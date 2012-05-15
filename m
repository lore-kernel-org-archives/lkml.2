Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933122Ab2EOPHf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:07:35 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:37284 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933105Ab2EOPHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:07:31 -0400
From: "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
To: linux-kernel@vger.kernel.org
Cc: acking@vmware.com, dtor@vmware.com, dsouders@vmware.com,
        cschamp@vmware.com, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, virtualization@lists.linux-foundation.org,
        "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
Subject: [vmw_vmci RFC 08/11] Apply VMCI queue pairs
Date: Tue, 15 May 2012 08:07:05 -0700
Message-Id: <1337094428-20453-9-git-send-email-astiegmann@vmware.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1337094428-20453-1-git-send-email-astiegmann@vmware.com>
References: <1337094428-20453-1-git-send-email-astiegmann@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VMCI queue pairs allow for bi-directional ordered communication between
host and guests.

Signed-off-by: Andrew Stiegmann (stieg) <astiegmann@vmware.com>
---
 drivers/misc/vmw_vmci/vmci_queue_pair.c | 4517 +++++++++++++++++++++++++++++++
 drivers/misc/vmw_vmci/vmci_queue_pair.h |  258 ++
 2 files changed, 4775 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/vmw_vmci/vmci_queue_pair.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_queue_pair.h

diff --git a/drivers/misc/vmw_vmci/vmci_queue_pair.c b/drivers/misc/vmw_vmci/vmci_queue_pair.c
new file mode 100644
index 0000000..b5b1b8e
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmci_queue_pair.c
@@ -0,0 +1,4517 @@
+/*
+ * VMware VMCI Driver
+ *
+ * Copyright (C) 2012 VMware, Inc. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation version 2 and no later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
+ */
+
+#include <linux/device-mapper.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/semaphore.h>
+#include <linux/socket.h>
+#include <linux/vmw_vmci_api.h>
+#include <linux/vmw_vmci_defs.h>
+
+#include "vmci_common_int.h"
+#include "vmci_context.h"
+#include "vmci_datagram.h"
+#include "vmci_driver.h"
+#include "vmci_event.h"
+#include "vmci_handle_array.h"
+#include "vmci_hash_table.h"
+#include "vmci_queue_pair.h"
+#include "vmci_resource.h"
+#include "vmci_route.h"
+
+#define INVALID_VMCI_GUEST_MEM_ID  0
+
+/*
+ * In the following, we will distinguish between two kinds of VMX processes -
+ * the ones with versions lower than VMCI_VERSION_NOVMVM that use specialized
+ * VMCI page files in the VMX and supporting VM to VM communication and the
+ * newer ones that use the guest memory directly. We will in the following refer
+ * to the older VMX versions as old-style VMX'en, and the newer ones as new-style
+ * VMX'en.
+ *
+ * The state transition datagram is as follows (the VMCIQPB_ prefix has been
+ * removed for readability) - see below for more details on the transtions:
+ *
+ *            --------------  NEW  -------------
+ *            |                                |
+ *           \_/                              \_/
+ *     CREATED_NO_MEM <-----------------> CREATED_MEM
+ *            |    |                           |
+ *            |    o-----------------------o   |
+ *            |                            |   |
+ *           \_/                          \_/ \_/
+ *     ATTACHED_NO_MEM <----------------> ATTACHED_MEM
+ *            |                            |   |
+ *            |     o----------------------o   |
+ *            |     |                          |
+ *           \_/   \_/                        \_/
+ *     SHUTDOWN_NO_MEM <----------------> SHUTDOWN_MEM
+ *            |                                |
+ *            |                                |
+ *            -------------> gone <-------------
+ *
+ * In more detail. When a VMCI queue pair is first created, it will be in the
+ * VMCIQPB_NEW state. It will then move into one of the following states:
+ * - VMCIQPB_CREATED_NO_MEM: this state indicates that either:
+ *     - the created was performed by a host endpoint, in which case there is no
+ *       backing memory yet.
+ *     - the create was initiated by an old-style VMX, that uses
+ *       vmci_qp_broker_set_page_store to specify the UVAs of the queue pair at a
+ *       later point in time. This state can be distinguished from the one above
+ *       by the context ID of the creator. A host side is not allowed to attach
+ *       until the page store has been set.
+ * - VMCIQPB_CREATED_MEM: this state is the result when the queue pair is created
+ *     by a VMX using the queue pair device backend that sets the UVAs of the
+ *     queue pair immediately and stores the information for later attachers. At
+ *     this point, it is ready for the host side to attach to it.
+ * Once the queue pair is in one of the created states (with the exception of the
+ * case mentioned for older VMX'en above), it is possible to attach to the queue
+ * pair. Again we have two new states possible:
+ * - VMCIQPB_ATTACHED_MEM: this state can be reached through the following paths:
+ *     - from VMCIQPB_CREATED_NO_MEM when a new-style VMX allocates a queue pair,
+ *       and attaches to a queue pair previously created by the host side.
+ *     - from VMCIQPB_CREATED_MEM when the host side attaches to a queue pair
+ *       already created by a guest.
+ *     - from VMCIQPB_ATTACHED_NO_MEM, when an old-style VMX calls
+ *       vmci_qp_broker_set_page_store (see below).
+ * - VMCIQPB_ATTACHED_NO_MEM: If the queue pair already was in the
+ *     VMCIQPB_CREATED_NO_MEM due to a host side create, an old-style VMX will
+ *     bring the queue pair into this state. Once vmci_qp_broker_set_page_store is
+ *     called to register the user memory, the VMCIQPB_ATTACH_MEM state will be
+ *     entered.
+ * From the attached queue pair, the queue pair can enter the shutdown states
+ * when either side of the queue pair detaches. If the guest side detaches first,
+ * the queue pair will enter the VMCIQPB_SHUTDOWN_NO_MEM state, where the content
+ * of the queue pair will no longer be available. If the host side detaches first,
+ * the queue pair will either enter the VMCIQPB_SHUTDOWN_MEM, if the guest memory
+ * is currently mapped, or VMCIQPB_SHUTDOWN_NO_MEM, if the guest memory is not
+ * mapped (e.g., the host detaches while a guest is stunned).
+ *
+ * New-style VMX'en will also unmap guest memory, if the guest is quiesced, e.g.,
+ * during a snapshot operation. In that case, the guest memory will no longer be
+ * available, and the queue pair will transition from *_MEM state to a *_NO_MEM
+ * state. The VMX may later map the memory once more, in which case the queue
+ * pair will transition from the *_NO_MEM state at that point back to the *_MEM
+ * state. Note that the *_NO_MEM state may have changed, since the peer may have
+ * either attached or detached in the meantime. The values are laid out such that
+ * ++ on a state will move from a *_NO_MEM to a *_MEM state, and vice versa.
+ */
+
+/* The Kernel specific component of the struct vmci_queue structure. */
+struct vmci_queue_kern_if {
+	struct page **page;
+	struct page **headerPage;
+	void *va;
+	struct semaphore __mutex;
+	struct semaphore *mutex;
+	bool host;
+	size_t numPages;
+	bool mapped;
+};
+
+/*
+ * This structure is opaque to the clients.
+ */
+struct vmci_qp {
+	struct vmci_handle handle;
+	struct vmci_queue *produceQ;
+	struct vmci_queue *consumeQ;
+	uint64_t produceQSize;
+	uint64_t consumeQSize;
+	uint32_t peer;
+	uint32_t flags;
+	uint32_t privFlags;
+	bool guestEndpoint;
+	uint32_t blocked;
+	wait_queue_head_t event;
+};
+
+enum qp_broker_state {
+	VMCIQPB_NEW,
+	VMCIQPB_CREATED_NO_MEM,
+	VMCIQPB_CREATED_MEM,
+	VMCIQPB_ATTACHED_NO_MEM,
+	VMCIQPB_ATTACHED_MEM,
+	VMCIQPB_SHUTDOWN_NO_MEM,
+	VMCIQPB_SHUTDOWN_MEM,
+	VMCIQPB_GONE
+};
+
+#define QPBROKERSTATE_HAS_MEM(_qpb) (_qpb->state == VMCIQPB_CREATED_MEM || \
+                                     _qpb->state == VMCIQPB_ATTACHED_MEM || \
+                                     _qpb->state == VMCIQPB_SHUTDOWN_MEM)
+
+/*
+ * In the queue pair broker, we always use the guest point of view for
+ * the produce and consume queue values and references, e.g., the
+ * produce queue size stored is the guests produce queue size. The
+ * host endpoint will need to swap these around. The only exception is
+ * the local queue pairs on the host, in which case the host endpoint
+ * that creates the queue pair will have the right orientation, and
+ * the attaching host endpoint will need to swap.
+ */
+
+struct qp_entry {
+	struct list_head listItem;
+	struct vmci_handle handle;
+	uint32_t peer;
+	uint32_t flags;
+	uint64_t produceSize;
+	uint64_t consumeSize;
+	uint32_t refCount;
+};
+
+struct qp_broker_entry {
+	struct qp_entry qp;
+	uint32_t createId;
+	uint32_t attachId;
+	enum qp_broker_state state;
+	bool requireTrustedAttach;
+	bool createdByTrusted;
+	bool vmciPageFiles;	// Created by VMX using VMCI page files
+	struct vmci_queue *produceQ;
+	struct vmci_queue *consumeQ;
+	struct vmci_queue_header savedProduceQ;
+	struct vmci_queue_header savedConsumeQ;
+	VMCIEventReleaseCB wakeupCB;
+	void *clientData;
+	void *localMem;		// Kernel memory for local queue pair
+};
+
+struct qp_guest_endpoint {
+	struct qp_entry qp;
+	uint64_t numPPNs;
+	void *produceQ;
+	void *consumeQ;
+	struct PPNSet ppnSet;
+};
+
+struct qp_list {
+	struct list_head head;
+	struct semaphore mutex;
+};
+
+static struct qp_list qpBrokerList;
+
+#define QPE_NUM_PAGES(_QPE) ((uint32_t)(dm_div_up(_QPE.produceSize, PAGE_SIZE) + \
+					dm_div_up(_QPE.consumeSize, PAGE_SIZE) + 2))
+
+static struct qp_list qpGuestEndpoints;
+
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * qp_free_queue --
+ *
+ *      Frees kernel VA space for a given queue and its queue header, and
+ *      frees physical data pages.
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      Memory is freed.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static void qp_free_queue(void *q,	// IN:
+			  uint64_t size)	// IN: size of queue (not including header)
+{
+	struct vmci_queue *queue = q;
+
+	if (queue) {
+		uint64_t i = dm_div_up(size, PAGE_SIZE);
+
+		if (queue->kernelIf->mapped) {
+			ASSERT(queue->kernelIf->va);
+			vunmap(queue->kernelIf->va);
+			queue->kernelIf->va = NULL;
+		}
+
+		while (i)
+			__free_page(queue->kernelIf->page[--i]);
+
+		vfree(queue->qHeader);
+	}
+}
+
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * qp_alloc_queue --
+ *
+ *      Allocates kernel VA space of specified size, plus space for the
+ *      queue structure/kernel interface and the queue header.  Allocates
+ *      physical pages for the queue data pages.
+ *
+ *      PAGE m:      struct vmci_queue_header (struct vmci_queue->qHeader)
+ *      PAGE m+1:    struct vmci_queue
+ *      PAGE m+1+q:  struct vmci_queue_kern_if (struct vmci_queue->kernelIf)
+ *      PAGE n-size: Data pages (struct vmci_queue->kernelIf->page[])
+ *
+ * Results:
+ *      Pointer to the queue on success, NULL otherwise.
+ *
+ * Side effects:
+ *      Memory is allocated.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static void *qp_alloc_queue(uint64_t size,	// IN: size of queue (not including header)
+			    uint32_t flags)
+{
+	uint64_t i;
+	struct vmci_queue *queue;
+	struct vmci_queue_header *qHeader;
+	const uint64_t numDataPages = dm_div_up(size, PAGE_SIZE);
+	const uint queueSize =
+		PAGE_SIZE +
+		sizeof(*queue) + sizeof(*(queue->kernelIf)) +
+		numDataPages * sizeof(*(queue->kernelIf->page));
+
+	ASSERT(size <= VMCI_MAX_GUEST_QP_MEMORY);
+	ASSERT(!QP_PINNED(flags) || size <= VMCI_MAX_PINNED_QP_MEMORY);
+
+	qHeader = vmalloc(queueSize);
+	if (!qHeader)
+		return NULL;
+
+	queue = (struct vmci_queue *)((uint8_t *) qHeader + PAGE_SIZE);
+	queue->qHeader = qHeader;
+	queue->savedHeader = NULL;
+	queue->kernelIf =
+		(struct vmci_queue_kern_if *)((uint8_t *) queue + sizeof(*queue));
+	queue->kernelIf->headerPage = NULL;	/* Unused in guest. */
+	queue->kernelIf->page =
+		(struct page **)((uint8_t *) queue->kernelIf +
+				 sizeof(*(queue->kernelIf)));
+	queue->kernelIf->host = false;
+	queue->kernelIf->va = NULL;
+	queue->kernelIf->mapped = false;
+
+	for (i = 0; i < numDataPages; i++) {
+		queue->kernelIf->page[i] = alloc_pages(GFP_KERNEL, 0);
+		if (!queue->kernelIf->page[i])
+			goto fail;
+	}
+
+	if (QP_PINNED(flags)) {
+		queue->kernelIf->va = vmap(queue->kernelIf->page, numDataPages,
+					   VM_MAP, PAGE_KERNEL);
+		if (!queue->kernelIf->va)
+			goto fail;
+
+		queue->kernelIf->mapped = true;
+	}
+
+	return (void *)queue;
+
+fail:
+	qp_free_queue(queue, i * PAGE_SIZE);
+	return NULL;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * __qp_memcpy_to_queue --
+ *
+ *      Copies from a given buffer or iovector to a VMCI Queue.  Uses
+ *      kmap()/kunmap() to dynamically map/unmap required portions of the queue
+ *      by traversing the offset -> page translation structure for the queue.
+ *      Assumes that offset + size does not wrap around in the queue.
+ *
+ * Results:
+ *      Zero on success, negative error code on failure.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static int __qp_memcpy_to_queue(struct vmci_queue *queue,	// OUT:
+				uint64_t queueOffset,	// IN:
+				const void *src,	// IN:
+				size_t size,	// IN:
+				bool isIovec)	// IN: if src is a struct iovec *
+{
+	struct vmci_queue_kern_if *kernelIf = queue->kernelIf;
+	size_t bytesCopied = 0;
+
+	while (bytesCopied < size) {
+		uint64_t pageIndex = (queueOffset + bytesCopied) / PAGE_SIZE;
+		size_t pageOffset =
+			(queueOffset + bytesCopied) & (PAGE_SIZE - 1);
+		void *va;
+		size_t toCopy;
+
+		if (!kernelIf->mapped)
+			va = kmap(kernelIf->page[pageIndex]);
+		else
+			va = (void *)((uint8_t *)kernelIf->va + (pageIndex * PAGE_SIZE));
+
+		if (size - bytesCopied > PAGE_SIZE - pageOffset) {
+			/* Enough payload to fill up from this page. */
+			toCopy = PAGE_SIZE - pageOffset;
+		} else {
+			toCopy = size - bytesCopied;
+		}
+
+		if (isIovec) {
+			struct iovec *iov = (struct iovec *)src;
+			int err;
+
+			/* The iovec will track bytesCopied internally. */
+			err = memcpy_fromiovec((uint8_t *) va + pageOffset,
+					       iov, toCopy);
+			if (err != 0) {
+				kunmap(kernelIf->page[pageIndex]);
+				return VMCI_ERROR_INVALID_ARGS;
+			}
+		} else {
+			memcpy((uint8_t *) va + pageOffset,
+			       (uint8_t *) src + bytesCopied, toCopy);
+		}
+
+		bytesCopied += toCopy;
+		if (!kernelIf->mapped)
+			kunmap(kernelIf->page[pageIndex]);
+	}
+
+	return VMCI_SUCCESS;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * __qp_memcpy_from_queue --
+ *
+ *      Copies to a given buffer or iovector from a VMCI Queue.  Uses
+ *      kmap()/kunmap() to dynamically map/unmap required portions of the queue
+ *      by traversing the offset -> page translation structure for the queue.
+ *      Assumes that offset + size does not wrap around in the queue.
+ *
+ * Results:
+ *      Zero on success, negative error code on failure.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static int __qp_memcpy_from_queue(void *dest,	// OUT:
+				  const struct vmci_queue *queue,	// IN:
+				  uint64_t queueOffset,	// IN:
+				  size_t size,	// IN:
+				  bool isIovec)	// IN: if dest is a struct iovec *
+{
+	struct vmci_queue_kern_if *kernelIf = queue->kernelIf;
+	size_t bytesCopied = 0;
+
+	while (bytesCopied < size) {
+		uint64_t pageIndex = (queueOffset + bytesCopied) / PAGE_SIZE;
+		size_t pageOffset =
+			(queueOffset + bytesCopied) & (PAGE_SIZE - 1);
+		void *va;
+		size_t toCopy;
+
+		if (!kernelIf->mapped)
+			va = kmap(kernelIf->page[pageIndex]);
+		else
+			va = (void *)((uint8_t *)kernelIf->va + (pageIndex * PAGE_SIZE));
+
+		if (size - bytesCopied > PAGE_SIZE - pageOffset) {
+			/* Enough payload to fill up this page. */
+			toCopy = PAGE_SIZE - pageOffset;
+		} else {
+			toCopy = size - bytesCopied;
+		}
+
+		if (isIovec) {
+			struct iovec *iov = (struct iovec *)dest;
+			int err;
+
+			/* The iovec will track bytesCopied internally. */
+			err = memcpy_toiovec(iov, (uint8_t *) va + pageOffset,
+					     toCopy);
+			if (err != 0) {
+				kunmap(kernelIf->page[pageIndex]);
+				return VMCI_ERROR_INVALID_ARGS;
+			}
+		} else {
+			memcpy((uint8_t *) dest + bytesCopied,
+			       (uint8_t *) va + pageOffset, toCopy);
+		}
+
+		bytesCopied += toCopy;
+		if (!kernelIf->mapped)
+			kunmap(kernelIf->page[pageIndex]);
+	}
+
+	return VMCI_SUCCESS;
+}
+
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * qp_alloc_ppn_set --
+ *
+ *      Allocates two list of PPNs --- one for the pages in the produce queue,
+ *      and the other for the pages in the consume queue. Intializes the list
+ *      of PPNs with the page frame numbers of the KVA for the two queues (and
+ *      the queue headers).
+ *
+ * Results:
+ *      Success or failure.
+ *
+ * Side effects:
+ *      Memory may be allocated.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static int qp_alloc_ppn_set(void *prodQ,	// IN:
+			    uint64_t numProducePages,	// IN: for queue plus header
+			    void *consQ,	// IN:
+			    uint64_t numConsumePages,	// IN: for queue plus header
+			    struct PPNSet *ppnSet)	// OUT:
+{
+	uint32_t *producePPNs;
+	uint32_t *consumePPNs;
+	struct vmci_queue *produceQ = prodQ;
+	struct vmci_queue *consumeQ = consQ;
+	uint64_t i;
+
+	if (!produceQ || !numProducePages || !consumeQ ||
+	    !numConsumePages || !ppnSet)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	if (ppnSet->initialized)
+		return VMCI_ERROR_ALREADY_EXISTS;
+
+	producePPNs =
+		kmalloc(numProducePages * sizeof *producePPNs, GFP_KERNEL);
+	if (!producePPNs)
+		return VMCI_ERROR_NO_MEM;
+
+	consumePPNs =
+		kmalloc(numConsumePages * sizeof *consumePPNs, GFP_KERNEL);
+	if (!consumePPNs) {
+		kfree(producePPNs);
+		return VMCI_ERROR_NO_MEM;
+	}
+
+	producePPNs[0] = page_to_pfn(vmalloc_to_page(produceQ->qHeader));
+	for (i = 1; i < numProducePages; i++) {
+		unsigned long pfn;
+
+		producePPNs[i] = pfn =
+			page_to_pfn(produceQ->kernelIf->page[i - 1]);
+
+		/* Fail allocation if PFN isn't supported by hypervisor. */
+		if (sizeof pfn > sizeof *producePPNs && pfn != producePPNs[i])
+			goto ppnError;
+	}
+	consumePPNs[0] = page_to_pfn(vmalloc_to_page(consumeQ->qHeader));
+	for (i = 1; i < numConsumePages; i++) {
+		unsigned long pfn;
+
+		consumePPNs[i] = pfn =
+			page_to_pfn(consumeQ->kernelIf->page[i - 1]);
+
+		/* Fail allocation if PFN isn't supported by hypervisor. */
+		if (sizeof pfn > sizeof *consumePPNs && pfn != consumePPNs[i])
+			goto ppnError;
+	}
+
+	ppnSet->numProducePages = numProducePages;
+	ppnSet->numConsumePages = numConsumePages;
+	ppnSet->producePPNs = producePPNs;
+	ppnSet->consumePPNs = consumePPNs;
+	ppnSet->initialized = true;
+	return VMCI_SUCCESS;
+
+ppnError:
+	kfree(producePPNs);
+	kfree(consumePPNs);
+	return VMCI_ERROR_INVALID_ARGS;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * qp_free_ppn_set --
+ *
+ *      Frees the two list of PPNs for a queue pair.
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static void qp_free_ppn_set(struct PPNSet *ppnSet)	// IN:
+{
+	ASSERT(ppnSet);
+	if (ppnSet->initialized) {
+		/* Do not call these functions on NULL inputs. */
+		ASSERT(ppnSet->producePPNs && ppnSet->consumePPNs);
+		kfree(ppnSet->producePPNs);
+		kfree(ppnSet->consumePPNs);
+	}
+	memset(ppnSet, 0, sizeof *ppnSet);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * qp_populate_ppn_set --
+ *
+ *      Populates the list of PPNs in the hypercall structure with the PPNS
+ *      of the produce queue and the consume queue.
+ *
+ * Results:
+ *      VMCI_SUCCESS.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static int qp_populate_ppn_set(uint8_t * callBuf,	// OUT:
+			       const struct PPNSet *ppnSet)	// IN:
+{
+	ASSERT(callBuf && ppnSet && ppnSet->initialized);
+	memcpy(callBuf, ppnSet->producePPNs,
+	       ppnSet->numProducePages * sizeof *ppnSet->producePPNs);
+	memcpy(callBuf +
+	       ppnSet->numProducePages * sizeof *ppnSet->producePPNs,
+	       ppnSet->consumePPNs,
+	       ppnSet->numConsumePages * sizeof *ppnSet->consumePPNs);
+
+	return VMCI_SUCCESS;
+}
+
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * qp_memcpy_to_queue --
+ *
+ *      Copies from a given buffer to a VMCI Queue.
+ *
+ * Results:
+ *      Zero on success, negative error code on failure.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static int qp_memcpy_to_queue(struct vmci_queue *queue,	// OUT:
+				     uint64_t queueOffset,	// IN:
+				     const void *src,	// IN:
+				     size_t srcOffset,	// IN:
+				     size_t size,	// IN:
+				     int bufType)	// IN: Unused
+{
+	return __qp_memcpy_to_queue(queue, queueOffset,
+				    (uint8_t *) src + srcOffset, size, false);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * qp_memcpy_from_queue --
+ *
+ *      Copies to a given buffer from a VMCI Queue.
+ *
+ * Results:
+ *      Zero on success, negative error code on failure.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static int qp_memcpy_from_queue(void *dest,	// OUT:
+				       size_t destOffset,	// IN:
+				       const struct vmci_queue *queue,	// IN:
+				       uint64_t queueOffset,	// IN:
+				       size_t size,	// IN:
+				       int bufType)	// IN: Unused
+{
+	return __qp_memcpy_from_queue((uint8_t *) dest + destOffset,
+				      queue, queueOffset, size, false);
+}
+
+/*
+ *----------------------------------------------------------------------------
+ *
+ * qp_memcpy_to_queue_iov --
+ *
+ *      Copies from a given iovec from a VMCI Queue.
+ *
+ * Results:
+ *      Zero on success, negative error code on failure.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------------
+ */
+
+static int qp_memcpy_to_queue_iov(struct vmci_queue *queue,	// OUT:
+					 uint64_t queueOffset,	// IN:
+					 const void *src,	// IN: iovec
+					 size_t srcOffset,	// IN: ignored
+					 size_t size,	// IN:
+					 int bufType)	// IN: ignored
+{
+
+	/*
+	 * We ignore srcOffset because src is really a struct iovec * and will
+	 * maintain offset internally.
+	 */
+	return __qp_memcpy_to_queue(queue, queueOffset, src, size, true);
+}
+
+/*
+ *----------------------------------------------------------------------------
+ *
+ * qp_memcpy_from_queue_iov --
+ *
+ *      Copies to a given iovec from a VMCI Queue.
+ *
+ * Results:
+ *      Zero on success, negative error code on failure.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------------
+ */
+
+static int qp_memcpy_from_queue_iov(void *dest,	// OUT: iovec
+					   size_t destOffset,	// IN: ignored
+					   const struct vmci_queue *queue,	// IN:
+					   uint64_t queueOffset,	// IN:
+					   size_t size,	// IN:
+					   int bufType)	// IN: ignored
+{
+	/*
+	 * We ignore destOffset because dest is really a struct iovec * and will
+	 * maintain offset internally.
+	 */
+	return __qp_memcpy_from_queue(dest, queue, queueOffset, size, true);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIHost_AllocQueue --
+ *
+ *      Allocates kernel VA space of specified size plus space for the queue
+ *      and kernel interface.  This is different from the guest queue allocator,
+ *      because we do not allocate our own queue header/data pages here but
+ *      share those of the guest.
+ *
+ * Results:
+ *      A pointer to an allocated and initialized struct vmci_queue structure or NULL.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+struct vmci_queue *VMCIHost_AllocQueue(uint64_t size)	// IN:
+{
+	struct vmci_queue *queue;
+	const size_t numPages = dm_div_up(size, PAGE_SIZE) + 1;
+	const size_t queueSize = sizeof(*queue) + sizeof(*(queue->kernelIf));
+	const size_t queuePageSize = numPages * sizeof(*queue->kernelIf->page);
+
+	queue = kzalloc(queueSize + queuePageSize, GFP_KERNEL);
+	if (queue) {
+		queue->qHeader = NULL;
+		queue->savedHeader = NULL;
+		queue->kernelIf =
+			(struct vmci_queue_kern_if *)((uint8_t *) queue +
+						      sizeof(*queue));
+		queue->kernelIf->host = true;
+		queue->kernelIf->mutex = NULL;
+		queue->kernelIf->numPages = numPages;
+		queue->kernelIf->headerPage =
+			(struct page **)((uint8_t *) queue + queueSize);
+		queue->kernelIf->page = &queue->kernelIf->headerPage[1];
+		queue->kernelIf->va = NULL;
+		queue->kernelIf->mapped = false;
+	}
+
+	return queue;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIHost_FreeQueue --
+ *
+ *      Frees kernel memory for a given queue (header plus translation
+ *      structure).
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      Memory is freed.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+void VMCIHost_FreeQueue(struct vmci_queue *queue,	// IN:
+			uint64_t queueSize)	// IN:
+{
+	if (queue)
+		kfree(queue);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCI_InitQueueMutex()
+ *
+ *       Initialize the mutex for the pair of queues.  This mutex is used to
+ *       protect the qHeader and the buffer from changing out from under any
+ *       users of either queue.  Of course, it's only any good if the mutexes
+ *       are actually acquired.  Queue structure must lie on non-paged memory
+ *       or we cannot guarantee access to the mutex.
+ *
+ * Results:
+ *       None.
+ *
+ * Side Effects:
+ *       None.
+ *
+ *----------------------------------------------------------------------------
+ */
+
+void VMCI_InitQueueMutex(struct vmci_queue *produceQ,	// IN/OUT
+			 struct vmci_queue *consumeQ)	// IN/OUT
+{
+	ASSERT(produceQ);
+	ASSERT(consumeQ);
+	ASSERT(produceQ->kernelIf);
+	ASSERT(consumeQ->kernelIf);
+
+	/*
+	 * Only the host queue has shared state - the guest queues do not
+	 * need to synchronize access using a queue mutex.
+	 */
+
+	if (produceQ->kernelIf->host) {
+		produceQ->kernelIf->mutex = &produceQ->kernelIf->__mutex;
+		consumeQ->kernelIf->mutex = &produceQ->kernelIf->__mutex;
+		sema_init(produceQ->kernelIf->mutex, 1);
+	}
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCI_CleanupQueueMutex()
+ *
+ *       Cleans up the mutex for the pair of queues.
+ *
+ * Results:
+ *       None.
+ *
+ * Side Effects:
+ *       None.
+ *
+ *----------------------------------------------------------------------------
+ */
+
+void VMCI_CleanupQueueMutex(struct vmci_queue *produceQ,	// IN/OUT
+			    struct vmci_queue *consumeQ)	// IN/OUT
+{
+	ASSERT(produceQ);
+	ASSERT(consumeQ);
+	ASSERT(produceQ->kernelIf);
+	ASSERT(consumeQ->kernelIf);
+
+	if (produceQ->kernelIf->host) {
+		produceQ->kernelIf->mutex = NULL;
+		consumeQ->kernelIf->mutex = NULL;
+	}
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCI_AcquireQueueMutex()
+ *
+ *       Acquire the mutex for the queue.  Note that the produceQ and
+ *       the consumeQ share a mutex.  So, only one of the two need to
+ *       be passed in to this routine.  Either will work just fine.
+ *
+ * Results:
+ *       None.
+ *
+ * Side Effects:
+ *       May block the caller.
+ *
+ *----------------------------------------------------------------------------
+ */
+
+void VMCI_AcquireQueueMutex(struct vmci_queue *queue)	// IN
+{
+	ASSERT(queue);
+	ASSERT(queue->kernelIf);
+
+	if (queue->kernelIf->host) {
+		ASSERT(queue->kernelIf->mutex);
+		down(queue->kernelIf->mutex);
+	}
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCI_ReleaseQueueMutex()
+ *
+ *       Release the mutex for the queue.  Note that the produceQ and
+ *       the consumeQ share a mutex.  So, only one of the two need to
+ *       be passed in to this routine.  Either will work just fine.
+ *
+ * Results:
+ *       None.
+ *
+ * Side Effects:
+ *       May block the caller.
+ *
+ *----------------------------------------------------------------------------
+ */
+
+void VMCI_ReleaseQueueMutex(struct vmci_queue *queue)	// IN
+{
+	ASSERT(queue);
+	ASSERT(queue->kernelIf);
+
+	if (queue->kernelIf->host) {
+		ASSERT(queue->kernelIf->mutex);
+		up(queue->kernelIf->mutex);
+	}
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIReleasePageStorePages --
+ *
+ *       Helper function to release pages in the PageStoreAttachInfo
+ *       previously obtained using get_user_pages.
+ *
+ * Results:
+ *       None.
+ *
+ * Side Effects:
+ *       None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static void VMCIReleasePages(struct page **pages,	// IN
+			     uint64_t numPages,	// IN
+			     bool dirty)	// IN
+{
+	int i;
+
+	for (i = 0; i < numPages; i++) {
+		ASSERT(pages[i]);
+
+		if (dirty)
+			set_page_dirty(pages[i]);
+
+		page_cache_release(pages[i]);
+		pages[i] = NULL;
+	}
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIHost_GetUserMemory --
+ *
+ *
+ *       Lock the user pages referenced by the {produce,consume}Buffer
+ *       struct into memory and populate the {produce,consume}Pages
+ *       arrays in the attach structure with them.
+ *
+ * Results:
+ *       VMCI_SUCCESS on sucess, negative error code on failure.
+ *
+ * Side Effects:
+ *       None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+int VMCIHost_GetUserMemory(uint64_t produceUVA,	// IN
+			   uint64_t consumeUVA,	// IN
+			   struct vmci_queue *produceQ,	// OUT
+			   struct vmci_queue *consumeQ)	// OUT
+{
+	int retval;
+	int err = VMCI_SUCCESS;
+
+	down_write(&current->mm->mmap_sem);
+	retval = get_user_pages(current,
+				current->mm,
+				(uintptr_t) produceUVA,
+				produceQ->kernelIf->numPages,
+				1, 0, produceQ->kernelIf->headerPage, NULL);
+	if (retval < produceQ->kernelIf->numPages) {
+		pr_warn("get_user_pages(produce) failed (retval=%d)",
+			retval);
+		VMCIReleasePages(produceQ->kernelIf->headerPage, retval, false);
+		err = VMCI_ERROR_NO_MEM;
+		goto out;
+	}
+
+	retval = get_user_pages(current,
+				current->mm,
+				(uintptr_t) consumeUVA,
+				consumeQ->kernelIf->numPages,
+				1, 0, consumeQ->kernelIf->headerPage, NULL);
+	if (retval < consumeQ->kernelIf->numPages) {
+		pr_warn("get_user_pages(consume) failed (retval=%d)",
+			retval);
+		VMCIReleasePages(consumeQ->kernelIf->headerPage, retval, false);
+		VMCIReleasePages(produceQ->kernelIf->headerPage,
+				 produceQ->kernelIf->numPages, false);
+		err = VMCI_ERROR_NO_MEM;
+	}
+
+out:
+	up_write(&current->mm->mmap_sem);
+
+	return err;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIHost_RegisterUserMemory --
+ *
+ *       Registers the specification of the user pages used for backing a queue
+ *       pair. Enough information to map in pages is stored in the OS specific
+ *       part of the struct vmci_queue structure.
+ *
+ * Results:
+ *       VMCI_SUCCESS on sucess, negative error code on failure.
+ *
+ * Side Effects:
+ *       None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+int VMCIHost_RegisterUserMemory(QueuePairPageStore * pageStore,	// IN
+				struct vmci_queue *produceQ,	// OUT
+				struct vmci_queue *consumeQ)	// OUT
+{
+	uint64_t produceUVA;
+	uint64_t consumeUVA;
+
+	ASSERT(produceQ->kernelIf->headerPage
+	       && consumeQ->kernelIf->headerPage);
+
+	/*
+	 * The new style and the old style mapping only differs in that we either
+	 * get a single or two UVAs, so we split the single UVA range at the
+	 * appropriate spot.
+	 */
+
+	produceUVA = pageStore->pages;
+	consumeUVA =
+		pageStore->pages + produceQ->kernelIf->numPages * PAGE_SIZE;
+	return VMCIHost_GetUserMemory(produceUVA, consumeUVA, produceQ,
+				      consumeQ);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIHost_UnregisterUserMemory --
+ *
+ *       Releases and removes the references to user pages stored in the attach
+ *       struct.
+ *
+ * Results:
+ *       None
+ *
+ * Side Effects:
+ *       Pages are released from the page cache and may become
+ *       swappable again.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+void VMCIHost_UnregisterUserMemory(struct vmci_queue *produceQ,	// IN/OUT
+				   struct vmci_queue *consumeQ)	// IN/OUT
+{
+	ASSERT(produceQ->kernelIf);
+	ASSERT(consumeQ->kernelIf);
+	ASSERT(!produceQ->qHeader && !consumeQ->qHeader);
+
+	VMCIReleasePages(produceQ->kernelIf->headerPage,
+			 produceQ->kernelIf->numPages, true);
+	memset(produceQ->kernelIf->headerPage, 0,
+	       sizeof *produceQ->kernelIf->headerPage *
+	       produceQ->kernelIf->numPages);
+	VMCIReleasePages(consumeQ->kernelIf->headerPage,
+			 consumeQ->kernelIf->numPages, true);
+	memset(consumeQ->kernelIf->headerPage, 0,
+	       sizeof *consumeQ->kernelIf->headerPage *
+	       consumeQ->kernelIf->numPages);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIHost_MapQueues --
+ *
+ *       Once VMCIHost_RegisterUserMemory has been performed on a
+ *       queue, the queue pair headers can be mapped into the
+ *       kernel. Once mapped, they must be unmapped with
+ *       VMCIHost_UnmapQueues prior to calling
+ *       VMCIHost_UnregisterUserMemory.
+ *
+ * Results:
+ *       VMCI_SUCCESS if pages are mapped, appropriate error code otherwise.
+ *
+ * Side Effects:
+ *       Pages are pinned.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+int VMCIHost_MapQueues(struct vmci_queue *produceQ,	// IN/OUT
+		       struct vmci_queue *consumeQ)	// IN/OUT
+{
+	int result;
+
+	if (!produceQ->qHeader || !consumeQ->qHeader) {
+		struct page *headers[2];
+
+		if (produceQ->qHeader != consumeQ->qHeader)
+			return VMCI_ERROR_QUEUEPAIR_MISMATCH;
+
+		if (produceQ->kernelIf->headerPage == NULL ||
+		    *produceQ->kernelIf->headerPage == NULL)
+			return VMCI_ERROR_UNAVAILABLE;
+
+		ASSERT(*produceQ->kernelIf->headerPage
+		       && *consumeQ->kernelIf->headerPage);
+
+		headers[0] = *produceQ->kernelIf->headerPage;
+		headers[1] = *consumeQ->kernelIf->headerPage;
+
+		produceQ->qHeader = vmap(headers, 2, VM_MAP, PAGE_KERNEL);
+		if (produceQ->qHeader != NULL) {
+			consumeQ->qHeader =
+				(struct vmci_queue_header *)((uint8_t *)
+							     produceQ->qHeader +
+							     PAGE_SIZE);
+			result = VMCI_SUCCESS;
+		} else {
+			pr_warn("vmap failed.");
+			result = VMCI_ERROR_NO_MEM;
+		}
+	} else {
+		result = VMCI_SUCCESS;
+	}
+
+	return result;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIHost_UnmapQueues --
+ *
+ *       Unmaps previously mapped queue pair headers from the kernel.
+ *
+ * Results:
+ *       VMCI_SUCCESS always.
+ *
+ * Side Effects:
+ *       Pages are unpinned.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+int VMCIHost_UnmapQueues(uint32_t gid,	// IN
+			 struct vmci_queue *produceQ,	// IN/OUT
+			 struct vmci_queue *consumeQ)	// IN/OUT
+{
+	if (produceQ->qHeader) {
+		ASSERT(consumeQ->qHeader);
+
+		if (produceQ->qHeader < consumeQ->qHeader)
+			vunmap(produceQ->qHeader);
+		else
+			vunmap(consumeQ->qHeader);
+
+		produceQ->qHeader = NULL;
+		consumeQ->qHeader = NULL;
+	}
+
+	return VMCI_SUCCESS;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIHost_ReleaseUserMemory --
+ *       Release the reference to user pages stored in the attach
+ *       struct
+ *
+ * Results:
+ *       None
+ *
+ * Side Effects:
+ *       Pages are released from the page cache and may become
+ *       swappable again.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+void VMCIHost_ReleaseUserMemory(struct vmci_queue *produceQ,	// IN/OUT
+				struct vmci_queue *consumeQ)	// IN/OUT
+{
+	ASSERT(produceQ->kernelIf->headerPage);
+
+	VMCIHost_UnregisterUserMemory(produceQ, consumeQ);
+}
+
+
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * qp_list_find --
+ *
+ *      Finds the entry in the list corresponding to a given handle. Assumes
+ *      that the list is locked.
+ *
+ * Results:
+ *      Pointer to entry.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static struct qp_entry *qp_list_find(struct qp_list *qpList,	// IN
+				     struct vmci_handle handle)	// IN
+{
+	struct qp_entry *entry;
+
+	if (VMCI_HANDLE_INVALID(handle))
+		return NULL;
+
+	list_for_each_entry(entry, &qpList->head, listItem) {
+		if (VMCI_HANDLE_EQUAL(entry->handle, handle))
+			return entry;
+	}
+
+	return NULL;
+}
+
+/*
+ *----------------------------------------------------------------------------
+ *
+ * qp_notify_peer_local --
+ *
+ *      Dispatches a queue pair event message directly into the local event
+ *      queue.
+ *
+ * Results:
+ *      VMCI_SUCCESS on success, error code otherwise
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------------
+ */
+
+static int qp_notify_peer_local(bool attach,	// IN: attach or detach?
+				struct vmci_handle handle)	// IN: queue pair handle
+{
+	struct vmci_event_msg *eMsg;
+	struct vmci_event_payld_qp *ePayload;
+	/* buf is only 48 bytes. */
+	char buf[sizeof *eMsg + sizeof *ePayload];
+	uint32_t contextId;
+
+	contextId = VMCI_GetContextID();
+
+	eMsg = (struct vmci_event_msg *)buf;
+	ePayload = vmci_event_data_payload(&eMsg->eventData);
+
+	eMsg->hdr.dst = vmci_make_handle(contextId, VMCI_EVENT_HANDLER);
+	eMsg->hdr.src = vmci_make_handle(VMCI_HYPERVISOR_CONTEXT_ID,
+					 VMCI_CONTEXT_RESOURCE_ID);
+	eMsg->hdr.payloadSize =
+		sizeof *eMsg + sizeof *ePayload - sizeof eMsg->hdr;
+	eMsg->eventData.event =
+		attach ? VMCI_EVENT_QP_PEER_ATTACH : VMCI_EVENT_QP_PEER_DETACH;
+	ePayload->peerId = contextId;
+	ePayload->handle = handle;
+
+	return vmci_event_dispatch((struct vmci_dg *)eMsg);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * qp_guest_endpoint_create --
+ *
+ *      Allocates and initializes a qp_guest_endpoint structure.
+ *      Allocates a QueuePair rid (and handle) iff the given entry has
+ *      an invalid handle.  0 through VMCI_RESERVED_RESOURCE_ID_MAX
+ *      are reserved handles.  Assumes that the QP list mutex is held
+ *      by the caller.
+ *
+ * Results:
+ *      Pointer to structure intialized.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static struct qp_guest_endpoint *qp_guest_endpoint_create(struct vmci_handle handle,	// IN
+							  uint32_t peer,	// IN
+							  uint32_t flags,	// IN
+							  uint64_t produceSize,	// IN
+							  uint64_t consumeSize,	// IN
+							  void *produceQ,	// IN
+							  void *consumeQ)	// IN
+{
+	static uint32_t queuePairRID = VMCI_RESERVED_RESOURCE_ID_MAX + 1;
+	struct qp_guest_endpoint *entry;
+	const uint64_t numPPNs = dm_div_up(produceSize, PAGE_SIZE) + dm_div_up(consumeSize, PAGE_SIZE) + 2;	/* One page each for the queue headers. */
+
+	ASSERT((produceSize || consumeSize) && produceQ && consumeQ);
+
+	if (VMCI_HANDLE_INVALID(handle)) {
+		uint32_t contextID = VMCI_GetContextID();
+		uint32_t oldRID = queuePairRID;
+
+		/*
+		 * Generate a unique QueuePair rid.  Keep on trying until we wrap around
+		 * in the RID space.
+		 */
+		ASSERT(oldRID > VMCI_RESERVED_RESOURCE_ID_MAX);
+		do {
+			handle = vmci_make_handle(contextID, queuePairRID);
+			entry = (struct qp_guest_endpoint *)
+				qp_list_find(&qpGuestEndpoints, handle);
+			queuePairRID++;
+
+			if (unlikely(!queuePairRID))
+				/* Skip the reserved rids. */
+				queuePairRID = 
+				  VMCI_RESERVED_RESOURCE_ID_MAX + 1;
+
+		} while (entry && queuePairRID != oldRID);
+
+		if (unlikely(entry != NULL)) {
+			ASSERT(queuePairRID == oldRID);
+			/*
+			 * We wrapped around --- no rids were free.
+			 */
+			return NULL;
+		}
+	}
+
+	ASSERT(!VMCI_HANDLE_INVALID(handle) &&
+	       qp_list_find(&qpGuestEndpoints, handle) == NULL);
+	entry = kzalloc(sizeof *entry, GFP_KERNEL);
+	if (entry) {
+		entry->qp.handle = handle;
+		entry->qp.peer = peer;
+		entry->qp.flags = flags;
+		entry->qp.produceSize = produceSize;
+		entry->qp.consumeSize = consumeSize;
+		entry->qp.refCount = 0;
+		entry->numPPNs = numPPNs;
+		entry->produceQ = produceQ;
+		entry->consumeQ = consumeQ;
+		INIT_LIST_HEAD(&entry->qp.listItem);
+	}
+	return entry;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * qp_guest_endpoint_destroy --
+ *
+ *      Frees a QPGuestEndpoint structure.
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static void qp_guest_endpoint_destroy(struct qp_guest_endpoint *entry)	// IN
+{
+	ASSERT(entry);
+	ASSERT(entry->qp.refCount == 0);
+
+	qp_free_ppn_set(&entry->ppnSet);
+	VMCI_CleanupQueueMutex(entry->produceQ, entry->consumeQ);
+	qp_free_queue(entry->produceQ, entry->qp.produceSize);
+	qp_free_queue(entry->consumeQ, entry->qp.consumeSize);
+	kfree(entry);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * qp_alloc_hypercall --
+ *
+ *      Helper to make a QueuePairAlloc hypercall when the driver is
+ *      supporting a guest device.
+ *
+ * Results:
+ *      Result of the hypercall.
+ *
+ * Side effects:
+ *      Memory is allocated & freed.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static int qp_alloc_hypercall(const struct qp_guest_endpoint *entry)	// IN
+{
+	struct vmci_qp_alloc_msg *allocMsg;
+	size_t msgSize;
+	int result;
+
+	if (!entry || entry->numPPNs <= 2)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	ASSERT(!(entry->qp.flags & VMCI_QPFLAG_LOCAL));
+
+	msgSize = sizeof *allocMsg + (size_t) entry->numPPNs * sizeof(uint32_t);
+	allocMsg = kmalloc(msgSize, GFP_KERNEL);
+	if (!allocMsg)
+		return VMCI_ERROR_NO_MEM;
+
+	allocMsg->hdr.dst = vmci_make_handle(VMCI_HYPERVISOR_CONTEXT_ID,
+					     VMCI_QUEUEPAIR_ALLOC);
+	allocMsg->hdr.src = VMCI_ANON_SRC_HANDLE;
+	allocMsg->hdr.payloadSize = msgSize - VMCI_DG_HEADERSIZE;
+	allocMsg->handle = entry->qp.handle;
+	allocMsg->peer = entry->qp.peer;
+	allocMsg->flags = entry->qp.flags;
+	allocMsg->produceSize = entry->qp.produceSize;
+	allocMsg->consumeSize = entry->qp.consumeSize;
+	allocMsg->numPPNs = entry->numPPNs;
+
+	result =
+		qp_populate_ppn_set((uint8_t *) allocMsg + sizeof *allocMsg,
+				    &entry->ppnSet);
+	if (result == VMCI_SUCCESS)
+		result = vmci_send_dg((struct vmci_dg *)allocMsg);
+
+	kfree(allocMsg);
+
+	return result;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * qp_detatch_hypercall --
+ *
+ *      Helper to make a QueuePairDetach hypercall when the driver is
+ *      supporting a guest device.
+ *
+ * Results:
+ *      Result of the hypercall.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static int qp_detatch_hypercall(struct vmci_handle handle)	// IN
+{
+	struct vmci_qp_detach_msg detachMsg;
+
+	detachMsg.hdr.dst = vmci_make_handle(VMCI_HYPERVISOR_CONTEXT_ID,
+					     VMCI_QUEUEPAIR_DETACH);
+	detachMsg.hdr.src = VMCI_ANON_SRC_HANDLE;
+	detachMsg.hdr.payloadSize = sizeof handle;
+	detachMsg.handle = handle;
+
+	return vmci_send_dg((struct vmci_dg *)&detachMsg);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * qp_list_add_entry --
+ *
+ *      Adds the given entry to the list. Assumes that the list is locked.
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static void qp_list_add_entry(struct qp_list *qpList,	// IN
+				     struct qp_entry *entry)	// IN
+{
+	if (entry)
+		list_add(&entry->listItem, &qpList->head);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * qp_list_remove_entry --
+ *
+ *      Removes the given entry from the list. Assumes that the list is locked.
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static void qp_list_remove_entry(struct qp_list *qpList,	// IN
+					struct qp_entry *entry)	// IN
+{
+	if (entry)
+		list_del(&entry->listItem);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * qp_detatch_guest_work --
+ *
+ *      Helper for VMCI QueuePair detach interface. Frees the physical
+ *      pages for the queue pair.
+ *
+ * Results:
+ *      Success or failure.
+ *
+ * Side effects:
+ *      Memory may be freed.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static int qp_detatch_guest_work(struct vmci_handle handle)	// IN
+{
+	int result;
+	struct qp_guest_endpoint *entry;
+	uint32_t refCount = ~0;	/* To avoid compiler warning below */
+
+	ASSERT(!VMCI_HANDLE_INVALID(handle));
+
+	down(&qpGuestEndpoints.mutex);
+
+	entry = (struct qp_guest_endpoint *)
+		qp_list_find(&qpGuestEndpoints, handle);
+	if (!entry) {
+		up(&qpGuestEndpoints.mutex);
+		return VMCI_ERROR_NOT_FOUND;
+	}
+
+	ASSERT(entry->qp.refCount >= 1);
+
+	if (entry->qp.flags & VMCI_QPFLAG_LOCAL) {
+		result = VMCI_SUCCESS;
+
+		if (entry->qp.refCount > 1) {
+			result = qp_notify_peer_local(false, handle);
+			/*
+			 * We can fail to notify a local queuepair because we can't allocate.
+			 * We still want to release the entry if that happens, so don't bail
+			 * out yet.
+			 */
+		}
+	} else {
+		result = qp_detatch_hypercall(handle);
+		if (result < VMCI_SUCCESS) {
+			/*
+			 * We failed to notify a non-local queuepair.  That other queuepair
+			 * might still be accessing the shared memory, so don't release the
+			 * entry yet.  It will get cleaned up by VMCIQueuePair_Exit()
+			 * if necessary (assuming we are going away, otherwise why did this
+			 * fail?).
+			 */
+
+			up(&qpGuestEndpoints.mutex);
+			return result;
+		}
+	}
+
+	/*
+	 * If we get here then we either failed to notify a local queuepair, or
+	 * we succeeded in all cases.  Release the entry if required.
+	 */
+
+	entry->qp.refCount--;
+	if (entry->qp.refCount == 0)
+		qp_list_remove_entry(&qpGuestEndpoints, &entry->qp);
+
+	/* If we didn't remove the entry, this could change once we unlock. */
+	if (entry)
+		refCount = entry->qp.refCount;
+
+	up(&qpGuestEndpoints.mutex);
+
+	if (refCount == 0)
+		qp_guest_endpoint_destroy(entry);
+
+	return result;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * qp_alloc_guest_work --
+ *
+ *      This functions handles the actual allocation of a VMCI queue
+ *      pair guest endpoint. Allocates physical pages for the queue
+ *      pair. It makes OS dependent calls through generic wrappers.
+ *
+ * Results:
+ *      Success or failure.
+ *
+ * Side effects:
+ *      Memory is allocated.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static int qp_alloc_guest_work(struct vmci_handle *handle,	// IN/OUT
+			       struct vmci_queue **produceQ,	// OUT
+			       uint64_t produceSize,	// IN
+			       struct vmci_queue **consumeQ,	// OUT
+			       uint64_t consumeSize,	// IN
+			       uint32_t peer,	// IN
+			       uint32_t flags,	// IN
+			       uint32_t privFlags)	// IN
+{
+	const uint64_t numProducePages = dm_div_up(produceSize, PAGE_SIZE) + 1;
+	const uint64_t numConsumePages = dm_div_up(consumeSize, PAGE_SIZE) + 1;
+	void *myProduceQ = NULL;
+	void *myConsumeQ = NULL;
+	int result;
+	struct qp_guest_endpoint *queuePairEntry = NULL;
+
+	ASSERT(handle && produceQ && consumeQ && (produceSize || consumeSize));
+
+	if (privFlags != VMCI_NO_PRIVILEGE_FLAGS)
+		return VMCI_ERROR_NO_ACCESS;
+
+	down(&qpGuestEndpoints.mutex);
+
+	if ((queuePairEntry = (struct qp_guest_endpoint *)
+	     qp_list_find(&qpGuestEndpoints, *handle))) {
+		if (queuePairEntry->qp.flags & VMCI_QPFLAG_LOCAL) {
+			/* Local attach case. */
+			if (queuePairEntry->qp.refCount > 1) {
+				pr_devel("Error attempting to attach more than "
+					 "once.");
+				result = VMCI_ERROR_UNAVAILABLE;
+				goto errorKeepEntry;
+			}
+
+			if (queuePairEntry->qp.produceSize != consumeSize
+			    || queuePairEntry->qp.consumeSize !=
+			    produceSize
+			    || queuePairEntry->qp.flags !=
+			    (flags & ~VMCI_QPFLAG_ATTACH_ONLY)) {
+				pr_devel("Error mismatched queue pair in local "
+					 "attach.");
+				result = VMCI_ERROR_QUEUEPAIR_MISMATCH;
+				goto errorKeepEntry;
+			}
+
+			/*
+			 * Do a local attach.  We swap the consume and produce queues for the
+			 * attacher and deliver an attach event.
+			 */
+			result = qp_notify_peer_local(true, *handle);
+			if (result < VMCI_SUCCESS)
+				goto errorKeepEntry;
+
+			myProduceQ = queuePairEntry->consumeQ;
+			myConsumeQ = queuePairEntry->produceQ;
+			goto out;
+		}
+		result = VMCI_ERROR_ALREADY_EXISTS;
+		goto errorKeepEntry;
+	}
+
+	myProduceQ = qp_alloc_queue(produceSize, flags);
+	if (!myProduceQ) {
+		pr_warn("Error allocating pages for produce queue.");
+		result = VMCI_ERROR_NO_MEM;
+		goto error;
+	}
+
+	myConsumeQ = qp_alloc_queue(consumeSize, flags);
+	if (!myConsumeQ) {
+		pr_warn("Error allocating pages for consume queue.");
+		result = VMCI_ERROR_NO_MEM;
+		goto error;
+	}
+
+	queuePairEntry = qp_guest_endpoint_create(*handle, peer, flags,
+						  produceSize, consumeSize,
+						  myProduceQ, myConsumeQ);
+	if (!queuePairEntry) {
+		pr_warn("Error allocating memory in %s.", __FUNCTION__);
+		result = VMCI_ERROR_NO_MEM;
+		goto error;
+	}
+
+	result = qp_alloc_ppn_set(myProduceQ, numProducePages, myConsumeQ,
+				  numConsumePages, &queuePairEntry->ppnSet);
+	if (result < VMCI_SUCCESS) {
+		pr_warn("qp_alloc_ppn_set failed.");
+		goto error;
+	}
+
+	/*
+	 * It's only necessary to notify the host if this queue pair will be
+	 * attached to from another context.
+	 */
+	if (queuePairEntry->qp.flags & VMCI_QPFLAG_LOCAL) {
+		/* Local create case. */
+		uint32_t contextId = VMCI_GetContextID();
+
+		/*
+		 * Enforce similar checks on local queue pairs as we do for regular ones.
+		 * The handle's context must match the creator or attacher context id
+		 * (here they are both the current context id) and the attach-only flag
+		 * cannot exist during create.  We also ensure specified peer is this
+		 * context or an invalid one.
+		 */
+		if (queuePairEntry->qp.handle.context != contextId ||
+		    (queuePairEntry->qp.peer != VMCI_INVALID_ID &&
+		     queuePairEntry->qp.peer != contextId)) {
+			result = VMCI_ERROR_NO_ACCESS;
+			goto error;
+		}
+
+		if (queuePairEntry->qp.flags & VMCI_QPFLAG_ATTACH_ONLY) {
+			result = VMCI_ERROR_NOT_FOUND;
+			goto error;
+		}
+	} else {
+		result = qp_alloc_hypercall(queuePairEntry);
+		if (result < VMCI_SUCCESS) {
+			pr_warn("qp_alloc_hypercall result = %d.",
+				result);
+			goto error;
+		}
+	}
+
+	VMCI_InitQueueMutex((struct vmci_queue *)myProduceQ,
+			    (struct vmci_queue *)myConsumeQ);
+
+	qp_list_add_entry(&qpGuestEndpoints, &queuePairEntry->qp);
+
+out:
+	queuePairEntry->qp.refCount++;
+	*handle = queuePairEntry->qp.handle;
+	*produceQ = (struct vmci_queue *)myProduceQ;
+	*consumeQ = (struct vmci_queue *)myConsumeQ;
+
+	/*
+	 * We should initialize the queue pair header pages on a local queue pair
+	 * create.  For non-local queue pairs, the hypervisor initializes the header
+	 * pages in the create step.
+	 */
+	if ((queuePairEntry->qp.flags & VMCI_QPFLAG_LOCAL) &&
+	    queuePairEntry->qp.refCount == 1) {
+		vmci_q_header_init((*produceQ)->qHeader, *handle);
+		vmci_q_header_init((*consumeQ)->qHeader, *handle);
+	}
+
+	up(&qpGuestEndpoints.mutex);
+
+	return VMCI_SUCCESS;
+
+error:
+	up(&qpGuestEndpoints.mutex);
+	if (queuePairEntry) {
+		/* The queues will be freed inside the destroy routine. */
+		qp_guest_endpoint_destroy(queuePairEntry);
+	} else {
+		if (myProduceQ) {
+			qp_free_queue(myProduceQ, produceSize);
+		}
+		if (myConsumeQ) {
+			qp_free_queue(myConsumeQ, consumeSize);
+		}
+	}
+	return result;
+
+errorKeepEntry:
+	/* This path should only be used when an existing entry was found. */
+	ASSERT(queuePairEntry->qp.refCount > 0);
+	up(&qpGuestEndpoints.mutex);
+	return result;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * qp_broker_create --
+ *
+ *      The first endpoint issuing a queue pair allocation will create the state
+ *      of the queue pair in the queue pair broker.
+ *
+ *      If the creator is a guest, it will associate a VMX virtual address range
+ *      with the queue pair as specified by the pageStore. For compatibility with
+ *      older VMX'en, that would use a separate step to set the VMX virtual
+ *      address range, the virtual address range can be registered later using
+ *      vmci_qp_broker_set_page_store. In that case, a pageStore of NULL should be
+ *      used.
+ *
+ *      If the creator is the host, a pageStore of NULL should be used as well,
+ *      since the host is not able to supply a page store for the queue pair.
+ *
+ *      For older VMX and host callers, the queue pair will be created in the
+ *      VMCIQPB_CREATED_NO_MEM state, and for current VMX callers, it will be
+ *      created in VMCOQPB_CREATED_MEM state.
+ *
+ * Results:
+ *      VMCI_SUCCESS on success, appropriate error code otherwise.
+ *
+ * Side effects:
+ *      Memory will be allocated, and pages may be pinned.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static int qp_broker_create(struct vmci_handle handle,	// IN
+			    uint32_t peer,	// IN
+			    uint32_t flags,	// IN
+			    uint32_t privFlags,	// IN
+			    uint64_t produceSize,	// IN
+			    uint64_t consumeSize,	// IN
+			    QueuePairPageStore * pageStore,	// IN
+			    struct vmci_ctx *context,	// IN: Caller
+			    VMCIEventReleaseCB wakeupCB,	// IN
+			    void *clientData,	// IN
+			    struct qp_broker_entry **ent)	// OUT
+{
+	struct qp_broker_entry *entry = NULL;
+	const uint32_t contextId = vmci_ctx_get_id(context);
+	bool isLocal = flags & VMCI_QPFLAG_LOCAL;
+	int result;
+	uint64_t guestProduceSize;
+	uint64_t guestConsumeSize;
+
+	/*
+	 * Do not create if the caller asked not to.
+	 */
+
+	if (flags & VMCI_QPFLAG_ATTACH_ONLY) {
+		return VMCI_ERROR_NOT_FOUND;
+	}
+
+	/*
+	 * Creator's context ID should match handle's context ID or the creator
+	 * must allow the context in handle's context ID as the "peer".
+	 */
+
+	if (handle.context != contextId && handle.context != peer) {
+		return VMCI_ERROR_NO_ACCESS;
+	}
+
+	if (VMCI_CONTEXT_IS_VM(contextId) && VMCI_CONTEXT_IS_VM(peer)) {
+		return VMCI_ERROR_DST_UNREACHABLE;
+	}
+
+	/*
+	 * Creator's context ID for local queue pairs should match the
+	 * peer, if a peer is specified.
+	 */
+
+	if (isLocal && peer != VMCI_INVALID_ID && contextId != peer) {
+		return VMCI_ERROR_NO_ACCESS;
+	}
+
+	entry = kzalloc(sizeof *entry, GFP_ATOMIC);
+	if (!entry) {
+		return VMCI_ERROR_NO_MEM;
+	}
+
+	if (vmci_ctx_get_id(context) == VMCI_HOST_CONTEXT_ID && !isLocal) {
+		/*
+		 * The queue pair broker entry stores values from the guest
+		 * point of view, so a creating host side endpoint should swap
+		 * produce and consume values -- unless it is a local queue
+		 * pair, in which case no swapping is necessary, since the local
+		 * attacher will swap queues.
+		 */
+
+		guestProduceSize = consumeSize;
+		guestConsumeSize = produceSize;
+	} else {
+		guestProduceSize = produceSize;
+		guestConsumeSize = consumeSize;
+	}
+
+	entry->qp.handle = handle;
+	entry->qp.peer = peer;
+	entry->qp.flags = flags;
+	entry->qp.produceSize = guestProduceSize;
+	entry->qp.consumeSize = guestConsumeSize;
+	entry->qp.refCount = 1;
+	entry->createId = contextId;
+	entry->attachId = VMCI_INVALID_ID;
+	entry->state = VMCIQPB_NEW;
+	entry->requireTrustedAttach =
+		(context->privFlags & VMCI_PRIVILEGE_FLAG_RESTRICTED) ? true :
+		false;
+	entry->createdByTrusted =
+		(privFlags & VMCI_PRIVILEGE_FLAG_TRUSTED) ? true : false;
+	entry->vmciPageFiles = false;
+	entry->wakeupCB = wakeupCB;
+	entry->clientData = clientData;
+	entry->produceQ = VMCIHost_AllocQueue(guestProduceSize);
+	if (entry->produceQ == NULL) {
+		result = VMCI_ERROR_NO_MEM;
+		goto error;
+	}
+	entry->consumeQ = VMCIHost_AllocQueue(guestConsumeSize);
+	if (entry->consumeQ == NULL) {
+		result = VMCI_ERROR_NO_MEM;
+		goto error;
+	}
+
+	VMCI_InitQueueMutex(entry->produceQ, entry->consumeQ);
+
+	INIT_LIST_HEAD(&entry->qp.listItem);
+
+	if (isLocal) {
+		ASSERT(pageStore == NULL);
+
+		entry->localMem =
+			kmalloc(QPE_NUM_PAGES(entry->qp) * PAGE_SIZE, GFP_KERNEL);
+		if (entry->localMem == NULL) {
+			result = VMCI_ERROR_NO_MEM;
+			goto error;
+		}
+		entry->state = VMCIQPB_CREATED_MEM;
+		entry->produceQ->qHeader = entry->localMem;
+		entry->consumeQ->qHeader =
+			(struct vmci_queue_header *)((uint8_t *) entry->localMem +
+						     (dm_div_up
+						      (entry->qp.produceSize,
+						       PAGE_SIZE) + 1) * PAGE_SIZE);
+		vmci_q_header_init(entry->produceQ->qHeader, handle);
+		vmci_q_header_init(entry->consumeQ->qHeader, handle);
+	} else if (pageStore) {
+		ASSERT(entry->createId != VMCI_HOST_CONTEXT_ID || isLocal);
+
+		/*
+		 * The VMX already initialized the queue pair headers, so no
+		 * need for the kernel side to do that.
+		 */
+
+		result = VMCIHost_RegisterUserMemory(pageStore,
+						     entry->produceQ,
+						     entry->consumeQ);
+		if (result < VMCI_SUCCESS) {
+			goto error;
+		}
+		entry->state = VMCIQPB_CREATED_MEM;
+	} else {
+		/*
+		 * A create without a pageStore may be either a host side create (in which
+		 * case we are waiting for the guest side to supply the memory) or an old
+		 * style queue pair create (in which case we will expect a set page store
+		 * call as the next step).
+		 */
+
+		entry->state = VMCIQPB_CREATED_NO_MEM;
+	}
+
+	qp_list_add_entry(&qpBrokerList, &entry->qp);
+	if (ent != NULL)
+		*ent = entry;
+
+	vmci_ctx_qp_create(context, handle);
+
+	return VMCI_SUCCESS;
+
+error:
+	if (entry != NULL) {
+		if (entry->produceQ != NULL)
+			VMCIHost_FreeQueue(entry->produceQ, guestProduceSize);
+
+		if (entry->consumeQ != NULL)
+			VMCIHost_FreeQueue(entry->consumeQ, guestConsumeSize);
+
+		kfree(entry);
+	}
+	return result;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * qp_notify_peer --
+ *
+ *      Enqueues an event datagram to notify the peer VM attached to
+ *      the given queue pair handle about attach/detach event by the
+ *      given VM.
+ *
+ * Results:
+ *      Payload size of datagram enqueued on success, error code otherwise.
+ *
+ * Side effects:
+ *      Memory is allocated.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static int qp_notify_peer(bool attach,	// IN: attach or detach?
+			  struct vmci_handle handle,	// IN
+			  uint32_t myId,	// IN
+			  uint32_t peerId)	// IN: CID of VM to notify
+{
+	int rv;
+	struct vmci_event_msg *eMsg;
+	struct vmci_event_payld_qp *evPayload;
+	char buf[sizeof *eMsg + sizeof *evPayload];
+
+	if (VMCI_HANDLE_INVALID(handle) || myId == VMCI_INVALID_ID ||
+	    peerId == VMCI_INVALID_ID)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	/*
+	 * Notification message contains: queue pair handle and
+	 * attaching/detaching VM's context id.
+	 */
+
+	eMsg = (struct vmci_event_msg *)buf;
+
+	/*
+	 * In vmci_ctx_enqueue_dg() we enforce the upper limit on number of
+	 * pending events from the hypervisor to a given VM otherwise a rogue VM
+	 * could do an arbitrary number of attach and detach operations causing memory
+	 * pressure in the host kernel.
+	 */
+
+	/* Clear out any garbage. */
+	memset(eMsg, 0, sizeof buf);
+
+	eMsg->hdr.dst = vmci_make_handle(peerId, VMCI_EVENT_HANDLER);
+	eMsg->hdr.src = vmci_make_handle(VMCI_HYPERVISOR_CONTEXT_ID,
+					 VMCI_CONTEXT_RESOURCE_ID);
+	eMsg->hdr.payloadSize =
+		sizeof *eMsg + sizeof *evPayload - sizeof eMsg->hdr;
+	eMsg->eventData.event =
+		attach ? VMCI_EVENT_QP_PEER_ATTACH : VMCI_EVENT_QP_PEER_DETACH;
+	evPayload = vmci_event_data_payload(&eMsg->eventData);
+	evPayload->handle = handle;
+	evPayload->peerId = myId;
+
+	rv = vmci_dg_dispatch(VMCI_HYPERVISOR_CONTEXT_ID,
+			      (struct vmci_dg *)eMsg, false);
+	if (rv < VMCI_SUCCESS)
+		pr_warn("Failed to enqueue QueuePair %s event datagram "
+			"for context (ID=0x%x).",
+			attach ? "ATTACH" : "DETACH", peerId);
+
+	return rv;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * qp_broker_attach --
+ *
+ *      The second endpoint issuing a queue pair allocation will attach to the
+ *      queue pair registered with the queue pair broker.
+ *
+ *      If the attacher is a guest, it will associate a VMX virtual address range
+ *      with the queue pair as specified by the pageStore. At this point, the
+ *      already attach host endpoint may start using the queue pair, and an
+ *      attach event is sent to it. For compatibility with older VMX'en, that
+ *      used a separate step to set the VMX virtual address range, the virtual
+ *      address range can be registered later using vmci_qp_broker_set_page_store. In
+ *      that case, a pageStore of NULL should be used, and the attach event will
+ *      be generated once the actual page store has been set.
+ *
+ *      If the attacher is the host, a pageStore of NULL should be used as well,
+ *      since the page store information is already set by the guest.
+ *
+ *      For new VMX and host callers, the queue pair will be moved to the
+ *      VMCIQPB_ATTACHED_MEM state, and for older VMX callers, it will be
+ *      moved to the VMCOQPB_ATTACHED_NO_MEM state.
+ *
+ * Results:
+ *      VMCI_SUCCESS on success, appropriate error code otherwise.
+ *
+ * Side effects:
+ *      Memory will be allocated, and pages may be pinned.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static int qp_broker_attach(struct qp_broker_entry *entry,	// IN
+			    uint32_t peer,	// IN
+			    uint32_t flags,	// IN
+			    uint32_t privFlags,	// IN
+			    uint64_t produceSize,	// IN
+			    uint64_t consumeSize,	// IN
+			    QueuePairPageStore * pageStore,	// IN/OUT
+			    struct vmci_ctx *context,	// IN: Caller
+			    VMCIEventReleaseCB wakeupCB,	// IN
+			    void *clientData,	// IN
+			    struct qp_broker_entry **ent)	// OUT
+{
+	const uint32_t contextId = vmci_ctx_get_id(context);
+	bool isLocal = flags & VMCI_QPFLAG_LOCAL;
+	int result;
+
+	if (entry->state != VMCIQPB_CREATED_NO_MEM &&
+	    entry->state != VMCIQPB_CREATED_MEM)
+		return VMCI_ERROR_UNAVAILABLE;
+
+	if (isLocal) {
+		if (!(entry->qp.flags & VMCI_QPFLAG_LOCAL) ||
+		    contextId != entry->createId) {
+			return VMCI_ERROR_INVALID_ARGS;
+		}
+	} else if (contextId == entry->createId ||
+		   contextId == entry->attachId) {
+		return VMCI_ERROR_ALREADY_EXISTS;
+	}
+
+	ASSERT(entry->qp.refCount < 2);
+	ASSERT(entry->attachId == VMCI_INVALID_ID);
+
+	if (VMCI_CONTEXT_IS_VM(contextId) &&
+	    VMCI_CONTEXT_IS_VM(entry->createId))
+		return VMCI_ERROR_DST_UNREACHABLE;
+
+	/*
+	 * If we are attaching from a restricted context then the queuepair
+	 * must have been created by a trusted endpoint.
+	 */
+	if ((context->privFlags & VMCI_PRIVILEGE_FLAG_RESTRICTED) &&
+	    !entry->createdByTrusted)
+		return VMCI_ERROR_NO_ACCESS;
+
+	/*
+	 * If we are attaching to a queuepair that was created by a restricted
+	 * context then we must be trusted.
+	 */
+	if (entry->requireTrustedAttach &&
+	    (!(privFlags & VMCI_PRIVILEGE_FLAG_TRUSTED)))
+		return VMCI_ERROR_NO_ACCESS;
+
+	/*
+	 * If the creator specifies VMCI_INVALID_ID in "peer" field, access
+	 * control check is not performed.
+	 */
+
+	if (entry->qp.peer != VMCI_INVALID_ID && entry->qp.peer != contextId)
+		return VMCI_ERROR_NO_ACCESS;
+
+	if (entry->createId == VMCI_HOST_CONTEXT_ID) {
+		/*
+		 * Do not attach if the caller doesn't support Host Queue Pairs
+		 * and a host created this queue pair.
+		 */
+
+		if (!vmci_ctx_supports_host_qp(context))
+			return VMCI_ERROR_INVALID_RESOURCE;
+
+	} else if (contextId == VMCI_HOST_CONTEXT_ID) {
+		struct vmci_ctx *createContext;
+		bool supportsHostQP;
+
+		/*
+		 * Do not attach a host to a user created queue pair if that
+		 * user doesn't support host queue pair end points.
+		 */
+
+		createContext = vmci_ctx_get(entry->createId);
+		supportsHostQP = vmci_ctx_supports_host_qp(createContext);
+		vmci_ctx_release(createContext);
+
+		if (!supportsHostQP)
+			return VMCI_ERROR_INVALID_RESOURCE;
+	}
+
+	if ((entry->qp.flags & ~VMCI_QP_ASYMM) != (flags & ~VMCI_QP_ASYMM_PEER))
+		return VMCI_ERROR_QUEUEPAIR_MISMATCH;
+
+	if (contextId != VMCI_HOST_CONTEXT_ID) {
+		/*
+		 * The queue pair broker entry stores values from the guest
+		 * point of view, so an attaching guest should match the values
+		 * stored in the entry.
+		 */
+
+		if (entry->qp.produceSize != produceSize ||
+		    entry->qp.consumeSize != consumeSize) {
+			return VMCI_ERROR_QUEUEPAIR_MISMATCH;
+		}
+	} else if (entry->qp.produceSize != consumeSize ||
+		   entry->qp.consumeSize != produceSize) {
+		return VMCI_ERROR_QUEUEPAIR_MISMATCH;
+	}
+
+	if (contextId != VMCI_HOST_CONTEXT_ID) {
+		/*
+		 * If a guest attached to a queue pair, it will supply the backing memory.
+		 * If this is a pre NOVMVM vmx, the backing memory will be supplied by
+		 * calling vmci_qp_broker_set_page_store() following the return of the
+		 * vmci_qp_broker_alloc() call. If it is a vmx of version NOVMVM or later,
+		 * the page store must be supplied as part of the vmci_qp_broker_alloc call.
+		 * Under all circumstances must the initially created queue pair not have
+		 * any memory associated with it already.
+		 */
+
+		if (entry->state != VMCIQPB_CREATED_NO_MEM)
+			return VMCI_ERROR_INVALID_ARGS;
+
+		if (pageStore != NULL) {
+			/*
+			 * Patch up host state to point to guest supplied memory. The VMX
+			 * already initialized the queue pair headers, so no need for the
+			 * kernel side to do that.
+			 */
+
+			result = VMCIHost_RegisterUserMemory(pageStore,
+							     entry->produceQ,
+							     entry->consumeQ);
+			if (result < VMCI_SUCCESS)
+				return result;
+
+			/*
+			 * Preemptively load in the headers if non-blocking to
+			 * prevent blocking later.
+			 */
+			if (entry->qp.flags & VMCI_QPFLAG_NONBLOCK) {
+				result = VMCIHost_MapQueues(entry->produceQ,
+							    entry->consumeQ);
+				if (result < VMCI_SUCCESS) {
+					VMCIHost_ReleaseUserMemory(entry->
+								   produceQ,
+								   entry->
+								   consumeQ);
+					return result;
+				}
+			}
+
+			entry->state = VMCIQPB_ATTACHED_MEM;
+		} else {
+			entry->state = VMCIQPB_ATTACHED_NO_MEM;
+		}
+	} else if (entry->state == VMCIQPB_CREATED_NO_MEM) {
+		/*
+		 * The host side is attempting to attach to a queue pair that doesn't have
+		 * any memory associated with it. This must be a pre NOVMVM vmx that hasn't
+		 * set the page store information yet, or a quiesced VM.
+		 */
+
+		return VMCI_ERROR_UNAVAILABLE;
+	} else {
+		/*
+		 * For non-blocking queue pairs, we cannot rely on enqueue/dequeue to map
+		 * in the pages on the host-side, since it may block, so we make an attempt
+		 * here.
+		 */
+
+		if (flags & VMCI_QPFLAG_NONBLOCK) {
+			result =
+				VMCIHost_MapQueues(entry->produceQ,
+						   entry->consumeQ);
+			if (result < VMCI_SUCCESS)
+				return result;
+
+			entry->qp.flags |= flags &
+				(VMCI_QPFLAG_NONBLOCK | VMCI_QPFLAG_PINNED);
+		}
+
+		/* The host side has successfully attached to a queue pair. */
+		entry->state = VMCIQPB_ATTACHED_MEM;
+	}
+
+	if (entry->state == VMCIQPB_ATTACHED_MEM) {
+		result =
+			qp_notify_peer(true, entry->qp.handle, contextId,
+				       entry->createId);
+		if (result < VMCI_SUCCESS)
+			pr_warn("Failed to notify peer (ID=0x%x) of "
+				"attach to queue pair (handle=0x%x:0x%x).",
+				entry->createId, entry->qp.handle.context,
+				entry->qp.handle.resource);
+	}
+
+	entry->attachId = contextId;
+	entry->qp.refCount++;
+	if (wakeupCB) {
+		ASSERT(!entry->wakeupCB);
+		entry->wakeupCB = wakeupCB;
+		entry->clientData = clientData;
+	}
+
+	/*
+	 * When attaching to local queue pairs, the context already has
+	 * an entry tracking the queue pair, so don't add another one.
+	 */
+
+	if (!isLocal)
+		vmci_ctx_qp_create(context, entry->qp.handle);
+        else
+		ASSERT(vmci_ctx_qp_exists(context, entry->qp.handle));
+
+	if (ent != NULL)
+		*ent = entry;
+
+	return VMCI_SUCCESS;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * qp_broker_alloc --
+ *
+ *      QueuePair_Alloc for use when setting up queue pair endpoints
+ *      on the host. Like QueuePair_Alloc, but returns a pointer to
+ *      the struct qp_broker_entry on success.
+ *
+ * Results:
+ *      Success or failure.
+ *
+ * Side effects:
+ *      Memory may be allocated.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static int qp_broker_alloc(struct vmci_handle handle,	// IN
+			   uint32_t peer,	// IN
+			   uint32_t flags,	// IN
+			   uint32_t privFlags,	// IN
+			   uint64_t produceSize,	// IN
+			   uint64_t consumeSize,	// IN
+			   QueuePairPageStore * pageStore,	// IN/OUT
+			   struct vmci_ctx *context,	// IN: Caller
+			   VMCIEventReleaseCB wakeupCB,	// IN
+			   void *clientData,	// IN
+			   struct qp_broker_entry **ent,	// OUT
+			   bool * swap)	// OUT: swap queues?
+{
+	const uint32_t contextId = vmci_ctx_get_id(context);
+	bool create;
+	struct qp_broker_entry *entry;
+	bool isLocal = flags & VMCI_QPFLAG_LOCAL;
+	int result;
+
+	if (VMCI_HANDLE_INVALID(handle) ||
+	    (flags & ~VMCI_QP_ALL_FLAGS) || isLocal ||
+	    !(produceSize || consumeSize) ||
+	    !context || contextId == VMCI_INVALID_ID ||
+	    handle.context == VMCI_INVALID_ID) {
+		return VMCI_ERROR_INVALID_ARGS;
+	}
+
+	if (pageStore && !VMCI_QP_PAGESTORE_IS_WELLFORMED(pageStore))
+		return VMCI_ERROR_INVALID_ARGS;
+
+	/*
+	 * In the initial argument check, we ensure that non-vmkernel hosts
+	 * are not allowed to create local queue pairs.
+	 */
+
+	ASSERT(!isLocal);
+
+	down(&qpBrokerList.mutex);
+
+	if (!isLocal && vmci_ctx_qp_exists(context, handle)) {
+		pr_devel("Context (ID=0x%x) already attached to queue "
+			 "pair (handle=0x%x:0x%x).", contextId,
+			 handle.context, handle.resource);
+		up(&qpBrokerList.mutex);
+		return VMCI_ERROR_ALREADY_EXISTS;
+	}
+
+	entry = (struct qp_broker_entry *)
+		qp_list_find(&qpBrokerList, handle);
+	if (!entry) {
+		create = true;
+		result =
+			qp_broker_create(handle, peer, flags, privFlags,
+					 produceSize, consumeSize, pageStore,
+					 context, wakeupCB, clientData, ent);
+	} else {
+		create = false;
+		result =
+			qp_broker_attach(entry, peer, flags, privFlags,
+					 produceSize, consumeSize, pageStore,
+					 context, wakeupCB, clientData, ent);
+	}
+
+	up(&qpBrokerList.mutex);
+
+	if (swap)
+		*swap = (contextId == VMCI_HOST_CONTEXT_ID) &&
+			!(create && isLocal);
+
+
+	return result;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * qp_alloc_host_work --
+ *
+ *    This function implements the kernel API for allocating a queue
+ *    pair.
+ *
+ * Results:
+ *     VMCI_SUCCESS on succes and appropriate failure code otherwise.
+ *
+ * Side effects:
+ *     May allocate memory.
+ *
+ *----------------------------------------------------------------------
+ */
+
+static int qp_alloc_host_work(struct vmci_handle *handle,	// IN/OUT
+			      struct vmci_queue **produceQ,	// OUT
+			      uint64_t produceSize,	// IN
+			      struct vmci_queue **consumeQ,	// OUT
+			      uint64_t consumeSize,	// IN
+			      uint32_t peer,	// IN
+			      uint32_t flags,	// IN
+			      uint32_t privFlags,	// IN
+			      VMCIEventReleaseCB wakeupCB,	// IN
+			      void *clientData)	// IN
+{
+	struct vmci_ctx *context;
+	struct qp_broker_entry *entry;
+	int result;
+	bool swap;
+
+	if (VMCI_HANDLE_INVALID(*handle)) {
+		uint32_t resourceID = vmci_resource_get_id(VMCI_HOST_CONTEXT_ID);
+		if (resourceID == VMCI_INVALID_ID)
+			return VMCI_ERROR_NO_HANDLE;
+
+		*handle = vmci_make_handle(VMCI_HOST_CONTEXT_ID, resourceID);
+	}
+
+	context = vmci_ctx_get(VMCI_HOST_CONTEXT_ID);
+	ASSERT(context);
+
+	entry = NULL;
+	result =
+		qp_broker_alloc(*handle, peer, flags, privFlags,
+				produceSize, consumeSize, NULL, context,
+				wakeupCB, clientData, &entry, &swap);
+	if (result == VMCI_SUCCESS) {
+		if (swap) {
+			/*
+			 * If this is a local queue pair, the attacher will swap around produce
+			 * and consume queues.
+			 */
+
+			*produceQ = entry->consumeQ;
+			*consumeQ = entry->produceQ;
+		} else {
+			*produceQ = entry->produceQ;
+			*consumeQ = entry->consumeQ;
+		}
+	} else {
+		*handle = VMCI_INVALID_HANDLE;
+		pr_devel("queue pair broker failed to alloc (result=%d)"
+			 ".", result);
+	}
+	vmci_ctx_release(context);
+	return result;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * vmci_qp_alloc --
+ *
+ *      Allocates a VMCI QueuePair. Only checks validity of input
+ *      arguments. The real work is done in the host or guest
+ *      specific function.
+ *
+ * Results:
+ *      VMCI_SUCCESS on success, appropriate error code otherwise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+int vmci_qp_alloc(struct vmci_handle *handle,	// IN/OUT
+		  struct vmci_queue **produceQ,	// OUT
+		  uint64_t produceSize,	// IN
+		  struct vmci_queue **consumeQ,	// OUT
+		  uint64_t consumeSize,	// IN
+		  uint32_t peer,	// IN
+		  uint32_t flags,	// IN
+		  uint32_t privFlags,	// IN
+		  bool guestEndpoint,	// IN
+		  VMCIEventReleaseCB wakeupCB,	// IN
+		  void *clientData)	// IN
+{
+	if (!handle || !produceQ || !consumeQ || (!produceSize && !consumeSize)
+	    || (flags & ~VMCI_QP_ALL_FLAGS))
+		return VMCI_ERROR_INVALID_ARGS;
+
+	if (guestEndpoint)
+		return qp_alloc_guest_work(handle, produceQ,
+					   produceSize, consumeQ,
+					   consumeSize, peer,
+					   flags, privFlags);
+	else
+		return qp_alloc_host_work(handle, produceQ,
+					  produceSize, consumeQ,
+					  consumeSize, peer, flags,
+					  privFlags, wakeupCB,
+					  clientData);
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * qp_detatch_host_work --
+ *
+ *    This function implements the host kernel API for detaching from
+ *    a queue pair.
+ *
+ * Results:
+ *     VMCI_SUCCESS on success and appropriate failure code otherwise.
+ *
+ * Side effects:
+ *     May deallocate memory.
+ *
+ *----------------------------------------------------------------------
+ */
+
+static int qp_detatch_host_work(struct vmci_handle handle)	// IN
+{
+	int result;
+	struct vmci_ctx *context;
+
+	context = vmci_ctx_get(VMCI_HOST_CONTEXT_ID);
+
+	result = vmci_qp_broker_detach(handle, context);
+
+	vmci_ctx_release(context);
+	return result;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * qp_detatch --
+ *
+ *      Detaches from a VMCI QueuePair. Only checks validity of input argument.
+ *      Real work is done in the host or guest specific function.
+ *
+ * Results:
+ *      Success or failure.
+ *
+ * Side effects:
+ *      Memory is freed.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static int qp_detatch(struct vmci_handle handle,	// IN
+		      bool guestEndpoint)	// IN
+{
+	if (VMCI_HANDLE_INVALID(handle))
+		return VMCI_ERROR_INVALID_ARGS;
+
+	if (guestEndpoint)
+		return qp_detatch_guest_work(handle);
+	else
+		return qp_detatch_host_work(handle);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * qp_list_init --
+ *
+ *      Initializes the list of QueuePairs.
+ *
+ * Results:
+ *      Success or failure.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static int qp_list_init(struct qp_list *qpList)	// IN
+{
+	INIT_LIST_HEAD(&qpList->head);
+	sema_init(&qpList->mutex, 1);
+	return VMCI_SUCCESS;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * qp_list_get_head --
+ *
+ *      Returns the entry from the head of the list. Assumes that the list is
+ *      locked.
+ *
+ * Results:
+ *      Pointer to entry.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static struct qp_entry *qp_list_get_head(struct qp_list *qpList)
+{
+	if (!list_empty(&qpList->head)) {
+		struct qp_entry *entry =
+			list_first_entry(&qpList->head, struct qp_entry,
+					 listItem);
+		return entry;
+	}
+
+	return NULL;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * vmci_qp_broker_init --
+ *
+ *      Initalizes queue pair broker state.
+ *
+ * Results:
+ *      Success or failure.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+int __init vmci_qp_broker_init(void)
+{
+	return qp_list_init(&qpBrokerList);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * vmci_qp_broker_exit --
+ *
+ *      Destroys the queue pair broker state.
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+void vmci_qp_broker_exit(void)
+{
+	struct qp_broker_entry *entry;
+
+	down(&qpBrokerList.mutex);
+
+	while ((entry = (struct qp_broker_entry *)
+		qp_list_get_head(&qpBrokerList))) {
+		qp_list_remove_entry(&qpBrokerList, &entry->qp);
+		kfree(entry);
+	}
+
+	up(&qpBrokerList.mutex);
+	INIT_LIST_HEAD(&(qpBrokerList.head));
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * vmci_qp_broker_alloc --
+ *
+ *      Requests that a queue pair be allocated with the VMCI queue
+ *      pair broker. Allocates a queue pair entry if one does not
+ *      exist. Attaches to one if it exists, and retrieves the page
+ *      files backing that QueuePair.  Assumes that the queue pair
+ *      broker lock is held.
+ *
+ * Results:
+ *      Success or failure.
+ *
+ * Side effects:
+ *      Memory may be allocated.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+int vmci_qp_broker_alloc(struct vmci_handle handle,	// IN
+			 uint32_t peer,	// IN
+			 uint32_t flags,	// IN
+			 uint32_t privFlags,	// IN
+			 uint64_t produceSize,	// IN
+			 uint64_t consumeSize,	// IN
+			 QueuePairPageStore * pageStore,	// IN/OUT
+			 struct vmci_ctx *context)	// IN: Caller
+{
+	return qp_broker_alloc(handle, peer, flags, privFlags,
+			       produceSize, consumeSize,
+			       pageStore, context, NULL, NULL, NULL, NULL);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * vmci_qp_broker_set_page_store --
+ *
+ *      VMX'en with versions lower than VMCI_VERSION_NOVMVM use a separate
+ *      step to add the UVAs of the VMX mapping of the queue pair. This function
+ *      provides backwards compatibility with such VMX'en, and takes care of
+ *      registering the page store for a queue pair previously allocated by the
+ *      VMX during create or attach. This function will move the queue pair state
+ *      to either from VMCIQBP_CREATED_NO_MEM to VMCIQBP_CREATED_MEM or
+ *      VMCIQBP_ATTACHED_NO_MEM to VMCIQBP_ATTACHED_MEM. If moving to the
+ *      attached state with memory, the queue pair is ready to be used by the
+ *      host peer, and an attached event will be generated.
+ *
+ *      Assumes that the queue pair broker lock is held.
+ *
+ *      This function is only used by the hosted platform, since there is no
+ *      issue with backwards compatibility for vmkernel.
+ *
+ * Results:
+ *      VMCI_SUCCESS on success, appropriate error code otherwise.
+ *
+ * Side effects:
+ *      Pages may get pinned.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+int vmci_qp_broker_set_page_store(struct vmci_handle handle,	// IN
+				  uint64_t produceUVA,	// IN
+				  uint64_t consumeUVA,	// IN
+				  struct vmci_ctx *context)	// IN: Caller
+{
+	struct qp_broker_entry *entry;
+	int result;
+	const uint32_t contextId = vmci_ctx_get_id(context);
+
+	if (VMCI_HANDLE_INVALID(handle) || !context
+	    || contextId == VMCI_INVALID_ID)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	/*
+	 * We only support guest to host queue pairs, so the VMX must
+	 * supply UVAs for the mapped page files.
+	 */
+
+	if (produceUVA == 0 || consumeUVA == 0)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	down(&qpBrokerList.mutex);
+
+	if (!vmci_ctx_qp_exists(context, handle)) {
+		pr_warn("Context (ID=0x%x) not attached to queue pair "
+			"(handle=0x%x:0x%x).", contextId, handle.context,
+			handle.resource);
+		result = VMCI_ERROR_NOT_FOUND;
+		goto out;
+	}
+
+	entry = (struct qp_broker_entry *)
+		qp_list_find(&qpBrokerList, handle);
+	if (!entry) {
+		result = VMCI_ERROR_NOT_FOUND;
+		goto out;
+	}
+
+	/*
+	 * If I'm the owner then I can set the page store.
+	 *
+	 * Or, if a host created the QueuePair and I'm the attached peer
+	 * then I can set the page store.
+	 */
+
+	if (entry->createId != contextId &&
+	    (entry->createId != VMCI_HOST_CONTEXT_ID ||
+	     entry->attachId != contextId)) {
+		result = VMCI_ERROR_QUEUEPAIR_NOTOWNER;
+		goto out;
+	}
+
+	if (entry->state != VMCIQPB_CREATED_NO_MEM &&
+	    entry->state != VMCIQPB_ATTACHED_NO_MEM) {
+		result = VMCI_ERROR_UNAVAILABLE;
+		goto out;
+	}
+
+	result = VMCIHost_GetUserMemory(produceUVA, consumeUVA,
+					entry->produceQ, entry->consumeQ);
+	if (result < VMCI_SUCCESS)
+		goto out;
+
+	result = VMCIHost_MapQueues(entry->produceQ, entry->consumeQ);
+	if (result < VMCI_SUCCESS) {
+		VMCIHost_ReleaseUserMemory(entry->produceQ, entry->consumeQ);
+		goto out;
+	}
+
+	if (entry->state == VMCIQPB_CREATED_NO_MEM) {
+		entry->state = VMCIQPB_CREATED_MEM;
+	} else {
+		ASSERT(entry->state == VMCIQPB_ATTACHED_NO_MEM);
+		entry->state = VMCIQPB_ATTACHED_MEM;
+	}
+	entry->vmciPageFiles = true;
+
+	if (entry->state == VMCIQPB_ATTACHED_MEM) {
+		result =
+			qp_notify_peer(true, handle, contextId,
+				       entry->createId);
+		if (result < VMCI_SUCCESS) {
+			pr_warn("Failed to notify peer (ID=0x%x) of "
+				"attach to queue pair (handle=0x%x:0x%x).",
+				entry->createId, entry->qp.handle.context,
+				entry->qp.handle.resource);
+		}
+	}
+
+	result = VMCI_SUCCESS;
+out:
+	up(&qpBrokerList.mutex);
+	return result;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * qp_reset_saved_headers --
+ *
+ *      Resets saved queue headers for the given QP broker
+ *      entry. Should be used when guest memory becomes available
+ *      again, or the guest detaches.
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static void qp_reset_saved_headers(struct qp_broker_entry *entry)	// IN
+{
+	entry->produceQ->savedHeader = NULL;
+	entry->consumeQ->savedHeader = NULL;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * vmci_qp_broker_detach --
+ *
+ *      The main entry point for detaching from a queue pair registered with the
+ *      queue pair broker. If more than one endpoint is attached to the queue
+ *      pair, the first endpoint will mainly decrement a reference count and
+ *      generate a notification to its peer. The last endpoint will clean up
+ *      the queue pair state registered with the broker.
+ *
+ *      When a guest endpoint detaches, it will unmap and unregister the guest
+ *      memory backing the queue pair. If the host is still attached, it will
+ *      no longer be able to access the queue pair content.
+ *
+ *      If the queue pair is already in a state where there is no memory
+ *      registered for the queue pair (any *_NO_MEM state), it will transition to
+ *      the VMCIQPB_SHUTDOWN_NO_MEM state. This will also happen, if a guest
+ *      endpoint is the first of two endpoints to detach. If the host endpoint is
+ *      the first out of two to detach, the queue pair will move to the
+ *      VMCIQPB_SHUTDOWN_MEM state.
+ *
+ * Results:
+ *      VMCI_SUCCESS on success, appropriate error code otherwise.
+ *
+ * Side effects:
+ *      Memory may be freed, and pages may be unpinned.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+int vmci_qp_broker_detach(struct vmci_handle handle,	// IN
+			  struct vmci_ctx *context)	// IN
+{
+	struct qp_broker_entry *entry;
+	const uint32_t contextId = vmci_ctx_get_id(context);
+	uint32_t peerId;
+	bool isLocal = false;
+	int result;
+
+	if (VMCI_HANDLE_INVALID(handle) || !context
+	    || contextId == VMCI_INVALID_ID) {
+		return VMCI_ERROR_INVALID_ARGS;
+	}
+
+	down(&qpBrokerList.mutex);
+
+	if (!vmci_ctx_qp_exists(context, handle)) {
+		pr_devel("Context (ID=0x%x) not attached to queue pair "
+			 "(handle=0x%x:0x%x).", contextId, handle.context,
+			 handle.resource);
+		result = VMCI_ERROR_NOT_FOUND;
+		goto out;
+	}
+
+	entry = (struct qp_broker_entry *)
+		qp_list_find(&qpBrokerList, handle);
+	if (!entry) {
+		pr_devel("Context (ID=0x%x) reports being attached to "
+			 "queue pair(handle=0x%x:0x%x) that isn't present in "
+			 "broker.", contextId, handle.context,
+			 handle.resource);
+		result = VMCI_ERROR_NOT_FOUND;
+		goto out;
+	}
+
+	if (contextId != entry->createId && contextId != entry->attachId) {
+		result = VMCI_ERROR_QUEUEPAIR_NOTATTACHED;
+		goto out;
+	}
+
+	if (contextId == entry->createId) {
+		peerId = entry->attachId;
+		entry->createId = VMCI_INVALID_ID;
+	} else {
+		peerId = entry->createId;
+		entry->attachId = VMCI_INVALID_ID;
+	}
+	entry->qp.refCount--;
+
+	isLocal = entry->qp.flags & VMCI_QPFLAG_LOCAL;
+
+	if (contextId != VMCI_HOST_CONTEXT_ID) {
+		int result;
+		bool headersMapped;
+
+		ASSERT(!isLocal);
+
+		/*
+		 * Pre NOVMVM vmx'en may detach from a queue pair before setting the page
+		 * store, and in that case there is no user memory to detach from. Also,
+		 * more recent VMX'en may detach from a queue pair in the quiesced state.
+		 */
+
+		VMCI_AcquireQueueMutex(entry->produceQ);
+		headersMapped = entry->produceQ->qHeader
+			|| entry->consumeQ->qHeader;
+		if (QPBROKERSTATE_HAS_MEM(entry)) {
+			result =
+				VMCIHost_UnmapQueues
+				(INVALID_VMCI_GUEST_MEM_ID, entry->produceQ,
+				 entry->consumeQ);
+			if (result < VMCI_SUCCESS)
+				pr_warn("Failed to unmap queue headers "
+					"for queue pair "
+					"(handle=0x%x:0x%x,result=%d).",
+					handle.context, handle.resource,
+					result);
+
+			if (entry->vmciPageFiles) {
+				VMCIHost_ReleaseUserMemory(entry->produceQ,
+							   entry->consumeQ);
+			} else {
+				VMCIHost_UnregisterUserMemory(entry->produceQ,
+							      entry->consumeQ);
+			}
+		}
+
+		if (!headersMapped)
+			qp_reset_saved_headers(entry);
+
+		VMCI_ReleaseQueueMutex(entry->produceQ);
+
+		if (!headersMapped && entry->wakeupCB)
+			entry->wakeupCB(entry->clientData);
+
+	} else {
+		if (entry->wakeupCB) {
+			entry->wakeupCB = NULL;
+			entry->clientData = NULL;
+		}
+	}
+
+	if (entry->qp.refCount == 0) {
+		qp_list_remove_entry(&qpBrokerList, &entry->qp);
+
+		if (isLocal) {
+			kfree(entry->localMem);
+		}
+		VMCI_CleanupQueueMutex(entry->produceQ, entry->consumeQ);
+		VMCIHost_FreeQueue(entry->produceQ, entry->qp.produceSize);
+		VMCIHost_FreeQueue(entry->consumeQ, entry->qp.consumeSize);
+		kfree(entry);
+
+		vmci_ctx_qp_destroy(context, handle);
+	} else {
+		ASSERT(peerId != VMCI_INVALID_ID);
+		qp_notify_peer(false, handle, contextId, peerId);
+		if (contextId == VMCI_HOST_CONTEXT_ID
+		    && QPBROKERSTATE_HAS_MEM(entry)) {
+			entry->state = VMCIQPB_SHUTDOWN_MEM;
+		} else {
+			entry->state = VMCIQPB_SHUTDOWN_NO_MEM;
+		}
+
+		if (!isLocal)
+			vmci_ctx_qp_destroy(context, handle);
+
+	}
+	result = VMCI_SUCCESS;
+out:
+	up(&qpBrokerList.mutex);
+	return result;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * vmci_qp_broker_map --
+ *
+ *      Establishes the necessary mappings for a queue pair given a
+ *      reference to the queue pair guest memory. This is usually
+ *      called when a guest is unquiesced and the VMX is allowed to
+ *      map guest memory once again.
+ *
+ * Results:
+ *      VMCI_SUCCESS on success, appropriate error code otherwise.
+ *
+ * Side effects:
+ *      Memory may be allocated, and pages may be pinned.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+int vmci_qp_broker_map(struct vmci_handle handle,	// IN
+		       struct vmci_ctx *context,	// IN
+		       uint64_t guestMem)	// IN
+{
+	struct qp_broker_entry *entry;
+	const uint32_t contextId = vmci_ctx_get_id(context);
+	bool isLocal = false;
+	int result;
+
+	if (VMCI_HANDLE_INVALID(handle) || !context
+	    || contextId == VMCI_INVALID_ID)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	down(&qpBrokerList.mutex);
+
+	if (!vmci_ctx_qp_exists(context, handle)) {
+		pr_devel("Context (ID=0x%x) not attached to queue pair "
+			 "(handle=0x%x:0x%x).", contextId, handle.context,
+			 handle.resource);
+		result = VMCI_ERROR_NOT_FOUND;
+		goto out;
+	}
+
+	entry = (struct qp_broker_entry *)
+		qp_list_find(&qpBrokerList, handle);
+	if (!entry) {
+		pr_devel("Context (ID=0x%x) reports being attached to "
+			 "queue pair (handle=0x%x:0x%x) that isn't present "
+			 "in broker.", contextId, handle.context,
+			 handle.resource);
+		result = VMCI_ERROR_NOT_FOUND;
+		goto out;
+	}
+
+	if (contextId != entry->createId && contextId != entry->attachId) {
+		result = VMCI_ERROR_QUEUEPAIR_NOTATTACHED;
+		goto out;
+	}
+
+	isLocal = entry->qp.flags & VMCI_QPFLAG_LOCAL;
+	result = VMCI_SUCCESS;
+
+	if (contextId != VMCI_HOST_CONTEXT_ID) {
+		QueuePairPageStore pageStore;
+
+		ASSERT(entry->state == VMCIQPB_CREATED_NO_MEM ||
+		       entry->state == VMCIQPB_SHUTDOWN_NO_MEM ||
+		       entry->state == VMCIQPB_ATTACHED_NO_MEM);
+		ASSERT(!isLocal);
+
+		pageStore.pages = guestMem;
+		pageStore.len = QPE_NUM_PAGES(entry->qp);
+
+		VMCI_AcquireQueueMutex(entry->produceQ);
+		qp_reset_saved_headers(entry);
+		result =
+			VMCIHost_RegisterUserMemory(&pageStore,
+						    entry->produceQ,
+						    entry->consumeQ);
+		VMCI_ReleaseQueueMutex(entry->produceQ);
+		if (result == VMCI_SUCCESS) {
+			/* Move state from *_NO_MEM to *_MEM */
+
+			entry->state++;
+
+			ASSERT(entry->state == VMCIQPB_CREATED_MEM ||
+			       entry->state == VMCIQPB_SHUTDOWN_MEM ||
+			       entry->state == VMCIQPB_ATTACHED_MEM);
+
+			if (entry->wakeupCB)
+				entry->wakeupCB(entry->clientData);
+		}
+	}
+
+out:
+	up(&qpBrokerList.mutex);
+	return result;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * qp_save_headers --
+ *
+ *      Saves a snapshot of the queue headers for the given QP broker
+ *      entry. Should be used when guest memory is unmapped.
+ *
+ * Results:
+ *      VMCI_SUCCESS on success, appropriate error code if guest memory
+ *      can't be accessed..
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static int qp_save_headers(struct qp_broker_entry *entry)	// IN
+{
+	int result;
+
+	if (entry->produceQ->savedHeader != NULL &&
+	    entry->consumeQ->savedHeader != NULL) {
+		/*
+		 *  If the headers have already been saved, we don't need to do
+		 *  it again, and we don't want to map in the headers
+		 *  unnecessarily.
+		 */
+
+		return VMCI_SUCCESS;
+	}
+
+	if (NULL == entry->produceQ->qHeader
+	    || NULL == entry->consumeQ->qHeader) {
+		result = VMCIHost_MapQueues(entry->produceQ, entry->consumeQ);
+		if (result < VMCI_SUCCESS)
+			return result;
+	}
+
+	memcpy(&entry->savedProduceQ, entry->produceQ->qHeader,
+	       sizeof entry->savedProduceQ);
+	entry->produceQ->savedHeader = &entry->savedProduceQ;
+	memcpy(&entry->savedConsumeQ, entry->consumeQ->qHeader,
+	       sizeof entry->savedConsumeQ);
+	entry->consumeQ->savedHeader = &entry->savedConsumeQ;
+
+	return VMCI_SUCCESS;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * vmci_qp_broker_unmap --
+ *
+ *      Removes all references to the guest memory of a given queue pair, and
+ *      will move the queue pair from state *_MEM to *_NO_MEM. It is usually
+ *      called when a VM is being quiesced where access to guest memory should
+ *      avoided.
+ *
+ * Results:
+ *      VMCI_SUCCESS on success, appropriate error code otherwise.
+ *
+ * Side effects:
+ *      Memory may be freed, and pages may be unpinned.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+int vmci_qp_broker_unmap(struct vmci_handle handle,	// IN
+			 struct vmci_ctx *context,	// IN
+			 uint32_t gid)	// IN
+{
+	struct qp_broker_entry *entry;
+	const uint32_t contextId = vmci_ctx_get_id(context);
+	bool isLocal = false;
+	int result;
+
+	if (VMCI_HANDLE_INVALID(handle) || !context
+	    || contextId == VMCI_INVALID_ID)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	down(&qpBrokerList.mutex);
+
+	if (!vmci_ctx_qp_exists(context, handle)) {
+		pr_devel("Context (ID=0x%x) not attached to queue pair "
+			 "(handle=0x%x:0x%x).", contextId,
+			 handle.context, handle.resource);
+		result = VMCI_ERROR_NOT_FOUND;
+		goto out;
+	}
+
+	entry = (struct qp_broker_entry *)
+		qp_list_find(&qpBrokerList, handle);
+	if (!entry) {
+		pr_devel("Context (ID=0x%x) reports being attached to "
+			 "queue pair (handle=0x%x:0x%x) that isn't present "
+			 "in broker.", contextId, handle.context,
+			 handle.resource);
+		result = VMCI_ERROR_NOT_FOUND;
+		goto out;
+	}
+
+	if (contextId != entry->createId && contextId != entry->attachId) {
+		result = VMCI_ERROR_QUEUEPAIR_NOTATTACHED;
+		goto out;
+	}
+
+	isLocal = entry->qp.flags & VMCI_QPFLAG_LOCAL;
+
+	if (contextId != VMCI_HOST_CONTEXT_ID) {
+		ASSERT(entry->state != VMCIQPB_CREATED_NO_MEM &&
+		       entry->state != VMCIQPB_SHUTDOWN_NO_MEM &&
+		       entry->state != VMCIQPB_ATTACHED_NO_MEM);
+		ASSERT(!isLocal);
+
+		VMCI_AcquireQueueMutex(entry->produceQ);
+		result = qp_save_headers(entry);
+		if (result < VMCI_SUCCESS)
+			pr_warn("Failed to save queue headers for "
+				"queue pair (handle=0x%x:0x%x,result=%d).",
+				handle.context, handle.resource, result);
+
+		VMCIHost_UnmapQueues(gid, entry->produceQ, entry->consumeQ);
+
+		/*
+		 * On hosted, when we unmap queue pairs, the VMX will also
+		 * unmap the guest memory, so we invalidate the previously
+		 * registered memory. If the queue pair is mapped again at a
+		 * later point in time, we will need to reregister the user
+		 * memory with a possibly new user VA.
+		 */
+
+		VMCIHost_UnregisterUserMemory(entry->produceQ, entry->consumeQ);
+
+		/*
+		 * Move state from *_MEM to *_NO_MEM.
+		 */
+
+		entry->state--;
+
+		VMCI_ReleaseQueueMutex(entry->produceQ);
+	}
+
+	result = VMCI_SUCCESS;
+out:
+	up(&qpBrokerList.mutex);
+	return result;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * vmci_qp_guest_endpoints_init --
+ *
+ *      Initalizes data structure state keeping track of queue pair
+ *      guest endpoints.
+ *
+ * Results:
+ *      VMCI_SUCCESS on success and appropriate failure code otherwise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+int __devinit vmci_qp_guest_endpoints_init(void)
+{
+	return qp_list_init(&qpGuestEndpoints);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * vmci_qp_guest_endpoints_exit --
+ *
+ *      Destroys all guest queue pair endpoints. If active guest queue
+ *      pairs still exist, hypercalls to attempt detach from these
+ *      queue pairs will be made. Any failure to detach is silently
+ *      ignored.
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+void vmci_qp_guest_endpoints_exit(void)
+{
+	struct qp_guest_endpoint *entry;
+
+	down(&qpGuestEndpoints.mutex);
+
+	while ((entry = (struct qp_guest_endpoint *)
+		qp_list_get_head(&qpGuestEndpoints))) {
+
+		/* Don't make a hypercall for local QueuePairs. */
+		if (!(entry->qp.flags & VMCI_QPFLAG_LOCAL))
+			qp_detatch_hypercall(entry->qp.handle);
+
+		/* We cannot fail the exit, so let's reset refCount. */
+		entry->qp.refCount = 0;
+		qp_list_remove_entry(&qpGuestEndpoints, &entry->qp);
+		qp_guest_endpoint_destroy(entry);
+	}
+
+	up(&qpGuestEndpoints.mutex);
+	INIT_LIST_HEAD(&(qpGuestEndpoints.head));
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * qp_lock --
+ *
+ *      Helper routine that will lock the queue pair before subsequent
+ *      operations.
+ *
+ *      Note: Non-blocking on the host side is currently only implemented in ESX.
+ *            Since non-blocking isn't yet implemented on the host personality we
+ *	      have no reason to acquire a spin lock.  So to avoid the use of an
+ *            unnecessary lock only acquire the mutex if we can block.
+ *      Note: It is assumed that QPFLAG_PINNED implies QPFLAG_NONBLOCK.  Therefore
+ *            we can use the same locking function for access to both the queue
+ *            and the queue headers as it is the same logic.  Assert this behvior.
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      May block.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static void qp_lock(const struct vmci_qp *qpair)	// IN
+{
+	ASSERT(!QP_PINNED(qpair->flags) ||
+	       (QP_PINNED(qpair->flags) && !CAN_BLOCK(qpair->flags)));
+
+	if (CAN_BLOCK(qpair->flags))
+		VMCI_AcquireQueueMutex(qpair->produceQ);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * qp_unlock --
+ *
+ *      Helper routine that unlocks the queue pair after calling
+ *      qp_lock.  Respects non-blocking and pinning flags.
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static void qp_unlock(const struct vmci_qp *qpair)	// IN
+{
+	if (CAN_BLOCK(qpair->flags))
+		VMCI_ReleaseQueueMutex(qpair->produceQ);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * qp_map_queue_headers --
+ *
+ *      The queue headers may not be mapped at all times. If a queue is
+ *      currently not mapped, it will be attempted to do so.
+ *
+ * Results:
+ *      VMCI_SUCCESS if queues were validated, appropriate error code otherwise.
+ *
+ * Side effects:
+ *      May attempt to map in guest memory.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static int qp_map_queue_headers(struct vmci_queue *produceQ,	// IN
+				struct vmci_queue *consumeQ,	// IN
+				bool canBlock)
+{
+	int result;
+
+	if (NULL == produceQ->qHeader || NULL == consumeQ->qHeader) {
+		if (canBlock)
+			result = VMCIHost_MapQueues(produceQ, consumeQ);
+		else
+			result = VMCI_ERROR_QUEUEPAIR_NOT_READY;
+
+		if (result < VMCI_SUCCESS) {
+			if (produceQ->savedHeader && consumeQ->savedHeader) {
+				return VMCI_ERROR_QUEUEPAIR_NOT_READY;
+			} else {
+				return VMCI_ERROR_QUEUEPAIR_NOTATTACHED;
+			}
+		}
+	}
+
+	return VMCI_SUCCESS;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * qp_get_queue_headers --
+ *
+ *      Helper routine that will retrieve the produce and consume
+ *      headers of a given queue pair. If the guest memory of the
+ *      queue pair is currently not available, the saved queue headers
+ *      will be returned, if these are available.
+ *
+ * Results:
+ *      VMCI_SUCCESS if either current or saved queue headers are found.
+ *      Appropriate error code otherwise.
+ *
+ * Side effects:
+ *      May block.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static int qp_get_queue_headers(const struct vmci_qp *qpair,	// IN
+				struct vmci_queue_header **produceQHeader,	// OUT
+				struct vmci_queue_header **consumeQHeader)	// OUT
+{
+	int result;
+
+	result = qp_map_queue_headers(qpair->produceQ, qpair->consumeQ,
+				      CAN_BLOCK(qpair->flags));
+	if (result == VMCI_SUCCESS) {
+		*produceQHeader = qpair->produceQ->qHeader;
+		*consumeQHeader = qpair->consumeQ->qHeader;
+	} else if (qpair->produceQ->savedHeader && qpair->consumeQ->savedHeader) {
+		ASSERT(!qpair->guestEndpoint);
+		*produceQHeader = qpair->produceQ->savedHeader;
+		*consumeQHeader = qpair->consumeQ->savedHeader;
+		result = VMCI_SUCCESS;
+	}
+
+	return result;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * qp_wakeup_cb --
+ *
+ *      Callback from VMCI queue pair broker indicating that a queue
+ *      pair that was previously not ready, now either is ready or
+ *      gone forever.
+ *
+ * Results:
+ *      VMCI_SUCCESS always.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static int qp_wakeup_cb(void *clientData)
+{
+	struct vmci_qp *qpair = (struct vmci_qp *)clientData;
+	ASSERT(qpair);
+
+	qp_lock(qpair);
+	while (qpair->blocked > 0) {
+		qpair->blocked--;
+		wake_up(&qpair->event);
+	}
+	qp_unlock(qpair);
+
+	return VMCI_SUCCESS;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * qp_release_mutex_cb --
+ *
+ *      Callback from VMCI_WaitOnEvent releasing the queue pair mutex
+ *      protecting the queue pair header state.
+ *
+ * Results:
+ *      0 always.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static int qp_release_mutex_cb(void *clientData)
+{
+	struct vmci_qp *qpair = (struct vmci_qp *)clientData;
+	ASSERT(qpair);
+	qp_unlock(qpair);
+	return 0;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * qp_wait_for_ready_queue --
+ *
+ *      Makes the calling thread wait for the queue pair to become
+ *      ready for host side access.
+ *
+ * Results:
+ *     true when thread is woken up after queue pair state change.
+ *     false otherwise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static bool qp_wait_for_ready_queue(struct vmci_qp *qpair)
+{
+	if (unlikely(qpair->guestEndpoint))
+		ASSERT(false);
+
+	if (qpair->flags & VMCI_QPFLAG_NONBLOCK)
+		return false;
+
+	qpair->blocked++;
+	vmci_drv_wait_on_event_intr(&qpair->event, qp_release_mutex_cb,
+				    qpair);
+	qp_lock(qpair);
+	return true;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPair_Alloc --
+ *
+ *      This is the client interface for allocating the memory for a
+ *      VMCIQPair structure and then attaching to the underlying
+ *      queue.  If an error occurs allocating the memory for the
+ *      VMCIQPair structure, no attempt is made to attach.  If an
+ *      error occurs attaching, then the VMCIQPair structure
+ *      is freed.
+ *
+ * Results:
+ *      An err, if < 0.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+int VMCIQPair_Alloc(struct vmci_qp **qpair,	// OUT
+		    struct vmci_handle *handle,	// OUT
+		    uint64_t produceQSize,	// IN
+		    uint64_t consumeQSize,	// IN
+		    uint32_t peer,	// IN
+		    uint32_t flags,	// IN
+		    uint32_t privFlags)	// IN
+{
+	struct vmci_qp *myQPair;
+	int retval;
+	struct vmci_handle src = VMCI_INVALID_HANDLE;
+	struct vmci_handle dst = vmci_make_handle(peer, VMCI_INVALID_ID);
+	enum vmci_route route;
+	VMCIEventReleaseCB wakeupCB;
+	void *clientData;
+
+	/*
+	 * Restrict the size of a queuepair.  The device already enforces a limit
+	 * on the total amount of memory that can be allocated to queuepairs for a
+	 * guest.  However, we try to allocate this memory before we make the
+	 * queuepair allocation hypercall.  On Linux, we allocate each page separately,
+	 * which means rather than fail, the guest will thrash while it tries to allocate,
+	 * and will become increasingly unresponsive to the point where it appears to be hung.
+	 * So we place a limit on the size of an individual queuepair here, and
+	 * leave the device to enforce the restriction on total queuepair memory.
+	 * (Note that this doesn't prevent all cases; a user with only this much
+	 * physical memory could still get into trouble.)  The error used by the
+	 * device is NO_RESOURCES, so use that here too.
+	 */
+
+	if (produceQSize <= 0 || consumeQSize <= 0 ||
+	    produceQSize + consumeQSize > VMCI_MAX_GUEST_QP_MEMORY)
+		return VMCI_ERROR_NO_RESOURCES;
+
+	retval = vmci_route(&src, &dst, false, &route);
+	if (retval < VMCI_SUCCESS) {
+		if (vmci_guest_code_active()) {
+			route = VMCI_ROUTE_AS_GUEST;
+		} else {
+			route = VMCI_ROUTE_AS_HOST;
+		}
+	}
+
+	/* If NONBLOCK or PINNED is set, we better be the guest personality. */
+	if ((!CAN_BLOCK(flags) || QP_PINNED(flags)) &&
+	    VMCI_ROUTE_AS_GUEST != route) {
+		pr_devel("Not guest personality w/ NONBLOCK OR PINNED set");
+		return VMCI_ERROR_INVALID_ARGS;
+	}
+
+	/*
+	 * Limit the size of pinned QPs and check sanity.
+	 *
+	 * Pinned pages implies non-blocking mode.  Mutexes aren't acquired
+	 * when the NONBLOCK flag is set in qpair code; and also should not be
+	 * acquired when the PINNED flagged is set.  Since pinning pages
+	 * implies we want speed, it makes no sense not to have NONBLOCK
+	 * set if PINNED is set.  Hence enforce this implication.
+	 */
+	if (QP_PINNED(flags)) {
+		if (CAN_BLOCK(flags)) {
+			pr_err
+				("Attempted to enable pinning w/o non-blocking");
+			return VMCI_ERROR_INVALID_ARGS;
+		}
+
+		if (produceQSize + consumeQSize > VMCI_MAX_PINNED_QP_MEMORY)
+			return VMCI_ERROR_NO_RESOURCES;
+	}
+
+	myQPair = kzalloc(sizeof *myQPair, GFP_KERNEL);
+	if (!myQPair)
+		return VMCI_ERROR_NO_MEM;
+
+	myQPair->produceQSize = produceQSize;
+	myQPair->consumeQSize = consumeQSize;
+	myQPair->peer = peer;
+	myQPair->flags = flags;
+	myQPair->privFlags = privFlags;
+
+	wakeupCB = clientData = NULL;
+	if (VMCI_ROUTE_AS_HOST == route) {
+		myQPair->guestEndpoint = false;
+		if (!(flags & VMCI_QPFLAG_LOCAL)) {
+			myQPair->blocked = 0;
+			init_waitqueue_head(&myQPair->event);
+			wakeupCB = qp_wakeup_cb;
+			clientData = (void *)myQPair;
+		}
+	} else {
+		myQPair->guestEndpoint = true;
+	}
+
+	retval = vmci_qp_alloc(handle,
+			       &myQPair->produceQ,
+			       myQPair->produceQSize,
+			       &myQPair->consumeQ,
+			       myQPair->consumeQSize,
+			       myQPair->peer,
+			       myQPair->flags,
+			       myQPair->privFlags,
+			       myQPair->guestEndpoint,
+			       wakeupCB, clientData);
+
+	if (retval < VMCI_SUCCESS) {
+		kfree(myQPair);
+		return retval;
+	}
+
+	*qpair = myQPair;
+	myQPair->handle = *handle;
+
+	return retval;
+}
+
+EXPORT_SYMBOL(VMCIQPair_Alloc);
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPair_Detach --
+ *
+ *      This is the client interface for detaching from a VMCIQPair.
+ *      Note that this routine will free the memory allocated for the
+ *      VMCIQPair structure, too.
+ *
+ * Results:
+ *      An error, if < 0.
+ *
+ * Side effects:
+ *      Will clear the caller's pointer to the VMCIQPair structure.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+int VMCIQPair_Detach(struct vmci_qp **qpair)	// IN/OUT
+{
+	int result;
+	struct vmci_qp *oldQPair;
+
+	if (!qpair || !(*qpair))
+		return VMCI_ERROR_INVALID_ARGS;
+
+	oldQPair = *qpair;
+	result = qp_detatch(oldQPair->handle, oldQPair->guestEndpoint);
+
+	/*
+	 * The guest can fail to detach for a number of reasons, and if it does so,
+	 * it will cleanup the entry (if there is one).  The host can fail too, but
+	 * it won't cleanup the entry immediately, it will do that later when the
+	 * context is freed.  Either way, we need to release the qpair struct here;
+	 * there isn't much the caller can do, and we don't want to leak.
+	 */
+
+	memset(oldQPair, 0, sizeof *oldQPair);
+	oldQPair->handle = VMCI_INVALID_HANDLE;
+	oldQPair->peer = VMCI_INVALID_ID;
+	kfree(oldQPair);
+	*qpair = NULL;
+
+	return result;
+}
+
+EXPORT_SYMBOL(VMCIQPair_Detach);
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPair_GetProduceIndexes --
+ *
+ *      This is the client interface for getting the current indexes of the
+ *      QPair from the point of the view of the caller as the producer.
+ *
+ * Results:
+ *      err, if < 0
+ *      Success otherwise.
+ *
+ * Side effects:
+ *      Windows blocking call.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+int VMCIQPair_GetProduceIndexes(const struct vmci_qp *qpair,	// IN
+				uint64_t * producerTail,	// OUT
+				uint64_t * consumerHead)	// OUT
+{
+	struct vmci_queue_header *produceQHeader;
+	struct vmci_queue_header *consumeQHeader;
+	int result;
+
+	if (!qpair)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	qp_lock(qpair);
+	result = qp_get_queue_headers(qpair, &produceQHeader, &consumeQHeader);
+	if (result == VMCI_SUCCESS)
+		vmci_q_header_get_pointers(produceQHeader, consumeQHeader,
+					   producerTail, consumerHead);
+	qp_unlock(qpair);
+
+	if (result == VMCI_SUCCESS &&
+	    ((producerTail && *producerTail >= qpair->produceQSize) ||
+	     (consumerHead && *consumerHead >= qpair->produceQSize)))
+		return VMCI_ERROR_INVALID_SIZE;
+
+	return result;
+}
+
+EXPORT_SYMBOL(VMCIQPair_GetProduceIndexes);
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPair_GetConsumeIndexes --
+ *
+ *      This is the client interface for getting the current indexes of the
+ *      QPair from the point of the view of the caller as the consumer.
+ *
+ * Results:
+ *      err, if < 0
+ *      Success otherwise.
+ *
+ * Side effects:
+ *      Windows blocking call.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+int VMCIQPair_GetConsumeIndexes(const struct vmci_qp *qpair,	// IN
+				uint64_t * consumerTail,	// OUT
+				uint64_t * producerHead)	// OUT
+{
+	struct vmci_queue_header *produceQHeader;
+	struct vmci_queue_header *consumeQHeader;
+	int result;
+
+	if (!qpair)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	qp_lock(qpair);
+	result = qp_get_queue_headers(qpair, &produceQHeader, &consumeQHeader);
+	if (result == VMCI_SUCCESS)
+		vmci_q_header_get_pointers(consumeQHeader, produceQHeader,
+					   consumerTail, producerHead);
+	qp_unlock(qpair);
+
+	if (result == VMCI_SUCCESS &&
+	    ((consumerTail && *consumerTail >= qpair->consumeQSize) ||
+	     (producerHead && *producerHead >= qpair->consumeQSize)))
+		return VMCI_ERROR_INVALID_SIZE;
+
+	return result;
+}
+
+EXPORT_SYMBOL(VMCIQPair_GetConsumeIndexes);
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPair_ProduceFreeSpace --
+ *
+ *      This is the client interface for getting the amount of free
+ *      space in the QPair from the point of the view of the caller as
+ *      the producer which is the common case.
+ *
+ * Results:
+ *      Err, if < 0.
+ *      Full queue if = 0.
+ *      Number of available bytes into which data can be enqueued if > 0.
+ *
+ * Side effects:
+ *      Windows blocking call.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+int64_t VMCIQPair_ProduceFreeSpace(const struct vmci_qp * qpair)	// IN
+{
+	struct vmci_queue_header *produceQHeader;
+	struct vmci_queue_header *consumeQHeader;
+	int64_t result;
+
+	if (!qpair)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	qp_lock(qpair);
+	result = qp_get_queue_headers(qpair, &produceQHeader, &consumeQHeader);
+	if (result == VMCI_SUCCESS) {
+		result = vmci_q_header_free_space(produceQHeader,
+						  consumeQHeader,
+						  qpair->produceQSize);
+	} else {
+		result = 0;
+	}
+	qp_unlock(qpair);
+
+	return result;
+}
+
+EXPORT_SYMBOL(VMCIQPair_ProduceFreeSpace);
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPair_ConsumeFreeSpace --
+ *
+ *      This is the client interface for getting the amount of free
+ *      space in the QPair from the point of the view of the caller as
+ *      the consumer which is not the common case (see
+ *      VMCIQPair_ProduceFreeSpace(), above).
+ *
+ * Results:
+ *      Err, if < 0.
+ *      Full queue if = 0.
+ *      Number of available bytes into which data can be enqueued if > 0.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+int64_t VMCIQPair_ConsumeFreeSpace(const struct vmci_qp * qpair)	// IN
+{
+	struct vmci_queue_header *produceQHeader;
+	struct vmci_queue_header *consumeQHeader;
+	int64_t result;
+
+	if (!qpair)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	qp_lock(qpair);
+	result = qp_get_queue_headers(qpair, &produceQHeader, &consumeQHeader);
+	if (result == VMCI_SUCCESS) {
+		result = vmci_q_header_free_space(consumeQHeader,
+						  produceQHeader,
+						  qpair->consumeQSize);
+	} else {
+		result = 0;
+	}
+	qp_unlock(qpair);
+
+	return result;
+}
+
+EXPORT_SYMBOL(VMCIQPair_ConsumeFreeSpace);
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPair_ProduceBufReady --
+ *
+ *      This is the client interface for getting the amount of
+ *      enqueued data in the QPair from the point of the view of the
+ *      caller as the producer which is not the common case (see
+ *      VMCIQPair_ConsumeBufReady(), above).
+ *
+ * Results:
+ *      Err, if < 0.
+ *      Empty queue if = 0.
+ *      Number of bytes ready to be dequeued if > 0.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+int64_t VMCIQPair_ProduceBufReady(const struct vmci_qp * qpair)	// IN
+{
+	struct vmci_queue_header *produceQHeader;
+	struct vmci_queue_header *consumeQHeader;
+	int64_t result;
+
+	if (!qpair)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	qp_lock(qpair);
+	result = qp_get_queue_headers(qpair, &produceQHeader, &consumeQHeader);
+	if (result == VMCI_SUCCESS) {
+		result = vmci_q_header_buf_ready(produceQHeader,
+						 consumeQHeader,
+						 qpair->produceQSize);
+	} else {
+		result = 0;
+	}
+	qp_unlock(qpair);
+
+	return result;
+}
+
+EXPORT_SYMBOL(VMCIQPair_ProduceBufReady);
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPair_ConsumeBufReady --
+ *
+ *      This is the client interface for getting the amount of
+ *      enqueued data in the QPair from the point of the view of the
+ *      caller as the consumer which is the normal case.
+ *
+ * Results:
+ *      Err, if < 0.
+ *      Empty queue if = 0.
+ *      Number of bytes ready to be dequeued if > 0.
+ *
+ * Side effects:
+ *      Windows blocking call.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+int64_t VMCIQPair_ConsumeBufReady(const struct vmci_qp * qpair)	// IN
+{
+	struct vmci_queue_header *produceQHeader;
+	struct vmci_queue_header *consumeQHeader;
+	int64_t result;
+
+	if (!qpair)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	qp_lock(qpair);
+	result = qp_get_queue_headers(qpair, &produceQHeader, &consumeQHeader);
+	if (result == VMCI_SUCCESS) {
+		result = vmci_q_header_buf_ready(consumeQHeader,
+						 produceQHeader,
+						 qpair->consumeQSize);
+	} else {
+		result = 0;
+	}
+	qp_unlock(qpair);
+
+	return result;
+}
+
+EXPORT_SYMBOL(VMCIQPair_ConsumeBufReady);
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * qp_enqueue_locked --
+ *
+ *      Enqueues a given buffer to the produce queue using the provided
+ *      function. As many bytes as possible (space available in the queue)
+ *      are enqueued.
+ *
+ *      Assumes the queue->mutex has been acquired.
+ *
+ * Results:
+ *      VMCI_ERROR_QUEUEPAIR_NOSPACE if no space was available to enqueue data.
+ *      VMCI_ERROR_INVALID_SIZE, if any queue pointer is outside the queue
+ *      (as defined by the queue size).
+ *      VMCI_ERROR_INVALID_ARGS, if an error occured when accessing the buffer.
+ *      VMCI_ERROR_QUEUEPAIR_NOTATTACHED, if the queue pair pages aren't
+ *      available.
+ *      Otherwise, the number of bytes written to the queue is returned.
+ *
+ * Side effects:
+ *      Updates the tail pointer of the produce queue.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static ssize_t qp_enqueue_locked(struct vmci_queue *produceQ,	// IN
+				 struct vmci_queue *consumeQ,	// IN
+				 const uint64_t produceQSize,	// IN
+				 const void *buf,	// IN
+				 size_t bufSize,	// IN
+				 int bufType,	// IN
+				 VMCIMemcpyToQueueFunc memcpyToQueue,	// IN
+				 bool canBlock)
+{
+	int64_t freeSpace;
+	uint64_t tail;
+	size_t written;
+	ssize_t result;
+
+	result = qp_map_queue_headers(produceQ, consumeQ, canBlock);
+	if (unlikely(result != VMCI_SUCCESS))
+		return result;
+
+	freeSpace = vmci_q_header_free_space(produceQ->qHeader,
+					     consumeQ->qHeader, produceQSize);
+	if (freeSpace == 0)
+		return VMCI_ERROR_QUEUEPAIR_NOSPACE;
+
+	if (freeSpace < VMCI_SUCCESS)
+		return (ssize_t) freeSpace;
+
+	written = (size_t) (freeSpace > bufSize ? bufSize : freeSpace);
+	tail = vmci_q_header_producer_tail(produceQ->qHeader);
+	if (likely(tail + written < produceQSize)) {
+		result = memcpyToQueue(produceQ, tail, buf, 0, written, bufType);
+	} else {
+		/* Tail pointer wraps around. */
+
+		const size_t tmp = (size_t) (produceQSize - tail);
+
+		result = memcpyToQueue(produceQ, tail, buf, 0, tmp, bufType);
+		if (result >= VMCI_SUCCESS)
+			result = memcpyToQueue(produceQ, 0, buf, tmp,
+					       written - tmp, bufType);
+	}
+
+	if (result < VMCI_SUCCESS)
+		return result;
+
+	vmci_q_header_add_producer_tail(produceQ->qHeader, written,
+					produceQSize);
+	return written;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * qp_dequeue_locked --
+ *
+ *      Dequeues data (if available) from the given consume queue. Writes data
+ *      to the user provided buffer using the provided function.
+ *
+ *      Assumes the queue->mutex has been acquired.
+ *
+ * Results:
+ *      VMCI_ERROR_QUEUEPAIR_NODATA if no data was available to dequeue.
+ *      VMCI_ERROR_INVALID_SIZE, if any queue pointer is outside the queue
+ *      (as defined by the queue size).
+ *      VMCI_ERROR_INVALID_ARGS, if an error occured when accessing the buffer.
+ *      Otherwise the number of bytes dequeued is returned.
+ *
+ * Side effects:
+ *      Updates the head pointer of the consume queue.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static ssize_t qp_dequeue_locked(struct vmci_queue *produceQ,	// IN
+				 struct vmci_queue *consumeQ,	// IN
+				 const uint64_t consumeQSize,	// IN
+				 void *buf,	// IN
+				 size_t bufSize,	// IN
+				 int bufType,	// IN
+				 VMCIMemcpyFromQueueFunc memcpyFromQueue,	// IN
+				 bool updateConsumer,	// IN
+				 bool canBlock)
+{
+	int64_t bufReady;
+	uint64_t head;
+	size_t read;
+	ssize_t result;
+
+	result = qp_map_queue_headers(produceQ, consumeQ, canBlock);
+	if (unlikely(result != VMCI_SUCCESS))
+		return result;
+
+	bufReady = vmci_q_header_buf_ready(consumeQ->qHeader,
+					   produceQ->qHeader, consumeQSize);
+	if (bufReady == 0)
+		return VMCI_ERROR_QUEUEPAIR_NODATA;
+
+	if (bufReady < VMCI_SUCCESS)
+		return (ssize_t) bufReady;
+
+	read = (size_t) (bufReady > bufSize ? bufSize : bufReady);
+	head = vmci_q_header_consumer_head(produceQ->qHeader);
+	if (likely(head + read < consumeQSize)) {
+		result = memcpyFromQueue(buf, 0, consumeQ, head, read, bufType);
+	} else {
+		/* Head pointer wraps around. */
+
+		const size_t tmp = (size_t) (consumeQSize - head);
+
+		result = memcpyFromQueue(buf, 0, consumeQ, head, tmp, bufType);
+		if (result >= VMCI_SUCCESS) {
+			result = memcpyFromQueue(buf, tmp, consumeQ, 0,
+						 read - tmp, bufType);
+		}
+	}
+
+	if (result < VMCI_SUCCESS)
+		return result;
+
+	if (updateConsumer)
+		vmci_q_header_add_consumer_head(produceQ->qHeader,
+						read, consumeQSize);
+
+	return read;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPair_Enqueue --
+ *
+ *      This is the client interface for enqueueing data into the queue.
+ *
+ * Results:
+ *      Err, if < 0.
+ *      Number of bytes enqueued if >= 0.
+ *
+ * Side effects:
+ *      Windows blocking call.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+ssize_t VMCIQPair_Enqueue(struct vmci_qp * qpair,	// IN
+			  const void *buf,	// IN
+			  size_t bufSize,	// IN
+			  int bufType)	// IN
+{
+	ssize_t result;
+
+	if (!qpair || !buf)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	qp_lock(qpair);
+
+	do {
+		result = qp_enqueue_locked(qpair->produceQ,
+					   qpair->consumeQ,
+					   qpair->produceQSize,
+					   buf, bufSize, bufType,
+					   qp_memcpy_to_queue,
+					   CAN_BLOCK(qpair->flags));
+
+		if (result == VMCI_ERROR_QUEUEPAIR_NOT_READY &&
+		    !qp_wait_for_ready_queue(qpair))
+			result = VMCI_ERROR_WOULD_BLOCK;
+
+	} while (result == VMCI_ERROR_QUEUEPAIR_NOT_READY);
+
+	qp_unlock(qpair);
+
+	return result;
+}
+
+EXPORT_SYMBOL(VMCIQPair_Enqueue);
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPair_Dequeue --
+ *
+ *      This is the client interface for dequeueing data from the queue.
+ *
+ * Results:
+ *      Err, if < 0.
+ *      Number of bytes dequeued if >= 0.
+ *
+ * Side effects:
+ *      Windows blocking call.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+ssize_t VMCIQPair_Dequeue(struct vmci_qp * qpair,	// IN
+			  void *buf,	// IN
+			  size_t bufSize,	// IN
+			  int bufType)	// IN
+{
+	ssize_t result;
+
+	if (!qpair || !buf)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	qp_lock(qpair);
+
+	do {
+		result = qp_dequeue_locked(qpair->produceQ,
+					   qpair->consumeQ,
+					   qpair->consumeQSize,
+					   buf, bufSize, bufType,
+					   qp_memcpy_from_queue, true,
+					   CAN_BLOCK(qpair->flags));
+
+		if (result == VMCI_ERROR_QUEUEPAIR_NOT_READY &&
+		    !qp_wait_for_ready_queue(qpair))
+			result = VMCI_ERROR_WOULD_BLOCK;
+
+	} while (result == VMCI_ERROR_QUEUEPAIR_NOT_READY);
+
+	qp_unlock(qpair);
+
+	return result;
+}
+
+EXPORT_SYMBOL(VMCIQPair_Dequeue);
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPair_Peek --
+ *
+ *      This is the client interface for peeking into a queue.  (I.e.,
+ *      copy data from the queue without updating the head pointer.)
+ *
+ * Results:
+ *      Err, if < 0.
+ *      Number of bytes peeked, if >= 0.
+ *
+ * Side effects:
+ *      Windows blocking call.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+ssize_t VMCIQPair_Peek(struct vmci_qp * qpair,	// IN
+		       void *buf,	// IN
+		       size_t bufSize,	// IN
+		       int bufType)	// IN
+{
+	ssize_t result;
+
+	if (!qpair || !buf)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	qp_lock(qpair);
+
+	do {
+		result = qp_dequeue_locked(qpair->produceQ,
+					   qpair->consumeQ,
+					   qpair->consumeQSize,
+					   buf, bufSize, bufType,
+					   qp_memcpy_from_queue, false,
+					   CAN_BLOCK(qpair->flags));
+
+		if (result == VMCI_ERROR_QUEUEPAIR_NOT_READY &&
+		    !qp_wait_for_ready_queue(qpair))
+			result = VMCI_ERROR_WOULD_BLOCK;
+
+	} while (result == VMCI_ERROR_QUEUEPAIR_NOT_READY);
+
+	qp_unlock(qpair);
+
+	return result;
+}
+
+EXPORT_SYMBOL(VMCIQPair_Peek);
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPair_EnqueueV --
+ *
+ *      This is the client interface for enqueueing data into the queue.
+ *
+ * Results:
+ *      Err, if < 0.
+ *      Number of bytes enqueued if >= 0.
+ *
+ * Side effects:
+ *      Windows blocking call.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+ssize_t VMCIQPair_EnqueueV(struct vmci_qp * qpair,	// IN
+			   void *iov,	// IN
+			   size_t iovSize,	// IN
+			   int bufType)	// IN
+{
+	ssize_t result;
+
+	if (!qpair || !iov)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	qp_lock(qpair);
+
+	do {
+		result = qp_enqueue_locked(qpair->produceQ,
+					   qpair->consumeQ,
+					   qpair->produceQSize,
+					   iov, iovSize, bufType,
+					   qp_memcpy_to_queue_iov,
+					   CAN_BLOCK(qpair->flags));
+
+		if (result == VMCI_ERROR_QUEUEPAIR_NOT_READY &&
+		    !qp_wait_for_ready_queue(qpair))
+			result = VMCI_ERROR_WOULD_BLOCK;
+
+	} while (result == VMCI_ERROR_QUEUEPAIR_NOT_READY);
+
+	qp_unlock(qpair);
+
+	return result;
+}
+
+EXPORT_SYMBOL(VMCIQPair_EnqueueV);
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPair_DequeueV --
+ *
+ *      This is the client interface for dequeueing data from the queue.
+ *
+ * Results:
+ *      Err, if < 0.
+ *      Number of bytes dequeued if >= 0.
+ *
+ * Side effects:
+ *      Windows blocking call.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+ssize_t VMCIQPair_DequeueV(struct vmci_qp * qpair,	// IN
+			   void *iov,	// IN
+			   size_t iovSize,	// IN
+			   int bufType)	// IN
+{
+	ssize_t result;
+
+	qp_lock(qpair);
+
+	if (!qpair || !iov)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	do {
+		result = qp_dequeue_locked(qpair->produceQ,
+					   qpair->consumeQ,
+					   qpair->consumeQSize,
+					   iov, iovSize, bufType,
+					   qp_memcpy_from_queue_iov,
+					   true, CAN_BLOCK(qpair->flags));
+
+		if (result == VMCI_ERROR_QUEUEPAIR_NOT_READY &&
+		    !qp_wait_for_ready_queue(qpair))
+			result = VMCI_ERROR_WOULD_BLOCK;
+
+	} while (result == VMCI_ERROR_QUEUEPAIR_NOT_READY);
+
+	qp_unlock(qpair);
+
+	return result;
+}
+
+EXPORT_SYMBOL(VMCIQPair_DequeueV);
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQPair_PeekV --
+ *
+ *      This is the client interface for peeking into a queue.  (I.e.,
+ *      copy data from the queue without updating the head pointer.)
+ *
+ * Results:
+ *      Err, if < 0.
+ *      Number of bytes peeked, if >= 0.
+ *
+ * Side effects:
+ *      Windows blocking call.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+ssize_t VMCIQPair_PeekV(struct vmci_qp * qpair,	// IN
+			void *iov,	// IN
+			size_t iovSize,	// IN
+			int bufType)	// IN
+{
+	ssize_t result;
+
+	if (!qpair || !iov)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	qp_lock(qpair);
+
+	do {
+		result = qp_dequeue_locked(qpair->produceQ,
+					   qpair->consumeQ,
+					   qpair->consumeQSize,
+					   iov, iovSize, bufType,
+					   qp_memcpy_from_queue_iov,
+					   false, CAN_BLOCK(qpair->flags));
+
+		if (result == VMCI_ERROR_QUEUEPAIR_NOT_READY &&
+		    !qp_wait_for_ready_queue(qpair))
+				result = VMCI_ERROR_WOULD_BLOCK;
+
+	} while (result == VMCI_ERROR_QUEUEPAIR_NOT_READY);
+
+	qp_unlock(qpair);
+	return result;
+}
+
+EXPORT_SYMBOL(VMCIQPair_PeekV);
diff --git a/drivers/misc/vmw_vmci/vmci_queue_pair.h b/drivers/misc/vmw_vmci/vmci_queue_pair.h
new file mode 100644
index 0000000..63f6287
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmci_queue_pair.h
@@ -0,0 +1,258 @@
+/*
+ * VMware VMCI Driver
+ *
+ * Copyright (C) 2012 VMware, Inc. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation version 2 and no later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
+ * or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
+ * for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
+ */
+
+#ifndef _VMCI_QUEUE_PAIR_H_
+#define _VMCI_QUEUE_PAIR_H_
+
+#include <linux/vmw_vmci_defs.h>
+
+#include "vmci_context.h"
+
+/* Callback needed for correctly waiting on events. */
+typedef int (*VMCIEventReleaseCB) (void *clientData);
+
+/* Guest device port I/O. */
+struct PPNSet {
+  uint64_t numProducePages;
+  uint64_t numConsumePages;
+  uint32_t *producePPNs;
+  uint32_t *consumePPNs;
+  bool initialized;
+};
+
+
+/* VMCIQueuePairAllocInfo */
+struct vmci_qp_alloc_info {
+  struct vmci_handle handle;
+  uint32_t peer;
+  uint32_t flags;
+  uint64_t produceSize;
+  uint64_t consumeSize;
+  uint64_t ppnVA;		/* Start VA of queue pair PPNs. */
+  uint64_t numPPNs;
+  int32_t result;
+  uint32_t version;
+};
+
+/* VMCIQueuePairSetVAInfo */
+struct vmci_qp_set_va_info {
+  struct vmci_handle handle;
+  uint64_t va;		/* Start VA of queue pair PPNs. */
+  uint64_t numPPNs;
+  uint32_t version;
+  int32_t result;
+};
+
+/*
+ * For backwards compatibility, here is a version of the
+ * VMCIQueuePairPageFileInfo before host support end-points was added.
+ * Note that the current version of that structure requires VMX to
+ * pass down the VA of the mapped file.  Before host support was added
+ * there was nothing of the sort.  So, when the driver sees the ioctl
+ * with a parameter that is the sizeof
+ * VMCIQueuePairPageFileInfo_NoHostQP then it can infer that the version
+ * of VMX running can't attach to host end points because it doesn't
+ * provide the VA of the mapped files.
+ *
+ * The Linux driver doesn't get an indication of the size of the
+ * structure passed down from user space.  So, to fix a long standing
+ * but unfiled bug, the _pad field has been renamed to version.
+ * Existing versions of VMX always initialize the PageFileInfo
+ * structure so that _pad, er, version is set to 0.
+ *
+ * A version value of 1 indicates that the size of the structure has
+ * been increased to include two UVA's: produceUVA and consumeUVA.
+ * These UVA's are of the mmap()'d queue contents backing files.
+ *
+ * In addition, if when VMX is sending down the
+ * VMCIQueuePairPageFileInfo structure it gets an error then it will
+ * try again with the _NoHostQP version of the file to see if an older
+ * VMCI kernel module is running.
+ */
+
+/* VMCIQueuePairPageFileInfo */
+struct vmci_qp_page_file_info {
+  struct vmci_handle handle;
+  uint64_t producePageFile;	/* User VA. */
+  uint64_t consumePageFile;	/* User VA. */
+  uint64_t producePageFileSize;	/* Size of the file name array. */
+  uint64_t consumePageFileSize;	/* Size of the file name array. */
+  int32_t result;
+  uint32_t version;	/* Was _pad. */
+  uint64_t produceVA;	/* User VA of the mapped file. */
+  uint64_t consumeVA;	/* User VA of the mapped file. */
+};
+
+/* VMCIQueuePairDetachInfo */
+struct vmci_qp_dtch_info {
+  struct vmci_handle handle;
+  int32_t result;
+  uint32_t _pad;
+};
+
+/*
+ * QueuePairPageStore describes how the memory of a given queue pair
+ * is backed. When the queue pair is between the host and a guest, the
+ * page store consists of references to the guest pages. On vmkernel,
+ * this is a list of PPNs, and on hosted, it is a user VA where the
+ * queue pair is mapped into the VMX address space.
+ */
+
+typedef struct QueuePairPageStore {
+  uint64_t pages;		// Reference to pages backing the queue pair.
+  uint32_t len;		// Length of pageList/virtual addres range (in pages).
+} QueuePairPageStore;
+
+/*
+ * struct vmci_queue
+ *
+ * This data type contains the information about a queue.
+ *
+ * There are two queues (hence, queue pairs) per transaction model between a
+ * pair of end points, A & B.  One queue is used by end point A to transmit
+ * commands and responses to B.  The other queue is used by B to transmit
+ * commands and responses.
+ *
+ * struct vmci_queue_kern_if is a per-OS defined Queue structure.  It contains either a
+ * direct pointer to the linear address of the buffer contents or a pointer to
+ * structures which help the OS locate those data pages.  See vmciKernelIf.c
+ * for each platform for its definition.
+ */
+
+struct vmci_queue {
+  struct vmci_queue_header *qHeader;
+  struct vmci_queue_header *savedHeader;
+  struct vmci_queue_kern_if *kernelIf;
+};
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIMemcpy{To,From}QueueFunc() prototypes.  Functions of these
+ * types are passed around to enqueue and dequeue routines.  Note that
+ * often the functions passed are simply wrappers around memcpy
+ * itself.
+ *
+ * Note: In order for the memcpy typedefs to be compatible with the VMKernel,
+ * there's an unused last parameter for the hosted side.  In
+ * ESX, that parameter holds a buffer type.
+ *
+ *-----------------------------------------------------------------------------
+ */
+typedef int VMCIMemcpyToQueueFunc(struct vmci_queue *queue,
+				  uint64_t queueOffset, const void *src,
+				  size_t srcOffset, size_t size, int bufType);
+typedef int VMCIMemcpyFromQueueFunc(void *dest, size_t destOffset,
+				    const struct vmci_queue *queue,
+				    uint64_t queueOffset, size_t size,
+				    int bufType);
+
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ *  VMCI_QP_PAGESTORE_IS_WELLFORMED --
+ *
+ *     Utility function that checks whether the fields of the page
+ *     store contain valid values.
+ *
+ *  Result:
+ *     true if the page store is wellformed. false otherwise.
+ *
+ *  Side effects:
+ *     None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+static inline bool VMCI_QP_PAGESTORE_IS_WELLFORMED(QueuePairPageStore * pageStore)	// IN
+{
+  return pageStore->len >= 2;
+}
+
+
+
+int vmci_qp_broker_init(void);
+void vmci_qp_broker_exit(void);
+int vmci_qp_broker_alloc(struct vmci_handle handle, uint32_t peer,
+			 uint32_t flags, uint32_t privFlags,
+			 uint64_t produceSize, uint64_t consumeSize,
+			 QueuePairPageStore * pageStore,
+			 struct vmci_ctx *context);
+int vmci_qp_broker_set_page_store(struct vmci_handle handle,
+				  uint64_t produceUVA, uint64_t consumeUVA,
+				  struct vmci_ctx *context);
+int vmci_qp_broker_detach(struct vmci_handle handle,
+			  struct vmci_ctx *context);
+
+int vmci_qp_guest_endpoints_init(void);
+void vmci_qp_guest_endpoints_exit(void);
+
+int vmci_qp_alloc(struct vmci_handle *handle,
+		  struct vmci_queue **produceQ, uint64_t produceSize,
+		  struct vmci_queue **consumeQ, uint64_t consumeSize,
+		  uint32_t peer, uint32_t flags, uint32_t privFlags,
+		  bool guestEndpoint, VMCIEventReleaseCB wakeupCB,
+		  void *clientData);
+int vmci_qp_broker_map(struct vmci_handle handle,
+		       struct vmci_ctx *context, uint64_t guestMem);
+int vmci_qp_broker_unmap(struct vmci_handle handle,
+			 struct vmci_ctx *context, uint32_t gid);
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIMemcpy{To,From}Queue[v]() prototypes
+ *
+ * Note that these routines are NOT SAFE to call on a host end-point
+ * until the guest end of the queue pair has attached -AND-
+ * SetPageStore().  The VMX crosstalk device will issue the
+ * SetPageStore() on behalf of the guest when the guest creates a
+ * QueuePair or attaches to one created by the host.  So, if the guest
+ * notifies the host that it's attached then the queue is safe to use.
+ * Also, if the host registers notification of the connection of the
+ * guest, then it will only receive that notification when the guest
+ * has issued the SetPageStore() call and not before (when the guest
+ * had attached).
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+int VMCIMemcpyToQueue(struct vmci_queue *queue, uint64_t queueOffset,
+		      const void *src, size_t srcOffset, size_t size,
+		      int bufType);
+int VMCIMemcpyFromQueue(void *dest, size_t destOffset,
+			const struct vmci_queue *queue,
+			uint64_t queueOffset, size_t size, int bufType);
+
+int VMCIMemcpyToQueueLocal(struct vmci_queue *queue, uint64_t queueOffset,
+			   const void *src, size_t srcOffset, size_t size,
+			   int bufType);
+int VMCIMemcpyFromQueueLocal(void *dest, size_t destOffset,
+			     const struct vmci_queue *queue,
+			     uint64_t queueOffset, size_t size, int bufType);
+
+int VMCIMemcpyToQueueV(struct vmci_queue *queue, uint64_t queueOffset,
+		       const void *src, size_t srcOffset, size_t size,
+		       int bufType);
+int VMCIMemcpyFromQueueV(void *dest, size_t destOffset,
+			 const struct vmci_queue *queue,
+			 uint64_t queueOffset, size_t size, int bufType);
+
+#endif				/* !_VMCI_QUEUE_PAIR_H_ */
-- 
1.7.0.4

