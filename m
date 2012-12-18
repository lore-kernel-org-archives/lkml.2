Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab2LRJNJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 04:13:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13129 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753136Ab2LRJNG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 04:13:06 -0500
Date: Tue, 18 Dec 2012 11:12:56 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Nickolai Zeldovich <nickolai@csail.mit.edu>
Cc: Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: fix i8254 counter 0 wraparound
Message-ID: <20121218091256.GG11016@redhat.com>
References: <1355571277-6096-1-git-send-email-nickolai@csail.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355571277-6096-1-git-send-email-nickolai@csail.mit.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2012 at 06:34:37AM -0500, Nickolai Zeldovich wrote:
> The kvm i8254 emulation for counter 0 (but not for counters 1 and 2)
> has at least two bugs in mode 0:
> 
> 1. The OUT bit, computed by pit_get_out(), is never set high.
> 
> 2. The counter value, computed by pit_get_count(), wraps back around to
>    the initial counter value, rather than wrapping back to 0xFFFF
>    (which is the behavior described in the comment in __kpit_elapsed,
>    the behavior implemented by qemu, and the behavior observed on AMD
>    hardware).
> 
> The bug stems from __kpit_elapsed computing the elapsed time mod the
> initial counter value (stored as nanoseconds in ps->period).  This is both
> unnecessary (none of the callers of kpit_elapsed expect the value to be
> at most the initial counter value) and incorrect (it causes pit_get_count
> to appear to wrap around to the initial counter value rather than 0xFFFF).
> Removing this mod from __kpit_elapsed fixes both of the above bugs.
> 
> Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Applied, thanks!

> ---
>  arch/x86/kvm/i8254.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
> index 11300d2..c1d30b2 100644
> --- a/arch/x86/kvm/i8254.c
> +++ b/arch/x86/kvm/i8254.c
> @@ -122,7 +122,6 @@ static s64 __kpit_elapsed(struct kvm *kvm)
>  	 */
>  	remaining = hrtimer_get_remaining(&ps->timer);
>  	elapsed = ps->period - ktime_to_ns(remaining);
> -	elapsed = mod_64(elapsed, ps->period);
>  
>  	return elapsed;
>  }
> -- 
> 1.7.10.4

--
			Gleb.
