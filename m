Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab0KIOLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 09:11:42 -0500
Received: from server109-228-6-236.live-servers.net ([109.228.6.236]:51017
	"EHLO fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751521Ab0KIOLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 09:11:41 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.66.37;
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org, fweisbec@gmail.com,
        mingo@redhat.com, Chris Wilson <chris@chris-wilson.co.uk>
Subject: [PATCH] Delegate unknown module parameters to interested parties
Date: Tue,  9 Nov 2010 14:11:07 +0000
Message-Id: <1289311867-10096-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <0d30dc$k4dmjb@orsmga001.jf.intel.com>
References: <0d30dc$k4dmjb@orsmga001.jf.intel.com>
X-Originating-IP: 78.156.66.37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a sketch of what I had in mind for trace to do the event
initialisation on the modules behalf.

---
 include/linux/module.h      |    8 ++++++++
 include/linux/moduleparam.h |    3 ++-
 init/main.c                 |    8 ++++----
 kernel/module.c             |   21 ++++++++++++++++++++-
 kernel/params.c             |   10 ++++++----
 kernel/trace/trace_events.c |   15 ++++++++++++++-
 6 files changed, 54 insertions(+), 11 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index b29e745..84daad8 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -241,6 +241,14 @@ enum module_state
 	MODULE_STATE_GOING,
 };
 
+#define MODULE_UNKNOWN_PARAM (MODULE_STATE_GOING + 1)
+
+struct module_unknown_param {
+	struct module *mod;
+	char *param;
+	char *val;
+};
+
 struct module
 {
 	enum module_state state;
diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
index 112adf8..5e24ec1 100644
--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -265,7 +265,8 @@ extern int parse_args(const char *name,
 		      char *args,
 		      const struct kernel_param *params,
 		      unsigned num,
-		      int (*unknown)(char *param, char *val));
+		      int (*unknown)(char *param, char *val, void *data),
+		      void *data);
 
 /* Called by module remove. */
 #ifdef CONFIG_SYSFS
diff --git a/init/main.c b/init/main.c
index e59af24..782780e 100644
--- a/init/main.c
+++ b/init/main.c
@@ -267,7 +267,7 @@ early_param("loglevel", loglevel);
  * Unknown boot options get handed to init, unless they look like
  * unused parameters (modprobe will find them in /proc/cmdline).
  */
-static int __init unknown_bootoption(char *param, char *val)
+static int __init unknown_bootoption(char *param, char *val, void *data)
 {
 	/* Change NUL term back to "=", to make "param" the whole string. */
 	if (val) {
@@ -455,7 +455,7 @@ static noinline void __init_refok rest_init(void)
 }
 
 /* Check for early params. */
-static int __init do_early_param(char *param, char *val)
+static int __init do_early_param(char *param, char *val, void *data)
 {
 	const struct obs_kernel_param *p;
 
@@ -475,7 +475,7 @@ static int __init do_early_param(char *param, char *val)
 
 void __init parse_early_options(char *cmdline)
 {
-	parse_args("early options", cmdline, NULL, 0, do_early_param);
+	parse_args("early options", cmdline, NULL, 0, do_early_param, NULL);
 }
 
 /* Arch code calls this early on, or if not, just before other parsing. */
@@ -578,7 +578,7 @@ asmlinkage void __init start_kernel(void)
 	parse_early_param();
 	parse_args("Booting kernel", static_command_line, __start___param,
 		   __stop___param - __start___param,
-		   &unknown_bootoption);
+		   &unknown_bootoption, NULL);
 	/*
 	 * These use large bootmem allocations and must precede
 	 * kmem_cache_init()
diff --git a/kernel/module.c b/kernel/module.c
index 2df4630..87ce541 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2544,6 +2544,24 @@ static int post_relocation(struct module *mod, const struct load_info *info)
 	return module_finalize(info->hdr, info->sechdrs, mod);
 }
 
+static int unknown_param(char *param, char *val, void *data)
+{
+	struct module_unknown_param arg;
+	int ret;
+
+	arg.mod = data;
+	arg.param = param;
+	arg.val = val;
+
+	ret = blocking_notifier_call_chain(&module_notify_list,
+					  MODULE_UNKNOWN_PARAM,
+					  &arg);
+	if (ret & NOTIFY_STOP_MASK)
+		return notifier_to_errno(ret);
+
+	return -ENOENT;
+}
+
 /* Allocate and load the module: note that size of section 0 is always
    zero, and we rely on this for optional sections. */
 static struct module *load_module(void __user *umod,
@@ -2637,7 +2655,8 @@ static struct module *load_module(void __user *umod,
 	mutex_unlock(&module_mutex);
 
 	/* Module is ready to execute: parsing args may do that. */
-	err = parse_args(mod->name, mod->args, mod->kp, mod->num_kp, NULL);
+	err = parse_args(mod->name, mod->args, mod->kp, mod->num_kp,
+			 unknown_param, mod);
 	if (err < 0)
 		goto unlink;
 
diff --git a/kernel/params.c b/kernel/params.c
index 08107d1..d8c707c 100644
--- a/kernel/params.c
+++ b/kernel/params.c
@@ -87,7 +87,8 @@ static int parse_one(char *param,
 		     char *val,
 		     const struct kernel_param *params,
 		     unsigned num_params,
-		     int (*handle_unknown)(char *param, char *val))
+		     int (*handle_unknown)(char *param, char *val, void *data),
+		     void *data)
 {
 	unsigned int i;
 	int err;
@@ -109,7 +110,7 @@ static int parse_one(char *param,
 
 	if (handle_unknown) {
 		DEBUGP("Unknown argument: calling %p\n", handle_unknown);
-		return handle_unknown(param, val);
+		return handle_unknown(param, val, data);
 	}
 
 	DEBUGP("Unknown argument `%s'\n", param);
@@ -173,7 +174,8 @@ int parse_args(const char *name,
 	       char *args,
 	       const struct kernel_param *params,
 	       unsigned num,
-	       int (*unknown)(char *param, char *val))
+	       int (*unknown)(char *param, char *val, void *data),
+	       void *data)
 {
 	char *param, *val;
 
@@ -188,7 +190,7 @@ int parse_args(const char *name,
 
 		args = next_arg(args, &param, &val);
 		irq_was_disabled = irqs_disabled();
-		ret = parse_one(param, val, params, num, unknown);
+		ret = parse_one(param, val, params, num, unknown, data);
 		if (irq_was_disabled && !irqs_disabled()) {
 			printk(KERN_WARNING "parse_args(): option '%s' enabled "
 					"irq's!\n", param);
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 0725eea..d23cbf3 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1330,10 +1330,21 @@ static void trace_module_remove_events(struct module *mod)
 	up_write(&trace_event_mutex);
 }
 
+static int trace_module_unknown_param(struct module_unknown_param *arg)
+{
+	if (strcmp(arg->param, "trace") == 0) {
+		int ret = trace_set_clr_module_event(arg->mod, arg->val, 1);
+		return NOTIFY_STOP_MASK | (NOTIFY_OK - ret);
+	}
+
+	return NOTIFY_OK;
+}
+
 static int trace_module_notify(struct notifier_block *self,
 			       unsigned long val, void *data)
 {
 	struct module *mod = data;
+	int ret = 0;
 
 	mutex_lock(&event_mutex);
 	switch (val) {
@@ -1343,10 +1354,12 @@ static int trace_module_notify(struct notifier_block *self,
 	case MODULE_STATE_GOING:
 		trace_module_remove_events(mod);
 		break;
+	case MODULE_UNKNOWN_PARAM:
+		ret = trace_module_unknown_param(data);
 	}
 	mutex_unlock(&event_mutex);
 
-	return 0;
+	return ret;
 }
 #else
 static int trace_module_notify(struct notifier_block *self,
-- 
1.7.2.3

