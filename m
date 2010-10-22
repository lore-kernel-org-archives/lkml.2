Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759685Ab0JVTJe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:09:34 -0400
Received: from kroah.org ([198.145.64.141]:34220 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753295Ab0JVS4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:56:37 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:52:32 2010
Message-Id: <20101022185232.488125117@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:51:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Yinghai Lu <yinghai@kernel.org>, David Rientjes <rientjes@google.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [057/103] x86, numa: For each node, register the memory blocks actually used
In-Reply-To: <20101022185455.GA9114@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yinghai Lu <yinghai@kernel.org>

commit 73cf624d029d776a33d0a80c695485b3f9b36231 upstream.

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

Use nodememblk_range[] instead of nodes[] in order to make sure we
capture the actual memory blocks registered with each node.  nodes[]
contains an extended range which spans all memory regions associated
with a node, but that does not mean that all the memory in between are
included.

Reported-by: Russ Anderson <rja@sgi.com>
Tested-by: Russ Anderson <rja@sgi.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <4CB27BDF.5000800@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/mm/srat_64.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
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


