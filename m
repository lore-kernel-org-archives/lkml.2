Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab1HaOla (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 10:41:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36250 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab1HaOl0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 10:41:26 -0400
Subject: Re: [PATCH 05/32] nohz: Move rcu dynticks idle mode handling to
 idle enter/exit APIs
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>,
        Paul Menage <paul@paulmenage.org>
Date: Wed, 31 Aug 2011 16:41:00 +0200
In-Reply-To: <20110831133754.GA20598@somewhere>
References: <20110829175954.GF9748@somewhere.redhat.com>
	 <1314641160.2816.128.camel@twins>
	 <20110829233521.GK9748@somewhere.redhat.com>
	 <1314703315.2799.5.camel@twins>
	 <20110830143207.GP9748@somewhere.redhat.com>
	 <1314717993.5812.11.camel@twins>
	 <20110830153343.GW9748@somewhere.redhat.com>
	 <1314737918.19586.8.camel@twins>
	 <20110830222432.GD15953@somewhere.redhat.com>
	 <1314782245.23993.9.camel@twins> <20110831133754.GA20598@somewhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1314801660.3578.41.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-31 at 15:37 +0200, Frederic Weisbecker wrote:
> > Why? rcu-sched can use a context-switch counter, rcu-preempt doesn't
> > even need that. Remote cpus can notice those just fine.
> 
> If that's fine to only rely on context switches, which don't happen in
> a bounded time in theory, then ok.

But (!PREEMPT) rcu already depends on that, and suffers this lack of
time-bounds. What it does to expedite matters is force context switches,
but nowhere is it written the GP is bounded by anything sane.

> > But you then also start the tick again..
> 
> When we enter kernel? (minus interrupts)
> No we only call rcu_exit_nohz(). 

So thinking more about all this:

rcu_exit_nohz() will make remote cpus wait for us, this is exactly what
is needed because we might have looked at pointers. Lacking a tick we
don't progress our own state but that is fine, !PREEMPT RCU wouldn't
have been able to progress our state anyway since we haven't scheduled
(there's nothing to schedule to except idle, see below).

Then when we leave the kernel (or go idle) we re-enter rcu_nohz state,
and the other cpus will ignore our contribution (since we have entered a
QS and can't be holding any pointers) the other CPUs can continue and
complete the GP and run the callbacks.

I haven't fully considered PREEMPT RCU quite yet, but I'm thinking we
can get away with something similar.

So per the above we don't need the tick at all (for the case of
nr_running=[0,1]), RCU will sort itself out.

Now I forgot where all you send IPIs from, and I'll go look at these
patches once more.

As for call_rcu() for that we can indeed wake the tick (on leaving
kernel space or entering idle, no need to IPI since we can't process
anything before that anyway) or we could hand off our call list to a
'willing' victim.

But yeah, input from Paul would be nice...
