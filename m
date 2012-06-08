Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933453Ab2FHF1r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:27:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43189 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760570Ab2FHFHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:15 -0400
Message-Id: <20120608041845.013957176@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:19:11 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Minchan Kim <minchan@kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: [ 31/82] mm/vmalloc.c: change void* into explict vm_struct*
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Minchan Kim <minchan@kernel.org>

commit db1aecafef58b5dda39c4228debe2c845e4a27ab upstream.

vmap_area->private is void* but we don't use the field for various purpose
but use only for vm_struct.  So change it to a vm_struct* with naming to
improve for readability and type checking.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 mm/vmalloc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 21fdf46..877ca04 100644
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
 
@@ -1285,7 +1285,7 @@ static void setup_vmalloc_vm(struct vm_struct *vm, struct vmap_area *va,
 	vm->addr = (void *)va->va_start;
 	vm->size = va->va_end - va->va_start;
 	vm->caller = caller;
-	va->private = vm;
+	va->vm = vm;
 	va->flags |= VM_VM_AREA;
 }
 
@@ -1408,7 +1408,7 @@ static struct vm_struct *find_vm_area(const void *addr)
 
 	va = find_vmap_area((unsigned long)addr);
 	if (va && va->flags & VM_VM_AREA)
-		return va->private;
+		return va->vm;
 
 	return NULL;
 }
@@ -1427,7 +1427,7 @@ struct vm_struct *remove_vm_area(const void *addr)
 
 	va = find_vmap_area((unsigned long)addr);
 	if (va && va->flags & VM_VM_AREA) {
-		struct vm_struct *vm = va->private;
+		struct vm_struct *vm = va->vm;
 
 		if (!(vm->flags & VM_UNLIST)) {
 			struct vm_struct *tmp, **p;


