Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab1CREKi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 00:10:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64908 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750786Ab1CREKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 00:10:33 -0400
Message-ID: <4D82DBA3.5020306@cn.fujitsu.com>
Date: Fri, 18 Mar 2011 12:12:19 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Namhyung Kim <namhyung@gmail.com>, Pekka Enberg <penberg@kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 33/36] vmalloc,rcu: convert call_rcu(rcu_free_va) to kfree_rcu()
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 12:09:10,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-03-18 12:09:11,
	Serialize complete at 2011-03-18 12:09:11
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



The rcu callback rcu_free_va() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(rcu_free_va).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 mm/vmalloc.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index f9b1667..fe38e30 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -416,13 +416,6 @@ overflow:
 	return va;
 }
 
-static void rcu_free_va(struct rcu_head *head)
-{
-	struct vmap_area *va = container_of(head, struct vmap_area, rcu_head);
-
-	kfree(va);
-}
-
 static void __free_vmap_area(struct vmap_area *va)
 {
 	BUG_ON(RB_EMPTY_NODE(&va->rb_node));
@@ -439,7 +432,7 @@ static void __free_vmap_area(struct vmap_area *va)
 	if (va->va_end > VMALLOC_START && va->va_end <= VMALLOC_END)
 		vmap_area_pcpu_hole = max(vmap_area_pcpu_hole, va->va_end);
 
-	call_rcu(&va->rcu_head, rcu_free_va);
+	kfree_rcu(va, rcu_head);
 }
 
 /*
-- 
1.7.4
