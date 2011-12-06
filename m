Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672Ab1LFQQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 11:16:25 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:52300 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112Ab1LFQQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 11:16:24 -0500
Date: Tue, 6 Dec 2011 08:11:10 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Yong Zhang <yong.zhang0@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu 7/7] rcu: Quiet RCU-lockdep warnings
 involving interrupt disabling
Message-ID: <20111206161110.GD2325@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20111203183417.GA18914@linux.vnet.ibm.com>
 <1322937282-19846-7-git-send-email-paulmck@linux.vnet.ibm.com>
 <20111205091924.GA28117@zhy>
 <20111205164505.GB2326@linux.vnet.ibm.com>
 <20111206012635.GA32498@zhy>
 <1323165152.32012.51.camel@twins>
 <1323167246.32012.60.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323167246.32012.60.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11120616-5930-0000-0000-000002ECFCF9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 11:27:26AM +0100, Peter Zijlstra wrote:
> On Tue, 2011-12-06 at 10:52 +0100, Peter Zijlstra wrote:
> > On Tue, 2011-12-06 at 09:26 +0800, Yong Zhang wrote:
> > 
> > > Yeah, because we call might_sleep() in rt_mutex_lock() unconditionally.
> > > But in this case the 'BUG: sleeping function called from invalid context
> > > at *' is obviously false positive.
> > 
> > Why can't this mutex acquisition not block?
> 
> Gaah!! I see, this 5342e269 patch is revolting.. guys that's really vile
> don't do that!
> 
> I tried reading the RCU code but I gave up.. rcu_boost() does:
> 
>   rt_mutex_init_proxy_locked();
>   raw_spin_unlock_irqrestore();
>   rt_mutex_lock();
>   rt_mutex_unlock();
> 
> vs rcu_read_unlock_special()'s RCU_READ_UNLOCK_BLOCKED branch:
> 
>   rt_mutex_unlock();
> 
> 
> The latter looks to be unbalanced because I can't actually find a
> matching lock. Also, all of that is ran with IRQs enabled. So what's the
> problem?

The rt_mutex_init_proxy_locked() creates the lock in held state,
held by the RCU reader who is holding up the grace period.
So rcu_read_unlock_special()'s rt_mutex_unlock() is balanced by the
rt_mutex_init_proxy_locked().

The problem with the IRQs enabled is the following sequence:

	rcu_read_lock();
	/* do stuff */
	local_irq_save(flags);
	/* do more stuff */
	rcu_read_unlock();
	/* do even more stuff */
	local_irq_restore(flags);

This has been legal in the past, and might well be used in places that
-rt does not exercise, hence the desire to explicitly legalize it.

							Thanx, Paul

