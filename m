Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab0JNXSh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 19:18:37 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:9806 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506Ab0JNXSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 19:18:34 -0400
Subject: [PATCH v4 2/6] resources: support allocating space within a region
	from the top down
To: Jesse Barnes <jbarnes@virtuousgeek.org>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Bob Picco <bpicco@redhat.com>, Brian Bloniarz <phunge0@hotmail.com>,
        Charles Butterfield <charles.butterfield@nextcentury.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-pci@vger.kernel.org,
        "Horst H. von Brand" <vonbrand@inf.utfsm.cl>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Stefan Becker <chemobejk@gmail.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Yinghai Lu <yinghai@kernel.org>,
        Leann Ogasawara <leann.ogasawara@canonical.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 14 Oct 2010 17:18:32 -0600
Message-ID: <20101014231831.536.69326.stgit@bob.kio>
In-Reply-To: <20101014231804.536.62138.stgit@bob.kio>
References: <20101014231804.536.62138.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Allocate space from the top of a region first, then work downward,
if an architecture desires this.

When we allocate space from a resource, we look for gaps between children
of the resource.  Previously, we always looked at gaps from the bottom up.
For example, given this:

    [mem 0xbff00000-0xf7ffffff] PCI Bus 0000:00
      [mem 0xbff00000-0xbfffffff] gap -- available
      [mem 0xc0000000-0xdfffffff] PCI Bus 0000:02
      [mem 0xe0000000-0xf7ffffff] gap -- available

we attempted to allocate from the [mem 0xbff00000-0xbfffffff] gap first,
then the [mem 0xe0000000-0xf7ffffff] gap.

With this patch an architecture can choose to allocate from the top gap
[mem 0xe0000000-0xf7ffffff] first.

We can't do this across the board because iomem_resource.end is initialized
to 0xffffffff_ffffffff on 64-bit architectures, and most machines can't
address the entire 64-bit physical address space.  Therefore, we only
allocate top-down if the arch requests it by clearing
"resource_alloc_from_bottom".

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 Documentation/kernel-parameters.txt |    5 ++
 include/linux/ioport.h              |    1 
 kernel/resource.c                   |   89 +++++++++++++++++++++++++++++++++++
 3 files changed, 94 insertions(+), 1 deletions(-)


diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 8dd7248..fe50cbd 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2156,6 +2156,11 @@ and is between 256 and 4096 characters. It is defined in the file
 	reset_devices	[KNL] Force drivers to reset the underlying device
 			during initialization.
 
+	resource_alloc_from_bottom
+			Allocate new resources from the beginning of available
+			space, not the end.  If you need to use this, please
+			report a bug.
+
 	resume=		[SWSUSP]
 			Specify the partition device for software suspend
 
diff --git a/include/linux/ioport.h b/include/linux/ioport.h
index b227902..d377ea8 100644
--- a/include/linux/ioport.h
+++ b/include/linux/ioport.h
@@ -112,6 +112,7 @@ struct resource_list {
 /* PC/ISA/whatever - the normal PC address spaces: IO and memory */
 extern struct resource ioport_resource;
 extern struct resource iomem_resource;
+extern int resource_alloc_from_bottom;
 
 extern struct resource *request_resource_conflict(struct resource *root, struct resource *new);
 extern int request_resource(struct resource *root, struct resource *new);
diff --git a/kernel/resource.c b/kernel/resource.c
index ace2269..8d337a9 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -40,6 +40,23 @@ EXPORT_SYMBOL(iomem_resource);
 
 static DEFINE_RWLOCK(resource_lock);
 
+/*
+ * By default, we allocate free space bottom-up.  The architecture can request
+ * top-down by clearing this flag.  The user can override the architecture's
+ * choice with the "resource_alloc_from_bottom" kernel boot option, but that
+ * should only be a debugging tool.
+ */
+int resource_alloc_from_bottom = 1;
+
+static __init int setup_alloc_from_bottom(char *s)
+{
+	printk(KERN_INFO
+	       "resource: allocating from bottom-up; please report a bug\n");
+	resource_alloc_from_bottom = 1;
+	return 0;
+}
+early_param("resource_alloc_from_bottom", setup_alloc_from_bottom);
+
 static void *r_next(struct seq_file *m, void *v, loff_t *pos)
 {
 	struct resource *p = v;
@@ -358,7 +375,74 @@ int __weak page_is_ram(unsigned long pfn)
 }
 
 /*
+ * Find the resource before "child" in the sibling list of "root" children.
+ */
+static struct resource *find_sibling_prev(struct resource *root, struct resource *child)
+{
+	struct resource *this;
+
+	for (this = root->child; this; this = this->sibling)
+		if (this->sibling == child)
+			return this;
+
+	return NULL;
+}
+
+/*
+ * Find empty slot in the resource tree given range and alignment.
+ * This version allocates from the end of the root resource first.
+ */
+static int find_resource_from_top(struct resource *root, struct resource *new,
+				  resource_size_t size, resource_size_t min,
+				  resource_size_t max, resource_size_t align,
+				  resource_size_t (*alignf)(void *,
+						   const struct resource *,
+						   resource_size_t,
+						   resource_size_t),
+				  void *alignf_data)
+{
+	struct resource *this;
+	struct resource tmp = *new;
+	resource_size_t start;
+
+	tmp.start = root->end;
+	tmp.end = root->end;
+
+	this = find_sibling_prev(root, NULL);
+	for (;;) {
+		if (this) {
+			if (this->end < root->end)
+				tmp.start = this->end + 1;
+		} else
+			tmp.start = root->start;
+		if (tmp.start < min)
+			tmp.start = min;
+		if (tmp.end > max)
+			tmp.end = max;
+		tmp.start = ALIGN(tmp.start, align);
+		if (alignf) {
+			start = alignf(alignf_data, &tmp, size, align);
+			if (tmp.start <= start && start <= tmp.end)
+				tmp.start = start;
+			else
+				tmp.start = tmp.end;
+		}
+		if (tmp.start < tmp.end && tmp.end - tmp.start >= size - 1) {
+			new->start = tmp.start;
+			new->end = tmp.start + size - 1;
+			return 0;
+		}
+		if (!this || this->start == root->start)
+			break;
+		tmp.end = this->start - 1;
+		this = find_sibling_prev(root, this);
+	}
+	return -EBUSY;
+}
+
+/*
  * Find empty slot in the resource tree given range and alignment.
+ * This version allocates from the beginning of the root resource first.
  */
 static int find_resource(struct resource *root, struct resource *new,
 			 resource_size_t size, resource_size_t min,
@@ -435,7 +519,10 @@ int allocate_resource(struct resource *root, struct resource *new,
 	int err;
 
 	write_lock(&resource_lock);
-	err = find_resource(root, new, size, min, max, align, alignf, alignf_data);
+	if (resource_alloc_from_bottom)
+		err = find_resource(root, new, size, min, max, align, alignf, alignf_data);
+	else
+		err = find_resource_from_top(root, new, size, min, max, align, alignf, alignf_data);
 	if (err >= 0 && __request_resource(root, new))
 		err = -EBUSY;
 	write_unlock(&resource_lock);

