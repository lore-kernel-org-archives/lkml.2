Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134Ab1K2Rgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 12:36:37 -0500
Received: from service87.mimecast.com ([91.220.42.44]:43511 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479Ab1K2Rgg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 12:36:36 -0500
Subject: Re: [PATCH] virtio-mmio: Devices parameter parsing
From: Pawel Moll <pawel.moll@arm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
In-Reply-To: <87zkfht7dp.fsf@rustcorp.com.au>
References: <1321365185-2928-1-git-send-email-pawel.moll@arm.com>
	 <87sjlooq3m.fsf@rustcorp.com.au>
	 <1321467222.3137.417.camel@hornet.cambridge.arm.com>
	 <87vcqe9ml9.fsf@rustcorp.com.au>
	 <1321886688.3093.248.camel@hornet.cambridge.arm.com>
	 <1321898210.3093.263.camel@hornet.cambridge.arm.com>
	 <87fwhhx9is.fsf@rustcorp.com.au>
	 <1322071732.3093.491.camel@hornet.cambridge.arm.com>
	 <87zkfht7dp.fsf@rustcorp.com.au>
Date: Tue, 29 Nov 2011 17:36:30 +0000
Message-ID: <1322588190.3164.129.camel@hornet.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 29 Nov 2011 17:36:30.0548 (UTC) FILETIME=[6E0FC140:01CCAEBD]
X-MC-Unique: 111112917363301501
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-11-28 at 00:31 +0000, Rusty Russell wrote:
> Off the top of my head, this makes me think of the way initcalls are
> ordered.  We could put a parameter parsing initcall at the start of each
> initcall level in include/asm-generic/vmlinux.lds.h's INITCALLS macro.
> 
> Then we steal four bits from struct kernel_param's flags to indicate the
> level of the initcall (-1 == existing ones, otherwise N == before level
> N initcalls).

Yes, this was my initial idea as well. The only problem I faced is the
fact that there is no "between levels"... It's easy to add parameters
parsing _at_ any particular level, but hard to do this _after_ level A
and _before_ level B. The initcalls section simply contains all the
calls, ordered by the level - the only "separated" level is the pre-SMP
early one. And order within one level is determined by the link order,
so I can't guarantee parsing the parameters as the first call of a level
(nor as the last call of the previous level).

I've came up with a simple prototype (below, only relevant fragments),
doing exactly what I want at the "late" level (maybe that's all we
actually need? ;-) Of course adding all other levels is possible,
probably some clever "generalization" will be useful. And of course the
level would be simply a number in the flags, but what to do with "_sync"
levels (like "arch_initcall_sync", which is "3s" not just "3").

If it makes any sense I'll carry on, any feedback will be useful.

Cheers!

Paweł

---
diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
index 7317dc2..22e6196 100644
--- a/drivers/virtio/virtio_mmio.c
+++ b/drivers/virtio/virtio_mmio.c
@@ -443,6 +489,122 @@ static int __devexit virtio_mmio_remove(struct platform_device *pdev)
 
 
 
+/* Devices list parameter */
+
+#if defined(CONFIG_VIRTIO_MMIO_CMDLINE_DEVICES)
+
+static struct device vm_cmdline_parent = {
+	.init_name = "virtio-mmio-cmdline",
+};
+
+static int vm_cmdline_parent_registered;
+static int vm_cmdline_id;
+
+static int vm_cmdline_set(const char *device,
+		const struct kernel_param *kp)
+{
+	int err;
+	struct resource resources[2] = {};
+	char *str;
+	long long int base;
+	int processed, consumed = 0;
+	struct platform_device *pdev;
+
+	resources[0].flags = IORESOURCE_MEM;
+	resources[1].flags = IORESOURCE_IRQ;
+
+	resources[0].end = memparse(device, &str) - 1;
+
+	processed = sscanf(str, "@%lli:%u%n:%d%n",
+			&base, &resources[1].start, &consumed,
+			&vm_cmdline_id, &consumed);
+
+	if (processed < 2 || processed > 3 || str[consumed])
+		return -EINVAL;
+
+	resources[0].start = base;
+	resources[0].end += base;
+	resources[1].end = resources[1].start;
+
+	if (!vm_cmdline_parent_registered) {
+		err = device_register(&vm_cmdline_parent);
+		if (err) {
+			pr_err("Failed to register parent device!\n");
+			return err;
+		}
+		vm_cmdline_parent_registered = 1;
+	}
+
+	pr_info("Registering device virtio-mmio.%d at 0x%llx-0x%llx, IRQ %d.\n",
+		       vm_cmdline_id++,
+		       (unsigned long long)resources[0].start,
+		       (unsigned long long)resources[0].end,
+		       (int)resources[1].start);
+
+	pdev = platform_device_register_resndata(&vm_cmdline_parent,
+			"virtio-mmio", vm_cmdline_id++,
+			resources, ARRAY_SIZE(resources), NULL, 0);
+	if (IS_ERR(pdev))
+		return PTR_ERR(pdev);
+
+	return 0;
+}
+
+static int vm_cmdline_get_device(struct device *dev, void *data)
+{
+	char *buffer = data;
+	unsigned int len = strlen(buffer);
+	struct platform_device *pdev = to_platform_device(dev);
+
+	snprintf(buffer + len, PAGE_SIZE - len, "0x%llx@0x%llx:%llu:%d\n",
+			pdev->resource[0].end - pdev->resource[0].start + 1ULL,
+			(unsigned long long)pdev->resource[0].start,
+			(unsigned long long)pdev->resource[1].start,
+			pdev->id);
+	return 0;
+}
+
+static int vm_cmdline_get(char *buffer, const struct kernel_param *kp)
+{
+	buffer[0] = '\0';
+	device_for_each_child(&vm_cmdline_parent, buffer,
+			vm_cmdline_get_device);
+	return strlen(buffer) + 1;
+}
+
+static struct kernel_param_ops vm_cmdline_param_ops = {
+	.set = vm_cmdline_set,
+	.get = vm_cmdline_get,
+};
+
+module_param_cb_late(device, &vm_cmdline_param_ops, NULL, S_IRUSR);
+
+static int vm_unregister_cmdline_device(struct device *dev,
+		void *data)
+{
+	platform_device_unregister(to_platform_device(dev));
+
+	return 0;
+}
+
+static void vm_unregister_cmdline_devices(void)
+{
+	if (vm_cmdline_parent_registered) {
+		device_for_each_child(&vm_cmdline_parent, NULL,
+				vm_unregister_cmdline_device);
+		device_unregister(&vm_cmdline_parent);
+		vm_cmdline_parent_registered = 0;
+	}
+}
+
+#else
+
+static void virtio_mmio_unregister_cmdline_devices(void)
+{
+}
+
+#endif
+
 /* Platform driver */
 
 static struct of_device_id virtio_mmio_match[] = {
@@ -469,6 +631,7 @@ static int __init virtio_mmio_init(void)
 static void __exit virtio_mmio_exit(void)
 {
 	platform_driver_unregister(&virtio_mmio_driver);
+	vm_unregister_cmdline_devices();
 }
 
 module_init(virtio_mmio_init);
diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 7939f63..fccf0cb 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -48,7 +48,8 @@ struct kernel_param_ops {
 };
 
 /* Flag bits for kernel_param.flags */
-#define KPARAM_ISBOOL		2
+#define KPARAM_ISBOOL		(1 << 1)
+#define KPARAM_LATE		(1 << 2)
 
 struct kernel_param {
 	const char *name;
@@ -132,7 +133,13 @@ struct kparam_array
  */
 #define module_param_cb(name, ops, arg, perm)				      \
 	__module_param_call(MODULE_PARAM_PREFIX,			      \
-			    name, ops, arg, __same_type((arg), bool *), perm)
+			    name, ops, arg, 				      \
+			    __same_type((arg), bool *), 0, perm)
+
+#define module_param_cb_late(name, ops, arg, perm)			      \
+	__module_param_call(MODULE_PARAM_PREFIX,			      \
+			    name, ops, arg,				      \
+			    __same_type((arg), bool *), 1, perm)
 
 /* On alpha, ia64 and ppc64 relocations to global data cannot go into
    read-only sections (which is part of respective UNIX ABI on these
@@ -146,7 +153,7 @@ struct kparam_array
 
 /* This is the fundamental function for registering boot/module
    parameters. */
-#define __module_param_call(prefix, name, ops, arg, isbool, perm)	\
+#define __module_param_call(prefix, name, ops, arg, isbool, late, perm)	\
 	/* Default value instead of permissions? */			\
 	static int __param_perm_check_##name __attribute__((unused)) =	\
 	BUILD_BUG_ON_ZERO((perm) < 0 || (perm) > 0777 || ((perm) & 2))	\
@@ -155,7 +162,8 @@ struct kparam_array
 	static struct kernel_param __moduleparam_const __param_##name	\
 	__used								\
     __attribute__ ((unused,__section__ ("__param"),aligned(sizeof(void *)))) \
-	= { __param_str_##name, ops, perm, isbool ? KPARAM_ISBOOL : 0,	\
+	= { __param_str_##name, ops, perm, 				\
+	    (isbool ? KPARAM_ISBOOL : 0) | (late ? KPARAM_LATE : 0),	\
 	    { arg } }
 
 /* Obsolete - use module_param_cb() */
@@ -165,6 +173,7 @@ struct kparam_array
 	__module_param_call(MODULE_PARAM_PREFIX,			\
 			    name, &__param_ops_##name, arg,		\
 			    __same_type(arg, bool *),			\
+			    0,					\
 			    (perm) + sizeof(__check_old_set_param(set))*0)
 
 /* We don't get oldget: it's often a new-style param_get_uint, etc. */
@@ -246,7 +255,7 @@ static inline void __kernel_param_unlock(void)
 #define core_param(name, var, type, perm)				\
 	param_check_##type(name, &(var));				\
 	__module_param_call("", name, &param_ops_##type,		\
-			    &var, __same_type(var, bool), perm)
+			    &var, __same_type(var, bool), 0, perm)
 #endif /* !MODULE */
 
 /**
@@ -264,7 +273,7 @@ static inline void __kernel_param_unlock(void)
 		= { len, string };					\
 	__module_param_call(MODULE_PARAM_PREFIX, name,			\
 			    &param_ops_string,				\
-			    .str = &__param_string_##name, 0, perm);	\
+			    .str = &__param_string_##name, 0, 0, perm);	\
 	__MODULE_PARM_TYPE(name, "string")
 
 /**
@@ -292,6 +301,8 @@ extern int parse_args(const char *name,
 		      char *args,
 		      const struct kernel_param *params,
 		      unsigned num,
+		      u16 flags_mask,
+		      u16 flags,
 		      int (*unknown)(char *param, char *val));
 
 /* Called by module remove. */
@@ -402,7 +413,7 @@ extern int param_get_invbool(char *buffer, const struct kernel_param *kp);
 	__module_param_call(MODULE_PARAM_PREFIX, name,			\
 			    &param_array_ops,				\
 			    .arr = &__param_arr_##name,			\
-			    __same_type(array[0], bool), perm);		\
+			    __same_type(array[0], bool), 0, perm);	\
 	__MODULE_PARM_TYPE(name, "array of " #type)
 
 extern struct kernel_param_ops param_array_ops;
diff --git a/init/main.c b/init/main.c
index 217ed23..ce89a53 100644
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
+		   KPARAM_LATE, 0, &unknown_bootoption);
 
 	jump_label_init();
 
@@ -737,6 +737,22 @@ static void __init do_basic_setup(void)
 	do_initcalls();
 }
 
+static int __init ignore_unknown_bootoption(char *param, char *val)
+{
+	return 0;
+}
+
+static int __init parse_late_args(void)
+{
+	extern const struct kernel_param __start___param[], __stop___param[];
+
+	strcpy(static_command_line, saved_command_line);
+	parse_args("Late parameters", static_command_line, __start___param,
+		   __stop___param - __start___param,
+		   KPARAM_LATE, KPARAM_LATE, ignore_unknown_bootoption);
+}
+late_initcall(parse_late_args);
+
 static void __init do_pre_smp_initcalls(void)
 {
 	initcall_t *fn;
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
index 65aae11..560345c 100644
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
+			        flags_mask, flags, unknown);
 		if (irq_was_disabled && !irqs_disabled()) {
 			printk(KERN_WARNING "parse_args(): option '%s' enabled "
 					"irq's!\n", param);



