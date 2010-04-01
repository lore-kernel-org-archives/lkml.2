Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186Ab0DABBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 21:01:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:56689 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758127Ab0DABBT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 21:01:19 -0400
Date: Thu, 1 Apr 2010 01:00:58 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, rusty@rustcorp.com.au, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, rusty@rustcorp.com.au, tglx@linutronix.de
In-Reply-To: <4BB18E55.6090903@kernel.org>
References: <4BB18E55.6090903@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Make e820_remove_range to handle all covered case
Message-ID: <tip-9f3a5f52aa63d3aa4c64a7245153549bb66bad8c@git.kernel.org>
Git-Commit-ID: 9f3a5f52aa63d3aa4c64a7245153549bb66bad8c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 01 Apr 2010 01:00:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9f3a5f52aa63d3aa4c64a7245153549bb66bad8c
Gitweb:     http://git.kernel.org/tip/9f3a5f52aa63d3aa4c64a7245153549bb66bad8c
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Mon, 29 Mar 2010 22:38:29 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 31 Mar 2010 17:40:57 -0700

x86: Make e820_remove_range to handle all covered case

Rusty found on lguest with trim_bios_range, max_pfn is not right anymore, and
looks e820_remove_range does not work right.

[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  LGUEST: 0000000000000000 - 0000000004000000 (usable)
[    0.000000] Notice: NX (Execute Disable) protection missing in CPU or disabled in BIOS!
[    0.000000] DMI not present or invalid.
[    0.000000] last_pfn = 0x3fa0 max_arch_pfn = 0x100000
[    0.000000] init_memory_mapping: 0000000000000000-0000000003fa0000

root cause is: the e820_remove_range doesn't handle the all covered
case.  e820_remove_range(BIOS_START, BIOS_END - BIOS_START, ...)
produces a bogus range as a result.

Make it match e820_update_range() by handling that case too.

Reported-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Tested-by: Rusty Russell <rusty@rustcorp.com.au>
LKML-Reference: <4BB18E55.6090903@kernel.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
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
