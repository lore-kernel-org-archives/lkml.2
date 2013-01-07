Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401Ab3AGBR1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 20:17:27 -0500
Received: from ozlabs.org ([203.10.76.45]:46261 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311Ab3AGBRW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 20:17:22 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Josh Boyer <jwboyer@redhat.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>, dhowells@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MODSIGN: Don't taint unless signature enforcing is enabled
In-Reply-To: <20130104191205.GD27554@hansolo.jdub.homelinux.org>
References: <20130104191205.GD27554@hansolo.jdub.homelinux.org>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 07 Jan 2013 11:39:47 +1030
Message-ID: <87bod14x44.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Boyer <jwboyer@redhat.com> writes:
> With module signing enabled but not in enforcing mode, we don't consider
> unsigned modules to be an error.  However, we only mark sig_ok as true if
> a signature verified.  This causes the module to be tainted with the
> TAINT_FORCED_MODULE flag.

Wait, what?  So, what does CONFIG_MODULE_SIG=y with MODULE_SIG_FORCE=n
mean?  Why not just call that CONFIG_USELESS_BLOAT? :)

>  That in turn taints the kernel, which also disables lockdep.

Yeah, lockdep is oversensitive.  This has been argued before, take it up
with Ingo.  Perhaps we need a taint flag bit to indicate that lockdep
should actually be disabled?

> Tainting the module and kernel when we don't consider something to be an
> error seems excessive.  This marks sig_ok as true if we aren't in enforcing
> mode.

If we were to do this, please follow Plauger's Law: "Don't patch bad
code - rewrite it."

In this case, rip out the now-useless sig_ok field.

Thanks,
Rusty.

> diff --git a/kernel/module.c b/kernel/module.c
> index 250092c..a50172e 100644
> --- a/kernel/module.c
> +++ b/kernel/module.c
> @@ -2443,8 +2443,10 @@ static int module_sig_check(struct load_info *info)
>  	if (err < 0 && fips_enabled)
>  		panic("Module verification failed with error %d in FIPS mode\n",
>  		      err);
> -	if (err == -ENOKEY && !sig_enforce)
> +	if (err == -ENOKEY && !sig_enforce) {
> +		info->sig_ok = true;
>  		err = 0;
> +	}
>  
>  	return err;
>  }
> -- 
> 1.8.0.1
