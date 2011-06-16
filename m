Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742Ab1FPM2P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 08:28:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46240 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755515Ab1FPM2O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 08:28:14 -0400
Subject: Re: "Cache" sched domains
From: Peter Zijlstra <peterz@infradead.org>
To: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Venkatesh Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
In-Reply-To: <20110616121147.GA4644@const.bordeaux.inria.fr>
References: <20110616121147.GA4644@const.bordeaux.inria.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Jun 2011 14:27:22 +0200
Message-ID: <1308227242.13240.56.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p5GCSPuI027711

On Thu, 2011-06-16 at 14:11 +0200, Samuel Thibault wrote:
> Hello,
> 
> We have an x86 machine whose sockets look like this in hwloc:
> 
> ┌──────────────────────────────────────────────────────────────────┐
> │Socket P#1                                                        │
> │┌────────────────────────────────────────────────────────────────┐│
> ││L3 (16MB)                                                       ││
> │└────────────────────────────────────────────────────────────────┘│
> │┌────────────────────┐┌────────────────────┐┌────────────────────┐│
> ││L2 (3072KB)         ││L2 (3072KB)         ││L2 (3072KB)         ││
> │└────────────────────┘└────────────────────┘└────────────────────┘│
> │┌─────────┐┌─────────┐┌─────────┐┌─────────┐┌─────────┐┌─────────┐│
> ││L1 (32KB)││L1 (32KB)││L1 (32KB)││L1 (32KB)││L1 (32KB)││L1 (32KB)││
> │└─────────┘└─────────┘└─────────┘└─────────┘└─────────┘└─────────┘│
> │┌─────────┐┌─────────┐┌─────────┐┌─────────┐┌─────────┐┌─────────┐│
> ││Core P#0 ││Core P#1 ││Core P#2 ││Core P#3 ││Core P#4 ││Core P#5 ││
> ││┌───────┐││┌───────┐││┌───────┐││┌───────┐││┌───────┐││┌───────┐││
> │││PU P#0 ││││PU P#4 ││││PU P#8 ││││PU P#12││││PU P#16││││PU P#20│││
> ││└───────┘││└───────┘││└───────┘││└───────┘││└───────┘││└───────┘││
> │└─────────┘└─────────┘└─────────┘└─────────┘└─────────┘└─────────┘│
> └──────────────────────────────────────────────────────────────────┘

Pretty, bonus points for effort there.

> However, Linux does not build sched domains for the pairs of cores
> which share an L2 cache. On s390, IBM added sched domains for books,
> that is, sets of cores which share an L2 cache. The support should
> probably be added in a generic way for all archs thanks to generic cache
> information.

Yeah, sched domain generation is currently somewhat crappy.

I think you'll find you'll get that L2 domain when you enable mc/smt
power savings on !magny-cours due to this particular horror in
arch/x86/kernel/smpboot.c (possibly loosing another level due to other
crap and changing scheduler behaviour in ways you might not fancy):

const struct cpumask *cpu_coregroup_mask(int cpu)
{
	struct cpuinfo_x86 *c = &cpu_data(cpu);
	/*
	 * For perf, we return last level cache shared map.
	 * And for power savings, we return cpu_core_map
	 */
	if ((sched_mc_power_savings || sched_smt_power_savings) &&
	    !(cpu_has(c, X86_FEATURE_AMD_DCM)))
		return cpu_core_mask(cpu);
	else
		return cpu_llc_shared_mask(cpu);
}

I recently started reworking all that sched_domain crud and we're almost
at the point where we can remove all legacy 'level' crap. That is,
nothing in the scheduler should (and does, last time I checked) depend
on sd->level anymore.

So the current goal is to change sched_domain_topology to not be such a
silly hard coded list of domains, but build that thing dynamically based
on the system topology and set all the SD_flags correctly.

If that is something you're willing to work on, that'd be totally
awesome.
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
