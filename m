Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab2IJEPe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 00:15:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40143 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177Ab2IJEPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 00:15:30 -0400
Date: Sun, 9 Sep 2012 21:12:57 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Wessel <jason.wessel@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>
Cc: Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>,
        Colin Cross <ccross@android.com>, Brian Swetland <swetland@google.com>,
        John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        kgdb-bugreport@lists.sourceforge.net, linux-serial@vger.kernel.org
Subject: [PATCH 03/14] kernel/debug: Mask KGDB NMI upon entry
Message-ID: <20120910041257.GC29537@lizard>
References: <20120910040802.GA1261@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120910040802.GA1261@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
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
 include/linux/kgdb.h      | 23 +++++++++++++++++++++++
 kernel/debug/debug_core.c | 36 +++++++++++++++++++++++++++++++++---
 2 files changed, 56 insertions(+), 3 deletions(-)

diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index c4d2fc1..3b111a6 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -221,6 +221,29 @@ extern int kgdb_arch_remove_breakpoint(struct kgdb_bkpt *bpt);
  */
 extern void kgdb_arch_late(void);
 
+/**
+ *	kgdb_arch_enable_nmi - Enable or disable KGDB-entry NMI
+ *	@on: Flag to either enable or disable an NMI
+ *
+ *	This is an architecture-specific "back-end" for kgdb_enable_nmi(). The
+ *	call does not count disable/enable requests, do not use it directly.
+ */
+extern void kgdb_arch_enable_nmi(bool on);
+
+/**
+ *	kgdb_enable_nmi - Enable or disable KGDB-entry NMI
+ *	@on: Flag to either enable or disable an NMI
+ *
+ *	This function manages NMIs that usually cause KGDB to enter. That is,
+ *	not all NMIs should be enabled or disabled, but only those that issue
+ *	kgdb_handle_exception().
+ *
+ *	The call counts disable requests, and thus allows to nest disables.
+ *	But trying to enable already enabled NMI is an error. The call returns
+ *	1 if NMI has been actually enabled after the call, and a value <= 0 if
+ *	it is still disabled.
+ */
+extern int kgdb_enable_nmi(bool on);
 
 /**
  * struct kgdb_arch - Describe architecture specific values.
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 0557f24..b621d1e 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -214,6 +214,30 @@ int __weak kgdb_skipexception(int exception, struct pt_regs *regs)
 	return 0;
 }
 
+void __weak kgdb_arch_enable_nmi(bool on)
+{
+}
+
+int kgdb_enable_nmi(bool on)
+{
+	static atomic_t cnt;
+	int ret;
+
+	ret = atomic_add_return(on ? 1 : -1, &cnt);
+	if (ret > 1 && on) {
+		/*
+		 * There should be only one instance that calls this function
+		 * in "enable, disable" order. All other users must call
+		 * disable first, then enable. If not, something is wrong.
+		 */
+		WARN_ON(1);
+		return 1;
+	}
+
+	kgdb_arch_enable_nmi(ret > 0);
+	return ret;
+}
+
 /*
  * Some architectures need cache flushes when we set/clear a
  * breakpoint:
@@ -672,6 +696,9 @@ kgdb_handle_exception(int evector, int signo, int ecode, struct pt_regs *regs)
 {
 	struct kgdb_state kgdb_var;
 	struct kgdb_state *ks = &kgdb_var;
+	int ret = 0;
+
+	kgdb_enable_nmi(0);
 
 	ks->cpu			= raw_smp_processor_id();
 	ks->ex_vector		= evector;
@@ -681,11 +708,14 @@ kgdb_handle_exception(int evector, int signo, int ecode, struct pt_regs *regs)
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
+	kgdb_enable_nmi(1);
+	return ret;
 }
 
 int kgdb_nmicallback(int cpu, void *regs)
-- 
1.7.11.5

