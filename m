Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab1C2RUS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 13:20:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:39807 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab1C2RUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 13:20:16 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=QQXixWDqseIA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=o3_xqOFF_69Tb2v62JoA:9 a=gIZkw7Ai5F78AfdYQ4cA:7 a=aNmSPNOc26n2Elua-EWVTGjx5ZwA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH] lockdep: Print a nice description of an irq
 locking issue
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <1301418845.14261.284.camel@gandalf.stny.rr.com>
References: <1301418845.14261.284.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 29 Mar 2011 13:20:14 -0400
Message-ID: <1301419214.14261.289.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-29 at 13:14 -0400, Steven Rostedt wrote:
>    
>      ---
>     other info that might help us debug this:
>     
>     Chain exists of:
>       &rq->lock --> lockA --> lockC
>     
>      Possible interrupt unsafe locking scenario:
>     
>            CPU0                    CPU1
>            ----                    ----
>       lock(lockC);
>                                    local_irq_disable();
>                                    lock(&rq->lock);
>                                    lock(lockA);
>       <Interrupt>
>         lock(&rq->lock)
>     
>      *** DEADLOCK ***
>     

Note, the above output is real. To produce this output, I wrote a module
that created a "lockA", "lockB" and "lockC" and had the following:

        spin_lock_irq(&lockA);
        spin_lock(&lockB);
        spin_unlock(&lockB);
        spin_unlock_irq(&lockA);

        spin_lock_irq(&lockB);
        spin_lock(&lockC);
        spin_unlock(&lockC);
        spin_unlock_irq(&lockB);

        spin_lock(&lockC);
        spin_unlock(&lockC);
        ret = register_trace_sched_switch(probe_switch, NULL);

static void
probe_switch(void *ignore, struct task_struct *p, struct task_struct *n)
{
        unsigned long flags;

        spin_lock_irqsave(&lockA, flags);
        spin_unlock_irqrestore(&lockA, flags);
}


probe_switch is called via the trace_sched_switch() trace point that is
called with the rq lock held, producing the call chain that will trigger
lockdep to produce a dump.

-- Steve




