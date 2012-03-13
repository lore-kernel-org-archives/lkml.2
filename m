Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab2CMGnr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 02:43:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:38997 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722Ab2CMGnq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 02:43:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="76798095"
From: "Liu, Chuansheng" <chuansheng.liu@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>
Subject: RE: [PATCH] Fix the race between smp_call_function and CPU booting
Thread-Topic: [PATCH] Fix the race between smp_call_function and CPU booting
Thread-Index: AQHNADMe8jfAhS12dUCWb8Li45vgkJZnxtew
Date: Tue, 13 Mar 2012 06:43:42 +0000
Message-ID: <27240C0AC20F114CBF8149A2696CBE4A054D6A@SHSMSX101.ccr.corp.intel.com>
References: <27240C0AC20F114CBF8149A2696CBE4A053BE8@SHSMSX101.ccr.corp.intel.com>
 <1331544767.18960.23.camel@twins>
In-Reply-To: <1331544767.18960.23.camel@twins>
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
> Sent: Monday, March 12, 2012 5:33 PM
> To: Liu, Chuansheng
> Cc: linux-kernel@vger.kernel.org; Yanmin Zhang; tglx@linutronix.de
> Subject: Re: [PATCH] Fix the race between smp_call_function and CPU booting
> 
> On Mon, 2012-03-12 at 09:27 +0000, Liu, Chuansheng wrote:
> > From: liu chuansheng <chuansheng.liu@intel.com>
> > Subject: [PATCH] Fix the race between smp_call_function and CPU
> > booting
> >
> > When system is waking up from suspend state, sometimes the
> > smp_call_function is called which will cause deadlock specially on the
> > platform which just has two CPUs.
> >
> > CPU0:                                           CPU1:
> > pm_suspend -->
> > suspend_devices_and_enter -->
> > enable_nonboot_cpus -->
> > _cpu_up -->
> > __cpu_up -->
> > native_cpu_up
> >                                                 start_secondary
> >                                                         -- set
> cpu online
> >                                                         --
> waiting for the active state new thread call:
> > smp_call_function -->
> > smp_call_function_many -->
> > smp_call_function_single -->
> >    -- csd_lock
> >    -- generic_exec_single -->
> >    -- arch_send_call_function_single_ipi
> >    -- csd_lock_wait
> >
> > At this time, both CPUs are blocked. Normally the CPU0 will set the
> > CPU1 with active state after finished the _cpu_up calling, but CPU1
> > can not handle the IPI due to the corresponding irq is still disabled,
> > which will be enabled after waiting for the active state.
> >
> > The solution is just to send smp call to active cpus instead of online
> > cpus.
> 
> Wouldn't http://lkml.org/lkml/2011/12/15/255 also solve that?
Yes, the patch in http://lkml.org/lkml/2011/12/15/255 also solve it. But it moved the action of setting active state into the start_secondary thru cpu_notifier starting,
If so, more simpler solution is calling set_cpu_active directly in function start_secondary, do not need register cpu_online/cpu_starting cpu_notifier in function migration_init at all.

