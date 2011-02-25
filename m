Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932995Ab1BYUcK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 15:32:10 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:13954 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932968Ab1BYUcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 15:32:09 -0500
From: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
To: x86@kernel.org
Cc: Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Message-Id: <20110225202838.2229.71011.sendpatchset@nchumbalkar.americas.hpqcorp.net>
Subject: [PATCH]: x86: Don't check for BIOS corruption in first 64K when there's no need to
Date: Fri, 25 Feb 2011 20:31:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Due to commit 781c5a67f152c17c3e4a9ed9647f8c0be6ea5ae9 it is likely that
the number of areas to scan for BIOS corruption is 0 -- especially when
the first 64K is already reserved (X86_RESERVE_LOW is 64K by default).
If that's the case then don't set up the scan.

Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
---
 arch/x86/kernel/check.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/check.c b/arch/x86/kernel/check.c
index 13a3891..a9480e1 100644
--- a/arch/x86/kernel/check.c
+++ b/arch/x86/kernel/check.c
@@ -106,8 +106,9 @@ void __init setup_bios_corruption_check(void)
 		addr += size;
 	}
 
-	printk(KERN_INFO "Scanning %d areas for low memory corruption\n",
-	       num_scan_areas);
+	if (num_scan_areas)
+		printk(KERN_INFO "Scanning %d areas for low memory "
+		       "corruption\n", num_scan_areas);
 }
 
 
@@ -148,7 +149,8 @@ static void check_corruption(struct work_struct *dummy)
 
 static int start_periodic_check_for_corruption(void)
 {
-	if (!memory_corruption_check || corruption_check_period == 0)
+	if (!num_scan_areas || !memory_corruption_check ||
+	    corruption_check_period == 0)
 		return 0;
 
 	printk(KERN_INFO "Scanning for low memory corruption every %d seconds\n",
-- 
1.7.1.2

