Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760088Ab1LPD5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 22:57:05 -0500
Received: from ozlabs.org ([203.10.76.45]:57379 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826Ab1LPD5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 22:57:03 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: jim.cromie@gmail.com, jbaron@redhat.com
Cc: greg@kroah.com, linux-kernel@vger.kernel.org,
        Jim Cromie <jim.cromie@gmail.com>, Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH 18/25] dynamic_debug: Introduce global fake module param $module.dyndbg
In-Reply-To: <1323731569-20644-18-git-send-email-jim.cromie@gmail.com>
References: <1323731569-20644-1-git-send-email-jim.cromie@gmail.com> <1323731569-20644-18-git-send-email-jim.cromie@gmail.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 16 Dec 2011 10:30:41 +1030
Message-ID: <87bor9qtau.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Dec 2011 16:12:44 -0700, jim.cromie@gmail.com wrote:
> From: Jim Cromie <jim.cromie@gmail.com>
> 
> Rework Thomas Renninger's $module.ddebug boot-time debugging feature,
> from https://lkml.org/lkml/2010/9/15/397

OK, this looks cleaner!

> @@ -292,7 +292,8 @@ extern int parse_args(const char *name,
>  		      char *args,
>  		      const struct kernel_param *params,
>  		      unsigned num,
> -		      int (*unknown)(char *param, char *val));
> +		      int (*unknown)(char *param, char *val,
> +			      const char *modname));

s/modname/doing/ here, since it's a generic callback.

> -static int __init unknown_bootoption(char *param, char *val)
> +static int __init unknown_bootoption(char *param, char *val,
> +				const char *modname)
>  {

s/modname/doing/ (or /s/modname/unused/).

>  	/* Change NUL term back to "=", to make "param" the whole string. */
>  	if (val) {
> @@ -387,7 +388,7 @@ static noinline void __init_refok rest_init(void)
>  }
>  
>  /* Check for early params. */
> -static int __init do_early_param(char *param, char *val)
> +static int __init do_early_param(char *param, char *val, const char *modname)
>  {

Same as above.

> diff --git a/kernel/params.c b/kernel/params.c
> index 9240664..4c39c0e 100644
> --- a/kernel/params.c
> +++ b/kernel/params.c
> @@ -86,9 +86,11 @@ bool parameq(const char *a, const char *b)
>  
>  static int parse_one(char *param,
>  		     char *val,
> +		     const char *doing,
>  		     const struct kernel_param *params,
>  		     unsigned num_params,
> -		     int (*handle_unknown)(char *param, char *val))
> +		     int (*handle_unknown)(char *param, char *val,
> +					   const char *modname))
>  {

s/modname/doing/ here too, makes it clear.

>  /* Args looks like "foo=bar,bar2 baz=fuz wiz". */
> -int parse_args(const char *name,
> +int parse_args(const char *doing, /* modname, Booting kernel, early options */
>  	       char *args,
>  	       const struct kernel_param *params,
>  	       unsigned num,
> -	       int (*unknown)(char *param, char *val))
> +	       int (*unknown)(char *param, char *val, const char *modname))
>  {

... again....

> +/* find & process .dyndbg params (prefixed by modname) in cmdline */
> +static __init void ddebug_boot_parse_args(void)
> +{

OK, I don't get why you are doing your own parsing for builtins?

Can't you call something from init/main.c:unknown_bootoption()?

If that's too early, I have a patch we're working on which adds
parameter parsing to each initlevel.

Thanks,
Rusty.
