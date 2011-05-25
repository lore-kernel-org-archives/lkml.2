Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853Ab1EYGeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 02:34:20 -0400
Received: from mail4.comsite.net ([205.238.176.238]:43935 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab1EYGeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 02:34:19 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
Subject: [PATCH 2/4] irq: radix_tree_insert can fail
From: Milton Miller <miltonm@bga.com>
Message-Id: <radix-insert-can-fail@mdm.bga.com>
In-Reply-To: <generic-irq-changes@mdm.bga.com>
References: <generic-irq-changes@mdm.bga.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: <linux-kernel@vger.kernel.org>
Date: Wed, 25 May 2011 01:34:18 -0500
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check the insert, and if it fails cleanup and free all partial work.

Sparse irq was not checking the return code from radix_tree_insert,
but it may need to allocate memory and can fail.  If it failed,
it still claimed success to the caller but the affected irq(s) are
unavailable and the reference to the affected descriptors is leaked.

Signed-off-by: Milton Miller <miltonm@bga.com>
---
I started by tring to change free_desc to take the descriptor pointer
and pushing that down, but that soon ran into conflicts between the
array and sparse implementations, and/or the old dynamic irq cleanup
function that is still used by some architectures.  This version is
targeted, and also protects against scribbles to irq_data.irq.


Index: work.git/kernel/irq/irqdesc.c
===================================================================
--- work.git.orig/kernel/irq/irqdesc.c	2011-05-23 13:46:09.197635762 -0500
+++ work.git/kernel/irq/irqdesc.c	2011-05-23 14:29:22.960588100 -0500
@@ -164,10 +164,8 @@ err_desc:
 	return NULL;
 }
 
-static void free_desc(unsigned int irq)
+static void free_a_desc(unsigned int irq, struct irq_desc *desc)
 {
-	struct irq_desc *desc = irq_to_desc(irq);
-
 	unregister_irq_proc(irq, desc);
 
 	mutex_lock(&sparse_irq_lock);
@@ -179,21 +177,30 @@ static void free_desc(unsigned int irq)
 	kfree(desc);
 }
 
+static void free_desc(unsigned int irq)
+{
+	free_a_desc(irq, irq_to_desc(irq));
+}
+
 static int alloc_descs(unsigned int start, unsigned int cnt, int node)
 {
 	struct irq_desc *desc;
-	int i;
+	int i, res;
 
 	for (i = 0; i < cnt; i++) {
 		desc = alloc_desc(start + i, node);
 		if (!desc)
 			goto err;
 		mutex_lock(&sparse_irq_lock);
-		irq_insert_desc(start + i, desc);
+		res = irq_insert_desc(start + i, desc);
 		mutex_unlock(&sparse_irq_lock);
+		if (res)
+			goto err_insert;
 	}
 	return start;
 
+err_insert:
+	free_a_desc(start + i, desc);
 err:
 	for (i--; i >= 0; i--)
 		free_desc(start + i);
