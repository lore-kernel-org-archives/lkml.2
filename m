Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789Ab1KAXwW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 19:52:22 -0400
Received: from smtp-out.google.com ([216.239.44.51]:52350 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932681Ab1KAXwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 19:52:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:
	references:in-reply-to:references:organization;
	b=DIhx0uvDFLkmcpsKI8fSH5rnIX4B5ZIzJn/CJ+aQ8EdR8ovNpvFKy1p95DjDHCQ55
	36rqQmteYWM0oAyyIULXQ==
From: David Decotigny <david.decotigny@google.com>
To: Randy Dunlap <rdunlap@xenotime.net>,
        Jason Wessel <jason.wessel@windriver.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Michal Schmidt <mschmidt@redhat.com>,
        Richard Kennedy <richard@rsk.demon.co.uk>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Dmitry Torokhov <dtor@vmware.com>, Kay Sievers <kay.sievers@vrfy.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Satoru Moriya <satoru.moriya@hds.com>,
        David Decotigny <decot@google.com>,
        David Decotigny <david.decotigny@google.com>
Subject: [PATCH v2 3/3] param: make /sys/module/*/paramaters optional
Date: Tue,  1 Nov 2011 16:50:35 -0700
Message-Id: <4cfeb61114204047567a77acf5895cb56b745460.1320191327.git.david.decotigny@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <cover.1320191327.git.david.decotigny@google.com>
References: <cover.1320191327.git.david.decotigny@google.com>
In-Reply-To: <cover.1320191327.git.david.decotigny@google.com>
References: <cover.1320191327.git.david.decotigny@google.com>
Organization: Google, Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Decotigny <decot@google.com>

With this patch, we allow systems that don't want to pay the price for
/sys/module/*/paramaters to be compiled without that feature. This
abiltity can in turn encourage module developers to expose more of
their parameters with fewer hesitations (eg. memory concerns, etc.);
this is desirable to help debugging/auditing of live (larger) systems.

The new knob to control that is CONFIG_SYSFS_MODULE_PARAM available in
Kconfig in expert mode: File systems / Pseudo filesystems / sysfs file
system support / Module parameters in sysfs. It is enabled by default,
keeping /sys/module/*/paramaters/ available as before.

As an illustration, on my copy I see 1658 module_param() macros with
perm == 0: most of these could be exposed to user (perm != 0).

Tested:
  - qemu + real x86_64 with defconfig customized:
      CONFIG_EXPERT=y
      CONFIG_SYSFS=y
      # CONFIG_SYSFS_MODULE_PARAM is not set
  - qemu + real x86_64 with defconfig
  - make all with allyesconfig / allnoconfig / allmodconfig



Signed-off-by: David Decotigny <david.decotigny@google.com>
---
 Documentation/ABI/stable/sysfs-module |    3 +++
 Documentation/DocBook/kgdb.tmpl       |    3 ++-
 fs/sysfs/Kconfig                      |   15 ++++++++++++++-
 include/linux/moduleparam.h           |    4 ++--
 kernel/params.c                       |    7 +++++++
 5 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-module b/Documentation/ABI/stable/sysfs-module
index 75be431..a733ad8 100644
--- a/Documentation/ABI/stable/sysfs-module
+++ b/Documentation/ABI/stable/sysfs-module
@@ -15,6 +15,9 @@ Description:
 		documentation as to the contents of these parameters and
 		what they accomplish.
 
+		This directory is available only when
+		CONFIG_SYSFS_MODULE_PARAM is set (default).
+
 		Note: The individual parameter names and values are not
 		considered stable, only the fact that they will be
 		placed in this location within sysfs.  See the
diff --git a/Documentation/DocBook/kgdb.tmpl b/Documentation/DocBook/kgdb.tmpl
index d71b57f..68a1d23 100644
--- a/Documentation/DocBook/kgdb.tmpl
+++ b/Documentation/DocBook/kgdb.tmpl
@@ -474,7 +474,8 @@
    a kgdb I/O driver, kgdb will unregister all the kernel hook points.
    </para>
    <para> All kgdb I/O drivers can be reconfigured at run time, if
-   <symbol>CONFIG_SYSFS</symbol> and <symbol>CONFIG_MODULES</symbol>
+   <symbol>CONFIG_SYSFS</symbol>, <symbol>CONFIG_MODULES</symbol> and
+   <symbol>CONFIG_SYSFS_MODULE_PARAM</symbol>
    are enabled, by echo'ing a new config string to
    <constant>/sys/module/&lt;driver&gt;/parameter/&lt;option&gt;</constant>.
    The driver can be unconfigured by passing an empty string.  You cannot
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

