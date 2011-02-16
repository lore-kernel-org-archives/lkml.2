Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759149Ab1BPMXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 07:23:43 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52471 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932342Ab1BPMWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 07:22:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=jtSMc84LedM8XBQa87XrKW42TEwlTDM5YG4fKr6LQdqi/8ns/YjF1FtxGgM0YPkAjw
         tLIHR6gMi2HDPh8xrh8UilsD79n9gI/QegKjMIRy4GTdI/X6MnmxQtpY3JifNfw3DFnI
         sq3/PwrhI6gOIEA0CSOVd4m3JdCk2sKasM1Ac=
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org, yinghai@kernel.org,
        brgerst@gmail.com, gorcunov@gmail.com, shaohui.zheng@intel.com,
        rientjes@google.com, mingo@elte.hu, hpa@linux.intel.com,
        ankita@in.ibm.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 30/33] x86-64, NUMA: Wrap node ID during emulation
Date: Wed, 16 Feb 2011 13:21:04 +0100
Message-Id: <1297858867-25981-31-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1297858867-25981-1-git-send-email-tj@kernel.org>
References: <1297858867-25981-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both emulation layout functions - split_nodes[_size]_interleave() -
didn't wrap emulated nid while laying out the fake nodes and tried to
avoid interating over the specified number of nodes, which is fragile.

Now that the emulation code generates numa_meminfo, the node memblks
don't need to be consecutive and emulated node IDs can simply wrap.
This makes the code more robust and is necessary for updates to better
handle the cases where the physical nodes are interleaved.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Brian Gerst <brgerst@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Shaohui Zheng <shaohui.zheng@intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/numa_64.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 30c087d..040d0ff 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -768,15 +768,7 @@ static int __init split_nodes_interleave(struct numa_meminfo *ei,
 			    memblock_x86_hole_size(end, physnodes[i].end) < size)
 				end = physnodes[i].end;
 
-			/*
-			 * Avoid allocating more nodes than requested, which can
-			 * happen as a result of rounding down each node's size
-			 * to FAKE_NODE_MIN_SIZE.
-			 */
-			if (nodes_weight(physnode_mask) + nid >= nr_nodes)
-				end = physnodes[i].end;
-
-			ret = emu_setup_memblk(ei, nid++, i,
+			ret = emu_setup_memblk(ei, nid++ % nr_nodes, i,
 					       physnodes[i].start,
 					       min(end, physnodes[i].end));
 			if (ret < 0)
@@ -873,7 +865,7 @@ static int __init split_nodes_size_interleave(struct numa_meminfo *ei,
 			    memblock_x86_hole_size(end, physnodes[i].end) < size)
 				end = physnodes[i].end;
 
-			ret = emu_setup_memblk(ei, nid++, i,
+			ret = emu_setup_memblk(ei, nid++ % MAX_NUMNODES, i,
 					       physnodes[i].start,
 					       min(end, physnodes[i].end));
 			if (ret < 0)
-- 
1.7.1

