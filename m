Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754413Ab1BKIh7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 03:37:59 -0500
Received: from [65.115.85.73] ([65.115.85.73]:52891 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753323Ab1BKIh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 03:37:58 -0500
Date: Fri, 11 Feb 2011 00:37:02 -0800
From: Dmitry Torokhov <dtor@vmware.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: boot problen with next-20110211
Message-ID: <20110211083702.GA1026@dtor-ws.eng.vmware.com>
References: <20110211172254.8aa4d816.sfr@canb.auug.org.au>
 <20110211065731.GA8861@dtor-ws.eng.vmware.com>
 <20110211070642.GA9512@dtor-ws.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110211070642.GA9512@dtor-ws.eng.vmware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 11:06:42PM -0800, Dmitry Torokhov wrote:
> On Thu, Feb 10, 2011 at 10:57:31PM -0800, Dmitry Torokhov wrote:
> > Hi Stephen,
> > 
> > On Thu, Feb 10, 2011 at 10:22:54PM -0800, Stephen Rothwell wrote:
> > > 
> > > Maybe the module parameter alignment patches?  That is a very strange
> > > parameter name (it is the same in the other messages).
> > 
> > Yes, I think it is... I wonder why I did not see it locally.  Let me try
> > to fix that...
> > 
> 
> Gah, it is better Rusty drops the module param alignment patch so I can
> redo it properly. The module case is completely broken as it still
> operates with assumption that __param section contains full structures
> and not pointers.
> 

OK, so the following seems to boot fine on x86_64 and i386. Anyway,
tomorrow I will fold everything together and resend properly.

Thanks,
Dmitry


>From 24871cd7d3afc5e71c8ae22dfc6196bb1c605d60 Mon Sep 17 00:00:00 2001
From: Dmitry Torokhov <dtor@vmware.com>
Date: Fri, 11 Feb 2011 00:34:25 -0800
Subject: [PATCH] module: fix fallout from alignment patch

Signed-off-by: Dmitry Torokhov <dtor@vmware.com>
---
 include/linux/module.h      |    2 +-
 include/linux/moduleparam.h |   10 +++++-----
 init/main.c                 |    2 +-
 kernel/module.c             |    2 +-
 kernel/params.c             |   35 +++++++++++++++++++----------------
 5 files changed, 27 insertions(+), 24 deletions(-)

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
index 05b92c0..75c5dad 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -267,15 +267,15 @@ static inline void __kernel_param_unlock(void)
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
@@ -393,13 +393,13 @@ struct module;
 
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
index 66f7e66..4f2eb43 100644
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
@@ -668,16 +671,16 @@ static void free_module_param_attrs(struct module_kobject *mk)
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
@@ -711,13 +714,13 @@ void module_param_sysfs_remove(struct module *mod)
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
-- 
1.7.3.2


