Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab1IZBKe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 21:10:34 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33673 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244Ab1IZBKd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 21:10:33 -0400
MIME-Version: 1.0
In-Reply-To: <20110926010418.GA18553@somewhere>
References: <20110925002409.GA24220@shutemov.name>
	<20110925050826.GC2995@linux.vnet.ibm.com>
	<20110925112637.GA19298@shutemov.name>
	<20110925130622.GA9205@somewhere.redhat.com>
	<20110925164804.GD2995@linux.vnet.ibm.com>
	<20110926010418.GA18553@somewhere>
Date: Mon, 26 Sep 2011 03:10:33 +0200
Message-ID: <CAFTL4hy4t4z2GX=Tj5wjVv=BSGaSbcspDw3FGUy_2uK=9HU_2A@mail.gmail.com>
Subject: Re: linux-next-20110923: warning kernel/rcutree.c:1833
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-kernel@vger.kernel.org,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/26 Frederic Weisbecker <fweisbec@gmail.com>:
> On Sun, Sep 25, 2011 at 09:48:04AM -0700, Paul E. McKenney wrote:
>> This is required for RCU_FAST_NO_HZ, which checks to see whether the
>> current CPU can accelerate the current grace period so as to enter
>> dyntick-idle mode sooner than it would otherwise.  This takes effect
>> in the situation where rcu_needs_cpu() sees that there are callbacks.
>> It then notes a quiescent state (which is illegal in an RCU read-side
>> critical section), calls force_quiescent_state(), and so on.  For this
>> to work, the current CPU must be in an RCU read-side critical section.
>
> You mean it must *not* be in an RCU read-side critical section (ie: in a
> quiescent state)?
>
> That assumption at least fails anytime in idle for the RCU
> sched flavour given that preemption is disabled in the idle loop.
>
>> If this cannot be made to work, another option is to call a new RCU
>> function in the case where rcu_needs_cpu() returned false, but after
>> the RCU read-side critical section has exited.
>
> You mean when rcu_needs_cpu() returns true (when we have callbacks
> enqueued)?
>
>> This new RCU function
>> could then attempt to rearrange RCU so as to allow the CPU to enter
>> dyntick-idle mode more quickly.  It is more important for this to
>> happen when the CPU is going idle than when it is executing a user
>> process.
>>
>> So, is this doable?
>
> At least not when we have RCU sched callbacks enqueued, given preemption
> is disabled. But that sounds plausible in order to accelerate the switch
> to dyntick-idle mode when we only have rcu and/or rcu bh callbacks.

But the RCU sched case could be dealt with if we embrace every use of
it with rcu_read_lock_sched() and rcu_read_unlock_sched(), or some light
version that just increases a local counter that rcu_needs_cpu() could check.

It's an easy thing to add: we can ensure preempt is disabled when we call it
and we can force rcu_dereference_sched() to depend on it.
