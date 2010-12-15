Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437Ab0LOWAV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 17:00:21 -0500
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:23681 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754391Ab0LOWAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 17:00:19 -0500
Date: Wed, 15 Dec 2010 14:00:19 -0800
From: Dmitry Torokhov <dtor@vmware.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH] Show version information for built-in modules in sysfs
Message-ID: <20101215220019.GA6560@dtor-ws.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently only drivers that are built as modules have their versions
shown in /sys/module/<module_name>/version, but this information might
also be useful for built-in drivers as well. This especially important
for drivers that do not define any parameters - such drivers, if
built-in, are completely invisible from userspace.

This patch changes MODULE_VERSION() macro so that in case when we are
compiling built-in module, version information is stored in a separate
section. Kernel then uses this data to create 'version' sysfs attribute
in the same fashion it creates attributes for module parameters.

Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
---

This change is driven by our desire to detect whether vmw_balloon driver
is built-in into the kernel when we installing our tool package in the
guest and avoid installing our own version of the driver.

Since vmw_balloon does not have any module parameter nor registers any
driver core devices, without this patch it is completely invisible from
userspace when built into the kernel.

Thanks,
Dmitry

 include/asm-generic/vmlinux.lds.h |    7 ++++
 include/linux/module.h            |   27 +++++++++++++++
 kernel/params.c                   |   65 ++++++++++++++++++++++++++++++------
 3 files changed, 88 insertions(+), 11 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index bd69d79..0d83dd1 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -355,6 +355,13 @@
 		VMLINUX_SYMBOL(__start___param) = .;			\
 		*(__param)						\
 		VMLINUX_SYMBOL(__stop___param) = .;			\
+	}								\
+									\
+	/* Built-in module versions. */					\
+	__modver : AT(ADDR(__modver) - LOAD_OFFSET) {			\
+		VMLINUX_SYMBOL(__start___modver) = .;			\
+		*(__modver)						\
+		VMLINUX_SYMBOL(__stop___modver) = .;			\
 		. = ALIGN((align));					\
 		VMLINUX_SYMBOL(__end_rodata) = .;			\
 	}								\
diff --git a/include/linux/module.h b/include/linux/module.h
index 7575bbb..f74ddda 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -58,6 +58,12 @@ struct module_attribute {
 	void (*free)(struct module *);
 };
 
+struct module_version_attribute {
+	struct module_attribute mattr;
+	const char *module_name;
+	const char *version;
+};
+
 struct module_kobject
 {
 	struct kobject kobj;
@@ -161,7 +167,28 @@ extern struct module __this_module;
   Using this automatically adds a checksum of the .c files and the
   local headers in "srcversion".
 */
+
+#ifdef MODULE
 #define MODULE_VERSION(_version) MODULE_INFO(version, _version)
+#else
+#define MODULE_VERSION(_version)					\
+	extern ssize_t __modver_version_show(struct module_attribute *,	\
+					     struct module *, char *);	\
+	static struct module_version_attribute __modver_version_attr	\
+	__used								\
+    __attribute__ ((unused,__section__ ("__modver"),aligned(sizeof(void *)))) \
+	= {								\
+		.mattr	= {						\
+			.attr	= {					\
+				.name	= "version",			\
+				.mode	= S_IRUGO,			\
+			},						\
+			.show	= __modver_version_show,		\
+		},							\
+		.module_name	= KBUILD_MODNAME,			\
+		.version	= _version,				\
+	}
+#endif
 
 /* Optional firmware file (or files) needed by the module
  * format is simply firmware file name.  Multiple firmware
diff --git a/kernel/params.c b/kernel/params.c
index 08107d1..0da1411 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -719,9 +719,7 @@ void destroy_params(const struct kernel_param *params, unsigned num)
 			params[i].ops->free(params[i].arg);
 }
 
-static void __init kernel_add_sysfs_param(const char *name,
-					  struct kernel_param *kparam,
-					  unsigned int name_skip)
+static struct module_kobject * __init locate_module_kobject(const char *name)
 {
 	struct module_kobject *mk;
 	struct kobject *kobj;
@@ -729,10 +727,7 @@ static void __init kernel_add_sysfs_param(const char *name,
 
 	kobj = kset_find_obj(module_kset, name);
 	if (kobj) {
-		/* We already have one.  Remove params so we can add more. */
 		mk = to_module_kobject(kobj);
-		/* We need to remove it before adding parameters. */
-		sysfs_remove_group(&mk->kobj, &mk->mp->grp);
 	} else {
 		mk = kzalloc(sizeof(struct module_kobject), GFP_KERNEL);
 		BUG_ON(!mk);
@@ -743,15 +738,36 @@ static void __init kernel_add_sysfs_param(const char *name,
 					   "%s", name);
 		if (err) {
 			kobject_put(&mk->kobj);
-			printk(KERN_ERR "Module '%s' failed add to sysfs, "
-			       "error number %d\n", name, err);
-			printk(KERN_ERR	"The system will be unstable now.\n");
-			return;
+			printk(KERN_ERR
+				"Module '%s' failed add to sysfs, error number %d\n",
+				name, err);
+			printk(KERN_ERR
+				"The system will be unstable now.\n");
+			return NULL;
 		}
-		/* So that exit path is even. */
+
+		/* So that we hold reference in both cases. */
 		kobject_get(&mk->kobj);
 	}
 
+	return mk;
+}
+
+static void __init kernel_add_sysfs_param(const char *name,
+					  struct kernel_param *kparam,
+					  unsigned int name_skip)
+{
+	struct module_kobject *mk;
+	int err;
+
+	mk = locate_module_kobject(name);
+	if (!mk)
+		return;
+
+	/* We need to remove old parameters before adding more. */
+	if (mk->mp)
+		sysfs_remove_group(&mk->kobj, &mk->mp->grp);
+
 	/* These should not fail at boot. */
 	err = add_sysfs_param(mk, kparam, kparam->name + name_skip);
 	BUG_ON(err);
@@ -796,6 +812,32 @@ static void __init param_sysfs_builtin(void)
 	}
 }
 
+ssize_t __modver_version_show(struct module_attribute *mattr,
+			      struct module *mod, char *buf)
+{
+	struct module_version_attribute *vattr =
+		container_of(mattr, struct module_version_attribute, mattr);
+
+	return sprintf(buf, "%s\n", vattr->version);
+}
+
+extern struct module_version_attribute __start___modver[], __stop___modver[];
+
+static void __init version_sysfs_builtin(void)
+{
+	const struct module_version_attribute *vattr;
+	struct module_kobject *mk;
+	int err;
+
+	for (vattr = __start___modver; vattr < __stop___modver; vattr++) {
+		mk = locate_module_kobject(vattr->module_name);
+		if (mk) {
+			err = sysfs_create_file(&mk->kobj, &vattr->mattr.attr);
+			kobject_uevent(&mk->kobj, KOBJ_ADD);
+			kobject_put(&mk->kobj);
+		}
+	}
+}
 
 /* module-related sysfs stuff */
 
@@ -875,6 +917,7 @@ static int __init param_sysfs_init(void)
 	}
 	module_sysfs_initialized = 1;
 
+	version_sysfs_builtin();
 	param_sysfs_builtin();
 
 	return 0;
-- 
1.7.3.2

