Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932937Ab2EWB7y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 21:59:54 -0400
Received: from mga14.intel.com ([143.182.124.37]:8909 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139Ab2EWB7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 21:59:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="146542324"
Message-ID: <4FBC444A.6060500@intel.com>
Date: Wed, 23 May 2012 09:58:34 +0800
From: ShuoX Liu <shuox.liu@intel.com>
Reply-To: shuox.liu@intel.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: andi@firstfloor.org, Andrew Morton <akpm@linux-foundation.org>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>
Subject: [PATCH] printk: ignore recursion_bug flag when MCE in progress
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ShuoX Liu <shuox.liu@intel.com>

When MCE happens in printk, we ignore recursion_bug to make sure
some MCE logs printed out. Re-use mce_entry variable.

Signed-off-by: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Signed-off-by: ShuoX Liu <shuox.liu@intel.com>
---
I found mce_entry was introduced by commit 553f265f, but it's not
used now. Why not removed?
---
 arch/x86/include/asm/mce.h       |    2 --
 arch/x86/kernel/cpu/mcheck/mce.c |    2 --
 include/linux/kernel.h           |    1 +
 kernel/printk.c                  |    4 +++-
 4 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 441520e..aeda4cc 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -187,8 +187,6 @@ int mce_available(struct cpuinfo_x86 *c);
 DECLARE_PER_CPU(unsigned, mce_exception_count);
 DECLARE_PER_CPU(unsigned, mce_poll_count);
 
-extern atomic_t mce_entry;
-
 typedef DECLARE_BITMAP(mce_banks_t, MAX_NR_BANKS);
 DECLARE_PER_CPU(mce_banks_t, mce_poll_banks);
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 11c9166..6073354 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -61,8 +61,6 @@ int mce_disabled __read_mostly;
 
 #define SPINUNIT 100	/* 100ns */
 
-atomic_t mce_entry;
-
 DEFINE_PER_CPU(unsigned, mce_exception_count);
 
 /*
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 645231c..24af685 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -354,6 +354,7 @@ unsigned long int_sqrt(unsigned long);
 extern void bust_spinlocks(int yes);
 extern void wake_up_klogd(void);
 extern int oops_in_progress;		/* If set, an oops, panic(), BUG() or die() is in progress */
+extern atomic_t mce_entry;
 extern int panic_timeout;
 extern int panic_on_oops;
 extern int panic_on_unrecovered_nmi;
diff --git a/kernel/printk.c b/kernel/printk.c
index 473afdb..2bae087 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -79,6 +79,7 @@ int console_printk[4] = {
 int oops_in_progress;
 EXPORT_SYMBOL(oops_in_progress);
 
+atomic_t mce_entry;
 /*
  * console_sem protects the console_drivers list, and also
  * provides serialisation for access to the entire console
@@ -864,7 +865,8 @@ asmlinkage int vprintk(const char *fmt, va_list args)
 		 * recursion and return - but flag the recursion so that
 		 * it can be printed at the next appropriate moment:
 		 */
-		if (!oops_in_progress && !lockdep_recursing(current)) {
+		if (!oops_in_progress && !atomic_read(&mce_entry)
+				&& !lockdep_recursing(current)) {
 			recursion_bug = 1;
 			goto out_restore_irqs;
 		}
-- 
1.7.1
