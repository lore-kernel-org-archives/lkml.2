Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760634Ab2FDNg6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 09:36:58 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:59356 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab2FDNg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 09:36:57 -0400
Date: Mon, 4 Jun 2012 15:37:22 +0200
From: Borislav Petkov <bp@amd64.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Borislav Petkov <bp@amd64.org>, Ingo Molnar <mingo@kernel.org>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH] x86, smp: Fix topology checks on AMD MCM
Message-ID: <20120604133722.GB15433@aftab.osrc.amd.com>
References: <20120529174804.GC8263@alberich.amd.com>
 <1338813717-28112-1-git-send-email-bp@amd64.org>
 <1338813830.28282.44.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338813830.28282.44.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2012 at 02:43:50PM +0200, Peter Zijlstra wrote:
> On Mon, 2012-06-04 at 14:41 +0200, Borislav Petkov wrote:
> > The warning below triggers on AMD MCM packages because physical
> > package
> > IDs on the cores of a _physical_ socket are the same. I.e., this field
> > says which CPUs belong to the same physical package.
> > 
> Thanks!

This is still crap.

It breaks tests like those in powernow-k8:

        if (cpumask_first(cpu_core_mask(data->cpu)) == data->cpu)
                print_basics(data);

and it calls print_basics() on each core filling up dmesg with:

[    5.216925] powernow-k8:    0 : pstate 0 (1700 MHz)
[    5.222139] powernow-k8:    1 : pstate 1 (1300 MHz)
[    5.227354] powernow-k8:    2 : pstate 2 (1100 MHz)
[    5.232568] powernow-k8:    3 : pstate 3 (1000 MHz)
[    5.237783] powernow-k8:    4 : pstate 4 (800 MHz)
[    5.242988] powernow-k8:    0 : pstate 0 (1700 MHz)
[    5.248242] powernow-k8:    1 : pstate 1 (1300 MHz)
[    5.253462] powernow-k8:    2 : pstate 2 (1100 MHz)
[    5.258677] powernow-k8:    3 : pstate 3 (1000 MHz)
[    5.263892] powernow-k8:    4 : pstate 4 (800 MHz)
[    5.269094] powernow-k8:    0 : pstate 0 (1700 MHz)
[    5.274348] powernow-k8:    1 : pstate 1 (1300 MHz)
[    5.279566] powernow-k8:    2 : pstate 2 (1100 MHz)
[    5.284787] powernow-k8:    3 : pstate 3 (1000 MHz)
[    5.298387] powernow-k8:    4 : pstate 4 (800 MHz)
...

while it should dump the Pstates only once per physical socket.

The proper fix should be:

static bool __cpuinit match_mc(struct cpuinfo_x86 *c, struct cpuinfo_x86 *o)
{
        if (c->phys_proc_id == o->phys_proc_id) {
                if (cpu_has(c, X86_FEATURE_AMD_DCM))
                        return true;

                return topology_sane(c, o, "mc");
        }
        return false;
}

which basically circumvents the topology check on MCM modules. I'll run
this a bit longer to verify it doesn't break anything else.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
