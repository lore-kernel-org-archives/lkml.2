Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069Ab1GKRNu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 13:13:50 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:59639 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757967Ab1GKRNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 13:13:49 -0400
Date: Mon, 11 Jul 2011 10:13:37 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: xen-devel@lists.xensource.com, julie Sullivan <kernelmail.jms@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: 3.0-rc kernels unbootable since -rc3
Message-ID: <20110711171337.GK2245@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAAVPGOMe6NawfkNQ1pSGYe5a1=X0z_KcD5Dn_xDX55p3K_46nQ@mail.gmail.com>
 <20110710032510.GG6014@linux.vnet.ibm.com>
 <CAAVPGOPCGsNynWPWcwaxVU_jPCg=VPdz82_g6OvY5gnYKk5oFg@mail.gmail.com>
 <20110710171626.GK6014@linux.vnet.ibm.com>
 <20110710173530.GA16954@linux.vnet.ibm.com>
 <CAAVPGOPAx-oLZct9u2Kq3uQ4W2GwJFYUGgw3h=M_Y4_wv7b51w@mail.gmail.com>
 <20110710214639.GP6014@linux.vnet.ibm.com>
 <CAAVPGOMafp_+45X=7asHe=MqaHY8CiJYsf2GZ3qOPrWpjctHVQ@mail.gmail.com>
 <20110710231449.GQ6014@linux.vnet.ibm.com>
 <20110711162450.GA22913@dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110711162450.GA22913@dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 12:24:51PM -0400, Konrad Rzeszutek Wilk wrote:
> On Sun, Jul 10, 2011 at 04:14:49PM -0700, Paul E. McKenney wrote:
> > On Sun, Jul 10, 2011 at 10:50:48PM +0100, julie Sullivan wrote:
> > > > Very cool!  Thank you very much for the testing --
> .. snip..
> > And here is what I am proposing sending upstream.  I have your Tested-by,
> 
> Hey Paul,
> 
> I am hitting a similar bug.
> Starting udev Kernel Device Manager...
> Starting Configure read-only root support...
> [   79.942067] INFO: rcu_sched_state detected stalls on CPUs/tasks: { 0} (detected by 2, t=60002 jiffies)
> [   79.942089] sending NMI to all CPUs:
> 
> when running a 3.0-rc6 under Xen as 32-bit guest (I don't see this issue
> when running a 64-bit guest) and when I've more than two CPUs under the guest.
> 
> I've tried the patch below against 3.0-rc6 and it did not fix the issue.
> 
> I've also tried to use 3.0-rc3 as somewhere in thread one of the reporters mentioned
> that it worked for me - but that did not help me.
> 
> The config is a Fedora Core based. The stack traces of the four CPUs look
> as follow:
> 
> CPU0:
> Call Trace:
>   [<c04023a7>] hypercall_page+0x3a7  <--
>   [<c0405ed5>] xen_safe_halt+0x12 
>   [<c040ea08>] default_idle+0x5a 
>   [<c04081a6>] cpu_idle+0x8e 
>   [<c07da9a9>] rest_init+0x5d 
>   [<c0a86788>] start_kernel+0x34d 
>   [<c0a861c4>] unknown_bootoption 
>   [<c0a860ba>] i386_start_kernel+0xa9 
>   [<c0a895ce>] xen_start_kernel+0x55d 
>   [<c04090b1>] sys_rt_sigreturn+0xb 
> 
> CPU1 and CPU2:
> Call Trace:
>   [<c04023a7>] hypercall_page+0x3a7  <--
>   [<c0405ed5>] xen_safe_halt+0x12 
>   [<c040ea08>] default_idle+0x5a 
>   [<c04081a6>] cpu_idle+0x8e 
>   [<c07e5419>] cpu_bringup_and_idle+0xd 
> 
> CPU3:
> Call Trace:
>   [<c042d0f2>] task_waking_fair+0x11  <--
>   [<c0439a45>] try_to_wake_up+0xb2 
>   [<c0439b0c>] default_wake_function+0x10 
>   [<c042d4db>] __wake_up_common+0x3b 
>   [<c042ea69>] complete+0x3e 
>   [<c0455e14>] wakeme_after_rcu+0x10 
>   [<c048fd58>] __rcu_process_callbacks+0x172 
>   [<c049080f>] rcu_process_callbacks+0x20 
>   [<c044567d>] __do_softirq+0xa2 
>   [<c04455db>] __do_softirq 
>   [<c040a52d>] do_softirq+0x5a 
> 
> The full config is http://darnok.org/xen/config-rcu-stall
> The full bootup log is http://darnok.org/xen/log-rcu-stall
> 
> Any thoughts of what I ought to try? I don't know if there is some missing functionality
> in the RCU patches to work under Xen.... Any older version of Linux kernel
> you would like me to try?

Hmmm...  Does the stall repeat about every 3.5 minutes after the first stall?

One thing to try would be to disable CONFIG_RCU_FAST_NO_HZ.  I wouldn't
expect this to have any effect, but might be worth a try.  It is really
intended for small battery-powered systems.

							Thanx, Paul
