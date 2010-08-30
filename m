Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab0H3TsP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 15:48:15 -0400
Received: from mother.openwall.net ([195.42.179.200]:42464 "HELO
	mother.openwall.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752718Ab0H3TsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 15:48:14 -0400
Date: Mon, 30 Aug 2010 23:48:06 +0400
From: Solar Designer <solar@openwall.com>
To: Roland McGrath <roland@redhat.com>
Cc: Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
        oss-security@lists.openwall.com, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Neil Horman <nhorman@tuxdriver.com>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] exec argument expansion can inappropriately trigger OOM-killer
Message-ID: <20100830194806.GC25870@openwall.com>
References: <20100827220258.GF4703@outflux.net> <20100830005648.431B7400D9@magilla.sf.frob.com> <20100830032331.GA22773@openwall.com> <20100830100616.78971400D9@magilla.sf.frob.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100830100616.78971400D9@magilla.sf.frob.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 30, 2010 at 03:06:16AM -0700, Roland McGrath wrote:
> And I say, if your userland process could really allocate another 200GB,
> then more power to you, you can do it with an exec too.  If you could do
> the same with a userland stack allocation, and spend all that time in
> strlen calls and then memcpy, you can do it inside execve too.  If it
> takes days, that's what you asked for, and it's your process.  It just
> ought to be every bit (or near enough) as preemptible and interruptible
> as that normal userland activity ought to be.

This makes sense to me.  However, introducing a new preemption point
may violate assumptions under which the code was written and reviewed
in the past.  In the worst case, we'd introduce/expose race conditions
allowing for privilege escalation.

> So, perhaps we want this (count already has a cond_resched in its loop):

Good point re: count() already having this (I think it did not in 2.2).

> @@ -400,6 +403,10 @@ static int copy_strings(int argc, const 
>  		int len;
>  		unsigned long pos;
>  
> +		if (signal_pending(current))
> +			return -ERESTARTNOINTR;
> +		cond_resched();

So, in current kernels, you're making it possible for more kinds of
things to change after prepare_binprm() but before
search_binary_handler().  We'd need to check for possible implications
of this.

I must admit I am not familiar with what additional kinds of things may
change when execution is preempted.  This made a significant difference
in some much older kernels (many years ago), but now that the kernel
makes a lot less use of locking most things may be changed by another
CPU even without preemption.  So does anyone have a list of what
additional risks we're exposed to, if any, when we allow preemption in
current kernels?

> Has someone reported this BUG_ON failure mode with a reproducer?

64bit_dos.c was supposed to be the reproducer, and I managed to get it
to work (as I've documented in another message earlier today).  The
prerequisites appeared to be (some of these might be specific to my
tests, though):

- 64-bit kernel with 32-bit userland support (e.g., CONFIG_IA32_EMULATION);
- 64-bit build of 64bit_dos.c;
- 32-bit build of the target program;
- no dynamic linking in the target program;
- "ulimit -s unlimited" before running the reproducer program;
- over 3 GB of RAM in the system.

> [...]  Rather than better enabling OOM killing, I think what really
> makes sense is for the nascent mm to be marked such that allocations in
> it (they'll be from get_arg_page->get_user_pages->handle_mm_fault) just
> fail with ENOMEM before it resorts to the OOM killer (or perhaps even to
> very aggressive pageout).  That should percolate back to the execve just
> failing with ENOMEM, which is nicer than OOM kill even if the OOM killer
> actually does pick exactly and only the right target.

I agree.

Thanks,

Alexander
