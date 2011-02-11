Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758235Ab1BKWEz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 17:04:55 -0500
Received: from [65.115.85.73] ([65.115.85.73]:46572 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757392Ab1BKWEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 17:04:52 -0500
Date: Fri, 11 Feb 2011 14:03:56 -0800
From: Dmitry Torokhov <dtor@vmware.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Miller <davem@davemloft.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Linux/m68k <linux-m68k@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Dmitry Torokhov <dtor@vmware.com>
Subject: [PATCH v2] module: deal with alignment issues in built-in module
 parameters
Message-ID: <20110211220356.GA13504@dtor-ws.eng.vmware.com>
References: <1297123347-2170-1-git-send-email-dtor@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297123347-2170-1-git-send-email-dtor@vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 03f1332fc02af7af0d06ab409e3ec72107637845 Mon Sep 17 00:00:00 2001
From: Dmitry Torokhov <dtor@vmware.com>
Date: Mon, 7 Feb 2011 13:47:20 -0800
Subject: [PATCH] module: deal with alignment issues in built-in module parameters

As DaveM said, we can't reliably put structures into independent
objects, put them into a special section, and then expect array
access over them (via the section boundaries) after linking the
objects together to just "work" due to variable alignment choices
in different situations. The only solution that seems to work
reliably is to make an array of plain pointers to the objects in
question and put those pointers in the special section.

Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
---

This is v2 of the patch, hopefully fixing all the issues that were
presented in the original submission, namely:

- fix for kparam_[un]block_sysfs_write() breakage;
- convert non-built-in module parameter case to expect array of
  pointers to struct kernel_param, not array of the structures
  themselves.

Thanks,

Dmitry


 include/linux/module.h      |    2 +-
 include/linux/moduleparam.h |   24 ++++++++++++----------
 init/main.c                 |    2 +-
 kernel/module.c             |    2 +-
 kernel/params.c             |   45 +++++++++++++++++++++++-------------------
 5 files changed, 41 insertions(+), 34 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index cb41837..c256380 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -292,7 +292,7 @@ struct module
 	unsigned int num_syms;
 
 	/* Kernel parameters. */
-	struct kernel_param *kp;
+	const struct kernel_param **kp;
 	unsigned int num_kp;
 
 	/* GPL-only exported symbols. */
diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 07b4195..f9de240 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -147,15 +147,17 @@ struct kparam_array
 	BUILD_BUG_ON_ZERO((perm) < 0 || (perm) > 0777 || ((perm) & 2))	\
 	+ BUILD_BUG_ON_ZERO(sizeof(""prefix) > MAX_PARAM_PREFIX_LEN);	\
 	static const char __param_str_##name[] = prefix #name;		\
-	static struct kernel_param __moduleparam_const __param_##name	\
-	__used								\
-    __attribute__ ((unused,__section__ ("__param"),aligned(sizeof(void *)))) \
-	= { __param_str_##name, ops, perm, isbool ? KPARAM_ISBOOL : 0,	\
-	    { arg } }
+	static const struct kernel_param __param_##name = {		\
+	    __param_str_##name, ops, perm, isbool ? KPARAM_ISBOOL : 0,	\
+	    { arg }							\
+	};								\
+	static const struct kernel_param				\
+	__used __attribute__ ((__section__ ("__param")))		\
+	* __moduleparam_const ___param_##name = &__param_##name
 
 /* Obsolete - use module_param_cb() */
 #define module_param_call(name, set, get, arg, perm)			\
-	static struct kernel_param_ops __param_ops_##name =		\
+	static const struct kernel_param_ops __param_ops_##name =	\
 		 { (void *)set, (void *)get };				\
 	__module_param_call(MODULE_PARAM_PREFIX,			\
 			    name, &__param_ops_##name, arg,		\
@@ -265,15 +267,15 @@ static inline void __kernel_param_unlock(void)
 /* Called on module insert or kernel boot */
 extern int parse_args(const char *name,
 		      char *args,
-		      const struct kernel_param *params,
+		      const struct kernel_param **params,
 		      unsigned num,
 		      int (*unknown)(char *param, char *val));
 
 /* Called by module remove. */
 #ifdef CONFIG_SYSFS
-extern void destroy_params(const struct kernel_param *params, unsigned num);
+extern void destroy_params(const struct kernel_param **params, unsigned num);
 #else
-static inline void destroy_params(const struct kernel_param *params,
+static inline void destroy_params(const struct kernel_param **params,
 				  unsigned num)
 {
 }
@@ -391,13 +393,13 @@ struct module;
 
 #if defined(CONFIG_SYSFS) && defined(CONFIG_MODULES)
 extern int module_param_sysfs_setup(struct module *mod,
-				    const struct kernel_param *kparam,
+				    const struct kernel_param **kparam,
 				    unsigned int num_params);
 
 extern void module_param_sysfs_remove(struct module *mod);
 #else
 static inline int module_param_sysfs_setup(struct module *mod,
-			     const struct kernel_param *kparam,
+			     const struct kernel_param **kparam,
 			     unsigned int num_params)
 {
 	return 0;
diff --git a/init/main.c b/init/main.c
index 33c37c3..3601586 100644
--- a/init/main.c
+++ b/init/main.c
@@ -544,7 +544,7 @@ static void __init mm_init(void)
 asmlinkage void __init start_kernel(void)
 {
 	char * command_line;
-	extern const struct kernel_param __start___param[], __stop___param[];
+	extern const struct kernel_param *__start___param[], *__stop___param[];
 
 	smp_setup_processor_id();
 
diff --git a/kernel/module.c b/kernel/module.c
index efa290e..7c6c3bf 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1470,7 +1470,7 @@ out:
 
 static int mod_sysfs_setup(struct module *mod,
 			   const struct load_info *info,
-			   struct kernel_param *kparam,
+			   const struct kernel_param **kparam,
 			   unsigned int num_params)
 {
 	int err;
diff --git a/kernel/params.c b/kernel/params.c
index 09a08cb..4f2eb43 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -83,9 +83,9 @@ static inline int parameq(const char *input, const char *paramname)
 	return 0;
 }
 
-static int parse_one(char *param,
+static int parse_one(char *name,
 		     char *val,
-		     const struct kernel_param *params,
+		     const struct kernel_param **params,
 		     unsigned num_params,
 		     int (*handle_unknown)(char *param, char *val))
 {
@@ -94,14 +94,16 @@ static int parse_one(char *param,
 
 	/* Find parameter */
 	for (i = 0; i < num_params; i++) {
-		if (parameq(param, params[i].name)) {
+		const struct kernel_param *param = params[i];
+
+		if (parameq(name, param->name)) {
 			/* Noone handled NULL, so do it here. */
-			if (!val && params[i].ops->set != param_set_bool)
+			if (!val && param->ops->set != param_set_bool)
 				return -EINVAL;
 			DEBUGP("They are equal!  Calling %p\n",
-			       params[i].ops->set);
+			       param->ops->set);
 			mutex_lock(&param_lock);
-			err = params[i].ops->set(val, &params[i]);
+			err = param->ops->set(val, param);
 			mutex_unlock(&param_lock);
 			return err;
 		}
@@ -109,7 +111,7 @@ static int parse_one(char *param,
 
 	if (handle_unknown) {
 		DEBUGP("Unknown argument: calling %p\n", handle_unknown);
-		return handle_unknown(param, val);
+		return handle_unknown(name, val);
 	}
 
 	DEBUGP("Unknown argument `%s'\n", param);
@@ -171,7 +173,7 @@ static char *next_arg(char *args, char **param, char **val)
 /* Args looks like "foo=bar,bar2 baz=fuz wiz". */
 int parse_args(const char *name,
 	       char *args,
-	       const struct kernel_param *params,
+	       const struct kernel_param **params,
 	       unsigned num,
 	       int (*unknown)(char *param, char *val))
 {
@@ -190,8 +192,9 @@ int parse_args(const char *name,
 		irq_was_disabled = irqs_disabled();
 		ret = parse_one(param, val, params, num, unknown);
 		if (irq_was_disabled && !irqs_disabled()) {
-			printk(KERN_WARNING "parse_args(): option '%s' enabled "
-					"irq's!\n", param);
+			printk(KERN_WARNING
+				"parse_args(): option '%s' enabled irq's!\n",
+				param);
 		}
 		switch (ret) {
 		case -ENOENT:
@@ -498,7 +501,8 @@ EXPORT_SYMBOL(param_ops_string);
 #define to_module_attr(n) container_of(n, struct module_attribute, attr)
 #define to_module_kobject(n) container_of(n, struct module_kobject, kobj)
 
-extern struct kernel_param __start___param[], __stop___param[];
+extern const struct kernel_param *__start___param[];
+extern const struct kernel_param *__stop___param[];
 
 struct param_attribute
 {
@@ -667,16 +671,16 @@ static void free_module_param_attrs(struct module_kobject *mk)
  * /sys/module/[mod->name]/parameters/
  */
 int module_param_sysfs_setup(struct module *mod,
-			     const struct kernel_param *kparam,
+			     const struct kernel_param **kparam,
 			     unsigned int num_params)
 {
 	int i, err;
 	bool params = false;
 
 	for (i = 0; i < num_params; i++) {
-		if (kparam[i].perm == 0)
+		if (kparam[i]->perm == 0)
 			continue;
-		err = add_sysfs_param(&mod->mkobj, &kparam[i], kparam[i].name);
+		err = add_sysfs_param(&mod->mkobj, kparam[i], kparam[i]->name);
 		if (err)
 			return err;
 		params = true;
@@ -710,13 +714,13 @@ void module_param_sysfs_remove(struct module *mod)
 }
 #endif
 
-void destroy_params(const struct kernel_param *params, unsigned num)
+void destroy_params(const struct kernel_param **params, unsigned num)
 {
 	unsigned int i;
 
 	for (i = 0; i < num; i++)
-		if (params[i].ops->free)
-			params[i].ops->free(params[i].arg);
+		if (params[i]->ops->free)
+			params[i]->ops->free(params[i]->arg);
 }
 
 static struct module_kobject * __init locate_module_kobject(const char *name)
@@ -754,7 +758,7 @@ static struct module_kobject * __init locate_module_kobject(const char *name)
 }
 
 static void __init kernel_add_sysfs_param(const char *name,
-					  struct kernel_param *kparam,
+					  const struct kernel_param *kparam,
 					  unsigned int name_skip)
 {
 	struct module_kobject *mk;
@@ -789,11 +793,12 @@ static void __init kernel_add_sysfs_param(const char *name,
  */
 static void __init param_sysfs_builtin(void)
 {
-	struct kernel_param *kp;
+	const struct kernel_param **p;
 	unsigned int name_len;
 	char modname[MODULE_NAME_LEN];
 
-	for (kp = __start___param; kp < __stop___param; kp++) {
+	for (p = __start___param; p < __stop___param; p++) {
+		const struct kernel_param *kp = *p;
 		char *dot;
 
 		if (kp->perm == 0)
-- 
1.7.3.2

