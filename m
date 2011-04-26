Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab1DZNq3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 09:46:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:34654 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755444Ab1DZNq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 09:46:28 -0400
X-Authority-Analysis: v=1.1 cv=ZtuXOl23UuD1yoJUTgnZ6i6Z5VPlPhPMWCeUNtN8OGA= c=1 sm=0 a=XYJHFtupD_QA:10 a=Q-f9MIRv_TgA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=qmZRBXI9V2DU_IBCoIAA:9 a=yxraQSO0sP65Tu5J5XoA:7 a=CjuIK1q_8ugA:10 a=jEp0ucaQiEUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Tue, 26 Apr 2011 09:46:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: masami.hiramatsu.pt@hitachi.com, linux-kernel@vger.kernel.org,
        mingo@elte.hu
Subject: Re: [PATCH] kprobes,x86: disable irq durinr optimized callback
Message-ID: <20110426134625.GA21840@home.goodmis.org>
References: <1303822891-8450-1-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1303822891-8450-1-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 03:01:31PM +0200, Jiri Olsa wrote:
> hi,
> 
> attached patch is disabling irqs during optimized callback,
> so we dont miss any in-irq kprobes as missed.
> 
> Also I think there's small window where current_kprobe variable
> could be touched in non-safe way, but I was not able to hit
> any issue.
> 
> I'm not sure wether this is a bug or if it was intentional to have
> irqs enabled during the pre_handler callback.

That's not very convincing. Did you see if we actually did miss events.
If that's the case then it is a bug. The conversion to optimizing should
not cause events to be missed.


> 
> wbr,
> jirka
> 
> ---
> Disabling irqs during optimized callback, so we dont miss
> any in-irq kprobes as missed.
> 
> Interrupts are also disabled during non-optimized kprobes callbacks.
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  arch/x86/kernel/kprobes.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
> index c969fd9..917cb31 100644
> --- a/arch/x86/kernel/kprobes.c
> +++ b/arch/x86/kernel/kprobes.c
> @@ -1183,11 +1183,13 @@ static void __kprobes optimized_callback(struct optimized_kprobe *op,
>  					 struct pt_regs *regs)
>  {
>  	struct kprobe_ctlblk *kcb = get_kprobe_ctlblk();
> +	unsigned long flags;
>  
>  	/* This is possible if op is under delayed unoptimizing */
>  	if (kprobe_disabled(&op->kp))
>  		return;
>  
> +	local_irq_save(flags);
>  	preempt_disable();

No reason to disable preemption if you disabled interrupts.

>  	if (kprobe_running()) {
>  		kprobes_inc_nmissed_count(&op->kp);
> @@ -1208,6 +1210,7 @@ static void __kprobes optimized_callback(struct optimized_kprobe *op,
>  		__this_cpu_write(current_kprobe, NULL);
>  	}
>  	preempt_enable_no_resched();

Remove the preempt_enable_no_resched() as well.

BTW, what's up with all these preempt_enable_no_resched()'s laying
around in the kprobe code? Looks to me that this can cause lots of
missing wakeups (preemption leaks). Which would make this horrible for
real-time.

-- Steve

> +	local_irq_restore(flags);
>  }
>  
>  static int __kprobes copy_optimized_instructions(u8 *dest, u8 *src)
