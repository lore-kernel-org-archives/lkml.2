Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649Ab2CZPWY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 11:22:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14935 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303Ab2CZPWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 11:22:22 -0400
X-Authority-Analysis: v=2.0 cv=NYRkJh/4 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=X4MpolQEQ-25mMzaK08A:9 a=ONYRA_EH2MFLEK1_CkMA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1332775340.23924.102.camel@gandalf.stny.rr.com>
Subject: Re: CPU Hotplug rework
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rusty Russell <rusty@rustcorp.com.au>, paulmck@linux.vnet.ibm.com,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Milton Miller <miltonm@bga.com>, "mingo@elte.hu" <mingo@elte.hu>,
        Tejun Heo <tj@kernel.org>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Date: Mon, 26 Mar 2012 11:22:20 -0400
In-Reply-To: <1332769098.16159.111.camel@twins>
References: <4F674649.2000300@linux.vnet.ibm.com>
	 <87aa3cqht9.fsf@rustcorp.com.au> <1332240151.18960.401.camel@twins>
	 <874ntic1ze.fsf@rustcorp.com.au> <1332320519.18960.466.camel@twins>
	 <87d3859s9r.fsf@rustcorp.com.au> <20120322224919.GW2450@linux.vnet.ibm.com>
	 <877gya99uj.fsf@rustcorp.com.au> <20120324002347.GD2450@linux.vnet.ibm.com>
	 <87bonkchxk.fsf@rustcorp.com.au> <1332748920.16159.65.camel@twins>
	 <1332767386.23924.75.camel@gandalf.stny.rr.com>
	 <1332769098.16159.111.camel@twins>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-26 at 15:38 +0200, Peter Zijlstra wrote:
> On Mon, 2012-03-26 at 09:09 -0400, Steven Rostedt wrote:
> > On Mon, 2012-03-26 at 10:02 +0200, Peter Zijlstra wrote:
> > > On Mon, 2012-03-26 at 11:11 +1030, Rusty Russell wrote:
> > > > Obviously, having callbacks hanging around until the CPU comes back is
> > > > not viable, nor is blocking preempt during the callbacks.  Calling
> > > > get_online_cpus() is too heavy. 
> > > 
> > > -rt has patches (albeit somewhat ugly) to make get_online_cpus() a br
> > > style rw-lock. 
> > 
> > Unfortunately, -rt still has broken cpu hotplug.
> 
> This is still the issue where we take the hotplug lock for write, but
> then rely on other threads to complete -- say CPU_DOWN_PREPARE notifiers
> doing flush_workqueue(), and the worker kthread needing to acquire the
> hotplug lock for read, right?

Right, I did get it working, but required making the current "ugly" code
even uglier, and Thomas nack'd it for that reason. He wanted a clean up
on hotplug instead.

> 
> Yes, that is bothersome, but doesn't hinder the work required to get
> get_online_cpus() usably fast, right?

Yep. What we do in -rt currently (without my updates) is that we create
a thread pinned to the CPU going down. This thread counts the "readers"
that is on the CPU. That is, every user that wanted to do a
"get_online_cpus()", and as -rt allows preemption while doing so, there
may be more than one of these for a given CPU.

Once the count goes to zero, new tasks that enter this path will block
on the hotplug lock. Then the CPU task we created is done and the cpu
offline continues.

But then we call the cpu offline notifiers. Some of the notifiers wakeup
threads and tell them to exit using kthread_stop(). But if the thread it
waits for does something that will enter the above path, it will block
on the hotplug lock too, and cause a deadlock. Unfortunately, in -rt we
have the sleeping spinlocks go into this path, thus any thread that is
going down that grabs a sleeping spinlock will hit this deadlock.

There's also the case where the thread that is going offline, or even
the notifier itself, may be grabbing a lock, that happens to be held by
another thread that is on the offlining CPU but is blocked on the
hotplug lock. This also causes a deadlock.

The workaround I added was to do several things:

1) instead of blocking on the hotplug lock, try to migrate itself
instead. If it succeeds, then we don't need to worry about this thread.
But if the thread is pinned to the CPU, then we need to worry about it.
I first had it block only in this case, but that wasn't good enough, so
I let them just continue.

2) had the CPU thread that was created do a multi-phase. The first phase
it still waited for the cpu ref counter to go to zero, but instead of
having tasks block, tasks would instead try to migrate and if I could
not then just continue.

3) after all the notifiers are finished, notify the created CPU thread
to sync tasks. Now that the notifiers are done, we can make any
remaining task block. That is, the old method is done, where the CPU
thread waits for the ref counter to go to zero, and new tasks will block
on the hotplug lock. Because this happens after the notifiers, we do not
need to worry about the previous deadlocks.

The above changes mostly worked. Where it broke was paths in bringing up
the CPU that may call code with sleeping spin locks where preemption is
disabled. But this is actually unrelated to the cpu hotplug itself and
more related to the normal problems caused by sleeping spinlocks added
by -rt.

The above changes also required reverting the -rt changes done to
workqueue.


Now what are the issues we have:

1) We need to get tasks off the CPU going down. For most tasks this is
not an issue. But for CPU specific kernel threads, this can be an issue.
To get tasks off of the CPU is required before the notifiers are called.
This is to keep them from creating work on the CPU, because after the
notifiers, there should be no more work added to the CPU.

2) Some tasks are going to go down and exit. We can audit all the
notifier callbacks for CPU offlining, and see if we can just make them
dormant instead of killing them. As Rusty said, it may not be that
important to save the memory of these tasks.

3) Some tasks do not go offline, instead they just get moved to another
CPU. This is the case of ksoftirqd. As it is killed after the CPU is
down (POST_DEAD) (at least in -rt it is).


All that is needed now is, at the beginning of taking the CPU down is to
push off tasks from the CPU that may migrate. Then call the notifiers,
and then block the rest and take the CPU down. This seems to work fine.
It was just the implementation I proposed was a bit too ugly for
Thomas's taste.

-- Steve


