Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424Ab2IGBVF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 21:21:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:10536 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755637Ab2IGBVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 21:21:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,382,1344236400"; 
   d="scan'208";a="219127793"
Date: Fri, 7 Sep 2012 09:20:58 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Michael Wang <wangyun@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>
Subject: Re: WARNING: cpu_is_offline() at native_smp_send_reschedule()
Message-ID: <20120907012058.GA9000@localhost>
References: <20120905011152.GA19853@localhost>
 <5046D69F.9000705@linux.vnet.ibm.com>
 <1346842480.2461.11.camel@laptop>
 <20120905125700.GA5833@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120905125700.GA5833@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 08:57:00PM +0800, Fengguang Wu wrote:
> On Wed, Sep 05, 2012 at 12:54:40PM +0200, Peter Zijlstra wrote:
> > On Wed, 2012-09-05 at 12:35 +0800, Michael Wang wrote:
> > > > [   10.968565] reboot: machine restart
> > > > [   10.983510] ------------[ cut here ]------------
> > > > [   10.984218] WARNING: at /c/kernel-tests/src/stable/arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x46/0x50()
> > > > [   10.985880] Pid: 88, comm: kpktgend_0 Not tainted 3.6.0-rc3-00005-gb374aa1 #10
> > > > [   10.987185] Call Trace:
> > > > [   10.987506]  [<7902f42a>] warn_slowpath_common+0x5a/0x80
> > > > [   10.987506]  [<7901ee16>] ? native_smp_send_reschedule+0x46/0x50
> > > > [   10.987506]  [<7901ee16>] ? native_smp_send_reschedule+0x46/0x50
> > > > [   10.987506]  [<7902f4fd>] warn_slowpath_null+0x1d/0x20
> > > > [   10.987506]  [<7901ee16>] native_smp_send_reschedule+0x46/0x50
> > > 
> > > So this cpu try to fire a nohz balance kick ipi to an offline cpu?
> > > 
> > > May be we are choosing a wrong cpu to kick but that's not the point,
> > > what I can't understand is why this cpu could do this kick.
> > > 
> > > We have nohz_kick_needed() to check whether current cpu should do kick ,
> > > and the first condition we need to match is that current cpu should be
> > > idle, but the trace show current pid is 88 not 0.
> > > 
> > > We should add Peter to cc list, may be he will be interested on what
> > > happened.
> > 
> > > > [   10.987506]  [<7905fdad>] trigger_load_balance+0x1bd/0x250
> > > > [   10.987506]  [<79056d14>] scheduler_tick+0xd4/0x100
> > > > [   10.987506]  [<7903bde5>] update_process_times+0x55/0x70 
> > 
> > Hmm, added both venki and suresh as they touched it last ;-)
> > 
> > I suppose you're running a hotplug loop along with your workload?
> 
> I would definitely like to add some hotplug tests! However for this
> trace, it's simply booting into an ubuntu-core initrd and run the
> "reboot" command in some late init.d script.
> 
> It seems that the bug was introduced somewhere in v3.3..v3.4. I'm now
> running 100 kvms to speedup the bisect progress :)

FYI, the bisect result is

commit 554cecaf733623b327eef9652b65965eb1081b81
Author: Diwakar Tundlam <dtundlam@nvidia.com>
Date:   Wed Mar 7 14:44:26 2012 -0800

    sched/nohz: Correctly initialize 'next_balance' in 'nohz' idle balancer

    The 'next_balance' field of 'nohz' idle balancer must be initialized
    to jiffies. Since jiffies is initialized to negative 300 seconds the
    'nohz' idle balancer does not run for the first 300s (5mins) after
    bootup. If no new processes are spawed or no idle cycles happen, the
    load on the cpus will remain unbalanced for that duration.

    Signed-off-by: Diwakar Tundlam <dtundlam@nvidia.com>
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Link: http://lkml.kernel.org/r/1DD7BFEDD3147247B1355BEFEFE4665237994F30EF@HQMAIL04.nvidia.com
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

Thanks,
Fengguang
