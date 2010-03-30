Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab0C3Fj5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 01:39:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:42917 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753990Ab0C3Fj4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 01:39:56 -0400
Message-ID: <4BB18E55.6090903@kernel.org>
Date: Mon, 29 Mar 2010 22:38:29 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] x86: Make e820_remove_range to handle all covered case
References: <201003301238.43620.rusty@rustcorp.com.au>
In-Reply-To: <201003301238.43620.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Rusty found on lguest with trim_bios_range, max_pfn is not right anymore, and
looks e820_remove_range does not work right.

[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  LGUEST: 0000000000000000 - 0000000004000000 (usable)
[    0.000000] Notice: NX (Execute Disable) protection missing in CPU or disabled in BIOS!
[    0.000000] DMI not present or invalid.
[    0.000000] last_pfn = 0x3fa0 max_arch_pfn = 0x100000
[    0.000000] init_memory_mapping: 0000000000000000-0000000003fa0000

root cause is: the e820_remove_range doesn't handle that all cover case.
e820_remove_range(BIOS_START, BIOS_END - BIOS_start, ,,)
get miss one left range.

Make that is corresponding to e820_update_range() to handle that case too.

Reported-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/e820.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -519,29 +519,45 @@ u64 __init e820_remove_range(u64 start,
 	printk(KERN_DEBUG "e820 remove range: %016Lx - %016Lx ",
 		       (unsigned long long) start,
 		       (unsigned long long) end);
-	e820_print_type(old_type);
+	if (checktype)
+		e820_print_type(old_type);
 	printk(KERN_CONT "\n");
 
 	for (i = 0; i < e820.nr_map; i++) {
 		struct e820entry *ei = &e820.map[i];
 		u64 final_start, final_end;
+		u64 ei_end;
 
 		if (checktype && ei->type != old_type)
 			continue;
+
+		ei_end = ei->addr + ei->size;
 		/* totally covered? */
-		if (ei->addr >= start &&
-		    (ei->addr + ei->size) <= (start + size)) {
+		if (ei->addr >= start && ei_end <= end) {
 			real_removed_size += ei->size;
 			memset(ei, 0, sizeof(struct e820entry));
 			continue;
 		}
+
+		/* new range is totally covered? */
+		if (ei->addr < start && ei_end > end) {
+			e820_add_region(end, ei_end - end, ei->type);
+			ei->size = start - ei->addr;
+			real_removed_size += size;
+			continue;
+		}
+
 		/* partially covered */
 		final_start = max(start, ei->addr);
-		final_end = min(start + size, ei->addr + ei->size);
+		final_end = min(end, ei_end);
 		if (final_start >= final_end)
 			continue;
 		real_removed_size += final_end - final_start;
 
+		/*
+		 * left range could be head or tail, so need to update
+		 * size at first.
+		 */
 		ei->size -= final_end - final_start;
 		if (ei->addr < final_start)
 			continue;
