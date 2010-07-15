Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074Ab0GOAoy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 20:44:54 -0400
Received: from adelie.canonical.com ([91.189.90.139]:57329 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932075Ab0GOAob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 20:44:31 -0400
From: John Johansen <john.johansen@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org
Subject: [PATCH 12/13] AppArmor: Enable configuring and building of the AppArmor security module
Date: Wed, 14 Jul 2010 17:43:40 -0700
Message-Id: <1279154621-25868-13-git-send-email-john.johansen@canonical.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1279154621-25868-1-git-send-email-john.johansen@canonical.com>
References: <1279154621-25868-1-git-send-email-john.johansen@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kconfig and Makefiles to enable configuration and building of AppArmor.

Signed-off-by: John Johansen <john.johansen@canonical.com>
---
 security/Kconfig             |    6 ++++++
 security/Makefile            |    2 ++
 security/apparmor/.gitignore |    5 +++++
 security/apparmor/Kconfig    |   31 +++++++++++++++++++++++++++++++
 security/apparmor/Makefile   |   24 ++++++++++++++++++++++++
 5 files changed, 68 insertions(+), 0 deletions(-)
 create mode 100644 security/apparmor/.gitignore
 create mode 100644 security/apparmor/Kconfig
 create mode 100644 security/apparmor/Makefile

diff --git a/security/Kconfig b/security/Kconfig
index 226b955..bd72ae6 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -140,6 +140,7 @@ config LSM_MMAP_MIN_ADDR
 source security/selinux/Kconfig
 source security/smack/Kconfig
 source security/tomoyo/Kconfig
+source security/apparmor/Kconfig
 
 source security/integrity/ima/Kconfig
 
@@ -148,6 +149,7 @@ choice
 	default DEFAULT_SECURITY_SELINUX if SECURITY_SELINUX
 	default DEFAULT_SECURITY_SMACK if SECURITY_SMACK
 	default DEFAULT_SECURITY_TOMOYO if SECURITY_TOMOYO
+	default DEFAULT_SECURITY_APPARMOR if SECURITY_APPARMOR
 	default DEFAULT_SECURITY_DAC
 
 	help
@@ -163,6 +165,9 @@ choice
 	config DEFAULT_SECURITY_TOMOYO
 		bool "TOMOYO" if SECURITY_TOMOYO=y
 
+	config DEFAULT_SECURITY_APPARMOR
+		bool "AppArmor" if SECURITY_APPARMOR=y
+
 	config DEFAULT_SECURITY_DAC
 		bool "Unix Discretionary Access Controls"
 
@@ -173,6 +178,7 @@ config DEFAULT_SECURITY
 	default "selinux" if DEFAULT_SECURITY_SELINUX
 	default "smack" if DEFAULT_SECURITY_SMACK
 	default "tomoyo" if DEFAULT_SECURITY_TOMOYO
+	default "apparmor" if DEFAULT_SECURITY_APPARMOR
 	default "" if DEFAULT_SECURITY_DAC
 
 endmenu
diff --git a/security/Makefile b/security/Makefile
index da20a19..8bb0fe9 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -6,6 +6,7 @@ obj-$(CONFIG_KEYS)			+= keys/
 subdir-$(CONFIG_SECURITY_SELINUX)	+= selinux
 subdir-$(CONFIG_SECURITY_SMACK)		+= smack
 subdir-$(CONFIG_SECURITY_TOMOYO)        += tomoyo
+subdir-$(CONFIG_SECURITY_APPARMOR)	+= apparmor
 
 # always enable default capabilities
 obj-y					+= commoncap.o
@@ -19,6 +20,7 @@ obj-$(CONFIG_SECURITY_SELINUX)		+= selinux/built-in.o
 obj-$(CONFIG_SECURITY_SMACK)		+= smack/built-in.o
 obj-$(CONFIG_AUDIT)			+= lsm_audit.o
 obj-$(CONFIG_SECURITY_TOMOYO)		+= tomoyo/built-in.o
+obj-$(CONFIG_SECURITY_APPARMOR)		+= apparmor/built-in.o
 obj-$(CONFIG_CGROUP_DEVICE)		+= device_cgroup.o
 
 # Object integrity file lists
diff --git a/security/apparmor/.gitignore b/security/apparmor/.gitignore
new file mode 100644
index 0000000..0a0a99f
--- /dev/null
+++ b/security/apparmor/.gitignore
@@ -0,0 +1,5 @@
+#
+# Generated include files
+#
+af_names.h
+capability_names.h
diff --git a/security/apparmor/Kconfig b/security/apparmor/Kconfig
new file mode 100644
index 0000000..c054cf7
--- /dev/null
+++ b/security/apparmor/Kconfig
@@ -0,0 +1,31 @@
+config SECURITY_APPARMOR
+	bool "AppArmor support"
+	depends on SECURITY
+	select AUDIT
+	select SECURITY_PATH
+	select SECURITYFS
+	select SECURITY_NETWORK
+	default n
+	help
+	  This enables the AppArmor security module.
+	  Required userspace tools (if they are not included in your
+	  distribution) and further information may be found at
+	  <http://forge.novell.com/modules/xfmod/project/?apparmor>
+
+	  If you are unsure how to answer this question, answer N.
+
+config SECURITY_APPARMOR_BOOTPARAM_VALUE
+	int "AppArmor boot parameter default value"
+	depends on SECURITY_APPARMOR
+	range 0 1
+	default 1
+	help
+	  This option sets the default value for the kernel parameter
+	  'apparmor', which allows AppArmor to be enabled or disabled
+          at boot.  If this option is set to 0 (zero), the AppArmor
+	  kernel parameter will default to 0, disabling AppArmor at
+	  bootup.  If this option is set to 1 (one), the AppArmor
+	  kernel parameter will default to 1, enabling AppArmor at
+	  bootup.
+
+	  If you are unsure how to answer this question, answer 1.
diff --git a/security/apparmor/Makefile b/security/apparmor/Makefile
new file mode 100644
index 0000000..f204869
--- /dev/null
+++ b/security/apparmor/Makefile
@@ -0,0 +1,24 @@
+# Makefile for AppArmor Linux Security Module
+#
+obj-$(CONFIG_SECURITY_APPARMOR) += apparmor.o
+
+apparmor-y := apparmorfs.o audit.o capability.o context.o ipc.o lib.o match.o \
+              path.o domain.o policy.o policy_unpack.o procattr.o lsm.o \
+              resource.o sid.o file.o
+
+clean-files: capability_names.h af_names.h
+
+quiet_cmd_make-caps = GEN     $@
+cmd_make-caps = echo "static const char *capability_names[] = {" > $@ ; sed -n -e "/CAP_FS_MASK/d" -e "s/^\#define[ \\t]\\+CAP_\\([A-Z0-9_]\\+\\)[ \\t]\\+\\([0-9]\\+\\)\$$/[\\2]  = \"\\1\",/p" $< | tr A-Z a-z >> $@ ; echo "};" >> $@
+
+quiet_cmd_make-rlim = GEN     $@
+cmd_make-rlim = echo "static const char *rlim_names[] = {" > $@ ; sed -n --e "/AF_MAX/d" -e "s/^\# \\?define[ \\t]\\+RLIMIT_\\([A-Z0-9_]\\+\\)[ \\t]\\+\\([0-9]\\+\\)\\(.*\\)\$$/[\\2]  = \"\\1\",/p" $< | tr A-Z a-z >> $@ ; echo "};" >> $@ ; echo "static const int rlim_map[] = {" >> $@ ; sed -n -e "/AF_MAX/d" -e "s/^\# \\?define[ \\t]\\+\\(RLIMIT_[A-Z0-9_]\\+\\)[ \\t]\\+\\([0-9]\\+\\)\\(.*\\)\$$/\\1,/p" $< >> $@ ; echo "};" >> $@
+
+$(obj)/capability.o : $(obj)/capability_names.h
+$(obj)/resource.o : $(obj)/rlim_names.h
+$(obj)/capability_names.h : $(srctree)/include/linux/capability.h
+	$(call cmd,make-caps)
+$(obj)/af_names.h : $(srctree)/include/linux/socket.h
+	$(call cmd,make-af)
+$(obj)/rlim_names.h : $(srctree)/include/asm-generic/resource.h
+	$(call cmd,make-rlim)
-- 
1.7.0.4

