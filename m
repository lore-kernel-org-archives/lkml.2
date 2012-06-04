Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760509Ab2FDMek (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 08:34:40 -0400
Received: from zose-mta13.web4all.fr ([178.33.204.91]:44231 "EHLO
	zose-mta13.web4all.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760481Ab2FDMej convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 08:34:39 -0400
Date: Mon, 4 Jun 2012 14:38:51 +0200 (CEST)
From: =?utf-8?Q?Beno=C3=AEt_Th=C3=A9baudeau?= 
	<benoit.thebaudeau@advansee.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Pawel Moll <pawel.moll@arm.com>, Artem Bityutskiy <dedekind1@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
        benoit thebaudeau <benoit.thebaudeau@advansee.com>
Message-ID: <28190110.1966162.1338813531173.JavaMail.root@advansee.com>
In-Reply-To: <87ipf71ytx.fsf@rustcorp.com.au>
Subject: Re: init: multi param parsing regression since 3.4
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [88.188.188.98]
X-Mailer: Zimbra 7.2.0_GA_2669 (ZimbraWebClient - FF3.0 (Win)/7.2.0_GA_2669)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 4, 2012 at 6:32:42AM, Rusty Russell wrote:
> Erk, I tested it and you're right.  Level 0 is 'early' initcalls, but
> traditional module parameters are called even earlier.  Simplest fix
> is to move the default parameters to -1.
> 
> This works for me:
> 
> Subject: module_param: stop double-calling parameters.
> From: Rusty Russell <rusty@rustcorp.com.au>
> 
> Commit 026cee0086fe1df4cf74691cf273062cc769617d "params:
> <level>_initcall-like kernel parameters" set old-style module
> parameters to level 0.  And we call those level 0 calls where we used
> to, early in start_kernel().
> 
> We also loop through the initcall levels and call the levelled
> module_params before the corresponding initcall.  Unfortunately level
> 0 is early_init(), so we call the standard module_param calls twice.
> 
> (Turns out most things don't care, but at least ubi.mtd does).
> 
> Change the level to -1 for standard module_param calls.
> 
> Reported-by: Benoît Thébaudeau <benoit.thebaudeau@advansee.com>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Cc: stable@kernel.org
> 
> diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
> --- a/drivers/mtd/ubi/build.c
> +++ b/drivers/mtd/ubi/build.c
> @@ -1293,6 +1293,8 @@ static int __init ubi_mtd_param_parse(co
>  	char *pbuf = &buf[0];
>  	char *tokens[2] = {NULL, NULL};
>  
> +	printk("ubi_mtd_param_parse: val = %s\n", val);
> +	WARN_ON(1);
>  	if (!val)
>  		return -EINVAL;
>  
> diff --git a/include/linux/moduleparam.h
> b/include/linux/moduleparam.h
> --- a/include/linux/moduleparam.h
> +++ b/include/linux/moduleparam.h
> @@ -128,7 +128,7 @@ struct kparam_array
>   * The ops can have NULL set or get functions.
>   */
>  #define module_param_cb(name, ops, arg, perm)				      \
> -	__module_param_call(MODULE_PARAM_PREFIX, name, ops, arg, perm, 0)
> +	__module_param_call(MODULE_PARAM_PREFIX, name, ops, arg, perm, -1)
>  
>  /**
>   * <level>_param_cb - general callback for a module/cmdline
>   parameter
> @@ -192,7 +192,7 @@ struct kparam_array
>  		 { (void *)set, (void *)get };				\
>  	__module_param_call(MODULE_PARAM_PREFIX,			\
>  			    name, &__param_ops_##name, arg,		\
> -			    (perm) + sizeof(__check_old_set_param(set))*0, 0)
> +			    (perm) + sizeof(__check_old_set_param(set))*0, -1)
>  
>  /* We don't get oldget: it's often a new-style param_get_uint, etc.
>  */
>  static inline int
> @@ -272,7 +272,7 @@ static inline void __kernel_param_unlock
>   */
>  #define core_param(name, var, type, perm)				\
>  	param_check_##type(name, &(var));				\
> -	__module_param_call("", name, &param_ops_##type, &var, perm, 0)
> +	__module_param_call("", name, &param_ops_##type, &var, perm, -1)
>  #endif /* !MODULE */
>  
>  /**
> @@ -290,7 +290,7 @@ static inline void __kernel_param_unlock
>  		= { len, string };					\
>  	__module_param_call(MODULE_PARAM_PREFIX, name,			\
>  			    &param_ops_string,				\
> -			    .str = &__param_string_##name, perm, 0);	\
> +			    .str = &__param_string_##name, perm, -1);	\
>  	__MODULE_PARM_TYPE(name, "string")
>  
>  /**
> @@ -432,7 +432,7 @@ extern int param_set_bint(const char *va
>  	__module_param_call(MODULE_PARAM_PREFIX, name,			\
>  			    &param_array_ops,				\
>  			    .arr = &__param_arr_##name,			\
> -			    perm, 0);					\
> +			    perm, -1);					\
>  	__MODULE_PARM_TYPE(name, "array of " #type)
>  
>  extern struct kernel_param_ops param_array_ops;
> diff --git a/init/main.c b/init/main.c
> --- a/init/main.c
> +++ b/init/main.c
> @@ -508,7 +508,7 @@ asmlinkage void __init start_kernel(void
>  	parse_early_param();
>  	parse_args("Booting kernel", static_command_line, __start___param,
>  		   __stop___param - __start___param,
> -		   0, 0, &unknown_bootoption);
> +		   -1, -1, &unknown_bootoption);
>  
>  	jump_label_init();
>  
> 

It works for me too. But I think you can remove the 1st hunk, which seems to be
a leftover from your tests.

Regards,
Benoît
