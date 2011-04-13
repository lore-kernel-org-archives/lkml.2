Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964805Ab1DMXWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 19:22:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48792 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964777Ab1DMXWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 19:22:18 -0400
Message-ID: <4DA63012.2090307@zytor.com>
Date: Wed, 13 Apr 2011 16:21:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Hans Rosenfeld <hans.rosenfeld@amd.com>
CC: mingo@elte.hu, brgerst@gmail.com, tglx@linutronix.de,
        suresh.b.siddha@intel.com, eranian@google.com, robert.richter@amd.com,
        Andreas.Herrmann3@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, xsave: fix non-lazy allocation of the xsave area
References: <20110407153029.GU13@escobedo.osrc.amd.com> <1302692301-695807-1-git-send-email-hans.rosenfeld@amd.com>
In-Reply-To: <1302692301-695807-1-git-send-email-hans.rosenfeld@amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2011 03:58 AM, Hans Rosenfeld wrote:
> A single static xsave area just for init is not enough, since there are
> more user processes that are directly executed by kernel threads. Use
> fpu_alloc(), and SIGKILL the process if that fails.
> 
> Signed-off-by: Hans Rosenfeld <hans.rosenfeld@amd.com>
> ---
>  arch/x86/include/asm/i387.h |    9 +++------
>  1 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/include/asm/i387.h b/arch/x86/include/asm/i387.h
> index 989c0ac..833b6f1 100644
> --- a/arch/x86/include/asm/i387.h
> +++ b/arch/x86/include/asm/i387.h
> @@ -329,15 +329,12 @@ static inline void fpu_copy(struct fpu *dst, struct fpu *src)
>  }
>  
>  extern void fpu_finit(struct fpu *fpu);
> -static union thread_xstate __init_xstate, *init_xstate = &__init_xstate;
>  
>  static inline void fpu_clear(struct fpu *fpu)
>  {
> -	if (!fpu_allocated(fpu)) {
> -		BUG_ON(init_xstate == NULL);
> -		fpu->state = init_xstate;
> -		init_xstate = NULL;
> -	}
> +	if (!fpu_allocated(fpu) && fpu_alloc(fpu))
> +		do_group_exit(SIGKILL);
> +
>  	memset(fpu->state, 0, xstate_size);
>  	fpu_finit(fpu);
>  	set_used_math();

Ideally this should be done earlier, while it is still possible to
ENOMEM the exec.  Specifically, it probably should be done from a new
arch hook at the top in flush_old_exec().  I'm not sure how much it
matters in practice, because if we are that memory-constrained we'll
probably die shortly anyway, and to a kernel thread it is probably not
that much of a difference if the exec'd process dies with SIGKILL or if
it gets ENOMEM from the exec() -- it will typically be visible only from
the parent thread anyway.

	-hpa

