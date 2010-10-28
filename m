Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758498Ab0J1MaY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 08:30:24 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50006 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754408Ab0J1MaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 08:30:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=oHAhQhWHcBgtcEEFQAhLV7r1dvTNX/Z0PNx4nEDmwbIgrGHyamBQsMHZODIDA06NDo
         fMLlElUOCOImhvKlqQjexbS8GG9YRc3/UTcA59FWWB9mbPx/K8vvsIbVdU0E1bwcdaqg
         bFN+FiOWISLdgdZAXA+lGZ7yaQf6/p97EZYc8=
Subject: Re: [PATCH] x86-32: Allocate irq stacks seperate from percpu area
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Brian Gerst <brgerst@gmail.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, mingo@elte.hu
In-Reply-To: <4CC965FF.8000601@kernel.org>
References: <AANLkTinnc3vBSmewf7ixuOSDYxG+5VNiGaB-vSrDNRiO@mail.gmail.com>
	 <1288158182-1753-1-git-send-email-brgerst@gmail.com>
	 <1288159670.2652.181.camel@edumazet-laptop>
	 <1288173442.15336.1490.camel@twins>
	 <1288186405.2709.117.camel@edumazet-laptop>  <4CC82C2F.1020707@kernel.org>
	 <1288187870.2709.128.camel@edumazet-laptop>  <4CC83067.5000009@kernel.org>
	 <1288189461.2709.144.camel@edumazet-laptop>
	 <1288190387.2709.147.camel@edumazet-laptop>  <4CC83A85.3070608@kernel.org>
	 <1288192868.2709.152.camel@edumazet-laptop>  <4CC846D5.50106@kernel.org>
	 <1288212951.2658.51.camel@edumazet-laptop>  <4CC965FF.8000601@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Oct 2010 14:30:18 +0200
Message-ID: <1288269018.2649.421.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 28 octobre 2010 à 14:01 +0200, Tejun Heo a écrit :
> Hello, Eric.
> 
> On 10/27/2010 10:55 PM, Eric Dumazet wrote:
> > I changed the User/Kernel split from 3G/1G to 1G/3G so that I have
> > LOWMEM on both nodes. Still pcpu allocates all percpu from node0.
> ...
> > [    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:16 nr_node_ids:8
> > [    0.000000] PERCPU: Embedded 16 pages/cpu @bea00000 s41984 r0 d23552 u131072
> > [    0.000000] pcpu-alloc: s41984 r0 d23552 u131072 alloc=1*2097152
> > [    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 
> > [    0.000000] setup_percpu: cpu=0 early_cpu_to_node()=0
> > [    0.000000] setup_percpu: cpu=1 early_cpu_to_node()=0
> > [    0.000000] setup_percpu: cpu=2 early_cpu_to_node()=0
> > [    0.000000] setup_percpu: cpu=3 early_cpu_to_node()=0
> > [    0.000000] setup_percpu: cpu=4 early_cpu_to_node()=0
> > [    0.000000] setup_percpu: cpu=5 early_cpu_to_node()=0
> > [    0.000000] setup_percpu: cpu=6 early_cpu_to_node()=0
> > [    0.000000] setup_percpu: cpu=7 early_cpu_to_node()=0
> > [    0.000000] setup_percpu: cpu=8 early_cpu_to_node()=0
> > [    0.000000] setup_percpu: cpu=9 early_cpu_to_node()=0
> > [    0.000000] setup_percpu: cpu=10 early_cpu_to_node()=0
> > [    0.000000] setup_percpu: cpu=11 early_cpu_to_node()=0
> > [    0.000000] setup_percpu: cpu=12 early_cpu_to_node()=0
> > [    0.000000] setup_percpu: cpu=13 early_cpu_to_node()=0
> > [    0.000000] setup_percpu: cpu=14 early_cpu_to_node()=0
> > [    0.000000] setup_percpu: cpu=15 early_cpu_to_node()=0
> 
> So, this is the problem.  percpu uses early_cpu_to_node() to determine
> which cpu belongs to which NUMA node and according to it all CPUs are
> on node 0, so percpu is configured accordingly.  I have no idea why
> early_cpu_to_node() is set up like that tho.  Ingo, Thomas, any ideas?
> 

CONFIG_X86_32

early_cpu_to_node() uses cpu_to_node_map[]

Set in map_cpu_to_node(), _after_ pcpu stuff if you look at my previous
dmesg output.

arch/x86/kernel/smpboot.c
int cpu_to_node_map[NR_CPUS] __read_mostly = { [0 ... NR_CPUS-1] = 0 };

static void map_cpu_to_node(int cpu, int node)
{
	printk(KERN_INFO "Mapping cpu %d to node %d\n", cpu, node);
	cpumask_set_cpu(cpu, node_to_cpumask_map[node]);
	cpu_to_node_map[cpu] = node;
}

[    0.013437] Mapping cpu 0 to node 1
[    0.172421] Mapping cpu 1 to node 0
[    0.280357] Mapping cpu 2 to node 1
[    0.388310] Mapping cpu 3 to node 0
[    0.496494] Mapping cpu 4 to node 1
[    0.604182] Mapping cpu 5 to node 0
[    0.712050] Mapping cpu 6 to node 1
[    0.820102] Mapping cpu 7 to node 0
...


I added this bit in acpi_map_cpu2node(), just in case.

diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index c05872a..f995d3a 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -561,6 +561,7 @@ static void acpi_map_cpu2node(acpi_handle handle,
int cpu, int physid)
 	numa_set_node(cpu, nid);
 #else /* CONFIG_X86_32 */
 	apicid_2_node[physid] = nid;
+	pr_err("cpu_to_node_map(cpu=%d)=%d\n", cpu, nid);
 	cpu_to_node_map[cpu] = nid;
 #endif
 


Seems to be not called.



