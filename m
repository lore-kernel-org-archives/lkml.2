Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756743Ab2FNX7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 19:59:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56620 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756695Ab2FNX7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 19:59:09 -0400
Message-Id: <20120614235624.513231504@linuxfoundation.org>
User-Agent: quilt/0.60-20.1
Date: Thu, 14 Jun 2012 16:56:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Beno=C3=AEt=20Th=C3=A9baudeau?= 
	<benoit.thebaudeau@advansee.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [ 07/42] module_param: stop double-calling parameters.
In-Reply-To: <20120614235636.GA5275@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rusty Russell <rusty@rustcorp.com.au>

commit ae82fdb1406ad41d68f07027fe31f2d35ba22a90 upstream.

Commit 026cee0086fe1df4cf74691cf273062cc769617d "params:
<level>_initcall-like kernel parameters" set old-style module
parameters to level 0.  And we call those level 0 calls where we used
to, early in start_kernel().

We also loop through the initcall levels and call the levelled
module_params before the corresponding initcall.  Unfortunately level
0 is early_init(), so we call the standard module_param calls twice.

(Turns out most things don't care, but at least ubi.mtd does).

Change the level to -1 for standard module_param calls.

Reported-by: Benoît Thébaudeau <benoit.thebaudeau@advansee.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/moduleparam.h |   10 +++++-----
 init/main.c                 |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/include/linux/moduleparam.h
+++ b/include/linux/moduleparam.h
@@ -128,7 +128,7 @@ struct kparam_array
  * The ops can have NULL set or get functions.
  */
 #define module_param_cb(name, ops, arg, perm)				      \
-	__module_param_call(MODULE_PARAM_PREFIX, name, ops, arg, perm, 0)
+	__module_param_call(MODULE_PARAM_PREFIX, name, ops, arg, perm, -1)
 
 /**
  * <level>_param_cb - general callback for a module/cmdline parameter
@@ -192,7 +192,7 @@ struct kparam_array
 		 { (void *)set, (void *)get };				\
 	__module_param_call(MODULE_PARAM_PREFIX,			\
 			    name, &__param_ops_##name, arg,		\
-			    (perm) + sizeof(__check_old_set_param(set))*0, 0)
+			    (perm) + sizeof(__check_old_set_param(set))*0, -1)
 
 /* We don't get oldget: it's often a new-style param_get_uint, etc. */
 static inline int
@@ -272,7 +272,7 @@ static inline void __kernel_param_unlock
  */
 #define core_param(name, var, type, perm)				\
 	param_check_##type(name, &(var));				\
-	__module_param_call("", name, &param_ops_##type, &var, perm, 0)
+	__module_param_call("", name, &param_ops_##type, &var, perm, -1)
 #endif /* !MODULE */
 
 /**
@@ -290,7 +290,7 @@ static inline void __kernel_param_unlock
 		= { len, string };					\
 	__module_param_call(MODULE_PARAM_PREFIX, name,			\
 			    &param_ops_string,				\
-			    .str = &__param_string_##name, perm, 0);	\
+			    .str = &__param_string_##name, perm, -1);	\
 	__MODULE_PARM_TYPE(name, "string")
 
 /**
@@ -431,7 +431,7 @@ extern int param_set_bint(const char *va
 	__module_param_call(MODULE_PARAM_PREFIX, name,			\
 			    &param_array_ops,				\
 			    .arr = &__param_arr_##name,			\
-			    perm, 0);					\
+			    perm, -1);					\
 	__MODULE_PARM_TYPE(name, "array of " #type)
 
 extern struct kernel_param_ops param_array_ops;
--- a/init/main.c
+++ b/init/main.c
@@ -508,7 +508,7 @@ asmlinkage void __init start_kernel(void
 	parse_early_param();
 	parse_args("Booting kernel", static_command_line, __start___param,
 		   __stop___param - __start___param,
-		   0, 0, &unknown_bootoption);
+		   -1, -1, &unknown_bootoption);
 
 	jump_label_init();
 


