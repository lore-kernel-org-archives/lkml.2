Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446Ab1CBWlP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 17:41:15 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:57130 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754516Ab1CBWlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 17:41:14 -0500
Date: Wed, 2 Mar 2011 14:41:08 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 11/11] rcu: move TREE_RCU from softirq
 to kthread
Message-ID: <20110302224108.GA23194@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110223013917.GA20996@linux.vnet.ibm.com>
 <1298425183-21265-11-git-send-email-paulmck@linux.vnet.ibm.com>
 <4D6765B6.1030401@cn.fujitsu.com>
 <20110225203219.GD2269@linux.vnet.ibm.com>
 <4D6B16A8.4050405@cn.fujitsu.com>
 <1298886437.2428.10174.camel@twins>
 <20110301001300.GD2331@linux.vnet.ibm.com>
 <1298990291.5226.870.camel@laptop>
 <20110302000703.GK2218@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110302000703.GK2218@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 04:07:03PM -0800, Paul E. McKenney wrote:
> On Tue, Mar 01, 2011 at 03:38:11PM +0100, Peter Zijlstra wrote:
> > On Mon, 2011-02-28 at 16:13 -0800, Paul E. McKenney wrote:

[ . . . ]

> > wait_event() will only actually wait if the condition is false, in the
> > start-up case above it will find the condition true and fall right
> > through to do stuff.
> 
> So as long as it is OK to call sched_setscheduler_nocheck() before
> the kthread is first awakened, we should be OK.

So the softlockup code kills me when I do it this way.  Or can kill me.
>From what I can se the problem is that it might be the case that no one
needs a particular RCU kthread for some time.  In addition, if the kthread
has not yet done the wait_event(), wake_up() won't know to wake it up.
The flag gets set, and all zero of the tasks blocked on the event's
queue are awakened, but the not-yet-awakened task still sleeps because
it has not yet done the wait_event().

So I am falling back to waking each thread up just after creation so
that they can be safely parked regardless of who needs which kthread at
what time in the future.

On the other hand, making these changes and testing them helped me find
and fix a number of subtle and not-so-subtle bugs in the TREE_RCU priority
boosting code, so I most certainly cannot argue with the outcome!  ;-)

							Thanx, Paul
