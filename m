Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423Ab0KMUBK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 15:01:10 -0500
Received: from mail.perches.com ([173.55.12.10]:1097 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755316Ab0KMUBH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 15:01:07 -0500
Subject: Re: [PATCH] Fix dmesg_restrict build failure with
 CONFIG_EMBEDDED=y and CONFIG_PRINTK=n
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Eugene Teo <eugeneteo@kernel.org>, Kees Cook <kees.cook@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1289677904.16461.82.camel@Joe-Laptop>
References: <1289669176.16461.12.camel@Joe-Laptop>
	 <AANLkTi=ut2O+mCbs1jOyg-aP=E+48h1B-MH8NxK5XyVf@mail.gmail.com>
	 <1289677904.16461.82.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Nov 2010 12:01:05 -0800
Message-ID: <1289678465.16461.85.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maybe something like this is better?

Remove dmesg_restrict from kernel.h printk.c
Move dmesg_restrict to security/commoncap.c
Add extern int dmesg_restrict to kernel/sysctl.c
Use CONFIG_SECURITY_DMESG_RESTRICT as variable guard

uncompiled/untested.

---
 include/linux/kernel.h |    1 -
 kernel/printk.c        |    6 ------
 kernel/sysctl.c        |    6 ++++++
 security/Kconfig       |    1 +
 security/commoncap.c   |    8 ++++++++
 5 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index fc3da9e..b526947 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -293,7 +293,6 @@ extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
 				   unsigned int interval_msec);
 
 extern int printk_delay_msec;
-extern int dmesg_restrict;
 
 /*
  * Print a one-time message (analogous to WARN_ONCE() et al):
diff --git a/kernel/printk.c b/kernel/printk.c
index 38e7d58..b2ebaee 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -261,12 +261,6 @@ static inline void boot_delay_msec(void)
 }
 #endif
 
-#ifdef CONFIG_SECURITY_DMESG_RESTRICT
-int dmesg_restrict = 1;
-#else
-int dmesg_restrict;
-#endif
-
 int do_syslog(int type, char __user *buf, int len, bool from_file)
 {
 	unsigned i, j, limit, count;
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index b65bf63..f8ba761 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -106,6 +106,10 @@ extern int sysctl_nr_trim_pages;
 #ifdef CONFIG_BLOCK
 extern int blk_iopoll_enabled;
 #endif
+#ifdef CONFIG_SECURITY_DMESG_RESTRICT
+extern int dmesg_restrict;
+#endif
+
 
 /* Constants used for minimum and  maximum */
 #ifdef CONFIG_LOCKUP_DETECTOR
@@ -703,6 +707,7 @@ static struct ctl_table kern_table[] = {
 		.extra2		= &ten_thousand,
 	},
 #endif
+#ifdef CONFIG_SECURITY_DMESG_RESTRICT
 	{
 		.procname	= "dmesg_restrict",
 		.data		= &dmesg_restrict,
@@ -712,6 +717,7 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
+#endif
 	{
 		.procname	= "ngroups_max",
 		.data		= &ngroups_max,
diff --git a/security/Kconfig b/security/Kconfig
index e80da95..c6583d6 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -41,6 +41,7 @@ config KEYS_DEBUG_PROC_KEYS
 
 config SECURITY_DMESG_RESTRICT
 	bool "Restrict unprivileged access to the kernel syslog"
+	depends on SECURITY
 	default n
 	help
 	  This enforces restrictions on unprivileged users reading the kernel
diff --git a/security/commoncap.c b/security/commoncap.c
index 04b80f9..08066df 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -883,6 +883,12 @@ error:
 	return error;
 }
 
+#ifdef CONFIG_SECURITY_DMESG_RESTRICT
+int dmesg_restrict = 1;
+#else
+int dmesg_restrict;
+#endif
+
 /**
  * cap_syslog - Determine whether syslog function is permitted
  * @type: Function requested
@@ -895,8 +901,10 @@ int cap_syslog(int type, bool from_file)
 {
 	if (type != SYSLOG_ACTION_OPEN && from_file)
 		return 0;
+#ifdef CONFIG_SECURITY_DMESG_RESTRICT
 	if (dmesg_restrict && !capable(CAP_SYS_ADMIN))
 		return -EPERM;
+#endif
 	if ((type != SYSLOG_ACTION_READ_ALL &&
 	     type != SYSLOG_ACTION_SIZE_BUFFER) && !capable(CAP_SYS_ADMIN))
 		return -EPERM;


