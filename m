Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933347Ab2HXWRS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 18:17:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40034 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760204Ab2HXWRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 18:17:14 -0400
Date: Fri, 24 Aug 2012 15:16:59 -0700
From: tip-bot for Suresh Siddha <suresh.b.siddha@intel.com>
Message-ID: <tip-1ce83ffda9aea53e6e4b6b6a82c028a019526010@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, suresh.b.siddha@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, suresh.b.siddha@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1345842782-24175-6-git-send-email-suresh.b.siddha@intel.com>
References: <1345842782-24175-6-git-send-email-suresh.b.siddha@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fpu] lguest, x86: handle guest TS bit for lazy/
 non-lazy fpu host models
Git-Commit-ID: 1ce83ffda9aea53e6e4b6b6a82c028a019526010
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 24 Aug 2012 15:17:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1ce83ffda9aea53e6e4b6b6a82c028a019526010
Gitweb:     http://git.kernel.org/tip/1ce83ffda9aea53e6e4b6b6a82c028a019526010
Author:     Suresh Siddha <suresh.b.siddha@intel.com>
AuthorDate: Fri, 24 Aug 2012 14:13:01 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 24 Aug 2012 14:26:52 -0700

lguest, x86: handle guest TS bit for lazy/non-lazy fpu host models

Instead of using unlazy_fpu() check if user_has_fpu() and set/clear
the host TS bits so that the lguest works fine with both the
lazy/non-lazy FPU host models with minimal changes.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/r/1345842782-24175-6-git-send-email-suresh.b.siddha@intel.com
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 drivers/lguest/x86/core.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/lguest/x86/core.c b/drivers/lguest/x86/core.c
index 39809035..4af12e1 100644
--- a/drivers/lguest/x86/core.c
+++ b/drivers/lguest/x86/core.c
@@ -203,8 +203,8 @@ void lguest_arch_run_guest(struct lg_cpu *cpu)
 	 * we set it now, so we can trap and pass that trap to the Guest if it
 	 * uses the FPU.
 	 */
-	if (cpu->ts)
-		unlazy_fpu(current);
+	if (cpu->ts && user_has_fpu())
+		stts();
 
 	/*
 	 * SYSENTER is an optimized way of doing system calls.  We can't allow
@@ -234,6 +234,10 @@ void lguest_arch_run_guest(struct lg_cpu *cpu)
 	 if (boot_cpu_has(X86_FEATURE_SEP))
 		wrmsr(MSR_IA32_SYSENTER_CS, __KERNEL_CS, 0);
 
+	/* Clear the host TS bit if it was set above. */
+	if (cpu->ts && user_has_fpu())
+		clts();
+
 	/*
 	 * If the Guest page faulted, then the cr2 register will tell us the
 	 * bad virtual address.  We have to grab this now, because once we
@@ -249,7 +253,7 @@ void lguest_arch_run_guest(struct lg_cpu *cpu)
 	 * a different CPU. So all the critical stuff should be done
 	 * before this.
 	 */
-	else if (cpu->regs->trapnum == 7)
+	else if (cpu->regs->trapnum == 7 && !user_has_fpu())
 		math_state_restore();
 }
 
