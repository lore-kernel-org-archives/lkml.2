Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136Ab1CaO7c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 10:59:32 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:49652 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab1CaO7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 10:59:31 -0400
Date: Thu, 31 Mar 2011 07:59:18 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: excessive kworker activity when idle. (was Re: vma corruption
 in today's -git)
Message-ID: <20110331145918.GE2258@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110329040939.GA32764@redhat.com>
 <AANLkTi=PHtUpb5oJ8_r1K1dvaUunhxv1MS3LLPM8V4Ci@mail.gmail.com>
 <20110331030917.GB26057@redhat.com>
 <20110331033432.GA434@redhat.com>
 <AANLkTimPi-Vbi3DNLEeShCpfOJEuUZo3--3CQ_BMgJiS@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimPi-Vbi3DNLEeShCpfOJEuUZo3--3CQ_BMgJiS@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 08:44:06PM -0700, Linus Torvalds wrote:
> On Wed, Mar 30, 2011 at 8:34 PM, Dave Jones <davej@redhat.com> wrote:
> >
> > so 'perf kmem record sleep 5' shows hundreds of calls kmem_cache_free from
> > the kworker processes. Called from shmem_i_callback, __d_free and file_free_rcu.
> > My guess is that my fuzzing caused so many allocations that the rcu freeing is
> > still ongoing an hour or so after the process has quit.  does that make any sense?
> 
> No, that shouldn't be the case. RCU freeing should go on for just a
> few RCU periods, and be done. I think there is some "limit the work we
> do for rcu each time" in order to not have bad latencies, but even so
> that shouldn't take _that_ long. And as you say, you should see the
> freeing in the slab stats.
> 
> So clearly there are shmem inodes being destroyed, but it shouldn't be
> from an hour ago. I wonder if your system isn't as idle as you think
> it is.
> 
> But I'm cc'ing Paul, maybe he'll disagree and say it's expected and
> that the RCU batch size is really small. Or at least give some hint
> about how to check the pending rcu state.

There is by default a ten-callback-per-softirq per-CPU limit (set by
module parameter "blimit"), but if there are more than 10,000 callbacks
queued (set by module parameter "qhimark"), RCU stops being Mr.  Nice Guy
and just plows through the callbacks.

I am having a really hard time believing that you could queue a batch of
callbacks and still have RCU processing them an hour later.  But one way
this can happen is if the callbacks requeue themselves, for example, if
the RCU callback function contains a call to call_rcu().  I am not seeing
that in the __d_free and file_free_rcu callbacks that Dave mentioned,
but this does happen in some places in the Linux kernel.  And maybe such
a place is being invoked in a non-obvious way.

There is a debugfs file "rcu/rcudata" that reports the current RCU queue
length that is enabled with CONFIG_RCU_TRACE.  Here is sample output:

rcu_sched:
  0 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=10951/1 dn=0 df=1101 of=0 ri=36 ql=0 b=10
  1 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=16117/1 dn=0 df=1015 of=0 ri=0 ql=0 b=10
  2 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=1445/1 dn=0 df=1839 of=0 ri=0 ql=0 b=10
  3 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=6681/1 dn=0 df=1545 of=0 ri=0 ql=0 b=10
  4 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=1003/1 dn=0 df=1992 of=0 ri=0 ql=0 b=10
  5 c=17829 g=17830 pq=1 pqc=17829 qp=1 dt=3887/1 dn=0 df=3331 of=0 ri=4 ql=2 b=10
  6 c=17829 g=17829 pq=1 pqc=17829 qp=0 dt=859/1 dn=0 df=3224 of=0 ri=0 ql=0 b=10
  7 c=17829 g=17830 pq=0 pqc=17829 qp=1 dt=3761/1 dn=0 df=1818 of=0 ri=0 ql=2 b=10
rcu_bh:
  0 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=10951/1 dn=0 df=0 of=0 ri=0 ql=0 b=10
  1 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=16117/1 dn=0 df=13 of=0 ri=0 ql=0 b=10
  2 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=1445/1 dn=0 df=15 of=0 ri=0 ql=0 b=10
  3 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=6681/1 dn=0 df=9 of=0 ri=0 ql=0 b=10
  4 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=1003/1 dn=0 df=15 of=0 ri=0 ql=0 b=10
  5 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=3887/1 dn=0 df=15 of=0 ri=0 ql=0 b=10
  6 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=859/1 dn=0 df=15 of=0 ri=0 ql=0 b=10
  7 c=-275 g=-275 pq=1 pqc=-275 qp=0 dt=3761/1 dn=0 df=15 of=0 ri=0 ql=0 b=10

The "ql=" gives the per-CPU callback queue size.  For example, CPU 7 has
two rcu_sched callbacks queued.  In CONFIG_TREE_PREEMPT_RCU builds, there
will be an additional "rcu_preempt" section.  If you see some huge number
after a "ql=", that would indicate a problem.  ;-)

Does this help?

							Thanx, Paul
