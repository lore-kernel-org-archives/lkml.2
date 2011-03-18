Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab1CREL2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 00:11:28 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60503 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750786Ab1CRELW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 00:11:22 -0400
Message-ID: <4D82DBD4.8040407@cn.fujitsu.com>
Date: Fri, 18 Mar 2011 12:13:08 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Namhyung Kim <namhyung@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 34/36] vmalloc,rcu: convert call_rcu(rcu_free_vb) to kfree_rcu()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 12:09:59,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 12:10:00,
	Serialize complete at 2011-03-18 12:10:00
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



The rcu callback rcu_free_vb() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(rcu_free_vb).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 mm/vmalloc.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index fe38e30..2f3c614 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -778,13 +778,6 @@ static struct vmap_block *new_vmap_block(gfp_t gfp_mask)
 	return vb;
 }
 
-static void rcu_free_vb(struct rcu_head *head)
-{
-	struct vmap_block *vb = container_of(head, struct vmap_block, rcu_head);
-
-	kfree(vb);
-}
-
 static void free_vmap_block(struct vmap_block *vb)
 {
 	struct vmap_block *tmp;
@@ -797,7 +790,7 @@ static void free_vmap_block(struct vmap_block *vb)
 	BUG_ON(tmp != vb);
 
 	free_vmap_area_noflush(vb->va);
-	call_rcu(&vb->rcu_head, rcu_free_vb);
+	kfree_rcu(vb, rcu_head);
 }
 
 static void purge_fragmented_blocks(int cpu)
-- 
1.7.4
