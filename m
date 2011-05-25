Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab1EYGej (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 02:34:39 -0400
Received: from mail4.comsite.net ([205.238.176.238]:9433 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240Ab1EYGeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 02:34:36 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
Subject: [PATCH 1/4] sparse irq: protect irq_to_desc against irq_free_descs
From: Milton Miller <miltonm@bga.com>
Message-Id: <rcu-lock-radix-lookup-sparse-irq@mdm.bga.com>
In-Reply-To: <generic-irq-changes@mdm.bga.com>
References: <generic-irq-changes@mdm.bga.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Wed, 25 May 2011 01:34:18 -0500
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The radix-tree code uses call_rcu to delay freeing internal data
elements when removing when deleting an entry.  We must protect
against the elements being freed while we traverse the tree.

While preparing a patch to expand the contexts in which the radix
tree optionally used by powerpc for mapping hardware irq numbers to
linux numbers would be called, I realized that the radix tree was
not locked when radix_tree_lookup was called.  I then realized the
same issue applies to the generic irq code when sparse irqs are in use.

While the powerpc radix tree was only referenced from one callsite
that was irqs_disabled and irq_enter, irq_to_desc is called from
many more contexts including threaded irq handlers and other
process contexts.

This does not show up in the rcu lockdep because in 2.6.34 commit
2676a58c98 (radix-tree: Disable RCU lockdep checking in radix tree)
deemed it too hard to pass the condition of the protecting lock
to the library.

Signed-off-by: Milton Miller <miltonm@bga.com>
Cc: <stable@kernel.org>
---
I expect the relatively infrequent calls to irq_free_descs, combined
with most calls to irq_to_desc being irqs_disabled and the fact
merged to mainline implemntations of call_rcu requiring a cpu to
respond to a hard irq or schedule has hidden this error to date.

Index: work.git/kernel/irq/irqdesc.c
===================================================================
--- work.git.orig/kernel/irq/irqdesc.c	2011-05-23 13:34:08.728585785 -0500
+++ work.git/kernel/irq/irqdesc.c	2011-05-23 13:46:09.197635762 -0500
@@ -108,7 +108,13 @@ static void irq_insert_desc(unsigned int
 
 struct irq_desc *irq_to_desc(unsigned int irq)
 {
-	return radix_tree_lookup(&irq_desc_tree, irq);
+	struct irq_desc *desc;
+
+	rcu_read_lock();
+	desc = radix_tree_lookup(&irq_desc_tree, irq);
+	rcu_read_unlock();
+
+	return desc
 }
 
 static void delete_irq_desc(unsigned int irq)
