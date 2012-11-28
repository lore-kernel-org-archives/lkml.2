Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab2K1WMx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 17:12:53 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:54100 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756065Ab2K1WMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 17:12:51 -0500
Message-ID: <1354140755.3588.27.camel@thor>
Subject: Re: [BUG -next-20121127] kernel BUG at kernel/softirq.c:471!
From: Peter Hurley <peter@hurleysoftware.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Xiaotian Feng <dannyfeng@tencent.com>,
        Xiaotian Feng <xtfeng@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, linux-next@vger.kernel.org
Date: Wed, 28 Nov 2012 17:12:35 -0500
In-Reply-To: <1354125623.2788.23.camel@thor>
References: <1351824534-2861-1-git-send-email-xtfeng@gmail.com>
	 <20121105145207.6d2fae92.akpm@linux-foundation.org>
	 <CAJn8CcF=2=XBV0T661LnAxHi8+fT8KAVapCFaiDZgS6TyieNOA@mail.gmail.com>
	 <20121105173707.94602896.akpm@linux-foundation.org>
	 <1354125623.2788.23.camel@thor>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.2.4-0build1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[cc'ing linux-next]

On Wed, 2012-11-28 at 13:00 -0500, Peter Hurley wrote:
> Hi all,
> 
> I couldn't find the v2 patch of this on linux-kernel but this commit
> 
>   4660e32 "tasklet: ignore disabled tasklet in tasklet_action()"
> 
> BUGS in -next-20121127.
> 
> -----------[cut here ]----------
> kernel BUG at /home/peter/src/kernels/next/kernel/softirq.c:471!
> invalid opcode: 0000 [#1] PREEMPT SMP
> ....
> 
> The registers/stack dump isn't useful so I didn't include it here.
> 
> I'm still trying to track down the execution sequence that causes this,
> but the high-level trigger is a firewire bus reset.
> 
> Hopefully I'll have more information soon.

>From the original v1 of this patch [where is v2?] ...

On Fri, 2012-11-02 at 10:48 +0800, Xiaotian Feng wrote:
> We met a ksoftirqd 100% issue, the perf top shows kernel is busy
> with tasklet_action(), but no actual action is shown. From dumped
> kernel, there's only one disabled tasklet on the tasklet_vec.
> 
> tasklet_action might be handled after tasklet is disabled, this will
> make disabled tasklet stayed on tasklet_vec. tasklet_action will not
> handle disabled tasklet, but place it on the tail of tasklet_vec,
> still raise softirq for this tasklet. Things will become worse if
> device driver uses tasklet_disable on its device remove/close code.
> The disabled tasklet will stay on the vec, frequently __raise_softirq_off()
> and make ksoftirqd wakeup even if no tasklets need to be handled.
> 
> This patch introduced a new TASKLET_STATE_HI bit to indicate HI_SOFTIRQ,
> in tasklet_action(), simply ignore the disabled tasklet and don't raise
> the softirq nr. In my previous patch, I remove tasklet_hi_enable() since
> it is the same as tasklet_enable(). So only tasklet_enable() needs to be
> modified, if tasklet state is changed from disable to enable, use
> __tasklet_schedule() to put it on the right vec.
> 
> Signed-off-by: Xiaotian Feng <dannyfeng@tencent.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---
>  include/linux/interrupt.h |   12 ++++++++++--
>  kernel/softirq.c          |   10 +++++-----
>  2 files changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
> index 5e4e617..7e5bb00 100644
> --- a/include/linux/interrupt.h
> +++ b/include/linux/interrupt.h
> @@ -521,7 +521,8 @@ struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(1), func, data }
>  enum
>  {
>  	TASKLET_STATE_SCHED,	/* Tasklet is scheduled for execution */
> -	TASKLET_STATE_RUN	/* Tasklet is running (SMP only) */
> +	TASKLET_STATE_RUN,	/* Tasklet is running (SMP only) */
> +	TASKLET_STATE_HI	/* Tasklet is HI_SOFTIRQ */
>  };
>  
>  #ifdef CONFIG_SMP
> @@ -593,7 +594,14 @@ static inline void tasklet_disable(struct tasklet_struct *t)
>  static inline void tasklet_enable(struct tasklet_struct *t)
>  {
>  	smp_mb__before_atomic_dec();
> -	atomic_dec(&t->count);
> +	if (atomic_dec_and_test(&t->count)) {
> +		if (!test_bit(TASKLET_STATE_SCHED, &t->state))
> +			return;
> +		if (test_bit(TASKLET_STATE_HI, &t->state))
> +			__tasklet_hi_schedule(t);
> +		else
> 

Since this isn't protected by locks, all of the conditions that __were__
met to arrive here (t->count == 0 && t->state & TASKLET_STATE_SCHED) may
no longer be true now because another cpu may have run tasklet_action(),
so now this tasklet will be scheduled when it should not be.

Plus __tasklet_schedule() can't just be called from any cpu that happens
to be calling tasklet_enable(). What you're doing here means that the
tasklet could be scheduled on multiple cpus at the same time -- that's
not going to work.

+			__tasklet_schedule(t);
> 


