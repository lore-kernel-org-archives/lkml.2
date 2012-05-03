Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab2ECJCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 05:02:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:49879 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755120Ab2ECJCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 05:02:48 -0400
Message-Id: <20120503085033.898475542@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 03 May 2012 09:02:47 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>
Subject: [patch V2 01/31] frv: Use correct size for task_struct allocation
References: <20120503083859.991965503@linutronix.de>
Content-Disposition: inline;
 filename=frv-use-correct-size-for-task-struct-allocation.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alloc_task_struct_node() allocates THREAD_SIZE and maintains some
weird refcount in the allocated memory. This never blew up as
task_struct size on 32bit machines was always less than THREAD_SIZE

Allocate just sizeof(struct task_struct) and get rid of the magic
refcounting.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: David Howells <dhowells@redhat.com>

---
 arch/frv/kernel/process.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

Index: tip/arch/frv/kernel/process.c
===================================================================
--- tip.orig/arch/frv/kernel/process.c
+++ tip/arch/frv/kernel/process.c
@@ -45,17 +45,12 @@ EXPORT_SYMBOL(pm_power_off);
 
 struct task_struct *alloc_task_struct_node(int node)
 {
-	struct task_struct *p = kmalloc_node(THREAD_SIZE, GFP_KERNEL, node);
-
-	if (p)
-		atomic_set((atomic_t *)(p+1), 1);
-	return p;
+	return kmalloc_node(sizeof(task_struct), GFP_KERNEL, node);
 }
 
 void free_task_struct(struct task_struct *p)
 {
-	if (atomic_dec_and_test((atomic_t *)(p+1)))
-		kfree(p);
+	kfree(p);
 }
 
 static void core_sleep_idle(void)


