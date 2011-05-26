Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321Ab1EZSQG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:16:06 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:32895 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933189Ab1EZSPL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:15:11 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: XFF1O2MVM1nb5XHtTLscMzppD1wjPzcl7W.1QhVe5ajIULC
 TC3b0WwWeZZkyWCkuMQ2D5XvtJUQ2A87PH.6JCr9gXBNVUc.lc53e7LxDBFy
 awB2EUyaIUXwUmBwu9NnnD4rpzUxKceG2VZxTjppb7Znacvqb61cXTiV.H00
 8mBKO6ixrdaLKXFBm7vUCnK7HFE7RMASV3_LA8.ghPId8.PcC_G4YFv6Q3Uc
 mBd56rT7bgnfzRShWLW3_90OXyOgI78808hVCvCpUgJ5xcaEJZNUModiKxS_
 7tfvJreC6ENZPlpbHQpYvWWE1z_xSsj4M_p3uN07rdFhquK15my3.Mb3VST8
 DVuwhuI0qrpVo6OwZtLRbZxJr
X-Yahoo-Newman-Property: ymail-3
Message-Id: <20110526181509.448259381@linux.com>
User-Agent: quilt/0.48-1
Date: Thu, 26 May 2011 13:14:56 -0500
From: Christoph Lameter <cl@linux.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: David Rientjes <rientjes@google.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Subject: [slubllv6 14/17] slub: Add statistics for the case that the current slab does not match the node
References: <20110526181442.789868308@linux.com>
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
--- linux-2.6.orig/include/linux/slub_def.h	2011-05-24 09:40:43.764875120 -0500
+++ linux-2.6/include/linux/slub_def.h	2011-05-24 09:41:07.574874967 -0500
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
--- linux-2.6.orig/mm/slub.c	2011-05-24 09:41:03.744874994 -0500
+++ linux-2.6/mm/slub.c	2011-05-24 09:41:07.574874967 -0500
@@ -1952,6 +1952,7 @@ static void *__slab_alloc(struct kmem_ca
 		goto new_slab;
 
 	if (unlikely(!node_match(c, node))) {
+		stat(s, ALLOC_NODE_MISMATCH);
 		deactivate_slab(s, c);
 		goto new_slab;
 	}
@@ -4651,6 +4652,7 @@ STAT_ATTR(FREE_REMOVE_PARTIAL, free_remo
 STAT_ATTR(ALLOC_FROM_PARTIAL, alloc_from_partial);
 STAT_ATTR(ALLOC_SLAB, alloc_slab);
 STAT_ATTR(ALLOC_REFILL, alloc_refill);
+STAT_ATTR(ALLOC_NODE_MISMATCH, alloc_node_mismatch);
 STAT_ATTR(FREE_SLAB, free_slab);
 STAT_ATTR(CPUSLAB_FLUSH, cpuslab_flush);
 STAT_ATTR(DEACTIVATE_FULL, deactivate_full);
@@ -4710,6 +4712,7 @@ static struct attribute *slab_attrs[] =
 	&alloc_from_partial_attr.attr,
 	&alloc_slab_attr.attr,
 	&alloc_refill_attr.attr,
+	&alloc_node_mismatch_attr.attr,
 	&free_slab_attr.attr,
 	&cpuslab_flush_attr.attr,
 	&deactivate_full_attr.attr,

