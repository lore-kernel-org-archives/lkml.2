Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab1EZH30 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 03:29:26 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51410 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab1EZH3Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 03:29:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=KHU/Ix0cthYCTm6I2NuJg9l5LhTLuo1QrNGmDlp88MWtUw6gfcroWw1vaGwhzg3GDe
         bVvDr+vOn8gnp7tyR8GKwWY0hgyq9HziPFCa/wQL3fqc4EDe0EZ/29trAYjOgCNKpMzt
         ljPEGiuAD9UYJlqYtszAOfBxQVcBpPhFrL3b0=
MIME-Version: 1.0
In-Reply-To: <1306358128.21578.107.camel@twins>
References: <1306260792.27474.133.camel@e102391-lin.cambridge.arm.com>
	<1306272750.2497.79.camel@laptop>
	<1306343335.21578.65.camel@twins>
	<1306358128.21578.107.camel@twins>
Date: Thu, 26 May 2011 15:29:23 +0800
Message-ID: <BANLkTi=XbTXQsu3jUEvQyCfBy6-aRnqSpw@mail.gmail.com>
Subject: Re: [BUG] "sched: Remove rq->lock from the first half of ttwu()"
 locks up on ARM
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, Ingo Molnar <mingo@elte.hu>,
        Frank Rowand <frank.rowand@am.sony.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 26, 2011 at 5:15 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, 2011-05-25 at 19:08 +0200, Peter Zijlstra wrote:
>> Ooh, shiny, whilst typing this I got an NMI-watchdog error reporting me
>> that CPU1 got stuck in try_to_wake_up(), so it looks like I can indeed
>> reproduce some funnies.
>>
>> /me goes dig in.
>
> Does the below make your ARM box happy again?
>
> It restores the old ttwu behaviour for this case and seems to not mess
> up my x86 with __ARCH_WANT_INTERRUPTS_ON_CTXSW.
>
> Figuring out why the existing condition failed

Seems  'current' will change before/after switch_to since it's derived from
sp register.
So that means if interrupt come before we switch sp, 'p == current' will
catch it, but if interrupt comes after we switch sp, we will lose a wake up.

Thanks,
Yong

> and writing a proper
> changelog requires a mind that is slightly less deprived of sleep and I
> shall attempt that tomorrow -- provided this does indeed work for you.
>
> ---
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 2d12893..6976eac 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2573,7 +2573,19 @@ static void ttwu_queue_remote(struct task_struct *p, int cpu)
>        if (!next)
>                smp_send_reschedule(cpu);
>  }
> -#endif
> +
> +#ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
> +static void ttwu_activate_remote(struct task_struct *p, int wake_flags)
> +{
> +       struct rq *rq = __task_rq_lock(p);
> +
> +       ttwu_activate(rq, p, ENQUEUE_WAKEUP | ENQUEUE_WAKING);
> +       ttwu_do_wakeup(rq, p, wake_flags);
> +
> +       __task_rq_unlock(rq);
> +}
> +#endif /* __ARCH_WANT_INTERRUPTS_ON_CTXSW */
> +#endif /* CONFIG_SMP */
>
>  static void ttwu_queue(struct task_struct *p, int cpu)
>  {
> @@ -2630,18 +2642,11 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
>         */
>        while (p->on_cpu) {
>  #ifdef __ARCH_WANT_INTERRUPTS_ON_CTXSW
> -               /*
> -                * If called from interrupt context we could have landed in the
> -                * middle of schedule(), in this case we should take care not
> -                * to spin on ->on_cpu if p is current, since that would
> -                * deadlock.
> -                */
> -               if (p == current) {
> -                       ttwu_queue(p, cpu);
> -                       goto stat;
> -               }
> -#endif
> +               ttwu_activate_remote(p, wake_flags);
> +               goto stat;
> +#else
>                cpu_relax();
> +#endif
>        }
>        /*
>         * Pairs with the smp_wmb() in finish_lock_switch().
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Only stand for myself
