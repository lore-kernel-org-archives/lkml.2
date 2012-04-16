Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638Ab2DPWKJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 18:10:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755573Ab2DPWJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 18:09:59 -0400
Date: Tue, 17 Apr 2012 00:09:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Chuck Ebbert <chuckebbert.lk@gmail.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] i387: ptrace breaks the lazy-fpu-restore logic
Message-ID: <20120416220925.GA29434@redhat.com>
References: <20120414235238.GA11131@redhat.com> <CA+55aFxJykAy4=9WVOnUOy1PUBYLmPy9mJmydoYZpQEbSkfvJQ@mail.gmail.com> <20120415223808.GA26214@redhat.com> <CA+55aFwpts0X=V67+wUchJN9Bgjh17eZJqOo0Y0oc2Mzbfa7QA@mail.gmail.com> <CA+55aFzeLqBMJ_tGyKh7EJhqWwPkD7DfggZ=NDmxwi3gYNjkdA@mail.gmail.com> <20120416204756.GA24884@redhat.com> <20120416204815.GB24884@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120416204815.GB24884@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Damn, I forgot to add

Cc: <stable@vger.kernel.org> # 3.3

On 04/16, Oleg Nesterov wrote:
> Starting from 7e16838d "i387: support lazy restore of FPU state"
> we assume that fpu_owner_task doesn't need restore_fpu_checking()
> on the context switch, its FPU state should match what we already
> have in the FPU on this CPU.
> 
> However, debugger can change the tracee's FPU state, in this case
> we should reset fpu.last_cpu to ensure fpu_lazy_restore() can't
> return true.
> 
> Change init_fpu() to do this, it is called by user_regset->set()
> methods.
> 
> Reported-by: Jan Kratochvil <jan.kratochvil@redhat.com>
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  arch/x86/kernel/i387.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/i387.c b/arch/x86/kernel/i387.c
> index 7734bcb..2d6e649 100644
> --- a/arch/x86/kernel/i387.c
> +++ b/arch/x86/kernel/i387.c
> @@ -235,6 +235,7 @@ int init_fpu(struct task_struct *tsk)
>  	if (tsk_used_math(tsk)) {
>  		if (HAVE_HWFP && tsk == current)
>  			unlazy_fpu(tsk);
> +		tsk->thread.fpu.last_cpu = ~0;
>  		return 0;
>  	}
>  
> -- 
> 1.5.5.1
> 

