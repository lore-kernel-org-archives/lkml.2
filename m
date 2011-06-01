Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351Ab1FAR1Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 13:27:24 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:38323 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759326Ab1FAR0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 13:26:21 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 2z9MJ3IVM1kxbxlBrvZR0FiDbWbPXKWHI_qI4W1bGKv.7.R
 ge148CasQsIU5_6820k4YmoqkXynm_RAp0bqCat5o6rpyB1mS4J1usyeJzU1
 9eOtuFwm_5jsUGLhKnKgiKuOmT_K28UgN2087o.vkzqzKphMlhNKUE1b96zt
 S7rVXTQIjzsPGfF6pJh8Uv8xs_2qKtPnr2RGoWW44S4kDi5.W5kcpfB01DEb
 7dOhRNfyn92wRnndQH_2fzXkaZIwHE6dicotQKvPLEGy5Kmfc2MuK4ExR63u
 t676r0TuY3iMFAW0eo9_Aj93547oBIOtpCAbz90Ba_hlQjVg2wzUqPJBnxlC
 XVncHutwp3Lv9tmbWYQIb6DkR
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110601172619.817315669@linux.com>
User-Agent: quilt/0.48-1
Date: Wed, 01 Jun 2011 12:25:57 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [slubllv7 14/17] slub: Add statistics for the case that the current slab does not match the node
References: <20110601172543.437240675@linux.com>
Content-Disposition: inline; filename=node_mismatch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Slub reloads the per cpu slab if the page does not satisfy the NUMA condition. Track
those reloads since doing so has a performance impact.

Signed-off-by: Christoph Lameter <cl@linux.com>


---
 include/linux/slub_def.h |    1 +
 mm/slub.c                |    3 +++
 2 files changed, 4 insertions(+)

Index: linux-2.6/include/linux/slub_def.h
===================================================================
--- linux-2.6.orig/include/linux/slub_def.h	2011-05-31 14:27:07.332880140 -0500
+++ linux-2.6/include/linux/slub_def.h	2011-05-31 14:27:17.792880073 -0500
@@ -24,6 +24,7 @@ enum stat_item {
 	ALLOC_FROM_PARTIAL,	/* Cpu slab acquired from partial list */
 	ALLOC_SLAB,		/* Cpu slab acquired from page allocator */
 	ALLOC_REFILL,		/* Refill cpu slab from slab freelist */
+	ALLOC_NODE_MISMATCH,	/* Switching cpu slab */
 	FREE_SLAB,		/* Slab freed to the page allocator */
 	CPUSLAB_FLUSH,		/* Abandoning of the cpu slab */
 	DEACTIVATE_FULL,	/* Cpu slab was full when deactivated */
Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2011-05-31 14:27:12.002880106 -0500
+++ linux-2.6/mm/slub.c	2011-05-31 14:27:17.792880073 -0500
@@ -1966,6 +1966,7 @@ static void *__slab_alloc(struct kmem_ca
 		goto new_slab;
 
 	if (unlikely(!node_match(c, node))) {
+		stat(s, ALLOC_NODE_MISMATCH);
 		deactivate_slab(s, c);
 		goto new_slab;
 	}
@@ -4675,6 +4676,7 @@ STAT_ATTR(FREE_REMOVE_PARTIAL, free_remo
 STAT_ATTR(ALLOC_FROM_PARTIAL, alloc_from_partial);
 STAT_ATTR(ALLOC_SLAB, alloc_slab);
 STAT_ATTR(ALLOC_REFILL, alloc_refill);
+STAT_ATTR(ALLOC_NODE_MISMATCH, alloc_node_mismatch);
 STAT_ATTR(FREE_SLAB, free_slab);
 STAT_ATTR(CPUSLAB_FLUSH, cpuslab_flush);
 STAT_ATTR(DEACTIVATE_FULL, deactivate_full);
@@ -4734,6 +4736,7 @@ static struct attribute *slab_attrs[] =
 	&alloc_from_partial_attr.attr,
 	&alloc_slab_attr.attr,
 	&alloc_refill_attr.attr,
+	&alloc_node_mismatch_attr.attr,
 	&free_slab_attr.attr,
 	&cpuslab_flush_attr.attr,
 	&deactivate_full_attr.attr,

