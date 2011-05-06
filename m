Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846Ab1EFSG7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 14:06:59 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:45241 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752425Ab1EFSG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 14:06:57 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: GZrmJMUVM1l0M6JPHEYzei7QExIDiAYBGl5mBCHHcZTOiUW
 flZnIRfPrHx4O.wE5LPazWV6roFT3cj2M9sI6doRiPJaiX6R5AerFThFc7Ug
 AwST_ZdXsC.jGhjyj3s5EiJ4dIihychTbIy3BVj15Ou3O63Gbn.jF6hTJuzF
 lfse5snNmNdwoh9VRD5ZASg6_auCDd48njFvuWIYRhLy2yR9z0kCItPX.TnS
 9ofZ6zq7OnWLCzplv0gJWiAyoUemtpkdhFr43CepX0Cdfr61YVp0iVY726zT
 3ccpaeqASmeSmbQGJjbxia9fWLZ7pabbLTYfxFl7qyadrDc.6m6E5kujs5Il
 xAy41EodT8L5_PEpBsBhoHyva
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110506180654.663421389@linux.com>
User-Agent: quilt/0.48-1
Date: Fri, 06 May 2011 13:05:42 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [slubllv4 01/16] slub: Per object NUMA support
References: <20110506180541.990069206@linux.com>
Content-Disposition: inline; filename=rr_slabs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently slub applies NUMA policies per allocated slab page. Change
that to apply memory policies for each individual object allocated.

F.e. before this patch MPOL_INTERLEAVE would return objects from the
same slab page until a new slab page was allocated. Now an object
from a different page is taken for each allocation.

This increases the overhead of the fastpath under NUMA.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 mm/slub.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-05-05 15:21:51.000000000 -0500
+++ linux-2.6/mm/slub.c	2011-05-05 15:28:33.000000000 -0500
@@ -1873,6 +1873,21 @@ debug:
 	goto unlock_out;
 }
 
+static __always_inline int alternate_slab_node(struct kmem_cache *s,
+						gfp_t flags, int node)
+{
+#ifdef CONFIG_NUMA
+	if (unlikely(node == NUMA_NO_NODE &&
+			!(flags & __GFP_THISNODE) &&
+			!in_interrupt())) {
+		if ((s->flags & SLAB_MEM_SPREAD) && cpuset_do_slab_mem_spread())
+			node = cpuset_slab_spread_node();
+		else if (current->mempolicy)
+		node = slab_node(current->mempolicy);
+	}
+#endif
+	return node;
+}
 /*
  * Inlined fastpath so that allocation functions (kmalloc, kmem_cache_alloc)
  * have the fastpath folded into their functions. So no function call
@@ -1893,6 +1908,8 @@ static __always_inline void *slab_alloc(
 	if (slab_pre_alloc_hook(s, gfpflags))
 		return NULL;
 
+	node = alternate_slab_node(s, gfpflags, node);
+
 redo:
 
 	/*

