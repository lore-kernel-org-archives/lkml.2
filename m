Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095Ab1BWQlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 11:41:45 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:36190 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754879Ab1BWQlo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 11:41:44 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=x5lYFldHaXAA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=V3uPyP-92uv3RMKLG0cA:9 a=pqKMKEnthuSll5uxJiMA:7 a=JA12IbQPuWDukOJ5SJH6WmZbr1QA:4 a=PUjeQqilurYA:10 a=m7dB5c_xsyASV2UR:21 a=CquaIQMWIIkNkfT1:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH RFC tip/core/rcu 11/11] rcu: move TREE_RCU from softirq
 to kthread
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
In-Reply-To: <20110223161645.GA1819@nowhere>
References: <20110223013917.GA20996@linux.vnet.ibm.com>
	 <1298425183-21265-11-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20110223161645.GA1819@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 23 Feb 2011 11:41:42 -0500
Message-ID: <1298479302.7666.94.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-23 at 17:16 +0100, Frederic Weisbecker wrote:
> On Tue, Feb 22, 2011 at 05:39:40PM -0800, Paul E. McKenney wrote:
> > +/*
> > + * Wake up the current CPU's kthread.  This replaces raise_softirq()
> > + * in earlier versions of RCU.
> > + */
> > +static void invoke_rcu_kthread(void)
> > +{
> > +	unsigned long flags;
> > +	wait_queue_head_t *q;
> > +	int cpu;
> > +
> > +	local_irq_save(flags);
> > +	cpu = smp_processor_id();
> > +	if (per_cpu(rcu_cpu_kthread_task, cpu) == NULL) {
> > +		local_irq_restore(flags);
> > +		return;
> > +	}
> > +	per_cpu(rcu_cpu_has_work, cpu) = 1;
> > +	q = &per_cpu(rcu_cpu_wq, cpu);
> 
> I see you make extensive use of per_cpu() accessors even for
> local variables.
> 
> I tend to think it's better to use __get_cpu_var() for local
> accesses and keep per_cpu() for remote accesses.
> 
> There are several reasons for that:
> 
> * __get_cpu_var() checks we are in a non-preemptible section,
> per_cpu() doesn't. That may sound of a limited interest for code like the
> above, but by the time code can move, and then we might lose track of some
> things, etc...

Ah, but so does smp_processor_id() ;-)

> 
> * local accesses can be optimized by architectures. per_cpu() implies
> finding the local cpu number, and dereference an array of cpu offsets with
> that number to find the local cpu offset.
> __get_cpu_var() does a direct access to __my_cpu_offset which is a nice
> shortcut if the arch implements it.

True, but we could also argue that the multiple checks for being preempt
can also be an issue.

> 
> * It makes code easier to review: we know that __get_cpu_var() is
> for local accesses and per_cpu() for remote.

This I'll agree with you.

In the past, I've thought about which one is better (per_cpu() vs
__get_cpu_var()).

But, that last point is a good one. Just knowing that this is for the
local CPU helps with the amount of info your mind needs to process when
looking at this code. And the mind needs all the help it can get when
reviewing this code ;-)

-- Steve

> 
> > +	wake_up(q);
> > +	local_irq_restore(flags);
> > +}


