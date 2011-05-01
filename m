Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758317Ab1EAN0D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 May 2011 09:26:03 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:45050 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757728Ab1EANWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 May 2011 09:22:39 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@gmail.com>,
        David Rientjes <rientjes@google.com>
Subject: [PATCH tip/core/rcu 85/86] vmalloc,rcu: convert call_rcu(rcu_free_va) to kfree_rcu()
Date: Sun,  1 May 2011 06:22:05 -0700
Message-Id: <1304256126-26015-85-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110501132142.GA25494@linux.vnet.ibm.com>
References: <20110501132142.GA25494@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

The rcu callback rcu_free_va() just calls a kfree(),
so we use kfree_rcu() instead of the call_rcu(rcu_free_va).

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: David Rientjes <rientjes@google.com>
---
 mm/vmalloc.c |    9 +--------
 1 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 5d60302..73f56c8 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -452,13 +452,6 @@ overflow:
 	return ERR_PTR(-EBUSY);
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
@@ -491,7 +484,7 @@ static void __free_vmap_area(struct vmap_area *va)
 	if (va->va_end > VMALLOC_START && va->va_end <= VMALLOC_END)
 		vmap_area_pcpu_hole = max(vmap_area_pcpu_hole, va->va_end);
 
-	call_rcu(&va->rcu_head, rcu_free_va);
+	kfree_rcu(va, rcu_head);
 }
 
 /*
-- 
1.7.3.2

