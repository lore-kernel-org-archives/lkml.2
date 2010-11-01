Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab0KAV1Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 17:27:24 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61855 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755113Ab0KAV1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 17:27:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EVJl9TICGMk6waOheNGtmonrlAOlGnP5vdA3Mfi9LG6XMdsgDoDUs76u9ehXtoF6Gi
         q2bLh3YEvgKE4tDzz6IG7jexxLZR8tNqkejWOtRWdckE4tR6RcfQfHsn0yGtIL9fRem6
         FaXhvV5wWCt/W2lT5GGJTZ3CqEWeRJVTJxW6Q=
Date: Mon, 1 Nov 2010 22:27:11 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net, x86@kernel.org
Subject: Re: [PATCH 01/11] x86,kgdb: fix debugger hw breakpoint test
	regression in 2.6.35
Message-ID: <20101101212709.GB5919@nowhere>
References: <1287780991-7476-1-git-send-email-jason.wessel@windriver.com> <1287780991-7476-2-git-send-email-jason.wessel@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287780991-7476-2-git-send-email-jason.wessel@windriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 03:56:21PM -0500, Jason Wessel wrote:
> HW breakpoints events stopped working correctly with kgdb as a result
> of commit: 018cbffe6819f6f8db20a0a3acd9bab9bfd667e4 (Merge commit
> 'v2.6.33' into perf/core), later commit:
> ba773f7c510c0b252145933926c636c439889207 (x86,kgdb: Fix hw breakpoint
> regression) allowed breakpoints to propagate to the debugger core but
> did not completely address the original regression in functionality
> found in 2.6.35.
> 
> When the DR_STEP flag is set in dr6 along with any of the DR_TRAP
> bits, the kgdb exception handler will enter once from the
> hw_breakpoint API call back and again from the die notifier for
> do_debug(), which causes the debugger to stop twice and also for the
> kgdb regression tests to fail running under kvm with:
> 
> echo V2I1 > /sys/module/kgdbts/parameters/kgdbts
> 
> To address the problem, the kgdb overflow handler needs to implement
> the same logic as the ptrace overflow handler call back with respect
> to updating the virtual copy of dr6.  This will allow the kgdb
> do_debug() die notifier to properly handle the exception and the
> attached debugger, or kgdb test suite, will only receive a single
> notification.
> 
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> CC: x86@kernel.org
> ---
>  arch/x86/kernel/kgdb.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
> index 852b819..497f973 100644
> --- a/arch/x86/kernel/kgdb.c
> +++ b/arch/x86/kernel/kgdb.c
> @@ -621,7 +621,12 @@ int kgdb_arch_init(void)
>  static void kgdb_hw_overflow_handler(struct perf_event *event, int nmi,
>  		struct perf_sample_data *data, struct pt_regs *regs)
>  {
> -	kgdb_ll_trap(DIE_DEBUG, "debug", regs, 0, 0, SIGTRAP);
> +	struct task_struct *tsk = current;
> +	int i;
> +
> +	for (i = 0; i < 4; i++)
> +		if (breakinfo[i].enabled)
> +			tsk->thread.debugreg6 |= (DR_TRAP0 << i);
>  }



Ok so there are several things:

First, if DR_STEP is set, you must ignore the DR_TRAP bits because
single step exceptions and breakpoint exceptions don't happen at the
same time: single step has a higher priority and intel manuals say
if we are in a single step exception, the DR_TRAP bits are random.
This is something I will fix soon, and this should fix your issue
as well.

Second, why are you sending a signal to userspace? Is it how a kgdb
client is notified? So it means kgdb breakpoints were broken since
the hw-breakpoint rewrite?

Third, we should perhaps do the reverse thing than we do now: keep thread.debugreg6 = dr6
as is and clear its bits from the perf handler. That looks more sane if only perf
doesn't want to send signals after breakpoints events. And callbacks will know which
breakpoint fired. This avoids you to randomly enable every status bits of all
running breakpoints every time a single one fire.


