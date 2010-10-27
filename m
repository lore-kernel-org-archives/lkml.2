Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718Ab0J0PgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 11:36:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:35404 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752025Ab0J0PgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 11:36:11 -0400
Message-ID: <4CC846D5.50106@kernel.org>
Date: Wed, 27 Oct 2010 17:35:49 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.11) Gecko/20101013 Lightning/1.0b2 Thunderbird/3.1.5
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, Brian Gerst <brgerst@gmail.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH] x86-32: Allocate irq stacks seperate from percpu area
References: <AANLkTinnc3vBSmewf7ixuOSDYxG+5VNiGaB-vSrDNRiO@mail.gmail.com>	 <1288158182-1753-1-git-send-email-brgerst@gmail.com>	 <1288159670.2652.181.camel@edumazet-laptop>	 <1288173442.15336.1490.camel@twins>	 <1288186405.2709.117.camel@edumazet-laptop>  <4CC82C2F.1020707@kernel.org>	 <1288187870.2709.128.camel@edumazet-laptop>  <4CC83067.5000009@kernel.org>	 <1288189461.2709.144.camel@edumazet-laptop>	 <1288190387.2709.147.camel@edumazet-laptop>  <4CC83A85.3070608@kernel.org> <1288192868.2709.152.camel@edumazet-laptop>
In-Reply-To: <1288192868.2709.152.camel@edumazet-laptop>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Oct 2010 15:35:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/27/2010 05:21 PM, Eric Dumazet wrote:
> I wish it could explain it.
> I upgraded BIOS to latest one from HP. no change.
> 
> If I remove HOTPLUG support I still get :
> 
> cpu=0 node=1
> cpu=1 node=0
> cpu=2 node=1
> cpu=3 node=0
> cpu=4 node=1
> cpu=5 node=0
> cpu=6 node=1
> cpu=7 node=0
> cpu=8 node=1
> cpu=9 node=0
> cpu=10 node=1
> cpu=11 node=0
> cpu=12 node=1
> cpu=13 node=0
> cpu=14 node=1
> cpu=15 node=0
> 
> [    0.000000] SMP: Allowing 16 CPUs, 0 hotplug CPUs
> [    0.000000] nr_irqs_gsi: 64
> [    0.000000] Allocating PCI resources starting at e4000000 (gap: e4000000:1ac00000)
> [    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:16 nr_node_ids:8
> [    0.000000] PERCPU: Embedded 16 pages/cpu @f4600000 s42752 r0 d22784 u131072
> [    0.000000] pcpu-alloc: s42752 r0 d22784 u131072 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15

Hmmm, okay.  Can you please print out early_cpu_to_node() output for
each cpu from arch/x86/kernel/setup_percpu.c::setup_per_cpu_areas()?
BTW, some clarifications.

* In the pcpu-alloc debug message, the n of [n] might not necessarily
  match the NUMA node.

* I was confused before.  If CPU distance reported by
  early_cpu_to_node() is greater than LOCAL_DISTANCE (ie. NUMA
  configuration), cpus will always belong to different [n].  What gets
  adjusted is the size of each unit.

* No matter what, here, the end result is correct.  As there's no low
  memory on node 1, it doesn't matter how the groups are organized in
  the first chunk as long as embedding is used.  And for other chunks,
  pages for each cpu are allocated separatedly w/ cpu_to_node() anyway
  so NUMA affinity will be correct, again, regardless of the group
  organization.

Thanks.

-- 
tejun
