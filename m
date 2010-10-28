Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932623Ab0J1MB0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 08:01:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:42929 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757697Ab0J1MBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 08:01:24 -0400
Message-ID: <4CC965FF.8000601@kernel.org>
Date: Thu, 28 Oct 2010 14:01:03 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.11) Gecko/20101013 Lightning/1.0b2 Thunderbird/3.1.5
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>, Brian Gerst <brgerst@gmail.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH] x86-32: Allocate irq stacks seperate from percpu area
References: <AANLkTinnc3vBSmewf7ixuOSDYxG+5VNiGaB-vSrDNRiO@mail.gmail.com>	 <1288158182-1753-1-git-send-email-brgerst@gmail.com>	 <1288159670.2652.181.camel@edumazet-laptop>	 <1288173442.15336.1490.camel@twins>	 <1288186405.2709.117.camel@edumazet-laptop>  <4CC82C2F.1020707@kernel.org>	 <1288187870.2709.128.camel@edumazet-laptop>  <4CC83067.5000009@kernel.org>	 <1288189461.2709.144.camel@edumazet-laptop>	 <1288190387.2709.147.camel@edumazet-laptop>  <4CC83A85.3070608@kernel.org>	 <1288192868.2709.152.camel@edumazet-laptop>  <4CC846D5.50106@kernel.org> <1288212951.2658.51.camel@edumazet-laptop>
In-Reply-To: <1288212951.2658.51.camel@edumazet-laptop>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 28 Oct 2010 12:01:05 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Eric.

On 10/27/2010 10:55 PM, Eric Dumazet wrote:
> I changed the User/Kernel split from 3G/1G to 1G/3G so that I have
> LOWMEM on both nodes. Still pcpu allocates all percpu from node0.
...
> [    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:16 nr_node_ids:8
> [    0.000000] PERCPU: Embedded 16 pages/cpu @bea00000 s41984 r0 d23552 u131072
> [    0.000000] pcpu-alloc: s41984 r0 d23552 u131072 alloc=1*2097152
> [    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 
> [    0.000000] setup_percpu: cpu=0 early_cpu_to_node()=0
> [    0.000000] setup_percpu: cpu=1 early_cpu_to_node()=0
> [    0.000000] setup_percpu: cpu=2 early_cpu_to_node()=0
> [    0.000000] setup_percpu: cpu=3 early_cpu_to_node()=0
> [    0.000000] setup_percpu: cpu=4 early_cpu_to_node()=0
> [    0.000000] setup_percpu: cpu=5 early_cpu_to_node()=0
> [    0.000000] setup_percpu: cpu=6 early_cpu_to_node()=0
> [    0.000000] setup_percpu: cpu=7 early_cpu_to_node()=0
> [    0.000000] setup_percpu: cpu=8 early_cpu_to_node()=0
> [    0.000000] setup_percpu: cpu=9 early_cpu_to_node()=0
> [    0.000000] setup_percpu: cpu=10 early_cpu_to_node()=0
> [    0.000000] setup_percpu: cpu=11 early_cpu_to_node()=0
> [    0.000000] setup_percpu: cpu=12 early_cpu_to_node()=0
> [    0.000000] setup_percpu: cpu=13 early_cpu_to_node()=0
> [    0.000000] setup_percpu: cpu=14 early_cpu_to_node()=0
> [    0.000000] setup_percpu: cpu=15 early_cpu_to_node()=0

So, this is the problem.  percpu uses early_cpu_to_node() to determine
which cpu belongs to which NUMA node and according to it all CPUs are
on node 0, so percpu is configured accordingly.  I have no idea why
early_cpu_to_node() is set up like that tho.  Ingo, Thomas, any ideas?

-- 
tejun
