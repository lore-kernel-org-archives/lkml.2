Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533Ab0LNCm2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 21:42:28 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:19223 "EHLO
	TX2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab0LNCm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 21:42:27 -0500
X-SpamScore: -21
X-BigFish: VPS-21(zzbb2dK936eK1432N98dN103dKzz1202hzzz2fh2a8h637h668h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4D06D968.9070004@am.sony.com>
Date: Mon, 13 Dec 2010 18:41:44 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: <frank.rowand@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
CC: Chris Mason <chris.mason@oracle.com>, "axboe@kernel.dk" <axboe@kernel.dk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>, Oleg Nesterov <oleg@redhat.com>,
        tglx <tglx@linutronix.de>
Subject: Re: [PATCH RFC] reduce runqueue lock contention
References: <20100520204810.GA19188@think>	 <1277114522.1875.469.camel@laptop>  <1277117647.1875.503.camel@laptop> <1277125479.1875.510.camel@laptop>
In-Reply-To: <1277125479.1875.510.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/10 06:04, Peter Zijlstra wrote:
> On Mon, 2010-06-21 at 12:54 +0200, Peter Zijlstra wrote:
>>> It looses the ttwu task_running() check, as I must admit I'm not quite
>>> sure what it does.. Ingo?
> 
> I think I figured out what its for, its for when p is prev in schedule()
> after deactivate_task(), we have to call activate_task() it again, but
> we cannot migrate the task because the CPU its on is still referencing
> it.

I have not been able to make sense of the task_running() check in
try_to_wake_up(), even with that clue.  The try_to_wake_up() code in
question is:

        rq = task_rq_lock(p, &flags);
        if (!(p->state & state))
                goto out;

        if (p->se.on_rq)
                goto out_running;

        cpu = task_cpu(p);
        orig_cpu = cpu;

#ifdef CONFIG_SMP
        if (unlikely(task_running(rq, p)))
                goto out_activate;


The relevent code in schedule() executes with the rq lock held (many
lines left out to emphasize the key lines):

        raw_spin_lock_irq(&rq->lock);

        if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {

                       deactivate_task(rq, prev, DEQUEUE_SLEEP);

        if (likely(prev != next)) {
                rq->curr = next;
                context_switch(rq, prev, next); /* unlocks the rq */
        } else
                raw_spin_unlock_irq(&rq->lock);


If (p->se.on_rq) can becomes false due to deactivate_task()
then task_running() will also become false while the rq lock is still
held (either via "rq->curr = next" or via context_switch() updating
p->oncpu -- which one matters depends on #ifdef __ARCH_WANT_UNLOCKED_CTXSW).

I  haven't been able to find any case where task_running() can be true
when (p->se.on_rq) is false, while the rq lock is not being held.  Thus
I don't think the branch to out_activate will ever be taken.

What am I missing, or is the task_running() test not needed?

Thanks!

Frank

