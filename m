Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab1J0CXX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 22:23:23 -0400
Received: from smtp-out.google.com ([74.125.121.67]:15226 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232Ab1J0CXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 22:23:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:
	references:in-reply-to:references:organization;
	b=dRqrAq1Cz/CpioyjoYCTEdNk24X2xU7/L9dt1DXoDzWqe+uEHRs5vnEd6//IL4Kkh
	Eas9mPnNvOX+Ic7MRqwAg==
From: David Decotigny <david.decotigny@google.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Randy Dunlap <rdunlap@xenotime.net>,
        Michal Schmidt <mschmidt@redhat.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        David Decotigny <david.decotigny@google.com>
Subject: [PATCH v1 3/3] param: allow to selectively enable /sys/module/MOD/paramaters nodes
Date: Wed, 26 Oct 2011 19:22:27 -0700
Message-Id: <d1eab40bc9015e24c2c455cf3142f7966daa827a.1319679966.git.david.decotigny@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <cover.1319679966.git.david.decotigny@google.com>
References: <cover.1319679966.git.david.decotigny@google.com>
In-Reply-To: <cover.1319679966.git.david.decotigny@google.com>
References: <cover.1319679966.git.david.decotigny@google.com>
Organization: Google, Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change defines CONFIG_SYSFS_MODULE_PARAM to prevent kernel module
parameters from being exposed to user. When unset, /sys/module/MOD is
populated as usual, except for the "parameters" sub-directory, which
is not created anymore.

Context: by default, when the module_param() attribute perm == 0, the
module attribute is not exposed to user in
/sys/module/*/parameters. Many module implementations use this
strategy, presumably to spare some memory. However, it can be
interesting to retrieve how kernel modules are configured at run-time
(debug, audit, etc.): it would be nice to see more modules have perm
!= 0 in order to expose their configuration pararemers to
user. Unfortunately, this doesn't play well with memory-constrained
systems that need sysfs but don't need this level of
introspection. This change allows to support both use cases.

Tested:
  - qemu + real x86_64 with defconfig customized:
      CONFIG_EXPERT=y
      CONFIG_SYSFS=y
      # CONFIG_SYSFS_MODULE_PARAM is not set
  - qemu + real x86_64 with defconfig
  - make all with allyesconfig / allnoconfig / allmodconfig

Signed-off-by: David Decotigny <david.decotigny@google.com>
---
 fs/sysfs/Kconfig            |   15 ++++++++++++++-
 include/linux/moduleparam.h |    4 ++--
 kernel/params.c             |    7 +++++++
 3 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/fs/sysfs/Kconfig b/fs/sysfs/Kconfig
index 8c41fea..22ac50c 100644
--- a/fs/sysfs/Kconfig
+++ b/fs/sysfs/Kconfig
@@ -1,4 +1,4 @@
-config SYSFS
+menuconfig SYSFS
 	bool "sysfs file system support" if EXPERT
 	default y
 	help
@@ -21,3 +21,16 @@ config SYSFS
 	example, "root=03:01" for /dev/hda1.
 
 	Designers of embedded systems may wish to say N here to conserve space.
+
+if SYSFS
+
+config SYSFS_MODULE_PARAM
+       bool "Module parameters in sysfs" if EXPERT
+       default y
+       help
+         Allow to enable/disable the availability of kernel module
+         parameters in /sys/module/[module_name]/parameters. When
+         unset, this will conserve some memory space. If unsure,
+         say Y.
+
+endif # SYSFS
diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 77d09f4..9c42200 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -213,7 +213,7 @@ __check_old_set_param(int (*oldset)(const char *, struct kernel_param *))
 		__kernel_param_unlock();		\
 	} while (0)
 
-#ifdef CONFIG_SYSFS
+#ifdef CONFIG_SYSFS_MODULE_PARAM
 extern void __kernel_param_lock(void);
 extern void __kernel_param_unlock(void);
 #else
@@ -400,7 +400,7 @@ extern int param_get_string(char *buffer, const struct kernel_param *kp);
 
 struct module;
 
-#if defined(CONFIG_SYSFS) && defined(CONFIG_MODULES)
+#if defined(CONFIG_SYSFS_MODULE_PARAM) && defined(CONFIG_MODULES)
 extern int module_param_sysfs_setup(struct module *mod,
 				    const struct kernel_param *kparam,
 				    unsigned int num_params);
diff --git a/kernel/params.c b/kernel/params.c
index b0e1668..7b2137a 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -558,6 +558,9 @@ static struct module_kobject * __init locate_module_kobject(const char *name)
 
 	return mk;
 }
+#endif /* CONFIG_SYSFS */
+
+#ifdef CONFIG_SYSFS_MODULE_PARAM
 
 #define to_param_attr(n) container_of(n, struct param_attribute, mattr)
 
@@ -805,7 +808,9 @@ static void __init param_sysfs_builtin(void)
 		kernel_add_sysfs_param(modname, kp, name_len);
 	}
 }
+#endif /* CONFIG_SYSFS_MODULE_PARAM */
 
+#ifdef CONFIG_SYSFS
 ssize_t __modver_version_show(struct module_attribute *mattr,
 			      struct module_kobject *mk, char *buf)
 {
@@ -915,7 +920,9 @@ static int __init param_sysfs_init(void)
 	module_sysfs_initialized = 1;
 
 	version_sysfs_builtin();
+#ifdef CONFIG_SYSFS_MODULE_PARAM
 	param_sysfs_builtin();
+#endif /* CONFIG_SYSFS_MODULE_PARAM */
 
 	return 0;
 }
-- 
1.7.3.1

