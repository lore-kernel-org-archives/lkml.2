Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763Ab1ADHMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 02:12:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:31547 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170Ab1ADHMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 02:12:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,271,1291622400"; 
   d="scan'208";a="693309267"
Subject: Re: [PATCH 5/7] perf: Optimise topology iteration
From: Lin Ming <ming.m.lin@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        "robert.richter@amd.com" <robert.richter@amd.com>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20110103152025.GB25713@one.firstfloor.org>
References: <1293464287.2695.106.camel@localhost>
	 <1294052530.2016.52.camel@laptop>
	 <20110103152025.GB25713@one.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 04 Jan 2011 15:13:02 +0800
Message-ID: <1294125182.23205.154.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-03 at 23:20 +0800, Andi Kleen wrote:
> On Mon, Jan 03, 2011 at 12:02:10PM +0100, Peter Zijlstra wrote:
> > On Mon, 2010-12-27 at 23:38 +0800, Lin Ming wrote:
> > > Currently we iterate the full machine looking for a matching core_id/nb
> > > for the percore and the amd northbridge stuff , using a smaller topology
> > > mask makes sense. 
> > 
> > Does topology_thread_cpumask() include offline cpus? I tried looking at
> > it, but I cannot find any code clearing bits in that mask on offline.
> 
> The problem is not only at offline, but also at online between CPUs
> going online.  I don't think the patch is a good idea and it doesn't

I didn't see the problem.

Assume logical cpu 3, 7 are 2 threads in a core, and they are
plug/unpluged as below sequence,
CPU 3 offline, CPU7 offline, CPU3 online, CPU7 online

1. After cpu3 offline

topology_thread_cpumask(3) returns empty
topology_thread_cpumask(7) returns 7

2. After CPU7 offline

topology_thread_cpumask(3) returns empty
topology_thread_cpumask(7) returns empty

3. When CPU3 online, calling intel_pmu_cpu_starting

topology_thread_cpumask(3) returns 3
topology_thread_cpumask(7) returns empty

        for_each_cpu(i, topology_thread_cpumask(cpu)) {
                struct intel_percore *pc = per_cpu(cpu_hw_events, i).per_core;

                if (pc && pc->core_id == core_id) {
                        kfree(cpuc->per_core);
                        cpuc->per_core = pc;
                        break;
                }
        }

Above "if" statement will not be executed, because pc->core_id was
initialized to -1 in intel_pmu_cpu_prepare.

4. When CPU7 online, calling intel_pmu_cpu_starting

topology_thread_cpumask(3) returns 3, 7
topology_thread_cpumask(7) returns 3, 7


        for_each_cpu(i, topology_thread_cpumask(cpu)) {
                struct intel_percore *pc = per_cpu(cpu_hw_events, i).per_core;

                if (pc && pc->core_id == core_id) {
                        kfree(cpuc->per_core);
                        cpuc->per_core = pc;
                        break;
                }
        }

        cpuc->per_core->core_id = core_id;
        cpuc->per_core->refcnt++;

Above "if" statement will be executed and the per_core data allocated
for cpu7 will be freed.

All above is right, or could you explain more about the problem at CPUs
offline and online?

Thanks,
Lin Ming

> even have any advantages either since this is a initialization only
> slow path.
> 
> -Andi


