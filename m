Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753006Ab0JKCyG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 22:54:06 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:34939 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab0JKCyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 22:54:03 -0400
Message-ID: <4CB27BDF.5000800@kernel.org>
Date: Sun, 10 Oct 2010 19:52:15 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <h.peter.anvin@intel.com>
CC: Robin Holt <holt@sgi.com>, Russ Anderson <rja@sgi.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
        Jack Steiner <steiner@sgi.com>
Subject: [PATCH -v3] x86, numa: Fix cross nodes memory configuration
References: <20101008213429.GB7223@sgi.com> <4CAFA1DB.6010802@kernel.org> <20101009125944.GA18248@sgi.com> <20101009163908.GX14068@sgi.com> <20101010104129.GB30271@elte.hu> <20101010104319.GA9862@elte.hu> <20101010114459.GY14068@sgi.com> <20101010115605.GC14064@sgi.com> <20101010140554.GB20400@elte.hu> <20101010225134.GD14064@sgi.com>
In-Reply-To: <20101010225134.GD14064@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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

After looking at the changelog, Found out that it has been broken for a while by
following commit

|commit 8716273caef7f55f39fe4fc6c69c5f9f197f41f1
|Author: David Rientjes <rientjes@google.com>
|Date:   Fri Sep 25 15:20:04 2009 -0700
|
|    x86: Export srat physical topology

Before that commit, register_active_regions() is called for every SRAT memory
entry right away.

Try to use nodememblk_range[] instead of nodes[].

For stable tree: from 2.6.33 to 2.3.36 need this patch

-v3: update to linus's tree.

Reported-by: Russ Anderson <rja@sgi.com>
Tested-by: Russ Anderson <rja@sgi.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: stable@kernel.org

---
 arch/x86/mm/srat_64.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/mm/srat_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/srat_64.c
+++ linux-2.6/arch/x86/mm/srat_64.c
@@ -420,9 +420,11 @@ int __init acpi_scan_nodes(unsigned long
 		return -1;
 	}
 
-	for_each_node_mask(i, nodes_parsed)
-		e820_register_active_regions(i, nodes[i].start >> PAGE_SHIFT,
-						nodes[i].end >> PAGE_SHIFT);
+	for (i = 0; i < num_node_memblks; i++)
+		e820_register_active_regions(memblk_nodeid[i],
+				node_memblk_range[i].start >> PAGE_SHIFT,
+				node_memblk_range[i].end >> PAGE_SHIFT);
+
 	/* for out of order entries in SRAT */
 	sort_node_map();
 	if (!nodes_cover_memory(nodes)) {
