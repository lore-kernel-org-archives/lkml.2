Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab1BXWqs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 17:46:48 -0500
Received: from smtp-out.google.com ([216.239.44.51]:63335 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab1BXWqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 17:46:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=UgCUHPKBhbUFZQBzY5XkCenC+TG65ax0S9eWaOzXRVoZSbgAOVDcPDehV4OiZEEgq5
         UAgE43ryz9DqazaM5tXQ==
Date: Thu, 24 Feb 2011 14:46:38 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>
cc: Yinghai Lu <yinghai@kernel.org>, tglx@linutronix.de,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: [patch] x86, mm: Fix size of numa_distance array
In-Reply-To: <AANLkTimvJ=BLDjoRDXg_TRSepd9GoDx-w_FonSCZtybi@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1102241330270.28798@chino.kir.corp.google.com>
References: <20110224145128.GM7840@htj.dyndns.org> <4D66AC9C.6080500@kernel.org> <20110224192305.GB15498@elte.hu> <4D66B176.9030300@kernel.org> <20110224193211.GC15498@elte.hu> <AANLkTimvJ=BLDjoRDXg_TRSepd9GoDx-w_FonSCZtybi@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Feb 2011, Tejun Heo wrote:

> >> DavidR reported that x86/mm broke his numa emulation with 128M etc.
> >
> > That regression needs to be fixed. Tejun, do you know about that bug?
> 
> Nope, David said he was gonna look into what happened but never got
> back.  David?
> 

I merged x86/mm with Linus' tree, it booted fine without numa=fake but 
then panics with numa=fake=128M (and could only be captured by 
earlyprintk):

[    0.000000] BUG: unable to handle kernel paging request at ffff88007ff00000
[    0.000000] IP: [<ffffffff818ffc15>] numa_alloc_distance+0x146/0x17a
[    0.000000] PGD 1804063 PUD 7fefd067 PMD 7fefe067 PTE 0
[    0.000000] Oops: 0002 [#1] SMP 
[    0.000000] last sysfs file: 
[    0.000000] CPU 0 
[    0.000000] Modules linked in:
[    0.000000] 
[    0.000000] Pid: 0, comm: swapper Not tainted 2.6.38-x86-mm #1
[    0.000000] RIP: 0010:[<ffffffff818ffc15>]  [<ffffffff818ffc15>] numa_alloc_distance+0x146/0x17a
[    0.000000] RSP: 0000:ffffffff81801d28  EFLAGS: 00010006
[    0.000000] RAX: 0000000000000009 RBX: 00000000000001ff RCX: 0000000000000ff8
[    0.000000] RDX: 0000000000000008 RSI: 000000007feff014 RDI: ffffffff8199ed0a
[    0.000000] RBP: ffffffff81801dc8 R08: 0000000000001000 R09: 000000008199ed0a
[    0.000000] R10: 000000007feff004 R11: 000000007fefd000 R12: 00000000000001ff
[    0.000000] R13: ffff88007feff000 R14: ffffffff81801d28 R15: ffffffff819b7ca0
[    0.000000] FS:  0000000000000000(0000) GS:ffffffff818da000(0000) knlGS:0000000000000000
[    0.000000] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    0.000000] CR2: ffff88007ff00000 CR3: 0000000001803000 CR4: 00000000000000b0
[    0.000000] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    0.000000] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[    0.000000] Process swapper (pid: 0, threadinfo ffffffff81800000, task ffffffff8180b020)
[    0.000000] Stack:
[    0.000000]  ffffffffffffffff ffffffffffffffff ffffffffffffffff ffffffffffffffff
[    0.000000]  ffffffffffffffff ffffffffffffffff ffffffffffffffff 7fffffffffffffff
[    0.000000]  0000000000000000 0000000000000000 0000000000000000 0000000000000000
[    0.000000] Call Trace:
[    0.000000]  [<ffffffff818ffc6d>] numa_set_distance+0x24/0xac
[    0.000000]  [<ffffffff81901581>] numa_emulation+0x236/0x284
[    0.000000]  [<ffffffff81900a0a>] ? x86_acpi_numa_init+0x0/0x1b
[    0.000000]  [<ffffffff8190020a>] initmem_init+0xe8/0x56c
[    0.000000]  [<ffffffff8104fa43>] ? native_apic_mem_read+0x9/0x13
[    0.000000]  [<ffffffff81900a0a>] ? x86_acpi_numa_init+0x0/0x1b
[    0.000000]  [<ffffffff8190068e>] ? amd_numa_init+0x0/0x376
[    0.000000]  [<ffffffff818ffa69>] ? dummy_numa_init+0x0/0x66
[    0.000000]  [<ffffffff818f974f>] ? register_lapic_address+0x75/0x85
[    0.000000]  [<ffffffff818f1b86>] setup_arch+0xa29/0xae9
[    0.000000]  [<ffffffff81456552>] ? printk+0x41/0x47
[    0.000000]  [<ffffffff818eda0d>] start_kernel+0x8a/0x386
[    0.000000]  [<ffffffff818ed2a4>] x86_64_start_reservations+0xb4/0xb8
[    0.000000]  [<ffffffff818ed39a>] x86_64_start_kernel+0xf2/0xf9

That's this:

430		numa_distance_cnt = cnt;
431	
432		/* fill with the default distances */
433		for (i = 0; i < cnt; i++)
434			for (j = 0; j < cnt; j++)
435	===>			numa_distance[i * cnt + j] = i == j ?
436					LOCAL_DISTANCE : REMOTE_DISTANCE;
437		printk(KERN_DEBUG "NUMA: Initialized distance table, cnt=%d\n", cnt);
438	
439		return 0;

We're overflowing the array and it's easy to see why:

        for_each_node_mask(i, nodes_parsed)
                cnt = i;
        size = ++cnt * sizeof(numa_distance[0]);

cnt is the highest node id parsed, so numa_distance[] must be cnt * cnt.  
The following patch fixes the issue on top of x86/mm.

I'm running on a 64GB machine with CONFIG_NODES_SHIFT == 10, so 
numa=fake=128M would result in 512 nodes.  That's going to require 2MB for 
numa_distance (and that's not __initdata).  Before these changes, we 
calculated numa_distance() using pxms without this additional mapping, is 
there any way to reduce this?  (Admittedly real NUMA machines with 512 
nodes wouldn't mind sacrificing 2MB, but we didn't need this before.)



x86, mm: Fix size of numa_distance array

numa_distance should be sized like the SLIT, an NxN matrix where N is the
highest node id.  This patch fixes the calulcation to avoid overflowing
the array on the subsequent iteration.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86/mm/numa_64.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index cccc01d..abf0131 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -414,7 +414,7 @@ static int __init numa_alloc_distance(void)
 
 	for_each_node_mask(i, nodes_parsed)
 		cnt = i;
-	size = ++cnt * sizeof(numa_distance[0]);
+	size = cnt * cnt * sizeof(numa_distance[0]);
 
 	phys = memblock_find_in_range(0, (u64)max_pfn_mapped << PAGE_SHIFT,
 				      size, PAGE_SIZE);
