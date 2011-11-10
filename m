Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965043Ab1KJEcI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:32:08 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:45714 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934151Ab1KJEb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 23:31:57 -0500
X-AuditID: b753bd60-a28adba0000019f4-d4-4ebb53bac8ce
X-AuditID: b753bd60-a28adba0000019f4-d4-4ebb53bac8ce
From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Subject: [PATCH] [2.6.32-stable] mm: avoid null pointer access in vm_struct
 via /proc/vmallocinfo
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Namhyung Kim <namhyung@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Date: Thu, 10 Nov 2011 13:37:16 +0900
Message-ID: <20111110043716.11274.32615.stgit@ltc219.sdl.hitachi.co.jp>
In-Reply-To: <20111107182439.GA5806@kroah.com>
References: <20111107182439.GA5806@kroah.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is the backport version of the patch which solves a null
pointer access in vm_struct via /proc/vmallocinfo.

The /proc/vmallocinfo shows information about vmalloc allocations in vmlist
that is a linklist of vm_struct. It, however, may access pages field of
vm_struct where a page was not allocated. This results in a null pointer
access and leads to a kernel panic.

Why this happen:
In __vmalloc_node() called from vmalloc(), newly allocated vm_struct
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
 mm/vmalloc.c            |   67 +++++++++++++++++++++++++++++++++++------------
 2 files changed, 51 insertions(+), 17 deletions(-)

diff --git a/include/linux/vmalloc.h b/include/linux/vmalloc.h
index 3c123c3..819a634 100644
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
index 7221e9e..f34ffd0 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1203,17 +1203,22 @@ EXPORT_SYMBOL_GPL(map_vm_area);
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
+
+	vm->flags &= ~VM_UNLIST;
 
 	write_lock(&vmlist_lock);
 	for (p = &vmlist; (tmp = *p) != NULL; p = &tmp->next) {
@@ -1225,6 +1230,13 @@ static void insert_vmalloc_vm(struct vm_struct *vm, struct vmap_area *va,
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
@@ -1263,7 +1275,18 @@ static struct vm_struct *__get_vm_area_node(unsigned long size,
 		return NULL;
 	}
 
-	insert_vmalloc_vm(area, va, flags, caller);
+	/*
+	 * When this function is called from __vmalloc_node,
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
 
@@ -1338,17 +1361,20 @@ struct vm_struct *remove_vm_area(const void *addr)
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
@@ -1568,8 +1594,9 @@ static void *__vmalloc_node(unsigned long size, unsigned long align,
 	if (!size || (size >> PAGE_SHIFT) > totalram_pages)
 		return NULL;
 
-	area = __get_vm_area_node(size, align, VM_ALLOC, VMALLOC_START,
-				  VMALLOC_END, node, gfp_mask, caller);
+	area = __get_vm_area_node(size, align, VM_ALLOC | VM_UNLIST,
+				  VMALLOC_START, VMALLOC_END, node,
+				  gfp_mask, caller);
 
 	if (!area)
 		return NULL;
@@ -1577,6 +1604,12 @@ static void *__vmalloc_node(unsigned long size, unsigned long align,
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

