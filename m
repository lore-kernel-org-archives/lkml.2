Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933409Ab2JWV1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:27:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932832Ab2JWV1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 17:27:07 -0400
Date: Tue, 23 Oct 2012 17:26:48 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Oleg Nesterov <oleg@redhat.com>
cc: Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] percpu-rw-semaphores: use light/heavy barriers
In-Reply-To: <20121023192318.GA25872@redhat.com>
Message-ID: <Pine.LNX.4.64.1210231724320.2689@file.rdu.redhat.com>
References: <CA+55aFwV-WOUx8MSr145f+HSrtmZ=nXHq0VLhtPyH=FNBFwmQg@mail.gmail.com>
 <20121017165902.GB9872@redhat.com> <20121017224430.GC2518@linux.vnet.ibm.com>
 <20121018162409.GA28504@redhat.com> <20121018163833.GK2518@linux.vnet.ibm.com>
 <20121018175747.GA30691@redhat.com> <20121019192838.GM2518@linux.vnet.ibm.com>
 <Pine.LNX.4.64.1210221910150.25995@file.rdu.redhat.com>
 <Pine.LNX.4.64.1210221936570.25995@file.rdu.redhat.com> <20121023165912.GA18712@redhat.com>
 <20121023192318.GA25872@redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 23 Oct 2012, Oleg Nesterov wrote:

> On 10/23, Oleg Nesterov wrote:
> >
> > Not really the comment, but the question...
> 
> Damn. And another question.
> 
> Mikulas, I am sorry for this (almost) off-topic noise. Let me repeat
> just in case that I am not arguing with your patches.
> 
> 
> 
> 
> So write_lock/write_unlock needs to call synchronize_sched() 3 times.
> I am wondering if it makes any sense to try to make it a bit heavier
> but faster.
> 
> What if we change the reader to use local_irq_disable/enable around
> this_cpu_inc/dec (instead of rcu read lock)? I have to admit, I have
> no idea how much cli/sti is slower compared to preempt_disable/enable.
> 
> Then the writer can use
> 
> 	static void mb_ipi(void *arg)
> 	{
> 		smp_mb(); /* unneeded ? */
> 	}
> 
> 	static void force_mb_on_each_cpu(void)
> 	{
> 		smp_mb();
> 		smp_call_function(mb_ipi, NULL, 1);
> 	}
> 
> to a) synchronise with irq_disable and b) to insert the necessary mb's.
> 
> Of course smp_call_function() means more work for each CPU, but
> write_lock() should be rare...
> 
> This can also wakeup the idle CPU's, but probably we can do
> on_each_cpu_cond(cond_func => !idle_cpu). Perhaps cond_func() can
> also return false if rcu_user_enter() was called...
> 
> Actually I was thinking about this from the very beginning, but I do
> not feel this looks like a good idea. Still I'd like to ask what do
> you think.
> 
> Oleg.

I think - if we can avoid local_irq_disable/enable, just avoid it (and use 
barrier-vs-synchronize_kernel).

Mikulas
