Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030667Ab2CNG2I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 02:28:08 -0400
Received: from mga14.intel.com ([143.182.124.37]:14407 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030209Ab2CNG2C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 02:28:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="77280231"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: RE: [PATCH] Fix the race between smp_call_function and CPU booting
Thread-Topic: [PATCH] Fix the race between smp_call_function and CPU booting
Thread-Index: AQHNATIIc9LZ55ArUE6HH+tsdd8H/pZpRxBQ
Date: Wed, 14 Mar 2012 06:27:58 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A0556FA@SHSMSX101.ccr.corp.intel.com>
References: <27240C0AC20F114CBF8149A2696CBE4A053BE8@SHSMSX101.ccr.corp.intel.com>
	 <1331546307.18960.26.camel@twins>
	 <27240C0AC20F114CBF8149A2696CBE4A054D70@SHSMSX101.ccr.corp.intel.com>
 <1331654251.18960.78.camel@twins>
In-Reply-To: <1331654251.18960.78.camel@twins>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Peter Zijlstra [mailto:peterz@infradead.org]
> Sent: Tuesday, March 13, 2012 11:58 PM
> To: Liu, Chuansheng
> Cc: linux-kernel@vger.kernel.org; Yanmin Zhang; tglx@linutronix.de
> Subject: RE: [PATCH] Fix the race between smp_call_function and CPU booting
> 
> On Tue, 2012-03-13 at 06:46 +0000, Liu, Chuansheng wrote:
> >
> > > -----Original Message-----
> > > From: Peter Zijlstra [mailto:peterz@infradead.org]
> > > Sent: Monday, March 12, 2012 5:58 PM
> > > To: Liu, Chuansheng
> > > Cc: linux-kernel@vger.kernel.org; Yanmin Zhang; tglx@linutronix.de
> > > Subject: Re: [PATCH] Fix the race between smp_call_function and CPU
> > > booting
> > >
> > > On Mon, 2012-03-12 at 09:27 +0000, Liu, Chuansheng wrote:
> > > > The solution is just to send smp call to active cpus instead of
> > > > online cpus.
> > >
> > > BTW, that solution is broken because !active cpus can still be
> > > online and actually running stuff, so sending IPIs to them is
> > > perfectly fine and actually required.
> > >
> > Based on current code base, the IPI can be handled only after the cpu
> > is active, before CPU is active, Any sending IPI is meanless.
> 
> Not so on the unplug case, we clear active long before we actually go offline
> and rebuild sched_domains.
On the unplug case, after set the CPU to !active, we do not need IPI handling for the corresponding
CPU before it is set to offline. I did not find any impact that limiting the smp_call_function
just after CPU is active.

I did a stress test that starting two different scripts concurrently:
1/ onoff_line script like below:
while true
do
 echo 0 > /sys/devices/system/cpu/cpu1/online
 echo 1 > /sys/devices/system/cpu/cpu1/online
done
2/ Adding a simple sys interface to trigger calling smp_call_function:
test_set()
{
  smp_call_function(...);
}

The script is writing the interface to trigger the calling in loop every 500ms;


The result is:
1/ without any patch, the deadlock issue is very easy to be reproduced;

2/ With your patch http://lkml.org/lkml/2011/12/15/255, the below issue is always found, and the system is hanging there.
I think it is because the booted CPU1 is set to active too early and the online do not be set yet.
[  721.759736] cpu_down
[  721.822193] LCS test smp_call_function
[  721.864892] CPU 1 is now offline
[  721.868270] SMP alternatives: switching to UP code
[  721.886925] _cpu_up
[  721.892222] SMP alternatives: switching to SMP code
[  721.906420] Booting Node 0 Processor 1 APIC 0x1
[  721.921177] Initializing CPU#1
[  721.981898] ------------[ cut here ]------------
[  721.989553] WARNING: at /root/r3_ics/hardware/intel/linux-2.6/arch/x86/kernel/smp.c:118 native_smp_send_reschedule+0x50/0x60()
[  722.000923] Hardware name: Medfield
[  722.004401] Modules linked in: atomisp lm3554 mt9m114 mt9e013 videobuf_vmalloc videobuf_core mac80211 cfg80211 compat btwilink st_drv
[  722.016408] Pid: 18865, comm: workqueue_trust Not tainted 3.0.8-137166-g2639a16-dirty #1
[  722.024486] Call Trace:
[  722.026939]  [<c1252287>] warn_slowpath_common+0x77/0x130
[  722.032321]  [<c121df70>] ? native_smp_send_reschedule+0x50/0x60
[  722.038314]  [<c121df70>] ? native_smp_send_reschedule+0x50/0x60
[  722.044316]  [<c1252362>] warn_slowpath_null+0x22/0x30
[  722.049445]  [<c121df70>] native_smp_send_reschedule+0x50/0x60
[  722.055268]  [<c124bacf>] try_to_wake_up+0x17f/0x390
[  722.060225]  [<c124bd34>] wake_up_process+0x14/0x20
[  722.065091]  [<c1277107>] kthread_stop+0x37/0x100
[  722.069789]  [<c126f5e0>] destroy_worker+0x50/0x90
[  722.074573]  [<c18c1b4d>] trustee_thread+0x3e3/0x4bf
[  722.079524]  [<c1277410>] ? wake_up_bit+0x90/0x90
[  722.084224]  [<c18c176a>] ? wait_trustee_state+0x91/0x91
[  722.089520]  [<c1276fc4>] kthread+0x74/0x80
[  722.093694]  [<c1276f50>] ? __init_kthread_worker+0x30/0x30
[  722.099264]  [<c18c7cfa>] kernel_thread_helper+0x6/0x10
[  722.104474] ---[ end trace fa5bcc15ece677c6 ]---

3/ With my patch, the system kept there for 1 hour ,did not find issue yet.
I will keep the stress test running for a long long time;

Any other good solution? If anything wrong, please correct me, thanks.

