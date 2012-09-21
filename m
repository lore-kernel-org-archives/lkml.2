Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab2IUPSj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 11:18:39 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46866 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101Ab2IUPSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 11:18:38 -0400
Message-ID: <505C855F.3060301@gmail.com>
Date: Fri, 21 Sep 2012 17:18:55 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120913 Thunderbird/15.0.1
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Michael Wang <wangyun@linux.vnet.ibm.com>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: RCU idle CPU detection is broken in linux-next
References: <5050CCE0.4090403@gmail.com> <20120919153934.GB2455@linux.vnet.ibm.com> <5059F458.3000407@gmail.com> <20120919170648.GF2455@linux.vnet.ibm.com> <505AC6C8.9060706@linux.vnet.ibm.com> <505AC979.7000008@gmail.com> <20120920152341.GE2449@linux.vnet.ibm.com> <505C33B9.8000807@gmail.com> <20120921121346.GD2458@linux.vnet.ibm.com> <505C6B03.7020305@gmail.com> <20120921151203.GA2454@linux.vnet.ibm.com>
In-Reply-To: <20120921151203.GA2454@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/21/2012 05:12 PM, Paul E. McKenney wrote:
> On Fri, Sep 21, 2012 at 03:26:27PM +0200, Sasha Levin wrote:
>> On 09/21/2012 02:13 PM, Paul E. McKenney wrote:
>>>> This might be unrelated, but I got the following dump as well when trinity
>>>>> decided it's time to reboot my guest:
>>> OK, sounds like we should hold off until you reproduce, then.
>>
>> I'm not sure what you mean.
>>
>> There are basically two issues I'm seeing now, which reproduce pretty much every
>> time:
>>
>>  1. The "using when idle" warning.
>>  2. The rcu related hangs during shutdown.
>>
>> The first one appears early on when I start fuzzing, the other one happens when
>> shutting down - so both of them are reproducible in the same session.
> 
> Ah, I misunderstood the "reboot my guest" -- I thought that you were
> doing something like repeated modprobe/rmmod cycles on rcutorture while
> running the guest for an extended time period.  That will teach me not
> to reply to email so soon after waking up.  ;-)
> 
> That said, #2 is expected behavior given the RCU CPU stall warnings in
> your Sept. 20 dmesg.  This is because rcutorture does rcu_barrier() on
> the way out, which cannot complete if grace periods are not completing.
> And the later soft lockup is also likely a consequence of the stall,
> because CPU hotplug does a synchronize_sched() while holding the hotplug
> lock, which will then cause get_online_cpus() to hang.
> 
> Looking further down, there are hung tasks that are waiting for a
> timeout, but this is also a consequence of the hang because they
> are waiting for MAX_SCHEDULE_TIMEOUT -- in other words, they are
> waiting to be killed at shutdown time.  I could suppress this by using
> schedule_timeout_interruptible() in a loop in order to reduce the noise
> in this case.
> 
> The remaining traces in that email are also consequences of the stall.
> 
> So why the stall?
> 
> Using RCU from a CPU that RCU believes to be idle can cause arbitrary
> bad behavior (possibly including stalls), but with very low probability.
> The reason that things can go arbitrarily bad is that RCU is ignoring
> the CPU, and thus not waiting for any RCU read-side critical sections.
> This could of course result in abitrary corruption of memory.  The reason
> for the low probability is that grace periods tend to be long and RCU
> read-side critical sections tend to be short.
> 
> It looks like you are running -next, which has RCU grace periods driven
> by a kthread.  Is it possible that this kthread is not getting a chance
> to run (in fact, the "Stall ended before state dump start" is consistent
> with that possibility), but in that case I would expect to see a soft
> lockup from it.  Furthermore, in that case, it would be expected to
> start running again as soon as things started going idle during shutdown.
> 
> Or did the system somehow manage to stay busy despite being in shutdown?
> Or, for that matter, are you overcommitting the physical CPUs on your
> trinity test setup?

Nope, I originally had 4 vcpus in the guest with the host running 4 physical
cpus, but I've also tested it with just 2 vcpus and still see the warnings.


Thanks,
Sasha

