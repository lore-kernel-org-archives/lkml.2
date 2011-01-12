Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359Ab1ALUkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 15:40:05 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:28233 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756315Ab1ALUkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 15:40:01 -0500
Date: Wed, 12 Jan 2011 21:39:59 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-mm@kvack.org
cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
        Pavel Emelianov <xemul@openvz.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mm: Remove two memset calls in mm/memcontrol.c by using the
 zalloc variants of alloc functions
Message-ID: <alpine.LNX.2.00.1101122135070.22297@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We can avoid two calls to memset() in mm/memcontrol.c by using 
kzalloc_node(), kzalloc & vzalloc().

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 memcontrol.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 00bb8a6..890df27 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4176,12 +4176,11 @@ static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *mem, int node)
 	 */
 	if (!node_state(node, N_NORMAL_MEMORY))
 		tmp = -1;
-	pn = kmalloc_node(sizeof(*pn), GFP_KERNEL, tmp);
+	pn = kzalloc_node(sizeof(*pn), GFP_KERNEL, tmp);
 	if (!pn)
 		return 1;
 
 	mem->info.nodeinfo[node] = pn;
-	memset(pn, 0, sizeof(*pn));
 
 	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
 		mz = &pn->zoneinfo[zone];
@@ -4206,14 +4205,13 @@ static struct mem_cgroup *mem_cgroup_alloc(void)
 
 	/* Can be very big if MAX_NUMNODES is very big */
 	if (size < PAGE_SIZE)
-		mem = kmalloc(size, GFP_KERNEL);
+		mem = kzalloc(size, GFP_KERNEL);
 	else
-		mem = vmalloc(size);
+		mem = vzalloc(size);
 
 	if (!mem)
 		return NULL;
 
-	memset(mem, 0, size);
 	mem->stat = alloc_percpu(struct mem_cgroup_stat_cpu);
 	if (!mem->stat)
 		goto out_free;



-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

