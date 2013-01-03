Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab3ACGsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 01:48:16 -0500
Received: from us01smtp2.synopsys.com ([198.182.44.80]:49339 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab3ACGsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 01:48:13 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
CC: <linux-kernel@vger.kernel.org>, <linux-ia64@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, <arnd@arndb.de>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Serge Hallyn" <serge.hallyn@canonical.com>
Subject: [RESEND PATCH] sysctl: Enable IA64 "ignore-unaligned-usertrap" to be used cross-arch
Date: Thu, 3 Jan 2013 12:17:33 +0530
Message-ID: <1357195653-998-2-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1357195653-998-1-git-send-email-vgupta@synopsys.com>
References: <50D2B75A.3000208@synopsys.com>
 <1357195653-998-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IA64 defines /proc/sys/kernel/ignore-unaligned-usertrap to control
verbosw warnings on unaligned access emaultion.

While the exact menchaincs (ignore/shout) are still arch specific, we
can make the sysctl usable by other arches.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
---
 arch/ia64/Kconfig |    1 +
 init/Kconfig      |    8 ++++++++
 kernel/sysctl.c   |    9 +++++++--
 3 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 3279646..5fb1064 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -40,6 +40,7 @@ config IA64
 	select ARCH_THREAD_INFO_ALLOCATOR
 	select ARCH_CLOCKSOURCE_DATA
 	select GENERIC_TIME_VSYSCALL_OLD
+	select SYSCTL_ARCH_UNALIGN_NO_WARN
 	select HAVE_MOD_ARCH_SPECIFIC
 	select MODULES_USE_ELF_RELA
 	default y
diff --git a/init/Kconfig b/init/Kconfig
index 7d30240..e188f9f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1232,6 +1232,14 @@ config SYSCTL_EXCEPTION_TRACE
 	help
 	  Enable support for /proc/sys/debug/exception-trace.
 
+config SYSCTL_ARCH_UNALIGN_NO_WARN
+	bool
+	help
+	  Enable support for /proc/sys/kernel/ignore-unaligned-usertrap
+	  Allows arch to define/use @no_unaligned_warning to possbly warn about
+	  unaligned access emulation going on under the hood.
+	  see arch/ia64/kernel/unaligned.c for reference
+
 config KALLSYMS
 	 bool "Load all symbols for debugging/ksymoops" if EXPERT
 	 default y
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c88878d..840fd5e 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -161,10 +161,13 @@ extern int unaligned_enabled;
 #endif
 
 #ifdef CONFIG_IA64
-extern int no_unaligned_warning;
 extern int unaligned_dump_stack;
 #endif
 
+#ifdef CONFIG_SYSCTL_ARCH_UNALIGN_NO_WARN
+extern int no_unaligned_warning;
+#endif
+
 #ifdef CONFIG_PROC_SYSCTL
 static int proc_do_cad_pid(struct ctl_table *table, int write,
 		  void __user *buffer, size_t *lenp, loff_t *ppos);
@@ -911,7 +914,7 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= proc_doulongvec_minmax,
 	},
 #endif
-#ifdef CONFIG_IA64
+#ifdef CONFIG_SYSCTL_ARCH_UNALIGN_NO_WARN
 	{
 		.procname	= "ignore-unaligned-usertrap",
 		.data		= &no_unaligned_warning,
@@ -919,6 +922,8 @@ static struct ctl_table kern_table[] = {
 	 	.mode		= 0644,
 		.proc_handler	= proc_dointvec,
 	},
+#endif
+#ifdef CONFIG_IA64
 	{
 		.procname	= "unaligned-dump-stack",
 		.data		= &unaligned_dump_stack,
-- 
1.7.4.1

