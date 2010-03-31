Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933049Ab0CaC01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 22:26:27 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:23832 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932483Ab0CaCVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 22:21:34 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 01/33] x86: Make e820_remove_range() to handle all covered case
Date: Tue, 30 Mar 2010 19:16:46 -0700
Message-Id: <1270001838-15857-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1270001838-15857-1-git-send-email-yinghai@kernel.org>
References: <1270001838-15857-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4BB2B11D.00F8,ss=1,fgs=0
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
 1 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 740b440..7bca3c6 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -519,29 +519,45 @@ u64 __init e820_remove_range(u64 start, u64 size, unsigned old_type,
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
-- 
1.6.4.2

