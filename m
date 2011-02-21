Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab1BUD2l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 22:28:41 -0500
Received: from mga11.intel.com ([192.55.52.93]:49106 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766Ab1BUD2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 22:28:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,197,1297065600"; 
   d="scan'208";a="889571805"
Subject: Re: [PATCH 5/6] perf: Optimise topology iteration
From: Lin Ming <ming.m.lin@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20110220211512.GT5818@one.firstfloor.org>
References: <1298221059.2318.70.camel@localhost>
	 <20110220211512.GT5818@one.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Feb 2011 11:29:24 +0800
Message-ID: <1298258964.17806.48.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-21 at 05:15 +0800, Andi Kleen wrote:
> On Mon, Feb 21, 2011 at 12:57:39AM +0800, Lin Ming wrote:
> > Currently we iterate the full machine looking for a matching core_id/nb
> > for the percore and the amd northbridge stuff , using a smaller topology
> > mask makes sense.
> 
> This is still wrong for CPU hotplug. The CPU "owning" the per core
> does not necessarily need to be online anymore.

This is remain issue for hotplug case, no matter we use
for_each_online_cpu or topology_thread_cpumask.

> Please drop this patch.

Re-look at the code, I think for_each_online_cpu is wrong for percore,
we should use topology_thread_cpumask instead.

for_each_online_cpu(i) {
	struct intel_percore *pc = per_cpu(cpu_hw_events, i).per_core;

	if (pc && pc->core_id == core_id) {       
		kfree(cpuc->per_core);
		cpuc->per_core = pc;              
		break;
	}
}

Assume 2 sockets,

//socket 0
cpu 0: core_id 0
cpu 1: core_id 0

//socket 1
cpu 2: core_id 0
cpu 3: core_id 0

If for_each_online_cpu is used, apparently 4 logical cpus will share the
same percore. This is wrong.

If topology_thread_cpumask is used, then cpu0 and cpu1 share one percore
and cpu2 and cpu3 share another percore. This is what we want.

Lin Ming

> 
> -Andi


