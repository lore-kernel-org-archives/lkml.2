Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab0KMRZA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 12:25:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754699Ab0KMRYz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 12:24:55 -0500
Date: Sat, 13 Nov 2010 18:17:22 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, ddaney@caviumnetworks.com, arnd@arndb.de,
        benh@kernel.crashing.org, cmetcalf@tilera.com, davem@davemloft.net,
        deller@gmx.de, heiko.carstens@de.ibm.com, hpa@zytor.com,
        jejb@parisc-linux.org, kyle@mcmartin.ca, mingo@elte.hu,
        roland@redhat.com, schwidefsky@de.ibm.com, tglx@linutronix.de,
        tony.luck@intel.com
Subject: Re: +
	exec_domain-establish-a-linux32-domain-on-config_compat-systems.patc
	h added to -mm tree
Message-ID: <20101113171722.GA2956@redhat.com>
References: <201011122022.oACKM6HH029696@imap1.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201011122022.oACKM6HH029696@imap1.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12, Andrew Morton wrote:
>
> From: David Daney <ddaney@caviumnetworks.com>
>
> If PER_LINUX32 is set calling sys_personality, we will try to find the
> corresponding exec_domain.  This causes us to try to load a module for
> personality-8.  After running the userspace module loader and failing to
> find the module, we fall back to the default.

Cough. It is not easy to me comment this patch ;)

Personally, I think this change is fine. But, despite the fact
the code in exec_domain.c is very trivial, I was never able to really
understand its rationality. And the usage of ->personality has some
oddities.

In particular, I can't parse default_exec_domain() at all. And,
what exec_domain->handler() actually does? I do not see anything
in arch/ which uses EXEC_DOMAIN offsets.

Perhaps someone from CC can explain this?


> We can avoid the failed module loading overhead by building-in the
> linux32_exec_domain for systems that have CONFIG_COMPAT.

Indeed. But at the same time this means it is not possible to use
personality-8.ko if the system has it.

Don't get me wrong, I have no idea why anyone could want this module,
just I am a bit worried.

> +#ifdef CONFIG_COMPAT
> +static struct exec_domain linux32_exec_domain = {
> +	.name		= "Linux32",		/* name */
> +	.handler	= default_handler,	/* lcall7 causes a seg fault. */
> +	.pers_low	= PER_LINUX32,
> +	.pers_high	= PER_LINUX32,
> +	.signal_map	= ident_map,		/* Identity map signals. */
> +	.signal_invmap	= ident_map,		/*  - both ways. */
> +};
> +#endif
> +
>  struct exec_domain default_exec_domain = {
>  	.name		= "Linux",		/* name */
>  	.handler	= default_handler,	/* lcall7 causes a seg fault. */
> @@ -41,6 +52,9 @@ struct exec_domain default_exec_domain =
>  	.pers_high	= 0,			/* PER_LINUX personality. */
>  	.signal_map	= ident_map,		/* Identity map signals. */
>  	.signal_invmap	= ident_map,		/*  - both ways. */
> +#ifdef CONFIG_COMPAT
> +	.next		= &linux32_exec_domain,
> +#endif
>  };

OK, but please look at arch/s390/kernel/compat_exec_domain.c and
arch/ia64/mm/init.c, they also register PER_LINUX32 domain, not
good. And note that register_exec_domain() doesn't check
pers_low/high, this means linux32_exec_domain can silently supress
s390_exec_domain/ia32_exec_domain.

Oleg.

