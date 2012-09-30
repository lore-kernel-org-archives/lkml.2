Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751337Ab2I3Lb7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 07:31:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63819 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785Ab2I3Lb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 07:31:57 -0400
Message-ID: <50682D9E.4060102@redhat.com>
Date: Sun, 30 Sep 2012 13:31:42 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: paulmck@linux.vnet.ibm.com, Josh Boyer <jwboyer@redhat.com>,
        Christian Hoffmann <email@christianhoffmann.info>,
        LKML <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>, johnstul@us.ibm.com,
        tglx@linutronix.de
Subject: Re: INFO: rcu_preempt detected stalls on CPUs/tasks: { 1} (detected
 by 0, t=10002 jiffies)
References: <20120925150701.GA2502@linux.vnet.ibm.com> <20120926042237.GA18287@localhost> <20120926043445.GB2524@linux.vnet.ibm.com> <20120926081501.GA28485@localhost> <20120926164543.GD2467@linux.vnet.ibm.com> <20120927025400.GA11434@localhost> <20120927042849.GA6556@linux.vnet.ibm.com> <20120927044044.GA22753@localhost> <20120928033511.GB2480@linux.vnet.ibm.com> <506828BF.9050409@redhat.com> <20120930111812.GA18764@localhost>
In-Reply-To: <20120930111812.GA18764@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/30/2012 01:18 PM, Fengguang Wu wrote:
> On Sun, Sep 30, 2012 at 01:10:55PM +0200, Avi Kivity wrote:
>> On 09/28/2012 05:35 AM, Paul E. McKenney wrote:
>> > On Thu, Sep 27, 2012 at 12:40:44PM +0800, Fengguang Wu wrote:
>> >> On Wed, Sep 26, 2012 at 09:28:50PM -0700, Paul E. McKenney wrote:
>> >> > On Thu, Sep 27, 2012 at 10:54:00AM +0800, Fengguang Wu wrote:
>> >> > > On Wed, Sep 26, 2012 at 09:45:43AM -0700, Paul E. McKenney wrote:
>> >> > > > On Wed, Sep 26, 2012 at 04:15:01PM +0800, Fengguang Wu wrote:
>> > 
>> > [ . . . ]
>> > 
>> >> > > > But could you also please send your .config file and a description of
>> >> > > 
>> >> > > .config attached.
>> >> > > 
>> >> > > > the workload you are running?
>> >> > > 
>> >> > > It's basically the below commands. The exact initrd is not relevant in
>> >> > > this case because it's a boot time warning before user space is
>> >> > > started. The stalls roughly happen 1 time on every 10 boots.
>> >> > 
>> >> > Yow!!!
>> >> > 
>> >> > You have severe cross-CPU time-synchronization problems.  See for
>> >> > example the first dmesg, with the relevant part extracted right here.
>> >> > One CPU believes that it is about 37 seconds past boot, and the other
>> >> > CPU beleives that it is about 137 seconds past boot.  Given that large
>> >> > of a time difference, an RCU CPU stall warning is expected behavior.
>> >> 
>> >> Good spot! Yeah I noticed that huge timestamp gap, however didn't take
>> >> it seriously enough..
>> >> 
>> >> > Get your two CPUs in agreement about what time it is, and I bet that
>> >> > the CPU stall warnings will go away.
>> >> 
>> >> Possibly KVM related? Because the warnings show up in many test boxes
>> >> running KVM and so is not likely some hardware specific issue.
>> > 
>> > I vaguely recall seeing something recently.  But let's ask the KVM and
>> > timekeeping guys.
>> 
>> >From the logs it looks like hpet (why not kvmclock?) is used for the
> 
> Hi Avi! Thanks for looking into this. It seems you have the full logs
> attached in my previous email?
> 
> FYI, I've enabled CONFIG_KVM_CLOCK/CONFIG_KVM_GUEST for all bootable
> kernels and here is the related boot message:
> 
> [    0.000000] kvm-clock: Using msrs 4b564d01 and 4b564d00
> [    0.000000] kvm-clock: cpu 0, msr 0:1b7ec81, boot clock
> 
>> clock, it should not generate such drifts since it is a global clock.
>> Can you verify current_clocksource on a boot that actually failed (in
>> case the clocksource is switched during runtime)?
> 
> I see a line
> 
> [    2.011710] Switching to clocksource kvm-clock
> 
> w/o any indication of errors.

So, with kvmclock it works and with hpet it fails?  Strange, hpet is
simple while kvmclock is more complicated, I'd have expected the
opposite behaviour.



-- 
error compiling committee.c: too many arguments to function
