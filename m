Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427Ab0KJXaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 18:30:17 -0500
Received: from mx1.vsecurity.com ([209.67.252.12]:57341 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757379Ab0KJXaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 18:30:16 -0500
Subject: [PATCH v3] Restrict unprivileged access to kernel syslog
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, mingo@elte.hu, kees.cook@canonical.com,
        akpm@linux-foundation.org, security@kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Nov 2010 18:28:55 -0500
Message-ID: <1289431735.3847.9.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel syslog contains debugging information that is often useful
during exploitation of other vulnerabilities, such as kernel heap
addresses.  Rather than futilely attempt to sanitize hundreds (or
thousands) of printk statements and simultaneously cripple useful
debugging functionality, it is far simpler to create an option that
prevents unprivileged users from reading the syslog.

This patch, loosely based on grsecurity's GRKERNSEC_DMESG, creates the
dmesg_restrict sysctl.  When set to "0", the default, no restrictions
are enforced.  When set to "1", only users with CAP_SYS_ADMIN can read
the kernel syslog via dmesg(8) or other mechanisms.

v3 sets a default for the config, renames to
CONFIG_SECURITY_DMESG_RESTRICT to be consistent with the sysctl name,
and adds Acks.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
Acked-by: Eugene Teo <eugeneteo@kernel.org>
Acked-by: Kees Cook <kees.cook@canonical.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: stable <stable@kernel.org>
---
 Documentation/sysctl/kernel.txt |   11 +++++++++++
 include/linux/kernel.h          |    1 +
 kernel/printk.c                 |    6 ++++++
 kernel/sysctl.c                 |    9 +++++++++
 security/Kconfig                |   12 ++++++++++++
 security/commoncap.c            |    2 ++
 6 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index 3894eaa..c6bac30 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -28,6 +28,7 @@ show up in /proc/sys/kernel:
 - core_uses_pid
 - ctrl-alt-del
 - dentry-state
+- dmesg_restrict
 - domainname
 - hostname
 - hotplug
@@ -213,6 +214,16 @@ to decide what to do with it.
 
 ==============================================================
 
+dmesg_restrict:
+
+This toggle indicates whether unprivileged users are prevented 
+from using dmesg(8) to view messages from the kernel's log
+buffer.  By default, it is set to (0), resulting in no 
+restrictions.  When set to (1), users must have CAP_SYS_ADMIN
+to use dmesg(8).
+
+==============================================================
+
 domainname & hostname:
 
 These files can be used to set the NIS/YP domainname and the
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 450092c..f0d0088 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -293,6 +293,7 @@ extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
 				   unsigned int interval_msec);
 
 extern int printk_delay_msec;
+extern int dmesg_restrict;
 
 /*
  * Print a one-time message (analogous to WARN_ONCE() et al):
diff --git a/kernel/printk.c b/kernel/printk.c
index b2ebaee..38e7d58 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -261,6 +261,12 @@ static inline void boot_delay_msec(void)
 }
 #endif
 
+#ifdef CONFIG_SECURITY_DMESG_RESTRICT
+int dmesg_restrict = 1;
+#else
+int dmesg_restrict;
+#endif
+
 int do_syslog(int type, char __user *buf, int len, bool from_file)
 {
 	unsigned i, j, limit, count;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index c33a1ed..b65bf63 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -704,6 +704,15 @@ static struct ctl_table kern_table[] = {
 	},
 #endif
 	{
+		.procname	= "dmesg_restrict",
+		.data		= &dmesg_restrict,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= &one,
+	},
+	{
 		.procname	= "ngroups_max",
 		.data		= &ngroups_max,
 		.maxlen		= sizeof (int),
diff --git a/security/Kconfig b/security/Kconfig
index bd72ae6..ffb2493 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -39,6 +39,18 @@ config KEYS_DEBUG_PROC_KEYS
 
 	  If you are unsure as to whether this is required, answer N.
 
+config SECURITY_DMESG_RESTRICT
+	bool "Restrict unprivileged access to the kernel syslog"
+	default n
+	help
+	  This enforces restrictions on unprivileged users reading the kernel
+	  syslog via dmesg(8).
+
+	  If this option is not selected, no restrictions will be enforced 
+	  unless the dmesg_restrict sysctl is explicitly set to (1).
+
+	  If you are unsure how to answer this question, answer N.
+
 config SECURITY
 	bool "Enable different security models"
 	depends on SYSFS
diff --git a/security/commoncap.c b/security/commoncap.c
index 5e632b4..04b80f9 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -895,6 +895,8 @@ int cap_syslog(int type, bool from_file)
 {
 	if (type != SYSLOG_ACTION_OPEN && from_file)
 		return 0;
+	if (dmesg_restrict && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
 	if ((type != SYSLOG_ACTION_READ_ALL &&
 	     type != SYSLOG_ACTION_SIZE_BUFFER) && !capable(CAP_SYS_ADMIN))
 		return -EPERM;


