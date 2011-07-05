Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab1GEOvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 10:51:33 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50571 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753034Ab1GEOvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 10:51:31 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 34/49] gma500: the GEM and GTT code is device independant
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Tue, 05 Jul 2011 15:41:43 +0100
Message-ID: <20110705144140.23872.86541.stgit@localhost.localdomain>
In-Reply-To: <20110705141038.23872.55303.stgit@localhost.localdomain>
References: <20110705141038.23872.55303.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Rename the gem and gtt files accordingly.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/gma500/Makefile  |    6 
 drivers/staging/gma500/gem.c     |  252 ++++++++++++++++++++
 drivers/staging/gma500/gtt.c     |  487 ++++++++++++++++++++++++++++++++++++++
 drivers/staging/gma500/gtt.h     |   62 +++++
 drivers/staging/gma500/psb_drv.h |    2 
 drivers/staging/gma500/psb_gem.c |  252 --------------------
 drivers/staging/gma500/psb_gtt.c |  487 --------------------------------------
 drivers/staging/gma500/psb_gtt.h |   62 -----
 8 files changed, 805 insertions(+), 805 deletions(-)
 create mode 100644 drivers/staging/gma500/gem.c
 create mode 100644 drivers/staging/gma500/gtt.c
 create mode 100644 drivers/staging/gma500/gtt.h
 delete mode 100644 drivers/staging/gma500/psb_gem.c
 delete mode 100644 drivers/staging/gma500/psb_gtt.c
 delete mode 100644 drivers/staging/gma500/psb_gtt.h

diff --git a/drivers/staging/gma500/Makefile b/drivers/staging/gma500/Makefile
index d2c0887..0603949 100644
--- a/drivers/staging/gma500/Makefile
+++ b/drivers/staging/gma500/Makefile
@@ -6,11 +6,11 @@ ccflags-y += -Iinclude/drm
 psb_gfx-y += gem_glue.o \
 	  accel_2d.o \
 	  backlight.o \
-	  power.o \
 	  framebuffer.o \
+	  gem.o \
+	  gtt.o \
+	  power.o \
 	  psb_drv.o \
-	  psb_gem.o \
-	  psb_gtt.o \
 	  psb_intel_bios.o \
 	  psb_intel_opregion.o \
 	  psb_intel_display.o \
diff --git a/drivers/staging/gma500/gem.c b/drivers/staging/gma500/gem.c
new file mode 100644
index 0000000..a63ad9e
--- /dev/null
+++ b/drivers/staging/gma500/gem.c
@@ -0,0 +1,252 @@
+/*
+ *  psb GEM interface
+ *
+ * Copyright (c) 2011, Intel Corporation.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * Authors: Alan Cox
+ *
+ * TODO:
+ *	-	we need to work out if the MMU is relevant (eg for
+ *		accelerated operations on a GEM object)
+ */
+
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include "psb_drm.h"
+#include "psb_drv.h"
+
+int psb_gem_init_object(struct drm_gem_object *obj)
+{
+	return -EINVAL;
+}
+
+void psb_gem_free_object(struct drm_gem_object *obj)
+{
+	struct gtt_range *gtt = container_of(obj, struct gtt_range, gem);
+	drm_gem_object_release_wrap(obj);
+	/* This must occur last as it frees up the memory of the GEM object */
+	psb_gtt_free_range(obj->dev, gtt);
+}
+
+int psb_gem_get_aperture(struct drm_device *dev, void *data,
+				struct drm_file *file)
+{
+	return -EINVAL;
+}
+
+/**
+ *	psb_gem_dumb_map_gtt	-	buffer mapping for dumb interface
+ *	@file: our drm client file
+ *	@dev: drm device
+ *	@handle: GEM handle to the object (from dumb_create)
+ *
+ *	Do the necessary setup to allow the mapping of the frame buffer
+ *	into user memory. We don't have to do much here at the moment.
+ */
+int psb_gem_dumb_map_gtt(struct drm_file *file, struct drm_device *dev,
+			 uint32_t handle, uint64_t *offset)
+{
+	int ret = 0;
+	struct drm_gem_object *obj;
+
+	if (!(dev->driver->driver_features & DRIVER_GEM))
+		return -ENODEV;
+
+	mutex_lock(&dev->struct_mutex);
+
+	/* GEM does all our handle to object mapping */
+	obj = drm_gem_object_lookup(dev, file, handle);
+	if (obj == NULL) {
+		ret = -ENOENT;
+		goto unlock;
+	}
+	/* What validation is needed here ? */
+
+	/* Make it mmapable */
+	if (!obj->map_list.map) {
+		ret = gem_create_mmap_offset(obj);
+		if (ret)
+			goto out;
+	}
+	/* GEM should really work out the hash offsets for us */
+	*offset = (u64)obj->map_list.hash.key << PAGE_SHIFT;
+out:
+	drm_gem_object_unreference(obj);
+unlock:
+	mutex_unlock(&dev->struct_mutex);
+	return ret;
+}
+
+/**
+ *	psb_gem_create		-	create a mappable object
+ *	@file: the DRM file of the client
+ *	@dev: our device
+ *	@size: the size requested
+ *	@handlep: returned handle (opaque number)
+ *
+ *	Create a GEM object, fill in the boilerplate and attach a handle to
+ *	it so that userspace can speak about it. This does the core work
+ *	for the various methods that do/will create GEM objects for things
+ */
+static int psb_gem_create(struct drm_file *file,
+	struct drm_device *dev, uint64_t size, uint32_t *handlep)
+{
+	struct gtt_range *r;
+	int ret;
+	u32 handle;
+
+	size = roundup(size, PAGE_SIZE);
+
+	/* Allocate our object - for now a direct gtt range which is not
+	   stolen memory backed */
+	r = psb_gtt_alloc_range(dev, size, "gem", 0);
+	if (r == NULL) {
+		dev_err(dev->dev, "no memory for %lld byte GEM object\n", size);
+		return -ENOSPC;
+	}
+	/* Initialize the extra goodies GEM needs to do all the hard work */
+	if (drm_gem_object_init(dev, &r->gem, size) != 0) {
+		psb_gtt_free_range(dev, r);
+		/* GEM doesn't give an error code and we don't have an
+		   EGEMSUCKS so make something up for now - FIXME */
+		dev_err(dev->dev, "GEM init failed for %lld\n", size);
+		return -ENOMEM;
+	}
+	/* Give the object a handle so we can carry it more easily */
+	ret = drm_gem_handle_create(file, &r->gem, &handle);
+	if (ret) {
+		dev_err(dev->dev, "GEM handle failed for %p, %lld\n",
+							&r->gem, size);
+		drm_gem_object_release(&r->gem);
+		psb_gtt_free_range(dev, r);
+		return ret;
+	}
+	/* We have the initial and handle reference but need only one now */
+	drm_gem_object_unreference(&r->gem);
+	*handlep = handle;
+	return 0;
+}
+
+/**
+ *	psb_gem_dumb_create	-	create a dumb buffer
+ *	@drm_file: our client file
+ *	@dev: our device
+ *	@args: the requested arguments copied from userspace
+ *
+ *	Allocate a buffer suitable for use for a frame buffer of the
+ *	form described by user space. Give userspace a handle by which
+ *	to reference it.
+ */
+int psb_gem_dumb_create(struct drm_file *file, struct drm_device *dev,
+			struct drm_mode_create_dumb *args)
+{
+	args->pitch = ALIGN(args->width * ((args->bpp + 7) / 8), 64);
+	args->size = args->pitch * args->height;
+	return psb_gem_create(file, dev, args->size, &args->handle);
+}
+
+/**
+ *	psb_gem_dumb_destroy	-	destroy a dumb buffer
+ *	@file: client file
+ *	@dev: our DRM device
+ *	@handle: the object handle
+ *
+ *	Destroy a handle that was created via psb_gem_dumb_create, at least
+ *	we hope it was created that way. i915 seems to assume the caller
+ *	does the checking but that might be worth review ! FIXME
+ */
+int psb_gem_dumb_destroy(struct drm_file *file, struct drm_device *dev,
+			uint32_t handle)
+{
+	/* No special work needed, drop the reference and see what falls out */
+	return drm_gem_handle_delete(file, handle);
+}
+
+/**
+ *	psb_gem_fault		-	pagefault handler for GEM objects
+ *	@vma: the VMA of the GEM object
+ *	@vmf: fault detail
+ *
+ *	Invoked when a fault occurs on an mmap of a GEM managed area. GEM
+ *	does most of the work for us including the actual map/unmap calls
+ *	but we need to do the actual page work.
+ *
+ *	This code eventually needs to handle faulting objects in and out
+ *	of the GTT and repacking it when we run out of space. We can put
+ *	that off for now and for our simple uses
+ *
+ *	The VMA was set up by GEM. In doing so it also ensured that the
+ *	vma->vm_private_data points to the GEM object that is backing this
+ *	mapping.
+ *
+ *	FIXME
+ */
+int psb_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
+{
+	struct drm_gem_object *obj;
+	struct gtt_range *r;
+	int ret;
+	unsigned long pfn;
+	pgoff_t page_offset;
+	struct drm_device *dev;
+	struct drm_psb_private *dev_priv;
+
+	obj = vma->vm_private_data;	/* GEM object */
+	dev = obj->dev;
+	dev_priv = dev->dev_private;
+
+	r = container_of(obj, struct gtt_range, gem);	/* Get the gtt range */
+
+	/* Make sure we don't parallel update on a fault, nor move or remove
+	   something from beneath our feet */
+	mutex_lock(&dev->struct_mutex);
+
+	/* For now the mmap pins the object and it stays pinned. As things
+	   stand that will do us no harm */
+	if (r->mmapping == 0) {
+		ret = psb_gtt_pin(r);
+		if (ret < 0) {
+			dev_err(dev->dev, "gma500: pin failed: %d\n", ret);
+			goto fail;
+		}
+		r->mmapping = 1;
+	}
+
+	/* Page relative to the VMA start - we must calculate this ourselves
+	   because vmf->pgoff is the fake GEM offset */
+	page_offset = ((unsigned long) vmf->virtual_address - vma->vm_start)
+				>> PAGE_SHIFT;
+
+	/* CPU view of the page, don't go via the GART for CPU writes */
+	if (r->stolen)
+		pfn = (dev_priv->stolen_base + r->offset) >> PAGE_SHIFT;
+	else
+		pfn = page_to_pfn(r->pages[page_offset]);
+	ret = vm_insert_pfn(vma, (unsigned long)vmf->virtual_address, pfn);
+
+fail:
+	mutex_unlock(&dev->struct_mutex);
+	switch (ret) {
+	case 0:
+	case -ERESTARTSYS:
+	case -EINTR:
+		return VM_FAULT_NOPAGE;
+	case -ENOMEM:
+		return VM_FAULT_OOM;
+	default:
+		return VM_FAULT_SIGBUS;
+	}
+}
diff --git a/drivers/staging/gma500/gtt.c b/drivers/staging/gma500/gtt.c
new file mode 100644
index 0000000..6cfa59b
--- /dev/null
+++ b/drivers/staging/gma500/gtt.c
@@ -0,0 +1,487 @@
+/*
+ * Copyright (c) 2007, Intel Corporation.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ * Authors: Thomas Hellstrom <thomas-at-tungstengraphics.com>
+ *	    Alan Cox <alan@linux.intel.com>
+ */
+
+#include <drm/drmP.h>
+#include "psb_drv.h"
+
+
+/*
+ *	GTT resource allocator - manage page mappings in GTT space
+ */
+
+/**
+ *	psb_gtt_mask_pte	-	generate GTT pte entry
+ *	@pfn: page number to encode
+ *	@type: type of memory in the GTT
+ *
+ *	Set the GTT entry for the appropriate memory type.
+ */
+static inline uint32_t psb_gtt_mask_pte(uint32_t pfn, int type)
+{
+	uint32_t mask = PSB_PTE_VALID;
+
+	if (type & PSB_MMU_CACHED_MEMORY)
+		mask |= PSB_PTE_CACHED;
+	if (type & PSB_MMU_RO_MEMORY)
+		mask |= PSB_PTE_RO;
+	if (type & PSB_MMU_WO_MEMORY)
+		mask |= PSB_PTE_WO;
+
+	return (pfn << PAGE_SHIFT) | mask;
+}
+
+/**
+ *	psb_gtt_entry		-	find the GTT entries for a gtt_range
+ *	@dev: our DRM device
+ *	@r: our GTT range
+ *
+ *	Given a gtt_range object return the GTT offset of the page table
+ *	entries for this gtt_range
+ */
+u32 *psb_gtt_entry(struct drm_device *dev, struct gtt_range *r)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	unsigned long offset;
+
+	offset = r->resource.start - dev_priv->gtt_mem->start;
+
+	return dev_priv->gtt_map + (offset >> PAGE_SHIFT);
+}
+
+/**
+ *	psb_gtt_insert	-	put an object into the GTT
+ *	@dev: our DRM device
+ *	@r: our GTT range
+ *
+ *	Take our preallocated GTT range and insert the GEM object into
+ *	the GTT.
+ *
+ *	FIXME: gtt lock ?
+ */
+static int psb_gtt_insert(struct drm_device *dev, struct gtt_range *r)
+{
+	u32 *gtt_slot, pte;
+	struct page **pages;
+	int i;
+
+	if (r->pages == NULL) {
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
+	WARN_ON(r->stolen);	/* refcount these maybe ? */
+
+	gtt_slot = psb_gtt_entry(dev, r);
+	pages = r->pages;
+
+	/* Make sure changes are visible to the GPU */
+	set_pages_array_uc(pages, r->npage);
+
+	/* Write our page entries into the GTT itself */
+	for (i = 0; i < r->npage; i++) {
+		pte = psb_gtt_mask_pte(page_to_pfn(*pages++), 0/*type*/);
+		iowrite32(pte, gtt_slot++);
+	}
+	/* Make sure all the entries are set before we return */
+	ioread32(gtt_slot - 1);
+	return 0;
+}
+
+/**
+ *	psb_gtt_remove	-	remove an object from the GTT
+ *	@dev: our DRM device
+ *	@r: our GTT range
+ *
+ *	Remove a preallocated GTT range from the GTT. Overwrite all the
+ *	page table entries with the dummy page
+ */
+
+static void psb_gtt_remove(struct drm_device *dev, struct gtt_range *r)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	u32 *gtt_slot, pte;
+	int i;
+
+	WARN_ON(r->stolen);
+
+	gtt_slot = psb_gtt_entry(dev, r);
+	pte = psb_gtt_mask_pte(page_to_pfn(dev_priv->scratch_page), 0);
+
+	for (i = 0; i < r->npage; i++)
+		iowrite32(pte, gtt_slot++);
+	ioread32(gtt_slot - 1);
+	set_pages_array_wb(r->pages, r->npage);
+}
+
+/**
+ *	psb_gtt_attach_pages	-	attach and pin GEM pages
+ *	@gt: the gtt range
+ *
+ *	Pin and build an in kernel list of the pages that back our GEM object.
+ *	While we hold this the pages cannot be swapped out
+ */
+static int psb_gtt_attach_pages(struct gtt_range *gt)
+{
+	struct inode *inode;
+	struct address_space *mapping;
+	int i;
+	struct page *p;
+	int pages = gt->gem.size / PAGE_SIZE;
+
+	WARN_ON(gt->pages);
+
+	/* This is the shared memory object that backs the GEM resource */
+	inode = gt->gem.filp->f_path.dentry->d_inode;
+	mapping = inode->i_mapping;
+
+	gt->pages = kmalloc(pages * sizeof(struct page *), GFP_KERNEL);
+	if (gt->pages == NULL)
+		return -ENOMEM;
+	gt->npage = pages;
+
+	for (i = 0; i < pages; i++) {
+		/* FIXME: review flags later */
+		p = read_cache_page_gfp(mapping, i,
+					__GFP_COLD | GFP_KERNEL);
+		if (IS_ERR(p))
+			goto err;
+		gt->pages[i] = p;
+	}
+	return 0;
+
+err:
+	while (i--)
+		page_cache_release(gt->pages[i]);
+	kfree(gt->pages);
+	gt->pages = NULL;
+	return PTR_ERR(p);
+}
+
+/**
+ *	psb_gtt_detach_pages	-	attach and pin GEM pages
+ *	@gt: the gtt range
+ *
+ *	Undo the effect of psb_gtt_attach_pages. At this point the pages
+ *	must have been removed from the GTT as they could now be paged out
+ *	and move bus address.
+ */
+static void psb_gtt_detach_pages(struct gtt_range *gt)
+{
+	int i;
+	for (i = 0; i < gt->npage; i++) {
+		/* FIXME: do we need to force dirty */
+		set_page_dirty(gt->pages[i]);
+		page_cache_release(gt->pages[i]);
+	}
+	kfree(gt->pages);
+	gt->pages = NULL;
+}
+
+/**
+ *	psb_gtt_pin		-	pin pages into the GTT
+ *	@gt: range to pin
+ *
+ *	Pin a set of pages into the GTT. The pins are refcounted so that
+ *	multiple pins need multiple unpins to undo.
+ *
+ *	Non GEM backed objects treat this as a no-op as they are always GTT
+ *	backed objects.
+ */
+int psb_gtt_pin(struct gtt_range *gt)
+{
+	int ret = 0;
+	struct drm_device *dev = gt->gem.dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+
+	mutex_lock(&dev_priv->gtt_mutex);
+
+	if (gt->in_gart == 0 && gt->stolen == 0) {
+		ret = psb_gtt_attach_pages(gt);
+		if (ret < 0)
+			goto out;
+		ret = psb_gtt_insert(dev, gt);
+		if (ret < 0) {
+			psb_gtt_detach_pages(gt);
+			goto out;
+		}
+	}
+	gt->in_gart++;
+out:
+	mutex_unlock(&dev_priv->gtt_mutex);
+	return ret;
+}
+
+/**
+ *	psb_gtt_unpin		-	Drop a GTT pin requirement
+ *	@gt: range to pin
+ *
+ *	Undoes the effect of psb_gtt_pin. On the last drop the GEM object
+ *	will be removed from the GTT which will also drop the page references
+ *	and allow the VM to clean up or page stuff.
+ *
+ *	Non GEM backed objects treat this as a no-op as they are always GTT
+ *	backed objects.
+ */
+void psb_gtt_unpin(struct gtt_range *gt)
+{
+	struct drm_device *dev = gt->gem.dev;
+	struct drm_psb_private *dev_priv = dev->dev_private;
+
+	mutex_lock(&dev_priv->gtt_mutex);
+
+	WARN_ON(!gt->in_gart);
+
+	gt->in_gart--;
+	if (gt->in_gart == 0 && gt->stolen == 0) {
+		psb_gtt_remove(dev, gt);
+		psb_gtt_detach_pages(gt);
+	}
+	mutex_unlock(&dev_priv->gtt_mutex);
+}
+
+/*
+ *	GTT resource allocator - allocate and manage GTT address space
+ */
+
+/**
+ *	psb_gtt_alloc_range	-	allocate GTT address space
+ *	@dev: Our DRM device
+ *	@len: length (bytes) of address space required
+ *	@name: resource name
+ *	@backed: resource should be backed by stolen pages
+ *
+ *	Ask the kernel core to find us a suitable range of addresses
+ *	to use for a GTT mapping.
+ *
+ *	Returns a gtt_range structure describing the object, or NULL on
+ *	error. On successful return the resource is both allocated and marked
+ *	as in use.
+ */
+struct gtt_range *psb_gtt_alloc_range(struct drm_device *dev, int len,
+						const char *name, int backed)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	struct gtt_range *gt;
+	struct resource *r = dev_priv->gtt_mem;
+	int ret;
+	unsigned long start, end;
+
+	if (backed) {
+		/* The start of the GTT is the stolen pages */
+		start = r->start;
+		end = r->start + dev_priv->pg->stolen_size - 1;
+	} else {
+		/* The rest we will use for GEM backed objects */
+		start = r->start + dev_priv->pg->stolen_size;
+		end = r->end;
+	}
+
+	gt = kzalloc(sizeof(struct gtt_range), GFP_KERNEL);
+	if (gt == NULL)
+		return NULL;
+	gt->resource.name = name;
+	gt->stolen = backed;
+	gt->in_gart = backed;
+	/* Ensure this is set for non GEM objects */
+	gt->gem.dev = dev;
+	ret = allocate_resource(dev_priv->gtt_mem, &gt->resource,
+				len, start, end, PAGE_SIZE, NULL, NULL);
+	if (ret == 0) {
+		gt->offset = gt->resource.start - r->start;
+		return gt;
+	}
+	kfree(gt);
+	return NULL;
+}
+
+/**
+ *	psb_gtt_free_range	-	release GTT address space
+ *	@dev: our DRM device
+ *	@gt: a mapping created with psb_gtt_alloc_range
+ *
+ *	Release a resource that was allocated with psb_gtt_alloc_range. If the
+ *	object has been pinned by mmap users we clean this up here currently.
+ */
+void psb_gtt_free_range(struct drm_device *dev, struct gtt_range *gt)
+{
+	/* Undo the mmap pin if we are destroying the object */
+	if (gt->mmapping) {
+		psb_gtt_unpin(gt);
+		gt->mmapping = 0;
+	}
+	WARN_ON(gt->in_gart && !gt->stolen);
+	release_resource(&gt->resource);
+	kfree(gt);
+}
+
+struct psb_gtt *psb_gtt_alloc(struct drm_device *dev)
+{
+	struct psb_gtt *tmp = kzalloc(sizeof(*tmp), GFP_KERNEL);
+
+	if (!tmp)
+		return NULL;
+
+	init_rwsem(&tmp->sem);
+	tmp->dev = dev;
+
+	return tmp;
+}
+
+void psb_gtt_takedown(struct drm_device *dev)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+
+	if (dev_priv->gtt_map) {
+		iounmap(dev_priv->gtt_map);
+		dev_priv->gtt_map = NULL;
+	}
+	if (dev_priv->gtt_initialized) {
+		pci_write_config_word(dev->pdev, PSB_GMCH_CTRL,
+				      dev_priv->gmch_ctrl);
+		PSB_WVDC32(dev_priv->pge_ctl, PSB_PGETBL_CTL);
+		(void) PSB_RVDC32(PSB_PGETBL_CTL);
+	}
+	if (dev_priv->vram_addr)
+		iounmap(dev_priv->gtt_map);
+	kfree(dev_priv->pg);
+	dev_priv->pg = NULL;
+}
+
+int psb_gtt_init(struct drm_device *dev, int resume)
+{
+	struct drm_psb_private *dev_priv = dev->dev_private;
+	unsigned gtt_pages;
+	unsigned long stolen_size, vram_stolen_size;
+	unsigned i, num_pages;
+	unsigned pfn_base;
+	uint32_t vram_pages;
+	uint32_t dvmt_mode = 0;
+	struct psb_gtt *pg;
+
+	int ret = 0;
+	uint32_t pte;
+
+	mutex_init(&dev_priv->gtt_mutex);
+
+	dev_priv->pg = pg = psb_gtt_alloc(dev);
+	if (pg == NULL)
+		return -ENOMEM;
+
+	/* Enable the GTT */
+	pci_read_config_word(dev->pdev, PSB_GMCH_CTRL, &dev_priv->gmch_ctrl);
+	pci_write_config_word(dev->pdev, PSB_GMCH_CTRL,
+			      dev_priv->gmch_ctrl | _PSB_GMCH_ENABLED);
+
+	dev_priv->pge_ctl = PSB_RVDC32(PSB_PGETBL_CTL);
+	PSB_WVDC32(dev_priv->pge_ctl | _PSB_PGETBL_ENABLED, PSB_PGETBL_CTL);
+	(void) PSB_RVDC32(PSB_PGETBL_CTL);
+
+	/* The root resource we allocate address space from */
+	dev_priv->gtt_mem = &dev->pdev->resource[PSB_GATT_RESOURCE];
+	dev_priv->gtt_initialized = 1;
+
+	pg->gtt_phys_start = dev_priv->pge_ctl & PAGE_MASK;
+
+	pg->gatt_start = pci_resource_start(dev->pdev, PSB_GATT_RESOURCE);
+	/*
+	 *	FIXME: video mmu has hw bug to access 0x0D0000000,
+	 *	then make gatt start at 0x0e000,0000
+	 */
+	pg->mmu_gatt_start = 0xE0000000;
+
+	pg->gtt_start = pci_resource_start(dev->pdev, PSB_GTT_RESOURCE);
+	gtt_pages = pci_resource_len(dev->pdev, PSB_GTT_RESOURCE)
+								>> PAGE_SHIFT;
+	pg->gatt_pages = pci_resource_len(dev->pdev, PSB_GATT_RESOURCE)
+								>> PAGE_SHIFT;
+
+	pci_read_config_dword(dev->pdev, PSB_BSM, &dev_priv->stolen_base);
+	vram_stolen_size = pg->gtt_phys_start - dev_priv->stolen_base
+								- PAGE_SIZE;
+
+	stolen_size = vram_stolen_size;
+
+	printk(KERN_INFO "Stolen memory information\n");
+	printk(KERN_INFO "       base in RAM: 0x%x\n", dev_priv->stolen_base);
+	printk(KERN_INFO "       size: %luK, calculated by (GTT RAM base) - (Stolen base), seems wrong\n",
+		vram_stolen_size/1024);
+	dvmt_mode = (dev_priv->gmch_ctrl >> 4) & 0x7;
+	printk(KERN_INFO "      the correct size should be: %dM(dvmt mode=%d)\n",
+		(dvmt_mode == 1) ? 1 : (2 << (dvmt_mode - 1)), dvmt_mode);
+
+	if (resume && (gtt_pages != pg->gtt_pages) &&
+	    (stolen_size != pg->stolen_size)) {
+		dev_err(dev->dev, "GTT resume error.\n");
+		ret = -EINVAL;
+		goto out_err;
+	}
+
+	pg->gtt_pages = gtt_pages;
+	pg->stolen_size = stolen_size;
+	dev_priv->vram_stolen_size = vram_stolen_size;
+
+	/*
+	 *	Map the GTT and the stolen memory area
+	 */
+	dev_priv->gtt_map = ioremap_nocache(pg->gtt_phys_start,
+						gtt_pages << PAGE_SHIFT);
+	if (!dev_priv->gtt_map) {
+		dev_err(dev->dev, "Failure to map gtt.\n");
+		ret = -ENOMEM;
+		goto out_err;
+	}
+
+	dev_priv->vram_addr = ioremap_wc(dev_priv->stolen_base, stolen_size);
+	if (!dev_priv->vram_addr) {
+		dev_err(dev->dev, "Failure to map stolen base.\n");
+		ret = -ENOMEM;
+		goto out_err;
+	}
+
+	/*
+	 * Insert vram stolen pages into the GTT
+	 */
+
+	pfn_base = dev_priv->stolen_base >> PAGE_SHIFT;
+	vram_pages = num_pages = vram_stolen_size >> PAGE_SHIFT;
+	printk(KERN_INFO"Set up %d stolen pages starting at 0x%08x, GTT offset %dK\n",
+		num_pages, pfn_base, 0);
+	for (i = 0; i < num_pages; ++i) {
+		pte = psb_gtt_mask_pte(pfn_base + i, 0);
+		iowrite32(pte, dev_priv->gtt_map + i);
+	}
+
+	/*
+	 * Init rest of GTT to the scratch page to avoid accidents or scribbles
+	 */
+
+	pfn_base = page_to_pfn(dev_priv->scratch_page);
+	pte = psb_gtt_mask_pte(pfn_base, 0);
+	for (; i < gtt_pages; ++i)
+		iowrite32(pte, dev_priv->gtt_map + i);
+
+	(void) ioread32(dev_priv->gtt_map + i - 1);
+	return 0;
+
+out_err:
+	psb_gtt_takedown(dev);
+	return ret;
+}
diff --git a/drivers/staging/gma500/gtt.h b/drivers/staging/gma500/gtt.h
new file mode 100644
index 0000000..4d6dc5f
--- /dev/null
+++ b/drivers/staging/gma500/gtt.h
@@ -0,0 +1,62 @@
+/**************************************************************************
+ * Copyright (c) 2007-2008, Intel Corporation.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ **************************************************************************/
+
+#ifndef _PSB_GTT_H_
+#define _PSB_GTT_H_
+
+#include <drm/drmP.h>
+
+/* This wants cleaning up with respect to the psb_dev and un-needed stuff */
+struct psb_gtt {
+	struct drm_device *dev;
+	uint32_t gatt_start;
+	uint32_t mmu_gatt_start;
+	uint32_t gtt_start;
+	uint32_t gtt_phys_start;
+	unsigned gtt_pages;
+	unsigned gatt_pages;
+	unsigned long stolen_size;
+	unsigned long vram_stolen_size;
+	struct rw_semaphore sem;
+};
+
+/*Exported functions*/
+extern int psb_gtt_init(struct drm_device *dev, int resume);
+extern void psb_gtt_takedown(struct drm_device *dev);
+
+/* Each gtt_range describes an allocation in the GTT area */
+struct gtt_range {
+	struct resource resource;	/* Resource for our allocation */
+	u32 offset;			/* GTT offset of our object */
+	struct drm_gem_object gem;	/* GEM high level stuff */
+	int in_gart;			/* Currently in the GART (ref ct) */
+	bool stolen;			/* Backed from stolen RAM */
+	bool mmapping;			/* Is mmappable */
+	struct page **pages;		/* Backing pages if present */
+	int npage;			/* Number of backing pages */
+};
+
+extern struct gtt_range *psb_gtt_alloc_range(struct drm_device *dev, int len,
+						const char *name, int backed);
+extern void psb_gtt_kref_put(struct gtt_range *gt);
+extern void psb_gtt_free_range(struct drm_device *dev, struct gtt_range *gt);
+extern int psb_gtt_pin(struct gtt_range *gt);
+extern void psb_gtt_unpin(struct gtt_range *gt);
+
+#endif
diff --git a/drivers/staging/gma500/psb_drv.h b/drivers/staging/gma500/psb_drv.h
index 9c6aba5..307ff9c 100644
--- a/drivers/staging/gma500/psb_drv.h
+++ b/drivers/staging/gma500/psb_drv.h
@@ -29,7 +29,7 @@
 #include "psb_drm.h"
 #include "psb_reg.h"
 #include "psb_intel_drv.h"
-#include "psb_gtt.h"
+#include "gtt.h"
 #include "psb_powermgmt.h"
 #include "mrst.h"
 
diff --git a/drivers/staging/gma500/psb_gem.c b/drivers/staging/gma500/psb_gem.c
deleted file mode 100644
index a63ad9e..0000000
--- a/drivers/staging/gma500/psb_gem.c
+++ /dev/null
@@ -1,252 +0,0 @@
-/*
- *  psb GEM interface
- *
- * Copyright (c) 2011, Intel Corporation.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
- *
- * Authors: Alan Cox
- *
- * TODO:
- *	-	we need to work out if the MMU is relevant (eg for
- *		accelerated operations on a GEM object)
- */
-
-#include <drm/drmP.h>
-#include <drm/drm.h>
-#include "psb_drm.h"
-#include "psb_drv.h"
-
-int psb_gem_init_object(struct drm_gem_object *obj)
-{
-	return -EINVAL;
-}
-
-void psb_gem_free_object(struct drm_gem_object *obj)
-{
-	struct gtt_range *gtt = container_of(obj, struct gtt_range, gem);
-	drm_gem_object_release_wrap(obj);
-	/* This must occur last as it frees up the memory of the GEM object */
-	psb_gtt_free_range(obj->dev, gtt);
-}
-
-int psb_gem_get_aperture(struct drm_device *dev, void *data,
-				struct drm_file *file)
-{
-	return -EINVAL;
-}
-
-/**
- *	psb_gem_dumb_map_gtt	-	buffer mapping for dumb interface
- *	@file: our drm client file
- *	@dev: drm device
- *	@handle: GEM handle to the object (from dumb_create)
- *
- *	Do the necessary setup to allow the mapping of the frame buffer
- *	into user memory. We don't have to do much here at the moment.
- */
-int psb_gem_dumb_map_gtt(struct drm_file *file, struct drm_device *dev,
-			 uint32_t handle, uint64_t *offset)
-{
-	int ret = 0;
-	struct drm_gem_object *obj;
-
-	if (!(dev->driver->driver_features & DRIVER_GEM))
-		return -ENODEV;
-
-	mutex_lock(&dev->struct_mutex);
-
-	/* GEM does all our handle to object mapping */
-	obj = drm_gem_object_lookup(dev, file, handle);
-	if (obj == NULL) {
-		ret = -ENOENT;
-		goto unlock;
-	}
-	/* What validation is needed here ? */
-
-	/* Make it mmapable */
-	if (!obj->map_list.map) {
-		ret = gem_create_mmap_offset(obj);
-		if (ret)
-			goto out;
-	}
-	/* GEM should really work out the hash offsets for us */
-	*offset = (u64)obj->map_list.hash.key << PAGE_SHIFT;
-out:
-	drm_gem_object_unreference(obj);
-unlock:
-	mutex_unlock(&dev->struct_mutex);
-	return ret;
-}
-
-/**
- *	psb_gem_create		-	create a mappable object
- *	@file: the DRM file of the client
- *	@dev: our device
- *	@size: the size requested
- *	@handlep: returned handle (opaque number)
- *
- *	Create a GEM object, fill in the boilerplate and attach a handle to
- *	it so that userspace can speak about it. This does the core work
- *	for the various methods that do/will create GEM objects for things
- */
-static int psb_gem_create(struct drm_file *file,
-	struct drm_device *dev, uint64_t size, uint32_t *handlep)
-{
-	struct gtt_range *r;
-	int ret;
-	u32 handle;
-
-	size = roundup(size, PAGE_SIZE);
-
-	/* Allocate our object - for now a direct gtt range which is not
-	   stolen memory backed */
-	r = psb_gtt_alloc_range(dev, size, "gem", 0);
-	if (r == NULL) {
-		dev_err(dev->dev, "no memory for %lld byte GEM object\n", size);
-		return -ENOSPC;
-	}
-	/* Initialize the extra goodies GEM needs to do all the hard work */
-	if (drm_gem_object_init(dev, &r->gem, size) != 0) {
-		psb_gtt_free_range(dev, r);
-		/* GEM doesn't give an error code and we don't have an
-		   EGEMSUCKS so make something up for now - FIXME */
-		dev_err(dev->dev, "GEM init failed for %lld\n", size);
-		return -ENOMEM;
-	}
-	/* Give the object a handle so we can carry it more easily */
-	ret = drm_gem_handle_create(file, &r->gem, &handle);
-	if (ret) {
-		dev_err(dev->dev, "GEM handle failed for %p, %lld\n",
-							&r->gem, size);
-		drm_gem_object_release(&r->gem);
-		psb_gtt_free_range(dev, r);
-		return ret;
-	}
-	/* We have the initial and handle reference but need only one now */
-	drm_gem_object_unreference(&r->gem);
-	*handlep = handle;
-	return 0;
-}
-
-/**
- *	psb_gem_dumb_create	-	create a dumb buffer
- *	@drm_file: our client file
- *	@dev: our device
- *	@args: the requested arguments copied from userspace
- *
- *	Allocate a buffer suitable for use for a frame buffer of the
- *	form described by user space. Give userspace a handle by which
- *	to reference it.
- */
-int psb_gem_dumb_create(struct drm_file *file, struct drm_device *dev,
-			struct drm_mode_create_dumb *args)
-{
-	args->pitch = ALIGN(args->width * ((args->bpp + 7) / 8), 64);
-	args->size = args->pitch * args->height;
-	return psb_gem_create(file, dev, args->size, &args->handle);
-}
-
-/**
- *	psb_gem_dumb_destroy	-	destroy a dumb buffer
- *	@file: client file
- *	@dev: our DRM device
- *	@handle: the object handle
- *
- *	Destroy a handle that was created via psb_gem_dumb_create, at least
- *	we hope it was created that way. i915 seems to assume the caller
- *	does the checking but that might be worth review ! FIXME
- */
-int psb_gem_dumb_destroy(struct drm_file *file, struct drm_device *dev,
-			uint32_t handle)
-{
-	/* No special work needed, drop the reference and see what falls out */
-	return drm_gem_handle_delete(file, handle);
-}
-
-/**
- *	psb_gem_fault		-	pagefault handler for GEM objects
- *	@vma: the VMA of the GEM object
- *	@vmf: fault detail
- *
- *	Invoked when a fault occurs on an mmap of a GEM managed area. GEM
- *	does most of the work for us including the actual map/unmap calls
- *	but we need to do the actual page work.
- *
- *	This code eventually needs to handle faulting objects in and out
- *	of the GTT and repacking it when we run out of space. We can put
- *	that off for now and for our simple uses
- *
- *	The VMA was set up by GEM. In doing so it also ensured that the
- *	vma->vm_private_data points to the GEM object that is backing this
- *	mapping.
- *
- *	FIXME
- */
-int psb_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
-{
-	struct drm_gem_object *obj;
-	struct gtt_range *r;
-	int ret;
-	unsigned long pfn;
-	pgoff_t page_offset;
-	struct drm_device *dev;
-	struct drm_psb_private *dev_priv;
-
-	obj = vma->vm_private_data;	/* GEM object */
-	dev = obj->dev;
-	dev_priv = dev->dev_private;
-
-	r = container_of(obj, struct gtt_range, gem);	/* Get the gtt range */
-
-	/* Make sure we don't parallel update on a fault, nor move or remove
-	   something from beneath our feet */
-	mutex_lock(&dev->struct_mutex);
-
-	/* For now the mmap pins the object and it stays pinned. As things
-	   stand that will do us no harm */
-	if (r->mmapping == 0) {
-		ret = psb_gtt_pin(r);
-		if (ret < 0) {
-			dev_err(dev->dev, "gma500: pin failed: %d\n", ret);
-			goto fail;
-		}
-		r->mmapping = 1;
-	}
-
-	/* Page relative to the VMA start - we must calculate this ourselves
-	   because vmf->pgoff is the fake GEM offset */
-	page_offset = ((unsigned long) vmf->virtual_address - vma->vm_start)
-				>> PAGE_SHIFT;
-
-	/* CPU view of the page, don't go via the GART for CPU writes */
-	if (r->stolen)
-		pfn = (dev_priv->stolen_base + r->offset) >> PAGE_SHIFT;
-	else
-		pfn = page_to_pfn(r->pages[page_offset]);
-	ret = vm_insert_pfn(vma, (unsigned long)vmf->virtual_address, pfn);
-
-fail:
-	mutex_unlock(&dev->struct_mutex);
-	switch (ret) {
-	case 0:
-	case -ERESTARTSYS:
-	case -EINTR:
-		return VM_FAULT_NOPAGE;
-	case -ENOMEM:
-		return VM_FAULT_OOM;
-	default:
-		return VM_FAULT_SIGBUS;
-	}
-}
diff --git a/drivers/staging/gma500/psb_gtt.c b/drivers/staging/gma500/psb_gtt.c
deleted file mode 100644
index 6cfa59b..0000000
--- a/drivers/staging/gma500/psb_gtt.c
+++ /dev/null
@@ -1,487 +0,0 @@
-/*
- * Copyright (c) 2007, Intel Corporation.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
- *
- * Authors: Thomas Hellstrom <thomas-at-tungstengraphics.com>
- *	    Alan Cox <alan@linux.intel.com>
- */
-
-#include <drm/drmP.h>
-#include "psb_drv.h"
-
-
-/*
- *	GTT resource allocator - manage page mappings in GTT space
- */
-
-/**
- *	psb_gtt_mask_pte	-	generate GTT pte entry
- *	@pfn: page number to encode
- *	@type: type of memory in the GTT
- *
- *	Set the GTT entry for the appropriate memory type.
- */
-static inline uint32_t psb_gtt_mask_pte(uint32_t pfn, int type)
-{
-	uint32_t mask = PSB_PTE_VALID;
-
-	if (type & PSB_MMU_CACHED_MEMORY)
-		mask |= PSB_PTE_CACHED;
-	if (type & PSB_MMU_RO_MEMORY)
-		mask |= PSB_PTE_RO;
-	if (type & PSB_MMU_WO_MEMORY)
-		mask |= PSB_PTE_WO;
-
-	return (pfn << PAGE_SHIFT) | mask;
-}
-
-/**
- *	psb_gtt_entry		-	find the GTT entries for a gtt_range
- *	@dev: our DRM device
- *	@r: our GTT range
- *
- *	Given a gtt_range object return the GTT offset of the page table
- *	entries for this gtt_range
- */
-u32 *psb_gtt_entry(struct drm_device *dev, struct gtt_range *r)
-{
-	struct drm_psb_private *dev_priv = dev->dev_private;
-	unsigned long offset;
-
-	offset = r->resource.start - dev_priv->gtt_mem->start;
-
-	return dev_priv->gtt_map + (offset >> PAGE_SHIFT);
-}
-
-/**
- *	psb_gtt_insert	-	put an object into the GTT
- *	@dev: our DRM device
- *	@r: our GTT range
- *
- *	Take our preallocated GTT range and insert the GEM object into
- *	the GTT.
- *
- *	FIXME: gtt lock ?
- */
-static int psb_gtt_insert(struct drm_device *dev, struct gtt_range *r)
-{
-	u32 *gtt_slot, pte;
-	struct page **pages;
-	int i;
-
-	if (r->pages == NULL) {
-		WARN_ON(1);
-		return -EINVAL;
-	}
-
-	WARN_ON(r->stolen);	/* refcount these maybe ? */
-
-	gtt_slot = psb_gtt_entry(dev, r);
-	pages = r->pages;
-
-	/* Make sure changes are visible to the GPU */
-	set_pages_array_uc(pages, r->npage);
-
-	/* Write our page entries into the GTT itself */
-	for (i = 0; i < r->npage; i++) {
-		pte = psb_gtt_mask_pte(page_to_pfn(*pages++), 0/*type*/);
-		iowrite32(pte, gtt_slot++);
-	}
-	/* Make sure all the entries are set before we return */
-	ioread32(gtt_slot - 1);
-	return 0;
-}
-
-/**
- *	psb_gtt_remove	-	remove an object from the GTT
- *	@dev: our DRM device
- *	@r: our GTT range
- *
- *	Remove a preallocated GTT range from the GTT. Overwrite all the
- *	page table entries with the dummy page
- */
-
-static void psb_gtt_remove(struct drm_device *dev, struct gtt_range *r)
-{
-	struct drm_psb_private *dev_priv = dev->dev_private;
-	u32 *gtt_slot, pte;
-	int i;
-
-	WARN_ON(r->stolen);
-
-	gtt_slot = psb_gtt_entry(dev, r);
-	pte = psb_gtt_mask_pte(page_to_pfn(dev_priv->scratch_page), 0);
-
-	for (i = 0; i < r->npage; i++)
-		iowrite32(pte, gtt_slot++);
-	ioread32(gtt_slot - 1);
-	set_pages_array_wb(r->pages, r->npage);
-}
-
-/**
- *	psb_gtt_attach_pages	-	attach and pin GEM pages
- *	@gt: the gtt range
- *
- *	Pin and build an in kernel list of the pages that back our GEM object.
- *	While we hold this the pages cannot be swapped out
- */
-static int psb_gtt_attach_pages(struct gtt_range *gt)
-{
-	struct inode *inode;
-	struct address_space *mapping;
-	int i;
-	struct page *p;
-	int pages = gt->gem.size / PAGE_SIZE;
-
-	WARN_ON(gt->pages);
-
-	/* This is the shared memory object that backs the GEM resource */
-	inode = gt->gem.filp->f_path.dentry->d_inode;
-	mapping = inode->i_mapping;
-
-	gt->pages = kmalloc(pages * sizeof(struct page *), GFP_KERNEL);
-	if (gt->pages == NULL)
-		return -ENOMEM;
-	gt->npage = pages;
-
-	for (i = 0; i < pages; i++) {
-		/* FIXME: review flags later */
-		p = read_cache_page_gfp(mapping, i,
-					__GFP_COLD | GFP_KERNEL);
-		if (IS_ERR(p))
-			goto err;
-		gt->pages[i] = p;
-	}
-	return 0;
-
-err:
-	while (i--)
-		page_cache_release(gt->pages[i]);
-	kfree(gt->pages);
-	gt->pages = NULL;
-	return PTR_ERR(p);
-}
-
-/**
- *	psb_gtt_detach_pages	-	attach and pin GEM pages
- *	@gt: the gtt range
- *
- *	Undo the effect of psb_gtt_attach_pages. At this point the pages
- *	must have been removed from the GTT as they could now be paged out
- *	and move bus address.
- */
-static void psb_gtt_detach_pages(struct gtt_range *gt)
-{
-	int i;
-	for (i = 0; i < gt->npage; i++) {
-		/* FIXME: do we need to force dirty */
-		set_page_dirty(gt->pages[i]);
-		page_cache_release(gt->pages[i]);
-	}
-	kfree(gt->pages);
-	gt->pages = NULL;
-}
-
-/**
- *	psb_gtt_pin		-	pin pages into the GTT
- *	@gt: range to pin
- *
- *	Pin a set of pages into the GTT. The pins are refcounted so that
- *	multiple pins need multiple unpins to undo.
- *
- *	Non GEM backed objects treat this as a no-op as they are always GTT
- *	backed objects.
- */
-int psb_gtt_pin(struct gtt_range *gt)
-{
-	int ret = 0;
-	struct drm_device *dev = gt->gem.dev;
-	struct drm_psb_private *dev_priv = dev->dev_private;
-
-	mutex_lock(&dev_priv->gtt_mutex);
-
-	if (gt->in_gart == 0 && gt->stolen == 0) {
-		ret = psb_gtt_attach_pages(gt);
-		if (ret < 0)
-			goto out;
-		ret = psb_gtt_insert(dev, gt);
-		if (ret < 0) {
-			psb_gtt_detach_pages(gt);
-			goto out;
-		}
-	}
-	gt->in_gart++;
-out:
-	mutex_unlock(&dev_priv->gtt_mutex);
-	return ret;
-}
-
-/**
- *	psb_gtt_unpin		-	Drop a GTT pin requirement
- *	@gt: range to pin
- *
- *	Undoes the effect of psb_gtt_pin. On the last drop the GEM object
- *	will be removed from the GTT which will also drop the page references
- *	and allow the VM to clean up or page stuff.
- *
- *	Non GEM backed objects treat this as a no-op as they are always GTT
- *	backed objects.
- */
-void psb_gtt_unpin(struct gtt_range *gt)
-{
-	struct drm_device *dev = gt->gem.dev;
-	struct drm_psb_private *dev_priv = dev->dev_private;
-
-	mutex_lock(&dev_priv->gtt_mutex);
-
-	WARN_ON(!gt->in_gart);
-
-	gt->in_gart--;
-	if (gt->in_gart == 0 && gt->stolen == 0) {
-		psb_gtt_remove(dev, gt);
-		psb_gtt_detach_pages(gt);
-	}
-	mutex_unlock(&dev_priv->gtt_mutex);
-}
-
-/*
- *	GTT resource allocator - allocate and manage GTT address space
- */
-
-/**
- *	psb_gtt_alloc_range	-	allocate GTT address space
- *	@dev: Our DRM device
- *	@len: length (bytes) of address space required
- *	@name: resource name
- *	@backed: resource should be backed by stolen pages
- *
- *	Ask the kernel core to find us a suitable range of addresses
- *	to use for a GTT mapping.
- *
- *	Returns a gtt_range structure describing the object, or NULL on
- *	error. On successful return the resource is both allocated and marked
- *	as in use.
- */
-struct gtt_range *psb_gtt_alloc_range(struct drm_device *dev, int len,
-						const char *name, int backed)
-{
-	struct drm_psb_private *dev_priv = dev->dev_private;
-	struct gtt_range *gt;
-	struct resource *r = dev_priv->gtt_mem;
-	int ret;
-	unsigned long start, end;
-
-	if (backed) {
-		/* The start of the GTT is the stolen pages */
-		start = r->start;
-		end = r->start + dev_priv->pg->stolen_size - 1;
-	} else {
-		/* The rest we will use for GEM backed objects */
-		start = r->start + dev_priv->pg->stolen_size;
-		end = r->end;
-	}
-
-	gt = kzalloc(sizeof(struct gtt_range), GFP_KERNEL);
-	if (gt == NULL)
-		return NULL;
-	gt->resource.name = name;
-	gt->stolen = backed;
-	gt->in_gart = backed;
-	/* Ensure this is set for non GEM objects */
-	gt->gem.dev = dev;
-	ret = allocate_resource(dev_priv->gtt_mem, &gt->resource,
-				len, start, end, PAGE_SIZE, NULL, NULL);
-	if (ret == 0) {
-		gt->offset = gt->resource.start - r->start;
-		return gt;
-	}
-	kfree(gt);
-	return NULL;
-}
-
-/**
- *	psb_gtt_free_range	-	release GTT address space
- *	@dev: our DRM device
- *	@gt: a mapping created with psb_gtt_alloc_range
- *
- *	Release a resource that was allocated with psb_gtt_alloc_range. If the
- *	object has been pinned by mmap users we clean this up here currently.
- */
-void psb_gtt_free_range(struct drm_device *dev, struct gtt_range *gt)
-{
-	/* Undo the mmap pin if we are destroying the object */
-	if (gt->mmapping) {
-		psb_gtt_unpin(gt);
-		gt->mmapping = 0;
-	}
-	WARN_ON(gt->in_gart && !gt->stolen);
-	release_resource(&gt->resource);
-	kfree(gt);
-}
-
-struct psb_gtt *psb_gtt_alloc(struct drm_device *dev)
-{
-	struct psb_gtt *tmp = kzalloc(sizeof(*tmp), GFP_KERNEL);
-
-	if (!tmp)
-		return NULL;
-
-	init_rwsem(&tmp->sem);
-	tmp->dev = dev;
-
-	return tmp;
-}
-
-void psb_gtt_takedown(struct drm_device *dev)
-{
-	struct drm_psb_private *dev_priv = dev->dev_private;
-
-	if (dev_priv->gtt_map) {
-		iounmap(dev_priv->gtt_map);
-		dev_priv->gtt_map = NULL;
-	}
-	if (dev_priv->gtt_initialized) {
-		pci_write_config_word(dev->pdev, PSB_GMCH_CTRL,
-				      dev_priv->gmch_ctrl);
-		PSB_WVDC32(dev_priv->pge_ctl, PSB_PGETBL_CTL);
-		(void) PSB_RVDC32(PSB_PGETBL_CTL);
-	}
-	if (dev_priv->vram_addr)
-		iounmap(dev_priv->gtt_map);
-	kfree(dev_priv->pg);
-	dev_priv->pg = NULL;
-}
-
-int psb_gtt_init(struct drm_device *dev, int resume)
-{
-	struct drm_psb_private *dev_priv = dev->dev_private;
-	unsigned gtt_pages;
-	unsigned long stolen_size, vram_stolen_size;
-	unsigned i, num_pages;
-	unsigned pfn_base;
-	uint32_t vram_pages;
-	uint32_t dvmt_mode = 0;
-	struct psb_gtt *pg;
-
-	int ret = 0;
-	uint32_t pte;
-
-	mutex_init(&dev_priv->gtt_mutex);
-
-	dev_priv->pg = pg = psb_gtt_alloc(dev);
-	if (pg == NULL)
-		return -ENOMEM;
-
-	/* Enable the GTT */
-	pci_read_config_word(dev->pdev, PSB_GMCH_CTRL, &dev_priv->gmch_ctrl);
-	pci_write_config_word(dev->pdev, PSB_GMCH_CTRL,
-			      dev_priv->gmch_ctrl | _PSB_GMCH_ENABLED);
-
-	dev_priv->pge_ctl = PSB_RVDC32(PSB_PGETBL_CTL);
-	PSB_WVDC32(dev_priv->pge_ctl | _PSB_PGETBL_ENABLED, PSB_PGETBL_CTL);
-	(void) PSB_RVDC32(PSB_PGETBL_CTL);
-
-	/* The root resource we allocate address space from */
-	dev_priv->gtt_mem = &dev->pdev->resource[PSB_GATT_RESOURCE];
-	dev_priv->gtt_initialized = 1;
-
-	pg->gtt_phys_start = dev_priv->pge_ctl & PAGE_MASK;
-
-	pg->gatt_start = pci_resource_start(dev->pdev, PSB_GATT_RESOURCE);
-	/*
-	 *	FIXME: video mmu has hw bug to access 0x0D0000000,
-	 *	then make gatt start at 0x0e000,0000
-	 */
-	pg->mmu_gatt_start = 0xE0000000;
-
-	pg->gtt_start = pci_resource_start(dev->pdev, PSB_GTT_RESOURCE);
-	gtt_pages = pci_resource_len(dev->pdev, PSB_GTT_RESOURCE)
-								>> PAGE_SHIFT;
-	pg->gatt_pages = pci_resource_len(dev->pdev, PSB_GATT_RESOURCE)
-								>> PAGE_SHIFT;
-
-	pci_read_config_dword(dev->pdev, PSB_BSM, &dev_priv->stolen_base);
-	vram_stolen_size = pg->gtt_phys_start - dev_priv->stolen_base
-								- PAGE_SIZE;
-
-	stolen_size = vram_stolen_size;
-
-	printk(KERN_INFO "Stolen memory information\n");
-	printk(KERN_INFO "       base in RAM: 0x%x\n", dev_priv->stolen_base);
-	printk(KERN_INFO "       size: %luK, calculated by (GTT RAM base) - (Stolen base), seems wrong\n",
-		vram_stolen_size/1024);
-	dvmt_mode = (dev_priv->gmch_ctrl >> 4) & 0x7;
-	printk(KERN_INFO "      the correct size should be: %dM(dvmt mode=%d)\n",
-		(dvmt_mode == 1) ? 1 : (2 << (dvmt_mode - 1)), dvmt_mode);
-
-	if (resume && (gtt_pages != pg->gtt_pages) &&
-	    (stolen_size != pg->stolen_size)) {
-		dev_err(dev->dev, "GTT resume error.\n");
-		ret = -EINVAL;
-		goto out_err;
-	}
-
-	pg->gtt_pages = gtt_pages;
-	pg->stolen_size = stolen_size;
-	dev_priv->vram_stolen_size = vram_stolen_size;
-
-	/*
-	 *	Map the GTT and the stolen memory area
-	 */
-	dev_priv->gtt_map = ioremap_nocache(pg->gtt_phys_start,
-						gtt_pages << PAGE_SHIFT);
-	if (!dev_priv->gtt_map) {
-		dev_err(dev->dev, "Failure to map gtt.\n");
-		ret = -ENOMEM;
-		goto out_err;
-	}
-
-	dev_priv->vram_addr = ioremap_wc(dev_priv->stolen_base, stolen_size);
-	if (!dev_priv->vram_addr) {
-		dev_err(dev->dev, "Failure to map stolen base.\n");
-		ret = -ENOMEM;
-		goto out_err;
-	}
-
-	/*
-	 * Insert vram stolen pages into the GTT
-	 */
-
-	pfn_base = dev_priv->stolen_base >> PAGE_SHIFT;
-	vram_pages = num_pages = vram_stolen_size >> PAGE_SHIFT;
-	printk(KERN_INFO"Set up %d stolen pages starting at 0x%08x, GTT offset %dK\n",
-		num_pages, pfn_base, 0);
-	for (i = 0; i < num_pages; ++i) {
-		pte = psb_gtt_mask_pte(pfn_base + i, 0);
-		iowrite32(pte, dev_priv->gtt_map + i);
-	}
-
-	/*
-	 * Init rest of GTT to the scratch page to avoid accidents or scribbles
-	 */
-
-	pfn_base = page_to_pfn(dev_priv->scratch_page);
-	pte = psb_gtt_mask_pte(pfn_base, 0);
-	for (; i < gtt_pages; ++i)
-		iowrite32(pte, dev_priv->gtt_map + i);
-
-	(void) ioread32(dev_priv->gtt_map + i - 1);
-	return 0;
-
-out_err:
-	psb_gtt_takedown(dev);
-	return ret;
-}
diff --git a/drivers/staging/gma500/psb_gtt.h b/drivers/staging/gma500/psb_gtt.h
deleted file mode 100644
index 4d6dc5f..0000000
--- a/drivers/staging/gma500/psb_gtt.h
+++ /dev/null
@@ -1,62 +0,0 @@
-/**************************************************************************
- * Copyright (c) 2007-2008, Intel Corporation.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms and conditions of the GNU General Public License,
- * version 2, as published by the Free Software Foundation.
- *
- * This program is distributed in the hope it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
- *
- **************************************************************************/
-
-#ifndef _PSB_GTT_H_
-#define _PSB_GTT_H_
-
-#include <drm/drmP.h>
-
-/* This wants cleaning up with respect to the psb_dev and un-needed stuff */
-struct psb_gtt {
-	struct drm_device *dev;
-	uint32_t gatt_start;
-	uint32_t mmu_gatt_start;
-	uint32_t gtt_start;
-	uint32_t gtt_phys_start;
-	unsigned gtt_pages;
-	unsigned gatt_pages;
-	unsigned long stolen_size;
-	unsigned long vram_stolen_size;
-	struct rw_semaphore sem;
-};
-
-/*Exported functions*/
-extern int psb_gtt_init(struct drm_device *dev, int resume);
-extern void psb_gtt_takedown(struct drm_device *dev);
-
-/* Each gtt_range describes an allocation in the GTT area */
-struct gtt_range {
-	struct resource resource;	/* Resource for our allocation */
-	u32 offset;			/* GTT offset of our object */
-	struct drm_gem_object gem;	/* GEM high level stuff */
-	int in_gart;			/* Currently in the GART (ref ct) */
-	bool stolen;			/* Backed from stolen RAM */
-	bool mmapping;			/* Is mmappable */
-	struct page **pages;		/* Backing pages if present */
-	int npage;			/* Number of backing pages */
-};
-
-extern struct gtt_range *psb_gtt_alloc_range(struct drm_device *dev, int len,
-						const char *name, int backed);
-extern void psb_gtt_kref_put(struct gtt_range *gt);
-extern void psb_gtt_free_range(struct drm_device *dev, struct gtt_range *gt);
-extern int psb_gtt_pin(struct gtt_range *gt);
-extern void psb_gtt_unpin(struct gtt_range *gt);
-
-#endif

