Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163Ab2IUPMl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 11:12:41 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:33504 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755926Ab2IUPMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 11:12:39 -0400
Date: Fri, 21 Sep 2012 08:12:03 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Michael Wang <wangyun@linux.vnet.ibm.com>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: RCU idle CPU detection is broken in linux-next
Message-ID: <20120921151203.GA2454@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <5050CCE0.4090403@gmail.com>
 <20120919153934.GB2455@linux.vnet.ibm.com>
 <5059F458.3000407@gmail.com>
 <20120919170648.GF2455@linux.vnet.ibm.com>
 <505AC6C8.9060706@linux.vnet.ibm.com>
 <505AC979.7000008@gmail.com>
 <20120920152341.GE2449@linux.vnet.ibm.com>
 <505C33B9.8000807@gmail.com>
 <20120921121346.GD2458@linux.vnet.ibm.com>
 <505C6B03.7020305@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <505C6B03.7020305@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12092115-5806-0000-0000-000019D6F698
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 03:26:27PM +0200, Sasha Levin wrote:
> On 09/21/2012 02:13 PM, Paul E. McKenney wrote:
> >> This might be unrelated, but I got the following dump as well when trinity
> >> > decided it's time to reboot my guest:
> > OK, sounds like we should hold off until you reproduce, then.
> 
> I'm not sure what you mean.
> 
> There are basically two issues I'm seeing now, which reproduce pretty much every
> time:
> 
>  1. The "using when idle" warning.
>  2. The rcu related hangs during shutdown.
> 
> The first one appears early on when I start fuzzing, the other one happens when
> shutting down - so both of them are reproducible in the same session.

Ah, I misunderstood the "reboot my guest" -- I thought that you were
doing something like repeated modprobe/rmmod cycles on rcutorture while
running the guest for an extended time period.  That will teach me not
to reply to email so soon after waking up.  ;-)

That said, #2 is expected behavior given the RCU CPU stall warnings in
your Sept. 20 dmesg.  This is because rcutorture does rcu_barrier() on
the way out, which cannot complete if grace periods are not completing.
And the later soft lockup is also likely a consequence of the stall,
because CPU hotplug does a synchronize_sched() while holding the hotplug
lock, which will then cause get_online_cpus() to hang.

Looking further down, there are hung tasks that are waiting for a
timeout, but this is also a consequence of the hang because they
are waiting for MAX_SCHEDULE_TIMEOUT -- in other words, they are
waiting to be killed at shutdown time.  I could suppress this by using
schedule_timeout_interruptible() in a loop in order to reduce the noise
in this case.

The remaining traces in that email are also consequences of the stall.

So why the stall?

Using RCU from a CPU that RCU believes to be idle can cause arbitrary
bad behavior (possibly including stalls), but with very low probability.
The reason that things can go arbitrarily bad is that RCU is ignoring
the CPU, and thus not waiting for any RCU read-side critical sections.
This could of course result in abitrary corruption of memory.  The reason
for the low probability is that grace periods tend to be long and RCU
read-side critical sections tend to be short.

It looks like you are running -next, which has RCU grace periods driven
by a kthread.  Is it possible that this kthread is not getting a chance
to run (in fact, the "Stall ended before state dump start" is consistent
with that possibility), but in that case I would expect to see a soft
lockup from it.  Furthermore, in that case, it would be expected to
start running again as soon as things started going idle during shutdown.

Or did the system somehow manage to stay busy despite being in shutdown?
Or, for that matter, are you overcommitting the physical CPUs on your
trinity test setup?

							Thanx, Paul

