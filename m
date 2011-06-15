Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab1FOO6a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 10:58:30 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:58236 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519Ab1FOO63 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 10:58:29 -0400
Date: Wed, 15 Jun 2011 07:58:03 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: mingo@elte.hu
Cc: daniel.blueman@gmail.com, shaohua.li@intel.com, alex.shi@intel.com,
        levinsasha928@gmail.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl
Subject: Re: [GIT PULL rcu/urgent] fixes for slowdowns and softlockup
Message-ID: <20110615145803.GA3521@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110615044107.GA5571@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110615044107.GA5571@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 14, 2011 at 09:41:07PM -0700, Paul E. McKenney wrote:
> Hello, Ingo,
> 
> This pull request fixes a softlockup and a severe performance regression.

Resending, this time copying LKML and a few additional people.
For those for whom this is a duplicate, please accept my apologies.

						Thanx, Paul

> Shaohua Li debugged a performance regression and found that RCU's shiny
> new real-time kthreads were causing excessive lock contention in the
> scheduler on large systems, resulting in severe performance regressions.
> Shaohua also provided a patch that converts the RCU core back to softirq,
> but still uses a real-time kthread to invoke the callbacks.  This allows
> RCU priority boosting to work, while greatly reducing the stress on
> the scheduler.  Shaohua's patch was tested by Alex Shi and Sasha Levin.
> 
> What was intended to be a code-cleanup patch fixes a softlockup
> problem reported by Daniel J Blueman.  The problem was that the RCU
> priority boosting kthread would not necessarily be awakened in a timely
> fashion.  Because kthreads are created in TASK_UNINTERRUPTIBLE state,
> if a newly created kthread is left alone for more than two minutes,
> softlockup warnings will be issued.  This problem was fixed by the
> code simplification -- because the binding of this kthread is only a
> performance optimization, we can awaken it before any of its CPUs are
> fully online, which eliminates the delay that could otherwise lead to
> the softlockup.
> 
> These changes are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git rcu/urgent
> 
>   							Thanx, Paul
> 
> ------------------>
> 
> Paul E. McKenney (1):
>       rcu: Simplify curing of load woes
> 
> Shaohua Li (1):
>       rcu: Use softirq to address performance regression
> 
>  Documentation/filesystems/proc.txt  |    1 +
>  include/linux/interrupt.h           |    1 +
>  include/trace/events/irq.h          |    3 +-
>  kernel/rcutree.c                    |   88 ++++++++++++++++-------------------
>  kernel/rcutree.h                    |    1 +
>  kernel/rcutree_plugin.h             |   20 ++++----
>  kernel/softirq.c                    |    2 +-
>  tools/perf/util/trace-event-parse.c |    1 +
>  8 files changed, 57 insertions(+), 60 deletions(-)
