Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056Ab2ISXpg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 19:45:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39585 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944Ab2ISXpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 19:45:34 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Colin Cross <ccross@android.com>, Brian Swetland <swetland@google.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        kgdb-bugreport@lists.sourceforge.net, linux-serial@vger.kernel.org
Subject: [PATCH 01/11] kernel/debug: Mask KGDB NMI upon entry
Date: Wed, 19 Sep 2012 16:41:52 -0700
Message-Id: <1348098122-11041-1-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.11.5
In-Reply-To: <20120919234003.GA24143@lizard>
References: <20120919234003.GA24143@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new arch callback should manage NMIs that usually cause KGDB to
enter. That is, not all NMIs should be enabled/disabled, but only
those that issue kgdb_handle_exception().

We must mask it as serial-line interrupt can be used as an NMI, so
if the original KGDB-entry cause was say a breakpoint, then every
input to KDB console will cause KGDB to reenter, which we don't want.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 include/linux/kgdb.h      |  3 +++
 kernel/debug/debug_core.c | 14 +++++++++++---
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index c4d2fc1..7800cce 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -240,6 +240,7 @@ extern void kgdb_arch_late(void);
  * hardware breakpoints.
  * @correct_hw_break: Allow an architecture to specify how to correct the
  * hardware debug registers.
+ * @enable_nmi: Manage NMI-triggered entry to KGDB
  */
 struct kgdb_arch {
 	unsigned char		gdb_bpt_instr[BREAK_INSTR_SIZE];
@@ -252,6 +253,8 @@ struct kgdb_arch {
 	void	(*disable_hw_break)(struct pt_regs *regs);
 	void	(*remove_all_hw_break)(void);
 	void	(*correct_hw_break)(void);
+
+	void	(*enable_nmi)(bool on);
 };
 
 /**
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 0557f24..17e073c 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -672,6 +672,10 @@ kgdb_handle_exception(int evector, int signo, int ecode, struct pt_regs *regs)
 {
 	struct kgdb_state kgdb_var;
 	struct kgdb_state *ks = &kgdb_var;
+	int ret = 0;
+
+	if (arch_kgdb_ops.enable_nmi)
+		arch_kgdb_ops.enable_nmi(0);
 
 	ks->cpu			= raw_smp_processor_id();
 	ks->ex_vector		= evector;
@@ -681,11 +685,15 @@ kgdb_handle_exception(int evector, int signo, int ecode, struct pt_regs *regs)
 	ks->linux_regs		= regs;
 
 	if (kgdb_reenter_check(ks))
-		return 0; /* Ouch, double exception ! */
+		goto out; /* Ouch, double exception ! */
 	if (kgdb_info[ks->cpu].enter_kgdb != 0)
-		return 0;
+		goto out;
 
-	return kgdb_cpu_enter(ks, regs, DCPU_WANT_MASTER);
+	ret = kgdb_cpu_enter(ks, regs, DCPU_WANT_MASTER);
+out:
+	if (arch_kgdb_ops.enable_nmi)
+		arch_kgdb_ops.enable_nmi(1);
+	return ret;
 }
 
 int kgdb_nmicallback(int cpu, void *regs)
-- 
1.7.11.5

