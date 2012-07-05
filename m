Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030193Ab2GEXPK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 19:15:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56057 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933414Ab2GEXPG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 19:15:06 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        Colin Cross <ccross@android.com>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        kernel-team@android.com, kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 2/6] kernel/debug: Mask KGDB NMI upon entry
Date: Thu,  5 Jul 2012 16:12:36 -0700
Message-Id: <1341529960-18370-2-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20120705231034.GA16931@lizard>
References: <20120705231034.GA16931@lizard>
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
 include/linux/kgdb.h      |    9 +++++++++
 kernel/debug/debug_core.c |   12 +++++++++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index c4d2fc1..47e739e 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -221,6 +221,15 @@ extern int kgdb_arch_remove_breakpoint(struct kgdb_bkpt *bpt);
  */
 extern void kgdb_arch_late(void);
 
+/**
+ *	kgdb_arch_enable_nmi - Enable or disable KGDB-entry NMI
+ *	@on: Flag to either enable or disable an NMI
+ *
+ *	This function manages NMIs that usually cause KGDB to enter. That is,
+ *	not all NMIs should be enabled or disabled, but only those that issue
+ *	kgdb_handle_exception().
+ */
+extern void kgdb_arch_enable_nmi(bool on);
 
 /**
  * struct kgdb_arch - Describe architecture specific values.
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 0557f24..e285600 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -214,6 +214,10 @@ int __weak kgdb_skipexception(int exception, struct pt_regs *regs)
 	return 0;
 }
 
+void __weak kgdb_arch_enable_nmi(bool on)
+{
+}
+
 /*
  * Some architectures need cache flushes when we set/clear a
  * breakpoint:
@@ -672,6 +676,9 @@ kgdb_handle_exception(int evector, int signo, int ecode, struct pt_regs *regs)
 {
 	struct kgdb_state kgdb_var;
 	struct kgdb_state *ks = &kgdb_var;
+	int ret;
+
+	kgdb_arch_enable_nmi(0);
 
 	ks->cpu			= raw_smp_processor_id();
 	ks->ex_vector		= evector;
@@ -685,7 +692,10 @@ kgdb_handle_exception(int evector, int signo, int ecode, struct pt_regs *regs)
 	if (kgdb_info[ks->cpu].enter_kgdb != 0)
 		return 0;
 
-	return kgdb_cpu_enter(ks, regs, DCPU_WANT_MASTER);
+	ret = kgdb_cpu_enter(ks, regs, DCPU_WANT_MASTER);
+
+	kgdb_arch_enable_nmi(1);
+	return ret;
 }
 
 int kgdb_nmicallback(int cpu, void *regs)
-- 
1.7.10.4

