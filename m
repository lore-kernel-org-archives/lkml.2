Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab1LLR5W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 12:57:22 -0500
Received: from service87.mimecast.com ([91.220.42.44]:35001 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab1LLR5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 12:57:20 -0500
From: Pawel Moll <pawel.moll@arm.com>
To: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH 1/2] params: <level>_initcall-like kernel parameters
Date: Mon, 12 Dec 2011 17:57:06 +0000
Message-Id: <1323712627-17353-1-git-send-email-pawel.moll@arm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1323712401.2391.93.camel@hornet.cambridge.arm.com>
References: <1323712401.2391.93.camel@hornet.cambridge.arm.com>
X-OriginalArrivalTime: 12 Dec 2011 17:57:14.0703 (UTC) FILETIME=[7B017DF0:01CCB8F7]
X-MC-Unique: 111121217571602901
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by nfs id pBCHvY7V020792

This patch adds a set of macros that can be used to declare
kernel parameters to be parsed _before_ initcalls at a chosen
level are executed. Such parameters are marked using existing
"flags" field of the "kernel_param" structure.

Linker macro collating init calls had to be modified in order
to add additional symbols between levels that are later used
by the init code to split the calls into blocks.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 include/asm-generic/vmlinux.lds.h |   35 ++++++++------------
 include/linux/moduleparam.h       |   59 ++++++++++++++++++++++++++++----
 init/main.c                       |   66 +++++++++++++++++++++++++++++++++---
 kernel/module.c                   |    3 +-
 kernel/params.c                   |    9 ++++-
 5 files changed, 135 insertions(+), 37 deletions(-)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index b5e2e4c..c4ad0b1 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -615,30 +615,23 @@
 		*(.init.setup)						\
 		VMLINUX_SYMBOL(__setup_end) = .;
 
-#define INITCALLS							\
-	*(.initcallearly.init)						\
-	VMLINUX_SYMBOL(__early_initcall_end) = .;			\
-  	*(.initcall0.init)						\
-  	*(.initcall0s.init)						\
-  	*(.initcall1.init)						\
-  	*(.initcall1s.init)						\
-  	*(.initcall2.init)						\
-  	*(.initcall2s.init)						\
-  	*(.initcall3.init)						\
-  	*(.initcall3s.init)						\
-  	*(.initcall4.init)						\
-  	*(.initcall4s.init)						\
-  	*(.initcall5.init)						\
-  	*(.initcall5s.init)						\
-	*(.initcallrootfs.init)						\
-  	*(.initcall6.init)						\
-  	*(.initcall6s.init)						\
-  	*(.initcall7.init)						\
-  	*(.initcall7s.init)
+#define INIT_CALLS_LEVEL(level)						\
+		VMLINUX_SYMBOL(__initcall##level##_start) = .;		\
+		*(.initcall##level##.init)				\
+		*(.initcall##level##s.init)				\
 
 #define INIT_CALLS							\
 		VMLINUX_SYMBOL(__initcall_start) = .;			\
-		INITCALLS						\
+		*(.initcallearly.init)					\
+		INIT_CALLS_LEVEL(0)					\
+		INIT_CALLS_LEVEL(1)					\
+		INIT_CALLS_LEVEL(2)					\
+		INIT_CALLS_LEVEL(3)					\
+		INIT_CALLS_LEVEL(4)					\
+		INIT_CALLS_LEVEL(5)					\
+		INIT_CALLS_LEVEL(rootfs)				\
+		INIT_CALLS_LEVEL(6)					\
+		INIT_CALLS_LEVEL(7)					\
 		VMLINUX_SYMBOL(__initcall_end) = .;
 
 #define CON_INITCALL							\
diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 7939f63..7f4c9b5 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -48,7 +48,14 @@ struct kernel_param_ops {
 };
 
 /* Flag bits for kernel_param.flags */
-#define KPARAM_ISBOOL		2
+#define KPARAM_ISBOOL		(1 << 1)
+#define KPARAM_ISLEVEL		(1 << 2)
+#define KPARAM_LEVEL_SHIFT	3
+#define KPARAM_LEVEL_MASK	(7 << KPARAM_LEVEL_SHIFT)
+
+#define __kparam_isbool(arg)	(__same_type((arg), bool) ? KPARAM_ISBOOL : 0)
+#define __kparam_isboolp(arg)	(__same_type((arg), bool *) ? KPARAM_ISBOOL : 0)
+#define __kparam_level(level)	(KPARAM_ISLEVEL | (level) << KPARAM_LEVEL_SHIFT)
 
 struct kernel_param {
 	const char *name;
@@ -132,7 +139,42 @@ struct kparam_array
  */
 #define module_param_cb(name, ops, arg, perm)				      \
 	__module_param_call(MODULE_PARAM_PREFIX,			      \
-			    name, ops, arg, __same_type((arg), bool *), perm)
+			    name, ops, arg, __kparam_isboolp(arg), perm)
+
+/**
+ * <level>_param_cb - general callback for a module/cmdline parameter
+ *                    to be evaluated before certain initcall level
+ * @name: a valid C identifier which is the parameter name.
+ * @ops: the set & get operations for this parameter.
+ * @perm: visibility in sysfs.
+ *
+ * The ops can have NULL set or get functions.
+ */
+#define __level_param_cb(level, name, ops, arg, perm)			      \
+	__module_param_call(MODULE_PARAM_PREFIX,			      \
+			    name, ops, arg,				      \
+			    __kparam_isboolp(arg) | __kparam_level(level), perm)
+
+#define core_param_cb(name, ops, arg, perm)				      \
+	__level_param_cb(1, name, ops, arg, perm)
+
+#define postcore_param_cb(name, ops, arg, perm)				      \
+	__level_param_cb(2, name, ops, arg, perm)
+
+#define arch_param_cb(name, ops, arg, perm)				      \
+	__level_param_cb(3, name, ops, arg, perm)
+
+#define subsys_param_cb(name, ops, arg, perm)				      \
+	__level_param_cb(4, name, ops, arg, perm)
+
+#define fs_param_cb(name, ops, arg, perm)				      \
+	__level_param_cb(5, name, ops, arg, perm)
+
+#define device_param_cb(name, ops, arg, perm)				      \
+	__level_param_cb(6, name, ops, arg, perm)
+
+#define late_param_cb(name, ops, arg, perm)				      \
+	__level_param_cb(7, name, ops, arg, perm)
 
 /* On alpha, ia64 and ppc64 relocations to global data cannot go into
    read-only sections (which is part of respective UNIX ABI on these
@@ -146,7 +188,7 @@ struct kparam_array
 
 /* This is the fundamental function for registering boot/module
    parameters. */
-#define __module_param_call(prefix, name, ops, arg, isbool, perm)	\
+#define __module_param_call(prefix, name, ops, arg, flags, perm)	\
 	/* Default value instead of permissions? */			\
 	static int __param_perm_check_##name __attribute__((unused)) =	\
 	BUILD_BUG_ON_ZERO((perm) < 0 || (perm) > 0777 || ((perm) & 2))	\
@@ -155,8 +197,7 @@ struct kparam_array
 	static struct kernel_param __moduleparam_const __param_##name	\
 	__used								\
     __attribute__ ((unused,__section__ ("__param"),aligned(sizeof(void *)))) \
-	= { __param_str_##name, ops, perm, isbool ? KPARAM_ISBOOL : 0,	\
-	    { arg } }
+	= { __param_str_##name, ops, perm, flags, { arg } }
 
 /* Obsolete - use module_param_cb() */
 #define module_param_call(name, set, get, arg, perm)			\
@@ -164,7 +205,7 @@ struct kparam_array
 		 { (void *)set, (void *)get };				\
 	__module_param_call(MODULE_PARAM_PREFIX,			\
 			    name, &__param_ops_##name, arg,		\
-			    __same_type(arg, bool *),			\
+			    __kparam_isboolp(arg),			\
 			    (perm) + sizeof(__check_old_set_param(set))*0)
 
 /* We don't get oldget: it's often a new-style param_get_uint, etc. */
@@ -246,7 +287,7 @@ static inline void __kernel_param_unlock(void)
 #define core_param(name, var, type, perm)				\
 	param_check_##type(name, &(var));				\
 	__module_param_call("", name, &param_ops_##type,		\
-			    &var, __same_type(var, bool), perm)
+			    &var, __kparam_isbool(var), perm)
 #endif /* !MODULE */
 
 /**
@@ -292,6 +333,8 @@ extern int parse_args(const char *name,
 		      char *args,
 		      const struct kernel_param *params,
 		      unsigned num,
+		      u16 flags_mask,
+		      u16 flags,
 		      int (*unknown)(char *param, char *val));
 
 /* Called by module remove. */
@@ -402,7 +445,7 @@ extern int param_get_invbool(char *buffer, const struct kernel_param *kp);
 	__module_param_call(MODULE_PARAM_PREFIX, name,			\
 			    &param_array_ops,				\
 			    .arr = &__param_arr_##name,			\
-			    __same_type(array[0], bool), perm);		\
+			    __kparam_isbool(array[0]), perm);		\
 	__MODULE_PARM_TYPE(name, "array of " #type)
 
 extern struct kernel_param_ops param_array_ops;
diff --git a/init/main.c b/init/main.c
index 217ed23..a7838c8 100644
--- a/init/main.c
+++ b/init/main.c
@@ -407,7 +407,7 @@ static int __init do_early_param(char *param, char *val)
 
 void __init parse_early_options(char *cmdline)
 {
-	parse_args("early options", cmdline, NULL, 0, do_early_param);
+	parse_args("early options", cmdline, NULL, 0, 0, 0, do_early_param);
 }
 
 /* Arch code calls this early on, or if not, just before other parsing. */
@@ -511,7 +511,7 @@ asmlinkage void __init start_kernel(void)
 	parse_early_param();
 	parse_args("Booting kernel", static_command_line, __start___param,
 		   __stop___param - __start___param,
-		   &unknown_bootoption);
+		   KPARAM_ISLEVEL, 0, &unknown_bootoption);
 
 	jump_label_init();
 
@@ -708,16 +708,70 @@ int __init_or_module do_one_initcall(initcall_t fn)
 }
 
 
-extern initcall_t __initcall_start[], __initcall_end[], __early_initcall_end[];
+extern initcall_t __initcall_start[];
+extern initcall_t __initcall0_start[];
+extern initcall_t __initcall1_start[];
+extern initcall_t __initcall2_start[];
+extern initcall_t __initcall3_start[];
+extern initcall_t __initcall4_start[];
+extern initcall_t __initcall5_start[];
+extern initcall_t __initcall6_start[];
+extern initcall_t __initcall7_start[];
+extern initcall_t __initcall_end[];
+
+static initcall_t *initcall_levels[] __initdata = {
+	__initcall0_start,
+	__initcall1_start,
+	__initcall2_start,
+	__initcall3_start,
+	__initcall4_start,
+	__initcall5_start,
+	__initcall6_start,
+	__initcall7_start,
+	__initcall_end,
+};
+
+static char *initcall_level_names[] __initdata = {
+	"core parameters",
+	"postcore parameters",
+	"arch parameters",
+	"subsys parameters",
+	"fs parameters",
+	"device parameters",
+	"late parameters",
+};
+
+static int __init ignore_unknown_bootoption(char *param, char *val)
+{
+	return 0;
+}
 
-static void __init do_initcalls(void)
+static void __init do_initcall_level(int level)
 {
+	extern const struct kernel_param __start___param[], __stop___param[];
 	initcall_t *fn;
 
-	for (fn = __early_initcall_end; fn < __initcall_end; fn++)
+	strcpy(static_command_line, saved_command_line);
+	parse_args(initcall_level_names[level],
+			static_command_line, __start___param,
+			__stop___param - __start___param,
+			KPARAM_ISLEVEL | KPARAM_LEVEL_MASK,
+			__kparam_level(level),
+			ignore_unknown_bootoption);
+
+	for (fn = initcall_levels[level]; fn < initcall_levels[level + 1];
+			fn++)
 		do_one_initcall(*fn);
 }
 
+static void __init do_initcalls(void)
+{
+	int level;
+
+	for (level = 0; level < ARRAY_SIZE(initcall_levels) - 1; level++)
+		do_initcall_level(level);
+}
+
 /*
  * Ok, the machine is now initialized. None of the devices
  * have been touched yet, but the CPU subsystem is up and
@@ -741,7 +795,7 @@ static void __init do_pre_smp_initcalls(void)
 {
 	initcall_t *fn;
 
-	for (fn = __initcall_start; fn < __early_initcall_end; fn++)
+	for (fn = __initcall_start; fn < __initcall0_start; fn++)
 		do_one_initcall(*fn);
 }
 
diff --git a/kernel/module.c b/kernel/module.c
index 178333c..66d3e75 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2893,7 +2893,8 @@ static struct module *load_module(void __user *umod,
 	mutex_unlock(&module_mutex);
 
 	/* Module is ready to execute: parsing args may do that. */
-	err = parse_args(mod->name, mod->args, mod->kp, mod->num_kp, NULL);
+	err = parse_args(mod->name, mod->args, mod->kp, mod->num_kp,
+			 0, 0, NULL);
 	if (err < 0)
 		goto unlink;
 
diff --git a/kernel/params.c b/kernel/params.c
index 65aae11..ddde6a7 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -94,6 +94,8 @@ static int parse_one(char *param,
 		     char *val,
 		     const struct kernel_param *params,
 		     unsigned num_params,
+		     int flags_mask,
+		     int flags,
 		     int (*handle_unknown)(char *param, char *val))
 {
 	unsigned int i;
@@ -102,6 +104,8 @@ static int parse_one(char *param,
 	/* Find parameter */
 	for (i = 0; i < num_params; i++) {
 		if (parameq(param, params[i].name)) {
+			if ((params[i].flags & flags_mask) != flags)
+				return 0;
 			/* No one handled NULL, so do it here. */
 			if (!val && params[i].ops->set != param_set_bool)
 				return -EINVAL;
@@ -180,6 +184,8 @@ int parse_args(const char *name,
 	       char *args,
 	       const struct kernel_param *params,
 	       unsigned num,
+	       u16 flags_mask,
+	       u16 flags,
 	       int (*unknown)(char *param, char *val))
 {
 	char *param, *val;
@@ -195,7 +201,8 @@ int parse_args(const char *name,
 
 		args = next_arg(args, &param, &val);
 		irq_was_disabled = irqs_disabled();
-		ret = parse_one(param, val, params, num, unknown);
+		ret = parse_one(param, val, params, num,
+				flags_mask, flags, unknown);
 		if (irq_was_disabled && !irqs_disabled()) {
 			printk(KERN_WARNING "parse_args(): option '%s' enabled "
 					"irq's!\n", param);
-- 
1.7.5.4


