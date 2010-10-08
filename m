Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab0JHW64 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 18:58:56 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:65235 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab0JHW6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 18:58:54 -0400
Message-ID: <4CAFA1DB.6010802@kernel.org>
Date: Fri, 08 Oct 2010 15:57:31 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Russ Anderson <rja@sgi.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
        "H. Peter Anvin" <h.peter.anvin@intel.com>,
        Jack Steiner <steiner@sgi.com>
Subject: Re: [BUG] x86: bootmem broken on SGI UV
References: <20101008213429.GB7223@sgi.com>
In-Reply-To: <20101008213429.GB7223@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2010 02:34 PM, Russ Anderson wrote:
> 	[BUG] x86: bootmem broken on SGI UV
> 
> Recent community kernels do not boot on SGI UV x86 hardware with
> more than one socket.  I suspect the problem is due to recent 
> bootmem/e820 changes.
> 
> What is happening is the e280 table defines a memory range.
> 
>  BIOS-e820: 0000000100000000 - 0000001080000000 (usable)
> 
> The SRAT table shows that memory range is spread over two nodes.
> 
>  SRAT: Node 0 PXM 0 100000000-800000000
>  SRAT: Node 1 PXM 1 800000000-1000000000
>  SRAT: Node 0 PXM 0 1000000000-1080000000
> 
> Previously, the kernel early_node_map[] would show three entries
> with the proper node.
>                                                                                 
> [    0.000000]     0: 0x00100000 -> 0x00800000
> [    0.000000]     1: 0x00800000 -> 0x01000000
> [    0.000000]     0: 0x01000000 -> 0x01080000
> 
> The problem is recent community kernel early_node_map[] shows 
> only two entries with the node 0 entry overlapping the node 1
> entry.
> 
>     0: 0x00100000 -> 0x01080000
>     1: 0x00800000 -> 0x01000000
> 
> This results in the range 0x800000 -> 0x1000000 getting freed twice
> (by free_all_memory_core_early()) resulting in nasty warnings.

please check

[PATCH] x86, numa: Fix cross nodes mem conf

Russ reported SGI UV is broken recently. He said:

| The SRAT table shows that memory range is spread over two nodes.
|
| SRAT: Node 0 PXM 0 100000000-800000000
| SRAT: Node 1 PXM 1 800000000-1000000000
| SRAT: Node 0 PXM 0 1000000000-1080000000
|
|Previously, the kernel early_node_map[] would show three entries
|with the proper node.
|
|[    0.000000]     0: 0x00100000 -> 0x00800000
|[    0.000000]     1: 0x00800000 -> 0x01000000
|[    0.000000]     0: 0x01000000 -> 0x01080000
|
|The problem is recent community kernel early_node_map[] shows
|only two entries with the node 0 entry overlapping the node 1
|entry.
|
|    0: 0x00100000 -> 0x01080000
|    1: 0x00800000 -> 0x01000000

After looking at the changelog, it turns out it is broken for a while by
following commit

|commit 8716273caef7f55f39fe4fc6c69c5f9f197f41f1
|Author: David Rientjes <rientjes@google.com>
|Date:   Fri Sep 25 15:20:04 2009 -0700
|
|    x86: Export srat physical topology

before that commit, register_active_regions() is called SRAT memory entries.

Try to use nodememblk_range[] instead of nodes[].

For stable tree: from 2.6.33 to 2.3.36 need this patch by
changing memblock_x86_register_active_regions() with e820_register_active_regions()

Reported-by: Russ Anderson <rja@sgi.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: stable@kernel.org

---
 arch/x86/mm/srat_64.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/mm/srat_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/srat_64.c
+++ linux-2.6/arch/x86/mm/srat_64.c
@@ -421,9 +421,11 @@ int __init acpi_scan_nodes(unsigned long
 		return -1;
 	}
 
-	for_each_node_mask(i, nodes_parsed)
-		memblock_x86_register_active_regions(i, nodes[i].start >> PAGE_SHIFT,
-						nodes[i].end >> PAGE_SHIFT);
+	for (i = 0; i < num_node_memblks; i++)
+		memblock_x86_register_active_regions(memblk_nodeid[i],
+						node_memblk_range[i].start >> PAGE_SHIFT,
+						node_memblk_range[i].end >> PAGE_SHIFT);
+
 	/* for out of order entries in SRAT */
 	sort_node_map();
 	if (!nodes_cover_memory(nodes)) {
