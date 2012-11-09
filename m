Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754807Ab2KIRBE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 12:01:04 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:50427 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355Ab2KIRBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 12:01:00 -0500
Date: Fri, 9 Nov 2012 08:59:58 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v2 1/1] percpu_rw_semaphore: reimplement to not
 block the readers unnecessarily
Message-ID: <20121109165958.GA2419@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+55aFx0yyke6V1+wgMPBN4QZ0w=YoV7yBRqp0uy6aGKbcmC5g@mail.gmail.com>
 <20121102180606.GA13255@redhat.com>
 <20121108134805.GA23870@redhat.com>
 <20121108134849.GB23870@redhat.com>
 <20121108120700.42d438f2.akpm@linux-foundation.org>
 <20121108210843.GF2519@linux.vnet.ibm.com>
 <Pine.LNX.4.64.1211081836180.7134@file.rdu.redhat.com>
 <20121109004136.GH2519@linux.vnet.ibm.com>
 <20121109032310.GA2438@linux.vnet.ibm.com>
 <20121109163538.GB26134@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121109163538.GB26134@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12110917-5518-0000-0000-000009280AB3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 09, 2012 at 05:35:38PM +0100, Oleg Nesterov wrote:
> On 11/08, Paul E. McKenney wrote:
> >
> > On Thu, Nov 08, 2012 at 04:41:36PM -0800, Paul E. McKenney wrote:
> > > On Thu, Nov 08, 2012 at 06:41:10PM -0500, Mikulas Patocka wrote:
> > > >
> > > > On Thu, 8 Nov 2012, Paul E. McKenney wrote:
> > > >
> > > > > On Thu, Nov 08, 2012 at 12:07:00PM -0800, Andrew Morton wrote:
> > > > > > On Thu, 8 Nov 2012 14:48:49 +0100
> > > > > > Oleg Nesterov <oleg@redhat.com> wrote:
> > > > > >
> > > > >
> > > > > The algorithm would work given rcu_read_lock()/rcu_read_unlock() and
> > > > > synchronize_rcu() in place of preempt_disable()/preempt_enable() and
> > > > > synchronize_sched().  The real-time guys would prefer the change
> > > > > to rcu_read_lock()/rcu_read_unlock() and synchronize_rcu(), now that
> > > > > you mention it.
> > > > >
> > > > > Oleg, Mikulas, any reason not to move to rcu_read_lock()/rcu_read_unlock()
> > > > > and synchronize_rcu()?
> > > >
> > > > preempt_disable/preempt_enable is faster than
> > > > rcu_read_lock/rcu_read_unlock for preemptive kernels.
> 
> Yes, I chose preempt_disable() because it is the fastest/simplest
> primitive and the critical section is really tiny.
> 
> But:
> 
> > > Significantly faster in this case?  Can you measure the difference
> > > from a user-mode test?
> 
> I do not think rcu_read_lock() or rcu_read_lock_sched() can actually
> make a measurable difference.
> 
> > Actually, the fact that __this_cpu_add() will malfunction on some
> > architectures is preemption is not disabled seems a more compelling
> > reason to keep preempt_enable() than any performance improvement.  ;-)
> 
> Yes, but this_cpu_add() should work.

Indeed!  But this_cpu_add() just does the preempt_enable() under the
covers, so not much difference from a latency viewpoint.

> > > Careful.  The real-time guys might take the same every-little-bit approach
> > > to latency that you seem to be taking for CPU cycles.  ;-)
> 
> Understand...
> 
> So I simply do not know. Please tell me if you think it would be
> better to use rcu_read_lock/synchronize_rcu or rcu_read_lock_sched,
> and I'll send the patch.

I doubt if it makes a measurable difference for either throughput or
latency.  One could argue that rcu_read_lock() would be better for
readability, but making sure that the preempt_disable() is clearly
commented as starting an RCU-sched read-side critical section would
be just as good.

So I am OK with the current preempt_disable() approach.

							Thanx, Paul

