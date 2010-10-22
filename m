Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613Ab0JVQKq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 12:10:46 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:37333 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755374Ab0JVQKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 12:10:45 -0400
Date: Fri, 22 Oct 2010 09:10:32 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2 v2] rcu,cleanup: simplify the code when cpu is dying
Message-ID: <20101022161032.GA2391@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4CBE8872.1010905@cn.fujitsu.com>
 <20101020192503.GH2386@linux.vnet.ibm.com>
 <4CC13EB1.6020800@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC13EB1.6020800@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 03:35:13PM +0800, Lai Jiangshan wrote:
> On 10/21/2010 03:25 AM, Paul E. McKenney wrote:
> > On Wed, Oct 20, 2010 at 02:13:06PM +0800, Lai Jiangshan wrote:
> >> When we handle cpu notify DYING, the whole system is stopped except
> >> current CPU, so we can touch any data, and we remove the orphan_cbs_tail
> >> and send the callbacks to the dest CPU directly.
> > 
> > Queued along with the documentation/comment patch below, thank you!!!
> > (Of course, please let me know if you see problems with my patch.)
> 
> Your patch is good for me, please queue it, thanks.

Very good, done!

> > One remaining question...  You use cpumask_any() to select the destination
> > CPU, which sounds good until you look at its definition.  The problem
> > is that cpumask_any() always chooses the lowest-numbered online CPU.
> > So imagine a (say) 64-CPU system and suppose that CPU 0 remains online.
> > Suppose further that the other 63 CPUs each execute some workload that
> > generates lots of RCU callbacks (perhaps creating then removing a large
> > source tree), and periodically go offline and come back online.
> > 
> > All of the RCU callbacks from CPUs 1-63 could easily end up getting
> > dumped onto CPU 0's callback lists.  It is easy to imagine that CPU 0
> > might not be able to invoke these callbacks as fast as the other CPUs
> > could generate them.
> > 
> > Or am I missing something?
> 
> It happens in the worst case. It may also happen before this patch.
> 
> Before this patch, the callback move to the receive-CPU who handles the CPU_DEAD
> event, and this CPU may be always cpu#0 in the worst case, the problem happens.
> 
> And it's not help if I introduce a choose_receive_cpu_very_smart(),
> Suppose further that the other 63 CPUs each execute some workload that
> generates lots of RCU callbacks (perhaps creating then removing a large
> source tree), and periodically go offline and come back online. In worse
> case, in some period, there is only cpu#0 online, So all of the RCU callbacks
> from CPUs 1-63 could easily end up getting dumped onto CPU 0's callback lists. 
> It is easy to imagine that CPU 0 might not be able to invoke these callbacks
> as fast as the other CPUs could generate them.
> 
> Another bad case(it may happens without this patch/with this patch
> /with choose_receive_cpu_very_smart()):
> 	Live-Lock, suppose cpu#A and cpu#B periodically go offline and come
> 	back online, the callback may be moved from A to B and from B to A
> 	periodically, no callback is handled.

Agreed, it -could- happen before in the worst case, but it required very
bad luck for the task adopting the callbacks to always be the same.
In contrast, cpumask_any() will always pick on the same CPU.

That said, your approach called out below is intriguing...

> To fix these problems(it does really very hardly happen), we must force
> all adopted callbacks are called before next cpu-offline. so we can use
> work_on_cpu() or rcu_barrier() to do this. To make the code simpler, I will
> use rcu_barrier().

This approach is nice, but requires extensive testing -- a start would
be a script that randomly onlines and offlines CPUs while rcutorture
is running in the background.  If you have not already done so, could
you please give this an over-the-weekend test on the largest system
you have access to?

							Thanx, Paul
