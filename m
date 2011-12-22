Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab1LVDd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 22:33:26 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62464 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956Ab1LVDdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 22:33:24 -0500
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>, Minchan Kim <minchan@kernel.org>
Subject: [PATCH] Change void* into explict vm_struct*
Date: Thu, 22 Dec 2011 12:33:13 +0900
Message-Id: <1324524793-14049-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.6.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, vmap_area->private is void* but we don't use the field
for various purpose but use only for vm_struct.
So change it with vm_struct* with naming and it's more good
for readability and type checking.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/vmalloc.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index e1fa5a6..6e3945d 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -256,7 +256,7 @@ struct vmap_area {
 	struct rb_node rb_node;		/* address sorted rbtree */
 	struct list_head list;		/* address sorted list */
 	struct list_head purge_list;	/* "lazy purge" list */
-	void *private;
+	struct vm_struct *vm;
 	struct rcu_head rcu_head;
 };
 
@@ -1265,7 +1265,7 @@ static void setup_vmalloc_vm(struct vm_struct *vm, struct vmap_area *va,
 	vm->addr = (void *)va->va_start;
 	vm->size = va->va_end - va->va_start;
 	vm->caller = caller;
-	va->private = vm;
+	va->vm = vm;
 	va->flags |= VM_VM_AREA;
 }
 
@@ -1388,7 +1388,7 @@ static struct vm_struct *find_vm_area(const void *addr)
 
 	va = find_vmap_area((unsigned long)addr);
 	if (va && va->flags & VM_VM_AREA)
-		return va->private;
+		return va->vm;
 
 	return NULL;
 }
@@ -1407,7 +1407,7 @@ struct vm_struct *remove_vm_area(const void *addr)
 
 	va = find_vmap_area((unsigned long)addr);
 	if (va && va->flags & VM_VM_AREA) {
-		struct vm_struct *vm = va->private;
+		struct vm_struct *vm = va->vm;
 
 		if (!(vm->flags & VM_UNLIST)) {
 			struct vm_struct *tmp, **p;
-- 
1.7.6.4

