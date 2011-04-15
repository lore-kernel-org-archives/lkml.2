Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756986Ab1DOUwW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 16:52:22 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:41943 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756095Ab1DOUrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 16:47:51 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: zFbSt5wVM1ldwcRzEyJTxyV1UYXx0C42Rf4HJULbCS3qMRf
 Gr9lEgdY_aCx7L2h22s_8cPrTLc6QZWSpHdlUMXMnicrldhqqLq_JiQ8aCOM
 NPxSZ7tt8OgAmCc7ftEVFHGA0XRF4OVkd8WlLbdoZOueQswI8_hBuuEwy_4k
 iYQmKw67hSAsPt9drJgoqldvb5tL2IVswPFECQEVrr10Sp3ovQPwr6Skyb42
 lGPdtaOgQ1opRlrjbPicnRDGIUuler1Fr.nRaev6IVuXTAZlJQXScrP2wwsK
 coL1oWHyw0Yx4mT9rhM.b3M9DrqHreQ5dVztMPwMRSZRfzUGavrwiVRrytP8
 -
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110415204749.520037696@linux.com>
User-Agent: quilt/0.48-1
Date: Fri, 15 Apr 2011 15:47:36 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org
Subject: [slubllv3 06/21] slub: Per object NUMA support
References: <20110415204730.326790555@linux.com>
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
 mm/slub.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-04-15 12:54:42.000000000 -0500
+++ linux-2.6/mm/slub.c	2011-04-15 13:11:25.000000000 -0500
@@ -1887,6 +1887,21 @@ debug:
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
@@ -1911,6 +1926,7 @@ static __always_inline void *slab_alloc(
 	if (slab_pre_alloc_hook(s, gfpflags))
 		return NULL;
 
+	node = alternate_slab_node(s, gfpflags, node);
 #ifndef CONFIG_CMPXCHG_LOCAL
 	local_irq_save(flags);
 #else

