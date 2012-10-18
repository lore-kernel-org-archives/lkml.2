Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab2JROBA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 10:01:00 -0400
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:37460 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755761Ab2JROAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 10:00:55 -0400
Message-ID: <1350565065.23730.6.camel@thor>
Subject: [PATCH 1/1] staging: fwserial: Add TTY-over-Firewire serial driver
From: Peter Hurley <peter@hurleysoftware.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux1394-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Date: Thu, 18 Oct 2012 08:57:45 -0400
In-Reply-To: <cover.1350526287.git.peter@hurleysoftware.com>
References: <cover.1350526287.git.peter@hurleysoftware.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.2.4-0build1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides the kernel driver for high-speed TTY
communication over the IEEE 1394 bus.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/staging/Kconfig             |    2 +
 drivers/staging/Makefile            |    1 +
 drivers/staging/fwserial/Kconfig    |    9 +
 drivers/staging/fwserial/Makefile   |    2 +
 drivers/staging/fwserial/TODO       |   89 ++
 drivers/staging/fwserial/dma_fifo.c |  310 ++++
 drivers/staging/fwserial/dma_fifo.h |  130 ++
 drivers/staging/fwserial/fwserial.c | 2885 +++++++++++++++++++++++++++++++++++
 drivers/staging/fwserial/fwserial.h |  355 +++++
 9 files changed, 3783 insertions(+)
 create mode 100644 drivers/staging/fwserial/Kconfig
 create mode 100644 drivers/staging/fwserial/Makefile
 create mode 100644 drivers/staging/fwserial/TODO
 create mode 100644 drivers/staging/fwserial/dma_fifo.c
 create mode 100644 drivers/staging/fwserial/dma_fifo.h
 create mode 100644 drivers/staging/fwserial/fwserial.c
 create mode 100644 drivers/staging/fwserial/fwserial.h

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index d805eef..39696d6 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -144,4 +144,6 @@ source "drivers/staging/imx-drm/Kconfig"
 
 source "drivers/staging/dgrp/Kconfig"
 
+source "drivers/staging/fwserial/Kconfig"
+
 endif # STAGING
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index 76e2ebd..5565d5f 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -64,3 +64,4 @@ obj-$(CONFIG_NET_VENDOR_SILICOM)	+= silicom/
 obj-$(CONFIG_CED1401)		+= ced1401/
 obj-$(CONFIG_DRM_IMX)		+= imx-drm/
 obj-$(CONFIG_DGRP)		+= dgrp/
+obj-$(CONFIG_FIREWIRE_SERIAL)	+= fwserial/
diff --git a/drivers/staging/fwserial/Kconfig b/drivers/staging/fwserial/Kconfig
new file mode 100644
index 0000000..580406c
--- /dev/null
+++ b/drivers/staging/fwserial/Kconfig
@@ -0,0 +1,9 @@
+config FIREWIRE_SERIAL
+       tristate "TTY over Firewire"
+       depends on FIREWIRE
+       help
+          This enables TTY over IEEE 1394, providing high-speed serial
+	  connectivity to cabled peers.
+
+	  To compile this driver as a module, say M here:  the module will
+	  be called firewire-serial.
diff --git a/drivers/staging/fwserial/Makefile b/drivers/staging/fwserial/Makefile
new file mode 100644
index 0000000..2170869
--- /dev/null
+++ b/drivers/staging/fwserial/Makefile
@@ -0,0 +1,2 @@
+obj-$(CONFIG_FIREWIRE_SERIAL) += firewire-serial.o
+firewire-serial-objs := fwserial.o dma_fifo.o
diff --git a/drivers/staging/fwserial/TODO b/drivers/staging/fwserial/TODO
new file mode 100644
index 0000000..5451341
--- /dev/null
+++ b/drivers/staging/fwserial/TODO
@@ -0,0 +1,89 @@
+TODOs
+-----
+1. Implement retries for RCODE_BUSY, RCODE_NO_ACK and RCODE_SEND_ERROR
+   - I/O is handled asynchronously which presents some issues when error
+     conditions occur.
+2. Test BRK generation
+   - serial break condition is emulated by generating TTY_BREAK on the
+     receiving end. This is computed from the current baud rate and fed to
+     rx by a work item. Not sure if this works at all.
+3. Turn off ALL echoing for loopback
+   - why so many ECHO termios bits ;)
+4. Find out why occasionally peers fail to auto-connect with generation error
+   - this is an issue with either needing sync retries or with the remote
+     auto-probing before the local unit completes initialization.
+5. Move fifo allocation to fwtty_activate?
+   - the dma fifos are allocated at probe time even if a remote attach will
+     never occur. This needs to be moved to the tty_port activate but failure
+     needs to be accounted for.
+6. Implement _robust_ console on top of this. The existing prototype console
+   driver is not ready for the big leagues yet.
+7. Expose means of controlling attach/detach of peers via sysfs. Include
+   GUID-to-port matching/whitelist/blacklist.
+
+-- Issues with firewire stack --
+1. This driver uses the same unregistered vendor id that the firewire core does
+     (0xd00d1e). Perhaps this could be exposed as a define in
+     firewire-constants.h?
+2. MAX_ASYNC_PAYLOAD needs to be publicly exposed by core/ohci
+   - otherwise how will this driver know the max size of address window to
+     open for one packet write?
+3. Maybe device_max_receive() and link_speed_to_max_payload() should be
+     taken up by the firewire core?
+3. AR context size characterizes TTY_BUF_LOW_WATERMARK -- how to expose?
+   - the AR context is basically a big buffer that has recv'd writes from the
+     remote but for *every* firewire device. So it's not appropriate to stall
+     already-received data if the tty flip buffer is full.  To prevent this
+     (and to avoid __even more buffering__) this driver needs to know the size
+     of the AR context to ensure that space is *already* available in the tty
+     flip buffers.
+4. Explore if bigger AR context will reduce RCODE_BUSY responses
+   (or auto-grow to certain max size -- but this would require major surgery
+    as the current AR is contiguously mapped)
+
+-- Issues with TTY core --
+  1. Hack for alternate device name scheme
+     - because udev no longer allows device renaming, devices should have
+       their proper names on creation. This is an issue for creating the
+       fwloop<n> device with the fwtty<n> devices because although duplicating
+       roughly the same operations as tty_port_register_device() isn't difficult,
+       access to the tty_class & tty_fops is restricted in scope.
+
+       This is currently being worked around in create_loop_device() by
+       extracting the tty_class ptr and tty_fops ptr from the previously created
+       tty devices. Perhaps an add'l api can be added -- eg.,
+       tty_{port_}register_named_device().
+
+  2. Hack for ensuring that flip buffer + ldisc has finished reading before HUP
+     - a race exists between HUPping the tty and waiting for data to be rcv'd
+       on the remote side (apparently this is known and has existed for some
+       time). The problem is that because of firewire's throughput, quite a
+       bit of data can be dropped when closing the remote because the flip
+       buffers may be nearly full but the ldisc doesn't account for this, but
+       rather just discards the data.
+
+       This is currently being worked around by walking the tty flip buffers on
+       hangup to determine how much data is still floating there -- see
+       fwtty_do_hangup().
+
+  3. Hack for determining if tty buffer level is past watermark level
+     - related to issue #2 with the firewire stack: this driver needs to know
+       how much space is still available for allocating in the tty flip
+       buffers. Central to this problem is that the device has already
+       rec'd data from the remote, but the data _must_ be moved out of the
+       buffer it's occupying (the AR context), or will stall every 1394
+       device. The AR context is a fixed size (32K) so to ensure that the
+       flip buffer will always have space avail, check this watermark with
+       each rx.
+
+       This is currently being worked around in fwtty_rx() by direct access to
+       tty_buffer.memory_used and subtracting this from 64k (constant used in
+       tty_buffer_alloc()).
+
+  4. Watermark isn't accurate because 256-byte tty buffers aren't accounted for
+     in memory_used
+     - related to issue #3 above: when tty flip buffers are reclaimed, 256-byte
+       buffers are not accounted for in memory_used. So it's possible for
+       (substantially) > 64K to be in use per tty_buffer.
+
+       This is a minor issue and not being worked around currently.
diff --git a/drivers/staging/fwserial/dma_fifo.c b/drivers/staging/fwserial/dma_fifo.c
new file mode 100644
index 0000000..cb20c99
--- /dev/null
+++ b/drivers/staging/fwserial/dma_fifo.c
@@ -0,0 +1,310 @@
+/*
+ * DMA-able FIFO implementation
+ *
+ * Copyright (C) 2012 Peter Hurley <peter@hurleysoftware.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/list.h>
+#include <linux/bug.h>
+
+#include "dma_fifo.h"
+
+#ifdef DEBUG_TRACING
+#define df_trace(s, args...) pr_debug(s, ##args)
+#else
+#define df_trace(s, args...)
+#endif
+
+#define FAIL(fifo, condition, format...) ({				\
+	fifo->corrupt = !!(condition);					\
+	if (unlikely(fifo->corrupt)) {					\
+		__WARN_printf(format);					\
+	}								\
+	unlikely(fifo->corrupt);					\
+})
+
+/*
+ * private helper fn to determine if check is in open interval (lo,hi)
+ */
+static bool addr_check(unsigned check, unsigned lo, unsigned hi)
+{
+	return check - (lo + 1) < (hi - 1) - lo;
+}
+
+/**
+ * dma_fifo_init: initialize the fifo to a valid but inoperative state
+ * @fifo: address of in-place "struct dma_fifo" object
+ */
+void dma_fifo_init(struct dma_fifo *fifo)
+{
+	memset(fifo, 0, sizeof(*fifo));
+}
+
+/**
+ * dma_fifo_alloc - initialize and allocate dma_fifo
+ * @fifo: address of in-place "struct dma_fifo" object
+ * @size: 'apparent' size, in bytes, of fifo
+ * @align: dma alignment to maintain (should be at least cpu cache alignment),
+ *         must be power of 2
+ * @tx_limit: maximum # of bytes transmissable per dma (rounded down to
+ *            multiple of alignment, but at least align size)
+ * @open_limit: maximum # of outstanding dma transactions allowed
+ * @gfp_mask: get_free_pages mask, passed to kmalloc()
+ *
+ * The 'apparent' size will be rounded up to next greater aligned size.
+ * Returns 0 if no error, otherwise an error code
+ */
+int dma_fifo_alloc(struct dma_fifo *fifo, int size, unsigned align,
+		   int tx_limit, int open_limit, gfp_t gfp_mask)
+{
+	int capacity;
+
+	if (!is_power_of_2(align) || size < 0)
+		return -EINVAL;
+
+	size = round_up(size, align);
+	capacity = size + align * open_limit + align * DMA_FIFO_GUARD;
+	fifo->data = kmalloc(capacity, gfp_mask);
+	if (!fifo->data)
+		return -ENOMEM;
+
+	fifo->in = 0;
+	fifo->out = 0;
+	fifo->done = 0;
+	fifo->size = size;
+	fifo->avail = size;
+	fifo->align = align;
+	fifo->tx_limit = max_t(int, round_down(tx_limit, align), align);
+	fifo->open = 0;
+	fifo->open_limit = open_limit;
+	fifo->guard = size + align * open_limit;
+	fifo->capacity = capacity;
+	INIT_LIST_HEAD(&fifo->pending);
+	fifo->corrupt = 0;
+
+	return 0;
+}
+
+/**
+ * dma_fifo_free - frees the fifo
+ * @fifo: address of in-place "struct dma_fifo" to free
+ *
+ * Also reinits the fifo to a valid but inoperative state. This
+ * allows the fifo to be reused with a different target requiring
+ * different fifo parameters.
+ */
+void dma_fifo_free(struct dma_fifo *fifo)
+{
+	struct dma_pending *pending, *next;
+
+	if (fifo->data == NULL)
+		return;
+
+	list_for_each_entry_safe(pending, next, &fifo->pending, link)
+		list_del(&pending->link);
+	kfree(fifo->data);
+	dma_fifo_init(fifo);
+}
+
+/**
+ * dma_fifo_reset - dumps the fifo contents and reinits for reuse
+ * @fifo: address of in-place "struct dma_fifo" to reset
+ */
+void dma_fifo_reset(struct dma_fifo *fifo)
+{
+	struct dma_pending *pending, *next;
+
+	if (fifo->data == NULL)
+		return;
+
+	list_for_each_entry_safe(pending, next, &fifo->pending, link)
+		list_del(&pending->link);
+	fifo->in = 0;
+	fifo->out = 0;
+	fifo->done = 0;
+	fifo->avail = fifo->size;
+	fifo->open = 0;
+	fifo->corrupt = 0;
+}
+
+/**
+ * dma_fifo_in - copies data into the fifo
+ * @fifo: address of in-place "struct dma_fifo" to write to
+ * @src: buffer to copy from
+ * @n: # of bytes to copy
+ *
+ * Returns the # of bytes actually copied, which can be less than requested if
+ * the fifo becomes full. If < 0, return is error code.
+ */
+int dma_fifo_in(struct dma_fifo *fifo, const void *src, int n)
+{
+	int ofs, l;
+
+	if (fifo->data == NULL)
+		return -ENOENT;
+	if (fifo->corrupt)
+		return -ENXIO;
+
+	if (n > fifo->avail)
+		n = fifo->avail;
+	if (n <= 0)
+		return 0;
+
+	ofs = fifo->in % fifo->capacity;
+	l = min(n, fifo->capacity - ofs);
+	memcpy(fifo->data + ofs, src, l);
+	memcpy(fifo->data, src + l, n - l);
+
+	if (FAIL(fifo, addr_check(fifo->done, fifo->in, fifo->in + n) ||
+			fifo->avail < n,
+			"fifo corrupt: in:%u out:%u done:%u n:%d avail:%d",
+			fifo->in, fifo->out, fifo->done, n, fifo->avail))
+		return -ENXIO;
+
+	fifo->in += n;
+	fifo->avail -= n;
+
+	df_trace("in:%u out:%u done:%u n:%d avail:%d", fifo->in, fifo->out,
+		 fifo->done, n, fifo->avail);
+
+	return n;
+}
+
+/**
+ * dma_fifo_out_pend - gets address/len of next avail read and marks as pended
+ * @fifo: address of in-place "struct dma_fifo" to read from
+ * @pended: address of structure to fill with read address/len
+ *          The data/len fields will be NULL/0 if no dma is pended.
+ *
+ * Returns the # of used bytes remaining in fifo (ie, if > 0, more data
+ * remains in the fifo that was not pended). If < 0, return is error code.
+ */
+int dma_fifo_out_pend(struct dma_fifo *fifo, struct dma_pending *pended)
+{
+	unsigned len, n, ofs, l, limit;
+
+	if (fifo->data == NULL)
+		return -ENOENT;
+	if (fifo->corrupt)
+		return -ENXIO;
+
+	pended->len = 0;
+	pended->data = NULL;
+	pended->out = fifo->out;
+
+	len = fifo->in - fifo->out;
+	if (!len)
+		return -ENODATA;
+	if (fifo->open == fifo->open_limit)
+		return -EAGAIN;
+
+	n = len;
+	ofs = fifo->out % fifo->capacity;
+	l = fifo->capacity - ofs;
+	limit = min_t(unsigned, l, fifo->tx_limit);
+	if (n > limit) {
+		n = limit;
+		fifo->out += limit;
+	} else if (ofs + n > fifo->guard) {
+		fifo->out += l;
+		fifo->in = fifo->out;
+	} else {
+		fifo->out += round_up(n, fifo->align);
+		fifo->in = fifo->out;
+	}
+
+	df_trace("in: %u out: %u done: %u n: %d len: %u avail: %d", fifo->in,
+		 fifo->out, fifo->done, n, len, fifo->avail);
+
+	pended->len = n;
+	pended->data = fifo->data + ofs;
+	pended->next = fifo->out;
+	list_add_tail(&pended->link, &fifo->pending);
+	++fifo->open;
+
+	if (FAIL(fifo, fifo->open > fifo->open_limit,
+			"past open limit:%d (limit:%d)",
+			fifo->open, fifo->open_limit))
+		return -ENXIO;
+	if (FAIL(fifo, fifo->out & (fifo->align - 1),
+			"fifo out unaligned:%u (align:%u)",
+			fifo->out, fifo->align))
+		return -ENXIO;
+
+	return len - n;
+}
+
+/**
+ * dma_fifo_out_complete - marks pended dma as completed
+ * @fifo: address of in-place "struct dma_fifo" which was read from
+ * @complete: address of structure for previously pended dma to mark completed
+ */
+int dma_fifo_out_complete(struct dma_fifo *fifo, struct dma_pending *complete)
+{
+	struct dma_pending *pending, *next, *tmp;
+
+	if (fifo->data == NULL)
+		return -ENOENT;
+	if (fifo->corrupt)
+		return -ENXIO;
+	if (list_empty(&fifo->pending) && fifo->open == 0)
+		return -EINVAL;
+
+	if (FAIL(fifo, list_empty(&fifo->pending) != (fifo->open == 0),
+			"pending list disagrees with open count:%d",
+			fifo->open))
+		return -ENXIO;
+
+	tmp = complete->data;
+	*tmp = *complete;
+	list_replace(&complete->link, &tmp->link);
+	dp_mark_completed(tmp);
+
+	/* Only update the fifo in the original pended order */
+	list_for_each_entry_safe(pending, next, &fifo->pending, link) {
+		if (!dp_is_completed(pending)) {
+			df_trace("still pending: saved out: %u len: %d",
+				 pending->out, pending->len);
+			break;
+		}
+
+		if (FAIL(fifo, pending->out != fifo->done ||
+				addr_check(fifo->in, fifo->done, pending->next),
+				"in:%u out:%u done:%u saved:%u next:%u",
+				fifo->in, fifo->out, fifo->done, pending->out,
+				pending->next))
+			return -ENXIO;
+
+		list_del(&pending->link);
+		fifo->done = pending->next;
+		fifo->avail += pending->len;
+		--fifo->open;
+
+		df_trace("in: %u out: %u done: %u len: %u avail: %d", fifo->in,
+			 fifo->out, fifo->done, pending->len, fifo->avail);
+	}
+
+	if (FAIL(fifo, fifo->open < 0, "open dma:%d < 0", fifo->open))
+		return -ENXIO;
+	if (FAIL(fifo, fifo->avail > fifo->size, "fifo avail:%d > size:%d",
+			fifo->avail, fifo->size))
+		return -ENXIO;
+
+	return 0;
+}
diff --git a/drivers/staging/fwserial/dma_fifo.h b/drivers/staging/fwserial/dma_fifo.h
new file mode 100644
index 0000000..a113fe1
--- /dev/null
+++ b/drivers/staging/fwserial/dma_fifo.h
@@ -0,0 +1,130 @@
+/*
+ * DMA-able FIFO interface
+ *
+ * Copyright (C) 2012 Peter Hurley <peter@hurleysoftware.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#ifndef _DMA_FIFO_H_
+#define _DMA_FIFO_H_
+
+/**
+ * The design basis for the DMA FIFO is to provide an output side that
+ * complies with the streaming DMA API design that can be DMA'd from directly
+ * (without additional copying), coupled with an input side that maintains a
+ * logically consistent 'apparent' size (ie, bytes in + bytes avail is static
+ * for the lifetime of the FIFO).
+ *
+ * DMA output transactions originate on a cache line boundary and can be
+ * variably-sized. DMA output transactions can be retired out-of-order but
+ * the FIFO will only advance the output in the original input sequence.
+ * This means the FIFO will eventually stall if a transaction is never retired.
+ *
+ * Chunking the output side into cache line multiples means that some FIFO
+ * memory is unused. For example, if all the avail input has been pended out,
+ * then the in and out markers are re-aligned to the next cache line.
+ * The maximum possible waste is
+ *     (cache line alignment - 1) * (max outstanding dma transactions)
+ * This potential waste requires additional hidden capacity within the FIFO
+ * to be able to accept input while the 'apparent' size has not been reached.
+ *
+ * Additional cache lines (ie, guard area) are used to minimize DMA
+ * fragmentation when wrapping at the end of the FIFO. Input is allowed into the
+ * guard area, but the in and out FIFO markers are wrapped when DMA is pended.
+ */
+
+#define DMA_FIFO_GUARD 3   /* # of cache lines to reserve for the guard area */
+
+struct dma_fifo {
+	unsigned	 in;
+	unsigned	 out;		/* updated when dma is pended         */
+	unsigned	 done;		/* updated upon dma completion        */
+	struct {
+		unsigned corrupt:1;
+	};
+	int		 size;		/* 'apparent' size of fifo	      */
+	int		 guard;		/* ofs of guard area		      */
+	int		 capacity;	/* size + reserved                    */
+	int		 avail;		/* # of unused bytes in fifo          */
+	unsigned	 align;		/* must be power of 2                 */
+	int		 tx_limit;	/* max # of bytes per dma transaction */
+	int		 open_limit;	/* max # of outstanding allowed       */
+	int		 open;		/* # of outstanding dma transactions  */
+	struct list_head pending;	/* fifo markers for outstanding dma   */
+	void		 *data;
+};
+
+struct dma_pending {
+	struct list_head link;
+	void		 *data;
+	unsigned	 len;
+	unsigned         next;
+	unsigned         out;
+};
+
+static inline void dp_mark_completed(struct dma_pending *dp)
+{
+	dp->data += 1;
+}
+
+static inline bool dp_is_completed(struct dma_pending *dp)
+{
+	return (unsigned long)dp->data & 1UL;
+}
+
+extern void dma_fifo_init(struct dma_fifo *fifo);
+extern int dma_fifo_alloc(struct dma_fifo *fifo, int size, unsigned align,
+			  int tx_limit, int open_limit, gfp_t gfp_mask);
+extern void dma_fifo_free(struct dma_fifo *fifo);
+extern void dma_fifo_reset(struct dma_fifo *fifo);
+extern int dma_fifo_in(struct dma_fifo *fifo, const void *src, int n);
+extern int dma_fifo_out_pend(struct dma_fifo *fifo, struct dma_pending *pended);
+extern int dma_fifo_out_complete(struct dma_fifo *fifo,
+				 struct dma_pending *complete);
+
+/* returns the # of used bytes in the fifo */
+static inline int dma_fifo_level(struct dma_fifo *fifo)
+{
+	return fifo->size - fifo->avail;
+}
+
+/* returns the # of bytes ready for output in the fifo */
+static inline int dma_fifo_out_level(struct dma_fifo *fifo)
+{
+	return fifo->in - fifo->out;
+}
+
+/* returns the # of unused bytes in the fifo */
+static inline int dma_fifo_avail(struct dma_fifo *fifo)
+{
+	return fifo->avail;
+}
+
+/* returns true if fifo has max # of outstanding dmas */
+static inline bool dma_fifo_busy(struct dma_fifo *fifo)
+{
+	return fifo->open == fifo->open_limit;
+}
+
+/* changes the max size of dma returned from dma_fifo_out_pend() */
+static inline int dma_fifo_change_tx_limit(struct dma_fifo *fifo, int tx_limit)
+{
+	tx_limit = round_down(tx_limit, fifo->align);
+	fifo->tx_limit = max_t(int, tx_limit, fifo->align);
+	return 0;
+}
+
+#endif /* _DMA_FIFO_H_ */
diff --git a/drivers/staging/fwserial/fwserial.c b/drivers/staging/fwserial/fwserial.c
new file mode 100644
index 0000000..07fd1b8
--- /dev/null
+++ b/drivers/staging/fwserial/fwserial.c
@@ -0,0 +1,2885 @@
+/*
+ * FireWire Serial driver
+ *
+ * Copyright (C) 2012 Peter Hurley <peter@hurleysoftware.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software Foundation,
+ * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ */
+
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/device.h>
+#include <linux/mod_devicetable.h>
+#include <linux/rculist.h>
+#include <linux/workqueue.h>
+#include <linux/ratelimit.h>
+#include <linux/bug.h>
+
+#include "fwserial.h"
+
+#define be32_to_u64(hi, lo)  ((u64)be32_to_cpu(hi) << 32 | be32_to_cpu(lo))
+
+#define LINUX_VENDOR_ID   0xd00d1eU  /* same id used in card root directory   */
+#define FWSERIAL_VERSION  0x00e81cU  /* must be unique within LINUX_VENDOR_ID */
+
+/* configurable options */
+static int num_ttys = 4;	    /* # of std ttys to create per fw_card    */
+				    /* - doubles as loopback port index       */
+static bool auto_connect = true;    /* try to VIRT_CABLE to every peer        */
+static bool create_loop_dev = true; /* create a loopback device for each card */
+bool limit_bw;			    /* limit async bandwidth to 20% of max    */
+
+module_param_named(ttys, num_ttys, int, S_IRUGO | S_IWUSR);
+module_param_named(auto, auto_connect, bool, S_IRUGO | S_IWUSR);
+module_param_named(loop, create_loop_dev, bool, S_IRUGO | S_IWUSR);
+module_param(limit_bw, bool, S_IRUGO | S_IWUSR);
+
+/*
+ * Threshold below which the tty is woken for writing
+ * - should be equal to WAKEUP_CHARS in drivers/tty/n_tty.c because
+ *   even if the writer is woken, n_tty_poll() won't set POLLOUT until
+ *   our fifo is below this level
+ */
+#define WAKEUP_CHARS             256
+
+/**
+ * fwserial_list: list of every fw_serial created for each fw_card
+ * See discussion in fwserial_probe.
+ */
+static LIST_HEAD(fwserial_list);
+static DEFINE_MUTEX(fwserial_list_mutex);
+
+/**
+ * port_table: array of tty ports allocated to each fw_card
+ *
+ * tty ports are allocated during probe when an fw_serial is first
+ * created for a given fw_card. Ports are allocated in a contiguous block,
+ * each block consisting of 'num_ports' ports.
+ */
+static struct fwtty_port *port_table[MAX_TOTAL_PORTS];
+static DEFINE_MUTEX(port_table_lock);
+static bool port_table_corrupt;
+#define FWTTY_INVALID_INDEX  MAX_TOTAL_PORTS
+
+/* total # of tty ports created per fw_card */
+static int num_ports;
+
+/* slab used as pool for struct fwtty_transactions */
+static struct kmem_cache *fwtty_txn_cache;
+
+struct fwtty_transaction;
+typedef void (*fwtty_transaction_cb)(struct fw_card *card, int rcode,
+				     void *data, size_t length,
+				     struct fwtty_transaction *txn);
+
+struct fwtty_transaction {
+	struct fw_transaction      fw_txn;
+	fwtty_transaction_cb       callback;
+	struct fwtty_port	   *port;
+	union {
+		struct dma_pending dma_pended;
+	};
+};
+
+#define fwtty_dbg(port, s, v...)	  dev_dbg(port->device, "%s: " s, __func__, ##v)
+#define fwtty_err(port, s, v...)	  dev_err(port->device, s, ##v)
+#define fwtty_err_ratelimited(p, s, v...) dev_err_ratelimited(p->device, s, ##v)
+
+#ifdef DEBUG
+static inline void debug_short_write(struct fwtty_port *port, int c, int n)
+{
+	int avail;
+
+	if (n < c) {
+		spin_lock_bh(&port->lock);
+		avail = dma_fifo_avail(&port->tx_fifo);
+		spin_unlock_bh(&port->lock);
+		fwtty_dbg(port, "short write: avail:%d req:%d wrote:%d",
+			  avail, c, n);
+	}
+}
+#else
+#define debug_short_write(port, c, n)
+#endif
+
+
+static void fwtty_update_port_status(struct fwtty_port *port, unsigned status);
+static void fwtty_restart_tx(struct fwtty_port *port);
+static struct fwtty_peer *__fwserial_peer_by_node_id(struct fw_card *card,
+						     int generation, int id);
+
+#ifdef FWTTY_PROFILING
+
+static void profile_fifo_avail(struct fwtty_port *port, unsigned *stat)
+{
+	spin_lock_bh(&port->lock);
+	profile_size_distrib(stat, dma_fifo_avail(&port->tx_fifo));
+	spin_unlock_bh(&port->lock);
+}
+
+static void dump_profile(struct seq_file *m, struct stats *stats)
+{
+	/* for each stat, print sum of 0 to 2^k, then individually */
+	int k = 4;
+	unsigned sum;
+	int j;
+	char t[10];
+
+	snprintf(t, 10, "< %d", 1 << k);
+	seq_printf(m, "\n%14s  %6s", " ", t);
+	for (j = k + 1; j < DISTRIBUTION_MAX_INDEX; ++j)
+		seq_printf(m, "%6d", 1 << j);
+
+	++k;
+	for (j = 0, sum = 0; j <= k; ++j)
+		sum += stats->writes[j];
+	seq_printf(m, "\n%14s: %6d", "writes", sum);
+	for (j = k + 1; j <= DISTRIBUTION_MAX_INDEX; ++j)
+		seq_printf(m, "%6d", stats->writes[j]);
+
+	for (j = 0, sum = 0; j <= k; ++j)
+		sum += stats->txns[j];
+	seq_printf(m, "\n%14s: %6d", "txns", sum);
+	for (j = k + 1; j <= DISTRIBUTION_MAX_INDEX; ++j)
+		seq_printf(m, "%6d", stats->txns[j]);
+
+	for (j = 0, sum = 0; j <= k; ++j)
+		sum += stats->unthrottle[j];
+	seq_printf(m, "\n%14s: %6d", "avail @ unthr", sum);
+	for (j = k + 1; j <= DISTRIBUTION_MAX_INDEX; ++j)
+		seq_printf(m, "%6d", stats->unthrottle[j]);
+}
+
+#else
+#define profile_fifo_avail(port, stat)
+#define dump_profile(m, stats)
+#endif
+
+/* Returns the max receive packet size for the given card */
+static inline int device_max_receive(struct fw_device *fw_device)
+{
+	return 1 <<  (clamp_t(int, fw_device->max_rec, 8U, 13U) + 1);
+}
+
+static void fwtty_log_tx_error(struct fwtty_port *port, int rcode)
+{
+	switch (rcode) {
+	case RCODE_SEND_ERROR:
+		fwtty_err_ratelimited(port, "card busy");
+		break;
+	case RCODE_ADDRESS_ERROR:
+		fwtty_err_ratelimited(port, "bad unit addr or write length");
+		break;
+	case RCODE_DATA_ERROR:
+		fwtty_err_ratelimited(port, "failed rx");
+		break;
+	case RCODE_NO_ACK:
+		fwtty_err_ratelimited(port, "missing ack");
+		break;
+	case RCODE_BUSY:
+		fwtty_err_ratelimited(port, "remote busy");
+		break;
+	default:
+		fwtty_err_ratelimited(port, "failed tx: %d", rcode);
+	}
+}
+
+static void fwtty_txn_constructor(void *this)
+{
+	struct fwtty_transaction *txn = this;
+
+	init_timer(&txn->fw_txn.split_timeout_timer);
+}
+
+static void fwtty_common_callback(struct fw_card *card, int rcode,
+				  void *payload, size_t len, void *cb_data)
+{
+	struct fwtty_transaction *txn = cb_data;
+	struct fwtty_port *port = txn->port;
+
+	if (port && rcode != RCODE_COMPLETE)
+		fwtty_log_tx_error(port, rcode);
+	if (txn->callback)
+		txn->callback(card, rcode, payload, len, txn);
+	kmem_cache_free(fwtty_txn_cache, txn);
+}
+
+static int fwtty_send_data_async(struct fwtty_peer *peer, int tcode,
+				 unsigned long long addr, void *payload,
+				 size_t len, fwtty_transaction_cb callback,
+				 struct fwtty_port *port)
+{
+	struct fwtty_transaction *txn;
+	int generation;
+
+	txn = kmem_cache_alloc(fwtty_txn_cache, GFP_ATOMIC);
+	if (!txn)
+		return -ENOMEM;
+
+	txn->callback = callback;
+	txn->port = port;
+
+	generation = peer->generation;
+	smp_rmb();
+	fw_send_request(peer->fw_serial->card, &txn->fw_txn, tcode,
+			peer->node_id, generation, peer->speed, addr, payload,
+			len, fwtty_common_callback, txn);
+	return 0;
+}
+
+static void fwtty_send_txn_async(struct fwtty_peer *peer,
+				 struct fwtty_transaction *txn, int tcode,
+				 unsigned long long addr, void *payload,
+				 size_t len, fwtty_transaction_cb callback,
+				 struct fwtty_port *port)
+{
+	int generation;
+
+	txn->callback = callback;
+	txn->port = port;
+
+	generation = peer->generation;
+	smp_rmb();
+	fw_send_request(peer->fw_serial->card, &txn->fw_txn, tcode,
+			peer->node_id, generation, peer->speed, addr, payload,
+			len, fwtty_common_callback, txn);
+}
+
+static void fwtty_update_port_status(struct fwtty_port *port, unsigned status)
+{
+	unsigned delta;
+	struct tty_struct *tty;
+
+	/* simulated LSR/MSR status from remote */
+	status &= ~MCTRL_MASK;
+	delta = (port->mstatus ^ status) & ~MCTRL_MASK;
+	delta &= ~(status & TIOCM_RNG);
+	smp_wmb();
+	port->mstatus = status;
+
+	if (delta & TIOCM_RNG)
+		++port->icount.rng;
+	if (delta & TIOCM_DSR)
+		++port->icount.dsr;
+	if (delta & TIOCM_CAR)
+		++port->icount.dcd;
+	if (delta & TIOCM_CTS)
+		++port->icount.cts;
+
+	fwtty_dbg(port, "status: %x delta: %x", status, delta);
+
+	if (delta & TIOCM_CAR) {
+		if (status & TIOCM_CAR)
+			wake_up_interruptible(&port->port.open_wait);
+		else
+			schedule_work(&port->hangup);
+	}
+
+	if (delta & TIOCM_CTS) {
+		tty = tty_port_tty_get(&port->port);
+		if (tty && C_CRTSCTS(tty)) {
+			if (tty->hw_stopped) {
+				if (status & TIOCM_CTS) {
+					tty->hw_stopped = 0;
+					fwtty_restart_tx(port);
+				}
+			} else {
+				if (~status & TIOCM_CTS)
+					tty->hw_stopped = 1;
+			}
+		}
+		tty_kref_put(tty);
+
+	} else if (delta & OOB_TX_THROTTLE) {
+		tty = tty_port_tty_get(&port->port);
+		if (tty) {
+			if (tty->hw_stopped) {
+				if (~status & OOB_TX_THROTTLE) {
+					tty->hw_stopped = 0;
+					fwtty_restart_tx(port);
+				}
+			} else {
+				if (status & OOB_TX_THROTTLE)
+					tty->hw_stopped = 1;
+			}
+		}
+		tty_kref_put(tty);
+	}
+
+	if (delta & (UART_LSR_BI << 24)) {
+		if (status & (UART_LSR_BI << 24)) {
+			port->break_last = jiffies;
+			schedule_delayed_work(&port->emit_breaks, 0);
+		} else {
+			/* run emit_breaks one last time (if pending) */
+			if (del_timer(&port->emit_breaks.timer))
+				schedule_work(&port->emit_breaks.work);
+		}
+	}
+
+	if (delta & (TIOCM_DSR | TIOCM_CAR | TIOCM_CTS | TIOCM_RNG))
+		wake_up_interruptible(&port->port.delta_msr_wait);
+}
+
+/**
+ * __fwtty_port_line_status - generate 'line status' for indicated port
+ *
+ * This function returns a remote 'MSR' state based on the local 'MCR' state,
+ * as if a null modem cable was attached. The actual status is a mangling
+ * of TIOCM_* bits suitable for sending to a peer's status_addr.
+ *
+ * Note: caller must be holding port lock
+ */
+static unsigned __fwtty_port_line_status(struct fwtty_port *port)
+{
+	unsigned status = 0;
+
+	/* TODO: add module param to tie RNG to DTR as well */
+
+	if (port->mctrl & TIOCM_DTR)
+		status |= TIOCM_DSR | TIOCM_CAR;
+	if (port->mctrl & TIOCM_RTS)
+		status |= TIOCM_CTS;
+	if (port->mctrl & OOB_RX_THROTTLE)
+		status |= OOB_TX_THROTTLE;
+	/* emulate BRK as add'l line status */
+	if (port->break_ctl)
+		status |= UART_LSR_BI << 24;
+
+	return status;
+}
+
+/**
+ * fwtty_port_line_status - same as above but locked by port lock
+ */
+static unsigned fwtty_port_line_status(struct fwtty_port *port)
+{
+	unsigned status;
+
+	spin_lock_bh(&port->lock);
+	status = __fwtty_port_line_status(port);
+	spin_unlock_bh(&port->lock);
+	return status;
+}
+
+/**
+ * fwtty_write_port_status - send the port line status to peer
+ *
+ * Note: caller cannot be holding the port lock. If this is a loopback
+ * device, fwtty_update_port_status() will deadlock trying to double-claim
+ * the port lock.
+ */
+static int fwtty_write_port_status(struct fwtty_port *port, unsigned status)
+{
+	struct fwtty_peer *peer;
+	int err = -ENOENT;
+
+	rcu_read_lock();
+	peer = rcu_dereference(port->peer);
+	if (peer) {
+		err = fwtty_send_data_async(peer, TCODE_WRITE_QUADLET_REQUEST,
+					    peer->status_addr, &status,
+					    sizeof(status), NULL, port);
+	}
+	rcu_read_unlock();
+
+	return err;
+}
+
+/**
+ * fwtty_do_hangup - wait for ldisc to deliver all pending rx; only then hangup
+ *
+ * When the remote has finished tx, and all in-flight rx has been received and
+ * and pushed to the flip buffer, the remote may close its device. This will
+ * drop DTR on the remote which will drop carrier here. Typically, the tty is
+ * hung up when carrier is dropped or lost.
+ *
+ * However, there is a race between the hang up and the line discipline
+ * delivering its data to the reader. A hangup will cause the ldisc to flush
+ * (ie., clear) the read buffer and flip buffer. Because of firewire's
+ * relatively high throughput, the ldisc frequently lags well behind the driver,
+ * resulting in lost data (which has already been received and written to
+ * the flip buffer) when the remote closes its end.
+ *
+ * Unfortunately, since the flip buffer offers no direct method for determining
+ * if it holds data, ensuring the ldisc has delivered all data is problematic.
+ */
+
+/* Disgusting HACK!! -- walk the flip buffers */
+static int hack_tty_buffer_chars_in_buffer(struct tty_struct *tty)
+{
+	struct tty_buffer *p;
+	int n = 0;
+
+	spin_lock_bh(&tty->buf.lock);
+	p = tty->buf.head;
+	while (p != NULL) {
+		n += p->commit - p->read;
+		p = p->next;
+	}
+	spin_unlock_bh(&tty->buf.lock);
+	return n;
+}
+
+static void fwtty_do_hangup(struct work_struct *work)
+{
+	struct fwtty_port *port = container_of(work, struct fwtty_port, hangup);
+	struct tty_struct *tty;
+	struct tty_ldisc *ldisc;
+	ssize_t unread = 0;
+	int n;
+	unsigned long delay = HZ / 100;
+	int tries = 20;		/* 0.2 second */
+
+	tty = tty_port_tty_get(&port->port);
+	if (tty) {
+		for (n = 0; n < tries;) {
+			++n;
+			ldisc = tty_ldisc_ref(tty);
+			if (!ldisc)
+				break;
+			unread = hack_tty_buffer_chars_in_buffer(tty);
+			unread += ldisc->ops->chars_in_buffer(tty);
+			tty_ldisc_deref(ldisc);
+
+			if (unread == 0)
+				break;
+
+			schedule_timeout_uninterruptible(delay);
+		}
+
+		fwtty_dbg(port, "unread:%ld tries:%d", (long)unread, n);
+
+		tty_vhangup(tty);
+		tty_kref_put(tty);
+	}
+}
+
+static void fwtty_emit_breaks(struct work_struct *work)
+{
+	struct fwtty_port *port = container_of(to_delayed_work(work),
+					       struct fwtty_port, emit_breaks);
+	struct tty_struct *tty;
+	static const char buf[16];
+	unsigned long now = jiffies;
+	unsigned long elapsed = now - port->break_last;
+	int n, t, c, brk = 0;
+
+	tty = tty_port_tty_get(&port->port);
+	if (!tty)
+		return;
+
+	/* generate breaks at the line rate (but at least 1) */
+	n = (elapsed * port->cps) / HZ + 1;
+	port->break_last = now;
+
+	fwtty_dbg(port, "sending %d brks", n);
+
+	while (n) {
+		t = min(n, 16);
+		c = tty_insert_flip_string_fixed_flag(tty, buf, TTY_BREAK, t);
+		n -= c;
+		brk += c;
+		if (c < t)
+			break;
+	}
+	tty_flip_buffer_push(tty);
+
+	tty_kref_put(tty);
+
+	if (port->mstatus & (UART_LSR_BI << 24))
+		schedule_delayed_work(&port->emit_breaks, FREQ_BREAKS);
+	port->icount.brk += brk;
+}
+
+static int fwtty_rx(struct fwtty_port *port, unsigned char *data, size_t len)
+{
+	struct tty_struct *tty;
+	int c, avail, n = len;
+	unsigned lsr, status, old;
+	int err = 0;
+
+	tty = tty_port_tty_get(&port->port);
+	if (!tty)
+		return -ENOENT;
+
+	fwtty_dbg(port, "%d", n);
+
+	if (port->write_only) {
+		n = 0;
+		goto out;
+	}
+
+	/* disregard break status; breaks are generated by emit_breaks work */
+	lsr = (port->mstatus >> 24) & ~UART_LSR_BI;
+
+	if (port->overrun)
+		lsr |= UART_LSR_OE;
+
+	if (lsr & UART_LSR_OE)
+		++port->icount.overrun;
+
+	lsr &= port->status_mask;
+	if (lsr & ~port->ignore_mask & UART_LSR_OE) {
+		if (!tty_insert_flip_char(tty, 0, TTY_OVERRUN)) {
+			err = -EIO;
+			goto out;
+		}
+	}
+	port->overrun = false;
+
+	if (lsr & port->ignore_mask & ~UART_LSR_OE) {
+		/* TODO: don't drop SAK and Magic SysRq here */
+		n = 0;
+		goto out;
+	}
+
+	c = tty_insert_flip_string_fixed_flag(tty, data, TTY_NORMAL, n);
+
+	if (c < n) {
+		/* Next rx, report overrun error (to ourselves) */
+		port->overrun = true;
+		err = -EIO;
+		fwtty_err_ratelimited(port, "flip buffer full");
+	}
+
+	n -= c;
+	if (c > 0)
+		tty_flip_buffer_push(tty);
+
+	/*
+	 * Throttle the sender if the remaining flip buffer space has reached
+	 * low watermark to avoid losing data which may already be in-flight.
+	 * Since the AR request context is 32k, that much data could have
+	 * __already__ been acked.
+	 */
+	if (!err) {
+		/*
+		 * HACK - this functionality needs to be exposed by interface
+		 * NB: this is not quite accurate because free 256-byte
+		 * flip buffers aren't accounted in memory_used. Actual avail
+		 * won't be less than reported though.
+		 */
+		spin_lock_bh(&tty->buf.lock);
+		avail = 65536 - tty->buf.memory_used;
+		spin_unlock_bh(&tty->buf.lock);
+
+		if (avail < TTY_BUF_LOW_WATERMARK) {
+			fwtty_dbg(port, "avail:%d", avail);
+			if (port->loopback)
+				tty->hw_stopped = 1;
+			else {
+				spin_lock_bh(&port->lock);
+				old = port->mctrl;
+				port->mctrl |= OOB_RX_THROTTLE;
+				status = __fwtty_port_line_status(port);
+				spin_unlock_bh(&port->lock);
+
+				if (~old & OOB_RX_THROTTLE)
+					fwtty_write_port_status(port, status);
+			}
+		}
+	}
+out:
+	tty_kref_put(tty);
+
+	port->icount.rx += len;
+	port->stats.lost += n;
+	return err;
+}
+
+/**
+ * fwtty_port_handler - bus address handler for port reads/writes
+ * @parameters: fw_address_callback_t as specified by firewire core interface
+ *
+ * This handler is responsible for handling inbound read/write dma from remotes.
+ */
+static void fwtty_port_handler(struct fw_card *card,
+			       struct fw_request *request,
+			       int tcode, int destination, int source,
+			       int generation,
+			       unsigned long long addr,
+			       void *data, size_t len,
+			       void *callback_data)
+{
+	struct fwtty_port *port = callback_data;
+	struct fwtty_peer *peer;
+	int err;
+	int rcode;
+
+	/* Only accept rx from the peer virtual-cabled to this port */
+	rcu_read_lock();
+	peer = __fwserial_peer_by_node_id(card, generation, source);
+	rcu_read_unlock();
+	if (!peer || peer != rcu_access_pointer(port->peer)) {
+		rcode = RCODE_ADDRESS_ERROR;
+		fwtty_err_ratelimited(port, "ignoring unauthenticated data");
+		goto respond;
+	}
+
+	switch (tcode) {
+	case TCODE_WRITE_QUADLET_REQUEST:
+		if (addr != port->rx_handler.offset || len != 4)
+			rcode = RCODE_ADDRESS_ERROR;
+		else {
+			fwtty_update_port_status(port, *(unsigned *)data);
+			rcode = RCODE_COMPLETE;
+		}
+		break;
+
+	case TCODE_WRITE_BLOCK_REQUEST:
+		if (addr != port->rx_handler.offset + 4 ||
+		    len > port->rx_handler.length - 4) {
+			rcode = RCODE_ADDRESS_ERROR;
+		} else {
+			err = fwtty_rx(port, data, len);
+			switch (err) {
+			case 0:
+				rcode = RCODE_COMPLETE;
+				break;
+			case -EIO:
+				rcode = RCODE_DATA_ERROR;
+				break;
+			default:
+				rcode = RCODE_CONFLICT_ERROR;
+				break;
+			}
+		}
+		break;
+
+	default:
+		rcode = RCODE_TYPE_ERROR;
+	}
+
+respond:
+	fw_send_response(card, request, rcode);
+}
+
+static void fwtty_restart_tx(struct fwtty_port *port)
+{
+	int len, avail;
+
+	spin_lock_bh(&port->lock);
+	len = dma_fifo_out_level(&port->tx_fifo);
+	if (len)
+		schedule_delayed_work(&port->drain, 0);
+	avail = dma_fifo_avail(&port->tx_fifo);
+	spin_unlock_bh(&port->lock);
+
+	fwtty_dbg(port, "fifo len: %d avail: %d", len, avail);
+}
+
+/**
+ * fwtty_tx_complete - callback for tx dma
+ * @data: ignored, has no meaning for write txns
+ * @length: ignored, has no meaning for write txns
+ *
+ * The writer must be woken here if the fifo has been emptied because it
+ * may have slept if chars_in_buffer was != 0
+ */
+static void fwtty_tx_complete(struct fw_card *card, int rcode,
+			      void *data, size_t length,
+			      struct fwtty_transaction *txn)
+{
+	struct fwtty_port *port = txn->port;
+	struct tty_struct *tty;
+	int len;
+
+	fwtty_dbg(port, "rcode: %d", rcode);
+
+	switch (rcode) {
+	case RCODE_COMPLETE:
+		spin_lock_bh(&port->lock);
+		dma_fifo_out_complete(&port->tx_fifo, &txn->dma_pended);
+		len = dma_fifo_level(&port->tx_fifo);
+		spin_unlock_bh(&port->lock);
+
+		port->icount.tx += txn->dma_pended.len;
+		break;
+
+	default:
+		/* TODO: implement retries */
+		spin_lock_bh(&port->lock);
+		dma_fifo_out_complete(&port->tx_fifo, &txn->dma_pended);
+		len = dma_fifo_level(&port->tx_fifo);
+		spin_unlock_bh(&port->lock);
+
+		port->stats.dropped += txn->dma_pended.len;
+	}
+
+	if (len == 0) {
+		tty = tty_port_tty_get(&port->port);
+		if (tty) {
+			tty_wakeup(tty);
+			tty_kref_put(tty);
+		}
+	}
+}
+
+static int fwtty_tx(struct fwtty_port *port, bool drain)
+{
+	struct fwtty_peer *peer;
+	struct fwtty_transaction *txn;
+	struct tty_struct *tty;
+	int n, len;
+
+	tty = tty_port_tty_get(&port->port);
+	if (!tty)
+		return -ENOENT;
+
+	rcu_read_lock();
+	peer = rcu_dereference(port->peer);
+	if (!peer) {
+		n = -EIO;
+		goto out;
+	}
+
+	if (test_and_set_bit(IN_TX, &port->flags)) {
+		n = -EALREADY;
+		goto out;
+	}
+
+	/* try to write as many dma transactions out as possible */
+	n = -EAGAIN;
+	while (!tty->stopped && !tty->hw_stopped &&
+			!test_bit(STOP_TX, &port->flags)) {
+		txn = kmem_cache_alloc(fwtty_txn_cache, GFP_ATOMIC);
+		if (!txn) {
+			n = -ENOMEM;
+			break;
+		}
+
+		spin_lock_bh(&port->lock);
+		n = dma_fifo_out_pend(&port->tx_fifo, &txn->dma_pended);
+		spin_unlock_bh(&port->lock);
+
+		fwtty_dbg(port, "out: %u rem: %d", txn->dma_pended.len, n);
+
+		if (n < 0) {
+			kmem_cache_free(fwtty_txn_cache, txn);
+			if (n == -EAGAIN)
+				++port->stats.tx_stall;
+			else if (n == -ENODATA)
+				profile_size_distrib(port->stats.txns, 0);
+			else {
+				++port->stats.fifo_errs;
+				fwtty_err_ratelimited(port, "fifo err: %d", n);
+			}
+			break;
+		}
+
+		profile_size_distrib(port->stats.txns, txn->dma_pended.len);
+
+		fwtty_send_txn_async(peer, txn, TCODE_WRITE_BLOCK_REQUEST,
+				     peer->fifo_addr, txn->dma_pended.data,
+				     txn->dma_pended.len, fwtty_tx_complete,
+				     port);
+		++port->stats.sent;
+
+		/*
+		 * Stop tx if the 'last view' of the fifo is empty or if
+		 * this is the writer and there's not enough data to bother
+		 */
+		if (n == 0 || (!drain && n < WRITER_MINIMUM))
+			break;
+	}
+
+	if (n >= 0 || n == -EAGAIN || n == -ENOMEM || n == -ENODATA) {
+		spin_lock_bh(&port->lock);
+		len = dma_fifo_out_level(&port->tx_fifo);
+		if (len) {
+			unsigned long delay = (n == -ENOMEM) ? HZ : 1;
+			schedule_delayed_work(&port->drain, delay);
+		}
+		spin_unlock_bh(&port->lock);
+
+		/* wakeup the writer */
+		if (drain && len < WAKEUP_CHARS)
+			tty_wakeup(tty);
+	}
+
+	clear_bit(IN_TX, &port->flags);
+	wake_up_interruptible(&port->wait_tx);
+
+out:
+	rcu_read_unlock();
+	tty_kref_put(tty);
+	return n;
+}
+
+static void fwtty_drain_tx(struct work_struct *work)
+{
+	struct fwtty_port *port = container_of(to_delayed_work(work),
+					       struct fwtty_port, drain);
+
+	fwtty_tx(port, true);
+}
+
+static void fwtty_write_xchar(struct fwtty_port *port, char ch)
+{
+	struct fwtty_peer *peer;
+
+	++port->stats.xchars;
+
+	fwtty_dbg(port, "%02x", ch);
+
+	rcu_read_lock();
+	peer = rcu_dereference(port->peer);
+	if (peer) {
+		fwtty_send_data_async(peer, TCODE_WRITE_BLOCK_REQUEST,
+				      peer->fifo_addr, &ch, sizeof(ch),
+				      NULL, port);
+	}
+	rcu_read_unlock();
+}
+
+struct fwtty_port *fwtty_port_get(unsigned index)
+{
+	struct fwtty_port *port;
+
+	if (index >= MAX_TOTAL_PORTS)
+		return NULL;
+
+	mutex_lock(&port_table_lock);
+	port = port_table[index];
+	if (port)
+		kref_get(&port->fw_serial->kref);
+	mutex_unlock(&port_table_lock);
+	return port;
+}
+EXPORT_SYMBOL(fwtty_port_get);
+
+static int fwtty_ports_add(struct fw_serial *fw_serial)
+{
+	int err = -EBUSY;
+	int i, j;
+
+	if (port_table_corrupt)
+		return err;
+
+	mutex_lock(&port_table_lock);
+	for (i = 0; i + num_ports <= MAX_TOTAL_PORTS; i += num_ports) {
+		if (!port_table[i]) {
+			for (j = 0; j < num_ports; ++i, ++j) {
+				fw_serial->ports[j]->index = i;
+				port_table[i] = fw_serial->ports[j];
+			}
+			err = 0;
+			break;
+		}
+	}
+	mutex_unlock(&port_table_lock);
+	return err;
+}
+
+static void fwserial_destroy(struct kref *kref)
+{
+	struct fw_serial *fw_serial = container_of(kref, struct fw_serial, kref);
+	struct fwtty_port **ports = fw_serial->ports;
+	int j, i = ports[0]->index;
+
+	synchronize_rcu();
+
+	mutex_lock(&port_table_lock);
+	for (j = 0; j < num_ports; ++i, ++j) {
+		static bool once;
+		int corrupt = port_table[i] != ports[j];
+		if (corrupt && !once) {
+			WARN(corrupt, "port_table[%d]: %p != ports[%d]: %p",
+			     i, port_table[i], j, ports[j]);
+			once = true;
+			port_table_corrupt = true;
+		}
+
+		port_table[i] = NULL;
+	}
+	mutex_unlock(&port_table_lock);
+
+	for (j = 0; j < num_ports; ++j) {
+		fw_core_remove_address_handler(&ports[j]->rx_handler);
+		dma_fifo_free(&ports[j]->tx_fifo);
+		kfree(ports[j]);
+	}
+	kfree(fw_serial);
+}
+
+void fwtty_port_put(struct fwtty_port *port)
+{
+	kref_put(&port->fw_serial->kref, fwserial_destroy);
+}
+EXPORT_SYMBOL(fwtty_port_put);
+
+static inline struct fwtty_port *fwtty_port(struct tty_port *tty_port)
+{
+	return container_of(tty_port, struct fwtty_port, port);
+}
+
+static void fwtty_port_dtr_rts(struct tty_port *tty_port, int on)
+{
+	struct fwtty_port *port = fwtty_port(tty_port);
+	unsigned status;
+
+	fwtty_dbg(port, "on/off: %d", on);
+
+	spin_lock_bh(&port->lock);
+	/* Don't change carrier state if this is a console */
+	if (!port->port.console) {
+		if (on)
+			port->mctrl |= TIOCM_DTR | TIOCM_RTS;
+		else
+			port->mctrl &= ~(TIOCM_DTR | TIOCM_RTS);
+	}
+
+	status = __fwtty_port_line_status(port);
+	spin_unlock_bh(&port->lock);
+
+	fwtty_write_port_status(port, status);
+}
+
+/**
+ * fwtty_port_carrier_raised: required tty_port operation
+ *
+ * This port operation is polled after a tty has been opened and is waiting for
+ * carrier detect -- see drivers/tty/tty_port:tty_port_block_til_ready().
+ */
+static int fwtty_port_carrier_raised(struct tty_port *tty_port)
+{
+	struct fwtty_port *port = fwtty_port(tty_port);
+	int rc;
+
+	rc = (port->mstatus & TIOCM_CAR);
+
+	fwtty_dbg(port, "%d", rc);
+
+	return rc;
+}
+
+static unsigned set_termios(struct fwtty_port *port, struct tty_struct *tty)
+{
+	unsigned baud, frame;
+
+	baud = tty_termios_baud_rate(&tty->termios);
+	tty_termios_encode_baud_rate(&tty->termios, baud, baud);
+
+	/* compute bit count of 2 frames */
+	frame = 12 + ((C_CSTOPB(tty)) ? 4 : 2) + ((C_PARENB(tty)) ? 2 : 0);
+
+	switch (C_CSIZE(tty)) {
+	case CS5:
+		frame -= (C_CSTOPB(tty)) ? 1 : 0;
+		break;
+	case CS6:
+		frame += 2;
+		break;
+	case CS7:
+		frame += 4;
+		break;
+	case CS8:
+		frame += 6;
+		break;
+	}
+
+	port->cps = (baud << 1) / frame;
+
+	port->status_mask = UART_LSR_OE;
+	if (_I_FLAG(tty, BRKINT | PARMRK))
+		port->status_mask |= UART_LSR_BI;
+
+	port->ignore_mask = 0;
+	if (I_IGNBRK(tty)) {
+		port->ignore_mask |= UART_LSR_BI;
+		if (I_IGNPAR(tty))
+			port->ignore_mask |= UART_LSR_OE;
+	}
+
+	port->write_only = !C_CREAD(tty);
+
+	/* turn off echo and newline xlat if loopback */
+	if (port->loopback) {
+		tty->termios.c_lflag &= ~ECHO;
+		tty->termios.c_oflag &= ~ONLCR;
+	}
+
+	return baud;
+}
+
+static int fwtty_port_activate(struct tty_port *tty_port,
+			       struct tty_struct *tty)
+{
+	struct fwtty_port *port = fwtty_port(tty_port);
+	unsigned baud, status;
+
+	set_bit(TTY_IO_ERROR, &tty->flags);
+
+	spin_lock_bh(&port->lock);
+	dma_fifo_reset(&port->tx_fifo);
+
+	baud = set_termios(port, tty);
+
+	/* if console, don't change carrier state */
+	if (!port->port.console) {
+		port->mctrl = 0;
+		if (baud != 0)
+			port->mctrl = TIOCM_DTR | TIOCM_RTS;
+	}
+
+	if (C_CRTSCTS(tty) && ~port->mstatus & TIOCM_CTS)
+		tty->hw_stopped = 1;
+
+	status = __fwtty_port_line_status(port);
+	spin_unlock_bh(&port->lock);
+
+	fwtty_write_port_status(port, status);
+
+	clear_bit(TTY_IO_ERROR, &tty->flags);
+
+	return 0;
+}
+
+/**
+ * fwtty_port_shutdown
+ *
+ * Note: the tty port core ensures this is not the console and
+ * manages TTY_IO_ERROR properly
+ */
+static void fwtty_port_shutdown(struct tty_port *tty_port)
+{
+	struct fwtty_port *port = fwtty_port(tty_port);
+	unsigned status;
+
+	/* TODO: cancel outstanding transactions */
+
+	cancel_delayed_work_sync(&port->emit_breaks);
+	flush_delayed_work_sync(&port->drain);
+
+	spin_lock_bh(&port->lock);
+	port->break_ctl = 0;
+	status = __fwtty_port_line_status(port);
+	dma_fifo_reset(&port->tx_fifo);
+	spin_unlock_bh(&port->lock);
+
+	fwtty_write_port_status(port, status);
+}
+
+static int fwtty_open(struct tty_struct *tty, struct file *fp)
+{
+	struct fwtty_port *port = tty->driver_data;
+
+	return tty_port_open(&port->port, tty, fp);
+}
+
+static void fwtty_close(struct tty_struct *tty, struct file *fp)
+{
+	struct fwtty_port *port = tty->driver_data;
+
+	tty_port_close(&port->port, tty, fp);
+}
+
+static void fwtty_hangup(struct tty_struct *tty)
+{
+	struct fwtty_port *port = tty->driver_data;
+
+	tty_port_hangup(&port->port);
+}
+
+static void fwtty_cleanup(struct tty_struct *tty)
+{
+	struct fwtty_port *port = tty->driver_data;
+
+	tty->driver_data = NULL;
+	fwtty_port_put(port);
+}
+
+static int fwtty_install(struct tty_driver *driver, struct tty_struct *tty)
+{
+	struct fwtty_port *port = fwtty_port_get(tty->index);
+	int err;
+
+	err = tty_standard_install(driver, tty);
+	if (!err)
+		tty->driver_data = port;
+	else
+		fwtty_port_put(port);
+	return err;
+}
+
+static int fwtty_write(struct tty_struct *tty, const unsigned char *buf, int c)
+{
+	struct fwtty_port *port = tty->driver_data;
+	int n, len;
+
+	fwtty_dbg(port, "%d", c);
+	profile_size_distrib(port->stats.writes, c);
+
+	spin_lock_bh(&port->lock);
+	n = dma_fifo_in(&port->tx_fifo, buf, c);
+	len = dma_fifo_out_level(&port->tx_fifo);
+	if (len < DRAIN_THRESHOLD)
+		schedule_delayed_work(&port->drain, 1);
+	spin_unlock_bh(&port->lock);
+
+	if (len >= DRAIN_THRESHOLD)
+		fwtty_tx(port, false);
+
+	debug_short_write(port, c, n);
+
+	return (n < 0) ? 0 : n;
+}
+
+static int fwtty_write_room(struct tty_struct *tty)
+{
+	struct fwtty_port *port = tty->driver_data;
+	int n;
+
+	spin_lock_bh(&port->lock);
+	n = dma_fifo_avail(&port->tx_fifo);
+	spin_unlock_bh(&port->lock);
+
+	fwtty_dbg(port, "%d", n);
+
+	return n;
+}
+
+static int fwtty_chars_in_buffer(struct tty_struct *tty)
+{
+	struct fwtty_port *port = tty->driver_data;
+	int n;
+
+	spin_lock_bh(&port->lock);
+	n = dma_fifo_level(&port->tx_fifo);
+	spin_unlock_bh(&port->lock);
+
+	fwtty_dbg(port, "%d", n);
+
+	return n;
+}
+
+static void fwtty_send_xchar(struct tty_struct *tty, char ch)
+{
+	struct fwtty_port *port = tty->driver_data;
+
+	fwtty_dbg(port, "%02x", ch);
+
+	fwtty_write_xchar(port, ch);
+}
+
+static void fwtty_throttle(struct tty_struct *tty)
+{
+	struct fwtty_port *port = tty->driver_data;
+
+	/*
+	 * Ignore throttling (but not unthrottling).
+	 * It only makes sense to throttle when data will no longer be
+	 * accepted by the tty flip buffer. For example, it is
+	 * possible for received data to overflow the tty buffer long
+	 * before the line discipline ever has a chance to throttle the driver.
+	 * Additionally, the driver may have already completed the I/O
+	 * but the tty buffer is still emptying, so the line discipline is
+	 * throttling and unthrottling nothing.
+	 */
+
+	++port->stats.throttled;
+}
+
+static void fwtty_unthrottle(struct tty_struct *tty)
+{
+	struct fwtty_port *port = tty->driver_data;
+	unsigned status;
+
+	fwtty_dbg(port, "CRTSCTS: %d", (C_CRTSCTS(tty) != 0));
+
+	profile_fifo_avail(port, port->stats.unthrottle);
+
+	if (port->loopback) {
+		tty->hw_stopped = 0;
+		fwtty_restart_tx(port);
+		return;
+	}
+
+	spin_lock_bh(&port->lock);
+	port->mctrl &= ~OOB_RX_THROTTLE;
+	if (C_CRTSCTS(tty))
+		port->mctrl |= TIOCM_RTS;
+	status = __fwtty_port_line_status(port);
+	spin_unlock_bh(&port->lock);
+
+	fwtty_write_port_status(port, status);
+}
+
+static int check_msr_delta(struct fwtty_port *port, unsigned long mask,
+			   struct async_icount *prev)
+{
+	struct async_icount now;
+	int delta;
+
+	now = port->icount;
+
+	delta = ((mask & TIOCM_RNG && prev->rng != now.rng) ||
+		 (mask & TIOCM_DSR && prev->dsr != now.dsr) ||
+		 (mask & TIOCM_CAR && prev->dcd != now.dcd) ||
+		 (mask & TIOCM_CTS && prev->cts != now.cts));
+
+	*prev = now;
+
+	return delta;
+}
+
+static int wait_msr_change(struct fwtty_port *port, unsigned long mask)
+{
+	struct async_icount prev;
+
+	prev = port->icount;
+
+	return wait_event_interruptible(port->port.delta_msr_wait,
+					check_msr_delta(port, mask, &prev));
+}
+
+static int get_serial_info(struct fwtty_port *port,
+			   struct serial_struct __user *info)
+{
+	struct serial_struct tmp;
+
+	memset(&tmp, 0, sizeof(tmp));
+
+	tmp.type =  PORT_UNKNOWN;
+	tmp.line =  port->port.tty->index;
+	tmp.flags = port->port.flags;
+	tmp.xmit_fifo_size = FWTTY_PORT_TXFIFO_LEN;
+	tmp.baud_base = 400000000;
+	tmp.close_delay = port->port.close_delay;
+
+	return (copy_to_user(info, &tmp, sizeof(*info))) ? -EFAULT : 0;
+}
+
+static int set_serial_info(struct fwtty_port *port,
+			   struct serial_struct __user *info)
+{
+	struct serial_struct tmp;
+
+	if (copy_from_user(&tmp, info, sizeof(tmp)))
+		return -EFAULT;
+
+	if (tmp.irq != 0 || tmp.port != 0 || tmp.custom_divisor != 0 ||
+			tmp.baud_base != 400000000)
+		return -EPERM;
+
+	if (!capable(CAP_SYS_ADMIN)) {
+		if (((tmp.flags & ~ASYNC_USR_MASK) !=
+		     (port->port.flags & ~ASYNC_USR_MASK)))
+			return -EPERM;
+	} else
+		port->port.close_delay = tmp.close_delay * HZ / 100;
+
+	return 0;
+}
+
+static int fwtty_ioctl(struct tty_struct *tty, unsigned cmd,
+		       unsigned long arg)
+{
+	struct fwtty_port *port = tty->driver_data;
+	int err;
+
+	switch (cmd) {
+	case TIOCGSERIAL:
+		mutex_lock(&port->port.mutex);
+		err = get_serial_info(port, (void __user *)arg);
+		mutex_unlock(&port->port.mutex);
+		break;
+
+	case TIOCSSERIAL:
+		mutex_lock(&port->port.mutex);
+		err = set_serial_info(port, (void __user *)arg);
+		mutex_unlock(&port->port.mutex);
+		break;
+
+	case TIOCMIWAIT:
+		err = wait_msr_change(port, arg);
+		break;
+
+	default:
+		err = -ENOIOCTLCMD;
+	}
+
+	return err;
+}
+
+static void fwtty_set_termios(struct tty_struct *tty, struct ktermios *old)
+{
+	struct fwtty_port *port = tty->driver_data;
+	unsigned baud, status;
+
+	spin_lock_bh(&port->lock);
+	baud = set_termios(port, tty);
+
+	if ((baud == 0) && (old->c_cflag & CBAUD))
+		port->mctrl &= ~(TIOCM_DTR | TIOCM_RTS);
+	else if ((baud != 0) && !(old->c_cflag & CBAUD)) {
+		if (C_CRTSCTS(tty) || !test_bit(TTY_THROTTLED, &tty->flags))
+			port->mctrl |= TIOCM_DTR | TIOCM_RTS;
+		else
+			port->mctrl |= TIOCM_DTR;
+	}
+	status = __fwtty_port_line_status(port);
+	spin_unlock_bh(&port->lock);
+
+	fwtty_write_port_status(port, status);
+
+	if (old->c_cflag & CRTSCTS) {
+		if (!C_CRTSCTS(tty)) {
+			tty->hw_stopped = 0;
+			fwtty_restart_tx(port);
+		}
+	} else if (C_CRTSCTS(tty) && ~port->mstatus & TIOCM_CTS) {
+		tty->hw_stopped = 1;
+	}
+}
+
+/**
+ * fwtty_break_ctl - start/stop sending breaks
+ *
+ * Signals the remote to start or stop generating simulated breaks.
+ * First, stop dequeueing from the fifo and wait for writer/drain to leave tx
+ * before signalling the break line status. This guarantees any pending rx will
+ * be queued to the line discipline before break is simulated on the remote.
+ * Conversely, turning off break_ctl requires signalling the line status change,
+ * then enabling tx.
+ */
+static int fwtty_break_ctl(struct tty_struct *tty, int state)
+{
+	struct fwtty_port *port = tty->driver_data;
+	unsigned status;
+	long ret;
+
+	fwtty_dbg(port, "%d", state);
+
+	if (state == -1) {
+		set_bit(STOP_TX, &port->flags);
+		ret = wait_event_interruptible_timeout(port->wait_tx,
+					       !test_bit(IN_TX, &port->flags),
+					       10);
+		if (ret == 0 || ret == -ERESTARTSYS) {
+			clear_bit(STOP_TX, &port->flags);
+			fwtty_restart_tx(port);
+			return -EINTR;
+		}
+	}
+
+	spin_lock_bh(&port->lock);
+	port->break_ctl = (state == -1);
+	status = __fwtty_port_line_status(port);
+	spin_unlock_bh(&port->lock);
+
+	fwtty_write_port_status(port, status);
+
+	if (state == 0) {
+		spin_lock_bh(&port->lock);
+		dma_fifo_reset(&port->tx_fifo);
+		clear_bit(STOP_TX, &port->flags);
+		spin_unlock_bh(&port->lock);
+	}
+	return 0;
+}
+
+static int fwtty_tiocmget(struct tty_struct *tty)
+{
+	struct fwtty_port *port = tty->driver_data;
+	unsigned tiocm;
+
+	spin_lock_bh(&port->lock);
+	tiocm = (port->mctrl & MCTRL_MASK) | (port->mstatus & ~MCTRL_MASK);
+	spin_unlock_bh(&port->lock);
+
+	fwtty_dbg(port, "%x", tiocm);
+
+	return tiocm;
+}
+
+static int fwtty_tiocmset(struct tty_struct *tty, unsigned set, unsigned clear)
+{
+	struct fwtty_port *port = tty->driver_data;
+	unsigned status;
+
+	fwtty_dbg(port, "set: %x clear: %x", set, clear);
+
+	/* TODO: simulate loopback if TIOCM_LOOP set */
+
+	spin_lock_bh(&port->lock);
+	port->mctrl &= ~(clear & MCTRL_MASK & 0xffff);
+	port->mctrl |= set & MCTRL_MASK & 0xffff;
+	status = __fwtty_port_line_status(port);
+	spin_unlock_bh(&port->lock);
+
+	fwtty_write_port_status(port, status);
+	return 0;
+}
+
+static int fwtty_get_icount(struct tty_struct *tty,
+			    struct serial_icounter_struct *icount)
+{
+	struct fwtty_port *port = tty->driver_data;
+	struct stats stats;
+
+	memcpy(&stats, &port->stats, sizeof(stats));
+	if (port->port.console)
+		(*port->fwcon_ops->stats)(&stats, port->con_data);
+
+	icount->cts = port->icount.cts;
+	icount->dsr = port->icount.dsr;
+	icount->rng = port->icount.rng;
+	icount->dcd = port->icount.dcd;
+	icount->rx  = port->icount.rx;
+	icount->tx  = port->icount.tx + stats.xchars;
+	icount->frame   = port->icount.frame;
+	icount->overrun = port->icount.overrun;
+	icount->parity  = port->icount.parity;
+	icount->brk     = port->icount.brk;
+	icount->buf_overrun = port->icount.overrun;
+	return 0;
+}
+
+static void fwtty_proc_show_port(struct seq_file *m, struct fwtty_port *port)
+{
+	struct stats stats;
+
+	memcpy(&stats, &port->stats, sizeof(stats));
+	if (port->port.console)
+		(*port->fwcon_ops->stats)(&stats, port->con_data);
+
+	seq_printf(m, " tx:%d rx:%d", port->icount.tx + stats.xchars,
+		   port->icount.rx);
+	seq_printf(m, " cts:%d dsr:%d rng:%d dcd:%d", port->icount.cts,
+		   port->icount.dsr, port->icount.rng, port->icount.dcd);
+	seq_printf(m, " fe:%d oe:%d pe:%d brk:%d", port->icount.frame,
+		   port->icount.overrun, port->icount.parity, port->icount.brk);
+	seq_printf(m, " dr:%d st:%d err:%d lost:%d", stats.dropped,
+		   stats.tx_stall, stats.fifo_errs, stats.lost);
+	seq_printf(m, " pkts:%d thr:%d", stats.sent, stats.throttled);
+	seq_printf(m, " addr:%012llx", port->rx_handler.offset);
+
+	if (port->port.console) {
+		seq_printf(m, "\n    ");
+		(*port->fwcon_ops->proc_show)(m, port->con_data);
+	}
+
+	dump_profile(m, &port->stats);
+}
+
+static void fwtty_proc_show_peer(struct seq_file *m, struct fwtty_peer *peer)
+{
+	int generation = peer->generation;
+
+	smp_rmb();
+	seq_printf(m, " %s:", dev_name(&peer->unit->device));
+	seq_printf(m, " node:%04x gen:%d", peer->node_id, generation);
+	seq_printf(m, " sp:%d max:%d guid:%016llx", peer->speed,
+		   peer->max_payload, (unsigned long long) peer->guid);
+
+	if (capable(CAP_SYS_ADMIN)) {
+		seq_printf(m, " mgmt:%012llx",
+			   (unsigned long long) peer->mgmt_addr);
+		seq_printf(m, " addr:%012llx",
+			   (unsigned long long) peer->status_addr);
+	}
+	seq_putc(m, '\n');
+}
+
+static int fwtty_proc_show(struct seq_file *m, void *v)
+{
+	struct fwtty_port *port;
+	struct fw_serial *fw_serial;
+	struct fwtty_peer *peer;
+	int i;
+
+	seq_puts(m, "fwserinfo: 1.0 driver: 1.0\n");
+	for (i = 0; i < MAX_TOTAL_PORTS && (port = fwtty_port_get(i)); ++i) {
+		seq_printf(m, "%2d:", i);
+		if (capable(CAP_SYS_ADMIN))
+			fwtty_proc_show_port(m, port);
+		fwtty_port_put(port);
+		seq_printf(m, "\n");
+	}
+	seq_putc(m, '\n');
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(fw_serial, &fwserial_list, list) {
+		seq_printf(m, "card: %s  guid: %016llx\n",
+			   dev_name(fw_serial->card->device),
+			   (unsigned long long) fw_serial->card->guid);
+		list_for_each_entry_rcu(peer, &fw_serial->peer_list, list)
+			fwtty_proc_show_peer(m, peer);
+	}
+	rcu_read_unlock();
+	return 0;
+}
+
+static int fwtty_proc_open(struct inode *inode, struct file *fp)
+{
+	return single_open(fp, fwtty_proc_show, NULL);
+}
+
+static const struct file_operations fwtty_proc_fops = {
+	.owner =        THIS_MODULE,
+	.open =         fwtty_proc_open,
+	.read =         seq_read,
+	.llseek =       seq_lseek,
+	.release =      single_release,
+};
+
+static const struct tty_port_operations fwtty_port_ops = {
+	.dtr_rts =		fwtty_port_dtr_rts,
+	.carrier_raised =	fwtty_port_carrier_raised,
+	.shutdown =		fwtty_port_shutdown,
+	.activate =		fwtty_port_activate,
+};
+
+static const struct tty_operations fwtty_ops = {
+	.open =			fwtty_open,
+	.close =		fwtty_close,
+	.hangup =		fwtty_hangup,
+	.cleanup =		fwtty_cleanup,
+	.install =		fwtty_install,
+	.write =		fwtty_write,
+	.write_room =		fwtty_write_room,
+	.chars_in_buffer =	fwtty_chars_in_buffer,
+	.send_xchar =           fwtty_send_xchar,
+	.throttle =             fwtty_throttle,
+	.unthrottle =           fwtty_unthrottle,
+	.ioctl =		fwtty_ioctl,
+	.set_termios =		fwtty_set_termios,
+	.break_ctl =		fwtty_break_ctl,
+	.tiocmget =		fwtty_tiocmget,
+	.tiocmset =		fwtty_tiocmset,
+	.get_icount =		fwtty_get_icount,
+	.proc_fops =		&fwtty_proc_fops,
+};
+
+static inline int mgmt_pkt_expected_len(__be16 code)
+{
+	static const struct fwserial_mgmt_pkt pkt;
+
+	switch (be16_to_cpu(code)) {
+	case FWSC_VIRT_CABLE_PLUG:
+		return sizeof(pkt.hdr) + sizeof(pkt.plug_req);
+
+	case FWSC_VIRT_CABLE_PLUG_RSP:  /* | FWSC_RSP_OK */
+		return sizeof(pkt.hdr) + sizeof(pkt.plug_rsp);
+
+
+	case FWSC_VIRT_CABLE_UNPLUG:
+	case FWSC_VIRT_CABLE_UNPLUG_RSP:
+	case FWSC_VIRT_CABLE_PLUG_RSP | FWSC_RSP_NACK:
+	case FWSC_VIRT_CABLE_UNPLUG_RSP | FWSC_RSP_NACK:
+		return sizeof(pkt.hdr);
+
+	default:
+		return -1;
+	}
+}
+
+static inline void fill_plug_params(struct virt_plug_params *params,
+				    struct fwtty_port *port)
+{
+	u64 status_addr = port->rx_handler.offset;
+	u64 fifo_addr = port->rx_handler.offset + 4;
+	size_t fifo_len = port->rx_handler.length - 4;
+
+	params->status_hi = cpu_to_be32(status_addr >> 32);
+	params->status_lo = cpu_to_be32(status_addr);
+	params->fifo_hi = cpu_to_be32(fifo_addr >> 32);
+	params->fifo_lo = cpu_to_be32(fifo_addr);
+	params->fifo_len = cpu_to_be32(fifo_len);
+}
+
+static inline void fill_plug_req(struct fwserial_mgmt_pkt *pkt,
+				 struct fwtty_port *port)
+{
+	pkt->hdr.code = cpu_to_be16(FWSC_VIRT_CABLE_PLUG);
+	pkt->hdr.len = cpu_to_be16(mgmt_pkt_expected_len(pkt->hdr.code));
+	fill_plug_params(&pkt->plug_req, port);
+}
+
+static inline void fill_plug_rsp_ok(struct fwserial_mgmt_pkt *pkt,
+				    struct fwtty_port *port)
+{
+	pkt->hdr.code = cpu_to_be16(FWSC_VIRT_CABLE_PLUG_RSP);
+	pkt->hdr.len = cpu_to_be16(mgmt_pkt_expected_len(pkt->hdr.code));
+	fill_plug_params(&pkt->plug_rsp, port);
+}
+
+static inline void fill_plug_rsp_nack(struct fwserial_mgmt_pkt *pkt)
+{
+	pkt->hdr.code = cpu_to_be16(FWSC_VIRT_CABLE_PLUG_RSP | FWSC_RSP_NACK);
+	pkt->hdr.len = cpu_to_be16(mgmt_pkt_expected_len(pkt->hdr.code));
+}
+
+static inline void fill_unplug_req(struct fwserial_mgmt_pkt *pkt)
+{
+	pkt->hdr.code = cpu_to_be16(FWSC_VIRT_CABLE_UNPLUG);
+	pkt->hdr.len = cpu_to_be16(mgmt_pkt_expected_len(pkt->hdr.code));
+}
+
+static inline void fill_unplug_rsp_nack(struct fwserial_mgmt_pkt *pkt)
+{
+	pkt->hdr.code = cpu_to_be16(FWSC_VIRT_CABLE_UNPLUG_RSP | FWSC_RSP_NACK);
+	pkt->hdr.len = cpu_to_be16(mgmt_pkt_expected_len(pkt->hdr.code));
+}
+
+static inline void fill_unplug_rsp_ok(struct fwserial_mgmt_pkt *pkt)
+{
+	pkt->hdr.code = cpu_to_be16(FWSC_VIRT_CABLE_UNPLUG_RSP);
+	pkt->hdr.len = cpu_to_be16(mgmt_pkt_expected_len(pkt->hdr.code));
+}
+
+static void fwserial_virt_plug_complete(struct fwtty_peer *peer,
+					struct virt_plug_params *params)
+{
+	struct fwtty_port *port = peer->port;
+	int n;
+
+	peer->status_addr = be32_to_u64(params->status_hi, params->status_lo);
+	peer->fifo_addr = be32_to_u64(params->fifo_hi, params->fifo_lo);
+	peer->fifo_len = be32_to_cpu(params->fifo_len);
+	peer_set_state(peer, FWPS_ATTACHED);
+
+	/* reconfigure tx_fifo optimally for this peer */
+	spin_lock_bh(&port->lock);
+	n = min3(peer->max_payload, peer->fifo_len, MAX_ASYNC_PAYLOAD);
+	dma_fifo_change_tx_limit(&port->tx_fifo, n);
+	spin_unlock_bh(&peer->port->lock);
+
+	if (port->port.console && port->fwcon_ops->notify != NULL)
+		(*port->fwcon_ops->notify)(FWCON_NOTIFY_ATTACH, port->con_data);
+
+	dev_info(&peer->unit->device, "peer (guid:%016llx) connected on %s",
+		 (unsigned long long)peer->guid, dev_name(port->device));
+}
+
+static inline int fwserial_send_mgmt_sync(struct fwtty_peer *peer,
+					  struct fwserial_mgmt_pkt *pkt)
+{
+	int generation;
+	int rcode;
+
+	generation = peer->generation;
+	smp_rmb();
+
+	/* XXX: consider retries here */
+	rcode = fw_run_transaction(peer->fw_serial->card,
+				   TCODE_WRITE_BLOCK_REQUEST, peer->node_id,
+				   generation, peer->speed, peer->mgmt_addr,
+				   pkt, be16_to_cpu(pkt->hdr.len));
+	return rcode;
+}
+
+/**
+ * fwserial_claim_port - attempt to claim port @ index for peer
+ *
+ * Returns ptr to claimed port or error code (as ERR_PTR())
+ * Can sleep - must be called from process context
+ */
+static struct fwtty_port *fwserial_claim_port(struct fwtty_peer *peer,
+					      int index)
+{
+	struct fwtty_port *port;
+
+	if (index < 0 || index >= num_ports)
+		return ERR_PTR(-EINVAL);
+
+	/* must guarantee that previous port releases have completed */
+	synchronize_rcu();
+
+	port = peer->fw_serial->ports[index];
+	spin_lock_bh(&port->lock);
+	if (!rcu_access_pointer(port->peer))
+		rcu_assign_pointer(port->peer, peer);
+	else
+		port = ERR_PTR(-EBUSY);
+	spin_unlock_bh(&port->lock);
+
+	return port;
+}
+
+/**
+ * fwserial_find_port - find avail port and claim for peer
+ *
+ * Returns ptr to claimed port or NULL if none avail
+ * Can sleep - must be called from process context
+ */
+static struct fwtty_port *fwserial_find_port(struct fwtty_peer *peer)
+{
+	struct fwtty_port **ports = peer->fw_serial->ports;
+	int i;
+
+	/* must guarantee that previous port releases have completed */
+	synchronize_rcu();
+
+	/* TODO: implement optional GUID-to-specific port # matching */
+
+	/* find an unattached port (but not the loopback port, if present) */
+	for (i = 0; i < num_ttys; ++i) {
+		spin_lock_bh(&ports[i]->lock);
+		if (!ports[i]->peer) {
+			/* claim port */
+			rcu_assign_pointer(ports[i]->peer, peer);
+			spin_unlock_bh(&ports[i]->lock);
+			return ports[i];
+		}
+		spin_unlock_bh(&ports[i]->lock);
+	}
+	return NULL;
+}
+
+static void fwserial_release_port(struct fwtty_port *port)
+{
+	int n = link_speed_to_max_payload(SCODE_100);
+
+	/* drop carrier (and all other line status) */
+	fwtty_update_port_status(port, 0);
+
+	spin_lock_bh(&port->lock);
+
+	/* reset dma fifo max transmission size back to S100 */
+	dma_fifo_change_tx_limit(&port->tx_fifo, n);
+
+	rcu_assign_pointer(port->peer, NULL);
+	spin_unlock_bh(&port->lock);
+
+	if (port->port.console && port->fwcon_ops->notify != NULL)
+		(*port->fwcon_ops->notify)(FWCON_NOTIFY_DETACH, port->con_data);
+}
+
+static void fwserial_plug_timeout(unsigned long data)
+{
+	struct fwtty_peer *peer = (struct fwtty_peer *) data;
+	struct fwtty_port *port;
+
+	spin_lock_bh(&peer->lock);
+	if (peer->state != FWPS_PLUG_PENDING) {
+		spin_unlock_bh(&peer->lock);
+		return;
+	}
+
+	port = peer_revert_state(peer);
+	spin_unlock_bh(&peer->lock);
+
+	if (port)
+		fwserial_release_port(port);
+}
+
+/**
+ * fwserial_connect_peer - initiate virtual cable with peer
+ *
+ * Returns 0 if VIRT_CABLE_PLUG request was successfully sent,
+ * otherwise error code.  Must be called from process context.
+ */
+static int fwserial_connect_peer(struct fwtty_peer *peer)
+{
+	struct fwtty_port *port;
+	struct fwserial_mgmt_pkt *pkt;
+	int err, rcode;
+
+	port = fwserial_find_port(peer);
+	if (!port) {
+		dev_err(&peer->unit->device, "avail ports in use");
+		return -EBUSY;
+	}
+
+	spin_lock_bh(&peer->lock);
+
+	/* only initiate VIRT_CABLE_PLUG if peer is currently not attached */
+	if (peer->state != FWPS_NOT_ATTACHED) {
+		err = -EBUSY;
+		goto release_port;
+	}
+
+	peer->port = port;
+	peer_set_state(peer, FWPS_PLUG_PENDING);
+
+	pkt = kmalloc(sizeof(*pkt), GFP_KERNEL);
+	if (!pkt) {
+		err = -ENOMEM;
+		goto revert_state;
+	}
+	fill_plug_req(pkt, peer->port);
+
+	setup_timer(&peer->timer, fwserial_plug_timeout, (unsigned long)peer);
+	mod_timer(&peer->timer, jiffies + VIRT_CABLE_PLUG_TIMEOUT);
+	spin_unlock_bh(&peer->lock);
+
+	rcode = fwserial_send_mgmt_sync(peer, pkt);
+
+	spin_lock_bh(&peer->lock);
+	if (peer->state == FWPS_PLUG_PENDING && rcode != RCODE_COMPLETE) {
+		err = -EIO;
+		goto cancel_timer;
+	}
+	spin_unlock_bh(&peer->lock);
+
+	return 0;
+
+cancel_timer:
+	del_timer(&peer->timer);
+revert_state:
+	peer_revert_state(peer);
+release_port:
+	spin_unlock_bh(&peer->lock);
+	fwserial_release_port(port);
+	return err;
+}
+
+/**
+ * fwserial_close_port -
+ * HUP the tty (if the tty exists) and unregister the tty device.
+ * Only used by the unit driver upon unit removal to disconnect and
+ * cleanup all attached ports
+ *
+ * The port reference is put by fwtty_cleanup (if a reference was
+ * ever taken).
+ */
+static void fwserial_close_port(struct fwtty_port *port)
+{
+	struct tty_struct *tty;
+
+	mutex_lock(&port->port.mutex);
+	tty = tty_port_tty_get(&port->port);
+	if (tty) {
+		tty_vhangup(tty);
+		tty_kref_put(tty);
+	}
+	mutex_unlock(&port->port.mutex);
+
+	tty_unregister_device(fwtty_driver, port->index);
+}
+
+/**
+ * fwserial_lookup - finds first fw_serial associated with card
+ * @card: fw_card to match
+ *
+ * NB: caller must be holding fwserial_list_mutex
+ */
+static struct fw_serial *fwserial_lookup(struct fw_card *card)
+{
+	struct fw_serial *fw_serial;
+
+	list_for_each_entry(fw_serial, &fwserial_list, list) {
+		if (card == fw_serial->card)
+			return fw_serial;
+	}
+
+	return NULL;
+}
+
+/**
+ * __fwserial_lookup_rcu - finds first fw_serial associated with card
+ * @card: fw_card to match
+ *
+ * NB: caller must be inside rcu_read_lock() section
+ */
+static struct fw_serial *__fwserial_lookup_rcu(struct fw_card *card)
+{
+	struct fw_serial *fw_serial;
+
+	list_for_each_entry_rcu(fw_serial, &fwserial_list, list) {
+		if (card == fw_serial->card)
+			return fw_serial;
+	}
+
+	return NULL;
+}
+
+/**
+ * __fwserial_peer_by_node_id - finds a peer matching the given generation + id
+ *
+ * If a matching peer could not be found for the specified generation/node id,
+ * this could be because:
+ * a) the generation has changed and one of the nodes hasn't updated yet
+ * b) the remote node has created its remote unit device before this
+ *    local node has created its corresponding remote unit device
+ * In either case, the remote node should retry
+ *
+ * Note: caller must be in rcu_read_lock() section
+ */
+static struct fwtty_peer *__fwserial_peer_by_node_id(struct fw_card *card,
+						     int generation, int id)
+{
+	struct fw_serial *fw_serial;
+	struct fwtty_peer *peer;
+
+	fw_serial = __fwserial_lookup_rcu(card);
+	if (!fw_serial) {
+		/*
+		 * Something is very wrong - there should be a matching
+		 * fw_serial structure for every fw_card. Maybe the remote node
+		 * has created its remote unit device before this driver has
+		 * been probed for any unit devices...
+		 */
+		driver_err("unknown card (guid %016llx)",
+			   (unsigned long long) card->guid);
+		return NULL;
+	}
+
+	list_for_each_entry_rcu(peer, &fw_serial->peer_list, list) {
+		int g = peer->generation;
+		smp_rmb();
+		if (generation == g && id == peer->node_id)
+			return peer;
+	}
+
+	return NULL;
+}
+
+/**
+ * fwserial_add_peer - add a newly probed 'serial' unit device as a 'peer'
+ * @fw_serial: aggregate representing the specific fw_card to add the peer to
+ * @unit: 'peer' to create and add to peer_list of fw_serial
+ *
+ * Adds a 'peer' (ie, a local or remote 'serial' unit device) to the list of
+ * peers for a specific fw_card. Optionally, auto-attach this peer to an
+ * available tty port. This function is called either directly or indirectly
+ * as a result of a 'serial' unit device being created & probed.
+ *
+ * Note: this function is serialized with fwserial_remove_peer() by the
+ * fwserial_list_mutex held in fwserial_probe().
+ *
+ * A 1:1 correspondence between an fw_unit and an fwtty_peer is maintained
+ * via the dev_set_drvdata() for the device of the fw_unit.
+ */
+static int fwserial_add_peer(struct fw_serial *fw_serial, struct fw_unit *unit)
+{
+	struct device *dev = &unit->device;
+	struct fw_device  *parent = fw_parent_device(unit);
+	struct fwtty_peer *peer;
+	struct fw_csr_iterator ci;
+	int key, val;
+	int generation;
+
+	peer = kzalloc(sizeof(*peer), GFP_KERNEL);
+	if (!peer)
+		return -ENOMEM;
+
+	peer_set_state(peer, FWPS_NOT_ATTACHED);
+
+	dev_set_drvdata(dev, peer);
+	peer->unit = unit;
+	peer->guid = (u64)parent->config_rom[3] << 32 | parent->config_rom[4];
+	peer->speed = parent->max_speed;
+	peer->max_payload = min(device_max_receive(parent),
+				link_speed_to_max_payload(peer->speed));
+
+	generation = parent->generation;
+	smp_rmb();
+	peer->node_id = parent->node_id;
+	smp_wmb();
+	peer->generation = generation;
+
+	/* retrieve the mgmt bus addr from the unit directory */
+	fw_csr_iterator_init(&ci, unit->directory);
+	while (fw_csr_iterator_next(&ci, &key, &val)) {
+		if (key == (CSR_OFFSET | CSR_DEPENDENT_INFO)) {
+			peer->mgmt_addr = CSR_REGISTER_BASE + 4 * val;
+			break;
+		}
+	}
+	if (peer->mgmt_addr == 0ULL) {
+		/*
+		 * No mgmt address effectively disables VIRT_CABLE_PLUG -
+		 * this peer will not be able to attach to a remote
+		 */
+		peer_set_state(peer, FWPS_NO_MGMT_ADDR);
+	}
+
+	spin_lock_init(&peer->lock);
+	peer->port = NULL;
+
+	init_timer(&peer->timer);
+	INIT_WORK(&peer->work, NULL);
+
+	/* associate peer with specific fw_card */
+	peer->fw_serial = fw_serial;
+	list_add_rcu(&peer->list, &fw_serial->peer_list);
+
+	dev_info(&peer->unit->device, "peer added (guid:%016llx)",
+		 (unsigned long long)peer->guid);
+
+	/* identify the local unit & virt cable to loopback port */
+	if (parent->is_local) {
+		fw_serial->self = peer;
+		if (create_loop_dev) {
+			struct fwtty_port *port;
+			port = fwserial_claim_port(peer, num_ttys);
+			if (!IS_ERR(port)) {
+				struct virt_plug_params params;
+				unsigned status;
+
+				spin_lock_bh(&peer->lock);
+				peer->port = port;
+				fill_plug_params(&params, port);
+				fwserial_virt_plug_complete(peer, &params);
+				spin_unlock_bh(&peer->lock);
+
+				status = fwtty_port_line_status(port);
+				fwtty_write_port_status(port, status);
+			}
+		}
+
+	} else if (auto_connect) {
+		/* auto-attach to remote units only (if policy allows) */
+		fwserial_connect_peer(peer);
+	}
+
+	return 0;
+}
+
+/**
+ * fwserial_remove_peer - remove a 'serial' unit device as a 'peer'
+ *
+ * Remove a 'peer' from its list of peers. This function is only
+ * called by fwserial_remove() on bus removal of the unit device.
+ *
+ * Note: this function is serialized with fwserial_add_peer() by the
+ * fwserial_list_mutex held in fwserial_remove().
+ */
+static void fwserial_remove_peer(struct fwtty_peer *peer)
+{
+	struct fwtty_port *port;
+
+	spin_lock_bh(&peer->lock);
+	peer_set_state(peer, FWPS_GONE);
+
+	/* if this unit is the local unit, clear link */
+	if (peer == peer->fw_serial->self)
+		peer->fw_serial->self = NULL;
+
+	/* cancel the request timeout timer (if running) */
+	del_timer(&peer->timer);
+
+	/* cancel pending work */
+	cancel_work_sync(&peer->work);
+
+	port = peer->port;
+	peer->port = NULL;
+
+	list_del_rcu(&peer->list);
+
+	dev_info(&peer->unit->device, "peer removed (guid:%016llx)",
+		 (unsigned long long)peer->guid);
+
+	spin_unlock_bh(&peer->lock);
+
+	if (port)
+		fwserial_release_port(port);
+
+	synchronize_rcu();
+	kfree(peer);
+}
+
+/**
+ * create_loop_device - create a loopback tty device
+ * @tty_driver: tty_driver to own loopback device
+ * @prototype: ptr to already-assigned 'prototype' tty port
+ * @index: index to associate this device with the tty port
+ * @parent: device to child to
+ *
+ * HACK - this is basically tty_port_register_device() with an
+ * alternate naming scheme. Suggest tty_port_register_named_device()
+ * helper api.
+ *
+ * Creates a loopback tty device named 'fwloop<n>' which is attached to
+ * the local unit in fwserial_add_peer(). Note that <n> in the device
+ * name advances in increments of port allocation blocks, ie., for port
+ * indices 0..3, the device name will be 'fwloop0'; for 4..7, 'fwloop1',
+ * and so on.
+ *
+ * Only one loopback device should be created per fw_card.
+ */
+static void release_loop_device(struct device *dev)
+{
+	kfree(dev);
+}
+
+static struct device *create_loop_device(struct tty_driver *driver,
+					 struct fwtty_port *prototype,
+					 struct fwtty_port *port,
+					 struct device *parent)
+{
+	char name[64];
+	int index = port->index;
+	dev_t devt = MKDEV(driver->major, driver->minor_start) + index;
+	struct device *dev = NULL;
+	int err;
+
+	if (index >= fwtty_driver->num)
+		return ERR_PTR(-EINVAL);
+
+	snprintf(name, 64, "%s%d", loop_dev_name, index / num_ports);
+
+	tty_port_link_device(&port->port, driver, index);
+
+	cdev_init(&driver->cdevs[index], driver->cdevs[prototype->index].ops);
+	driver->cdevs[index].owner = driver->owner;
+	err = cdev_add(&driver->cdevs[index], devt, 1);
+	if (err)
+		return ERR_PTR(err);
+
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev) {
+		cdev_del(&driver->cdevs[index]);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	dev->devt = devt;
+	dev->class = prototype->device->class;
+	dev->parent = parent;
+	dev->release = release_loop_device;
+	dev_set_name(dev, "%s", name);
+	dev->groups = NULL;
+	dev_set_drvdata(dev, NULL);
+
+	err = device_register(dev);
+	if (err) {
+		put_device(dev);
+		cdev_del(&driver->cdevs[index]);
+		return ERR_PTR(err);
+	}
+
+	return dev;
+}
+
+/**
+ * fwserial_create - init everything to create TTYs for a specific fw_card
+ * @unit: fw_unit for first 'serial' unit device probed for this fw_card
+ *
+ * This function inits the aggregate structure (an fw_serial instance)
+ * used to manage the TTY ports registered by a specific fw_card. Also, the
+ * unit device is added as the first 'peer'.
+ *
+ * This unit device may represent a local unit device (as specified by the
+ * config ROM unit directory) or it may represent a remote unit device
+ * (as specified by the reading of the remote node's config ROM).
+ *
+ * Returns 0 to indicate "ownership" of the unit device, or a negative errno
+ * value to indicate which error.
+ */
+static int fwserial_create(struct fw_unit *unit)
+{
+	struct device *dev = &unit->device;
+	struct fw_device *parent = fw_parent_device(unit);
+	struct fw_card *card = parent->card;
+	struct fw_serial *fw_serial;
+	struct fwtty_port *port;
+	struct device *tty_dev;
+	int i, j;
+	int err;
+
+	fw_serial = kzalloc(sizeof(*fw_serial), GFP_KERNEL);
+	if (!fw_serial)
+		return -ENOMEM;
+
+	kref_init(&fw_serial->kref);
+	fw_serial->card = card;
+	INIT_LIST_HEAD(&fw_serial->peer_list);
+
+	for (i = 0; i < num_ports; ++i) {
+		port = kzalloc(sizeof(*port), GFP_KERNEL);
+		if (!port) {
+			err = -ENOMEM;
+			goto free_ports;
+		}
+		tty_port_init(&port->port);
+		port->index = FWTTY_INVALID_INDEX;
+		port->port.ops = &fwtty_port_ops;
+		port->fw_serial = fw_serial;
+
+		spin_lock_init(&port->lock);
+		INIT_DELAYED_WORK(&port->drain, fwtty_drain_tx);
+		INIT_DELAYED_WORK(&port->emit_breaks, fwtty_emit_breaks);
+		INIT_WORK(&port->hangup, fwtty_do_hangup);
+		init_waitqueue_head(&port->wait_tx);
+		err = dma_fifo_alloc(&port->tx_fifo, FWTTY_PORT_TXFIFO_LEN,
+				     cache_line_size(),
+				     link_speed_to_max_payload(SCODE_100),
+				     FWTTY_PORT_MAX_PEND_DMA,
+				     GFP_KERNEL);
+		if (err) {
+			kfree(port);
+			goto free_ports;
+		}
+
+		rcu_assign_pointer(port->peer, NULL);
+		fw_serial->ports[i] = port;
+
+		/* get unique bus addr region for port's status & recv fifo */
+		port->rx_handler.length = FWTTY_PORT_RXFIFO_LEN + 4;
+		port->rx_handler.address_callback = fwtty_port_handler;
+		port->rx_handler.callback_data = port;
+		/*
+		 * XXX: use custom memory region above cpu physical memory addrs
+		 * this will ease porting to 64-bit firewire adapters
+		 */
+		err = fw_core_add_address_handler(&port->rx_handler,
+						  &fw_high_memory_region);
+		if (err) {
+			dma_fifo_free(&port->tx_fifo);
+			kfree(port);
+			goto free_ports;
+		}
+	}
+	/* preserve i for error cleanup */
+
+	err = fwtty_ports_add(fw_serial);
+	if (err) {
+		dev_err(dev, "no space in port table");
+		goto free_ports;
+	}
+
+	for (j = 0; j < num_ttys; ++j) {
+		tty_dev = tty_port_register_device(&fw_serial->ports[j]->port,
+						   fwtty_driver,
+						   fw_serial->ports[j]->index,
+						   card->device);
+		if (IS_ERR(tty_dev)) {
+			err = PTR_ERR(tty_dev);
+			dev_err(dev, "register tty device failed (%d)", err);
+			goto unregister_ttys;
+		}
+
+		fw_serial->ports[j]->device = tty_dev;
+	}
+	/* preserve j for error cleanup */
+
+	if (create_loop_dev) {
+		struct device *loop_dev;
+
+		loop_dev = create_loop_device(fwtty_driver,
+					      fw_serial->ports[0],
+					      fw_serial->ports[num_ttys],
+					      card->device);
+		if (IS_ERR(loop_dev)) {
+			err = PTR_ERR(loop_dev);
+			dev_err(dev, "failed creating loop device (%d)", err);
+			goto unregister_ttys;
+		}
+		fw_serial->ports[num_ttys]->device = loop_dev;
+		fw_serial->ports[num_ttys]->loopback = true;
+	}
+
+	list_add_rcu(&fw_serial->list, &fwserial_list);
+
+	dev_notice(dev, "TTY over FireWire on device %s (guid %016llx)",
+		   dev_name(card->device), (unsigned long long) card->guid);
+
+	err = fwserial_add_peer(fw_serial, unit);
+	if (!err)
+		return 0;
+
+	dev_err(dev, "unable to add peer unit device (%d)", err);
+
+	/* fall-through to error processing */
+	list_del_rcu(&fw_serial->list);
+unregister_ttys:
+	for (--j; j >= 0; --j)
+		tty_unregister_device(fwtty_driver, fw_serial->ports[j]->index);
+	kref_put(&fw_serial->kref, fwserial_destroy);
+	return err;
+
+free_ports:
+	for (--i; i >= 0; --i)
+		kfree(fw_serial->ports[i]);
+	kfree(fw_serial);
+	return err;
+}
+
+/**
+ * fwserial_probe: bus probe function for firewire 'serial' unit devices
+ *
+ * A 'serial' unit device is created and probed as a result of:
+ * - declaring a ieee1394 bus id table for 'devices' matching a fabricated
+ *   'serial' unit specifier id
+ * - adding a unit directory to the config ROM(s) for a 'serial' unit
+ *
+ * The firewire core registers unit devices by enumerating unit directories
+ * of a node's config ROM after reading the config ROM when a new node is
+ * added to the bus topology after a bus reset.
+ *
+ * The practical implications of this are:
+ * - this probe is called for both local and remote nodes that have a 'serial'
+ *   unit directory in their config ROM (that matches the specifiers in
+ *   fwserial_id_table).
+ * - no specific order is enforced for local vs. remote unit devices
+ *
+ * This unit driver copes with the lack of specific order in the same way the
+ * firewire net driver does -- each probe, for either a local or remote unit
+ * device, is treated as a 'peer' (has a struct fwtty_peer instance) and the
+ * first peer created for a given fw_card (tracked by the global fwserial_list)
+ * creates the underlying TTYs (aggregated in a fw_serial instance).
+ *
+ * NB: an early attempt to differentiate local & remote unit devices by creating
+ *     peers only for remote units and fw_serial instances (with their
+ *     associated TTY devices) only for local units was discarded. Managing
+ *     the peer lifetimes on device removal proved too complicated.
+ *
+ * fwserial_probe/fwserial_remove are effectively serialized by the
+ * fwserial_list_mutex. This is necessary because the addition of the first peer
+ * for a given fw_card will trigger the creation of the fw_serial for that
+ * fw_card, which must not simultaneously contend with the removal of the
+ * last peer for a given fw_card triggering the destruction of the same
+ * fw_serial for the same fw_card.
+ */
+static int fwserial_probe(struct device *dev)
+{
+	struct fw_unit *unit = fw_unit(dev);
+	struct fw_serial *fw_serial;
+	int err;
+
+	mutex_lock(&fwserial_list_mutex);
+	fw_serial = fwserial_lookup(fw_parent_device(unit)->card);
+	if (!fw_serial)
+		err = fwserial_create(unit);
+	else
+		err = fwserial_add_peer(fw_serial, unit);
+	mutex_unlock(&fwserial_list_mutex);
+	return err;
+}
+
+/**
+ * fwserial_remove: bus removal function for firewire 'serial' unit devices
+ *
+ * The corresponding 'peer' for this unit device is removed from the list of
+ * peers for the associated fw_serial (which has a 1:1 correspondence with a
+ * specific fw_card). If this is the last peer being removed, then trigger
+ * the destruction of the underlying TTYs.
+ */
+static int fwserial_remove(struct device *dev)
+{
+	struct fwtty_peer *peer = dev_get_drvdata(dev);
+	struct fw_serial *fw_serial = peer->fw_serial;
+	int i;
+
+	mutex_lock(&fwserial_list_mutex);
+	fwserial_remove_peer(peer);
+
+	if (list_empty(&fw_serial->peer_list)) {
+		/* unlink from the fwserial_list here */
+		list_del_rcu(&fw_serial->list);
+
+		for (i = 0; i < num_ports; ++i)
+			fwserial_close_port(fw_serial->ports[i]);
+		kref_put(&fw_serial->kref, fwserial_destroy);
+	}
+	mutex_unlock(&fwserial_list_mutex);
+
+	return 0;
+}
+
+/**
+ * fwserial_update: bus update function for 'firewire' serial unit devices
+ *
+ * Updates the new node_id and bus generation for this peer. Note that locking
+ * is unnecessary; but careful memory barrier usage is important to enforce the
+ * load and store order of generation & node_id.
+ *
+ * The fw-core orders the write of node_id before generation in the parent
+ * fw_device to ensure that a stale node_id cannot be used with a current
+ * bus generation. So the generation value must be read before the node_id.
+ *
+ * In turn, this orders the write of node_id before generation in the peer to
+ * also ensure a stale node_id cannot be used with a current bus generation.
+ */
+static void fwserial_update(struct fw_unit *unit)
+{
+	struct fw_device *parent = fw_parent_device(unit);
+	struct fwtty_peer *peer = dev_get_drvdata(&unit->device);
+	int generation;
+
+	generation = parent->generation;
+	smp_rmb();
+	peer->node_id = parent->node_id;
+	smp_wmb();
+	peer->generation = generation;
+}
+
+static const struct ieee1394_device_id fwserial_id_table[] = {
+	{
+		.match_flags  = IEEE1394_MATCH_SPECIFIER_ID |
+				IEEE1394_MATCH_VERSION,
+		.specifier_id = LINUX_VENDOR_ID,
+		.version      = FWSERIAL_VERSION,
+	},
+	{ }
+};
+
+static struct fw_driver fwserial_driver = {
+	.driver = {
+		.owner  = THIS_MODULE,
+		.name   = KBUILD_MODNAME,
+		.bus    = &fw_bus_type,
+		.probe  = fwserial_probe,
+		.remove = fwserial_remove,
+	},
+	.update   = fwserial_update,
+	.id_table = fwserial_id_table,
+};
+
+#define FW_UNIT_SPECIFIER(id)	((CSR_SPECIFIER_ID << 24) | (id))
+#define FW_UNIT_VERSION(ver)	((CSR_VERSION << 24) | (ver))
+#define FW_UNIT_ADDRESS(ofs)	(((CSR_OFFSET | CSR_DEPENDENT_INFO) << 24)  \
+				 | (((ofs) - CSR_REGISTER_BASE) >> 2))
+/* XXX: config ROM definitons could be improved with semi-automated offset
+ * and length calculation
+ */
+#define FW_ROM_DESCRIPTOR(ofs)	(((CSR_LEAF | CSR_DESCRIPTOR) << 24) | (ofs))
+
+struct fwserial_unit_directory_data {
+	u16	crc;
+	u16	len;
+	u32	unit_specifier;
+	u32	unit_sw_version;
+	u32	unit_addr_offset;
+	u32	desc1_ofs;
+	u16	desc1_crc;
+	u16	desc1_len;
+	u32	desc1_data[5];
+} __packed;
+
+static struct fwserial_unit_directory_data fwserial_unit_directory_data = {
+	.len = 4,
+	.unit_specifier = FW_UNIT_SPECIFIER(LINUX_VENDOR_ID),
+	.unit_sw_version = FW_UNIT_VERSION(FWSERIAL_VERSION),
+	.desc1_ofs = FW_ROM_DESCRIPTOR(1),
+	.desc1_len = 5,
+	.desc1_data = {
+		0x00000000,			/*   type = text            */
+		0x00000000,			/*   enc = ASCII, lang EN   */
+		0x4c696e75,			/* 'Linux TTY'              */
+		0x78205454,
+		0x59000000,
+	},
+};
+
+static struct fw_descriptor fwserial_unit_directory = {
+	.length = sizeof(fwserial_unit_directory_data) / sizeof(u32),
+	.key    = (CSR_DIRECTORY | CSR_UNIT) << 24,
+	.data   = (u32 *)&fwserial_unit_directory_data,
+};
+
+/*
+ * The management address is in the unit space region but above other known
+ * address users (to keep wild writes from causing havoc)
+ */
+const struct fw_address_region fwserial_mgmt_addr_region = {
+	.start = CSR_REGISTER_BASE + 0x1e0000ULL,
+	.end = 0x1000000000000ULL,
+};
+
+static struct fw_address_handler fwserial_mgmt_addr_handler;
+
+/**
+ * fwserial_handle_plug_req - handle VIRT_CABLE_PLUG request work
+ * @work: ptr to peer->work
+ *
+ * Attempts to complete the VIRT_CABLE_PLUG handshake sequence for this peer.
+ *
+ * This checks for a collided request-- ie, that a VIRT_CABLE_PLUG request was
+ * already sent to this peer. If so, the collision is resolved by comparing
+ * guid values; the loser sends the plug response.
+ *
+ * Note: if an error prevents a response, don't do anything -- the
+ * remote will timeout its request.
+ */
+static void fwserial_handle_plug_req(struct work_struct *work)
+{
+	struct fwtty_peer *peer = container_of(work, struct fwtty_peer, work);
+	struct virt_plug_params *plug_req = &peer->work_params.plug_req;
+	struct fwtty_port *port;
+	struct fwserial_mgmt_pkt *pkt;
+	int rcode;
+
+	pkt = kmalloc(sizeof(*pkt), GFP_KERNEL);
+	if (!pkt)
+		return;
+
+	port = fwserial_find_port(peer);
+
+	spin_lock_bh(&peer->lock);
+
+	switch (peer->state) {
+	case FWPS_NOT_ATTACHED:
+		if (!port) {
+			dev_err(&peer->unit->device, "no more ports avail");
+			fill_plug_rsp_nack(pkt);
+		} else {
+			peer->port = port;
+			fill_plug_rsp_ok(pkt, peer->port);
+			peer_set_state(peer, FWPS_PLUG_RESPONDING);
+			/* don't release claimed port */
+			port = NULL;
+		}
+		break;
+
+	case FWPS_PLUG_PENDING:
+		if (peer->fw_serial->card->guid > peer->guid)
+			goto cleanup;
+
+		/* We lost - hijack the already-claimed port and send ok */
+		del_timer(&peer->timer);
+		fill_plug_rsp_ok(pkt, peer->port);
+		peer_set_state(peer, FWPS_PLUG_RESPONDING);
+		break;
+
+	default:
+		fill_plug_rsp_nack(pkt);
+	}
+
+	spin_unlock_bh(&peer->lock);
+	if (port)
+		fwserial_release_port(port);
+
+	rcode = fwserial_send_mgmt_sync(peer, pkt);
+
+	spin_lock_bh(&peer->lock);
+	if (peer->state == FWPS_PLUG_RESPONDING) {
+		if (rcode == RCODE_COMPLETE) {
+			struct fwtty_port *tmp = peer->port;
+			unsigned status;
+
+			fwserial_virt_plug_complete(peer, plug_req);
+			spin_unlock_bh(&peer->lock);
+			/*
+			 * Send the port status without the peer lock
+			 * - when in loopback, the fw core address dispatcher
+			 * thinks it's in softirq (it isn't), so the
+			 * spin_unlock_bh() WARNS that irqs are disabled if
+			 * holding the peer lock
+			 */
+			status = fwtty_port_line_status(tmp);
+			fwtty_write_port_status(tmp, status);
+			spin_lock_bh(&peer->lock);
+		} else {
+			dev_err(&peer->unit->device,
+				"VIRT_CABLE_PLUG_RSP error (%d)", rcode);
+			port = peer_revert_state(peer);
+		}
+	}
+cleanup:
+	spin_unlock_bh(&peer->lock);
+	if (port)
+		fwserial_release_port(port);
+	kfree(pkt);
+	return;
+}
+
+static void fwserial_handle_unplug_req(struct work_struct *work)
+{
+	struct fwtty_peer *peer = container_of(work, struct fwtty_peer, work);
+	struct fwtty_port *port = NULL;
+	struct fwserial_mgmt_pkt *pkt;
+	int rcode;
+
+	pkt = kmalloc(sizeof(*pkt), GFP_KERNEL);
+	if (!pkt)
+		return;
+
+	spin_lock_bh(&peer->lock);
+
+	switch (peer->state) {
+	case FWPS_ATTACHED:
+		fill_unplug_rsp_ok(pkt);
+		peer_set_state(peer, FWPS_UNPLUG_RESPONDING);
+		break;
+
+	case FWPS_UNPLUG_PENDING:
+		if (peer->fw_serial->card->guid > peer->guid)
+			goto cleanup;
+
+		/* We lost - send unplug rsp */
+		del_timer(&peer->timer);
+		fill_unplug_rsp_ok(pkt);
+		peer_set_state(peer, FWPS_UNPLUG_RESPONDING);
+		break;
+
+	default:
+		fill_unplug_rsp_nack(pkt);
+	}
+
+	spin_unlock_bh(&peer->lock);
+
+	rcode = fwserial_send_mgmt_sync(peer, pkt);
+
+	spin_lock_bh(&peer->lock);
+	if (peer->state == FWPS_UNPLUG_RESPONDING) {
+		if (rcode == RCODE_COMPLETE)
+			port = peer_revert_state(peer);
+		else {
+			dev_err(&peer->unit->device,
+				"VIRT_CABLE_UNPLUG_RSP error (%d)", rcode);
+		}
+	}
+cleanup:
+	spin_unlock_bh(&peer->lock);
+	if (port)
+		fwserial_release_port(port);
+	kfree(pkt);
+	return;
+}
+
+static int fwserial_parse_mgmt_write(struct fwtty_peer *peer,
+				     struct fwserial_mgmt_pkt *pkt,
+				     unsigned long long addr,
+				     size_t len)
+{
+	struct fwtty_port *port = NULL;
+	int rcode;
+
+	if (addr != fwserial_mgmt_addr_handler.offset || len < sizeof(pkt->hdr))
+		return RCODE_ADDRESS_ERROR;
+
+	if (len != be16_to_cpu(pkt->hdr.len) ||
+	    len != mgmt_pkt_expected_len(pkt->hdr.code))
+		return RCODE_DATA_ERROR;
+
+	spin_lock_bh(&peer->lock);
+	if (peer->state == FWPS_GONE) {
+		/*
+		 * This should never happen - it would mean that the
+		 * remote unit that just wrote this transaction was
+		 * already removed from the bus -- and the removal was
+		 * processed before we rec'd this transaction
+		 */
+		dev_err(&peer->unit->device, "peer already removed");
+		spin_unlock_bh(&peer->lock);
+		return RCODE_ADDRESS_ERROR;
+	}
+
+	rcode = RCODE_COMPLETE;
+
+	dev_dbg(&peer->unit->device, "mgmt: hdr.code: %04hx", pkt->hdr.code);
+
+	switch (be16_to_cpu(pkt->hdr.code) & FWSC_CODE_MASK) {
+	case FWSC_VIRT_CABLE_PLUG:
+		if (work_pending(&peer->work)) {
+			dev_err(&peer->unit->device, "plug req: busy");
+			rcode = RCODE_CONFLICT_ERROR;
+
+		} else {
+			peer->work_params.plug_req = pkt->plug_req;
+			PREPARE_WORK(&peer->work, fwserial_handle_plug_req);
+			queue_work(system_unbound_wq, &peer->work);
+		}
+		break;
+
+	case FWSC_VIRT_CABLE_PLUG_RSP:
+		if (peer->state != FWPS_PLUG_PENDING) {
+			rcode = RCODE_CONFLICT_ERROR;
+
+		} else if (be16_to_cpu(pkt->hdr.code) & FWSC_RSP_NACK) {
+			dev_notice(&peer->unit->device, "NACK plug rsp");
+			port = peer_revert_state(peer);
+
+		} else {
+			struct fwtty_port *tmp = peer->port;
+			unsigned status;
+
+			fwserial_virt_plug_complete(peer, &pkt->plug_rsp);
+			spin_unlock_bh(&peer->lock);
+			/* See fwserial_handle_plug_req() for why unlocked */
+			status = fwtty_port_line_status(tmp);
+			fwtty_write_port_status(tmp, status);
+			spin_lock_bh(&peer->lock);
+		}
+		break;
+
+	case FWSC_VIRT_CABLE_UNPLUG:
+		if (work_pending(&peer->work)) {
+			dev_err(&peer->unit->device, "unplug req: busy");
+			rcode = RCODE_CONFLICT_ERROR;
+		} else {
+			PREPARE_WORK(&peer->work, fwserial_handle_unplug_req);
+			queue_work(system_unbound_wq, &peer->work);
+		}
+		break;
+
+	case FWSC_VIRT_CABLE_UNPLUG_RSP:
+		if (peer->state != FWPS_UNPLUG_PENDING)
+			rcode = RCODE_CONFLICT_ERROR;
+		else {
+			if (be16_to_cpu(pkt->hdr.code) & FWSC_RSP_NACK)
+				dev_notice(&peer->unit->device, "NACK unplug?");
+			port = peer_revert_state(peer);
+		}
+		break;
+
+	default:
+		dev_err(&peer->unit->device, "unknown mgmt code %d",
+			be16_to_cpu(pkt->hdr.code));
+		rcode = RCODE_DATA_ERROR;
+	}
+	spin_unlock_bh(&peer->lock);
+
+	if (port)
+		fwserial_release_port(port);
+
+	return rcode;
+}
+
+/**
+ * fwserial_mgmt_handler: bus address handler for mgmt requests
+ * @parameters: fw_address_callback_t as specified by firewire core interface
+ *
+ * This handler is responsible for handling virtual cable requests from remotes
+ * for all cards.
+ */
+static void fwserial_mgmt_handler(struct fw_card *card,
+				  struct fw_request *request,
+				  int tcode, int destination, int source,
+				  int generation,
+				  unsigned long long addr,
+				  void *data, size_t len,
+				  void *callback_data)
+{
+	struct fwserial_mgmt_pkt *pkt = data;
+	struct fwtty_peer *peer;
+	int rcode;
+
+	rcu_read_lock();
+	peer = __fwserial_peer_by_node_id(card, generation, source);
+	if (!peer) {
+		driver_err("peer(%d:%x) not found", generation, source);
+		rcode = RCODE_CONFLICT_ERROR;
+
+	} else {
+		switch (tcode) {
+		case TCODE_WRITE_BLOCK_REQUEST:
+			rcode = fwserial_parse_mgmt_write(peer, pkt, addr, len);
+			break;
+
+		default:
+			rcode = RCODE_TYPE_ERROR;
+		}
+	}
+
+	rcu_read_unlock();
+	fw_send_response(card, request, rcode);
+}
+
+static int __init fwserial_init(void)
+{
+	int err, num_loops = !!(create_loop_dev);
+
+	/* num_ttys/num_ports must not be set above the static alloc avail */
+	if (num_ttys + num_loops > MAX_CARD_PORTS)
+		num_ttys = MAX_CARD_PORTS - num_loops;
+	num_ports = num_ttys + num_loops;
+
+	fwtty_driver = alloc_tty_driver(MAX_TOTAL_PORTS);
+	if (!fwtty_driver) {
+		err = -ENOMEM;
+		return err;
+	}
+
+	fwtty_driver->driver_name	= KBUILD_MODNAME;
+	fwtty_driver->name		= tty_dev_name;
+	fwtty_driver->major		= 0;
+	fwtty_driver->minor_start	= 0;
+	fwtty_driver->type		= TTY_DRIVER_TYPE_SERIAL;
+	fwtty_driver->subtype		= SERIAL_TYPE_NORMAL;
+	fwtty_driver->flags		= TTY_DRIVER_REAL_RAW |
+						TTY_DRIVER_DYNAMIC_DEV;
+
+	fwtty_driver->init_termios	    = tty_std_termios;
+	fwtty_driver->init_termios.c_cflag  |= CLOCAL;
+	tty_set_operations(fwtty_driver, &fwtty_ops);
+
+	err = tty_register_driver(fwtty_driver);
+	if (err) {
+		driver_err("register tty driver failed (%d)", err);
+		goto put_tty;
+	}
+
+	fwtty_txn_cache = kmem_cache_create("fwtty_txn_cache",
+					    sizeof(struct fwtty_transaction),
+					    0, 0, fwtty_txn_constructor);
+	if (!fwtty_txn_cache) {
+		err = -ENOMEM;
+		goto unregister_driver;
+	}
+
+	/*
+	 * Ideally, this address handler would be registered per local node
+	 * (rather than the same handler for all local nodes). However,
+	 * since the firewire core requires the config rom descriptor *before*
+	 * the local unit device(s) are created, a single management handler
+	 * must suffice for all local serial units.
+	 */
+	fwserial_mgmt_addr_handler.length = sizeof(struct fwserial_mgmt_pkt);
+	fwserial_mgmt_addr_handler.address_callback = fwserial_mgmt_handler;
+
+	err = fw_core_add_address_handler(&fwserial_mgmt_addr_handler,
+					  &fwserial_mgmt_addr_region);
+	if (err) {
+		driver_err("add management handler failed (%d)", err);
+		goto destroy_cache;
+	}
+
+	fwserial_unit_directory_data.unit_addr_offset =
+		FW_UNIT_ADDRESS(fwserial_mgmt_addr_handler.offset);
+	err = fw_core_add_descriptor(&fwserial_unit_directory);
+	if (err) {
+		driver_err("add unit descriptor failed (%d)", err);
+		goto remove_handler;
+	}
+
+	err = driver_register(&fwserial_driver.driver);
+	if (err) {
+		driver_err("register fwserial driver failed (%d)", err);
+		goto remove_descriptor;
+	}
+
+	return 0;
+
+remove_descriptor:
+	fw_core_remove_descriptor(&fwserial_unit_directory);
+remove_handler:
+	fw_core_remove_address_handler(&fwserial_mgmt_addr_handler);
+destroy_cache:
+	kmem_cache_destroy(fwtty_txn_cache);
+unregister_driver:
+	tty_unregister_driver(fwtty_driver);
+put_tty:
+	put_tty_driver(fwtty_driver);
+	return err;
+}
+
+static void __exit fwserial_exit(void)
+{
+	driver_unregister(&fwserial_driver.driver);
+	fw_core_remove_descriptor(&fwserial_unit_directory);
+	fw_core_remove_address_handler(&fwserial_mgmt_addr_handler);
+	kmem_cache_destroy(fwtty_txn_cache);
+	tty_unregister_driver(fwtty_driver);
+	put_tty_driver(fwtty_driver);
+}
+
+module_init(fwserial_init);
+module_exit(fwserial_exit);
+
+MODULE_AUTHOR("Peter Hurley (peter@hurleysoftware.com)");
+MODULE_DESCRIPTION("FireWire Serial TTY Driver");
+MODULE_LICENSE("GPL");
+MODULE_DEVICE_TABLE(ieee1394, fwserial_id_table);
+MODULE_PARM_DESC(ttys, "Number of ttys to create for each local firewire node");
+MODULE_PARM_DESC(auto, "Auto-connect a tty to each firewire node discovered");
+MODULE_PARM_DESC(loop, "Create a loopback device, fwloop<n>, with ttys");
+MODULE_PARM_DESC(limit_bw, "Limit bandwidth utilization to 20%. Plays nice "
+			   "with bandwidth-sensitive firewire devices");
diff --git a/drivers/staging/fwserial/fwserial.h b/drivers/staging/fwserial/fwserial.h
new file mode 100644
index 0000000..ded7f67
--- /dev/null
+++ b/drivers/staging/fwserial/fwserial.h
@@ -0,0 +1,355 @@
+#ifndef _FIREWIRE_FWSERIAL_H
+#define _FIREWIRE_FWSERIAL_H
+
+#include <linux/kernel.h>
+#include <linux/tty.h>
+#include <linux/tty_driver.h>
+#include <linux/tty_flip.h>
+#include <linux/list.h>
+#include <linux/firewire.h>
+#include <linux/firewire-constants.h>
+#include <linux/spinlock.h>
+#include <linux/rcupdate.h>
+#include <linux/mutex.h>
+#include <linux/serial.h>
+#include <linux/serial_reg.h>
+#include <linux/module.h>
+#include <linux/seq_file.h>
+
+#include "dma_fifo.h"
+
+#ifdef FWTTY_PROFILING
+#define DISTRIBUTION_MAX_SIZE     8192
+#define DISTRIBUTION_MAX_INDEX    (ilog2(DISTRIBUTION_MAX_SIZE) + 1)
+static inline void profile_size_distrib(unsigned stat[], unsigned val)
+{
+	int n = (val) ? min(ilog2(val) + 1, DISTRIBUTION_MAX_INDEX) : 0;
+	++stat[n];
+}
+#else
+#define DISTRIBUTION_MAX_INDEX    0
+#define profile_size_distrib(st, n)
+#endif
+
+/* Parameters for both VIRT_CABLE_PLUG & VIRT_CABLE_PLUG_RSP mgmt codes */
+struct virt_plug_params {
+	__be32  status_hi;
+	__be32  status_lo;
+	__be32	fifo_hi;
+	__be32	fifo_lo;
+	__be32	fifo_len;
+};
+
+struct peer_work_params {
+	union {
+		struct virt_plug_params plug_req;
+	};
+};
+
+/**
+ * fwtty_peer: structure representing local & remote unit devices
+ * @unit: unit child device of fw_device node
+ * @fw_serial: back pointer to associated fw_serial aggregate
+ * @guid: unique 64-bit guid for this unit device
+ * @generation: most recent bus generation
+ * @node_id: most recent node_id
+ * @speed: link speed of peer (0 = S100, 2 = S400, ... 5 = S3200)
+ * @mgmt_addr: bus addr region to write mgmt packets to
+ * @status_addr: bus addr register to write line status to
+ * @fifo_addr: bus addr region to write serial output to
+ * @fifo_len:  max length for single write to fifo_addr
+ * @list: link for insertion into fw_serial's peer_list
+ * @rcu: for deferring peer reclamation
+ * @lock: spinlock to synchonize changes to state & port fields
+ * @work: only one work item can be queued at any one time
+ *        Note: pending work is canceled prior to removal, so this
+ *        peer is valid for at least the lifetime of the work function
+ * @work_params: parameter block for work functions
+ * @timer: timer for resetting peer state if remote request times out
+ * @state: current state
+ * @port: associated tty_port (usable if state == FWSC_ATTACHED)
+ */
+struct fwtty_peer {
+	struct fw_unit		*unit;
+	struct fw_serial	*fw_serial;
+	u64			guid;
+	int			generation;
+	int			node_id;
+	unsigned		speed;
+	int			max_payload;
+	u64			mgmt_addr;
+
+	/* these are usable only if state == FWSC_ATTACHED */
+	u64			status_addr;
+	u64			fifo_addr;
+	int			fifo_len;
+
+	struct list_head	list;
+	struct rcu_head		rcu;
+
+	spinlock_t		lock;
+	struct work_struct	work;
+	struct peer_work_params work_params;
+	struct timer_list	timer;
+	int			state;
+
+	struct fwtty_port	*port;
+};
+
+/* state values for fwtty_peer.state field */
+enum fwtty_peer_state {
+	FWPS_GONE,
+	FWPS_NOT_ATTACHED,
+	FWPS_ATTACHED,
+	FWPS_PLUG_PENDING,
+	FWPS_PLUG_RESPONDING,
+	FWPS_UNPLUG_PENDING,
+	FWPS_UNPLUG_RESPONDING,
+
+	FWPS_NO_MGMT_ADDR = -1,
+};
+
+/* must be holding peer lock for these state funclets */
+static inline void peer_set_state(struct fwtty_peer *peer, int new)
+{
+	peer->state = new;
+}
+
+static inline struct fwtty_port *peer_revert_state(struct fwtty_peer *peer)
+{
+	struct fwtty_port *port = peer->port;
+
+	peer->port = NULL;
+	peer_set_state(peer, FWPS_NOT_ATTACHED);
+	return port;
+}
+
+struct fwserial_mgmt_pkt {
+	struct {
+		__be16		len;
+		__be16		code;
+	} hdr;
+	union {
+		struct virt_plug_params plug_req;
+		struct virt_plug_params plug_rsp;
+	};
+} __packed;
+
+/* fwserial_mgmt_packet codes */
+#define FWSC_RSP_OK			0x0000
+#define FWSC_RSP_NACK			0x8000
+#define FWSC_CODE_MASK			0x0fff
+
+#define FWSC_VIRT_CABLE_PLUG		1
+#define FWSC_VIRT_CABLE_UNPLUG		2
+#define FWSC_VIRT_CABLE_PLUG_RSP	3
+#define FWSC_VIRT_CABLE_UNPLUG_RSP	4
+
+/* 1 min. plug timeout -- suitable for userland authorization */
+#define VIRT_CABLE_PLUG_TIMEOUT		(60 * HZ)
+
+struct stats {
+	unsigned	xchars;
+	unsigned	dropped;
+	unsigned	tx_stall;
+	unsigned	fifo_errs;
+	unsigned	sent;
+	unsigned	lost;
+	unsigned	throttled;
+	unsigned	writes[DISTRIBUTION_MAX_INDEX + 1];
+	unsigned	txns[DISTRIBUTION_MAX_INDEX + 1];
+	unsigned	unthrottle[DISTRIBUTION_MAX_INDEX + 1];
+};
+
+struct fwconsole_ops {
+	void (*notify)(int code, void *data);
+	void (*stats)(struct stats *stats, void *data);
+	void (*proc_show)(struct seq_file *m, void *data);
+};
+
+/* codes for console ops notify */
+#define FWCON_NOTIFY_ATTACH		1
+#define FWCON_NOTIFY_DETACH		2
+
+/**
+ * fwtty_port: structure used to track/represent underlying tty_port
+ * @port: underlying tty_port
+ * @device: tty device
+ * @index: index into port_table for this particular port
+ *    note: minor = index + FWSERIAL_TTY_START_MINOR
+ * @fw_serial: back pointer to the containing fw_serial
+ * @rx_handler: bus address handler for unique addr region used by remotes
+ *              to communicate with this port. Every port uses
+ *		fwtty_port_handler() for per port transactions.
+ * @fwcon_ops: ops for attached fw_console (if any)
+ * @con_data: private data for fw_console
+ * @wait_tx: waitqueue for sleeping until writer/drain completes tx
+ * @emit_breaks: delayed work responsible for generating breaks when the
+ *               break line status is active
+ * @cps : characters per second computed from the termios settings
+ * @break_last: timestamp in jiffies from last emit_breaks
+ * @hangup: work responsible for HUPing when carrier is dropped/lost
+ * @mstatus: loose virtualization of LSR/MSR
+ *         bits 15..0  correspond to TIOCM_* bits
+ *         bits 19..16 reserved for mctrl
+ *         bit 20      OOB_TX_THROTTLE
+ *	   bits 23..21 reserved
+ *         bits 31..24 correspond to UART_LSR_* bits
+ * @lock: spinlock for protecting concurrent access to fields below it
+ * @mctrl: loose virtualization of MCR
+ *         bits 15..0  correspond to TIOCM_* bits
+ *         bit 16      OOB_RX_THROTTLE
+ *         bits 19..17 reserved
+ *	   bits 31..20 reserved for mstatus
+ * @drain: delayed work scheduled to ensure that writes are flushed.
+ *         The work can race with the writer but concurrent sending is
+ *         prevented with the IN_TX flag. Scheduled under lock to
+ *         limit scheduling when fifo has just been drained.
+ * @tx_fifo: fifo used to store & block-up writes for dma to remote
+ * @status_mask: UART_LSR_* bitmask significant to rx (based on termios)
+ * @ignore_mask: UART_LSR_* bitmask of states to ignore (also based on termios)
+ * @break_ctl: if set, port is 'sending break' to remote
+ * @write_only: self-explanatory
+ * @overrun: previous rx was lost (partially or completely)
+ * @loopback: if set, port is in loopback mode
+ * @flags: atomic bit flags
+ *         bit 0: IN_TX - gate to allow only one cpu to send from the dma fifo
+ *                        at a time.
+ *         bit 1: STOP_TX - force tx to exit while sending
+ * @peer: rcu-pointer to associated fwtty_peer (if attached)
+ *        NULL if no peer attached
+ * @icount: predefined statistics reported by the TIOCGICOUNT ioctl
+ * @stats: additional statistics reported in /proc/tty/driver/firewire_serial
+ */
+struct fwtty_port {
+	struct tty_port		   port;
+	struct device		   *device;
+	unsigned		   index;
+	struct fw_serial	   *fw_serial;
+	struct fw_address_handler  rx_handler;
+
+	struct fwconsole_ops	   *fwcon_ops;
+	void			   *con_data;
+
+	wait_queue_head_t	   wait_tx;
+	struct delayed_work	   emit_breaks;
+	unsigned		   cps;
+	unsigned long		   break_last;
+
+	struct work_struct	   hangup;
+
+	unsigned		   mstatus;
+
+	spinlock_t		   lock;
+	unsigned		   mctrl;
+	struct delayed_work	   drain;
+	struct dma_fifo		   tx_fifo;
+	unsigned		   status_mask;
+	unsigned		   ignore_mask;
+	unsigned		   break_ctl:1,
+				   write_only:1,
+				   overrun:1,
+				   loopback:1;
+	unsigned long		   flags;
+
+	struct fwtty_peer	   *peer;
+
+	struct async_icount	   icount;
+	struct stats		   stats;
+};
+
+/* bit #s for flags field */
+#define IN_TX                      0
+#define STOP_TX                    1
+
+/* bitmasks for special mctrl/mstatus bits */
+#define OOB_RX_THROTTLE   0x00010000
+#define MCTRL_RSRVD       0x000e0000
+#define OOB_TX_THROTTLE   0x00100000
+#define MSTATUS_RSRVD     0x00e00000
+
+#define MCTRL_MASK        (TIOCM_DTR | TIOCM_RTS | TIOCM_OUT1 | TIOCM_OUT2 | \
+			   TIOCM_LOOP | OOB_RX_THROTTLE | MCTRL_RSRVD)
+
+/* XXX even every 1/50th secs. may be unnecessarily accurate */
+/* delay in jiffies between brk emits */
+#define FREQ_BREAKS        (HZ / 50)
+
+/* Ports are allocated in blocks of num_ports for each fw_card */
+#define MAX_CARD_PORTS           32	/* max # of ports per card */
+#define MAX_TOTAL_PORTS          64	/* max # of ports total    */
+
+/* tuning parameters */
+#define FWTTY_PORT_TXFIFO_LEN	4096
+#define FWTTY_PORT_MAX_PEND_DMA    8    /* costs a cache line per pend */
+#define DRAIN_THRESHOLD          512
+#define MAX_ASYNC_PAYLOAD       4096    /* ohci-defined limit          */
+#define WRITER_MINIMUM           128
+/* TODO: how to set watermark to AR context size? see fwtty_rx() */
+#define TTY_BUF_LOW_WATERMARK  32768	/* AR context is 32K	       */
+
+/*
+ * Size of bus addr region above 4GB used per port as the recv addr
+ * - must be at least as big as the MAX_ASYNC_PAYLOAD
+ */
+#define FWTTY_PORT_RXFIFO_LEN	MAX_ASYNC_PAYLOAD
+
+/**
+ * fw_serial: aggregate used to associate tty ports with specific fw_card
+ * @card: fw_card associated with this fw_serial device (1:1 association)
+ * @kref: reference-counted multi-port management allows delayed destroy
+ * @self: local unit device as 'peer'. Not valid until local unit device
+ *         is enumerated.
+ * @list: link for insertion into fwserial_list
+ * @peer_list: list of local & remote unit devices attached to this card
+ * @ports: fixed array of tty_ports provided by this serial device
+ */
+struct fw_serial {
+	struct fw_card	  *card;
+	struct kref	  kref;
+
+	struct fwtty_peer *self;
+
+	struct list_head  list;
+	struct list_head  peer_list;
+
+	struct fwtty_port *ports[MAX_CARD_PORTS];
+};
+
+#define TTY_DEV_NAME		    "fwtty"	/* ttyFW was taken           */
+static const char tty_dev_name[] =  TTY_DEV_NAME;
+static const char loop_dev_name[] = "fwloop";
+extern bool limit_bw;
+
+struct tty_driver *fwtty_driver;
+
+#define driver_err(s, v...)	pr_err(KBUILD_MODNAME ": " s, ##v)
+
+struct fwtty_port *fwtty_port_get(unsigned index);
+void fwtty_port_put(struct fwtty_port *port);
+
+static inline void fwtty_bind_console(struct fwtty_port *port,
+				      struct fwconsole_ops *fwcon_ops,
+				      void *data)
+{
+	port->con_data = data;
+	port->fwcon_ops = fwcon_ops;
+}
+
+/*
+ * Returns the max send async payload size in bytes based on the unit device
+ * link speed - if set to limit bandwidth to max 20%, use lookup table
+ */
+static inline int link_speed_to_max_payload(unsigned speed)
+{
+	static const int max_async[] = { 307, 614, 1229, 2458, 4916, 9832, };
+	BUILD_BUG_ON(ARRAY_SIZE(max_async) - 1 != SCODE_3200);
+
+	speed = clamp(speed, (unsigned) SCODE_100, (unsigned) SCODE_3200);
+	if (limit_bw)
+		return max_async[speed];
+	else
+		return 1 << (speed + 9);
+}
+
+#endif /* _FIREWIRE_FWSERIAL_H */
-- 
1.7.12.3



