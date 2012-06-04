Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab2FDEtw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 00:49:52 -0400
Received: from ozlabs.org ([203.10.76.45]:45310 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755963Ab2FDEsk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 00:48:40 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: =?utf-8?Q?Beno=C3=AEt_Th=C3=A9baudeau?= 
	<benoit.thebaudeau@advansee.com>,
        Pawel Moll <pawel.moll@arm.com>
Cc: benoit thebaudeau <benoit.thebaudeau@advansee.com>,
        linux-kernel@vger.kernel.org
Subject: Re: init: multi param parsing regression since 3.4
In-Reply-To: <1170056063.1844670.1338571611538.JavaMail.root@advansee.com>
References: <1170056063.1844670.1338571611538.JavaMail.root@advansee.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 04 Jun 2012 14:02:42 +0930
Message-ID: <87ipf71ytx.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2012 19:26:51 +0200 (CEST), Benoît Thébaudeau <benoit.thebaudeau@advansee.com> wrote:
> Hi Pawel, Rusty, all,
> 
...
> After some debugging, I found that this is caused by "ubi.mtd=rootfs" in my
> kernel command line being parsed twice while appearing once in this line.

Weird, that shouldn't happen.

> The root cause is "parse_args(initcall_level_names[level], ..." that you added
> to init/main.c in commit #026cee0086fe1df4cf74691cf273062cc769617d, because
> level 0 is shared by "Booting kernel" and "early parameters".

Erk, I tested it and you're right.  Level 0 is 'early' initcalls, but
traditional module parameters are called even earlier.  Simplest fix
is to move the default parameters to -1.

This works for me:

Subject: module_param: stop double-calling parameters.
From: Rusty Russell <rusty@rustcorp.com.au>

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
Cc: stable@kernel.org

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -1293,6 +1293,8 @@ static int __init ubi_mtd_param_parse(co
 	char *pbuf = &buf[0];
 	char *tokens[2] = {NULL, NULL};
 
+	printk("ubi_mtd_param_parse: val = %s\n", val);
+	WARN_ON(1);
 	if (!val)
 		return -EINVAL;
 
diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
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
@@ -432,7 +432,7 @@ extern int param_set_bint(const char *va
 	__module_param_call(MODULE_PARAM_PREFIX, name,			\
 			    &param_array_ops,				\
 			    .arr = &__param_arr_##name,			\
-			    perm, 0);					\
+			    perm, -1);					\
 	__MODULE_PARM_TYPE(name, "array of " #type)
 
 extern struct kernel_param_ops param_array_ops;
diff --git a/init/main.c b/init/main.c
--- a/init/main.c
+++ b/init/main.c
@@ -508,7 +508,7 @@ asmlinkage void __init start_kernel(void
 	parse_early_param();
 	parse_args("Booting kernel", static_command_line, __start___param,
 		   __stop___param - __start___param,
-		   0, 0, &unknown_bootoption);
+		   -1, -1, &unknown_bootoption);
 
 	jump_label_init();
 
