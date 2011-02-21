Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab1BUKUr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 05:20:47 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51908 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab1BUKUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 05:20:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=shK5g5r07lkmIgjKxyW7si+bSZrBsIshPCLGGVYUxP6yySlgX3GVcekjwd83IeYs49
         CK+TChuzIuTTFO8CkRqfBIlwotkM7YzFviMk/Y+t4jHSKazl/IVz0B/AAu2Vk+aeb2fk
         +Is8jT6Mv4nQiRAqCflkLstyeokMez5b0B6pk=
Date: Mon, 21 Feb 2011 11:20:40 +0100
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH] x86-64, NUMA: Do not scan two times for
 setup_node_bootmem()
Message-ID: <20110221102040.GI31267@htj.dyndns.org>
References: <4D5EC05A.60103@kernel.org>
 <4D5EC177.7030101@kernel.org>
 <alpine.DEB.2.00.1102191942420.32280@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1102191942420.32280@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2d389b34c02cbc36c561a309735f69568aa9c3ea Mon Sep 17 00:00:00 2001
From: Yinghai Lu <yinghai@kernel.org>
Date: Mon, 21 Feb 2011 10:58:13 +0100

By the time setup_node_bootmem() is called, all the memblocks are
already registered.  As node_data is allocated from these memblocks,
calling it more than once doesn't make any difference.  Drop the loop.

tj: Rephrased description.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
Applied to x86-numa.  I dropped the comment David pointed out and
redid the description.  If you are unhappy with me redoing the
descriptions, please scream.

Thanks.

 arch/x86/mm/numa_64.c |   32 ++++++++++++--------------------
 1 files changed, 12 insertions(+), 20 deletions(-)

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index f6d85e3..6e4ee96 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -480,7 +480,7 @@ static bool __init numa_meminfo_cover_memory(const struct numa_meminfo *mi)
 
 static int __init numa_register_memblks(struct numa_meminfo *mi)
 {
-	int i, j, nid;
+	int i, nid;
 
 	/* Account for nodes with cpus and no memory */
 	node_possible_map = numa_nodes_parsed;
@@ -506,28 +506,20 @@ static int __init numa_register_memblks(struct numa_meminfo *mi)
 
 	init_memory_mapping_high();
 
-	/*
-	 * Finally register nodes.  Do it twice in case setup_node_bootmem
-	 * missed one due to missing bootmem.
-	 */
-	for (i = 0; i < 2; i++) {
-		for_each_node_mask(nid, node_possible_map) {
-			u64 start = (u64)max_pfn << PAGE_SHIFT;
-			u64 end = 0;
+	/* Finally register nodes. */
+	for_each_node_mask(nid, node_possible_map) {
+		u64 start = (u64)max_pfn << PAGE_SHIFT;
+		u64 end = 0;
 
-			if (node_online(nid))
+		for (i = 0; i < mi->nr_blks; i++) {
+			if (nid != mi->blk[i].nid)
 				continue;
-
-			for (j = 0; j < mi->nr_blks; j++) {
-				if (nid != mi->blk[j].nid)
-					continue;
-				start = min(mi->blk[j].start, start);
-				end = max(mi->blk[j].end, end);
-			}
-
-			if (start < end)
-				setup_node_bootmem(nid, start, end);
+			start = min(mi->blk[i].start, start);
+			end = max(mi->blk[i].end, end);
 		}
+
+		if (start < end)
+			setup_node_bootmem(nid, start, end);
 	}
 
 	return 0;
-- 
1.7.1

