Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932718Ab1EYUrq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 16:47:46 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:45806 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932237Ab1EYUrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 16:47:43 -0400
Date: Wed, 25 May 2011 13:47:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
        mingo@redhat.com, hpa@zytor.com, tglx@linutronix.de
Subject: Re: [tip:core/rcu] Revert "rcu: Decrease memory-barrier usage
 based on semi-formal proof"
Message-ID: <20110525204739.GJ2341@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4DDAD934.9010603@kernel.org>
 <4DDAE5FA.2030303@kernel.org>
 <4DDAE6A5.6060701@kernel.org>
 <20110524011824.GL7428@linux.vnet.ibm.com>
 <4DDB093F.2060601@kernel.org>
 <20110524013523.GO7428@linux.vnet.ibm.com>
 <4DDC21E1.1070502@kernel.org>
 <4DDC48E3.1060108@kernel.org>
 <20110525045253.GB2262@linux.vnet.ibm.com>
 <20110525072742.GI429@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110525072742.GI429@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 25, 2011 at 09:27:42AM +0200, Ingo Molnar wrote:
> 
> * Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:
> 
> > On Tue, May 24, 2011 at 05:10:11PM -0700, Yinghai Lu wrote:
> > > On 05/24/2011 02:23 PM, Yinghai Lu wrote:
> > > > On 05/23/2011 06:35 PM, Paul E. McKenney wrote:
> > > >> On Mon, May 23, 2011 at 06:26:23PM -0700, Yinghai Lu wrote:
> > > >>> On 05/23/2011 06:18 PM, Paul E. McKenney wrote:
> > > >>>
> > > >>>> OK, so it looks like I need to get this out of the way in order to track
> > > >>>> down the delays.  Or does reverting PeterZ's patch get you a stable
> > > >>>> system, but with the longish delays in memory_dev_init()?  If the latter,
> > > >>>> it might be more productive to handle the two problems separately.
> > > >>>>
> > > >>>> For whatever it is worth, I do see about 5% increase in grace-period
> > > >>>> duration when switching to kthreads.  This is acceptable -- your
> > > >>>> 30x increase clearly is completely unacceptable and must be fixed.
> > > >>>> Other than that, the main thing that affects grace period duration is
> > > >>>> the setting of CONFIG_HZ -- the smaller the HZ value, the longer the
> > > >>>> grace-period duration.
> > > >>>
> > > >>> for my 1024g system when memory hotadd is enabled in kernel config:
> > > >>> 1. current linus tree + tip tree:  memory_dev_init will take about 100s.
> > > >>> 2. current linus tree + tip tree + your tree - Peterz patch: 
> > > >>>    a. on fedora 14 gcc: will cost about 4s: like old times
> > > >>>    b. on opensuse 11.3 gcc: will cost about 10s.
> > > >>
> > > >> So some patch in my tree that is not yet in tip makes things better?
> > > >>
> > > >> If so, could you please see which one?  Maybe that would give me a hint
> > > >> that could make things better on opensuse 11.3 as well.
> > > > 
> > > > today's tip:
> > > > 
> > > > [   31.795597] cpu_dev_init done
> > > > [   40.930202] memory_dev_init done
> > > > 
> > > 
> > > another boot from tip got:
> > > 
> > > [   35.211927] cpu_dev_init done
> > > [  136.053698] memory_dev_init done
> > > 
> > > wonder if you can have clean revert for
> > > 
> > > commit a26ac2455ffcf3be5c6ef92bc6df7182700f2114
> > > > Author: Paul E. McKenney <paul.mckenney@linaro.org>
> > > > Date:   Wed Jan 12 14:10:23 2011 -0800
> > > > 
> > > >     rcu: move TREE_RCU from softirq to kthread
> > > >     
> > > >     If RCU priority boosting is to be meaningful, callback invocation must
> > > >     be boosted in addition to preempted RCU readers.  Otherwise, in presence
> > > >     of CPU real-time threads, the grace period ends, but the callbacks don't
> > > >     get invoked.  If the callbacks don't get invoked, the associated memory
> > > >     doesn't get freed, so the system is still subject to OOM.
> > > >     
> > > >     But it is not reasonable to priority-boost RCU_SOFTIRQ, so this commit
> > > >     moves the callback invocations to a kthread, which can be boosted easily.
> > > >     
> > > >     Also add comments and properly synchronized all accesses to
> > > >     rcu_cpu_kthread_task, as suggested by Lai Jiangshan.
> > > >     
> > > >     Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > > >     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > >     Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> > 
> > There is a new branch yinghai.2011.05.24a on:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
> > 
> > Or will be as soon as kernel.org updates its mirrors.
> > 
> > I am not sure I could call this "clean", but it does revert that commit
> > and 11 of the subsequent commits that depend on it.  It does build,
> > and I will test it once my currently running tests complete.
> 
> Given that this is about a 1-2 minute delays with 1 *terabyte* of RAM, the per 
> gigabyte delay is like 60-120 msecs, right?
> 
> So it's not a regression we are absolutely forced to address via a quick 
> revert, debugging it would be nicer. There's something we don't understand and 
> that's arguably worse than having unresolved non-fatal bugs :-)

And my attempted revert results in test failures in any case.  :-(

> We already fixed the worst problem via a revert, the semi-hang: so i don't 
> think there's pressure to do other reverts - other than for diagnostic 
> purposes, of course.

Given that I have to debug in any case, I am happier debugging in the
forward direction rather than in the backwards direction.  ;-)

							Thanx, Paul
