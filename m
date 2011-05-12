Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758964Ab1ELX5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 19:57:32 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64804 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758905Ab1ELX51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 19:57:27 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com,
        martin.petersen@oracle.com, daniel.stodden@citrix.com, axboe@kernel.dk,
        chris.mason@oracle.com
Cc: hare@suse.de, JBeulich@novell.com, hch@infradead.org,
        xen-devel@lists.xensource.com, Ian.Campbell@citrix.com,
        stefano.stabellini@eu.citrix.com, jeremy@goop.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH] block: xen block backend driver.
Date: Thu, 12 May 2011 19:56:19 -0400
Message-Id: <1305244579-2830-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1305244579-2830-1-git-send-email-konrad.wilk@oracle.com>
References: <1305244579-2830-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090207.4DCC73BE.0021:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the host side counterpart to the frontend driver
in drivers/block/xen-blkfront.c. The PV protocol is also implemented by
frontend drivers in other OSes too, such as the BSDs and even Windows.

The patch is based on the driver from the xen.git pvops kernel tree but
has been put through the checkpatch.pl wringer plus several manual
cleanup passes. It has also been moved from drivers/xen/blkback to
drivers/block/xen-blback.

Reviewed-by: Ian Campbell <ian.campbell@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/block/Kconfig               |   21 +
 drivers/block/Makefile              |    1 +
 drivers/block/xen-blkback/Makefile  |    3 +
 drivers/block/xen-blkback/blkback.c |  822 +++++++++++++++++++++++++++++++++++
 drivers/block/xen-blkback/common.h  |  233 ++++++++++
 drivers/block/xen-blkback/xenbus.c  |  768 ++++++++++++++++++++++++++++++++
 6 files changed, 1848 insertions(+), 0 deletions(-)
 create mode 100644 drivers/block/xen-blkback/Makefile
 create mode 100644 drivers/block/xen-blkback/blkback.c
 create mode 100644 drivers/block/xen-blkback/common.h
 create mode 100644 drivers/block/xen-blkback/xenbus.c

diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
index 83c32cb..717d6e4 100644
--- a/drivers/block/Kconfig
+++ b/drivers/block/Kconfig
@@ -470,6 +470,27 @@ config XEN_BLKDEV_FRONTEND
 	  block device driver.  It communicates with a back-end driver
 	  in another domain which drives the actual block device.
 
+config XEN_BLKDEV_BACKEND
+	tristate "Block-device backend driver"
+	depends on XEN_BACKEND
+	help
+	  The block-device backend driver allows the kernel to export its
+	  block devices to other guests via a high-performance shared-memory
+	  interface.
+
+	  The corresponding Linux frontend driver is enabled by the
+	  CONFIG_XEN_BLKDEV_FRONTEND configuration option.
+
+	  The backend driver attaches itself to a any block device specified
+	  in the XenBus configuration. There are no limits to what the block
+	  device as long as it has a major and minor.
+
+	  If you are compiling a kernel to run in a Xen block backend driver
+	  domain (often this is domain 0) you should say Y here. To
+	  compile this driver as a module, chose M here: the module
+	  will be called xen-blkback.
+
+
 config VIRTIO_BLK
 	tristate "Virtio block driver (EXPERIMENTAL)"
 	depends on EXPERIMENTAL && VIRTIO
diff --git a/drivers/block/Makefile b/drivers/block/Makefile
index 40528ba..76646e9 100644
--- a/drivers/block/Makefile
+++ b/drivers/block/Makefile
@@ -36,6 +36,7 @@ obj-$(CONFIG_BLK_DEV_UB)	+= ub.o
 obj-$(CONFIG_BLK_DEV_HD)	+= hd.o
 
 obj-$(CONFIG_XEN_BLKDEV_FRONTEND)	+= xen-blkfront.o
+obj-$(CONFIG_XEN_BLKDEV_BACKEND)	+= xen-blkback/
 obj-$(CONFIG_BLK_DEV_DRBD)     += drbd/
 obj-$(CONFIG_BLK_DEV_RBD)     += rbd.o
 
diff --git a/drivers/block/xen-blkback/Makefile b/drivers/block/xen-blkback/Makefile
new file mode 100644
index 0000000..e491c1b
--- /dev/null
+++ b/drivers/block/xen-blkback/Makefile
@@ -0,0 +1,3 @@
+obj-$(CONFIG_XEN_BLKDEV_BACKEND) := xen-blkback.o
+
+xen-blkback-y	:= blkback.o xenbus.o
diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
new file mode 100644
index 0000000..9dee545
--- /dev/null
+++ b/drivers/block/xen-blkback/blkback.c
@@ -0,0 +1,822 @@
+/******************************************************************************
+ *
+ * Back-end of the driver for virtual block devices. This portion of the
+ * driver exports a 'unified' block-device interface that can be accessed
+ * by any operating system that implements a compatible front end. A
+ * reference front-end implementation can be found in:
+ *  drivers/block/xen-blkfront.c
+ *
+ * Copyright (c) 2003-2004, Keir Fraser & Steve Hand
+ * Copyright (c) 2005, Christopher Clark
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation; or, when distributed
+ * separately from the Linux kernel or incorporated into other
+ * software packages, subject to the following license:
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this source file (the "Software"), to deal in the Software without
+ * restriction, including without limitation the rights to use, copy, modify,
+ * merge, publish, distribute, sublicense, and/or sell copies of the Software,
+ * and to permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
+ * IN THE SOFTWARE.
+ */
+
+#include <linux/spinlock.h>
+#include <linux/kthread.h>
+#include <linux/list.h>
+#include <linux/delay.h>
+#include <linux/freezer.h>
+
+#include <xen/events.h>
+#include <xen/page.h>
+#include <asm/xen/hypervisor.h>
+#include <asm/xen/hypercall.h>
+#include "common.h"
+
+/*
+ * These are rather arbitrary. They are fairly large because adjacent requests
+ * pulled from a communication ring are quite likely to end up being part of
+ * the same scatter/gather request at the disc.
+ *
+ * ** TRY INCREASING 'xen_blkif_reqs' IF WRITE SPEEDS SEEM TOO LOW **
+ *
+ * This will increase the chances of being able to write whole tracks.
+ * 64 should be enough to keep us competitive with Linux.
+ */
+static int xen_blkif_reqs = 64;
+module_param_named(reqs, xen_blkif_reqs, int, 0);
+MODULE_PARM_DESC(reqs, "Number of blkback requests to allocate");
+
+/* Run-time switchable: /sys/module/blkback/parameters/ */
+static unsigned int log_stats;
+module_param(log_stats, int, 0644);
+
+/*
+ * Each outstanding request that we've passed to the lower device layers has a
+ * 'pending_req' allocated to it. Each buffer_head that completes decrements
+ * the pendcnt towards zero. When it hits zero, the specified domain has a
+ * response queued for it, with the saved 'id' passed back.
+ */
+struct pending_req {
+	struct xen_blkif	*blkif;
+	u64			id;
+	int			nr_pages;
+	atomic_t		pendcnt;
+	unsigned short		operation;
+	int			status;
+	struct list_head	free_list;
+};
+
+#define BLKBACK_INVALID_HANDLE (~0)
+
+struct xen_blkbk {
+	struct pending_req	*pending_reqs;
+	/* List of all 'pending_req' available */
+	struct list_head	pending_free;
+	/* And its spinlock. */
+	spinlock_t		pending_free_lock;
+	wait_queue_head_t	pending_free_wq;
+	/* The list of all pages that are available. */
+	struct page		**pending_pages;
+	/* And the grant handles that are available. */
+	grant_handle_t		*pending_grant_handles;
+};
+
+static struct xen_blkbk *blkbk;
+
+/*
+ * Little helpful macro to figure out the index and virtual address of the
+ * pending_pages[..]. For each 'pending_req' we have have up to
+ * BLKIF_MAX_SEGMENTS_PER_REQUEST (11) pages. The seg would be from 0 through
+ * 10 and would index in the pending_pages[..].
+ */
+static inline int vaddr_pagenr(struct pending_req *req, int seg)
+{
+	return (req - blkbk->pending_reqs) *
+		BLKIF_MAX_SEGMENTS_PER_REQUEST + seg;
+}
+
+#define pending_page(req, seg) pending_pages[vaddr_pagenr(req, seg)]
+
+static inline unsigned long vaddr(struct pending_req *req, int seg)
+{
+	unsigned long pfn = page_to_pfn(blkbk->pending_page(req, seg));
+	return (unsigned long)pfn_to_kaddr(pfn);
+}
+
+#define pending_handle(_req, _seg) \
+	(blkbk->pending_grant_handles[vaddr_pagenr(_req, _seg)])
+
+
+static int do_block_io_op(struct xen_blkif *blkif);
+static int dispatch_rw_block_io(struct xen_blkif *blkif,
+				struct blkif_request *req,
+				struct pending_req *pending_req);
+static void make_response(struct xen_blkif *blkif, u64 id,
+			  unsigned short op, int st);
+
+/*
+ * Retrieve from the 'pending_reqs' a free pending_req structure to be used.
+ */
+static struct pending_req *alloc_req(void)
+{
+	struct pending_req *req = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&blkbk->pending_free_lock, flags);
+	if (!list_empty(&blkbk->pending_free)) {
+		req = list_entry(blkbk->pending_free.next, struct pending_req,
+				 free_list);
+		list_del(&req->free_list);
+	}
+	spin_unlock_irqrestore(&blkbk->pending_free_lock, flags);
+	return req;
+}
+
+/*
+ * Return the 'pending_req' structure back to the freepool. We also
+ * wake up the thread if it was waiting for a free page.
+ */
+static void free_req(struct pending_req *req)
+{
+	unsigned long flags;
+	int was_empty;
+
+	spin_lock_irqsave(&blkbk->pending_free_lock, flags);
+	was_empty = list_empty(&blkbk->pending_free);
+	list_add(&req->free_list, &blkbk->pending_free);
+	spin_unlock_irqrestore(&blkbk->pending_free_lock, flags);
+	if (was_empty)
+		wake_up(&blkbk->pending_free_wq);
+}
+
+/*
+ * Routines for managing virtual block devices (vbds).
+ */
+static int xen_vbd_translate(struct phys_req *req, struct xen_blkif *blkif,
+			     int operation)
+{
+	struct xen_vbd *vbd = &blkif->vbd;
+	int rc = -EACCES;
+
+	if ((operation != READ) && vbd->readonly)
+		goto out;
+
+	if (unlikely((req->sector_number + req->nr_sects) > vbd_sz(vbd)))
+		goto out;
+
+	req->dev  = vbd->pdevice;
+	req->bdev = vbd->bdev;
+	rc = 0;
+
+ out:
+	return rc;
+}
+
+static void xen_vbd_resize(struct xen_blkif *blkif)
+{
+	struct xen_vbd *vbd = &blkif->vbd;
+	struct xenbus_transaction xbt;
+	int err;
+	struct xenbus_device *dev = xen_blkbk_xenbus(blkif->be);
+	unsigned long long new_size = vbd_sz(vbd);
+
+	pr_info(DRV_PFX "VBD Resize: Domid: %d, Device: (%d, %d)\n",
+		blkif->domid, MAJOR(vbd->pdevice), MINOR(vbd->pdevice));
+	pr_info(DRV_PFX "VBD Resize: new size %llu\n", new_size);
+	vbd->size = new_size;
+again:
+	err = xenbus_transaction_start(&xbt);
+	if (err) {
+		pr_warn(DRV_PFX "Error starting transaction");
+		return;
+	}
+	err = xenbus_printf(xbt, dev->nodename, "sectors", "%llu",
+			    (unsigned long long)vbd_sz(vbd));
+	if (err) {
+		pr_warn(DRV_PFX "Error writing new size");
+		goto abort;
+	}
+	/*
+	 * Write the current state; we will use this to synchronize
+	 * the front-end. If the current state is "connected" the
+	 * front-end will get the new size information online.
+	 */
+	err = xenbus_printf(xbt, dev->nodename, "state", "%d", dev->state);
+	if (err) {
+		pr_warn(DRV_PFX "Error writing the state");
+		goto abort;
+	}
+
+	err = xenbus_transaction_end(xbt, 0);
+	if (err == -EAGAIN)
+		goto again;
+	if (err)
+		pr_warn(DRV_PFX "Error ending transaction");
+abort:
+	xenbus_transaction_end(xbt, 1);
+}
+
+/*
+ * Notification from the guest OS.
+ */
+static void blkif_notify_work(struct xen_blkif *blkif)
+{
+	blkif->waiting_reqs = 1;
+	wake_up(&blkif->wq);
+}
+
+irqreturn_t xen_blkif_be_int(int irq, void *dev_id)
+{
+	blkif_notify_work(dev_id);
+	return IRQ_HANDLED;
+}
+
+/*
+ * SCHEDULER FUNCTIONS
+ */
+
+static void print_stats(struct xen_blkif *blkif)
+{
+	pr_info("xen-blkback (%s): oo %3d  |  rd %4d  |  wr %4d  |  f %4d\n",
+		 current->comm, blkif->st_oo_req,
+		 blkif->st_rd_req, blkif->st_wr_req, blkif->st_f_req);
+	blkif->st_print = jiffies + msecs_to_jiffies(10 * 1000);
+	blkif->st_rd_req = 0;
+	blkif->st_wr_req = 0;
+	blkif->st_oo_req = 0;
+}
+
+int xen_blkif_schedule(void *arg)
+{
+	struct xen_blkif *blkif = arg;
+	struct xen_vbd *vbd = &blkif->vbd;
+
+	xen_blkif_get(blkif);
+
+	while (!kthread_should_stop()) {
+		if (try_to_freeze())
+			continue;
+		if (unlikely(vbd->size != vbd_sz(vbd)))
+			xen_vbd_resize(blkif);
+
+		wait_event_interruptible(
+			blkif->wq,
+			blkif->waiting_reqs || kthread_should_stop());
+		wait_event_interruptible(
+			blkbk->pending_free_wq,
+			!list_empty(&blkbk->pending_free) ||
+			kthread_should_stop());
+
+		blkif->waiting_reqs = 0;
+		smp_mb(); /* clear flag *before* checking for work */
+
+		if (do_block_io_op(blkif))
+			blkif->waiting_reqs = 1;
+
+		if (log_stats && time_after(jiffies, blkif->st_print))
+			print_stats(blkif);
+	}
+
+	if (log_stats)
+		print_stats(blkif);
+
+	blkif->xenblkd = NULL;
+	xen_blkif_put(blkif);
+
+	return 0;
+}
+
+struct seg_buf {
+	unsigned long buf;
+	unsigned int nsec;
+};
+/*
+ * Unmap the grant references, and also remove the M2P over-rides
+ * used in the 'pending_req'.
+ */
+static void xen_blkbk_unmap(struct pending_req *req)
+{
+	struct gnttab_unmap_grant_ref unmap[BLKIF_MAX_SEGMENTS_PER_REQUEST];
+	unsigned int i, invcount = 0;
+	grant_handle_t handle;
+	int ret;
+
+	for (i = 0; i < req->nr_pages; i++) {
+		handle = pending_handle(req, i);
+		if (handle == BLKBACK_INVALID_HANDLE)
+			continue;
+		gnttab_set_unmap_op(&unmap[invcount], vaddr(req, i),
+				    GNTMAP_host_map, handle);
+		pending_handle(req, i) = BLKBACK_INVALID_HANDLE;
+		invcount++;
+	}
+
+	ret = HYPERVISOR_grant_table_op(
+		GNTTABOP_unmap_grant_ref, unmap, invcount);
+	BUG_ON(ret);
+	/*
+	 * Note, we use invcount, so nr->pages, so we can't index
+	 * using vaddr(req, i).
+	 */
+	for (i = 0; i < invcount; i++) {
+		ret = m2p_remove_override(
+			virt_to_page(unmap[i].host_addr), false);
+		if (ret) {
+			pr_alert(DRV_PFX "Failed to remove M2P override for %lx\n",
+				 (unsigned long)unmap[i].host_addr);
+			continue;
+		}
+	}
+}
+
+static int xen_blkbk_map(struct blkif_request *req,
+			 struct pending_req *pending_req,
+			 struct seg_buf seg[])
+{
+	struct gnttab_map_grant_ref map[BLKIF_MAX_SEGMENTS_PER_REQUEST];
+	int i;
+	int nseg = req->nr_segments;
+	int ret = 0;
+
+	/*
+	 * Fill out preq.nr_sects with proper amount of sectors, and setup
+	 * assign map[..] with the PFN of the page in our domain with the
+	 * corresponding grant reference for each page.
+	 */
+	for (i = 0; i < nseg; i++) {
+		uint32_t flags;
+
+		flags = GNTMAP_host_map;
+		if (pending_req->operation != BLKIF_OP_READ)
+			flags |= GNTMAP_readonly;
+		gnttab_set_map_op(&map[i], vaddr(pending_req, i), flags,
+				  req->u.rw.seg[i].gref,
+				  pending_req->blkif->domid);
+	}
+
+	ret = HYPERVISOR_grant_table_op(GNTTABOP_map_grant_ref, map, nseg);
+	BUG_ON(ret);
+
+	/*
+	 * Now swizzle the MFN in our domain with the MFN from the other domain
+	 * so that when we access vaddr(pending_req,i) it has the contents of
+	 * the page from the other domain.
+	 */
+	for (i = 0; i < nseg; i++) {
+		if (unlikely(map[i].status != 0)) {
+			pr_debug(DRV_PFX "invalid buffer -- could not remap it\n");
+			map[i].handle = BLKBACK_INVALID_HANDLE;
+			ret |= 1;
+		}
+
+		pending_handle(pending_req, i) = map[i].handle;
+
+		if (ret)
+			continue;
+
+		ret = m2p_add_override(PFN_DOWN(map[i].dev_bus_addr),
+			blkbk->pending_page(pending_req, i), false);
+		if (ret) {
+			pr_alert(DRV_PFX "Failed to install M2P override for %lx (ret: %d)\n",
+				 (unsigned long)map[i].dev_bus_addr, ret);
+			/* We could switch over to GNTTABOP_copy */
+			continue;
+		}
+
+		seg[i].buf  = map[i].dev_bus_addr |
+			(req->u.rw.seg[i].first_sect << 9);
+	}
+	return ret;
+}
+
+/*
+ * Completion callback on the bio's. Called as bh->b_end_io()
+ */
+
+static void __end_block_io_op(struct pending_req *pending_req, int error)
+{
+	/* An error fails the entire request. */
+	if ((pending_req->operation == BLKIF_OP_FLUSH_DISKCACHE) &&
+	    (error == -EOPNOTSUPP)) {
+		pr_debug(DRV_PFX "flush diskcache op failed, not supported\n");
+		xen_blkbk_flush_diskcache(XBT_NIL, pending_req->blkif->be, 0);
+		pending_req->status = BLKIF_RSP_EOPNOTSUPP;
+	} else if (error) {
+		pr_debug(DRV_PFX "Buffer not up-to-date at end of operation,"
+			 " error=%d\n", error);
+		pending_req->status = BLKIF_RSP_ERROR;
+	}
+
+	/*
+	 * If all of the bio's have completed it is time to unmap
+	 * the grant references associated with 'request' and provide
+	 * the proper response on the ring.
+	 */
+	if (atomic_dec_and_test(&pending_req->pendcnt)) {
+		xen_blkbk_unmap(pending_req);
+		make_response(pending_req->blkif, pending_req->id,
+			      pending_req->operation, pending_req->status);
+		xen_blkif_put(pending_req->blkif);
+		free_req(pending_req);
+	}
+}
+
+/*
+ * bio callback.
+ */
+static void end_block_io_op(struct bio *bio, int error)
+{
+	__end_block_io_op(bio->bi_private, error);
+	bio_put(bio);
+}
+
+
+
+/*
+ * Function to copy the from the ring buffer the 'struct blkif_request'
+ * (which has the sectors we want, number of them, grant references, etc),
+ * and transmute  it to the block API to hand it over to the proper block disk.
+ */
+static int do_block_io_op(struct xen_blkif *blkif)
+{
+	union blkif_back_rings *blk_rings = &blkif->blk_rings;
+	struct blkif_request req;
+	struct pending_req *pending_req;
+	RING_IDX rc, rp;
+	int more_to_do = 0;
+
+	rc = blk_rings->common.req_cons;
+	rp = blk_rings->common.sring->req_prod;
+	rmb(); /* Ensure we see queued requests up to 'rp'. */
+
+	while (rc != rp) {
+
+		if (RING_REQUEST_CONS_OVERFLOW(&blk_rings->common, rc))
+			break;
+
+		if (kthread_should_stop()) {
+			more_to_do = 1;
+			break;
+		}
+
+		pending_req = alloc_req();
+		if (NULL == pending_req) {
+			blkif->st_oo_req++;
+			more_to_do = 1;
+			break;
+		}
+
+		switch (blkif->blk_protocol) {
+		case BLKIF_PROTOCOL_NATIVE:
+			memcpy(&req, RING_GET_REQUEST(&blk_rings->native, rc), sizeof(req));
+			break;
+		case BLKIF_PROTOCOL_X86_32:
+			blkif_get_x86_32_req(&req, RING_GET_REQUEST(&blk_rings->x86_32, rc));
+			break;
+		case BLKIF_PROTOCOL_X86_64:
+			blkif_get_x86_64_req(&req, RING_GET_REQUEST(&blk_rings->x86_64, rc));
+			break;
+		default:
+			BUG();
+		}
+		blk_rings->common.req_cons = ++rc; /* before make_response() */
+
+		/* Apply all sanity checks to /private copy/ of request. */
+		barrier();
+
+		if (dispatch_rw_block_io(blkif, &req, pending_req))
+			break;
+
+		/* Yield point for this unbounded loop. */
+		cond_resched();
+	}
+
+	return more_to_do;
+}
+
+/*
+ * Transmutation of the 'struct blkif_request' to a proper 'struct bio'
+ * and call the 'submit_bio' to pass it to the underlying storage.
+ */
+static int dispatch_rw_block_io(struct xen_blkif *blkif,
+				struct blkif_request *req,
+				struct pending_req *pending_req)
+{
+	struct phys_req preq;
+	struct seg_buf seg[BLKIF_MAX_SEGMENTS_PER_REQUEST];
+	unsigned int nseg;
+	struct bio *bio = NULL;
+	struct bio *biolist[BLKIF_MAX_SEGMENTS_PER_REQUEST];
+	int i, nbio = 0;
+	int operation;
+	struct blk_plug plug;
+
+	switch (req->operation) {
+	case BLKIF_OP_READ:
+		blkif->st_rd_req++;
+		operation = READ;
+		break;
+	case BLKIF_OP_WRITE:
+		blkif->st_wr_req++;
+		operation = WRITE_ODIRECT;
+		break;
+	case BLKIF_OP_FLUSH_DISKCACHE:
+		blkif->st_f_req++;
+		operation = WRITE_FLUSH;
+		/*
+		 * The frontend likes to set this to -1, which xen_vbd_translate
+		 * is alergic too.
+		 */
+		req->u.rw.sector_number = 0;
+		break;
+	case BLKIF_OP_WRITE_BARRIER:
+	default:
+		operation = 0; /* make gcc happy */
+		goto fail_response;
+		break;
+	}
+
+	/* Check that the number of segments is sane. */
+	nseg = req->nr_segments;
+	if (unlikely(nseg == 0 && operation != WRITE_FLUSH) ||
+	    unlikely(nseg > BLKIF_MAX_SEGMENTS_PER_REQUEST)) {
+		pr_debug(DRV_PFX "Bad number of segments in request (%d)\n",
+			 nseg);
+		/* Haven't submitted any bio's yet. */
+		goto fail_response;
+	}
+
+	preq.dev           = req->handle;
+	preq.sector_number = req->u.rw.sector_number;
+	preq.nr_sects      = 0;
+
+	pending_req->blkif     = blkif;
+	pending_req->id        = req->id;
+	pending_req->operation = req->operation;
+	pending_req->status    = BLKIF_RSP_OKAY;
+	pending_req->nr_pages  = nseg;
+
+	for (i = 0; i < nseg; i++) {
+		seg[i].nsec = req->u.rw.seg[i].last_sect -
+			req->u.rw.seg[i].first_sect + 1;
+		if ((req->u.rw.seg[i].last_sect >= (PAGE_SIZE >> 9)) ||
+		    (req->u.rw.seg[i].last_sect < req->u.rw.seg[i].first_sect))
+			goto fail_response;
+		preq.nr_sects += seg[i].nsec;
+
+	}
+
+	if (xen_vbd_translate(&preq, blkif, operation) != 0) {
+		pr_debug(DRV_PFX "access denied: %s of [%llu,%llu] on dev=%04x\n",
+			 operation == READ ? "read" : "write",
+			 preq.sector_number,
+			 preq.sector_number + preq.nr_sects, preq.dev);
+		goto fail_response;
+	}
+
+	/*
+	 * This check _MUST_ be done after xen_vbd_translate as the preq.bdev
+	 * is set there.
+	 */
+	for (i = 0; i < nseg; i++) {
+		if (((int)preq.sector_number|(int)seg[i].nsec) &
+		    ((bdev_logical_block_size(preq.bdev) >> 9) - 1)) {
+			pr_debug(DRV_PFX "Misaligned I/O request from domain %d",
+				 blkif->domid);
+			goto fail_response;
+		}
+	}
+
+	/*
+	 * If we have failed at this point, we need to undo the M2P override,
+	 * set gnttab_set_unmap_op on all of the grant references and perform
+	 * the hypercall to unmap the grants - that is all done in
+	 * xen_blkbk_unmap.
+	 */
+	if (xen_blkbk_map(req, pending_req, seg))
+		goto fail_flush;
+
+	/* This corresponding xen_blkif_put is done in __end_block_io_op */
+	xen_blkif_get(blkif);
+
+	for (i = 0; i < nseg; i++) {
+		while ((bio == NULL) ||
+		       (bio_add_page(bio,
+				     blkbk->pending_page(pending_req, i),
+				     seg[i].nsec << 9,
+				     seg[i].buf & ~PAGE_MASK) == 0)) {
+
+			bio = bio_alloc(GFP_KERNEL, nseg-i);
+			if (unlikely(bio == NULL))
+				goto fail_put_bio;
+
+			biolist[nbio++] = bio;
+			bio->bi_bdev    = preq.bdev;
+			bio->bi_private = pending_req;
+			bio->bi_end_io  = end_block_io_op;
+			bio->bi_sector  = preq.sector_number;
+		}
+
+		preq.sector_number += seg[i].nsec;
+	}
+
+	/* This will be hit if the operation was a flush. */
+	if (!bio) {
+		BUG_ON(operation != WRITE_FLUSH);
+
+		bio = bio_alloc(GFP_KERNEL, 0);
+		if (unlikely(bio == NULL))
+			goto fail_put_bio;
+
+		biolist[nbio++] = bio;
+		bio->bi_bdev    = preq.bdev;
+		bio->bi_private = pending_req;
+		bio->bi_end_io  = end_block_io_op;
+	}
+
+	/*
+	 * We set it one so that the last submit_bio does not have to call
+	 * atomic_inc.
+	 */
+	atomic_set(&pending_req->pendcnt, nbio);
+
+	/* Get a reference count for the disk queue and start sending I/O */
+	blk_start_plug(&plug);
+
+	for (i = 0; i < nbio; i++)
+		submit_bio(operation, biolist[i]);
+
+	/* Let the I/Os go.. */
+	blk_finish_plug(&plug);
+
+	if (operation == READ)
+		blkif->st_rd_sect += preq.nr_sects;
+	else if (operation == WRITE || operation == WRITE_FLUSH)
+		blkif->st_wr_sect += preq.nr_sects;
+
+	return 0;
+
+ fail_flush:
+	xen_blkbk_unmap(pending_req);
+ fail_response:
+	/* Haven't submitted any bio's yet. */
+	make_response(blkif, req->id, req->operation, BLKIF_RSP_ERROR);
+	free_req(pending_req);
+	msleep(1); /* back off a bit */
+	return -EIO;
+
+ fail_put_bio:
+	for (i = 0; i < nbio; i++)
+		bio_put(biolist[i]);
+	__end_block_io_op(pending_req, -EINVAL);
+	msleep(1); /* back off a bit */
+	return -EIO;
+}
+
+
+
+/*
+ * Put a response on the ring on how the operation fared.
+ */
+static void make_response(struct xen_blkif *blkif, u64 id,
+			  unsigned short op, int st)
+{
+	struct blkif_response  resp;
+	unsigned long     flags;
+	union blkif_back_rings *blk_rings = &blkif->blk_rings;
+	int more_to_do = 0;
+	int notify;
+
+	resp.id        = id;
+	resp.operation = op;
+	resp.status    = st;
+
+	spin_lock_irqsave(&blkif->blk_ring_lock, flags);
+	/* Place on the response ring for the relevant domain. */
+	switch (blkif->blk_protocol) {
+	case BLKIF_PROTOCOL_NATIVE:
+		memcpy(RING_GET_RESPONSE(&blk_rings->native, blk_rings->native.rsp_prod_pvt),
+		       &resp, sizeof(resp));
+		break;
+	case BLKIF_PROTOCOL_X86_32:
+		memcpy(RING_GET_RESPONSE(&blk_rings->x86_32, blk_rings->x86_32.rsp_prod_pvt),
+		       &resp, sizeof(resp));
+		break;
+	case BLKIF_PROTOCOL_X86_64:
+		memcpy(RING_GET_RESPONSE(&blk_rings->x86_64, blk_rings->x86_64.rsp_prod_pvt),
+		       &resp, sizeof(resp));
+		break;
+	default:
+		BUG();
+	}
+	blk_rings->common.rsp_prod_pvt++;
+	RING_PUSH_RESPONSES_AND_CHECK_NOTIFY(&blk_rings->common, notify);
+	if (blk_rings->common.rsp_prod_pvt == blk_rings->common.req_cons) {
+		/*
+		 * Tail check for pending requests. Allows frontend to avoid
+		 * notifications if requests are already in flight (lower
+		 * overheads and promotes batching).
+		 */
+		RING_FINAL_CHECK_FOR_REQUESTS(&blk_rings->common, more_to_do);
+
+	} else if (RING_HAS_UNCONSUMED_REQUESTS(&blk_rings->common)) {
+		more_to_do = 1;
+	}
+
+	spin_unlock_irqrestore(&blkif->blk_ring_lock, flags);
+
+	if (more_to_do)
+		blkif_notify_work(blkif);
+	if (notify)
+		notify_remote_via_irq(blkif->irq);
+}
+
+static int __init xen_blkif_init(void)
+{
+	int i, mmap_pages;
+	int rc = 0;
+
+	if (!xen_pv_domain())
+		return -ENODEV;
+
+	blkbk = kzalloc(sizeof(struct xen_blkbk), GFP_KERNEL);
+	if (!blkbk) {
+		pr_alert(DRV_PFX "%s: out of memory!\n", __func__);
+		return -ENOMEM;
+	}
+
+	mmap_pages = xen_blkif_reqs * BLKIF_MAX_SEGMENTS_PER_REQUEST;
+
+	blkbk->pending_reqs          = kmalloc(sizeof(blkbk->pending_reqs[0]) *
+					xen_blkif_reqs, GFP_KERNEL);
+	blkbk->pending_grant_handles = kzalloc(sizeof(blkbk->pending_grant_handles[0]) *
+					mmap_pages, GFP_KERNEL);
+	blkbk->pending_pages         = kzalloc(sizeof(blkbk->pending_pages[0]) *
+					mmap_pages, GFP_KERNEL);
+
+	if (!blkbk->pending_reqs || !blkbk->pending_grant_handles ||
+	    !blkbk->pending_pages) {
+		rc = -ENOMEM;
+		goto out_of_memory;
+	}
+
+	for (i = 0; i < mmap_pages; i++) {
+		blkbk->pending_grant_handles[i] = BLKBACK_INVALID_HANDLE;
+		blkbk->pending_pages[i] = alloc_page(GFP_KERNEL);
+		if (blkbk->pending_pages[i] == NULL) {
+			rc = -ENOMEM;
+			goto out_of_memory;
+		}
+	}
+	rc = xen_blkif_interface_init();
+	if (rc)
+		goto failed_init;
+
+	memset(blkbk->pending_reqs, 0, sizeof(blkbk->pending_reqs));
+
+	INIT_LIST_HEAD(&blkbk->pending_free);
+	spin_lock_init(&blkbk->pending_free_lock);
+	init_waitqueue_head(&blkbk->pending_free_wq);
+
+	for (i = 0; i < xen_blkif_reqs; i++)
+		list_add_tail(&blkbk->pending_reqs[i].free_list,
+			      &blkbk->pending_free);
+
+	rc = xen_blkif_xenbus_init();
+	if (rc)
+		goto failed_init;
+
+	return 0;
+
+ out_of_memory:
+	pr_alert(DRV_PFX "%s: out of memory\n", __func__);
+ failed_init:
+	kfree(blkbk->pending_reqs);
+	kfree(blkbk->pending_grant_handles);
+	for (i = 0; i < mmap_pages; i++) {
+		if (blkbk->pending_pages[i])
+			__free_page(blkbk->pending_pages[i]);
+	}
+	kfree(blkbk->pending_pages);
+	kfree(blkbk);
+	blkbk = NULL;
+	return rc;
+}
+
+module_init(xen_blkif_init);
+
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/block/xen-blkback/common.h b/drivers/block/xen-blkback/common.h
new file mode 100644
index 0000000..9e40b28
--- /dev/null
+++ b/drivers/block/xen-blkback/common.h
@@ -0,0 +1,233 @@
+/*
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License version 2
+ * as published by the Free Software Foundation; or, when distributed
+ * separately from the Linux kernel or incorporated into other
+ * software packages, subject to the following license:
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a copy
+ * of this source file (the "Software"), to deal in the Software without
+ * restriction, including without limitation the rights to use, copy, modify,
+ * merge, publish, distribute, sublicense, and/or sell copies of the Software,
+ * and to permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
+ * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
+ * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
+ * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
+ * IN THE SOFTWARE.
+ */
+
+#ifndef __XEN_BLKIF__BACKEND__COMMON_H__
+#define __XEN_BLKIF__BACKEND__COMMON_H__
+
+#include <linux/version.h>
+#include <linux/module.h>
+#include <linux/interrupt.h>
+#include <linux/slab.h>
+#include <linux/blkdev.h>
+#include <linux/vmalloc.h>
+#include <linux/wait.h>
+#include <linux/io.h>
+#include <asm/setup.h>
+#include <asm/pgalloc.h>
+#include <asm/hypervisor.h>
+#include <xen/grant_table.h>
+#include <xen/xenbus.h>
+#include <xen/interface/io/ring.h>
+#include <xen/interface/io/blkif.h>
+#include <xen/interface/io/protocols.h>
+
+#define DRV_PFX "xen-blkback:"
+#define DPRINTK(fmt, args...)				\
+	pr_debug(DRV_PFX "(%s:%d) " fmt ".\n",	\
+		 __func__, __LINE__, ##args)
+
+
+/* Not a real protocol.  Used to generate ring structs which contain
+ * the elements common to all protocols only.  This way we get a
+ * compiler-checkable way to use common struct elements, so we can
+ * avoid using switch(protocol) in a number of places.  */
+struct blkif_common_request {
+	char dummy;
+};
+struct blkif_common_response {
+	char dummy;
+};
+
+/* i386 protocol version */
+#pragma pack(push, 4)
+struct blkif_x86_32_request {
+	uint8_t        operation;    /* BLKIF_OP_???                         */
+	uint8_t        nr_segments;  /* number of segments                   */
+	blkif_vdev_t   handle;       /* only for read/write requests         */
+	uint64_t       id;           /* private guest value, echoed in resp  */
+	blkif_sector_t sector_number;/* start sector idx on disk (r/w only)  */
+	struct blkif_request_segment seg[BLKIF_MAX_SEGMENTS_PER_REQUEST];
+};
+struct blkif_x86_32_response {
+	uint64_t        id;              /* copied from request */
+	uint8_t         operation;       /* copied from request */
+	int16_t         status;          /* BLKIF_RSP_???       */
+};
+#pragma pack(pop)
+
+/* x86_64 protocol version */
+struct blkif_x86_64_request {
+	uint8_t        operation;    /* BLKIF_OP_???                         */
+	uint8_t        nr_segments;  /* number of segments                   */
+	blkif_vdev_t   handle;       /* only for read/write requests         */
+	uint64_t       __attribute__((__aligned__(8))) id;
+	blkif_sector_t sector_number;/* start sector idx on disk (r/w only)  */
+	struct blkif_request_segment seg[BLKIF_MAX_SEGMENTS_PER_REQUEST];
+};
+struct blkif_x86_64_response {
+	uint64_t       __attribute__((__aligned__(8))) id;
+	uint8_t         operation;       /* copied from request */
+	int16_t         status;          /* BLKIF_RSP_???       */
+};
+
+DEFINE_RING_TYPES(blkif_common, struct blkif_common_request,
+		  struct blkif_common_response);
+DEFINE_RING_TYPES(blkif_x86_32, struct blkif_x86_32_request,
+		  struct blkif_x86_32_response);
+DEFINE_RING_TYPES(blkif_x86_64, struct blkif_x86_64_request,
+		  struct blkif_x86_64_response);
+
+union blkif_back_rings {
+	struct blkif_back_ring        native;
+	struct blkif_common_back_ring common;
+	struct blkif_x86_32_back_ring x86_32;
+	struct blkif_x86_64_back_ring x86_64;
+};
+
+enum blkif_protocol {
+	BLKIF_PROTOCOL_NATIVE = 1,
+	BLKIF_PROTOCOL_X86_32 = 2,
+	BLKIF_PROTOCOL_X86_64 = 3,
+};
+
+struct xen_vbd {
+	/* What the domain refers to this vbd as. */
+	blkif_vdev_t		handle;
+	/* Non-zero -> read-only */
+	unsigned char		readonly;
+	/* VDISK_xxx */
+	unsigned char		type;
+	/* phys device that this vbd maps to. */
+	u32			pdevice;
+	struct block_device	*bdev;
+	/* Cached size parameter. */
+	sector_t		size;
+	bool			flush_support;
+};
+
+struct backend_info;
+
+struct xen_blkif {
+	/* Unique identifier for this interface. */
+	domid_t			domid;
+	unsigned int		handle;
+	/* Physical parameters of the comms window. */
+	unsigned int		irq;
+	/* Comms information. */
+	enum blkif_protocol	blk_protocol;
+	union blkif_back_rings	blk_rings;
+	struct vm_struct	*blk_ring_area;
+	/* The VBD attached to this interface. */
+	struct xen_vbd		vbd;
+	/* Back pointer to the backend_info. */
+	struct backend_info	*be;
+	/* Private fields. */
+	spinlock_t		blk_ring_lock;
+	atomic_t		refcnt;
+
+	wait_queue_head_t	wq;
+	/* One thread per one blkif. */
+	struct task_struct	*xenblkd;
+	unsigned int		waiting_reqs;
+
+	/* statistics */
+	unsigned long		st_print;
+	int			st_rd_req;
+	int			st_wr_req;
+	int			st_oo_req;
+	int			st_f_req;
+	int			st_rd_sect;
+	int			st_wr_sect;
+
+	wait_queue_head_t	waiting_to_free;
+
+	grant_handle_t		shmem_handle;
+	grant_ref_t		shmem_ref;
+};
+
+
+#define vbd_sz(_v)	((_v)->bdev->bd_part ? \
+			 (_v)->bdev->bd_part->nr_sects : \
+			  get_capacity((_v)->bdev->bd_disk))
+
+#define xen_blkif_get(_b) (atomic_inc(&(_b)->refcnt))
+#define xen_blkif_put(_b)				\
+	do {						\
+		if (atomic_dec_and_test(&(_b)->refcnt))	\
+			wake_up(&(_b)->waiting_to_free);\
+	} while (0)
+
+struct phys_req {
+	unsigned short		dev;
+	unsigned short		nr_sects;
+	struct block_device	*bdev;
+	blkif_sector_t		sector_number;
+};
+int xen_blkif_interface_init(void);
+
+int xen_blkif_xenbus_init(void);
+
+irqreturn_t xen_blkif_be_int(int irq, void *dev_id);
+int xen_blkif_schedule(void *arg);
+
+int xen_blkbk_flush_diskcache(struct xenbus_transaction xbt,
+			      struct backend_info *be, int state);
+
+struct xenbus_device *xen_blkbk_xenbus(struct backend_info *be);
+
+static inline void blkif_get_x86_32_req(struct blkif_request *dst,
+					struct blkif_x86_32_request *src)
+{
+	int i, n = BLKIF_MAX_SEGMENTS_PER_REQUEST;
+	dst->operation = src->operation;
+	dst->nr_segments = src->nr_segments;
+	dst->handle = src->handle;
+	dst->id = src->id;
+	dst->u.rw.sector_number = src->sector_number;
+	barrier();
+	if (n > dst->nr_segments)
+		n = dst->nr_segments;
+	for (i = 0; i < n; i++)
+		dst->u.rw.seg[i] = src->seg[i];
+}
+
+static inline void blkif_get_x86_64_req(struct blkif_request *dst,
+					struct blkif_x86_64_request *src)
+{
+	int i, n = BLKIF_MAX_SEGMENTS_PER_REQUEST;
+	dst->operation = src->operation;
+	dst->nr_segments = src->nr_segments;
+	dst->handle = src->handle;
+	dst->id = src->id;
+	dst->u.rw.sector_number = src->sector_number;
+	barrier();
+	if (n > dst->nr_segments)
+		n = dst->nr_segments;
+	for (i = 0; i < n; i++)
+		dst->u.rw.seg[i] = src->seg[i];
+}
+
+#endif /* __XEN_BLKIF__BACKEND__COMMON_H__ */
diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
new file mode 100644
index 0000000..3457082
--- /dev/null
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -0,0 +1,768 @@
+/*  Xenbus code for blkif backend
+    Copyright (C) 2005 Rusty Russell <rusty@rustcorp.com.au>
+    Copyright (C) 2005 XenSource Ltd
+
+    This program is free software; you can redistribute it and/or modify
+    it under the terms of the GNU General Public License as published by
+    the Free Software Foundation; either version 2 of the License, or
+    (at your option) any later version.
+
+    This program is distributed in the hope that it will be useful,
+    but WITHOUT ANY WARRANTY; without even the implied warranty of
+    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+    GNU General Public License for more details.
+
+*/
+
+#include <stdarg.h>
+#include <linux/module.h>
+#include <linux/kthread.h>
+#include <xen/events.h>
+#include <xen/grant_table.h>
+#include "common.h"
+
+struct backend_info {
+	struct xenbus_device	*dev;
+	struct xen_blkif	*blkif;
+	struct xenbus_watch	backend_watch;
+	unsigned		major;
+	unsigned		minor;
+	char			*mode;
+};
+
+static struct kmem_cache *xen_blkif_cachep;
+static void connect(struct backend_info *);
+static int connect_ring(struct backend_info *);
+static void backend_changed(struct xenbus_watch *, const char **,
+			    unsigned int);
+
+struct xenbus_device *xen_blkbk_xenbus(struct backend_info *be)
+{
+	return be->dev;
+}
+
+static int blkback_name(struct xen_blkif *blkif, char *buf)
+{
+	char *devpath, *devname;
+	struct xenbus_device *dev = blkif->be->dev;
+
+	devpath = xenbus_read(XBT_NIL, dev->nodename, "dev", NULL);
+	if (IS_ERR(devpath))
+		return PTR_ERR(devpath);
+
+	devname = strstr(devpath, "/dev/");
+	if (devname != NULL)
+		devname += strlen("/dev/");
+	else
+		devname  = devpath;
+
+	snprintf(buf, TASK_COMM_LEN, "blkback.%d.%s", blkif->domid, devname);
+	kfree(devpath);
+
+	return 0;
+}
+
+static void xen_update_blkif_status(struct xen_blkif *blkif)
+{
+	int err;
+	char name[TASK_COMM_LEN];
+
+	/* Not ready to connect? */
+	if (!blkif->irq || !blkif->vbd.bdev)
+		return;
+
+	/* Already connected? */
+	if (blkif->be->dev->state == XenbusStateConnected)
+		return;
+
+	/* Attempt to connect: exit if we fail to. */
+	connect(blkif->be);
+	if (blkif->be->dev->state != XenbusStateConnected)
+		return;
+
+	err = blkback_name(blkif, name);
+	if (err) {
+		xenbus_dev_error(blkif->be->dev, err, "get blkback dev name");
+		return;
+	}
+
+	err = filemap_write_and_wait(blkif->vbd.bdev->bd_inode->i_mapping);
+	if (err) {
+		xenbus_dev_error(blkif->be->dev, err, "block flush");
+		return;
+	}
+	invalidate_inode_pages2(blkif->vbd.bdev->bd_inode->i_mapping);
+
+	blkif->xenblkd = kthread_run(xen_blkif_schedule, blkif, name);
+	if (IS_ERR(blkif->xenblkd)) {
+		err = PTR_ERR(blkif->xenblkd);
+		blkif->xenblkd = NULL;
+		xenbus_dev_error(blkif->be->dev, err, "start xenblkd");
+	}
+}
+
+static struct xen_blkif *xen_blkif_alloc(domid_t domid)
+{
+	struct xen_blkif *blkif;
+
+	blkif = kmem_cache_alloc(xen_blkif_cachep, GFP_KERNEL);
+	if (!blkif)
+		return ERR_PTR(-ENOMEM);
+
+	memset(blkif, 0, sizeof(*blkif));
+	blkif->domid = domid;
+	spin_lock_init(&blkif->blk_ring_lock);
+	atomic_set(&blkif->refcnt, 1);
+	init_waitqueue_head(&blkif->wq);
+	blkif->st_print = jiffies;
+	init_waitqueue_head(&blkif->waiting_to_free);
+
+	return blkif;
+}
+
+static int map_frontend_page(struct xen_blkif *blkif, unsigned long shared_page)
+{
+	struct gnttab_map_grant_ref op;
+
+	gnttab_set_map_op(&op, (unsigned long)blkif->blk_ring_area->addr,
+			  GNTMAP_host_map, shared_page, blkif->domid);
+
+	if (HYPERVISOR_grant_table_op(GNTTABOP_map_grant_ref, &op, 1))
+		BUG();
+
+	if (op.status) {
+		DPRINTK("Grant table operation failure !\n");
+		return op.status;
+	}
+
+	blkif->shmem_ref = shared_page;
+	blkif->shmem_handle = op.handle;
+
+	return 0;
+}
+
+static void unmap_frontend_page(struct xen_blkif *blkif)
+{
+	struct gnttab_unmap_grant_ref op;
+
+	gnttab_set_unmap_op(&op, (unsigned long)blkif->blk_ring_area->addr,
+			    GNTMAP_host_map, blkif->shmem_handle);
+
+	if (HYPERVISOR_grant_table_op(GNTTABOP_unmap_grant_ref, &op, 1))
+		BUG();
+}
+
+static int xen_blkif_map(struct xen_blkif *blkif, unsigned long shared_page,
+			 unsigned int evtchn)
+{
+	int err;
+
+	/* Already connected through? */
+	if (blkif->irq)
+		return 0;
+
+	blkif->blk_ring_area = alloc_vm_area(PAGE_SIZE);
+	if (!blkif->blk_ring_area)
+		return -ENOMEM;
+
+	err = map_frontend_page(blkif, shared_page);
+	if (err) {
+		free_vm_area(blkif->blk_ring_area);
+		return err;
+	}
+
+	switch (blkif->blk_protocol) {
+	case BLKIF_PROTOCOL_NATIVE:
+	{
+		struct blkif_sring *sring;
+		sring = (struct blkif_sring *)blkif->blk_ring_area->addr;
+		BACK_RING_INIT(&blkif->blk_rings.native, sring, PAGE_SIZE);
+		break;
+	}
+	case BLKIF_PROTOCOL_X86_32:
+	{
+		struct blkif_x86_32_sring *sring_x86_32;
+		sring_x86_32 = (struct blkif_x86_32_sring *)blkif->blk_ring_area->addr;
+		BACK_RING_INIT(&blkif->blk_rings.x86_32, sring_x86_32, PAGE_SIZE);
+		break;
+	}
+	case BLKIF_PROTOCOL_X86_64:
+	{
+		struct blkif_x86_64_sring *sring_x86_64;
+		sring_x86_64 = (struct blkif_x86_64_sring *)blkif->blk_ring_area->addr;
+		BACK_RING_INIT(&blkif->blk_rings.x86_64, sring_x86_64, PAGE_SIZE);
+		break;
+	}
+	default:
+		BUG();
+	}
+
+	err = bind_interdomain_evtchn_to_irqhandler(blkif->domid, evtchn,
+						    xen_blkif_be_int, 0,
+						    "blkif-backend", blkif);
+	if (err < 0) {
+		unmap_frontend_page(blkif);
+		free_vm_area(blkif->blk_ring_area);
+		blkif->blk_rings.common.sring = NULL;
+		return err;
+	}
+	blkif->irq = err;
+
+	return 0;
+}
+
+static void xen_blkif_disconnect(struct xen_blkif *blkif)
+{
+	if (blkif->xenblkd) {
+		kthread_stop(blkif->xenblkd);
+		blkif->xenblkd = NULL;
+	}
+
+	atomic_dec(&blkif->refcnt);
+	wait_event(blkif->waiting_to_free, atomic_read(&blkif->refcnt) == 0);
+	atomic_inc(&blkif->refcnt);
+
+	if (blkif->irq) {
+		unbind_from_irqhandler(blkif->irq, blkif);
+		blkif->irq = 0;
+	}
+
+	if (blkif->blk_rings.common.sring) {
+		unmap_frontend_page(blkif);
+		free_vm_area(blkif->blk_ring_area);
+		blkif->blk_rings.common.sring = NULL;
+	}
+}
+
+void xen_blkif_free(struct xen_blkif *blkif)
+{
+	if (!atomic_dec_and_test(&blkif->refcnt))
+		BUG();
+	kmem_cache_free(xen_blkif_cachep, blkif);
+}
+
+int __init xen_blkif_interface_init(void)
+{
+	xen_blkif_cachep = kmem_cache_create("blkif_cache",
+					     sizeof(struct xen_blkif),
+					     0, 0, NULL);
+	if (!xen_blkif_cachep)
+		return -ENOMEM;
+
+	return 0;
+}
+
+/*
+ *  sysfs interface for VBD I/O requests
+ */
+
+#define VBD_SHOW(name, format, args...)					\
+	static ssize_t show_##name(struct device *_dev,			\
+				   struct device_attribute *attr,	\
+				   char *buf)				\
+	{								\
+		struct xenbus_device *dev = to_xenbus_device(_dev);	\
+		struct backend_info *be = dev_get_drvdata(&dev->dev);	\
+									\
+		return sprintf(buf, format, ##args);			\
+	}								\
+	static DEVICE_ATTR(name, S_IRUGO, show_##name, NULL)
+
+VBD_SHOW(oo_req,  "%d\n", be->blkif->st_oo_req);
+VBD_SHOW(rd_req,  "%d\n", be->blkif->st_rd_req);
+VBD_SHOW(wr_req,  "%d\n", be->blkif->st_wr_req);
+VBD_SHOW(f_req,  "%d\n", be->blkif->st_f_req);
+VBD_SHOW(rd_sect, "%d\n", be->blkif->st_rd_sect);
+VBD_SHOW(wr_sect, "%d\n", be->blkif->st_wr_sect);
+
+static struct attribute *xen_vbdstat_attrs[] = {
+	&dev_attr_oo_req.attr,
+	&dev_attr_rd_req.attr,
+	&dev_attr_wr_req.attr,
+	&dev_attr_f_req.attr,
+	&dev_attr_rd_sect.attr,
+	&dev_attr_wr_sect.attr,
+	NULL
+};
+
+static struct attribute_group xen_vbdstat_group = {
+	.name = "statistics",
+	.attrs = xen_vbdstat_attrs,
+};
+
+VBD_SHOW(physical_device, "%x:%x\n", be->major, be->minor);
+VBD_SHOW(mode, "%s\n", be->mode);
+
+int xenvbd_sysfs_addif(struct xenbus_device *dev)
+{
+	int error;
+
+	error = device_create_file(&dev->dev, &dev_attr_physical_device);
+	if (error)
+		goto fail1;
+
+	error = device_create_file(&dev->dev, &dev_attr_mode);
+	if (error)
+		goto fail2;
+
+	error = sysfs_create_group(&dev->dev.kobj, &xen_vbdstat_group);
+	if (error)
+		goto fail3;
+
+	return 0;
+
+fail3:	sysfs_remove_group(&dev->dev.kobj, &xen_vbdstat_group);
+fail2:	device_remove_file(&dev->dev, &dev_attr_mode);
+fail1:	device_remove_file(&dev->dev, &dev_attr_physical_device);
+	return error;
+}
+
+void xenvbd_sysfs_delif(struct xenbus_device *dev)
+{
+	sysfs_remove_group(&dev->dev.kobj, &xen_vbdstat_group);
+	device_remove_file(&dev->dev, &dev_attr_mode);
+	device_remove_file(&dev->dev, &dev_attr_physical_device);
+}
+
+
+static void xen_vbd_free(struct xen_vbd *vbd)
+{
+	if (vbd->bdev)
+		blkdev_put(vbd->bdev, vbd->readonly ? FMODE_READ : FMODE_WRITE);
+	vbd->bdev = NULL;
+}
+
+static int xen_vbd_create(struct xen_blkif *blkif, blkif_vdev_t handle,
+			  unsigned major, unsigned minor, int readonly,
+			  int cdrom)
+{
+	struct xen_vbd *vbd;
+	struct block_device *bdev;
+	struct request_queue *q;
+
+	vbd = &blkif->vbd;
+	vbd->handle   = handle;
+	vbd->readonly = readonly;
+	vbd->type     = 0;
+
+	vbd->pdevice  = MKDEV(major, minor);
+
+	bdev = blkdev_get_by_dev(vbd->pdevice, vbd->readonly ?
+				 FMODE_READ : FMODE_WRITE, NULL);
+
+	if (IS_ERR(bdev)) {
+		DPRINTK("xen_vbd_create: device %08x could not be opened.\n",
+			vbd->pdevice);
+		return -ENOENT;
+	}
+
+	vbd->bdev = bdev;
+	vbd->size = vbd_sz(vbd);
+
+	if (vbd->bdev->bd_disk == NULL) {
+		DPRINTK("xen_vbd_create: device %08x doesn't exist.\n",
+			vbd->pdevice);
+		xen_vbd_free(vbd);
+		return -ENOENT;
+	}
+
+	if (vbd->bdev->bd_disk->flags & GENHD_FL_CD || cdrom)
+		vbd->type |= VDISK_CDROM;
+	if (vbd->bdev->bd_disk->flags & GENHD_FL_REMOVABLE)
+		vbd->type |= VDISK_REMOVABLE;
+
+	q = bdev_get_queue(bdev);
+	if (q && q->flush_flags)
+		vbd->flush_support = true;
+
+	DPRINTK("Successful creation of handle=%04x (dom=%u)\n",
+		handle, blkif->domid);
+	return 0;
+}
+static int xen_blkbk_remove(struct xenbus_device *dev)
+{
+	struct backend_info *be = dev_get_drvdata(&dev->dev);
+
+	DPRINTK("");
+
+	if (be->major || be->minor)
+		xenvbd_sysfs_delif(dev);
+
+	if (be->backend_watch.node) {
+		unregister_xenbus_watch(&be->backend_watch);
+		kfree(be->backend_watch.node);
+		be->backend_watch.node = NULL;
+	}
+
+	if (be->blkif) {
+		xen_blkif_disconnect(be->blkif);
+		xen_vbd_free(&be->blkif->vbd);
+		xen_blkif_free(be->blkif);
+		be->blkif = NULL;
+	}
+
+	kfree(be);
+	dev_set_drvdata(&dev->dev, NULL);
+	return 0;
+}
+
+int xen_blkbk_flush_diskcache(struct xenbus_transaction xbt,
+			      struct backend_info *be, int state)
+{
+	struct xenbus_device *dev = be->dev;
+	int err;
+
+	err = xenbus_printf(xbt, dev->nodename, "feature-flush-cache",
+			    "%d", state);
+	if (err)
+		xenbus_dev_fatal(dev, err, "writing feature-flush-cache");
+
+	return err;
+}
+
+/*
+ * Entry point to this code when a new device is created.  Allocate the basic
+ * structures, and watch the store waiting for the hotplug scripts to tell us
+ * the device's physical major and minor numbers.  Switch to InitWait.
+ */
+static int xen_blkbk_probe(struct xenbus_device *dev,
+			   const struct xenbus_device_id *id)
+{
+	int err;
+	struct backend_info *be = kzalloc(sizeof(struct backend_info),
+					  GFP_KERNEL);
+	if (!be) {
+		xenbus_dev_fatal(dev, -ENOMEM,
+				 "allocating backend structure");
+		return -ENOMEM;
+	}
+	be->dev = dev;
+	dev_set_drvdata(&dev->dev, be);
+
+	be->blkif = xen_blkif_alloc(dev->otherend_id);
+	if (IS_ERR(be->blkif)) {
+		err = PTR_ERR(be->blkif);
+		be->blkif = NULL;
+		xenbus_dev_fatal(dev, err, "creating block interface");
+		goto fail;
+	}
+
+	/* setup back pointer */
+	be->blkif->be = be;
+
+	err = xenbus_watch_pathfmt(dev, &be->backend_watch, backend_changed,
+				   "%s/%s", dev->nodename, "physical-device");
+	if (err)
+		goto fail;
+
+	err = xenbus_switch_state(dev, XenbusStateInitWait);
+	if (err)
+		goto fail;
+
+	return 0;
+
+fail:
+	DPRINTK("failed");
+	xen_blkbk_remove(dev);
+	return err;
+}
+
+
+/*
+ * Callback received when the hotplug scripts have placed the physical-device
+ * node.  Read it and the mode node, and create a vbd.  If the frontend is
+ * ready, connect.
+ */
+static void backend_changed(struct xenbus_watch *watch,
+			    const char **vec, unsigned int len)
+{
+	int err;
+	unsigned major;
+	unsigned minor;
+	struct backend_info *be
+		= container_of(watch, struct backend_info, backend_watch);
+	struct xenbus_device *dev = be->dev;
+	int cdrom = 0;
+	char *device_type;
+
+	DPRINTK("");
+
+	err = xenbus_scanf(XBT_NIL, dev->nodename, "physical-device", "%x:%x",
+			   &major, &minor);
+	if (XENBUS_EXIST_ERR(err)) {
+		/*
+		 * Since this watch will fire once immediately after it is
+		 * registered, we expect this.  Ignore it, and wait for the
+		 * hotplug scripts.
+		 */
+		return;
+	}
+	if (err != 2) {
+		xenbus_dev_fatal(dev, err, "reading physical-device");
+		return;
+	}
+
+	if ((be->major || be->minor) &&
+	    ((be->major != major) || (be->minor != minor))) {
+		pr_warn(DRV_PFX "changing physical device (from %x:%x to %x:%x) not supported.\n",
+			be->major, be->minor, major, minor);
+		return;
+	}
+
+	be->mode = xenbus_read(XBT_NIL, dev->nodename, "mode", NULL);
+	if (IS_ERR(be->mode)) {
+		err = PTR_ERR(be->mode);
+		be->mode = NULL;
+		xenbus_dev_fatal(dev, err, "reading mode");
+		return;
+	}
+
+	device_type = xenbus_read(XBT_NIL, dev->otherend, "device-type", NULL);
+	if (!IS_ERR(device_type)) {
+		cdrom = strcmp(device_type, "cdrom") == 0;
+		kfree(device_type);
+	}
+
+	if (be->major == 0 && be->minor == 0) {
+		/* Front end dir is a number, which is used as the handle. */
+
+		char *p = strrchr(dev->otherend, '/') + 1;
+		long handle;
+		err = strict_strtoul(p, 0, &handle);
+		if (err)
+			return;
+
+		be->major = major;
+		be->minor = minor;
+
+		err = xen_vbd_create(be->blkif, handle, major, minor,
+				 (NULL == strchr(be->mode, 'w')), cdrom);
+		if (err) {
+			be->major = 0;
+			be->minor = 0;
+			xenbus_dev_fatal(dev, err, "creating vbd structure");
+			return;
+		}
+
+		err = xenvbd_sysfs_addif(dev);
+		if (err) {
+			xen_vbd_free(&be->blkif->vbd);
+			be->major = 0;
+			be->minor = 0;
+			xenbus_dev_fatal(dev, err, "creating sysfs entries");
+			return;
+		}
+
+		/* We're potentially connected now */
+		xen_update_blkif_status(be->blkif);
+	}
+}
+
+
+/*
+ * Callback received when the frontend's state changes.
+ */
+static void frontend_changed(struct xenbus_device *dev,
+			     enum xenbus_state frontend_state)
+{
+	struct backend_info *be = dev_get_drvdata(&dev->dev);
+	int err;
+
+	DPRINTK("%s", xenbus_strstate(frontend_state));
+
+	switch (frontend_state) {
+	case XenbusStateInitialising:
+		if (dev->state == XenbusStateClosed) {
+			pr_info(DRV_PFX "%s: prepare for reconnect\n",
+				dev->nodename);
+			xenbus_switch_state(dev, XenbusStateInitWait);
+		}
+		break;
+
+	case XenbusStateInitialised:
+	case XenbusStateConnected:
+		/*
+		 * Ensure we connect even when two watches fire in
+		 * close successsion and we miss the intermediate value
+		 * of frontend_state.
+		 */
+		if (dev->state == XenbusStateConnected)
+			break;
+
+		/*
+		 * Enforce precondition before potential leak point.
+		 * blkif_disconnect() is idempotent.
+		 */
+		xen_blkif_disconnect(be->blkif);
+
+		err = connect_ring(be);
+		if (err)
+			break;
+		xen_update_blkif_status(be->blkif);
+		break;
+
+	case XenbusStateClosing:
+		xen_blkif_disconnect(be->blkif);
+		xenbus_switch_state(dev, XenbusStateClosing);
+		break;
+
+	case XenbusStateClosed:
+		xenbus_switch_state(dev, XenbusStateClosed);
+		if (xenbus_dev_is_online(dev))
+			break;
+		/* fall through if not online */
+	case XenbusStateUnknown:
+		/* implies blkif_disconnect() via blkback_remove() */
+		device_unregister(&dev->dev);
+		break;
+
+	default:
+		xenbus_dev_fatal(dev, -EINVAL, "saw state %d at frontend",
+				 frontend_state);
+		break;
+	}
+}
+
+
+/* ** Connection ** */
+
+
+/*
+ * Write the physical details regarding the block device to the store, and
+ * switch to Connected state.
+ */
+static void connect(struct backend_info *be)
+{
+	struct xenbus_transaction xbt;
+	int err;
+	struct xenbus_device *dev = be->dev;
+
+	DPRINTK("%s", dev->otherend);
+
+	/* Supply the information about the device the frontend needs */
+again:
+	err = xenbus_transaction_start(&xbt);
+	if (err) {
+		xenbus_dev_fatal(dev, err, "starting transaction");
+		return;
+	}
+
+	err = xen_blkbk_flush_diskcache(xbt, be, be->blkif->vbd.flush_support);
+	if (err)
+		goto abort;
+
+	err = xenbus_printf(xbt, dev->nodename, "sectors", "%llu",
+			    (unsigned long long)vbd_sz(&be->blkif->vbd));
+	if (err) {
+		xenbus_dev_fatal(dev, err, "writing %s/sectors",
+				 dev->nodename);
+		goto abort;
+	}
+
+	/* FIXME: use a typename instead */
+	err = xenbus_printf(xbt, dev->nodename, "info", "%u",
+			    be->blkif->vbd.type |
+			    (be->blkif->vbd.readonly ? VDISK_READONLY : 0));
+	if (err) {
+		xenbus_dev_fatal(dev, err, "writing %s/info",
+				 dev->nodename);
+		goto abort;
+	}
+	err = xenbus_printf(xbt, dev->nodename, "sector-size", "%lu",
+			    (unsigned long)
+			    bdev_logical_block_size(be->blkif->vbd.bdev));
+	if (err) {
+		xenbus_dev_fatal(dev, err, "writing %s/sector-size",
+				 dev->nodename);
+		goto abort;
+	}
+
+	err = xenbus_transaction_end(xbt, 0);
+	if (err == -EAGAIN)
+		goto again;
+	if (err)
+		xenbus_dev_fatal(dev, err, "ending transaction");
+
+	err = xenbus_switch_state(dev, XenbusStateConnected);
+	if (err)
+		xenbus_dev_fatal(dev, err, "switching to Connected state",
+				 dev->nodename);
+
+	return;
+ abort:
+	xenbus_transaction_end(xbt, 1);
+}
+
+
+static int connect_ring(struct backend_info *be)
+{
+	struct xenbus_device *dev = be->dev;
+	unsigned long ring_ref;
+	unsigned int evtchn;
+	char protocol[64] = "";
+	int err;
+
+	DPRINTK("%s", dev->otherend);
+
+	err = xenbus_gather(XBT_NIL, dev->otherend, "ring-ref", "%lu",
+			    &ring_ref, "event-channel", "%u", &evtchn, NULL);
+	if (err) {
+		xenbus_dev_fatal(dev, err,
+				 "reading %s/ring-ref and event-channel",
+				 dev->otherend);
+		return err;
+	}
+
+	be->blkif->blk_protocol = BLKIF_PROTOCOL_NATIVE;
+	err = xenbus_gather(XBT_NIL, dev->otherend, "protocol",
+			    "%63s", protocol, NULL);
+	if (err)
+		strcpy(protocol, "unspecified, assuming native");
+	else if (0 == strcmp(protocol, XEN_IO_PROTO_ABI_NATIVE))
+		be->blkif->blk_protocol = BLKIF_PROTOCOL_NATIVE;
+	else if (0 == strcmp(protocol, XEN_IO_PROTO_ABI_X86_32))
+		be->blkif->blk_protocol = BLKIF_PROTOCOL_X86_32;
+	else if (0 == strcmp(protocol, XEN_IO_PROTO_ABI_X86_64))
+		be->blkif->blk_protocol = BLKIF_PROTOCOL_X86_64;
+	else {
+		xenbus_dev_fatal(dev, err, "unknown fe protocol %s", protocol);
+		return -1;
+	}
+	pr_info(DRV_PFX "ring-ref %ld, event-channel %d, protocol %d (%s)\n",
+		ring_ref, evtchn, be->blkif->blk_protocol, protocol);
+
+	/* Map the shared frame, irq etc. */
+	err = xen_blkif_map(be->blkif, ring_ref, evtchn);
+	if (err) {
+		xenbus_dev_fatal(dev, err, "mapping ring-ref %lu port %u",
+				 ring_ref, evtchn);
+		return err;
+	}
+
+	return 0;
+}
+
+
+/* ** Driver Registration ** */
+
+
+static const struct xenbus_device_id xen_blkbk_ids[] = {
+	{ "vbd" },
+	{ "" }
+};
+
+
+static struct xenbus_driver xen_blkbk = {
+	.name = "vbd",
+	.owner = THIS_MODULE,
+	.ids = xen_blkbk_ids,
+	.probe = xen_blkbk_probe,
+	.remove = xen_blkbk_remove,
+	.otherend_changed = frontend_changed
+};
+
+
+int xen_blkif_xenbus_init(void)
+{
+	return xenbus_register_backend(&xen_blkbk);
+}
-- 
1.7.4.1

