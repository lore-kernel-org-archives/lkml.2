Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab0JKW26 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 18:28:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:44864 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756587Ab0JKW24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 18:28:56 -0400
Date: Mon, 11 Oct 2010 22:28:34 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, rja@sgi.com, tglx@linutronix.de,
        rientjes@google.com, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, rja@sgi.com, tglx@linutronix.de,
        rientjes@google.com, hpa@linux.intel.com
In-Reply-To: <4CB27BDF.5000800@kernel.org>
References: <4CB27BDF.5000800@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, numa: For each node, register the memory blocks actually used
Message-ID: <tip-73cf624d029d776a33d0a80c695485b3f9b36231@git.kernel.org>
Git-Commit-ID: 73cf624d029d776a33d0a80c695485b3f9b36231
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 11 Oct 2010 22:28:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  73cf624d029d776a33d0a80c695485b3f9b36231
Gitweb:     http://git.kernel.org/tip/73cf624d029d776a33d0a80c695485b3f9b36231
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Sun, 10 Oct 2010 19:52:15 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 11 Oct 2010 15:26:15 -0700

x86, numa: For each node, register the memory blocks actually used

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
Cc: <stable@kernel.org> 2.6.33 .34 .35 .36
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/srat_64.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/srat_64.c b/arch/x86/mm/srat_64.c
index f9897f7..9c0d0d3 100644
--- a/arch/x86/mm/srat_64.c
+++ b/arch/x86/mm/srat_64.c
@@ -420,9 +420,11 @@ int __init acpi_scan_nodes(unsigned long start, unsigned long end)
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
