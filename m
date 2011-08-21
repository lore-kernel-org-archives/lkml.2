Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315Ab1HUIQp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 04:16:45 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:54469 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110Ab1HUIQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 04:16:40 -0400
X-AuditID: b753bd60-a3c7dba0000050a4-9c-4e50bee42296
X-AuditID: b753bd60-a3c7dba0000050a4-9c-4e50bee42296
From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Subject: [PATCH -v3] avoid null pointer access in vm_struct
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        yrl.pp-manager.tt@hitachi.com,
        Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Namhyung Kim <namhyung@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Date: Sun, 21 Aug 2011 17:21:32 +0900
Message-ID: <20110821082132.28358.72280.stgit@ltc219.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The /proc/vmallocinfo shows information about vmalloc allocations in vmlist
that is a linklist of vm_struct. It, however, may access pages field of
vm_struct where a page was not allocated. This results in a null pointer
access and leads to a kernel panic.

Why this happen:
In __vmalloc_node_range() called from vmalloc(), newly allocated vm_struct
is added to vmlist at __get_vm_area_node() and then, some fields of
vm_struct such as nr_pages and pages are set at __vmalloc_area_node(). In
other words, it is added to vmlist before it is fully initialized. At the
same time, when the /proc/vmallocinfo is read, it accesses the pages field
of vm_struct according to the nr_pages field at show_numa_info(). Thus, a
null pointer access happens.

Patch:
This patch adds newly allocated vm_struct to the vmlist *after* it is fully
initialized. So, it can avoid accessing the pages field with unallocated
page when show_numa_info() is called.

Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---

 include/linux/vmalloc.h |    1 +
 mm/vmalloc.c            |   65 +++++++++++++++++++++++++++++++++++------------
 2 files changed, 49 insertions(+), 17 deletions(-)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 9332e52..687fb11 100644
--- a/include/linux/vmalloc.h
+++ b/include/linux/vmalloc.h
@@ -13,6 +13,7 @@ struct vm_area_struct;		/* vma defining user mapping in mm_types.h */
 #define VM_MAP		0x00000004	/* vmap()ed pages */
 #define VM_USERMAP	0x00000008	/* suitable for remap_vmalloc_range */
 #define VM_VPAGES	0x00000010	/* buffer for pages was vmalloc'ed */
+#define VM_UNLIST	0x00000020	/* vm_struct is not listed in vmlist */
 /* bits [20..32] reserved for arch specific ioremap internals */
 
 /*
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 7ef0903..0aca3ce 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1253,18 +1253,22 @@ EXPORT_SYMBOL_GPL(map_vm_area);
 DEFINE_RWLOCK(vmlist_lock);
 struct vm_struct *vmlist;
 
-static void insert_vmalloc_vm(struct vm_struct *vm, struct vmap_area *va,
+static void setup_vmalloc_vm(struct vm_struct *vm, struct vmap_area *va,
 			      unsigned long flags, void *caller)
 {
-	struct vm_struct *tmp, **p;
-
 	vm->flags = flags;
 	vm->addr = (void *)va->va_start;
 	vm->size = va->va_end - va->va_start;
 	vm->caller = caller;
 	va->private = vm;
 	va->flags |= VM_VM_AREA;
+}
+
+static void insert_vmalloc_vmlist(struct vm_struct *vm)
+{
+	struct vm_struct *tmp, **p;
 
+	vm->flags &= ~VM_UNLIST;
 	write_lock(&vmlist_lock);
 	for (p = &vmlist; (tmp = *p) != NULL; p = &tmp->next) {
 		if (tmp->addr >= vm->addr)
@@ -1275,6 +1279,13 @@ static void insert_vmalloc_vm(struct vm_struct *vm, struct vmap_area *va,
 	write_unlock(&vmlist_lock);
 }
 
+static void insert_vmalloc_vm(struct vm_struct *vm, struct vmap_area *va,
+			      unsigned long flags, void *caller)
+{
+	setup_vmalloc_vm(vm, va, flags, caller);
+	insert_vmalloc_vmlist(vm);
+}
+
 static struct vm_struct *__get_vm_area_node(unsigned long size,
 		unsigned long align, unsigned long flags, unsigned long start,
 		unsigned long end, int node, gfp_t gfp_mask, void *caller)
@@ -1313,7 +1324,18 @@ static struct vm_struct *__get_vm_area_node(unsigned long size,
 		return NULL;
 	}
 
-	insert_vmalloc_vm(area, va, flags, caller);
+	/*
+	 * When this function is called from __vmalloc_node_range,
+	 * we do not add vm_struct to vmlist here to avoid
+	 * accessing uninitialized members of vm_struct such as
+	 * pages and nr_pages fields. They will be set later.
+	 * To distinguish it from others, we use a VM_UNLIST flag.
+	 */
+	if (flags & VM_UNLIST)
+		setup_vmalloc_vm(area, va, flags, caller);
+	else
+		insert_vmalloc_vm(area, va, flags, caller);
+
 	return area;
 }
 
@@ -1381,17 +1403,20 @@ struct vm_struct *remove_vm_area(const void *addr)
 	va = find_vmap_area((unsigned long)addr);
 	if (va && va->flags & VM_VM_AREA) {
 		struct vm_struct *vm = va->private;
-		struct vm_struct *tmp, **p;
-		/*
-		 * remove from list and disallow access to this vm_struct
-		 * before unmap. (address range confliction is maintained by
-		 * vmap.)
-		 */
-		write_lock(&vmlist_lock);
-		for (p = &vmlist; (tmp = *p) != vm; p = &tmp->next)
-			;
-		*p = tmp->next;
-		write_unlock(&vmlist_lock);
+
+		if (!(vm->flags & VM_UNLIST)) {
+			struct vm_struct *tmp, **p;
+			/*
+			 * remove from list and disallow access to
+			 * this vm_struct before unmap. (address range
+			 * confliction is maintained by vmap.)
+			 */
+			write_lock(&vmlist_lock);
+			for (p = &vmlist; (tmp = *p) != vm; p = &tmp->next)
+				;
+			*p = tmp->next;
+			write_unlock(&vmlist_lock);
+		}
 
 		vmap_debug_free_range(va->va_start, va->va_end);
 		free_unmap_vmap_area(va);
@@ -1602,8 +1627,8 @@ void *__vmalloc_node_range(unsigned long size, unsigned long align,
 	if (!size || (size >> PAGE_SHIFT) > totalram_pages)
 		return NULL;
 
-	area = __get_vm_area_node(size, align, VM_ALLOC, start, end, node,
-				  gfp_mask, caller);
+	area = __get_vm_area_node(size, align, VM_ALLOC | VM_UNLIST,
+				  start, end, node, gfp_mask, caller);
 
 	if (!area)
 		return NULL;
@@ -1611,6 +1636,12 @@ void *__vmalloc_node_range(unsigned long size, unsigned long align,
 	addr = __vmalloc_area_node(area, gfp_mask, prot, node, caller);
 
 	/*
+	 * In this function, newly allocated vm_struct is not added
+	 * to vmlist at __get_vm_area_node(). so, it is added here.
+	 */
+	insert_vmalloc_vmlist(area);
+
+	/*
 	 * A ref_count = 3 is needed because the vm_struct and vmap_area
 	 * structures allocated in the __get_vm_area_node() function contain
 	 * references to the virtual address of the vmalloc'ed block.

