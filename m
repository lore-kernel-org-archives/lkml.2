Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab1DOT4T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 15:56:19 -0400
Received: from smtp103.prem.mail.ac4.yahoo.com ([76.13.13.42]:44597 "HELO
	smtp103.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750726Ab1DOT4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 15:56:18 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: X6X1sHoVM1k5rt..wFsn86V8MC.n4Sa7yeAmpztvOzBSg2w
 28OfR064p60DaGoyER7Xs.HCiEKBzKaD6og.zzSOyC.EqZn2Sv6SRmrYI4VT
 1qXJPTh1Gt8ubRAPcoILVAUuT32aYXZf3F2slcQ66fLqwu_JfQrl8UFZxqA0
 nOH1fFlXJ6zpN0ybvh6s1d9MncKTw6zf_P919Jit0iQWY5PskXHG06tkDsdc
 cNAegDQqvOPCHmmYp02ETHXkQdPg_aFjKcx5oFDMe3OqMI4gTVC60aLRFk6E
 oIF7QdgbJfGajPfQ701yGIT3K9ooV2ouxFJjYWBqhczKmc46X
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 15 Apr 2011 14:56:14 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [RFC] slub: Per object NUMA support
Message-ID: <alpine.DEB.2.00.1104151449370.12627@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am not sure if such a feature is needed/wanted/desired. It would make
the object allocation method similar to SLAB instead of relying on page
based policy application (which IMHO was the intend of the memory policy
system before Paul Jackson got that changed in SLAB).

Anyways the implementation is rather simple.





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
