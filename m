Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933Ab2IGITV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 04:19:21 -0400
Received: from mga11.intel.com ([192.55.52.93]:48306 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088Ab2IGITQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 04:19:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,384,1344236400"; 
   d="scan'208";a="219241720"
Date: Fri, 7 Sep 2012 16:17:29 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Michael Wang <wangyun@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>
Subject: Re: WARNING: cpu_is_offline() at native_smp_send_reschedule()
Message-ID: <20120907081729.GA19473@localhost>
References: <20120905011152.GA19853@localhost>
 <5046D69F.9000705@linux.vnet.ibm.com>
 <1346842480.2461.11.camel@laptop>
 <20120905125700.GA5833@localhost>
 <20120907012058.GA9000@localhost>
 <1347002596.18408.84.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347002596.18408.84.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 09:23:16AM +0200, Peter Zijlstra wrote:
> On Fri, 2012-09-07 at 09:20 +0800, Fengguang Wu wrote:
> 
> > FYI, the bisect result is
> > 
> > commit 554cecaf733623b327eef9652b65965eb1081b81
> > Author: Diwakar Tundlam <dtundlam@nvidia.com>
> > Date:   Wed Mar 7 14:44:26 2012 -0800
> > 
> >     sched/nohz: Correctly initialize 'next_balance' in 'nohz' idle balancer
> > 
> >     The 'next_balance' field of 'nohz' idle balancer must be initialized
> >     to jiffies. Since jiffies is initialized to negative 300 seconds the
> >     'nohz' idle balancer does not run for the first 300s (5mins) after
> >     bootup. If no new processes are spawed or no idle cycles happen, the
> >     load on the cpus will remain unbalanced for that duration.
> > 
> >     Signed-off-by: Diwakar Tundlam <dtundlam@nvidia.com>
> >     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >     Link: http://lkml.kernel.org/r/1DD7BFEDD3147247B1355BEFEFE4665237994F30EF@HQMAIL04.nvidia.com
> >     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> Oh fun.. does the below 'fix' it?
> 
> The thing I'm thinking of a tick happening right after we set jiffies
> but before the zalloc (specifically the memset(0)) is complete. Since
> we've already registered the softirq we can end up in the load-balancer
> and see a completely weird idle mask.
> 
> Hmm?

The may be more causes, since I still get the warning:

[    9.816279] reboot: machine restart
[    9.835796] ------------[ cut here ]------------
[    9.836558] WARNING: at /c/wfg/linux/arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x46/0x50()
[    9.839792] Pid: 18, comm: kworker/0:1 Not tainted 3.6.0-rc3-bisect-00005-gb374aa1-dirty #49
[    9.839792] Call Trace:
[    9.839792]  [<7902f42a>] warn_slowpath_common+0x5a/0x80
[    9.839792]  [<7901ee16>] ? native_smp_send_reschedule+0x46/0x50
[    9.839792]  [<7901ee16>] ? native_smp_send_reschedule+0x46/0x50
[    9.839792]  [<7902f4fd>] warn_slowpath_null+0x1d/0x20
[    9.839792]  [<7901ee16>] native_smp_send_reschedule+0x46/0x50
[    9.839792]  [<7905fdad>] trigger_load_balance+0x1bd/0x250
[    9.839792]  [<79056d14>] scheduler_tick+0xd4/0x100
[    9.839792]  [<7903bde5>] update_process_times+0x55/0x70
[    9.839792]  [<79071187>] tick_sched_timer+0x57/0xb0
[    9.839792]  [<793accee>] ? do_raw_spin_unlock+0x4e/0x90
[    9.839792]  [<7904e0b7>] __run_hrtimer.isra.29+0x57/0x100
[    9.839792]  [<79071130>] ? tick_nohz_handler+0xe0/0xe0
[    9.839792]  [<7904ed45>] hrtimer_interrupt+0xe5/0x280
[    9.839792]  [<7905a5a7>] ? sched_clock_cpu+0xc7/0x150
[    9.839792]  [<7901f9a4>] smp_apic_timer_interrupt+0x54/0x90
[    9.839792]  [<79882631>] apic_timer_interrupt+0x31/0x40
[    9.839792]  [<7905007b>] ? call_srcu+0x2b/0x70
[    9.839792]  [<793a00e0>] ? __bitmap_intersects+0x10/0x80
[    9.839792]  [<7988194f>] ? _raw_spin_unlock_irq+0x1f/0x40
[    9.839792]  [<7905307f>] finish_task_switch+0x7f/0xd0
[    9.839792]  [<79053038>] ? finish_task_switch+0x38/0xd0
[    9.839792]  [<7988044a>] __schedule+0x38a/0x770
[    9.839792]  [<79045529>] ? worker_thread+0x1a9/0x380
[    9.839792]  [<793accee>] ? do_raw_spin_unlock+0x4e/0x90
[    9.839792]  [<7988084e>] schedule+0x1e/0x50
[    9.839792]  [<7904552e>] worker_thread+0x1ae/0x380
[    9.839792]  [<79056ed9>] ? complete+0x49/0x60
[    9.839792]  [<79045380>] ? manage_workers.isra.23+0x250/0x250
[    9.839792]  [<79049ff8>] kthread+0x78/0x80
[    9.839792]  [<79880000>] ? __up.isra.0+0xd/0x2d
[    9.839792]  [<79049f80>] ? insert_kthread_work+0x70/0x70
[    9.839792]  [<798830c6>] kernel_thread_helper+0x6/0xd

Thanks,
Fengguang

