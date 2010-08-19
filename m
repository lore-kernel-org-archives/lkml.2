Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751237Ab0HSCnM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 22:43:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:2655 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970Ab0HSCnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 22:43:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,230,1280732400"; 
   d="scan'208";a="598037887"
Subject: Re: [RFC PATCH 0/3] perf: show package power consumption in perf
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Zhang, Rui" <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "robert.richter@amd.com" <robert.richter@amd.com>,
        "acme@redhat.com" <acme@redhat.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "gorcunov@gmail.com" <gorcunov@gmail.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "Brown, Len" <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Matt Fleming <matt@console-pimps.org>
In-Reply-To: <1282134329.1926.3918.camel@laptop>
References: <1282118350.5181.115.camel@rui>
	 <1282134329.1926.3918.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Aug 2010 10:43:31 +0800
Message-ID: <1282185811.11858.92.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-18 at 20:25 +0800, Peter Zijlstra wrote:
> On Wed, 2010-08-18 at 15:59 +0800, Zhang Rui wrote:
> > Hi, all,
> > 
> > RAPL(running average power limit) is a new feature which provides
> > mechanisms to enforce power consumption limit, on some new processors.
> > 
> > Generally speaking, by using RAPL, OS can set a power budget in a
> > certain time window, and let Hardware to throttle the processor
> > P/T-state to meet this energy limitation.
> > 
> > RAPL also provides a new MSR, i.e. MSR_PKG_ENERGY_STATUS, which reports
> > the total amount of energy consumed by the package.
> > 
> > I'm not sure if to support RAPL or not, but anyway, it sounds like a
> > good idea to export the energy status in perf.
> > 
> > So a new perf pmu and event to show the package energy consumed is
> > introduced in this patch.
> > 
> > Here is what I get after applying the three patches,
> > 
> > #./perf stat -e energy test
> > Performance counter stats for 'test':
> > 
> > 	202	Joules cost by package
> > 7.926001238	seconds time elapsed
> > 
> > 
> > Note that this patch set is made based on Peter's perf-pmu branch,
> > git://git.kernel.org/pub/scm/linux/kernel/git/peterz/linux-2.6-perf.git
> >  which provides better interfaces to register/unregister a new pmu.
> > 
> > any comment are welcome. :)
> 
> 
> Nice,.. however:
> 
>  - if it is a pure read-only counter without sampling support,
>    expose it as such, don't fudge in the hrtimer stuff. Simply
>    fail to create a sampling event.
> 
>    SH has the same problem for its 'normal' PMU, the solution is
>    to use event groups, Matt was looking at adding support to
>    perf-record for that, if creating a sampling event fails, fall
>    back to {hrtimer, $event} groups.
> 
>  - since its a free-running, non-configurable counter, you can indeed
>    act like its a 'software' event in that you can schedule consumers
>    without constraints, however I don't think the PERF_COUNT_SW_* space
>    is the right way to expose this counter.
> 
>    Better would be to use the sysfs stuff Lin has been working on (for

Sorry that I have no good idea how to export the various tracepoints
events automatically, so this work will take time.

Lin Ming

>    which I still need to catch up on the latest discussions), it would
>    then be tied to the pmu instance and appear/disappear when you load/
>    unload the module.
> 
>    However for testing purposes I see why you'd want to have _a_
>    interface :-)
> 
> - it would be nice if you'd write the cpu detection a bit more readable,
>   also, it looks like you forgot to check x86_vendor == X86_VENDOR_INTEL.
> 
> > +static int __init intel_rapl_init(void)
> > +{
> > +	/*
> > +	 * RAPL features are only supported on processors have a CPUID
> > +	 * signature with DisplayFamily_DisplayModel of 06_2AH, 06_2DH
> > +	 */
> > +	if (boot_cpu_data.x86 != 0x06 ||
> > +	    (boot_cpu_data.x86_model != 0x2A &&
> > +	    boot_cpu_data.x86_model != 0x2D))
> > +		return -ENODEV;
> > +
> > +	if (rapl_check_unit())
> > +		return -ENODEV;
> > +
> > +	perf_pmu_register(&rapl_pmu);
> > +	return 0;
> > +}
> 
> Maybe something like (see intel_pmu_init() for example):
> 
>   if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
>     return -ENODEV;
> 
>   if (boot_cpu_data.x86 != 0x06)
>     return -ENODEV;
> 
>   switch (boot_cpu_data.x86_model) {
>   case 0x2A: /* sandybridge ?! 32nm */
>   case 0x2D: /* othermodel 32nm */
>     break;
> 
>   default:
>     return -ENODEV;
>   }
> 
> Which again reminds me to ask of Intel, a comprehensive x86_model list,
> please?
> 
> Alternatively, you can create a X86_FEATURE_RAPL and simply use
> boot_cpu_has(X86_FEATURE_RAPL) (much like intel_ds_init() has).


