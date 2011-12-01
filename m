Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab1LADRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 22:17:18 -0500
Received: from ozlabs.org ([203.10.76.45]:51712 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436Ab1LADRQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 22:17:16 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Pawel Moll <pawel.moll@arm.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization\@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH] virtio-mmio: Devices parameter parsing
In-Reply-To: <1322588190.3164.129.camel@hornet.cambridge.arm.com>
References: <1321365185-2928-1-git-send-email-pawel.moll@arm.com> <87sjlooq3m.fsf@rustcorp.com.au> <1321467222.3137.417.camel@hornet.cambridge.arm.com> <87vcqe9ml9.fsf@rustcorp.com.au> <1321886688.3093.248.camel@hornet.cambridge.arm.com> <1321898210.3093.263.camel@hornet.cambridge.arm.com> <87fwhhx9is.fsf@rustcorp.com.au> <1322071732.3093.491.camel@hornet.cambridge.arm.com> <87zkfht7dp.fsf@rustcorp.com.au> <1322588190.3164.129.camel@hornet.cambridge.arm.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 01 Dec 2011 12:36:39 +1030
Message-ID: <877h2ht58w.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Nov 2011 17:36:30 +0000, Pawel Moll <pawel.moll@arm.com> wrote:
> On Mon, 2011-11-28 at 00:31 +0000, Rusty Russell wrote:
> > Off the top of my head, this makes me think of the way initcalls are
> > ordered.  We could put a parameter parsing initcall at the start of each
> > initcall level in include/asm-generic/vmlinux.lds.h's INITCALLS macro.
> > 
> > Then we steal four bits from struct kernel_param's flags to indicate the
> > level of the initcall (-1 == existing ones, otherwise N == before level
> > N initcalls).
> 
> Yes, this was my initial idea as well. The only problem I faced is the
> fact that there is no "between levels"... It's easy to add parameters
> parsing _at_ any particular level, but hard to do this _after_ level A
> and _before_ level B. The initcalls section simply contains all the
> calls, ordered by the level - the only "separated" level is the pre-SMP
> early one. And order within one level is determined by the link order,
> so I can't guarantee parsing the parameters as the first call of a level
> (nor as the last call of the previous level).

Yeah, that's why I suggested changing the linker script.
>  /* This is the fundamental function for registering boot/module
>     parameters. */
> -#define __module_param_call(prefix, name, ops, arg, isbool, perm)	\
> +#define __module_param_call(prefix, name, ops, arg, isbool, late, perm)	\
>  	/* Default value instead of permissions? */			\
>  	static int __param_perm_check_##name __attribute__((unused)) =	\
>  	BUILD_BUG_ON_ZERO((perm) < 0 || (perm) > 0777 || ((perm) & 2))	\

Might as well change isbool to "flags", since we have to fix callers
anyway.

> diff --git a/init/main.c b/init/main.c
> index 217ed23..ce89a53 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -407,7 +407,7 @@ static int __init do_early_param(char *param, char *val)
>  
>  void __init parse_early_options(char *cmdline)
>  {
> -	parse_args("early options", cmdline, NULL, 0, do_early_param);
> +	parse_args("early options", cmdline, NULL, 0, 0, 0, do_early_param);

It'd be nice to replace the early param stuff too, but that's probably a
separate patch.  As is getting rid of the old __setup() calls everywhere
;)

But so far, it looks good!

Thanks,
Rusty.
