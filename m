Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab2LMPLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 10:11:55 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:18122 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827Ab2LMOBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:01:03 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 13 Dec 2012 05:59:05 -0800
From: Terje Bergstrom <tbergstrom@nvidia.com>
To: <tbergstrom@nvidia.com>, <thierry.reding@avionic-design.de>,
        <dev@lynxeye.de>, <linux-tegra@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>
CC: <amerilainen@nvidia.com>, <linux-kernel@vger.kernel.org>
Subject: [PATCHv3 3/7] gpu: host1x: Add channel support
Date: Thu, 13 Dec 2012 16:04:40 +0200
Message-ID: <1355407484-28904-4-git-send-email-tbergstrom@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355407484-28904-1-git-send-email-tbergstrom@nvidia.com>
References: <1355407484-28904-1-git-send-email-tbergstrom@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for host1x client modules, and host1x channels to submit
work to the clients. The work is submitted in GEM CMA buffers, so
this patch adds support for them.

Signed-off-by: Terje Bergstrom <tbergstrom@nvidia.com>
---
 drivers/gpu/host1x/Kconfig                  |   24 +-
 drivers/gpu/host1x/Makefile                 |    8 +-
 drivers/gpu/host1x/cdma.c                   |  438 +++++++++++++++++++
 drivers/gpu/host1x/cdma.h                   |  107 +++++
 drivers/gpu/host1x/channel.c                |  137 ++++++
 drivers/gpu/host1x/channel.h                |   64 +++
 drivers/gpu/host1x/cma.c                    |  116 +++++
 drivers/gpu/host1x/cma.h                    |   43 ++
 drivers/gpu/host1x/dev.c                    |   13 +
 drivers/gpu/host1x/dev.h                    |   54 +++
 drivers/gpu/host1x/hw/cdma_hw.c             |  477 +++++++++++++++++++++
 drivers/gpu/host1x/hw/cdma_hw.h             |   37 ++
 drivers/gpu/host1x/hw/channel_hw.c          |  147 +++++++
 drivers/gpu/host1x/hw/host1x01.c            |    6 +
 drivers/gpu/host1x/hw/host1x01_hardware.h   |  124 ++++++
 drivers/gpu/host1x/hw/hw_host1x01_channel.h |   86 ++++
 drivers/gpu/host1x/hw/hw_host1x01_sync.h    |    8 +
 drivers/gpu/host1x/hw/hw_host1x01_uclass.h  |  130 ++++++
 drivers/gpu/host1x/hw/syncpt_hw.c           |   10 +
 drivers/gpu/host1x/intr.c                   |   29 +-
 drivers/gpu/host1x/intr.h                   |    6 +
 drivers/gpu/host1x/job.c                    |  618 +++++++++++++++++++++++++++
 drivers/gpu/host1x/memmgr.c                 |  174 ++++++++
 drivers/gpu/host1x/memmgr.h                 |   53 +++
 drivers/gpu/host1x/syncpt.c                 |    6 +
 drivers/gpu/host1x/syncpt.h                 |    2 +
 include/linux/host1x.h                      |  173 ++++++++
 include/trace/events/host1x.h               |  235 ++++++++++
 28 files changed, 3322 insertions(+), 3 deletions(-)
 create mode 100644 drivers/gpu/host1x/cdma.c
 create mode 100644 drivers/gpu/host1x/cdma.h
 create mode 100644 drivers/gpu/host1x/channel.c
 create mode 100644 drivers/gpu/host1x/channel.h
 create mode 100644 drivers/gpu/host1x/cma.c
 create mode 100644 drivers/gpu/host1x/cma.h
 create mode 100644 drivers/gpu/host1x/hw/cdma_hw.c
 create mode 100644 drivers/gpu/host1x/hw/cdma_hw.h
 create mode 100644 drivers/gpu/host1x/hw/channel_hw.c
 create mode 100644 drivers/gpu/host1x/hw/hw_host1x01_channel.h
 create mode 100644 drivers/gpu/host1x/hw/hw_host1x01_uclass.h
 create mode 100644 drivers/gpu/host1x/job.c
 create mode 100644 drivers/gpu/host1x/memmgr.c
 create mode 100644 drivers/gpu/host1x/memmgr.h

diff --git a/drivers/gpu/host1x/Kconfig b/drivers/gpu/host1x/Kconfig
index e89fb2b..61e7ba3 100644
--- a/drivers/gpu/host1x/Kconfig
+++ b/drivers/gpu/host1x/Kconfig
@@ -3,4 +3,26 @@ config TEGRA_HOST1X
 	help
 	  Driver for the Tegra host1x hardware.
 
-	  Required for enabling tegradrm.
+	  Required for enabling tegradrm and 2D acceleration.
+
+if TEGRA_HOST1X
+
+config TEGRA_HOST1X_CMA
+	bool "Support DRM CMA buffers"
+	depends on DRM
+	select DRM_GEM_CMA_HELPER
+	select DRM_KMS_CMA_HELPER
+	help
+	  Say yes if you wish to use DRM CMA buffers.
+
+	  If unsure, choose Y.
+
+config TEGRA_HOST1X_FIREWALL
+	bool "Enable HOST1X security firewall"
+	default y
+	help
+	  Say yes if kernel should protect command streams from tampering.
+
+	  If unsure, choose Y.
+
+endif
diff --git a/drivers/gpu/host1x/Makefile b/drivers/gpu/host1x/Makefile
index 9d00b62..f6c1924 100644
--- a/drivers/gpu/host1x/Makefile
+++ b/drivers/gpu/host1x/Makefile
@@ -3,7 +3,13 @@ ccflags-y = -Idrivers/gpu/host1x
 host1x-objs = \
 	syncpt.o \
 	dev.o \
-	intr.o
+	intr.o \
+	cdma.o \
+	intr.o \
+	channel.o \
+	job.o \
+	memmgr.o
 
+obj-$(CONFIG_TEGRA_HOST1X_CMA) += cma.o
 obj-$(CONFIG_TEGRA_HOST1X) += hw/
 obj-$(CONFIG_TEGRA_HOST1X) += host1x.o
diff --git a/drivers/gpu/host1x/cdma.c b/drivers/gpu/host1x/cdma.c
new file mode 100644
index 0000000..1193fea
--- /dev/null
+++ b/drivers/gpu/host1x/cdma.c
@@ -0,0 +1,438 @@
+/*
+ * Tegra host1x Command DMA
+ *
+ * Copyright (c) 2010-2012, NVIDIA Corporation.
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
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include "cdma.h"
+#include "channel.h"
+#include "dev.h"
+#include "memmgr.h"
+#include <asm/cacheflush.h>
+
+#include <linux/slab.h>
+#include <linux/kfifo.h>
+#include <linux/interrupt.h>
+#include <trace/events/host1x.h>
+
+#define TRACE_MAX_LENGTH 128U
+
+/*
+ * Add an entry to the sync queue.
+ */
+static void add_to_sync_queue(struct host1x_cdma *cdma,
+			      struct host1x_job *job,
+			      u32 nr_slots,
+			      u32 first_get)
+{
+	if (job->syncpt_id == NVSYNCPT_INVALID) {
+		dev_warn(&job->ch->dev->dev, "%s: Invalid syncpt\n",
+				__func__);
+		return;
+	}
+
+	job->first_get = first_get;
+	job->num_slots = nr_slots;
+	host1x_job_get(job);
+	list_add_tail(&job->list, &cdma->sync_queue);
+}
+
+/*
+ * Return the status of the cdma's sync queue or push buffer for the given event
+ *  - sq empty: returns 1 for empty, 0 for not empty (as in "1 empty queue" :-)
+ *  - pb space: returns the number of free slots in the channel's push buffer
+ * Must be called with the cdma lock held.
+ */
+static unsigned int cdma_status_locked(struct host1x_cdma *cdma,
+		enum cdma_event event)
+{
+	struct host1x *host1x = cdma_to_host1x(cdma);
+	switch (event) {
+	case CDMA_EVENT_SYNC_QUEUE_EMPTY:
+		return list_empty(&cdma->sync_queue) ? 1 : 0;
+	case CDMA_EVENT_PUSH_BUFFER_SPACE: {
+		struct push_buffer *pb = &cdma->push_buffer;
+		return host1x->cdma_pb_op.space(pb);
+	}
+	default:
+		return 0;
+	}
+}
+
+/*
+ * Sleep (if necessary) until the requested event happens
+ *   - CDMA_EVENT_SYNC_QUEUE_EMPTY : sync queue is completely empty.
+ *     - Returns 1
+ *   - CDMA_EVENT_PUSH_BUFFER_SPACE : there is space in the push buffer
+ *     - Return the amount of space (> 0)
+ * Must be called with the cdma lock held.
+ */
+unsigned int host1x_cdma_wait_locked(struct host1x_cdma *cdma,
+		enum cdma_event event)
+{
+	for (;;) {
+		unsigned int space = cdma_status_locked(cdma, event);
+		if (space)
+			return space;
+
+		trace_host1x_wait_cdma(cdma_to_channel(cdma)->dev->name,
+				event);
+
+		/* If somebody has managed to already start waiting, yield */
+		if (cdma->event != CDMA_EVENT_NONE) {
+			mutex_unlock(&cdma->lock);
+			schedule();
+			mutex_lock(&cdma->lock);
+			continue;
+		}
+		cdma->event = event;
+
+		mutex_unlock(&cdma->lock);
+		down(&cdma->sem);
+		mutex_lock(&cdma->lock);
+	}
+	return 0;
+}
+
+/*
+ * Start timer for a buffer submition that has completed yet.
+ * Must be called with the cdma lock held.
+ */
+static void cdma_start_timer_locked(struct host1x_cdma *cdma,
+		struct host1x_job *job)
+{
+	struct host1x *host = cdma_to_host1x(cdma);
+
+	if (cdma->timeout.clientid) {
+		/* timer already started */
+		return;
+	}
+
+	cdma->timeout.clientid = job->clientid;
+	cdma->timeout.syncpt = host1x_syncpt_get(host, job->syncpt_id);
+	cdma->timeout.syncpt_val = job->syncpt_end;
+	cdma->timeout.start_ktime = ktime_get();
+
+	schedule_delayed_work(&cdma->timeout.wq,
+			msecs_to_jiffies(job->timeout));
+}
+
+/*
+ * Stop timer when a buffer submition completes.
+ * Must be called with the cdma lock held.
+ */
+static void stop_cdma_timer_locked(struct host1x_cdma *cdma)
+{
+	cancel_delayed_work(&cdma->timeout.wq);
+	cdma->timeout.clientid = 0;
+}
+
+/*
+ * For all sync queue entries that have already finished according to the
+ * current sync point registers:
+ *  - unpin & unref their mems
+ *  - pop their push buffer slots
+ *  - remove them from the sync queue
+ * This is normally called from the host code's worker thread, but can be
+ * called manually if necessary.
+ * Must be called with the cdma lock held.
+ */
+static void update_cdma_locked(struct host1x_cdma *cdma)
+{
+	bool signal = false;
+	struct host1x *host1x = cdma_to_host1x(cdma);
+	struct host1x_job *job, *n;
+
+	/* If CDMA is stopped, queue is cleared and we can return */
+	if (!cdma->running)
+		return;
+
+	/*
+	 * Walk the sync queue, reading the sync point registers as necessary,
+	 * to consume as many sync queue entries as possible without blocking
+	 */
+	list_for_each_entry_safe(job, n, &cdma->sync_queue, list) {
+		struct host1x_syncpt *sp = host1x->syncpt + job->syncpt_id;
+
+		/* Check whether this syncpt has completed, and bail if not */
+		if (!host1x_syncpt_is_expired(sp, job->syncpt_end)) {
+			/* Start timer on next pending syncpt */
+			if (job->timeout)
+				cdma_start_timer_locked(cdma, job);
+			break;
+		}
+
+		/* Cancel timeout, when a buffer completes */
+		if (cdma->timeout.clientid)
+			stop_cdma_timer_locked(cdma);
+
+		/* Unpin the memory */
+		host1x_job_unpin(job);
+
+		/* Pop push buffer slots */
+		if (job->num_slots) {
+			struct push_buffer *pb = &cdma->push_buffer;
+			host1x->cdma_pb_op.pop_from(pb, job->num_slots);
+			if (cdma->event == CDMA_EVENT_PUSH_BUFFER_SPACE)
+				signal = true;
+		}
+
+		list_del(&job->list);
+		host1x_job_put(job);
+	}
+
+	if (list_empty(&cdma->sync_queue) &&
+				cdma->event == CDMA_EVENT_SYNC_QUEUE_EMPTY)
+			signal = true;
+
+	/* Wake up CdmaWait() if the requested event happened */
+	if (signal) {
+		cdma->event = CDMA_EVENT_NONE;
+		up(&cdma->sem);
+	}
+}
+
+void host1x_cdma_update_sync_queue(struct host1x_cdma *cdma,
+		struct platform_device *dev)
+{
+	u32 get_restart;
+	u32 syncpt_incrs;
+	struct host1x_job *job = NULL;
+	u32 syncpt_val;
+	struct host1x *host1x = cdma_to_host1x(cdma);
+
+	syncpt_val = host1x_syncpt_load_min(cdma->timeout.syncpt);
+
+	dev_dbg(&dev->dev,
+		"%s: starting cleanup (thresh %d)\n",
+		__func__, syncpt_val);
+
+	/*
+	 * Move the sync_queue read pointer to the first entry that hasn't
+	 * completed based on the current HW syncpt value. It's likely there
+	 * won't be any (i.e. we're still at the head), but covers the case
+	 * where a syncpt incr happens just prior/during the teardown.
+	 */
+
+	dev_dbg(&dev->dev,
+		"%s: skip completed buffers still in sync_queue\n",
+		__func__);
+
+	list_for_each_entry(job, &cdma->sync_queue, list) {
+		if (syncpt_val < job->syncpt_end)
+			break;
+
+		host1x_job_dump(&dev->dev, job);
+	}
+
+	/*
+	 * Walk the sync_queue, first incrementing with the CPU syncpts that
+	 * are partially executed (the first buffer) or fully skipped while
+	 * still in the current context (slots are also NOP-ed).
+	 *
+	 * At the point contexts are interleaved, syncpt increments must be
+	 * done inline with the pushbuffer from a GATHER buffer to maintain
+	 * the order (slots are modified to be a GATHER of syncpt incrs).
+	 *
+	 * Note: save in get_restart the location where the timed out buffer
+	 * started in the PB, so we can start the refetch from there (with the
+	 * modified NOP-ed PB slots). This lets things appear to have completed
+	 * properly for this buffer and resources are freed.
+	 */
+
+	dev_dbg(&dev->dev,
+		"%s: perform CPU incr on pending same ctx buffers\n",
+		__func__);
+
+	get_restart = cdma->last_put;
+	if (!list_empty(&cdma->sync_queue))
+		get_restart = job->first_get;
+
+	/* do CPU increments as long as this context continues */
+	list_for_each_entry_from(job, &cdma->sync_queue, list) {
+		/* different context, gets us out of this loop */
+		if (job->clientid != cdma->timeout.clientid)
+			break;
+
+		/* won't need a timeout when replayed */
+		job->timeout = 0;
+
+		syncpt_incrs = job->syncpt_end - syncpt_val;
+		dev_dbg(&dev->dev,
+			"%s: CPU incr (%d)\n", __func__, syncpt_incrs);
+
+		host1x_job_dump(&dev->dev, job);
+
+		/* safe to use CPU to incr syncpts */
+		host1x->cdma_op.timeout_cpu_incr(cdma,
+				job->first_get,
+				syncpt_incrs,
+				job->syncpt_end,
+				job->num_slots);
+
+		syncpt_val += syncpt_incrs;
+	}
+
+	list_for_each_entry_from(job, &cdma->sync_queue, list)
+		if (job->clientid == cdma->timeout.clientid)
+			job->timeout = 500;
+
+	dev_dbg(&dev->dev,
+		"%s: finished sync_queue modification\n", __func__);
+
+	/* roll back DMAGET and start up channel again */
+	host1x->cdma_op.timeout_teardown_end(cdma, get_restart);
+}
+
+/*
+ * Create a cdma
+ */
+int host1x_cdma_init(struct host1x_cdma *cdma)
+{
+	int err;
+	struct push_buffer *pb = &cdma->push_buffer;
+	struct host1x *host1x = cdma_to_host1x(cdma);
+
+	mutex_init(&cdma->lock);
+	sema_init(&cdma->sem, 0);
+
+	INIT_LIST_HEAD(&cdma->sync_queue);
+
+	cdma->event = CDMA_EVENT_NONE;
+	cdma->running = false;
+	cdma->torndown = false;
+
+	err = host1x->cdma_pb_op.init(pb);
+	if (err)
+		return err;
+	return 0;
+}
+
+/*
+ * Destroy a cdma
+ */
+void host1x_cdma_deinit(struct host1x_cdma *cdma)
+{
+	struct push_buffer *pb = &cdma->push_buffer;
+	struct host1x *host1x = cdma_to_host1x(cdma);
+
+	if (cdma->running) {
+		pr_warn("%s: CDMA still running\n",
+				__func__);
+	} else {
+		host1x->cdma_pb_op.destroy(pb);
+		host1x->cdma_op.timeout_destroy(cdma);
+	}
+}
+
+/*
+ * Begin a cdma submit
+ */
+int host1x_cdma_begin(struct host1x_cdma *cdma, struct host1x_job *job)
+{
+	struct host1x *host1x = cdma_to_host1x(cdma);
+
+	mutex_lock(&cdma->lock);
+
+	if (job->timeout) {
+		/* init state on first submit with timeout value */
+		if (!cdma->timeout.initialized) {
+			int err;
+			err = host1x->cdma_op.timeout_init(cdma,
+					job->syncpt_id);
+			if (err) {
+				mutex_unlock(&cdma->lock);
+				return err;
+			}
+		}
+	}
+	if (!cdma->running)
+		host1x->cdma_op.start(cdma);
+
+	cdma->slots_free = 0;
+	cdma->slots_used = 0;
+	cdma->first_get = host1x->cdma_pb_op.putptr(&cdma->push_buffer);
+
+	trace_host1x_cdma_begin(job->ch->dev->name);
+	return 0;
+}
+
+/*
+ * Push two words into a push buffer slot
+ * Blocks as necessary if the push buffer is full.
+ */
+void host1x_cdma_push(struct host1x_cdma *cdma, u32 op1, u32 op2)
+{
+	host1x_cdma_push_gather(cdma, NULL, 0, op1, op2);
+}
+
+/*
+ * Push two words into a push buffer slot
+ * Blocks as necessary if the push buffer is full.
+ */
+void host1x_cdma_push_gather(struct host1x_cdma *cdma,
+		struct mem_handle *handle,
+		u32 offset, u32 op1, u32 op2)
+{
+	struct host1x *host1x = cdma_to_host1x(cdma);
+	u32 slots_free = cdma->slots_free;
+	struct push_buffer *pb = &cdma->push_buffer;
+
+	if (slots_free == 0) {
+		host1x->cdma_op.kick(cdma);
+		slots_free = host1x_cdma_wait_locked(cdma,
+				CDMA_EVENT_PUSH_BUFFER_SPACE);
+	}
+	cdma->slots_free = slots_free - 1;
+	cdma->slots_used++;
+	host1x->cdma_pb_op.push_to(pb, handle, op1, op2);
+}
+
+/*
+ * End a cdma submit
+ * Kick off DMA, add job to the sync queue, and a number of slots to be freed
+ * from the pushbuffer. The handles for a submit must all be pinned at the same
+ * time, but they can be unpinned in smaller chunks.
+ */
+void host1x_cdma_end(struct host1x_cdma *cdma,
+		struct host1x_job *job)
+{
+	struct host1x *host1x = cdma_to_host1x(cdma);
+	bool was_idle = list_empty(&cdma->sync_queue);
+
+	host1x->cdma_op.kick(cdma);
+
+	add_to_sync_queue(cdma,
+			job,
+			cdma->slots_used,
+			cdma->first_get);
+
+	/* start timer on idle -> active transitions */
+	if (job->timeout && was_idle)
+		cdma_start_timer_locked(cdma, job);
+
+	trace_host1x_cdma_end(job->ch->dev->name);
+	mutex_unlock(&cdma->lock);
+}
+
+/*
+ * Update cdma state according to current sync point values
+ */
+void host1x_cdma_update(struct host1x_cdma *cdma)
+{
+	mutex_lock(&cdma->lock);
+	update_cdma_locked(cdma);
+	mutex_unlock(&cdma->lock);
+}
diff --git a/drivers/gpu/host1x/cdma.h b/drivers/gpu/host1x/cdma.h
new file mode 100644
index 0000000..5fd7cdf
--- /dev/null
+++ b/drivers/gpu/host1x/cdma.h
@@ -0,0 +1,107 @@
+/*
+ * Tegra host1x Command DMA
+ *
+ * Copyright (c) 2010-2012, NVIDIA Corporation.
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
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __NVHOST_CDMA_H
+#define __NVHOST_CDMA_H
+
+#include <linux/sched.h>
+#include <linux/semaphore.h>
+
+#include <linux/host1x.h>
+#include <linux/list.h>
+
+struct host1x_syncpt;
+struct host1x_userctx_timeout;
+struct host1x_job;
+struct mem_handle;
+
+/*
+ * cdma
+ *
+ * This is in charge of a host command DMA channel.
+ * Sends ops to a push buffer, and takes responsibility for unpinning
+ * (& possibly freeing) of memory after those ops have completed.
+ * Producer:
+ *	begin
+ *		push - send ops to the push buffer
+ *	end - start command DMA and enqueue handles to be unpinned
+ * Consumer:
+ *	update - call to update sync queue and push buffer, unpin memory
+ */
+
+struct push_buffer {
+	u32 *mapped;			/* mapped pushbuffer memory */
+	dma_addr_t phys;		/* physical address of pushbuffer */
+	u32 fence;			/* index we've written */
+	u32 cur;			/* index to write to */
+	struct mem_handle **handle;	/* handle for each opcode pair */
+};
+
+struct buffer_timeout {
+	struct delayed_work wq;		/* work queue */
+	bool initialized;		/* timer one-time setup flag */
+	struct host1x_syncpt *syncpt;	/* buffer completion syncpt */
+	u32 syncpt_val;			/* syncpt value when completed */
+	ktime_t start_ktime;		/* starting time */
+	/* context timeout information */
+	int clientid;
+};
+
+enum cdma_event {
+	CDMA_EVENT_NONE,		/* not waiting for any event */
+	CDMA_EVENT_SYNC_QUEUE_EMPTY,	/* wait for empty sync queue */
+	CDMA_EVENT_PUSH_BUFFER_SPACE	/* wait for space in push buffer */
+};
+
+struct host1x_cdma {
+	struct mutex lock;		/* controls access to shared state */
+	struct semaphore sem;		/* signalled when event occurs */
+	enum cdma_event event;		/* event that sem is waiting for */
+	unsigned int slots_used;	/* pb slots used in current submit */
+	unsigned int slots_free;	/* pb slots free in current submit */
+	unsigned int first_get;		/* DMAGET value, where submit begins */
+	unsigned int last_put;		/* last value written to DMAPUT */
+	struct push_buffer push_buffer;	/* channel's push buffer */
+	struct list_head sync_queue;	/* job queue */
+	struct buffer_timeout timeout;	/* channel's timeout state/wq */
+	bool running;
+	bool torndown;
+};
+
+#define cdma_to_channel(cdma) container_of(cdma, struct host1x_channel, cdma)
+#define cdma_to_host1x(cdma) host1x_get_host(cdma_to_channel(cdma)->dev)
+#define cdma_to_memmgr(cdma) ((cdma_to_host1x(cdma))->memmgr)
+#define pb_to_cdma(pb) container_of(pb, struct host1x_cdma, push_buffer)
+
+int	host1x_cdma_init(struct host1x_cdma *cdma);
+void	host1x_cdma_deinit(struct host1x_cdma *cdma);
+void	host1x_cdma_stop(struct host1x_cdma *cdma);
+int	host1x_cdma_begin(struct host1x_cdma *cdma, struct host1x_job *job);
+void	host1x_cdma_push(struct host1x_cdma *cdma, u32 op1, u32 op2);
+void	host1x_cdma_push_gather(struct host1x_cdma *cdma,
+		struct mem_handle *handle, u32 offset, u32 op1, u32 op2);
+void	host1x_cdma_end(struct host1x_cdma *cdma,
+		struct host1x_job *job);
+void	host1x_cdma_update(struct host1x_cdma *cdma);
+void	host1x_cdma_peek(struct host1x_cdma *cdma,
+		u32 dmaget, int slot, u32 *out);
+unsigned int host1x_cdma_wait_locked(struct host1x_cdma *cdma,
+		enum cdma_event event);
+void host1x_cdma_update_sync_queue(struct host1x_cdma *cdma,
+		struct platform_device *dev);
+#endif
diff --git a/drivers/gpu/host1x/channel.c b/drivers/gpu/host1x/channel.c
new file mode 100644
index 0000000..3705cae
--- /dev/null
+++ b/drivers/gpu/host1x/channel.c
@@ -0,0 +1,137 @@
+/*
+ * Tegra host1x Channel
+ *
+ * Copyright (c) 2010-2012, NVIDIA Corporation.
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
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include "channel.h"
+#include "dev.h"
+
+#include <linux/slab.h>
+#include <linux/module.h>
+
+#define NVHOST_CHANNEL_LOW_PRIO_MAX_WAIT 50
+
+/* Constructor for the host1x device list */
+void host1x_channel_list_init(struct host1x *host1x)
+{
+	INIT_LIST_HEAD(&host1x->chlist.list);
+}
+
+/*
+ * Iterator function for host1x device list
+ * It takes a fptr as an argument and calls that function for each
+ * device in the list
+ */
+void host1x_channel_for_all(struct host1x *host1x, void *data,
+	int (*fptr)(struct host1x_channel *ch, void *fdata))
+{
+	struct host1x_channel *ch;
+	int ret;
+
+	list_for_each_entry(ch, &host1x->chlist.list, list) {
+		if (ch && fptr) {
+			ret = fptr(ch, data);
+			if (ret) {
+				pr_info("%s: iterator error\n", __func__);
+				break;
+			}
+		}
+	}
+}
+
+
+int host1x_channel_submit(struct host1x_job *job)
+{
+	return host1x_get_host(job->ch->dev)->channel_op.submit(job);
+}
+EXPORT_SYMBOL(host1x_channel_submit);
+
+struct host1x_channel *host1x_channel_get(struct host1x_channel *ch)
+{
+	int err = 0;
+
+	mutex_lock(&ch->reflock);
+	if (ch->refcount == 0)
+		err = host1x_cdma_init(&ch->cdma);
+	if (!err)
+		ch->refcount++;
+
+	mutex_unlock(&ch->reflock);
+
+	return err ? NULL : ch;
+}
+EXPORT_SYMBOL(host1x_channel_get);
+
+void host1x_channel_put(struct host1x_channel *ch)
+{
+	mutex_lock(&ch->reflock);
+	if (ch->refcount == 1) {
+		host1x_get_host(ch->dev)->cdma_op.stop(&ch->cdma);
+		host1x_cdma_deinit(&ch->cdma);
+	}
+	ch->refcount--;
+	mutex_unlock(&ch->reflock);
+}
+EXPORT_SYMBOL(host1x_channel_put);
+
+struct host1x_channel *host1x_channel_alloc(struct platform_device *pdev)
+{
+	struct host1x_channel *ch = NULL;
+	struct host1x *host1x = host1x_get_host(pdev);
+	int chindex = host1x->allocated_channels;
+	int max_channels = host1x->info.nb_channels;
+	int err;
+
+	if (chindex > max_channels)
+		return NULL;
+
+	ch = kzalloc(sizeof(*ch), GFP_KERNEL);
+	if (ch == NULL)
+		return NULL;
+
+	/* Link platform_device to host1x_channel */
+	err = host1x->channel_op.init(ch, host1x, chindex);
+	if (err < 0) {
+		dev_err(&host1x->dev->dev, "failed to init channel %d\n",
+				chindex);
+		kfree(ch);
+		return NULL;
+	}
+	ch->dev = pdev;
+
+	/* Add to channel list */
+	list_add_tail(&ch->list, &host1x->chlist.list);
+
+	host1x->allocated_channels++;
+
+	return ch;
+}
+EXPORT_SYMBOL(host1x_channel_alloc);
+
+void host1x_free_channel(struct host1x_channel *ch)
+{
+	struct host1x *host1x = host1x_get_host(ch->dev);
+	struct host1x_channel *chiter, *tmp;
+	list_for_each_entry_safe(chiter, tmp, &host1x->chlist.list, list) {
+		if (chiter == ch) {
+			list_del(&chiter->list);
+			kfree(ch);
+			host1x->allocated_channels--;
+
+			return;
+		}
+	}
+}
diff --git a/drivers/gpu/host1x/channel.h b/drivers/gpu/host1x/channel.h
new file mode 100644
index 0000000..67d9487
--- /dev/null
+++ b/drivers/gpu/host1x/channel.h
@@ -0,0 +1,64 @@
+/*
+ * Tegra host1x Channel
+ *
+ * Copyright (c) 2010-2012, NVIDIA Corporation.
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
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __NVHOST_CHANNEL_H
+#define __NVHOST_CHANNEL_H
+
+#include <linux/cdev.h>
+#include <linux/io.h>
+#include "cdma.h"
+
+#define NVHOST_MAX_WAIT_CHECKS		256
+#define NVHOST_MAX_GATHERS		512
+#define NVHOST_MAX_HANDLES		1280
+#define NVHOST_MAX_POWERGATE_IDS	2
+
+struct host1x;
+struct platform_device;
+struct host1x_channel;
+
+/*
+ * host1x device list in debug-fs dump of host1x and client device
+ * as well as channel state
+ */
+struct host1x_channel {
+	struct list_head list;
+
+	int refcount;
+	int chid;
+	struct mutex reflock;
+	struct mutex submitlock;
+	void __iomem *regs;
+	struct device *node;
+	struct platform_device *dev;
+	struct cdev cdev;
+	struct host1x_cdma cdma;
+};
+
+/* channel list operations */
+void host1x_channel_list_init(struct host1x *);
+void host1x_channel_for_all(struct host1x *, void *data,
+	int (*fptr)(struct host1x_channel *ch, void *fdata));
+
+struct host1x_channel *host1x_alloc_channel(struct platform_device *dev);
+void host1x_free_channel(struct host1x_channel *ch);
+
+struct host1x_channel *host1x_getchannel(struct host1x_channel *ch);
+void host1x_putchannel(struct host1x_channel *ch);
+
+#endif
diff --git a/drivers/gpu/host1x/cma.c b/drivers/gpu/host1x/cma.c
new file mode 100644
index 0000000..bef9d4d
--- /dev/null
+++ b/drivers/gpu/host1x/cma.c
@@ -0,0 +1,116 @@
+/*
+ * Tegra host1x DMA-BUF support
+ *
+ * Copyright (c) 2012, NVIDIA Corporation.
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
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <drm/drmP.h>
+#include <drm/drm.h>
+#include <drm/drm_gem_cma_helper.h>
+#include <linux/host1x.h>
+#include <linux/mutex.h>
+
+#include "memmgr.h"
+
+static inline struct drm_gem_cma_object *to_cma_obj(struct mem_handle *h)
+{
+	return (struct drm_gem_cma_object *)(((u32)h) & MEMMGR_ID_MASK);
+}
+
+struct mem_handle *host1x_cma_alloc(size_t size, size_t align, int flags)
+{
+	return NULL;
+}
+
+void host1x_cma_put(struct mem_handle *handle)
+{
+	struct drm_gem_cma_object *obj = to_cma_obj(handle);
+	struct mutex *struct_mutex = &obj->base.dev->struct_mutex;
+
+	mutex_lock(struct_mutex);
+	drm_gem_object_unreference(&obj->base);
+	mutex_unlock(struct_mutex);
+}
+
+struct sg_table *host1x_cma_pin(struct mem_handle *handle)
+{
+	return NULL;
+}
+
+void host1x_cma_unpin(struct mem_handle *handle, struct sg_table *sgt)
+{
+
+}
+
+
+void *host1x_cma_mmap(struct mem_handle *handle)
+{
+	return (to_cma_obj(handle))->vaddr;
+}
+
+void host1x_cma_munmap(struct mem_handle *handle, void *addr)
+{
+
+}
+
+void *host1x_cma_kmap(struct mem_handle *handle, unsigned int pagenum)
+{
+	return (to_cma_obj(handle))->vaddr + pagenum * PAGE_SIZE;
+}
+
+void host1x_cma_kunmap(struct mem_handle *handle, unsigned int pagenum,
+		void *addr)
+{
+
+}
+
+struct mem_handle *host1x_cma_get(u32 id, struct platform_device *dev)
+{
+	struct drm_gem_cma_object *obj = to_cma_obj((void *)id);
+	struct mutex *struct_mutex = &obj->base.dev->struct_mutex;
+
+	mutex_lock(struct_mutex);
+	drm_gem_object_reference(&obj->base);
+	mutex_unlock(struct_mutex);
+
+	return (struct mem_handle *) ((u32)id | mem_mgr_type_cma);
+}
+
+int host1x_cma_pin_array_ids(struct platform_device *dev,
+		long unsigned *ids,
+		long unsigned id_type_mask,
+		long unsigned id_type,
+		u32 count,
+		struct host1x_job_unpin_data *unpin_data,
+		dma_addr_t *phys_addr)
+{
+	int i;
+	int pin_count = 0;
+
+	for (i = 0; i < count; i++) {
+		struct mem_handle *handle;
+
+		if ((ids[i] & id_type_mask) != id_type)
+			continue;
+
+		handle = host1x_cma_get(ids[i], dev);
+
+		phys_addr[i] = (to_cma_obj(handle)->paddr);
+		unpin_data[pin_count].h = handle;
+
+		pin_count++;
+	}
+	return pin_count;
+}
diff --git a/drivers/gpu/host1x/cma.h b/drivers/gpu/host1x/cma.h
new file mode 100644
index 0000000..69e2540
--- /dev/null
+++ b/drivers/gpu/host1x/cma.h
@@ -0,0 +1,43 @@
+/*
+ * Tegra host1x cma memory manager
+ *
+ * Copyright (c) 2012, NVIDIA Corporation.
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
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __NVHOST_CMA_H
+#define __NVHOST_CMA_H
+
+#include "memmgr.h"
+
+struct platform_device;
+
+struct mem_handle *host1x_cma_alloc(size_t size, size_t align, int flags);
+void host1x_cma_put(struct mem_handle *handle);
+struct sg_table *host1x_cma_pin(struct mem_handle *handle);
+void host1x_cma_unpin(struct mem_handle *handle, struct sg_table *sgt);
+void *host1x_cma_mmap(struct mem_handle *handle);
+void host1x_cma_munmap(struct mem_handle *handle, void *addr);
+void *host1x_cma_kmap(struct mem_handle *handle, unsigned int pagenum);
+void host1x_cma_kunmap(struct mem_handle *handle, unsigned int pagenum,
+		void *addr);
+int host1x_cma_get(u32 id, struct platform_device *dev);
+int host1x_cma_pin_array_ids(struct platform_device *dev,
+		long unsigned *ids,
+		long unsigned id_type_mask,
+		long unsigned id_type,
+		u32 count,
+		struct host1x_job_unpin_data *unpin_data,
+		dma_addr_t *phys_addr);
+#endif
diff --git a/drivers/gpu/host1x/dev.c b/drivers/gpu/host1x/dev.c
index 9255a49..9209333 100644
--- a/drivers/gpu/host1x/dev.c
+++ b/drivers/gpu/host1x/dev.c
@@ -26,6 +26,7 @@
 #include <linux/io.h>
 #include "dev.h"
 #include "intr.h"
+#include "channel.h"
 #include "hw/host1x01.h"
 
 #define CREATE_TRACE_POINTS
@@ -76,6 +77,16 @@ u32 host1x_sync_readl(struct host1x *host1x, u32 r)
 	return readl(sync_regs + r);
 }
 
+void host1x_ch_writel(struct host1x_channel *ch, u32 v, u32 r)
+{
+	writel(v, ch->regs + r);
+}
+
+u32 host1x_ch_readl(struct host1x_channel *ch, u32 r)
+{
+	return readl(ch->regs + r);
+}
+
 static int host1x_alloc_resources(struct host1x *host)
 {
 	host->intr.syncpt = devm_kzalloc(&host->dev->dev,
@@ -184,6 +195,8 @@ static int host1x_probe(struct platform_device *dev)
 
 	host1x_syncpt_reset(host);
 
+	host1x_channel_list_init(host);
+
 	host1x_intr_start(&host->intr, clk_get_rate(host->clk));
 
 	host1x = host;
diff --git a/drivers/gpu/host1x/dev.h b/drivers/gpu/host1x/dev.h
index a1622bb..093ac85 100644
--- a/drivers/gpu/host1x/dev.h
+++ b/drivers/gpu/host1x/dev.h
@@ -19,13 +19,59 @@
 
 #include <linux/host1x.h>
 
+#include "channel.h"
 #include "syncpt.h"
 #include "intr.h"
 
 struct host1x;
+struct host1x_intr;
 struct host1x_syncpt;
+struct host1x_channel;
+struct host1x_cdma;
+struct host1x_job;
+struct push_buffer;
+struct dentry;
+struct mem_handle;
 struct platform_device;
 
+struct host1x_channel_ops {
+	const char *soc_name;
+	int (*init)(struct host1x_channel *,
+		    struct host1x *,
+		    int chid);
+	int (*submit)(struct host1x_job *job);
+};
+
+struct host1x_cdma_ops {
+	void (*start)(struct host1x_cdma *);
+	void (*stop)(struct host1x_cdma *);
+	void (*kick)(struct  host1x_cdma *);
+	int (*timeout_init)(struct host1x_cdma *,
+			    u32 syncpt_id);
+	void (*timeout_destroy)(struct host1x_cdma *);
+	void (*timeout_teardown_begin)(struct host1x_cdma *);
+	void (*timeout_teardown_end)(struct host1x_cdma *,
+				     u32 getptr);
+	void (*timeout_cpu_incr)(struct host1x_cdma *,
+				 u32 getptr,
+				 u32 syncpt_incrs,
+				 u32 syncval,
+				 u32 nr_slots);
+};
+
+struct host1x_pushbuffer_ops {
+	void (*reset)(struct push_buffer *);
+	int (*init)(struct push_buffer *);
+	void (*destroy)(struct push_buffer *);
+	void (*push_to)(struct push_buffer *,
+			struct mem_handle *,
+			u32 op1, u32 op2);
+	void (*pop_from)(struct push_buffer *,
+			 unsigned int slots);
+	u32 (*space)(struct push_buffer *);
+	u32 (*putptr)(struct push_buffer *);
+};
+
 struct host1x_syncpt_ops {
 	void (*reset)(struct host1x_syncpt *);
 	void (*reset_wait_base)(struct host1x_syncpt *);
@@ -70,9 +116,15 @@ struct host1x {
 	struct host1x_syncpt *nop_sp;
 
 	const char *soc_name;
+	struct host1x_channel_ops channel_op;
+	struct host1x_cdma_ops cdma_op;
+	struct host1x_pushbuffer_ops cdma_pb_op;
 	struct host1x_syncpt_ops syncpt_op;
 	struct host1x_intr_ops intr_op;
 
+	struct host1x_channel chlist;
+	int allocated_channels;
+
 	struct dentry *debugfs;
 };
 
@@ -90,5 +142,7 @@ struct host1x *host1x_get_host(struct platform_device *_dev)
 
 void host1x_sync_writel(struct host1x *host1x, u32 r, u32 v);
 u32 host1x_sync_readl(struct host1x *host1x, u32 r);
+void host1x_ch_writel(struct host1x_channel *ch, u32 r, u32 v);
+u32 host1x_ch_readl(struct host1x_channel *ch, u32 r);
 
 #endif
diff --git a/drivers/gpu/host1x/hw/cdma_hw.c b/drivers/gpu/host1x/hw/cdma_hw.c
new file mode 100644
index 0000000..55adaa6
--- /dev/null
+++ b/drivers/gpu/host1x/hw/cdma_hw.c
@@ -0,0 +1,477 @@
+/*
+ * Tegra host1x Command DMA
+ *
+ * Copyright (c) 2010-2012, NVIDIA Corporation.
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
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/slab.h>
+#include <linux/scatterlist.h>
+#include <linux/dma-mapping.h>
+#include "cdma.h"
+#include "channel.h"
+#include "dev.h"
+#include "memmgr.h"
+
+#include "cdma_hw.h"
+
+static inline u32 host1x_channel_dmactrl(int stop, int get_rst, int init_get)
+{
+	return host1x_channel_dmactrl_dmastop_f(stop)
+		| host1x_channel_dmactrl_dmagetrst_f(get_rst)
+		| host1x_channel_dmactrl_dmainitget_f(init_get);
+}
+
+static void cdma_timeout_handler(struct work_struct *work);
+
+/*
+ * push_buffer
+ *
+ * The push buffer is a circular array of words to be fetched by command DMA.
+ * Note that it works slightly differently to the sync queue; fence == cur
+ * means that the push buffer is full, not empty.
+ */
+
+
+/**
+ * Reset to empty push buffer
+ */
+static void push_buffer_reset(struct push_buffer *pb)
+{
+	pb->fence = PUSH_BUFFER_SIZE - 8;
+	pb->cur = 0;
+}
+
+/**
+ * Init push buffer resources
+ */
+static void push_buffer_destroy(struct push_buffer *pb);
+static int push_buffer_init(struct push_buffer *pb)
+{
+	struct host1x_cdma *cdma = pb_to_cdma(pb);
+	struct host1x *host1x = cdma_to_host1x(cdma);
+	pb->mapped = NULL;
+	pb->phys = 0;
+	pb->handle = NULL;
+
+	host1x->cdma_pb_op.reset(pb);
+
+	/* allocate and map pushbuffer memory */
+	pb->mapped = dma_alloc_writecombine(&host1x->dev->dev,
+			PUSH_BUFFER_SIZE + 4, &pb->phys, GFP_KERNEL);
+	if (IS_ERR_OR_NULL(pb->mapped)) {
+		pb->mapped = NULL;
+		goto fail;
+	}
+
+	/* memory for storing mem client and handles for each opcode pair */
+	pb->handle = kzalloc(HOST1X_GATHER_QUEUE_SIZE *
+				sizeof(struct mem_handle *),
+			GFP_KERNEL);
+	if (!pb->handle)
+		goto fail;
+
+	/* put the restart at the end of pushbuffer memory */
+	*(pb->mapped + (PUSH_BUFFER_SIZE >> 2)) =
+		host1x_opcode_restart(pb->phys);
+
+	return 0;
+
+fail:
+	push_buffer_destroy(pb);
+	return -ENOMEM;
+}
+
+/*
+ * Clean up push buffer resources
+ */
+static void push_buffer_destroy(struct push_buffer *pb)
+{
+	struct host1x_cdma *cdma = pb_to_cdma(pb);
+	struct host1x *host1x = cdma_to_host1x(cdma);
+
+	if (pb->phys != 0)
+		dma_free_writecombine(&host1x->dev->dev,
+				PUSH_BUFFER_SIZE + 4,
+				pb->mapped, pb->phys);
+
+	kfree(pb->handle);
+
+	pb->mapped = NULL;
+	pb->phys = 0;
+	pb->handle = 0;
+}
+
+/*
+ * Push two words to the push buffer
+ * Caller must ensure push buffer is not full
+ */
+static void push_buffer_push_to(struct push_buffer *pb,
+		struct mem_handle *handle,
+		u32 op1, u32 op2)
+{
+	u32 cur = pb->cur;
+	u32 *p = (u32 *)((u32)pb->mapped + cur);
+	u32 cur_mem = (cur/8) & (HOST1X_GATHER_QUEUE_SIZE - 1);
+	WARN_ON(cur == pb->fence);
+	*(p++) = op1;
+	*(p++) = op2;
+	pb->handle[cur_mem] = handle;
+	pb->cur = (cur + 8) & (PUSH_BUFFER_SIZE - 1);
+}
+
+/*
+ * Pop a number of two word slots from the push buffer
+ * Caller must ensure push buffer is not empty
+ */
+static void push_buffer_pop_from(struct push_buffer *pb,
+		unsigned int slots)
+{
+	/* Clear the mem references for old items from pb */
+	unsigned int i;
+	u32 fence_mem = pb->fence/8;
+	for (i = 0; i < slots; i++) {
+		int cur_fence_mem = (fence_mem+i)
+				& (HOST1X_GATHER_QUEUE_SIZE - 1);
+		pb->handle[cur_fence_mem] = NULL;
+	}
+	/* Advance the next write position */
+	pb->fence = (pb->fence + slots * 8) & (PUSH_BUFFER_SIZE - 1);
+}
+
+/*
+ * Return the number of two word slots free in the push buffer
+ */
+static u32 push_buffer_space(struct push_buffer *pb)
+{
+	return ((pb->fence - pb->cur) & (PUSH_BUFFER_SIZE - 1)) / 8;
+}
+
+static u32 push_buffer_putptr(struct push_buffer *pb)
+{
+	return pb->phys + pb->cur;
+}
+
+/*
+ * The syncpt incr buffer is filled with methods to increment syncpts, which
+ * is later GATHER-ed into the mainline PB. It's used when a timed out context
+ * is interleaved with other work, so needs to inline the syncpt increments
+ * to maintain the count (but otherwise does no work).
+ */
+
+/*
+ * Init timeout resources
+ */
+static int cdma_timeout_init(struct host1x_cdma *cdma,
+				 u32 syncpt_id)
+{
+	if (syncpt_id == NVSYNCPT_INVALID)
+		return -EINVAL;
+
+	INIT_DELAYED_WORK(&cdma->timeout.wq, cdma_timeout_handler);
+	cdma->timeout.initialized = true;
+
+	return 0;
+}
+
+/*
+ * Clean up timeout resources
+ */
+static void cdma_timeout_destroy(struct host1x_cdma *cdma)
+{
+	if (cdma->timeout.initialized)
+		cancel_delayed_work(&cdma->timeout.wq);
+	cdma->timeout.initialized = false;
+}
+
+/*
+ * Increment timedout buffer's syncpt via CPU.
+ */
+static void cdma_timeout_cpu_incr(struct host1x_cdma *cdma, u32 getptr,
+				u32 syncpt_incrs, u32 syncval, u32 nr_slots)
+{
+	struct host1x *host1x = cdma_to_host1x(cdma);
+	struct push_buffer *pb = &cdma->push_buffer;
+	u32 i, getidx;
+
+	for (i = 0; i < syncpt_incrs; i++)
+		host1x_syncpt_cpu_incr(cdma->timeout.syncpt);
+
+	/* after CPU incr, ensure shadow is up to date */
+	host1x_syncpt_load_min(cdma->timeout.syncpt);
+
+	/* NOP all the PB slots */
+	getidx = getptr - pb->phys;
+	while (nr_slots--) {
+		u32 *p = (u32 *)((u32)pb->mapped + getidx);
+		*(p++) = HOST1X_OPCODE_NOOP;
+		*(p++) = HOST1X_OPCODE_NOOP;
+		dev_dbg(&host1x->dev->dev, "%s: NOP at 0x%x\n",
+			__func__, pb->phys + getidx);
+		getidx = (getidx + 8) & (PUSH_BUFFER_SIZE - 1);
+	}
+	wmb();
+}
+
+/*
+ * Start channel DMA
+ */
+static void cdma_start(struct host1x_cdma *cdma)
+{
+	struct host1x_channel *ch = cdma_to_channel(cdma);
+	struct host1x *host1x = cdma_to_host1x(cdma);
+
+	if (cdma->running)
+		return;
+
+	cdma->last_put = host1x->cdma_pb_op.putptr(&cdma->push_buffer);
+
+	host1x_ch_writel(ch, host1x_channel_dmactrl(true, false, false),
+		host1x_channel_dmactrl_r());
+
+	/* set base, put, end pointer (all of memory) */
+	host1x_ch_writel(ch, 0, host1x_channel_dmastart_r());
+	host1x_ch_writel(ch, cdma->last_put, host1x_channel_dmaput_r());
+	host1x_ch_writel(ch, 0xFFFFFFFF, host1x_channel_dmaend_r());
+
+	/* reset GET */
+	host1x_ch_writel(ch, host1x_channel_dmactrl(true, true, true),
+		host1x_channel_dmactrl_r());
+
+	/* start the command DMA */
+	host1x_ch_writel(ch, host1x_channel_dmactrl(false, false, false),
+		host1x_channel_dmactrl_r());
+
+	cdma->running = true;
+}
+
+/*
+ * Similar to cdma_start(), but rather than starting from an idle
+ * state (where DMA GET is set to DMA PUT), on a timeout we restore
+ * DMA GET from an explicit value (so DMA may again be pending).
+ */
+static void cdma_timeout_restart(struct host1x_cdma *cdma, u32 getptr)
+{
+	struct host1x *host1x = cdma_to_host1x(cdma);
+	struct host1x_channel *ch = cdma_to_channel(cdma);
+
+	if (cdma->running)
+		return;
+
+	cdma->last_put = host1x->cdma_pb_op.putptr(&cdma->push_buffer);
+
+	host1x_ch_writel(ch, host1x_channel_dmactrl(true, false, false),
+		host1x_channel_dmactrl_r());
+
+	/* set base, end pointer (all of memory) */
+	host1x_ch_writel(ch, 0, host1x_channel_dmastart_r());
+	host1x_ch_writel(ch, 0xFFFFFFFF, host1x_channel_dmaend_r());
+
+	/* set GET, by loading the value in PUT (then reset GET) */
+	host1x_ch_writel(ch, getptr, host1x_channel_dmaput_r());
+	host1x_ch_writel(ch, host1x_channel_dmactrl(true, true, true),
+		host1x_channel_dmactrl_r());
+
+	dev_dbg(&host1x->dev->dev,
+		"%s: DMA GET 0x%x, PUT HW 0x%x / shadow 0x%x\n",
+		__func__,
+		host1x_ch_readl(ch, host1x_channel_dmaget_r()),
+		host1x_ch_readl(ch, host1x_channel_dmaput_r()),
+		cdma->last_put);
+
+	/* deassert GET reset and set PUT */
+	host1x_ch_writel(ch, host1x_channel_dmactrl(true, false, false),
+		host1x_channel_dmactrl_r());
+	host1x_ch_writel(ch, cdma->last_put, host1x_channel_dmaput_r());
+
+	/* start the command DMA */
+	host1x_ch_writel(ch, host1x_channel_dmactrl(false, false, false),
+		host1x_channel_dmactrl_r());
+
+	cdma->running = true;
+}
+
+/*
+ * Kick channel DMA into action by writing its PUT offset (if it has changed)
+ */
+static void cdma_kick(struct host1x_cdma *cdma)
+{
+	struct host1x *host1x = cdma_to_host1x(cdma);
+	struct host1x_channel *ch = cdma_to_channel(cdma);
+	u32 put;
+
+	put = host1x->cdma_pb_op.putptr(&cdma->push_buffer);
+
+	if (put != cdma->last_put) {
+		host1x_ch_writel(ch, put, host1x_channel_dmaput_r());
+		cdma->last_put = put;
+	}
+}
+
+static void cdma_stop(struct host1x_cdma *cdma)
+{
+	struct host1x_channel *ch = cdma_to_channel(cdma);
+
+	mutex_lock(&cdma->lock);
+	if (cdma->running) {
+		host1x_cdma_wait_locked(cdma, CDMA_EVENT_SYNC_QUEUE_EMPTY);
+		host1x_ch_writel(ch, host1x_channel_dmactrl(true, false, false),
+			host1x_channel_dmactrl_r());
+		cdma->running = false;
+	}
+	mutex_unlock(&cdma->lock);
+}
+
+/*
+ * Stops both channel's command processor and CDMA immediately.
+ * Also, tears down the channel and resets corresponding module.
+ */
+static void cdma_timeout_teardown_begin(struct host1x_cdma *cdma)
+{
+	struct host1x *dev = cdma_to_host1x(cdma);
+	struct host1x_channel *ch = cdma_to_channel(cdma);
+	u32 cmdproc_stop;
+
+	if (cdma->torndown && !cdma->running) {
+		dev_warn(&dev->dev->dev, "Already torn down\n");
+		return;
+	}
+
+	dev_dbg(&dev->dev->dev,
+		"begin channel teardown (channel id %d)\n", ch->chid);
+
+	cmdproc_stop = host1x_sync_readl(dev, host1x_sync_cmdproc_stop_r());
+	cmdproc_stop |= BIT(ch->chid);
+	host1x_sync_writel(dev, cmdproc_stop, host1x_sync_cmdproc_stop_r());
+
+	dev_dbg(&dev->dev->dev,
+		"%s: DMA GET 0x%x, PUT HW 0x%x / shadow 0x%x\n",
+		__func__,
+		host1x_ch_readl(ch, host1x_channel_dmaget_r()),
+		host1x_ch_readl(ch, host1x_channel_dmaput_r()),
+		cdma->last_put);
+
+	host1x_ch_writel(ch, host1x_channel_dmactrl(true, false, false),
+		host1x_channel_dmactrl_r());
+
+	host1x_sync_writel(dev, BIT(ch->chid), host1x_sync_ch_teardown_r());
+
+	cdma->running = false;
+	cdma->torndown = true;
+}
+
+static void cdma_timeout_teardown_end(struct host1x_cdma *cdma, u32 getptr)
+{
+	struct host1x *host1x = cdma_to_host1x(cdma);
+	struct host1x_channel *ch = cdma_to_channel(cdma);
+	u32 cmdproc_stop;
+
+	dev_dbg(&host1x->dev->dev,
+		"end channel teardown (id %d, DMAGET restart = 0x%x)\n",
+		ch->chid, getptr);
+
+	cmdproc_stop = host1x_sync_readl(host1x, host1x_sync_cmdproc_stop_r());
+	cmdproc_stop &= ~(BIT(ch->chid));
+	host1x_sync_writel(host1x, cmdproc_stop, host1x_sync_cmdproc_stop_r());
+
+	cdma->torndown = false;
+	cdma_timeout_restart(cdma, getptr);
+}
+
+/*
+ * If this timeout fires, it indicates the current sync_queue entry has
+ * exceeded its TTL and the userctx should be timed out and remaining
+ * submits already issued cleaned up (future submits return an error).
+ */
+static void cdma_timeout_handler(struct work_struct *work)
+{
+	struct host1x_cdma *cdma;
+	struct host1x *host1x;
+	struct host1x_channel *ch;
+
+	u32 syncpt_val;
+
+	u32 prev_cmdproc, cmdproc_stop;
+
+	cdma = container_of(to_delayed_work(work), struct host1x_cdma,
+			    timeout.wq);
+	host1x = cdma_to_host1x(cdma);
+	ch = cdma_to_channel(cdma);
+
+	mutex_lock(&cdma->lock);
+
+	if (!cdma->timeout.clientid) {
+		dev_dbg(&host1x->dev->dev,
+			 "cdma_timeout: expired, but has no clientid\n");
+		mutex_unlock(&cdma->lock);
+		return;
+	}
+
+	/* stop processing to get a clean snapshot */
+	prev_cmdproc = host1x_sync_readl(host1x, host1x_sync_cmdproc_stop_r());
+	cmdproc_stop = prev_cmdproc | BIT(ch->chid);
+	host1x_sync_writel(host1x, cmdproc_stop, host1x_sync_cmdproc_stop_r());
+
+	dev_dbg(&host1x->dev->dev, "cdma_timeout: cmdproc was 0x%x is 0x%x\n",
+		prev_cmdproc, cmdproc_stop);
+
+	syncpt_val = host1x_syncpt_load_min(host1x->syncpt);
+
+	/* has buffer actually completed? */
+	if ((s32)(syncpt_val - cdma->timeout.syncpt_val) >= 0) {
+		dev_dbg(&host1x->dev->dev,
+			 "cdma_timeout: expired, but buffer had completed\n");
+		/* restore */
+		cmdproc_stop = prev_cmdproc & ~(BIT(ch->chid));
+		host1x_sync_writel(host1x, cmdproc_stop,
+			host1x_sync_cmdproc_stop_r());
+		mutex_unlock(&cdma->lock);
+		return;
+	}
+
+	dev_warn(&host1x->dev->dev,
+		"%s: timeout: %d (%s), HW thresh %d, done %d\n",
+		__func__,
+		cdma->timeout.syncpt->id, cdma->timeout.syncpt->name,
+		syncpt_val, cdma->timeout.syncpt_val);
+
+	/* stop HW, resetting channel/module */
+	host1x->cdma_op.timeout_teardown_begin(cdma);
+
+	host1x_cdma_update_sync_queue(cdma, ch->dev);
+	mutex_unlock(&cdma->lock);
+}
+
+static const struct host1x_cdma_ops host1x_cdma_ops = {
+	.start = cdma_start,
+	.stop = cdma_stop,
+	.kick = cdma_kick,
+
+	.timeout_init = cdma_timeout_init,
+	.timeout_destroy = cdma_timeout_destroy,
+	.timeout_teardown_begin = cdma_timeout_teardown_begin,
+	.timeout_teardown_end = cdma_timeout_teardown_end,
+	.timeout_cpu_incr = cdma_timeout_cpu_incr,
+};
+
+static const struct host1x_pushbuffer_ops host1x_pushbuffer_ops = {
+	.reset = push_buffer_reset,
+	.init = push_buffer_init,
+	.destroy = push_buffer_destroy,
+	.push_to = push_buffer_push_to,
+	.pop_from = push_buffer_pop_from,
+	.space = push_buffer_space,
+	.putptr = push_buffer_putptr,
+};
+
diff --git a/drivers/gpu/host1x/hw/cdma_hw.h b/drivers/gpu/host1x/hw/cdma_hw.h
new file mode 100644
index 0000000..4ce2f43
--- /dev/null
+++ b/drivers/gpu/host1x/hw/cdma_hw.h
@@ -0,0 +1,37 @@
+/*
+ * Tegra host1x Command DMA
+ *
+ * Copyright (c) 2011-2012, NVIDIA Corporation.
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
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __HOST1X_CDMA_H
+#define __HOST1X_CDMA_H
+
+/*
+ * Size of the sync queue. If it is too small, we won't be able to queue up
+ * many command buffers. If it is too large, we waste memory.
+ */
+#define HOST1X_SYNC_QUEUE_SIZE 512
+
+/*
+ * Number of gathers we allow to be queued up per channel. Must be a
+ * power of two. Currently sized such that pushbuffer is 4KB (512*8B).
+ */
+#define HOST1X_GATHER_QUEUE_SIZE 512
+
+/* 8 bytes per slot. (This number does not include the final RESTART.) */
+#define PUSH_BUFFER_SIZE (HOST1X_GATHER_QUEUE_SIZE * 8)
+
+#endif
diff --git a/drivers/gpu/host1x/hw/channel_hw.c b/drivers/gpu/host1x/hw/channel_hw.c
new file mode 100644
index 0000000..3bdfef6
--- /dev/null
+++ b/drivers/gpu/host1x/hw/channel_hw.c
@@ -0,0 +1,147 @@
+/*
+ * Tegra host1x Channel
+ *
+ * Copyright (c) 2010-2012, NVIDIA Corporation.
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
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/host1x.h>
+#include "channel.h"
+#include "dev.h"
+#include <linux/slab.h>
+#include "intr.h"
+#include <trace/events/host1x.h>
+
+static void submit_gathers(struct host1x_job *job)
+{
+	/* push user gathers */
+	int i;
+	for (i = 0 ; i < job->num_gathers; i++) {
+		struct host1x_job_gather *g = &job->gathers[i];
+		u32 op1 = host1x_opcode_gather(g->words);
+		u32 op2 = g->mem_base + g->offset;
+		host1x_cdma_push_gather(&job->ch->cdma,
+				job->gathers[i].ref,
+				job->gathers[i].offset,
+				op1, op2);
+	}
+}
+
+static int channel_submit(struct host1x_job *job)
+{
+	struct host1x_channel *ch = job->ch;
+	struct host1x_syncpt *sp;
+	u32 user_syncpt_incrs = job->syncpt_incrs;
+	u32 prev_max = 0;
+	u32 syncval;
+	int err;
+	void *completed_waiter = NULL;
+
+	sp = host1x_get_host(job->ch->dev)->syncpt + job->syncpt_id;
+	trace_host1x_channel_submit(ch->dev->name,
+			job->num_gathers, job->num_relocs, job->num_waitchk,
+			job->syncpt_id, job->syncpt_incrs);
+
+	/* before error checks, return current max */
+	prev_max = job->syncpt_end = host1x_syncpt_read_max(sp);
+
+	/* get submit lock */
+	err = mutex_lock_interruptible(&ch->submitlock);
+	if (err)
+		goto error;
+
+	completed_waiter = host1x_intr_alloc_waiter();
+	if (!completed_waiter) {
+		mutex_unlock(&ch->submitlock);
+		err = -ENOMEM;
+		goto error;
+	}
+
+	/* begin a CDMA submit */
+	err = host1x_cdma_begin(&ch->cdma, job);
+	if (err) {
+		mutex_unlock(&ch->submitlock);
+		goto error;
+	}
+
+	if (job->serialize) {
+		/*
+		 * Force serialization by inserting a host wait for the
+		 * previous job to finish before this one can commence.
+		 */
+		host1x_cdma_push(&ch->cdma,
+				host1x_opcode_setclass(NV_HOST1X_CLASS_ID,
+					host1x_uclass_wait_syncpt_r(),
+					1),
+				host1x_class_host_wait_syncpt(job->syncpt_id,
+					host1x_syncpt_read_max(sp)));
+	}
+
+	syncval = host1x_syncpt_incr_max(sp, user_syncpt_incrs);
+
+	job->syncpt_end = syncval;
+
+	/* add a setclass for modules that require it */
+	if (job->class)
+		host1x_cdma_push(&ch->cdma,
+			host1x_opcode_setclass(job->class, 0, 0),
+			HOST1X_OPCODE_NOOP);
+
+	submit_gathers(job);
+
+	/* end CDMA submit & stash pinned hMems into sync queue */
+	host1x_cdma_end(&ch->cdma, job);
+
+	trace_host1x_channel_submitted(ch->dev->name,
+			prev_max, syncval);
+
+	/* schedule a submit complete interrupt */
+	err = host1x_intr_add_action(&host1x_get_host(ch->dev)->intr,
+			job->syncpt_id, syncval,
+			HOST1X_INTR_ACTION_SUBMIT_COMPLETE, ch,
+			completed_waiter,
+			NULL);
+	completed_waiter = NULL;
+	WARN(err, "Failed to set submit complete interrupt");
+
+	mutex_unlock(&ch->submitlock);
+
+	return 0;
+
+error:
+	kfree(completed_waiter);
+	return err;
+}
+
+static inline void __iomem *host1x_channel_regs(void __iomem *p, int ndx)
+{
+	p += ndx * NV_HOST1X_CHANNEL_MAP_SIZE_BYTES;
+	return p;
+}
+
+static int host1x_channel_init(struct host1x_channel *ch,
+	struct host1x *dev, int index)
+{
+	ch->chid = index;
+	mutex_init(&ch->reflock);
+	mutex_init(&ch->submitlock);
+
+	ch->regs = host1x_channel_regs(dev->regs, index);
+	return 0;
+}
+
+static const struct host1x_channel_ops host1x_channel_ops = {
+	.init = host1x_channel_init,
+	.submit = channel_submit,
+};
diff --git a/drivers/gpu/host1x/hw/host1x01.c b/drivers/gpu/host1x/hw/host1x01.c
index c5c55a3..3f41619 100644
--- a/drivers/gpu/host1x/hw/host1x01.c
+++ b/drivers/gpu/host1x/hw/host1x01.c
@@ -24,13 +24,19 @@
 
 #include "hw/host1x01.h"
 #include "dev.h"
+#include "channel.h"
 #include "hw/host1x01_hardware.h"
 
+#include "hw/channel_hw.c"
+#include "hw/cdma_hw.c"
 #include "hw/syncpt_hw.c"
 #include "hw/intr_hw.c"
 
 int host1x01_init(struct host1x *host)
 {
+	host->channel_op = host1x_channel_ops;
+	host->cdma_op = host1x_cdma_ops;
+	host->cdma_pb_op = host1x_pushbuffer_ops;
 	host->syncpt_op = host1x_syncpt_ops;
 	host->intr_op = host1x_intr_ops;
 
diff --git a/drivers/gpu/host1x/hw/host1x01_hardware.h b/drivers/gpu/host1x/hw/host1x01_hardware.h
index 4e57f21..020798f 100644
--- a/drivers/gpu/host1x/hw/host1x01_hardware.h
+++ b/drivers/gpu/host1x/hw/host1x01_hardware.h
@@ -21,6 +21,130 @@
 
 #include <linux/types.h>
 #include <linux/bitops.h>
+#include "hw_host1x01_channel.h"
 #include "hw_host1x01_sync.h"
+#include "hw_host1x01_uclass.h"
+
+/* channel registers */
+#define NV_HOST1X_CHANNEL_MAP_SIZE_BYTES 16384
+
+static inline u32 host1x_class_host_wait_syncpt(
+	unsigned indx, unsigned threshold)
+{
+	return host1x_uclass_wait_syncpt_indx_f(indx)
+		| host1x_uclass_wait_syncpt_thresh_f(threshold);
+}
+
+static inline u32 host1x_class_host_load_syncpt_base(
+	unsigned indx, unsigned threshold)
+{
+	return host1x_uclass_load_syncpt_base_base_indx_f(indx)
+		| host1x_uclass_load_syncpt_base_value_f(threshold);
+}
+
+static inline u32 host1x_class_host_wait_syncpt_base(
+	unsigned indx, unsigned base_indx, unsigned offset)
+{
+	return host1x_uclass_wait_syncpt_base_indx_f(indx)
+		| host1x_uclass_wait_syncpt_base_base_indx_f(base_indx)
+		| host1x_uclass_wait_syncpt_base_offset_f(offset);
+}
+
+static inline u32 host1x_class_host_incr_syncpt_base(
+	unsigned base_indx, unsigned offset)
+{
+	return host1x_uclass_incr_syncpt_base_base_indx_f(base_indx)
+		| host1x_uclass_incr_syncpt_base_offset_f(offset);
+}
+
+static inline u32 host1x_class_host_incr_syncpt(
+	unsigned cond, unsigned indx)
+{
+	return host1x_uclass_incr_syncpt_cond_f(cond)
+		| host1x_uclass_incr_syncpt_indx_f(indx);
+}
+
+static inline u32 host1x_class_host_indoff_reg_write(
+	unsigned mod_id, unsigned offset, bool auto_inc)
+{
+	u32 v = host1x_uclass_indoff_indbe_f(0xf)
+		| host1x_uclass_indoff_indmodid_f(mod_id)
+		| host1x_uclass_indoff_indroffset_f(offset);
+	if (auto_inc)
+		v |= host1x_uclass_indoff_autoinc_f(1);
+	return v;
+}
+
+static inline u32 host1x_class_host_indoff_reg_read(
+	unsigned mod_id, unsigned offset, bool auto_inc)
+{
+	u32 v = host1x_uclass_indoff_indmodid_f(mod_id)
+		| host1x_uclass_indoff_indroffset_f(offset)
+		| host1x_uclass_indoff_rwn_read_v();
+	if (auto_inc)
+		v |= host1x_uclass_indoff_autoinc_f(1);
+	return v;
+}
+
+
+/* cdma opcodes */
+static inline u32 host1x_opcode_setclass(
+	unsigned class_id, unsigned offset, unsigned mask)
+{
+	return (0 << 28) | (offset << 16) | (class_id << 6) | mask;
+}
+
+static inline u32 host1x_opcode_incr(unsigned offset, unsigned count)
+{
+	return (1 << 28) | (offset << 16) | count;
+}
+
+static inline u32 host1x_opcode_nonincr(unsigned offset, unsigned count)
+{
+	return (2 << 28) | (offset << 16) | count;
+}
+
+static inline u32 host1x_opcode_mask(unsigned offset, unsigned mask)
+{
+	return (3 << 28) | (offset << 16) | mask;
+}
+
+static inline u32 host1x_opcode_imm(unsigned offset, unsigned value)
+{
+	return (4 << 28) | (offset << 16) | value;
+}
+
+static inline u32 host1x_opcode_imm_incr_syncpt(unsigned cond, unsigned indx)
+{
+	return host1x_opcode_imm(host1x_uclass_incr_syncpt_r(),
+		host1x_class_host_incr_syncpt(cond, indx));
+}
+
+static inline u32 host1x_opcode_restart(unsigned address)
+{
+	return (5 << 28) | (address >> 4);
+}
+
+static inline u32 host1x_opcode_gather(unsigned count)
+{
+	return (6 << 28) | count;
+}
+
+static inline u32 host1x_opcode_gather_nonincr(unsigned offset,	unsigned count)
+{
+	return (6 << 28) | (offset << 16) | BIT(15) | count;
+}
+
+static inline u32 host1x_opcode_gather_incr(unsigned offset, unsigned count)
+{
+	return (6 << 28) | (offset << 16) | BIT(15) | BIT(14) | count;
+}
+
+#define HOST1X_OPCODE_NOOP host1x_opcode_nonincr(0, 0)
+
+static inline u32 host1x_mask2(unsigned x, unsigned y)
+{
+	return 1 | (1 << (y - x));
+}
 
 #endif
diff --git a/drivers/gpu/host1x/hw/hw_host1x01_channel.h b/drivers/gpu/host1x/hw/hw_host1x01_channel.h
new file mode 100644
index 0000000..3a23d57
--- /dev/null
+++ b/drivers/gpu/host1x/hw/hw_host1x01_channel.h
@@ -0,0 +1,86 @@
+/*
+ * Copyright (c) 2012, NVIDIA Corporation.
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
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+
+ /*
+  * Function naming determines intended use:
+  *
+  *     <x>_r(void) : Returns the offset for register <x>.
+  *
+  *     <x>_w(void) : Returns the word offset for word (4 byte) element <x>.
+  *
+  *     <x>_<y>_s(void) : Returns size of field <y> of register <x> in bits.
+  *
+  *     <x>_<y>_f(u32 v) : Returns a value based on 'v' which has been shifted
+  *         and masked to place it at field <y> of register <x>.  This value
+  *         can be |'d with others to produce a full register value for
+  *         register <x>.
+  *
+  *     <x>_<y>_m(void) : Returns a mask for field <y> of register <x>.  This
+  *         value can be ~'d and then &'d to clear the value of field <y> for
+  *         register <x>.
+  *
+  *     <x>_<y>_<z>_f(void) : Returns the constant value <z> after being shifted
+  *         to place it at field <y> of register <x>.  This value can be |'d
+  *         with others to produce a full register value for <x>.
+  *
+  *     <x>_<y>_v(u32 r) : Returns the value of field <y> from a full register
+  *         <x> value 'r' after being shifted to place its LSB at bit 0.
+  *         This value is suitable for direct comparison with other unshifted
+  *         values appropriate for use in field <y> of register <x>.
+  *
+  *     <x>_<y>_<z>_v(void) : Returns the constant value for <z> defined for
+  *         field <y> of register <x>.  This value is suitable for direct
+  *         comparison with unshifted values appropriate for use in field <y>
+  *         of register <x>.
+  */
+
+#ifndef __hw_host1x_channel_host1x_h__
+#define __hw_host1x_channel_host1x_h__
+
+static inline u32 host1x_channel_dmastart_r(void)
+{
+	return 0x14;
+}
+static inline u32 host1x_channel_dmaput_r(void)
+{
+	return 0x18;
+}
+static inline u32 host1x_channel_dmaget_r(void)
+{
+	return 0x1c;
+}
+static inline u32 host1x_channel_dmaend_r(void)
+{
+	return 0x20;
+}
+static inline u32 host1x_channel_dmactrl_r(void)
+{
+	return 0x24;
+}
+static inline u32 host1x_channel_dmactrl_dmastop_f(u32 v)
+{
+	return (v & 0x1) << 0;
+}
+static inline u32 host1x_channel_dmactrl_dmagetrst_f(u32 v)
+{
+	return (v & 0x1) << 1;
+}
+static inline u32 host1x_channel_dmactrl_dmainitget_f(u32 v)
+{
+	return (v & 0x1) << 2;
+}
+#endif
diff --git a/drivers/gpu/host1x/hw/hw_host1x01_sync.h b/drivers/gpu/host1x/hw/hw_host1x01_sync.h
index b06a2c5..c9342da 100644
--- a/drivers/gpu/host1x/hw/hw_host1x01_sync.h
+++ b/drivers/gpu/host1x/hw/hw_host1x01_sync.h
@@ -63,6 +63,14 @@ static inline u32 host1x_sync_syncpt_thresh_int_enable_cpu0_r(void)
 {
 	return 0x68;
 }
+static inline u32 host1x_sync_cmdproc_stop_r(void)
+{
+	return 0xac;
+}
+static inline u32 host1x_sync_ch_teardown_r(void)
+{
+	return 0xb0;
+}
 static inline u32 host1x_sync_usec_clk_r(void)
 {
 	return 0x1a4;
diff --git a/drivers/gpu/host1x/hw/hw_host1x01_uclass.h b/drivers/gpu/host1x/hw/hw_host1x01_uclass.h
new file mode 100644
index 0000000..948cfe3
--- /dev/null
+++ b/drivers/gpu/host1x/hw/hw_host1x01_uclass.h
@@ -0,0 +1,130 @@
+/*
+ * Copyright (c) 2012, NVIDIA Corporation.
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
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ *
+ */
+
+ /*
+  * Function naming determines intended use:
+  *
+  *     <x>_r(void) : Returns the offset for register <x>.
+  *
+  *     <x>_w(void) : Returns the word offset for word (4 byte) element <x>.
+  *
+  *     <x>_<y>_s(void) : Returns size of field <y> of register <x> in bits.
+  *
+  *     <x>_<y>_f(u32 v) : Returns a value based on 'v' which has been shifted
+  *         and masked to place it at field <y> of register <x>.  This value
+  *         can be |'d with others to produce a full register value for
+  *         register <x>.
+  *
+  *     <x>_<y>_m(void) : Returns a mask for field <y> of register <x>.  This
+  *         value can be ~'d and then &'d to clear the value of field <y> for
+  *         register <x>.
+  *
+  *     <x>_<y>_<z>_f(void) : Returns the constant value <z> after being shifted
+  *         to place it at field <y> of register <x>.  This value can be |'d
+  *         with others to produce a full register value for <x>.
+  *
+  *     <x>_<y>_v(u32 r) : Returns the value of field <y> from a full register
+  *         <x> value 'r' after being shifted to place its LSB at bit 0.
+  *         This value is suitable for direct comparison with other unshifted
+  *         values appropriate for use in field <y> of register <x>.
+  *
+  *     <x>_<y>_<z>_v(void) : Returns the constant value for <z> defined for
+  *         field <y> of register <x>.  This value is suitable for direct
+  *         comparison with unshifted values appropriate for use in field <y>
+  *         of register <x>.
+  */
+
+#ifndef __hw_host1x_uclass_host1x_h__
+#define __hw_host1x_uclass_host1x_h__
+
+static inline u32 host1x_uclass_incr_syncpt_r(void)
+{
+	return 0x0;
+}
+static inline u32 host1x_uclass_incr_syncpt_cond_f(u32 v)
+{
+	return (v & 0xff) << 8;
+}
+static inline u32 host1x_uclass_incr_syncpt_indx_f(u32 v)
+{
+	return (v & 0xff) << 0;
+}
+static inline u32 host1x_uclass_wait_syncpt_r(void)
+{
+	return 0x8;
+}
+static inline u32 host1x_uclass_wait_syncpt_indx_f(u32 v)
+{
+	return (v & 0xff) << 24;
+}
+static inline u32 host1x_uclass_wait_syncpt_thresh_f(u32 v)
+{
+	return (v & 0xffffff) << 0;
+}
+static inline u32 host1x_uclass_wait_syncpt_base_indx_f(u32 v)
+{
+	return (v & 0xff) << 24;
+}
+static inline u32 host1x_uclass_wait_syncpt_base_base_indx_f(u32 v)
+{
+	return (v & 0xff) << 16;
+}
+static inline u32 host1x_uclass_wait_syncpt_base_offset_f(u32 v)
+{
+	return (v & 0xffff) << 0;
+}
+static inline u32 host1x_uclass_load_syncpt_base_base_indx_f(u32 v)
+{
+	return (v & 0xff) << 24;
+}
+static inline u32 host1x_uclass_load_syncpt_base_value_f(u32 v)
+{
+	return (v & 0xffffff) << 0;
+}
+static inline u32 host1x_uclass_incr_syncpt_base_base_indx_f(u32 v)
+{
+	return (v & 0xff) << 24;
+}
+static inline u32 host1x_uclass_incr_syncpt_base_offset_f(u32 v)
+{
+	return (v & 0xffffff) << 0;
+}
+static inline u32 host1x_uclass_indoff_r(void)
+{
+	return 0x2d;
+}
+static inline u32 host1x_uclass_indoff_indbe_f(u32 v)
+{
+	return (v & 0xf) << 28;
+}
+static inline u32 host1x_uclass_indoff_autoinc_f(u32 v)
+{
+	return (v & 0x1) << 27;
+}
+static inline u32 host1x_uclass_indoff_indmodid_f(u32 v)
+{
+	return (v & 0xff) << 18;
+}
+static inline u32 host1x_uclass_indoff_indroffset_f(u32 v)
+{
+	return (v & 0xffff) << 2;
+}
+static inline u32 host1x_uclass_indoff_rwn_read_v(void)
+{
+	return 1;
+}
+#endif
diff --git a/drivers/gpu/host1x/hw/syncpt_hw.c b/drivers/gpu/host1x/hw/syncpt_hw.c
index 44a10b0..a070473 100644
--- a/drivers/gpu/host1x/hw/syncpt_hw.c
+++ b/drivers/gpu/host1x/hw/syncpt_hw.c
@@ -97,6 +97,15 @@ static void syncpt_cpu_incr(struct host1x_syncpt *sp)
 	wmb();
 }
 
+/* remove a wait pointed to by patch_addr */
+static int syncpt_patch_wait(struct host1x_syncpt *sp, void *patch_addr)
+{
+	u32 override = host1x_class_host_wait_syncpt(
+			NVSYNCPT_GRAPHICS_HOST, 0);
+	__raw_writel(override, patch_addr);
+	return 0;
+}
+
 static const char *syncpt_name(struct host1x_syncpt *sp)
 {
 	struct host1x_device_info *info = &sp->dev->info;
@@ -141,6 +150,7 @@ static const struct host1x_syncpt_ops host1x_syncpt_ops = {
 	.read_wait_base = syncpt_read_wait_base,
 	.load_min = syncpt_load_min,
 	.cpu_incr = syncpt_cpu_incr,
+	.patch_wait = syncpt_patch_wait,
 	.debug = syncpt_debug,
 	.name = syncpt_name,
 };
diff --git a/drivers/gpu/host1x/intr.c b/drivers/gpu/host1x/intr.c
index f166224..a524826 100644
--- a/drivers/gpu/host1x/intr.c
+++ b/drivers/gpu/host1x/intr.c
@@ -20,6 +20,8 @@
 #include <linux/interrupt.h>
 #include <linux/slab.h>
 #include <linux/irq.h>
+#include <trace/events/host1x.h>
+#include "channel.h"
 #include "dev.h"
 
 /* Wait list management */
@@ -74,7 +76,7 @@ static void remove_completed_waiters(struct list_head *head, u32 sync,
 			struct list_head completed[HOST1X_INTR_ACTION_COUNT])
 {
 	struct list_head *dest;
-	struct host1x_waitlist *waiter, *next;
+	struct host1x_waitlist *waiter, *next, *prev;
 
 	list_for_each_entry_safe(waiter, next, head, list) {
 		if ((s32)(waiter->thresh - sync) > 0)
@@ -82,6 +84,17 @@ static void remove_completed_waiters(struct list_head *head, u32 sync,
 
 		dest = completed + waiter->action;
 
+		/* consolidate submit cleanups */
+		if (waiter->action == HOST1X_INTR_ACTION_SUBMIT_COMPLETE
+			&& !list_empty(dest)) {
+			prev = list_entry(dest->prev,
+					struct host1x_waitlist, list);
+			if (prev->data == waiter->data) {
+				prev->count++;
+				dest = NULL;
+			}
+		}
+
 		/* PENDING->REMOVED or CANCELLED->HANDLED */
 		if (atomic_inc_return(&waiter->state) == WLS_HANDLED || !dest) {
 			list_del(&waiter->list);
@@ -104,6 +117,19 @@ void reset_threshold_interrupt(struct host1x_intr *intr,
 	host1x->intr_op.enable_syncpt_intr(intr, id);
 }
 
+static void action_submit_complete(struct host1x_waitlist *waiter)
+{
+	struct host1x_channel *channel = waiter->data;
+	int nr_completed = waiter->count;
+
+	host1x_cdma_update(&channel->cdma);
+
+	/*  Add nr_completed to trace */
+	trace_host1x_channel_submit_complete(channel->dev->name,
+			nr_completed, waiter->thresh);
+
+}
+
 static void action_wakeup(struct host1x_waitlist *waiter)
 {
 	wait_queue_head_t *wq = waiter->data;
@@ -121,6 +147,7 @@ static void action_wakeup_interruptible(struct host1x_waitlist *waiter)
 typedef void (*action_handler)(struct host1x_waitlist *waiter);
 
 static action_handler action_handlers[HOST1X_INTR_ACTION_COUNT] = {
+	action_submit_complete,
 	action_wakeup,
 	action_wakeup_interruptible,
 };
diff --git a/drivers/gpu/host1x/intr.h b/drivers/gpu/host1x/intr.h
index 3625bf3..fa4b2c4 100644
--- a/drivers/gpu/host1x/intr.h
+++ b/drivers/gpu/host1x/intr.h
@@ -28,6 +28,12 @@ struct host1x_channel;
 
 enum host1x_intr_action {
 	/*
+	 * Perform cleanup after a submit has completed.
+	 * 'data' points to a channel
+	 */
+	HOST1X_INTR_ACTION_SUBMIT_COMPLETE = 0,
+
+	/*
 	 * Wake up a  task.
 	 * 'data' points to a wait_queue_head_t
 	 */
diff --git a/drivers/gpu/host1x/job.c b/drivers/gpu/host1x/job.c
new file mode 100644
index 0000000..cc8ca2f
--- /dev/null
+++ b/drivers/gpu/host1x/job.c
@@ -0,0 +1,618 @@
+/*
+ * Tegra host1x Job
+ *
+ * Copyright (c) 2010-2012, NVIDIA Corporation.
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
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/kref.h>
+#include <linux/err.h>
+#include <linux/vmalloc.h>
+#include <linux/scatterlist.h>
+#include <linux/host1x.h>
+#include <trace/events/host1x.h>
+#include <linux/dma-mapping.h>
+#include "channel.h"
+#include "syncpt.h"
+#include "dev.h"
+#include "memmgr.h"
+
+#ifdef CONFIG_TEGRA_HOST1X_FIREWALL
+static int host1x_firewall = 1;
+#else
+static int host1x_firewall;
+#endif
+
+struct host1x_job *host1x_job_alloc(struct host1x_channel *ch,
+		u32 num_cmdbufs, u32 num_relocs, u32 num_waitchks)
+{
+	struct host1x_job *job = NULL;
+	int num_unpins = num_cmdbufs + num_relocs;
+	s64 total;
+	void *mem;
+
+	/* Check that we're not going to overflow */
+	total = sizeof(struct host1x_job)
+			+ num_relocs * sizeof(struct host1x_reloc)
+			+ num_unpins * sizeof(struct host1x_job_unpin_data)
+			+ num_waitchks * sizeof(struct host1x_waitchk)
+			+ num_cmdbufs * sizeof(struct host1x_job_gather)
+			+ num_unpins * sizeof(dma_addr_t)
+			+ num_unpins * sizeof(u32 *);
+	if (total > ULONG_MAX)
+		return NULL;
+
+	mem = job = kzalloc(total, GFP_KERNEL);
+	if (!job)
+		return NULL;
+
+	kref_init(&job->ref);
+	job->ch = ch;
+
+	/* First init state to zero */
+
+	/*
+	 * Redistribute memory to the structs.
+	 * Overflows and negative conditions have
+	 * already been checked in job_alloc().
+	 */
+	mem += sizeof(struct host1x_job);
+	job->relocarray = num_relocs ? mem : NULL;
+	mem += num_relocs * sizeof(struct host1x_reloc);
+	job->unpins = num_unpins ? mem : NULL;
+	mem += num_unpins * sizeof(struct host1x_job_unpin_data);
+	job->waitchk = num_waitchks ? mem : NULL;
+	mem += num_waitchks * sizeof(struct host1x_waitchk);
+	job->gathers = num_cmdbufs ? mem : NULL;
+	mem += num_cmdbufs * sizeof(struct host1x_job_gather);
+	job->addr_phys = num_unpins ? mem : NULL;
+	mem += num_unpins * sizeof(dma_addr_t);
+	job->pin_ids = num_unpins ? mem : NULL;
+
+	job->reloc_addr_phys = job->addr_phys;
+	job->gather_addr_phys = &job->addr_phys[num_relocs];
+
+	return job;
+}
+EXPORT_SYMBOL(host1x_job_alloc);
+
+void host1x_job_get(struct host1x_job *job)
+{
+	kref_get(&job->ref);
+}
+EXPORT_SYMBOL(host1x_job_get);
+
+static void job_free(struct kref *ref)
+{
+	struct host1x_job *job = container_of(ref, struct host1x_job, ref);
+
+	kfree(job);
+}
+
+void host1x_job_put(struct host1x_job *job)
+{
+	kref_put(&job->ref, job_free);
+}
+EXPORT_SYMBOL(host1x_job_put);
+
+void host1x_job_add_gather(struct host1x_job *job,
+		u32 mem_id, u32 words, u32 offset)
+{
+	struct host1x_job_gather *cur_gather =
+			&job->gathers[job->num_gathers];
+
+	cur_gather->words = words;
+	cur_gather->mem_id = mem_id;
+	cur_gather->offset = offset;
+	job->num_gathers++;
+}
+EXPORT_SYMBOL(host1x_job_add_gather);
+
+/*
+ * Check driver supplied waitchk structs for syncpt thresholds
+ * that have already been satisfied and NULL the comparison (to
+ * avoid a wrap condition in the HW).
+ */
+static int do_waitchks(struct host1x_job *job, struct host1x *host,
+		u32 patch_mem, struct mem_handle *h)
+{
+	int i;
+
+	/* compare syncpt vs wait threshold */
+	for (i = 0; i < job->num_waitchk; i++) {
+		struct host1x_waitchk *wait = &job->waitchk[i];
+		struct host1x_syncpt *sp =
+			host1x_syncpt_get(host, wait->syncpt_id);
+
+		/* validate syncpt id */
+		if (wait->syncpt_id > host1x_syncpt_nb_pts(host))
+			continue;
+
+		/* skip all other gathers */
+		if (patch_mem != wait->mem)
+			continue;
+
+		trace_host1x_syncpt_wait_check(wait->mem, wait->offset,
+				wait->syncpt_id, wait->thresh,
+				host1x_syncpt_read_min(sp));
+		if (host1x_syncpt_is_expired(
+			host1x_syncpt_get(host, wait->syncpt_id),
+			wait->thresh)) {
+			struct host1x_syncpt *sp =
+				host1x_syncpt_get(host, wait->syncpt_id);
+
+			void *patch_addr = NULL;
+
+			/*
+			 * NULL an already satisfied WAIT_SYNCPT host method,
+			 * by patching its args in the command stream. The
+			 * method data is changed to reference a reserved
+			 * (never given out or incr) NVSYNCPT_GRAPHICS_HOST
+			 * syncpt with a matching threshold value of 0, so
+			 * is guaranteed to be popped by the host HW.
+			 */
+			dev_dbg(&host->dev->dev,
+			    "drop WAIT id %d (%s) thresh 0x%x, min 0x%x\n",
+			    wait->syncpt_id, sp->name, wait->thresh,
+			    host1x_syncpt_read_min(sp));
+
+			/* patch the wait */
+			patch_addr = host1x_memmgr_kmap(h,
+					wait->offset >> PAGE_SHIFT);
+			if (patch_addr) {
+				host1x_syncpt_patch_wait(sp,
+					(patch_addr +
+						(wait->offset & ~PAGE_MASK)));
+				host1x_memmgr_kunmap(h,
+						wait->offset >> PAGE_SHIFT,
+						patch_addr);
+			} else {
+				pr_err("Couldn't map cmdbuf for wait check\n");
+			}
+		}
+
+		wait->mem = 0;
+	}
+	return 0;
+}
+
+
+static int pin_job_mem(struct host1x_job *job)
+{
+	int i;
+	int count = 0;
+	int result;
+
+	for (i = 0; i < job->num_relocs; i++) {
+		struct host1x_reloc *reloc = &job->relocarray[i];
+		job->pin_ids[count] = reloc->target;
+		count++;
+	}
+
+	for (i = 0; i < job->num_gathers; i++) {
+		struct host1x_job_gather *g = &job->gathers[i];
+		job->pin_ids[count] = g->mem_id;
+		count++;
+	}
+
+	/* validate array and pin unique ids, get refs for unpinning */
+	result = host1x_memmgr_pin_array_ids(job->ch->dev,
+		job->pin_ids, job->addr_phys,
+		count,
+		job->unpins);
+
+	if (result > 0)
+		job->num_unpins = result;
+
+	return result;
+}
+
+static int do_relocs(struct host1x_job *job,
+		u32 cmdbuf_mem, struct mem_handle *h)
+{
+	int i = 0;
+	int last_page = -1;
+	void *cmdbuf_page_addr = NULL;
+
+	/* pin & patch the relocs for one gather */
+	while (i < job->num_relocs) {
+		struct host1x_reloc *reloc = &job->relocarray[i];
+
+		/* skip all other gathers */
+		if (cmdbuf_mem != reloc->cmdbuf_mem) {
+			i++;
+			continue;
+		}
+
+		if (last_page != reloc->cmdbuf_offset >> PAGE_SHIFT) {
+			if (cmdbuf_page_addr)
+				host1x_memmgr_kunmap(h,
+						last_page, cmdbuf_page_addr);
+
+			cmdbuf_page_addr = host1x_memmgr_kmap(h,
+					reloc->cmdbuf_offset >> PAGE_SHIFT);
+			last_page = reloc->cmdbuf_offset >> PAGE_SHIFT;
+
+			if (unlikely(!cmdbuf_page_addr)) {
+				pr_err("Couldn't map cmdbuf for relocation\n");
+				return -ENOMEM;
+			}
+		}
+
+		__raw_writel(
+			(job->reloc_addr_phys[i] +
+				reloc->target_offset) >> reloc->shift,
+			(cmdbuf_page_addr +
+				(reloc->cmdbuf_offset & ~PAGE_MASK)));
+
+		/* remove completed reloc from the job */
+		if (i != job->num_relocs - 1) {
+			struct host1x_reloc *reloc_last =
+				&job->relocarray[job->num_relocs - 1];
+			reloc->cmdbuf_mem	= reloc_last->cmdbuf_mem;
+			reloc->cmdbuf_offset	= reloc_last->cmdbuf_offset;
+			reloc->target		= reloc_last->target;
+			reloc->target_offset	= reloc_last->target_offset;
+			reloc->shift		= reloc_last->shift;
+			job->reloc_addr_phys[i] =
+				job->reloc_addr_phys[job->num_relocs - 1];
+			job->num_relocs--;
+		} else {
+			break;
+		}
+	}
+
+	if (cmdbuf_page_addr)
+		host1x_memmgr_kunmap(h, last_page, cmdbuf_page_addr);
+
+	return 0;
+}
+
+static int check_reloc(struct host1x_reloc *reloc,
+		u32 cmdbuf_id, int offset)
+{
+	int err = 0;
+	if (reloc->cmdbuf_mem != cmdbuf_id
+			|| reloc->cmdbuf_offset != offset * sizeof(u32))
+		err = -EINVAL;
+
+	return err;
+}
+
+static int check_mask(struct host1x_job *job,
+		struct platform_device *pdev,
+		struct host1x_reloc **reloc, int *num_relocs,
+		u32 cmdbuf_id, int *offset,
+		u32 *words, u32 class, u32 reg, u32 mask)
+{
+	while (mask) {
+		if (*words == 0)
+			return -EINVAL;
+
+		if (mask & 1) {
+			if (job->is_addr_reg(pdev, class, reg)) {
+				if (!*num_relocs ||
+					check_reloc(*reloc, cmdbuf_id, *offset))
+					return -EINVAL;
+				(*reloc)++;
+				(*num_relocs)--;
+			}
+			(*words)--;
+			(*offset)++;
+		}
+		mask >>= 1;
+		reg += 1;
+	}
+
+	return 0;
+}
+
+static int check_incr(struct host1x_job *job,
+		struct platform_device *pdev,
+		struct host1x_reloc **reloc, int *num_relocs,
+		u32 cmdbuf_id, int *offset,
+		u32 *words, u32 class, u32 reg, u32 count)
+{
+	while (count) {
+		if (*words == 0)
+			return -EINVAL;
+
+		if (job->is_addr_reg(pdev, class, reg)) {
+			if (!*num_relocs ||
+				check_reloc(*reloc, cmdbuf_id, *offset))
+				return -EINVAL;
+			(*reloc)++;
+			(*num_relocs)--;
+		}
+		reg += 1;
+		(*words)--;
+		(*offset)++;
+		count--;
+	}
+
+	return 0;
+}
+
+static int check_nonincr(struct host1x_job *job,
+		struct platform_device *pdev,
+		struct host1x_reloc **reloc, int *num_relocs,
+		u32 cmdbuf_id, int *offset,
+		u32 *words, u32 class, u32 reg, u32 count)
+{
+	int is_addr_reg = job->is_addr_reg(pdev, class, reg);
+
+	while (count) {
+		if (*words == 0)
+			return -EINVAL;
+
+		if (is_addr_reg) {
+			if (!*num_relocs ||
+				check_reloc(*reloc, cmdbuf_id, *offset))
+				return -EINVAL;
+			(*reloc)++;
+			(*num_relocs)--;
+		}
+		(*words)--;
+		(*offset)++;
+		count--;
+	}
+
+	return 0;
+}
+
+static int validate(struct host1x_job *job, struct platform_device *pdev,
+		struct host1x_job_gather *g)
+{
+	struct host1x_reloc *reloc = job->relocarray;
+	int num_relocs = job->num_relocs;
+	u32 *cmdbuf_base;
+	int offset = 0;
+	unsigned int words;
+	int err = 0;
+	int class = 0;
+
+	if (!job->is_addr_reg)
+		return 0;
+
+	cmdbuf_base = host1x_memmgr_mmap(g->ref);
+	if (IS_ERR_OR_NULL(cmdbuf_base))
+		return PTR_ERR(cmdbuf_base);
+
+	words = g->words;
+	while (words && !err) {
+		u32 word = cmdbuf_base[offset];
+		u32 opcode = (word & 0xf0000000) >> 28;
+		u32 mask = 0;
+		u32 reg = 0;
+		u32 count = 0;
+
+		words--;
+		offset++;
+
+		switch (opcode) {
+		case 0:
+			class = word >> 6 & 0x3ff;
+			mask = word & 0x3f;
+			reg = word >> 16 & 0xfff;
+			err = check_mask(job, pdev,
+					&reloc, &num_relocs, g->mem_id,
+					&offset, &words, class, reg, mask);
+			if (err)
+				goto out;
+			break;
+		case 1:
+			reg = word >> 16 & 0xfff;
+			count = word & 0xffff;
+			err = check_incr(job, pdev,
+					&reloc, &num_relocs, g->mem_id,
+					&offset, &words, class, reg, count);
+			if (err)
+				goto out;
+			break;
+
+		case 2:
+			reg = word >> 16 & 0xfff;
+			count = word & 0xffff;
+			err = check_nonincr(job, pdev,
+					&reloc, &num_relocs, g->mem_id,
+					&offset, &words, class, reg, count);
+			if (err)
+				goto out;
+			break;
+
+		case 3:
+			mask = word & 0xffff;
+			reg = word >> 16 & 0xfff;
+			err = check_mask(job, pdev,
+					&reloc, &num_relocs, g->mem_id,
+					&offset, &words, class, reg, mask);
+			if (err)
+				goto out;
+			break;
+		case 4:
+		case 5:
+		case 14:
+			break;
+		default:
+			err = -EINVAL;
+			break;
+		}
+	}
+
+	/* No relocs should remain at this point */
+	if (num_relocs)
+		err = -EINVAL;
+
+out:
+	host1x_memmgr_munmap(g->ref, cmdbuf_base);
+
+	return err;
+}
+
+static inline int copy_gathers(struct host1x_job *job,
+		struct platform_device *pdev)
+{
+	size_t size = 0;
+	size_t offset = 0;
+	int i;
+
+	for (i = 0; i < job->num_gathers; i++) {
+		struct host1x_job_gather *g = &job->gathers[i];
+		size += g->words * sizeof(u32);
+	}
+
+	job->gather_copy_mapped = dma_alloc_writecombine(&pdev->dev,
+			size, &job->gather_copy, GFP_KERNEL);
+	if (IS_ERR(job->gather_copy_mapped)) {
+		int err = PTR_ERR(job->gather_copy_mapped);
+		job->gather_copy_mapped = NULL;
+		return err;
+	}
+
+	job->gather_copy_size = size;
+
+	for (i = 0; i < job->num_gathers; i++) {
+		struct host1x_job_gather *g = &job->gathers[i];
+		void *gather = host1x_memmgr_mmap(g->ref);
+		memcpy(job->gather_copy_mapped + offset,
+				gather + g->offset,
+				g->words * sizeof(u32));
+
+		g->mem_base = job->gather_copy;
+		g->offset = offset;
+		g->mem_id = 0;
+		g->ref = 0;
+
+		host1x_memmgr_munmap(g->ref, gather);
+		offset += g->words * sizeof(u32);
+	}
+
+	return 0;
+}
+
+int host1x_job_pin(struct host1x_job *job, struct platform_device *pdev)
+{
+	int err = 0, i = 0, j = 0;
+	struct host1x *host = host1x_get_host(pdev);
+	DECLARE_BITMAP(waitchk_mask, host1x_syncpt_nb_pts(host));
+
+	bitmap_zero(waitchk_mask, host1x_syncpt_nb_pts(host));
+	for (i = 0; i < job->num_waitchk; i++) {
+		u32 syncpt_id = job->waitchk[i].syncpt_id;
+		if (syncpt_id < host1x_syncpt_nb_pts(host))
+			set_bit(syncpt_id, waitchk_mask);
+	}
+
+	/* get current syncpt values for waitchk */
+	for_each_set_bit(i, &waitchk_mask[0], sizeof(waitchk_mask))
+		host1x_syncpt_load_min(host->syncpt + i);
+
+	/* pin memory */
+	err = pin_job_mem(job);
+	if (err <= 0)
+		goto fail;
+
+	/* patch gathers */
+	for (i = 0; i < job->num_gathers; i++) {
+		struct host1x_job_gather *g = &job->gathers[i];
+
+		/* process each gather mem only once */
+		if (!g->ref) {
+			g->ref = host1x_memmgr_get(g->mem_id, job->ch->dev);
+			if (IS_ERR(g->ref)) {
+				err = PTR_ERR(g->ref);
+				g->ref = NULL;
+				break;
+			}
+
+			g->mem_base = job->gather_addr_phys[i];
+
+			for (j = 0; j < job->num_gathers; j++) {
+				struct host1x_job_gather *tmp =
+					&job->gathers[j];
+				if (!tmp->ref && tmp->mem_id == g->mem_id) {
+					tmp->ref = g->ref;
+					tmp->mem_base = g->mem_base;
+				}
+			}
+			err = 0;
+			if (host1x_firewall)
+				err = validate(job, pdev, g);
+			if (err)
+				dev_err(&pdev->dev,
+					"Job validate returned %d\n", err);
+			if (!err)
+				err = do_relocs(job, g->mem_id,  g->ref);
+			if (!err)
+				err = do_waitchks(job, host,
+						g->mem_id, g->ref);
+			host1x_memmgr_put(g->ref);
+			if (err)
+				break;
+		}
+	}
+
+	if (host1x_firewall) {
+		err = copy_gathers(job, pdev);
+		if (err) {
+			host1x_job_unpin(job);
+			return err;
+		}
+	}
+
+fail:
+	wmb();
+
+	return err;
+}
+EXPORT_SYMBOL(host1x_job_pin);
+
+void host1x_job_unpin(struct host1x_job *job)
+{
+	int i;
+
+	for (i = 0; i < job->num_unpins; i++) {
+		struct host1x_job_unpin_data *unpin = &job->unpins[i];
+		host1x_memmgr_unpin(unpin->h, unpin->mem);
+		host1x_memmgr_put(unpin->h);
+	}
+	job->num_unpins = 0;
+
+	if (job->gather_copy_size)
+		dma_free_writecombine(&job->ch->dev->dev,
+			job->gather_copy_size,
+			job->gather_copy_mapped, job->gather_copy);
+}
+EXPORT_SYMBOL(host1x_job_unpin);
+
+/*
+ * Debug routine used to dump job entries
+ */
+void host1x_job_dump(struct device *dev, struct host1x_job *job)
+{
+	dev_dbg(dev, "    SYNCPT_ID   %d\n",
+		job->syncpt_id);
+	dev_dbg(dev, "    SYNCPT_VAL  %d\n",
+		job->syncpt_end);
+	dev_dbg(dev, "    FIRST_GET   0x%x\n",
+		job->first_get);
+	dev_dbg(dev, "    TIMEOUT     %d\n",
+		job->timeout);
+	dev_dbg(dev, "    NUM_SLOTS   %d\n",
+		job->num_slots);
+	dev_dbg(dev, "    NUM_HANDLES %d\n",
+		job->num_unpins);
+}
diff --git a/drivers/gpu/host1x/memmgr.c b/drivers/gpu/host1x/memmgr.c
new file mode 100644
index 0000000..9cf604f
--- /dev/null
+++ b/drivers/gpu/host1x/memmgr.c
@@ -0,0 +1,174 @@
+/*
+ * Tegra host1x Memory Management Abstraction
+ *
+ * Copyright (c) 2012, NVIDIA Corporation.
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
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#include <linux/host1x.h>
+#include <linux/kernel.h>
+#include <linux/err.h>
+
+#include "memmgr.h"
+#include "cma.h"
+
+struct mem_handle *host1x_memmgr_alloc(size_t size, size_t align, int flags)
+{
+	return NULL;
+}
+
+struct mem_handle *host1x_memmgr_get(u32 id, struct platform_device *dev)
+{
+	struct mem_handle *h = NULL;
+
+	switch (host1x_memmgr_type(id)) {
+#if defined(CONFIG_TEGRA_HOST1X_CMA)
+	case mem_mgr_type_cma:
+		h = (struct mem_handle *) host1x_cma_get(id, dev);
+		break;
+#endif
+	default:
+		break;
+	}
+
+	return h;
+}
+
+void host1x_memmgr_put(struct mem_handle *handle)
+{
+	switch (host1x_memmgr_type((u32)handle)) {
+#if defined(CONFIG_TEGRA_HOST1X_CMA)
+	case mem_mgr_type_cma:
+		host1x_cma_put(handle);
+		break;
+#endif
+	default:
+		break;
+	}
+}
+
+struct sg_table *host1x_memmgr_pin(struct mem_handle *handle)
+{
+	switch (host1x_memmgr_type((u32)handle)) {
+#if defined(CONFIG_TEGRA_HOST1X_CMA)
+	case mem_mgr_type_cma:
+		return host1x_cma_pin(handle);
+		break;
+#endif
+	default:
+		return 0;
+		break;
+	}
+}
+
+void host1x_memmgr_unpin(struct mem_handle *handle, struct sg_table *sgt)
+{
+	switch (host1x_memmgr_type((u32)handle)) {
+#if defined(CONFIG_TEGRA_HOST1X_CMA)
+	case mem_mgr_type_cma:
+		host1x_cma_unpin(handle, sgt);
+		break;
+#endif
+	default:
+		break;
+	}
+}
+
+void *host1x_memmgr_mmap(struct mem_handle *handle)
+{
+	switch (host1x_memmgr_type((u32)handle)) {
+#if defined(CONFIG_TEGRA_HOST1X_CMA)
+	case mem_mgr_type_cma:
+		return host1x_cma_mmap(handle);
+		break;
+#endif
+	default:
+		return 0;
+		break;
+	}
+}
+
+void host1x_memmgr_munmap(struct mem_handle *handle, void *addr)
+{
+	switch (host1x_memmgr_type((u32)handle)) {
+#if defined(CONFIG_TEGRA_HOST1X_CMA)
+	case mem_mgr_type_cma:
+		host1x_cma_munmap(handle, addr);
+		break;
+#endif
+	default:
+		break;
+	}
+}
+
+void *host1x_memmgr_kmap(struct mem_handle *handle, unsigned int pagenum)
+{
+	switch (host1x_memmgr_type((u32)handle)) {
+#if defined(CONFIG_TEGRA_HOST1X_CMA)
+	case mem_mgr_type_cma:
+		return host1x_cma_kmap(handle, pagenum);
+		break;
+#endif
+	default:
+		return 0;
+		break;
+	}
+}
+
+void host1x_memmgr_kunmap(struct mem_handle *handle, unsigned int pagenum,
+		void *addr)
+{
+	switch (host1x_memmgr_type((u32)handle)) {
+#if defined(CONFIG_TEGRA_HOST1X_CMA)
+	case mem_mgr_type_cma:
+		host1x_cma_kunmap(handle, pagenum, addr);
+		break;
+#endif
+	default:
+		break;
+	}
+}
+
+int host1x_memmgr_pin_array_ids(struct platform_device *dev,
+		long unsigned *ids,
+		dma_addr_t *phys_addr,
+		u32 count,
+		struct host1x_job_unpin_data *unpin_data)
+{
+	int pin_count = 0;
+
+#if defined(CONFIG_TEGRA_HOST1X_CMA)
+	{
+		int cma_count = host1x_cma_pin_array_ids(dev,
+			ids, MEMMGR_TYPE_MASK,
+			mem_mgr_type_cma,
+			count, &unpin_data[pin_count],
+			phys_addr);
+
+		if (cma_count < 0) {
+			/* clean up previous handles */
+			while (pin_count) {
+				pin_count--;
+				/* unpin, put */
+				host1x_memmgr_unpin(unpin_data[pin_count].h,
+						unpin_data[pin_count].mem);
+				host1x_memmgr_put(unpin_data[pin_count].h);
+			}
+			return cma_count;
+		}
+		pin_count += cma_count;
+	}
+#endif
+	return pin_count;
+}
diff --git a/drivers/gpu/host1x/memmgr.h b/drivers/gpu/host1x/memmgr.h
new file mode 100644
index 0000000..52881ea
--- /dev/null
+++ b/drivers/gpu/host1x/memmgr.h
@@ -0,0 +1,53 @@
+/*
+ * Tegra host1x Memory Management Abstraction header
+ *
+ * Copyright (c) 2012, NVIDIA Corporation.
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
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef _NVHOST_MEM_MGR_H_
+#define _NVHOST_MEM_MGR_H_
+
+struct mem_handle;
+struct platform_device;
+
+struct host1x_job_unpin_data {
+	struct mem_handle *h;
+	struct sg_table *mem;
+};
+
+enum mem_mgr_flag {
+	mem_mgr_flag_uncacheable = 0,
+	mem_mgr_flag_write_combine = 1,
+};
+
+struct mem_handle *host1x_memmgr_alloc(size_t size, size_t align,
+		int flags);
+struct mem_handle *host1x_memmgr_get(u32 id, struct platform_device *dev);
+void host1x_memmgr_put(struct mem_handle *handle);
+struct sg_table *host1x_memmgr_pin(struct mem_handle *handle);
+void host1x_memmgr_unpin(struct mem_handle *handle, struct sg_table *sgt);
+void *host1x_memmgr_mmap(struct mem_handle *handle);
+void host1x_memmgr_munmap(struct mem_handle *handle, void *addr);
+void *host1x_memmgr_kmap(struct mem_handle *handle, unsigned int pagenum);
+void host1x_memmgr_kunmap(struct mem_handle *handle, unsigned int pagenum,
+		void *addr);
+
+int host1x_memmgr_pin_array_ids(struct platform_device *dev,
+		long unsigned *ids,
+		dma_addr_t *phys_addr,
+		u32 count,
+		struct host1x_job_unpin_data *unpin_data);
+
+#endif
diff --git a/drivers/gpu/host1x/syncpt.c b/drivers/gpu/host1x/syncpt.c
index 9987548..5de67d2 100644
--- a/drivers/gpu/host1x/syncpt.c
+++ b/drivers/gpu/host1x/syncpt.c
@@ -295,6 +295,12 @@ void host1x_syncpt_debug(struct host1x_syncpt *sp)
 	sp->dev->syncpt_op.debug(sp);
 }
 
+/* remove a wait pointed to by patch_addr */
+int host1x_syncpt_patch_wait(struct host1x_syncpt *sp, void *patch_addr)
+{
+	return sp->dev->syncpt_op.patch_wait(sp, patch_addr);
+}
+
 struct host1x_syncpt *host1x_syncpt_init(struct host1x *host)
 {
 	struct host1x_syncpt *syncpt, *sp;
diff --git a/drivers/gpu/host1x/syncpt.h b/drivers/gpu/host1x/syncpt.h
index d4d1f3f..24d4846 100644
--- a/drivers/gpu/host1x/syncpt.h
+++ b/drivers/gpu/host1x/syncpt.h
@@ -121,6 +121,8 @@ u32 host1x_syncpt_incr_max(struct host1x_syncpt *sp, u32 incrs);
 int host1x_syncpt_wait(struct host1x_syncpt *sp, u32 thresh,
 			long timeout, u32 *value);
 
+int host1x_syncpt_patch_wait(struct host1x_syncpt *sp, void *patch_addr);
+
 void host1x_syncpt_debug(struct host1x_syncpt *sp);
 
 static inline int host1x_syncpt_is_valid(struct host1x_syncpt *sp)
diff --git a/include/linux/host1x.h b/include/linux/host1x.h
index 00060ee..a58c798 100644
--- a/include/linux/host1x.h
+++ b/include/linux/host1x.h
@@ -25,6 +25,8 @@
 #include <linux/types.h>
 #include <linux/platform_device.h>
 
+struct host1x_job;
+struct host1x_job_unpin_data;
 struct host1x_syncpt;
 
 #define NVSYNCPT_INVALID			(-1)
@@ -35,6 +37,177 @@ void host1x_syncpt_incr_byid(u32 id);
 u32 host1x_syncpt_read_byid(u32 id);
 int host1x_syncpt_wait_byid(u32 id, u32 thresh, long timeout, u32 *value);
 
+/* channels */
+struct host1x_channel *host1x_channel_alloc(struct platform_device *pdev);
+struct host1x_channel *host1x_channel_get(struct host1x_channel *ch);
+void host1x_channel_put(struct host1x_channel *ch);
+int host1x_channel_submit(struct host1x_job *job);
+
+/* Buffer encapsulation */
+enum mem_mgr_type {
+	mem_mgr_type_cma = 2,
+};
+
+#define MEMMGR_TYPE_MASK	0x3
+#define MEMMGR_ID_MASK		~0x3
+
+static inline int host1x_memmgr_type(u32 id) { return id & MEMMGR_TYPE_MASK; }
+static inline int host1x_memmgr_id(u32 id) { return id & MEMMGR_ID_MASK; }
+static inline unsigned int host1x_memmgr_host1x_id(u32 type, u32 handle)
+{
+	if (host1x_memmgr_type(type) != type ||
+		host1x_memmgr_id(handle) != handle)
+		return 0;
+
+	return handle | type;
+}
+
+
+enum host1x_class {
+	NV_HOST1X_CLASS_ID		= 0x1,
+	NV_GRAPHICS_2D_CLASS_ID		= 0x51,
+};
+
+struct host1x_job_gather {
+	u32 words;
+	dma_addr_t mem_base;
+	u32 mem_id;
+	int offset;
+	struct mem_handle *ref;
+};
+
+struct host1x_cmdbuf {
+	__u32 mem;
+	__u32 offset;
+	__u32 words;
+	__u32 pad;
+};
+
+struct host1x_reloc {
+	__u32 cmdbuf_mem;
+	__u32 cmdbuf_offset;
+	__u32 target;
+	__u32 target_offset;
+	__u32 shift;
+	__u32 pad;
+};
+
+struct host1x_waitchk {
+	__u32 mem;
+	__u32 offset;
+	__u32 syncpt_id;
+	__u32 thresh;
+};
+
+/*
+ * Each submit is tracked as a host1x_job.
+ */
+struct host1x_job {
+	/* When refcount goes to zero, job can be freed */
+	struct kref ref;
+
+	/* List entry */
+	struct list_head list;
+
+	/* Channel where job is submitted to */
+	struct host1x_channel *ch;
+
+	int clientid;
+
+	/* Gathers and their memory */
+	struct host1x_job_gather *gathers;
+	int num_gathers;
+
+	/* Wait checks to be processed at submit time */
+	struct host1x_waitchk *waitchk;
+	int num_waitchk;
+	u32 waitchk_mask;
+
+	/* Array of handles to be pinned & unpinned */
+	struct host1x_reloc *relocarray;
+	int num_relocs;
+	struct host1x_job_unpin_data *unpins;
+	int num_unpins;
+
+	dma_addr_t *addr_phys;
+	dma_addr_t *gather_addr_phys;
+	dma_addr_t *reloc_addr_phys;
+
+	/* Sync point id, number of increments and end related to the submit */
+	u32 syncpt_id;
+	u32 syncpt_incrs;
+	u32 syncpt_end;
+
+	/* Maximum time to wait for this job */
+	int timeout;
+
+	/* Null kickoff prevents submit from being sent to hardware */
+	bool null_kickoff;
+
+	/* Index and number of slots used in the push buffer */
+	int first_get;
+	int num_slots;
+
+	/* Copy of gathers */
+	size_t gather_copy_size;
+	dma_addr_t gather_copy;
+	u8 *gather_copy_mapped;
+
+	/* Temporary space for unpin ids */
+	long unsigned int *pin_ids;
+
+	/* Check if register is marked as an address reg */
+	int (*is_addr_reg)(struct platform_device *dev, u32 reg, u32 class);
+
+	/* Request a SETCLASS to this class */
+	u32 class;
+
+	/* Add a channel wait for previous ops to complete */
+	u32 serialize;
+};
+/*
+ * Allocate memory for a job. Just enough memory will be allocated to
+ * accomodate the submit.
+ */
+struct host1x_job *host1x_job_alloc(struct host1x_channel *ch,
+		u32 num_cmdbufs, u32 num_relocs, u32 num_waitchks);
+
+/*
+ * Add a gather to a job.
+ */
+void host1x_job_add_gather(struct host1x_job *job,
+		u32 mem_id, u32 words, u32 offset);
+
+/*
+ * Increment reference going to host1x_job.
+ */
+void host1x_job_get(struct host1x_job *job);
+
+/*
+ * Decrement reference job, free if goes to zero.
+ */
+void host1x_job_put(struct host1x_job *job);
+
+/*
+ * Pin memory related to job. This handles relocation of addresses to the
+ * host1x address space. Handles both the gather memory and any other memory
+ * referred to from the gather buffers.
+ *
+ * Handles also patching out host waits that would wait for an expired sync
+ * point value.
+ */
+int host1x_job_pin(struct host1x_job *job, struct platform_device *pdev);
+
+/*
+ * Unpin memory related to job.
+ */
+void host1x_job_unpin(struct host1x_job *job);
+
+/*
+ * Dump contents of job to debug output.
+ */
+void host1x_job_dump(struct device *dev, struct host1x_job *job);
+
 struct host1x_syncpt *host1x_syncpt_alloc(struct platform_device *pdev,
 		int client_managed);
 void host1x_syncpt_free(struct host1x_syncpt *sp);
diff --git a/include/trace/events/host1x.h b/include/trace/events/host1x.h
index d98d74c..e087910 100644
--- a/include/trace/events/host1x.h
+++ b/include/trace/events/host1x.h
@@ -37,6 +37,214 @@ DECLARE_EVENT_CLASS(host1x,
 	TP_printk("name=%s", __entry->name)
 );
 
+DEFINE_EVENT(host1x, host1x_channel_open,
+	TP_PROTO(const char *name),
+	TP_ARGS(name)
+);
+
+DEFINE_EVENT(host1x, host1x_channel_release,
+	TP_PROTO(const char *name),
+	TP_ARGS(name)
+);
+
+TRACE_EVENT(host1x_cdma_begin,
+	TP_PROTO(const char *name),
+
+	TP_ARGS(name),
+
+	TP_STRUCT__entry(
+		__field(const char *, name)
+	),
+
+	TP_fast_assign(
+		__entry->name = name;
+	),
+
+	TP_printk("name=%s",
+		__entry->name)
+);
+
+TRACE_EVENT(host1x_cdma_end,
+	TP_PROTO(const char *name),
+
+	TP_ARGS(name),
+
+	TP_STRUCT__entry(
+		__field(const char *, name)
+	),
+
+	TP_fast_assign(
+		__entry->name = name;
+	),
+
+	TP_printk("name=%s",
+		__entry->name)
+);
+
+TRACE_EVENT(host1x_cdma_flush,
+	TP_PROTO(const char *name, int timeout),
+
+	TP_ARGS(name, timeout),
+
+	TP_STRUCT__entry(
+		__field(const char *, name)
+		__field(int, timeout)
+	),
+
+	TP_fast_assign(
+		__entry->name = name;
+		__entry->timeout = timeout;
+	),
+
+	TP_printk("name=%s, timeout=%d",
+		__entry->name, __entry->timeout)
+);
+
+TRACE_EVENT(host1x_cdma_push,
+	TP_PROTO(const char *name, u32 op1, u32 op2),
+
+	TP_ARGS(name, op1, op2),
+
+	TP_STRUCT__entry(
+		__field(const char *, name)
+		__field(u32, op1)
+		__field(u32, op2)
+	),
+
+	TP_fast_assign(
+		__entry->name = name;
+		__entry->op1 = op1;
+		__entry->op2 = op2;
+	),
+
+	TP_printk("name=%s, op1=%08x, op2=%08x",
+		__entry->name, __entry->op1, __entry->op2)
+);
+
+TRACE_EVENT(host1x_cdma_push_gather,
+	TP_PROTO(const char *name, u32 mem_id,
+			u32 words, u32 offset, void *cmdbuf),
+
+	TP_ARGS(name, mem_id, words, offset, cmdbuf),
+
+	TP_STRUCT__entry(
+		__field(const char *, name)
+		__field(u32, mem_id)
+		__field(u32, words)
+		__field(u32, offset)
+		__field(bool, cmdbuf)
+		__dynamic_array(u32, cmdbuf, words)
+	),
+
+	TP_fast_assign(
+		if (cmdbuf) {
+			memcpy(__get_dynamic_array(cmdbuf), cmdbuf+offset,
+					words * sizeof(u32));
+		}
+		__entry->cmdbuf = cmdbuf;
+		__entry->name = name;
+		__entry->mem_id = mem_id;
+		__entry->words = words;
+		__entry->offset = offset;
+	),
+
+	TP_printk("name=%s, mem_id=%08x, words=%u, offset=%d, contents=[%s]",
+	  __entry->name, __entry->mem_id,
+	  __entry->words, __entry->offset,
+	  __print_hex(__get_dynamic_array(cmdbuf),
+		  __entry->cmdbuf ? __entry->words * 4 : 0))
+);
+
+TRACE_EVENT(host1x_channel_submit,
+	TP_PROTO(const char *name, u32 cmdbufs, u32 relocs, u32 waitchks,
+			u32 syncpt_id, u32 syncpt_incrs),
+
+	TP_ARGS(name, cmdbufs, relocs, waitchks, syncpt_id, syncpt_incrs),
+
+	TP_STRUCT__entry(
+		__field(const char *, name)
+		__field(u32, cmdbufs)
+		__field(u32, relocs)
+		__field(u32, waitchks)
+		__field(u32, syncpt_id)
+		__field(u32, syncpt_incrs)
+	),
+
+	TP_fast_assign(
+		__entry->name = name;
+		__entry->cmdbufs = cmdbufs;
+		__entry->relocs = relocs;
+		__entry->waitchks = waitchks;
+		__entry->syncpt_id = syncpt_id;
+		__entry->syncpt_incrs = syncpt_incrs;
+	),
+
+	TP_printk("name=%s, cmdbufs=%u, relocs=%u, waitchks=%d,"
+		"syncpt_id=%u, syncpt_incrs=%u",
+	  __entry->name, __entry->cmdbufs, __entry->relocs, __entry->waitchks,
+	  __entry->syncpt_id, __entry->syncpt_incrs)
+);
+
+TRACE_EVENT(host1x_channel_submitted,
+	TP_PROTO(const char *name, u32 syncpt_base, u32 syncpt_max),
+
+	TP_ARGS(name, syncpt_base, syncpt_max),
+
+	TP_STRUCT__entry(
+		__field(const char *, name)
+		__field(u32, syncpt_base)
+		__field(u32, syncpt_max)
+	),
+
+	TP_fast_assign(
+		__entry->name = name;
+		__entry->syncpt_base = syncpt_base;
+		__entry->syncpt_max = syncpt_max;
+	),
+
+	TP_printk("name=%s, syncpt_base=%d, syncpt_max=%d",
+		__entry->name, __entry->syncpt_base, __entry->syncpt_max)
+);
+
+TRACE_EVENT(host1x_channel_submit_complete,
+	TP_PROTO(const char *name, int count, u32 thresh),
+
+	TP_ARGS(name, count, thresh),
+
+	TP_STRUCT__entry(
+		__field(const char *, name)
+		__field(int, count)
+		__field(u32, thresh)
+	),
+
+	TP_fast_assign(
+		__entry->name = name;
+		__entry->count = count;
+		__entry->thresh = thresh;
+	),
+
+	TP_printk("name=%s, count=%d, thresh=%d",
+		__entry->name, __entry->count, __entry->thresh)
+);
+
+TRACE_EVENT(host1x_wait_cdma,
+	TP_PROTO(const char *name, u32 eventid),
+
+	TP_ARGS(name, eventid),
+
+	TP_STRUCT__entry(
+		__field(const char *, name)
+		__field(u32, eventid)
+	),
+
+	TP_fast_assign(
+		__entry->name = name;
+		__entry->eventid = eventid;
+	),
+
+	TP_printk("name=%s, event=%d", __entry->name, __entry->eventid)
+);
+
 TRACE_EVENT(host1x_syncpt_load_min,
 	TP_PROTO(u32 id, u32 val),
 
@@ -55,6 +263,33 @@ TRACE_EVENT(host1x_syncpt_load_min,
 	TP_printk("id=%d, val=%d", __entry->id, __entry->val)
 );
 
+TRACE_EVENT(host1x_syncpt_wait_check,
+	TP_PROTO(u32 mem_id, u32 offset, u32 syncpt_id, u32 thresh, u32 min),
+
+	TP_ARGS(mem_id, offset, syncpt_id, thresh, min),
+
+	TP_STRUCT__entry(
+		__field(u32, mem_id)
+		__field(u32, offset)
+		__field(u32, syncpt_id)
+		__field(u32, thresh)
+		__field(u32, min)
+	),
+
+	TP_fast_assign(
+		__entry->mem_id = mem_id;
+		__entry->offset = offset;
+		__entry->syncpt_id = syncpt_id;
+		__entry->thresh = thresh;
+		__entry->min = min;
+	),
+
+	TP_printk("mem_id=%08x, offset=%05x, id=%d, thresh=%d, current=%d",
+		__entry->mem_id, __entry->offset,
+		__entry->syncpt_id, __entry->thresh,
+		__entry->min)
+);
+
 #endif /*  _TRACE_HOST1X_H */
 
 /* This part must be outside protection */
-- 
1.7.9.5

