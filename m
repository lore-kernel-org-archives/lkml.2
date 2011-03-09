Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361Ab1CIPkm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 10:40:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:50275 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932129Ab1CIPki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 10:40:38 -0500
Date: Wed, 9 Mar 2011 15:40:21 GMT
From: tip-bot for Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        stable@kernel.org, nagananda.chumbalkar@hp.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, nagananda.chumbalkar@hp.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20110225202838.2229.71011.sendpatchset@nchumbalkar.americas.hpqcorp.net>
References: <20110225202838.2229.71011.sendpatchset@nchumbalkar.americas.hpqcorp.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Don't check for BIOS corruption in first 64K when there's no need to
Message-ID: <tip-a7bd1dafdcc13ec7add4aafc927eb5e3a8d597e6@git.kernel.org>
Git-Commit-ID: a7bd1dafdcc13ec7add4aafc927eb5e3a8d597e6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 09 Mar 2011 15:40:22 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a7bd1dafdcc13ec7add4aafc927eb5e3a8d597e6
Gitweb:     http://git.kernel.org/tip/a7bd1dafdcc13ec7add4aafc927eb5e3a8d597e6
Author:     Naga Chumbalkar <nagananda.chumbalkar@hp.com>
AuthorDate: Fri, 25 Feb 2011 20:31:55 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Mar 2011 16:36:41 +0100

x86: Don't check for BIOS corruption in first 64K when there's no need to

Due to commit 781c5a67f152c17c3e4a9ed9647f8c0be6ea5ae9 it is
likely that the number of areas to scan for BIOS corruption is 0
 -- especially when the first 64K is already reserved
(X86_RESERVE_LOW is 64K by default).

If that's the case then don't set up the scan.

Signed-off-by: Naga Chumbalkar <nagananda.chumbalkar@hp.com>
Cc: <stable@kernel.org>
LKML-Reference: <20110225202838.2229.71011.sendpatchset@nchumbalkar.americas.hpqcorp.net>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/check.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/check.c b/arch/x86/kernel/check.c
index 13a3891..452932d 100644
--- a/arch/x86/kernel/check.c
+++ b/arch/x86/kernel/check.c
@@ -106,8 +106,8 @@ void __init setup_bios_corruption_check(void)
 		addr += size;
 	}
 
-	printk(KERN_INFO "Scanning %d areas for low memory corruption\n",
-	       num_scan_areas);
+	if (num_scan_areas)
+		printk(KERN_INFO "Scanning %d areas for low memory corruption\n", num_scan_areas);
 }
 
 
@@ -143,12 +143,12 @@ static void check_corruption(struct work_struct *dummy)
 {
 	check_for_bios_corruption();
 	schedule_delayed_work(&bios_check_work,
-		round_jiffies_relative(corruption_check_period*HZ)); 
+		round_jiffies_relative(corruption_check_period*HZ));
 }
 
 static int start_periodic_check_for_corruption(void)
 {
-	if (!memory_corruption_check || corruption_check_period == 0)
+	if (!num_scan_areas || !memory_corruption_check || corruption_check_period == 0)
 		return 0;
 
 	printk(KERN_INFO "Scanning for low memory corruption every %d seconds\n",
