Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab1LGBJf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 20:09:35 -0500
Received: from ozlabs.org ([203.10.76.45]:42826 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753919Ab1LGBJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 20:09:34 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: jim.cromie@gmail.com, jbaron@redhat.com
Cc: greg@kroah.com, joe@perches.com, bart.vanassche@gmail.com,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>,
        Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH 18/25] dynamic_debug: Introduce global fake module param $module.dyndbg
In-Reply-To: <1323198694-7186-19-git-send-email-jim.cromie@gmail.com>
References: <CAJfuBxyyriN6vYgwzEft9PKFjWsa2E4FZmbFMmtO6G_DP=nosg@mail.gmail.com>, <CAJfuBxzM6rg21Rpq+ww+=2qK_am44V-Btvhp3Z3hbP2TKP8JTw@mail.gmail.com> <1323198694-7186-1-git-send-email-jim.cromie@gmail.com> <1323198694-7186-19-git-send-email-jim.cromie@gmail.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 07 Dec 2011 11:31:55 +1030
Message-ID: <8739cxjit8.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  6 Dec 2011 12:11:28 -0700, jim.cromie@gmail.com wrote:
> From: Jim Cromie <jim.cromie@gmail.com>
> 
> Rework Thomas Renninger's $module.ddebug boot-time debugging feature,
> from https://lkml.org/lkml/2010/9/15/397

This worked out pretty neatly.  Thanks!

A few questions from your patches:

> diff --git a/include/linux/dynamic_debug.h b/include/linux/dynamic_debug.h
> index 7e3c53a..b77f43b 100644
> --- a/include/linux/dynamic_debug.h
> +++ b/include/linux/dynamic_debug.h
> @@ -39,11 +39,16 @@ struct _ddebug {
>  int ddebug_add_module(struct _ddebug *tab, unsigned int n,
>  				const char *modname);
>  
> +struct kernel_param;
> +
>  #if defined(CONFIG_DYNAMIC_DEBUG)
>  extern int ddebug_remove_module(const char *mod_name);
> +
>  extern __printf(2, 3)
>  int __dynamic_pr_debug(struct _ddebug *descriptor, const char *fmt, ...);

struct kernel_param def belongs in future patch?  And whitespace change
is kind of annoying.

> diff --git a/include/linux/moduleparam.h b/include/linux/moduleparam.h
> index 7939f63..91bd56a 100644
> --- a/include/linux/moduleparam.h
> +++ b/include/linux/moduleparam.h
> @@ -292,7 +292,7 @@ extern int parse_args(const char *name,
>  		      char *args,
>  		      const struct kernel_param *params,
>  		      unsigned num,
> -		      int (*unknown)(char *param, char *val));
> +		      int (*unknown)(char *param, char *val, const char *modname));

Do you really want the modname here, or a struct module?  I wonder if we
should make this a standard opaque void *.  Of course, we'd have to
modify parse_args callers, but you're abusing "name" arg here a bit
anyway.

> @@ -2893,7 +2893,8 @@ static struct module *load_module(void __user *umod,
> 	  mutex_unlock(&module_mutex);
> 
> 	  /* Module is ready to execute: parsing args may do that. */
> -	err = parse_args(mod->name, mod->args, mod->kp, mod->num_kp, NULL);
> +	err = parse_args(mod->name, mod->args, mod->kp, mod->num_kp,
> +			 ddebug_dyndbg_param_cb);
> 	  if (err < 0)
> 		  goto unlink;

You have to 



> @@ -510,8 +510,7 @@ asmlinkage void __init start_kernel(void)
>  	printk(KERN_NOTICE "Kernel command line: %s\n", boot_command_line);
>  	parse_early_param();
>  	parse_args("Booting kernel", static_command_line, __start___param,
> -		   __stop___param - __start___param,
> -		   &unknown_bootoption);
> +		   __stop___param - __start___param, &unknown_bootoption);
>  
>  	jump_label_init();

Gratuitous whitespace change.

> +int ddebug_dyndbg_param_cb(char *param, char* val, const char* modname)
> +{
> +	if (strcmp(param, "dyndbg")) {
> +		pr_warn("bogus param %s=%s received for %s\n",
> +			param, val, modname);
> +		return -EINVAL;
> +	}

This is already done in parse_args(); don't add a pr_warn here.

Thanks,
Rusty.
