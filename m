Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754221Ab0DLV63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 17:58:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55459 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754077Ab0DLV62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 17:58:28 -0400
Date: Mon, 12 Apr 2010 14:57:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David VomLehn <dvomlehn@cisco.com>
Cc: to@dvomlehn-lnx2.corp.sa.net, "linux_arch"@dvomlehn-lnx2.corp.sa.net,
       linux_arch@dvomlehn-lnx2.corp.sa.net, linux-kernel@vger.kernel.org,
       maint_arch@dvomlehn-lnx2.corp.sa.net
Subject: Re: [PATCH 1/23] Make register values available to panic notifiers
Message-Id: <20100412145757.7d0297bb.akpm@linux-foundation.org>
In-Reply-To: <20100412060338.GA24296@dvomlehn-lnx2.corp.sa.net>
References: <20100412060338.GA24296@dvomlehn-lnx2.corp.sa.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Apr 2010 23:03:38 -0700
David VomLehn <dvomlehn@cisco.com> wrote:

> This patch makes panic() and die() registers available to, for example,
> panic notifier functions.  Panic notifier functions are quite useful
> for recording crash information, but they don't get passed the register
> values. This makes it hard to print register contents, do stack
> backtraces, etc. The changes in this patch save the register state when
> panic() is called and introduce a function for die() to call that allows
> it to pass in the registers it was passed.
> 
> Following this patch are more patches, one per architecture. These include
> two types of changes:
> o  A save_ptregs() function for the processor. I've taken a whack at
>    doing this for all of the processors. I have tested x86 and MIPS
>    versions. I was able to find cross compilers for ARM, ... and the
>    code compiles cleanly. Everything else, well, what you see is sheer
>    fantasy. You are welcome to chortle with merriment.
> o  When I could figure it out, I replaced the calls to panic() in
>    exception handling functions with calls to panic_with_regs() so
>    that everyone can leverage these changes without much effort. Again,
>    not all the code was transparent, so there are likely some places
>    that should have additional work done.
> 
> Note that the pointer to the struct pt_regs may be NULL. This is to
> accomodate those processors which don't have a working save_ptregs(). I'd
> love to eliminate this case by providing a save_ptregs() for all
> architectures, but I'll need help to so.
> 

It would make life easier if you could describe (or send) a means by
which arch maintainers can easily test these changes.

> --- a/kernel/panic.c
> +++ b/kernel/panic.c
>
> ...
>
> +/* Registers stored in calls to panic() */
> +static DEFINE_PER_CPU(struct pt_regs, panic_panic_regs);
> +static DEFINE_PER_CPU(const struct pt_regs *, panic_regs);
> +
> +/**
> + * get_panic_regs - return the current pointer to panic register values
> + */
> +const struct pt_regs *get_panic_regs()
> +{
> +	return __get_cpu_var(panic_regs);
> +}
> +EXPORT_SYMBOL(get_panic_regs);
> +
> +/**
> + * set_panic_regs - Set a pointer to the values of registers on panic()
> + * @new_regs:	Pointer to register values
> + *
> + * Returns: Pointer to the previous panic registers, if any.
> + */
> +const struct pt_regs *set_panic_regs(const struct pt_regs *new_regs)
> +{
> +	const struct pt_regs *old_regs, **pp_regs;
> +
> +	pp_regs = &__get_cpu_var(panic_regs);
> +	old_regs = *pp_regs;
> +	*pp_regs = new_regs;
> +	return old_regs;
> +}

What's going on here?  We define storage for a set of pt_regs and also
storage for a set of pt_regs pointers, and provide the ability for
callers to rewrite the thing which the pt_regs*'s point at.

Seems complex.  Why not simply provide a set of pt_regs and permit
callers to copy their own pt_regs sets into that area?

Secondly, this code implicitly assumes that the panicing code is pinned
to the panicing CPU and cannot be preempted and migrated to a different
CPU.  Is that true - do we take steps to ensure this anywhere?

Thirdly and relatedly, the code assumes that callers have disabled
preemption (otherwise __get_cpu_var->smp_processor_id() will whine). 
Where does this get reliably assured?

