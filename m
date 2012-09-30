Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475Ab2I3MRt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 08:17:49 -0400
Received: from mga01.intel.com ([192.55.52.88]:26708 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751411Ab2I3MRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 08:17:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,513,1344236400"; 
   d="scan'208";a="228272317"
Date: Sun, 30 Sep 2012 19:59:37 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: paulmck@linux.vnet.ibm.com, Josh Boyer <jwboyer@redhat.com>,
        Christian Hoffmann <email@christianhoffmann.info>,
        LKML <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>, johnstul@us.ibm.com,
        tglx@linutronix.de
Subject: Re: INFO: rcu_preempt detected stalls on CPUs/tasks: { 1} (detected
 by 0, t=10002 jiffies)
Message-ID: <20120930115937.GA21989@localhost>
References: <20120926043445.GB2524@linux.vnet.ibm.com>
 <20120926081501.GA28485@localhost>
 <20120926164543.GD2467@linux.vnet.ibm.com>
 <20120927025400.GA11434@localhost>
 <20120927042849.GA6556@linux.vnet.ibm.com>
 <20120927044044.GA22753@localhost>
 <20120928033511.GB2480@linux.vnet.ibm.com>
 <506828BF.9050409@redhat.com>
 <20120930112308.GA18839@localhost>
 <50682DDE.7010002@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50682DDE.7010002@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 30, 2012 at 01:32:46PM +0200, Avi Kivity wrote:
> On 09/30/2012 01:23 PM, Fengguang Wu wrote:
> > On Sun, Sep 30, 2012 at 01:10:55PM +0200, Avi Kivity wrote:
> >> On 09/28/2012 05:35 AM, Paul E. McKenney wrote:
> >> > On Thu, Sep 27, 2012 at 12:40:44PM +0800, Fengguang Wu wrote:
> >> >> On Wed, Sep 26, 2012 at 09:28:50PM -0700, Paul E. McKenney wrote:
> >> >> > On Thu, Sep 27, 2012 at 10:54:00AM +0800, Fengguang Wu wrote:
> >> >> > > On Wed, Sep 26, 2012 at 09:45:43AM -0700, Paul E. McKenney wrote:
> >> >> > > > On Wed, Sep 26, 2012 at 04:15:01PM +0800, Fengguang Wu wrote:
> >> > 
> >> > [ . . . ]
> >> > 
> >> >> > > > But could you also please send your .config file and a description of
> >> >> > > 
> >> >> > > .config attached.
> >> >> > > 
> >> >> > > > the workload you are running?
> >> >> > > 
> >> >> > > It's basically the below commands. The exact initrd is not relevant in
> >> >> > > this case because it's a boot time warning before user space is
> >> >> > > started. The stalls roughly happen 1 time on every 10 boots.
> >> >> > 
> >> >> > Yow!!!
> >> >> > 
> >> >> > You have severe cross-CPU time-synchronization problems.  See for
> >> >> > example the first dmesg, with the relevant part extracted right here.
> >> >> > One CPU believes that it is about 37 seconds past boot, and the other
> >> >> > CPU beleives that it is about 137 seconds past boot.  Given that large
> >> >> > of a time difference, an RCU CPU stall warning is expected behavior.
> >> >> 
> >> >> Good spot! Yeah I noticed that huge timestamp gap, however didn't take
> >> >> it seriously enough..
> >> >> 
> >> >> > Get your two CPUs in agreement about what time it is, and I bet that
> >> >> > the CPU stall warnings will go away.
> >> >> 
> >> >> Possibly KVM related? Because the warnings show up in many test boxes
> >> >> running KVM and so is not likely some hardware specific issue.
> >> > 
> >> > I vaguely recall seeing something recently.  But let's ask the KVM and
> >> > timekeeping guys.
> >> 
> >> >From the logs it looks like hpet (why not kvmclock?) is used for the
> >> clock, it should not generate such drifts since it is a global clock.
> >> Can you verify current_clocksource on a boot that actually failed (in
> >> case the clocksource is switched during runtime)?
> > 
> > I've checked out the dmesg that's cited by Paul, attached. Yes it
> > contains lines
> > 
> > [    4.970051] Switching to clocksource hpet
> > 
> > and then
> > 
> > [    7.250353] Switching to clocksource tsc
> > 
> > And there is no kvm-clock lines. Oh well for this particular kernel:
> > 
> 
> Ah, tsc will certainly break on kvm if the hardware doesn't provide a
> constant tsc source.  I'm surprised the guest kernel didn't detect it
> and switch back to hpet though.

Thanks, it's good to know the root cause. All the dmesgs show the same hpet+tsc
switching pattern (and never switch back):

$ grep Switching dmesg-kvm_bisect2-inn-*21    
dmesg-kvm_bisect2-inn-41931-2012-09-27-10-37-51-3.6.0-rc7-bisect2-00078-g593d100-21:[    4.111415] Switching to clocksource hpet
dmesg-kvm_bisect2-inn-41931-2012-09-27-10-37-51-3.6.0-rc7-bisect2-00078-g593d100-21:[    6.550098] Switching to clocksource tsc
dmesg-kvm_bisect2-inn-41931-2012-09-27-10-41-48-3.6.0-rc7-bisect2-00078-g593d100-21:[    3.927716] Switching to clocksource hpet
dmesg-kvm_bisect2-inn-41931-2012-09-27-10-41-48-3.6.0-rc7-bisect2-00078-g593d100-21:[    6.030117] Switching to clocksource tsc
dmesg-kvm_bisect2-inn-42322-2012-09-27-10-35-17-3.6.0-rc7-bisect2-00078-g593d100-21:[    3.587408] Switching to clocksource hpet
dmesg-kvm_bisect2-inn-42322-2012-09-27-10-35-17-3.6.0-rc7-bisect2-00078-g593d100-21:[    5.812400] Switching to clocksource tsc
dmesg-kvm_bisect2-inn-42322-2012-09-27-10-43-56-3.6.0-rc7-bisect2-00078-g593d100-21:[    4.294842] Switching to clocksource hpet
dmesg-kvm_bisect2-inn-42322-2012-09-27-10-43-56-3.6.0-rc7-bisect2-00078-g593d100-21:[    6.491696] Switching to clocksource tsc
dmesg-kvm_bisect2-inn-42322-2012-09-27-10-47-03-3.6.0-rc7-bisect2-00078-g593d100-21:[    4.745749] Switching to clocksource hpet
dmesg-kvm_bisect2-inn-42322-2012-09-27-10-47-03-3.6.0-rc7-bisect2-00078-g593d100-21:[    7.193121] Switching to clocksource tsc
dmesg-kvm_bisect2-inn-42527-2012-09-27-10-38-38-3.6.0-rc7-bisect2-00078-g593d100-21:[    4.970051] Switching to clocksource hpet
dmesg-kvm_bisect2-inn-42527-2012-09-27-10-38-38-3.6.0-rc7-bisect2-00078-g593d100-21:[    7.250353] Switching to clocksource tsc

And these are the stall times:

$ grep -hC1 stalls dmesg-kvm_bisect2-inn-*21
[   36.122624] bus: 'platform': really_probe: probing driver i8042 with device i8042
[   36.106893] INFO: rcu_preempt self-detected stall on CPU[  210.200388] INFO: rcu_preempt detected stalls on CPUs/tasks: { 1} (detected by 0, t=17413 jiffies)
[  210.200417] Pid: 0, comm: swapper/0 Not tainted 3.6.0-rc7-bisect2-00078-g593d100 #21
--
[   35.403888] bus: 'platform': really_probe: probing driver i8042 with device i8042
[  212.130131] INFO: rcu_preempt detected stalls on CPUs/tasks:[  212.131029] rcu-torture: rtc: c1a5e988 ver: 228 tfle: 0 rta: 228 rtaf: 162 rtf: 206 rtmbe: 0 rtbke: 0 rtbre: 0 rtbf: 0 rtb: 0 nt: 988 onoff: 0/0:0/0 -1,0:-1,0 0:0 (HZ=100) barrier: 0/0:0
[  212.131029] rcu-torture: Reader Pipe:  16284405 36 0 0 0 0 0 0 0 0 0
--
[   35.458755] bus: 'platform': really_probe: probing driver i8042 with device i8042
[   35.448369] INFO: rcu_preempt self-detected stall on CPU { 1} [  210.260157] INFO: rcu_preempt detected stalls on CPUs/tasks: { 1} (detected by 0, t=17485 jiffies)
[  210.260179] Pid: 0, comm: swapper/0 Not tainted 3.6.0-rc7-bisect2-00078-g593d100 #21
--
[   36.079480] INFO: rcu_preempt self-detected stall on CPU { 1
[  223.710182] INFO: rcu_preempt detected stalls on CPUs/tasks: { 1} (detected by 0, t=18767 jiffies)
[  223.710201] Pid: 0, comm: swapper/0 Not tainted 3.6.0-rc7-bisect2-00078-g593d100 #21
--
[   37.831174] kobject: ':t-0000168' (c793a24c): fill_kobj_path: path = '/kernel/slab/:t-0000168'
[  136.910092] INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 1, t=10002 jiffies)
[  136.910092] INFO: Stall ended before state dump start
--
[   37.672159] kobject: 'iscsi_session' (cc2c0c0c): fill_kobj_path: path = '/class/iscsi_session'
[   37.672791] INFO: rcu_preempt self-detected stall on CPU { 1[  137.900041] INFO: rcu_preempt detected stalls on CPUs/tasks: { 1} (detected by 0, t=10028 jiffies)
[  137.900041] Pid: 41, comm: rcu_torture_rea Not tainted 3.6.0-rc7-bisect2-00078-g593d100 #21

Thanks,
Fengguang
