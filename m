Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758481Ab2EOPJg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:09:36 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:55153 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933087Ab2EOPH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:07:27 -0400
From: "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
To: linux-kernel@vger.kernel.org
Cc: acking@vmware.com, dtor@vmware.com, dsouders@vmware.com,
        cschamp@vmware.com, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, virtualization@lists.linux-foundation.org,
        "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
Subject: [vmw_vmci RFC 04/11] Apply VMCI driver code
Date: Tue, 15 May 2012 08:07:01 -0700
Message-Id: <1337094428-20453-5-git-send-email-astiegmann@vmware.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1337094428-20453-1-git-send-email-astiegmann@vmware.com>
References: <1337094428-20453-1-git-send-email-astiegmann@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code implementes both the host and guest personalities of the
VMCI driver.

Signed-off-by: Andrew Stiegmann (stieg) <astiegmann@vmware.com>
---
 drivers/misc/vmw_vmci/vmci_driver.c | 2875 +++++++++++++++++++++++++++++++++++
 drivers/misc/vmw_vmci/vmci_driver.h |   52 +
 2 files changed, 2927 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/vmw_vmci/vmci_driver.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_driver.h

diff --git a/drivers/misc/vmw_vmci/vmci_driver.c b/drivers/misc/vmw_vmci/vmci_driver.c
new file mode 100644
index 0000000..cf65bac
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmci_driver.c
@@ -0,0 +1,2875 @@
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
+#include <asm/atomic.h>
+#include <asm/io.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/highmem.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/miscdevice.h>
+#include <linux/moduleparam.h>
+#include <linux/mutex.h>
+#include <linux/pci.h>
+#include <linux/poll.h>
+#include <linux/sched.h>
+#include <linux/smp.h>
+#include <linux/version.h>
+#include <linux/vmw_vmci_api.h>
+#include <linux/vmw_vmci_defs.h>
+
+#include "vmci_handle_array.h"
+#include "vmci_common_int.h"
+#include "vmci_context.h"
+#include "vmci_datagram.h"
+#include "vmci_doorbell.h"
+#include "vmci_driver.h"
+#include "vmci_event.h"
+#include "vmci_hash_table.h"
+#include "vmci_queue_pair.h"
+#include "vmci_resource.h"
+
+#define VMCI_UTIL_NUM_RESOURCES 1
+
+enum {
+	VMCI_NOTIFY_RESOURCE_QUEUE_PAIR = 0,
+	VMCI_NOTIFY_RESOURCE_DOOR_BELL = 1,
+};
+
+enum {
+	VMCI_NOTIFY_RESOURCE_ACTION_NOTIFY = 0,
+	VMCI_NOTIFY_RESOURCE_ACTION_CREATE = 1,
+	VMCI_NOTIFY_RESOURCE_ACTION_DESTROY = 2,
+};
+
+static uint32_t ctxUpdateSubID = VMCI_INVALID_ID;
+static struct vmci_ctx *hostContext;
+static atomic_t vmContextID = { VMCI_INVALID_ID };
+
+struct vmci_delayed_work_info {
+	struct work_struct work;
+	VMCIWorkFn *workFn;
+	void *data;
+};
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * PCI Device interface --
+ *
+ *      Declarations of types and functions related to the VMCI PCI
+ *      device personality.
+ *
+ *
+ *----------------------------------------------------------------------
+ */
+
+/*
+ * VMCI driver initialization. This block can also be used to
+ * pass initial group membership etc.
+ */
+struct vmci_init_blk {
+	uint32_t cid;
+	uint32_t flags;
+};
+
+/* VMCIQueuePairAllocInfo_VMToVM */
+struct vmci_qp_alloc_info_vmvm {
+	struct vmci_handle handle;
+	uint32_t peer;
+	uint32_t flags;
+	uint64_t produceSize;
+	uint64_t consumeSize;
+	uint64_t producePageFile;	/* User VA. */
+	uint64_t consumePageFile;	/* User VA. */
+	uint64_t producePageFileSize;	/* Size of the file name array. */
+	uint64_t consumePageFileSize;	/* Size of the file name array. */
+	int32_t result;
+	uint32_t _pad;
+};
+
+/* VMCISetNotifyInfo: Used to pass notify flag's address to the host driver. */
+struct vmci_set_notify_info {
+	uint64_t notifyUVA;
+	int32_t result;
+	uint32_t _pad;
+};
+
+struct vmci_device {
+	struct mutex lock;
+
+	unsigned int ioaddr;
+	unsigned int ioaddr_size;
+	unsigned int irq;
+	unsigned int intr_type;
+	bool exclusive_vectors;
+	struct msix_entry msix_entries[VMCI_MAX_INTRS];
+
+	bool enabled;
+	spinlock_t dev_spinlock;
+	atomic_t datagrams_allowed;
+};
+
+static const struct pci_device_id vmci_ids[] = {
+	{PCI_DEVICE(PCI_VENDOR_ID_VMWARE, PCI_DEVICE_ID_VMWARE_VMCI),},
+	{0},
+};
+
+
+static struct vmci_device vmci_dev;
+static bool vmci_disable_host = false;
+static bool vmci_disable_guest = false;
+static bool vmci_disable_msi = false;
+static bool vmci_disable_msix = false;
+
+/*
+ * Allocate a buffer for incoming datagrams globally to avoid repeated
+ * allocation in the interrupt handler's atomic context.
+ */
+
+static uint8_t *data_buffer = NULL;
+static uint32_t data_buffer_size = VMCI_MAX_DG_SIZE;
+
+/*
+ * If the VMCI hardware supports the notification bitmap, we allocate
+ * and register a page with the device.
+ */
+static uint8_t *notification_bitmap = NULL;
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * Host device node interface --
+ *
+ *      Implements VMCI by implementing open/close/ioctl functions
+ *
+ *
+ *----------------------------------------------------------------------
+ */
+
+/*
+ * Per-instance host state
+ */
+struct vmci_linux {
+	struct vmci_ctx *context;
+	int userVersion;
+	enum vmci_obj_type ctType;
+	struct mutex lock;
+};
+
+/*
+ * Static driver state.
+ */
+struct vmci_linux_state {
+	struct miscdevice misc;
+	char buf[1024];
+	atomic_t activeContexts;
+};
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * Shared VMCI device definitions --
+ *
+ *      Types and variables shared by both host and guest personality
+ *
+ *
+ *----------------------------------------------------------------------
+ */
+
+static bool guestDeviceInit;
+static atomic_t guestDeviceActive;
+static bool hostDeviceInit;
+
+
+
+/*
+ *----------------------------------------------------------------------------
+ *
+ * drv_delayed_work_cb
+ *
+ *      Called in a worker thread context.
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------------
+ */
+
+static void drv_delayed_work_cb(struct work_struct *work)	// IN
+{
+	struct vmci_delayed_work_info *delayedWorkInfo;
+
+	delayedWorkInfo = container_of(work, struct vmci_delayed_work_info, work);
+	ASSERT(delayedWorkInfo);
+	ASSERT(delayedWorkInfo->workFn);
+
+	delayedWorkInfo->workFn(delayedWorkInfo->data);
+
+	kfree(delayedWorkInfo);
+}
+
+/*
+ *----------------------------------------------------------------------------
+ *
+ * vmci_drv_schedule_delayed_work --
+ *
+ *      Schedule the specified callback.
+ *
+ * Results:
+ *      Zero on success, error code otherwise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------------
+ */
+
+int vmci_drv_schedule_delayed_work(VMCIWorkFn * workFn,	// IN
+				   void *data)	// IN
+{
+	struct vmci_delayed_work_info *delayedWorkInfo;
+
+	ASSERT(workFn);
+
+	delayedWorkInfo = kmalloc(sizeof *delayedWorkInfo, GFP_ATOMIC);
+	if (!delayedWorkInfo)
+		return VMCI_ERROR_NO_MEM;
+
+	delayedWorkInfo->workFn = workFn;
+	delayedWorkInfo->data = data;
+
+	INIT_WORK(&delayedWorkInfo->work, drv_delayed_work_cb);
+
+	schedule_work(&delayedWorkInfo->work);
+
+	return VMCI_SUCCESS;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * vmci_drv_wait_on_event_intr --
+ *
+ * Results:
+ *      True if the wait was interrupted by a signal, false otherwise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+bool vmci_drv_wait_on_event_intr(wait_queue_head_t * event,	// IN:
+				 VMCIEventReleaseCB releaseCB,	// IN:
+				 void *clientData)	// IN:
+{
+	DECLARE_WAITQUEUE(wait, current);
+
+	if (event == NULL || releaseCB == NULL)
+		return false;
+
+	add_wait_queue(event, &wait);
+	current->state = TASK_INTERRUPTIBLE;
+
+	/*
+	 * Release the lock or other primitive that makes it possible for us to
+	 * put the current thread on the wait queue without missing the signal.
+	 * Ie. on Linux we need to put ourselves on the wait queue and set our
+	 * stateto TASK_INTERRUPTIBLE without another thread signalling us.
+	 * The releaseCB is used to synchronize this.
+	 */
+	releaseCB(clientData);
+
+	schedule();
+	current->state = TASK_RUNNING;
+	remove_wait_queue(event, &wait);
+
+	return signal_pending(current);
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * drv_host_cleanup --
+ *
+ *      Cleans up the host specific components of the VMCI module.
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+static void drv_host_cleanup(void)
+{
+	vmci_ctx_release_ctx(hostContext);
+	vmci_qp_broker_exit();
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * drv_device_enabled --
+ *
+ *      Checks whether the VMCI device is enabled.
+ *
+ * Results:
+ *      true if device is enabled, false otherwise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static bool drv_device_enabled(void)
+{
+	return vmci_guest_code_active()
+		|| vmci_host_code_active();
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCI_DeviceGet --
+ *
+ *      Verifies that a valid VMCI device is present, and indicates
+ *      the callers intention to use the device until it calls
+ *      VMCI_DeviceRelease().
+ *
+ * Results:
+ *      true if a valid VMCI device is present, false otherwise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+bool VMCI_DeviceGet(uint32_t * apiVersion,	// IN/OUT
+		    VMCI_DeviceShutdownFn * deviceShutdownCB,	// UNUSED
+		    void *userData,	// UNUSED
+		    void **deviceRegistration)	// OUT
+{
+	if (NULL != deviceRegistration) {
+		*deviceRegistration = NULL;
+	}
+
+	if (*apiVersion > VMCI_KERNEL_API_VERSION) {
+		*apiVersion = VMCI_KERNEL_API_VERSION;
+		return false;
+	}
+
+	if (!drv_device_enabled()) {
+		return false;
+	}
+
+	return true;
+}
+
+EXPORT_SYMBOL(VMCI_DeviceGet);
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCI_DeviceRelease --
+ *
+ *      Indicates that the caller is done using the VMCI device.
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      Useless.
+ *
+ *----------------------------------------------------------------------
+ */
+
+void VMCI_DeviceRelease(void *deviceRegistration)	// UNUSED
+{
+}
+
+EXPORT_SYMBOL(VMCI_DeviceRelease);
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * drv_util_cid_update --
+ *
+ *      Gets called with the new context id if updated or resumed.
+ *
+ * Results:
+ *      Context id.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static void drv_util_cid_update(uint32_t subID,	// IN:
+				struct vmci_event_data *eventData,	// IN:
+				void *clientData)	// IN:
+{
+	struct vmci_event_payld_ctx *evPayload =
+		vmci_event_data_payload(eventData);
+
+	if (subID != ctxUpdateSubID) {
+		pr_devel("Invalid subscriber (ID=0x%x).", subID);
+		return;
+	}
+
+	if (eventData == NULL || evPayload->contextID == VMCI_INVALID_ID) {
+		pr_devel("Invalid event data.");
+		return;
+	}
+
+	pr_devel("Updating context from (ID=0x%x) to (ID=0x%x) on event "
+		 "(type=%d).", atomic_read(&vmContextID), evPayload->contextID,
+		 eventData->event);
+
+	atomic_set(&vmContextID, evPayload->contextID);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * drv_util_init --
+ *
+ *      Subscribe to context id update event.
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
+static void __devinit drv_util_init(void)
+{
+	/*
+	 * We subscribe to the VMCI_EVENT_CTX_ID_UPDATE here so we can update the
+	 * internal context id when needed.
+	 */
+	if (VMCIEvent_Subscribe
+	    (VMCI_EVENT_CTX_ID_UPDATE, VMCI_FLAG_EVENT_NONE,
+	     drv_util_cid_update, NULL, &ctxUpdateSubID) < VMCI_SUCCESS) {
+		pr_warn("Failed to subscribe to event (type=%d).",
+			VMCI_EVENT_CTX_ID_UPDATE);
+	}
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * vmci_util_exit --
+ *
+ *      Cleanup
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
+static void vmci_util_exit(void)
+{
+	if (VMCIEvent_Unsubscribe(ctxUpdateSubID) < VMCI_SUCCESS) {
+		pr_warn("Failed to unsubscribe to event (type=%d) with "
+			"subscriber (ID=0x%x).", VMCI_EVENT_CTX_ID_UPDATE,
+			ctxUpdateSubID);
+	}
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * drv_check_host_caps --
+ *
+ *      Verify that the host supports the hypercalls we need. If it does not,
+ *      try to find fallback hypercalls and use those instead.
+ *
+ * Results:
+ *      true if required hypercalls (or fallback hypercalls) are
+ *      supported by the host, false otherwise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static bool drv_check_host_caps(void)
+{
+	bool result;
+	struct vmci_rscs_query_msg *msg;
+	uint32_t msgSize = sizeof(struct vmci_resource_query_hdr) +
+		VMCI_UTIL_NUM_RESOURCES * sizeof(uint32_t);
+	struct vmci_dg *checkMsg = kmalloc(msgSize, GFP_KERNEL);
+
+	if (checkMsg == NULL) {
+		pr_warn("Check host: Insufficient memory.");
+		return false;
+	}
+
+	checkMsg->dst = vmci_make_handle(VMCI_HYPERVISOR_CONTEXT_ID,
+					 VMCI_RESOURCES_QUERY);
+	checkMsg->src = VMCI_ANON_SRC_HANDLE;
+	checkMsg->payloadSize = msgSize - VMCI_DG_HEADERSIZE;
+	msg = (struct vmci_rscs_query_msg *)VMCI_DG_PAYLOAD(checkMsg);
+
+	msg->numResources = VMCI_UTIL_NUM_RESOURCES;
+	msg->resources[0] = VMCI_GET_CONTEXT_ID;
+
+	/* Checks that hyper calls are supported */
+	result = (0x1 == vmci_send_dg(checkMsg));
+	kfree(checkMsg);
+
+	pr_info("Host capability check: %s.",
+		result ? "PASSED" : "FAILED");
+
+	/* We need the vector. There are no fallbacks. */
+	return result;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * drv_read_dgs_from_port --
+ *
+ *      Reads datagrams from the data in port and dispatches them. We
+ *      always start reading datagrams into only the first page of the
+ *      datagram buffer. If the datagrams don't fit into one page, we
+ *      use the maximum datagram buffer size for the remainder of the
+ *      invocation. This is a simple heuristic for not penalizing
+ *      small datagrams.
+ *
+ *      This function assumes that it has exclusive access to the data
+ *      in port for the duration of the call.
+ *
+ * Results:
+ *      No result.
+ *
+ * Side effects:
+ *      Datagram handlers may be invoked.
+ *
+ *----------------------------------------------------------------------
+ */
+
+static void drv_read_dgs_from_port(int ioHandle,	// IN
+				   unsigned short int dgInPort,	// IN
+				   uint8_t * dgInBuffer,	// IN
+				   size_t dgInBufferSize)	// IN
+{
+	struct vmci_dg *dg;
+	size_t currentDgInBufferSize = PAGE_SIZE;
+	size_t remainingBytes;
+
+	ASSERT(dgInBufferSize >= PAGE_SIZE);
+
+	insb(dgInPort, dgInBuffer, currentDgInBufferSize);
+	dg = (struct vmci_dg *)dgInBuffer;
+	remainingBytes = currentDgInBufferSize;
+
+	while (dg->dst.resource != VMCI_INVALID_ID
+	       || remainingBytes > PAGE_SIZE) {
+		unsigned dgInSize;
+
+		/*
+		 * When the input buffer spans multiple pages, a datagram can
+		 * start on any page boundary in the buffer.
+		 */
+
+		if (dg->dst.resource == VMCI_INVALID_ID) {
+			ASSERT(remainingBytes > PAGE_SIZE);
+			dg = (struct vmci_dg *)roundup((uintptr_t)
+						       dg + 1, PAGE_SIZE);
+			ASSERT((uint8_t *) dg <
+			       dgInBuffer + currentDgInBufferSize);
+			remainingBytes =
+				(size_t) (dgInBuffer + currentDgInBufferSize -
+					  (uint8_t *) dg);
+			continue;
+		}
+
+		dgInSize = VMCI_DG_SIZE_ALIGNED(dg);
+
+		if (dgInSize <= dgInBufferSize) {
+			int result;
+
+			/*
+			 * If the remaining bytes in the datagram buffer doesn't
+			 * contain the complete datagram, we first make sure we have
+			 * enough room for it and then we read the reminder of the
+			 * datagram and possibly any following datagrams.
+			 */
+
+			if (dgInSize > remainingBytes) {
+				if (remainingBytes != currentDgInBufferSize) {
+
+					/*
+					 * We move the partial datagram to the front and read
+					 * the reminder of the datagram and possibly following
+					 * calls into the following bytes.
+					 */
+
+					memmove(dgInBuffer, dgInBuffer +
+						currentDgInBufferSize -
+						remainingBytes, remainingBytes);
+					dg = (struct vmci_dg *)
+						dgInBuffer;
+				}
+
+				if (currentDgInBufferSize != dgInBufferSize)
+					currentDgInBufferSize = dgInBufferSize;
+
+				insb(dgInPort, dgInBuffer + remainingBytes,
+				     currentDgInBufferSize - remainingBytes);
+			}
+
+			/* We special case event datagrams from the hypervisor. */
+			if (dg->src.context == VMCI_HYPERVISOR_CONTEXT_ID
+			    && dg->dst.resource == VMCI_EVENT_HANDLER) {
+				result = vmci_event_dispatch(dg);
+			} else {
+				result = vmci_dg_invoke_guest_handler(dg);
+			}
+			if (result < VMCI_SUCCESS) {
+				pr_devel("Datagram with resource "
+					 "(ID=0x%x) failed (err=%d).",
+					 dg->dst.resource, result);
+			}
+
+			/* On to the next datagram. */
+			dg = (struct vmci_dg *)((uint8_t *) dg +
+						dgInSize);
+		} else {
+			size_t bytesToSkip;
+
+			/* Datagram doesn't fit in datagram buffer of maximal size. We drop it. */
+			pr_devel("Failed to receive datagram (size=%u bytes).",
+				 dgInSize);
+
+			bytesToSkip = dgInSize - remainingBytes;
+			if (currentDgInBufferSize != dgInBufferSize)
+				currentDgInBufferSize = dgInBufferSize;
+
+			for (;;) {
+				insb(dgInPort, dgInBuffer,
+				     currentDgInBufferSize);
+				if (bytesToSkip <= currentDgInBufferSize)
+					break;
+
+				bytesToSkip -= currentDgInBufferSize;
+			}
+			dg = (struct vmci_dg *)(dgInBuffer + bytesToSkip);
+		}
+
+		remainingBytes =
+			(size_t) (dgInBuffer + currentDgInBufferSize -
+				  (uint8_t *) dg);
+
+		if (remainingBytes < VMCI_DG_HEADERSIZE) {
+			/* Get the next batch of datagrams. */
+
+			insb(dgInPort, dgInBuffer, currentDgInBufferSize);
+			dg = (struct vmci_dg *)dgInBuffer;
+			remainingBytes = currentDgInBufferSize;
+		}
+	}
+}
+
+/*
+ *----------------------------------------------------------------------------
+ *
+ * VMCI_GetContextID --
+ *
+ *    Returns the current context ID.  Note that since this is accessed only
+ *    from code running in the host, this always returns the host context ID.
+ *
+ * Results:
+ *    Context ID.
+ *
+ * Side effects:
+ *    None.
+ *
+ *----------------------------------------------------------------------------
+ */
+
+uint32_t VMCI_GetContextID(void)
+{
+	if (vmci_guest_code_active()) {
+		if (atomic_read(&vmContextID) == VMCI_INVALID_ID) {
+			uint32_t result;
+			struct vmci_dg getCidMsg;
+			getCidMsg.dst =
+				vmci_make_handle(VMCI_HYPERVISOR_CONTEXT_ID,
+						 VMCI_GET_CONTEXT_ID);
+			getCidMsg.src = VMCI_ANON_SRC_HANDLE;
+			getCidMsg.payloadSize = 0;
+			result = vmci_send_dg(&getCidMsg);
+			atomic_set(&vmContextID, result);
+		}
+		return atomic_read(&vmContextID);
+	} else if (vmci_host_code_active()) {
+		return VMCI_HOST_CONTEXT_ID;
+	}
+	return VMCI_INVALID_ID;
+}
+
+EXPORT_SYMBOL(VMCI_GetContextID);
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCI_Version --
+ *
+ *     Returns the version of the VMCI driver.
+ *
+ * Results:
+ *      Returns a version number.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+uint32_t VMCI_Version()
+{
+	return VMCI_VERSION;
+}
+
+EXPORT_SYMBOL(VMCI_Version);
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * drv_shared_init --
+ *
+ *      Initializes VMCI components shared between guest and host
+ *      driver. This registers core hypercalls.
+ *
+ * Results:
+ *      VMCI_SUCCESS if successful, appropriate error code otherwise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+static int __init drv_shared_init(void)
+{
+	int result;
+
+	result = vmci_resource_init();
+	if (result < VMCI_SUCCESS) {
+		pr_warn("Failed to initialize VMCIResource (result=%d).",
+			result);
+		goto errorExit;
+	}
+
+	result = vmci_ctx_init();
+	if (result < VMCI_SUCCESS) {
+		pr_warn("Failed to initialize VMCIContext (result=%d).",
+			result);
+		goto resourceExit;
+	}
+
+	result = vmci_dg_init();
+	if (result < VMCI_SUCCESS) {
+		pr_warn("Failed to initialize VMCIDatagram (result=%d).",
+			result);
+		goto resourceExit;
+	}
+
+	result = vmci_event_init();
+	if (result < VMCI_SUCCESS) {
+		pr_warn("Failed to initialize VMCIEvent (result=%d).",
+			result);
+		goto resourceExit;
+	}
+
+	result = vmci_dbell_init();
+	if (result < VMCI_SUCCESS) {
+		pr_warn("Failed to initialize VMCIDoorbell (result=%d).",
+			result);
+		goto eventExit;
+	}
+
+	pr_notice("shared components initialized.");
+	return VMCI_SUCCESS;
+
+eventExit:
+	vmci_event_exit();
+resourceExit:
+	vmci_resource_exit();
+errorExit:
+	return result;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * drv_shared_cleanup --
+ *
+ *      Cleans up VMCI components shared between guest and host
+ *      driver.
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+static void drv_shared_cleanup(void)
+{
+	vmci_event_exit();
+	vmci_resource_exit();
+}
+
+static const struct file_operations vmuser_fops;
+static struct vmci_linux_state linuxState = {
+	.misc = {
+		.name = MODULE_NAME,
+		.minor = MISC_DYNAMIC_MINOR,
+		.fops = &vmuser_fops,
+	},
+	.activeContexts = ATOMIC_INIT(0),
+};
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * drv_driver_open  --
+ *
+ *     Called on open of /dev/vmci.
+ *
+ * Side effects:
+ *     Increment use count used to determine eventual deallocation of
+ *     the module
+ *
+ *----------------------------------------------------------------------
+ */
+
+static int drv_driver_open(struct inode *inode,	// IN
+			   struct file *filp)	// IN
+{
+	struct vmci_linux *vmciLinux;
+
+	vmciLinux = kzalloc(sizeof(struct vmci_linux), GFP_KERNEL);
+	if (vmciLinux == NULL)
+		return -ENOMEM;
+
+	vmciLinux->ctType = VMCIOBJ_NOT_SET;
+	mutex_init(&vmciLinux->lock);
+	filp->private_data = vmciLinux;
+
+	return 0;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * drv_driver_close  --
+ *
+ *      Called on close of /dev/vmci, most often when the process
+ *      exits.
+ *
+ *----------------------------------------------------------------------
+ */
+
+static int drv_driver_close(struct inode *inode,	// IN
+			    struct file *filp)	// IN
+{
+	struct vmci_linux *vmciLinux;
+
+	vmciLinux = (struct vmci_linux *)filp->private_data;
+	ASSERT(vmciLinux);
+
+	if (vmciLinux->ctType == VMCIOBJ_CONTEXT) {
+		ASSERT(vmciLinux->context);
+
+		vmci_ctx_release_ctx(vmciLinux->context);
+		vmciLinux->context = NULL;
+
+		/*
+		 * The number of active contexts is used to track whether any
+		 * VMX'en are using the host personality. It is incremented when
+		 * a context is created through the IOCTL_VMCI_INIT_CONTEXT
+		 * ioctl.
+		 */
+
+		atomic_dec(&linuxState.activeContexts);
+	}
+	vmciLinux->ctType = VMCIOBJ_NOT_SET;
+
+	kfree(vmciLinux);
+	filp->private_data = NULL;
+	return 0;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * drv_driver_poll  --
+ *
+ *      This is used to wake up the VMX when a VMCI call arrives, or
+ *      to wake up select() or poll() at the next clock tick.
+ *
+ *----------------------------------------------------------------------
+ */
+
+static unsigned int drv_driver_poll(struct file *filp, poll_table * wait)
+{
+	struct vmci_linux *vmciLinux = (struct vmci_linux *)filp->private_data;
+	unsigned int mask = 0;
+
+	if (vmciLinux->ctType == VMCIOBJ_CONTEXT) {
+		ASSERT(vmciLinux->context != NULL);
+		/*
+		 * Check for VMCI calls to this VM context.
+		 */
+
+		if (wait != NULL) {
+			poll_wait(filp,
+				  &vmciLinux->context->hostContext.waitQueue,
+				  wait);
+		}
+
+		spin_lock(&vmciLinux->context->lock);
+		if (vmciLinux->context->pendingDatagrams > 0 ||
+		    vmci_handle_arr_get_size(vmciLinux->context->
+					     pendingDoorbellArray) > 0) {
+			mask = POLLIN;
+		}
+		spin_unlock(&vmciLinux->context->lock);
+	}
+	return mask;
+}
+
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * drv_host_init --
+ *
+ *      Initializes the VMCI host device driver.
+ *
+ * Results:
+ *      0 on success, other error codes on failure.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static int __init drv_host_init(void)
+{
+	int error;
+	int result;
+
+
+	result = vmci_ctx_init_ctx(VMCI_HOST_CONTEXT_ID,
+				   VMCI_DEFAULT_PROC_PRIVILEGE_FLAGS,
+				   -1, VMCI_VERSION, NULL, &hostContext);
+	if (result < VMCI_SUCCESS) {
+		pr_warn("Failed to initialize VMCIContext (result=%d).",
+			result);
+		return -ENOMEM;
+	}
+
+	result = vmci_qp_broker_init();
+	if (result < VMCI_SUCCESS) {
+		pr_warn("Failed to initialize broker (result=%d).",
+			result);
+		vmci_ctx_release_ctx(hostContext);
+		return -ENOMEM;
+	}
+
+	error = misc_register(&linuxState.misc);
+	if (error) {
+		pr_warn("Module registration error "
+			"(name=%s, major=%d, minor=%d, err=%d).",
+			linuxState.misc.name, MISC_MAJOR, linuxState.misc.minor,
+			error);
+		drv_host_cleanup();
+		return error;
+	}
+
+	pr_notice("Module registered (name=%s, major=%d, minor=%d).",
+		  linuxState.misc.name, MISC_MAJOR, linuxState.misc.minor);
+
+	return 0;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * drv_cp_harray_to_user  --
+ *
+ *      Copies the handles of a handle array into a user buffer, and
+ *      returns the new length in userBufferSize. If the copy to the
+ *      user buffer fails, the functions still returns VMCI_SUCCESS,
+ *      but retval != 0.
+ *
+ *----------------------------------------------------------------------
+ */
+
+static int drv_cp_harray_to_user(void *userBufUVA,	// IN
+				 uint64_t * userBufSize,	// IN/OUT
+				 struct vmci_handle_arr *handleArray,	// IN
+				 int *retval)	// IN
+{
+	uint32_t arraySize = 0;
+	struct vmci_handle *handles;
+
+	if (handleArray)
+		arraySize = vmci_handle_arr_get_size(handleArray);
+
+	if (arraySize * sizeof *handles > *userBufSize)
+		return VMCI_ERROR_MORE_DATA;
+
+	*userBufSize = arraySize * sizeof *handles;
+	if (*userBufSize)
+		*retval = copy_to_user(userBufUVA,
+				       vmci_handle_arr_get_handles
+				       (handleArray), *userBufSize);
+
+	return VMCI_SUCCESS;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * drv_qp_broker_alloc --
+ *
+ *      Helper function for creating queue pair and copying the result
+ *      to user memory.
+ *
+ * Results:
+ *      0 if result value was copied to user memory, -EFAULT otherwise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static int drv_qp_broker_alloc(struct vmci_handle handle,
+			       uint32_t peer,
+			       uint32_t flags,
+			       uint64_t produceSize,
+			       uint64_t consumeSize,
+			       QueuePairPageStore * pageStore,
+			       struct vmci_ctx *context,
+			       bool vmToVm,
+			       void *resultUVA)
+{
+	uint32_t cid;
+	int result;
+	int retval;
+
+	cid = vmci_ctx_get_id(context);
+
+	result =
+		vmci_qp_broker_alloc(handle, peer, flags,
+				     VMCI_NO_PRIVILEGE_FLAGS, produceSize,
+				     consumeSize, pageStore, context);
+	if (result == VMCI_SUCCESS && vmToVm)
+		result = VMCI_SUCCESS_QUEUEPAIR_CREATE;
+
+	retval = copy_to_user(resultUVA, &result, sizeof result);
+	if (retval) {
+		retval = -EFAULT;
+		if (result >= VMCI_SUCCESS) {
+			result = vmci_qp_broker_detach(handle, context);
+			ASSERT(result >= VMCI_SUCCESS);
+		}
+	}
+
+	return retval;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * drv_user_va_lock_page --
+ *
+ *      Lock physical page backing a given user VA.  Copied from
+ *      bora/modules/vmnet/linux/userif.c:UserIfLockPage().  TODO libify the
+ *      common code.
+ *
+ * Results:
+ *      Pointer to struct page on success, NULL otherwise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static struct page *drv_user_va_lock_page(uintptr_t addr)	// IN:
+{
+	struct page *page = NULL;
+	int retval;
+
+	down_read(&current->mm->mmap_sem);
+	retval = get_user_pages(current, current->mm, addr,
+				1, 1, 0, &page, NULL);
+	up_read(&current->mm->mmap_sem);
+
+	if (retval != 1)
+		return NULL;
+
+	return page;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * drv_map_bool_ptr --
+ *
+ *      Lock physical page backing a given user VA and maps it to kernel
+ *      address space.  The range of the mapped memory should be within a
+ *      single page otherwise an error is returned.  Copied from
+ *      bora/modules/vmnet/linux/userif.c:VNetUserIfMapUint32Ptr().  TODO
+ *      libify the common code.
+ *
+ * Results:
+ *      0 on success, negative error code otherwise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static int drv_map_bool_ptr(uintptr_t notifyUVA,	// IN:
+				   struct page **p,	// OUT:
+				   bool ** notifyPtr)	// OUT:
+{
+	if (!access_ok(VERIFY_WRITE, notifyUVA, sizeof **notifyPtr) ||
+	    (((notifyUVA + sizeof **notifyPtr - 1) & ~(PAGE_SIZE - 1)) !=
+	     (notifyUVA & ~(PAGE_SIZE - 1)))) {
+		return -EINVAL;
+	}
+
+	*p = drv_user_va_lock_page(notifyUVA);
+	if (*p == NULL)
+		return -EAGAIN;
+
+	*notifyPtr =
+		(bool *) ((uint8_t *) kmap(*p) + (notifyUVA & (PAGE_SIZE - 1)));
+	return 0;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * drv_setup_notify --
+ *
+ *      Sets up a given context for notify to work.  Calls drv_map_bool_ptr()
+ *      which maps the notify boolean in user VA in kernel space.
+ *
+ * Results:
+ *      VMCI_SUCCESS on success, error code otherwise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static int drv_setup_notify(struct vmci_ctx *context,	// IN:
+			    uintptr_t notifyUVA)	// IN:
+{
+	int retval;
+
+	if (context->notify) {
+		pr_warn("Notify mechanism is already set up.");
+		return VMCI_ERROR_DUPLICATE_ENTRY;
+	}
+
+	retval =
+		drv_map_bool_ptr(notifyUVA, &context->notifyPage,
+				 &context->notify) ==
+		0 ? VMCI_SUCCESS : VMCI_ERROR_GENERIC;
+	if (retval == VMCI_SUCCESS)
+		vmci_ctx_check_signal_notify(context);
+
+	return retval;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * drv_driver_unlocked_ioctl --
+ *
+ *      Main path for UserRPC
+ *
+ * Results:
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static long drv_driver_unlocked_ioctl(struct file *filp,
+				      u_int iocmd,
+				      unsigned long ioarg)
+{
+	struct vmci_linux *vmciLinux = (struct vmci_linux *)filp->private_data;
+	int retval = 0;
+
+	switch (iocmd) {
+	case IOCTL_VMCI_VERSION2:{
+		int verFromUser;
+
+		if (copy_from_user
+		    (&verFromUser, (void *)ioarg, sizeof verFromUser)) {
+			retval = -EFAULT;
+			break;
+		}
+
+		vmciLinux->userVersion = verFromUser;
+	}
+		/* Fall through. */
+	case IOCTL_VMCI_VERSION:
+		/*
+		 * The basic logic here is:
+		 *
+		 * If the user sends in a version of 0 tell it our version.
+		 * If the user didn't send in a version, tell it our version.
+		 * If the user sent in an old version, tell it -its- version.
+		 * If the user sent in an newer version, tell it our version.
+		 *
+		 * The rationale behind telling the caller its version is that
+		 * Workstation 6.5 required that VMX and VMCI kernel module were
+		 * version sync'd.  All new VMX users will be programmed to
+		 * handle the VMCI kernel module version.
+		 */
+
+		if (vmciLinux->userVersion > 0 &&
+		    vmciLinux->userVersion < VMCI_VERSION_HOSTQP) {
+			retval = vmciLinux->userVersion;
+		} else {
+			retval = VMCI_VERSION;
+		}
+		break;
+
+	case IOCTL_VMCI_INIT_CONTEXT:{
+		struct vmci_init_blk initBlock;
+		uid_t user;
+
+		retval =
+			copy_from_user(&initBlock, (void *)ioarg,
+				       sizeof initBlock);
+		if (retval != 0) {
+		  pr_info("Error reading init block.");
+			retval = -EFAULT;
+			break;
+		}
+
+		mutex_lock(&vmciLinux->lock);
+		if (vmciLinux->ctType != VMCIOBJ_NOT_SET) {
+			pr_info("Received VMCI init on initialized handle.");
+			retval = -EINVAL;
+			goto init_release;
+		}
+
+		if (initBlock.flags & ~VMCI_PRIVILEGE_FLAG_RESTRICTED) {
+			pr_info("Unsupported VMCI restriction flag.");
+			retval = -EINVAL;
+			goto init_release;
+		}
+
+		user = current_uid();
+		retval =
+			vmci_ctx_init_ctx(initBlock.cid,
+					  initBlock.flags,
+					  0 /* Unused */ ,
+					  vmciLinux->userVersion,
+					  &user, &vmciLinux->context);
+		if (retval < VMCI_SUCCESS) {
+			pr_info("Error initializing context.");
+			retval =
+				retval ==
+				VMCI_ERROR_DUPLICATE_ENTRY ? -EEXIST :
+				-EINVAL;
+			goto init_release;
+		}
+
+		/*
+		 * Copy cid to userlevel, we do this to allow the VMX to enforce its
+		 * policy on cid generation.
+		 */
+		initBlock.cid = vmci_ctx_get_id(vmciLinux->context);
+		retval =
+			copy_to_user((void *)ioarg, &initBlock,
+				     sizeof initBlock);
+		if (retval != 0) {
+			vmci_ctx_release_ctx(vmciLinux->context);
+			vmciLinux->context = NULL;
+			pr_info("Error writing init block.");
+			retval = -EFAULT;
+			goto init_release;
+		}
+		ASSERT(initBlock.cid != VMCI_INVALID_ID);
+
+		vmciLinux->ctType = VMCIOBJ_CONTEXT;
+
+		atomic_inc(&linuxState.activeContexts);
+
+		init_release:
+		mutex_unlock(&vmciLinux->lock);
+		break;
+	}
+
+	case IOCTL_VMCI_DATAGRAM_SEND:{
+		struct vmci_dg_snd_rcv_info sendInfo;
+		struct vmci_dg *dg = NULL;
+		uint32_t cid;
+
+		if (vmciLinux->ctType != VMCIOBJ_CONTEXT) {
+			pr_warn("Ioctl only valid for context handle (iocmd=%d).",
+				iocmd);
+			retval = -EINVAL;
+			break;
+		}
+
+		retval =
+			copy_from_user(&sendInfo, (void *)ioarg,
+				       sizeof sendInfo);
+		if (retval) {
+			pr_warn("copy_from_user failed.");
+			retval = -EFAULT;
+			break;
+		}
+
+		if (sendInfo.len > VMCI_MAX_DG_SIZE) {
+			pr_warn("Datagram too big (size=%d).",
+				sendInfo.len);
+			retval = -EINVAL;
+			break;
+		}
+
+		if (sendInfo.len < sizeof *dg) {
+			pr_warn("Datagram too small (size=%d).",
+				sendInfo.len);
+			retval = -EINVAL;
+			break;
+		}
+
+		dg = kmalloc(sendInfo.len, GFP_KERNEL);
+		if (dg == NULL) {
+			pr_info("Cannot allocate memory to dispatch datagram.");
+			retval = -ENOMEM;
+			break;
+		}
+
+		retval =
+			copy_from_user(dg,
+				       (char *)(uintptr_t) sendInfo.addr,
+				       sendInfo.len);
+		if (retval != 0) {
+			pr_info("Error getting datagram (err=%d).",
+			       retval);
+			kfree(dg);
+			retval = -EFAULT;
+			break;
+		}
+
+		pr_devel("Datagram dst (handle=0x%x:0x%x) src "
+			 "(handle=0x%x:0x%x), payload "
+			 "(size=%llu bytes).",
+			 dg->dst.context, dg->dst.resource,
+			 dg->src.context, dg->src.resource,
+			 (unsigned long long) dg->payloadSize);
+
+		/* Get source context id. */
+		ASSERT(vmciLinux->context);
+		cid = vmci_ctx_get_id(vmciLinux->context);
+		ASSERT(cid != VMCI_INVALID_ID);
+		sendInfo.result = vmci_dg_dispatch(cid, dg, true);
+		kfree(dg);
+		retval =
+			copy_to_user((void *)ioarg, &sendInfo,
+				     sizeof sendInfo);
+		break;
+	}
+
+	case IOCTL_VMCI_DATAGRAM_RECEIVE:{
+		struct vmci_dg_snd_rcv_info recvInfo;
+		struct vmci_dg *dg = NULL;
+		size_t size;
+
+		if (vmciLinux->ctType != VMCIOBJ_CONTEXT) {
+			pr_warn("Ioctl only valid for context handle (iocmd=%d).",
+				iocmd);
+			retval = -EINVAL;
+			break;
+		}
+
+		retval =
+			copy_from_user(&recvInfo, (void *)ioarg,
+				       sizeof recvInfo);
+		if (retval) {
+			pr_warn("copy_from_user failed.");
+			retval = -EFAULT;
+			break;
+		}
+
+		ASSERT(vmciLinux->ctType == VMCIOBJ_CONTEXT);
+
+		size = recvInfo.len;
+		ASSERT(vmciLinux->context);
+		recvInfo.result =
+			vmci_ctx_dequeue_dg(vmciLinux->context,
+					    &size, &dg);
+
+		if (recvInfo.result >= VMCI_SUCCESS) {
+			ASSERT(dg);
+			retval = copy_to_user((void *)((uintptr_t)
+						       recvInfo.addr),
+					      dg, VMCI_DG_SIZE(dg));
+			kfree(dg);
+			if (retval != 0)
+				break;
+		}
+		retval =
+			copy_to_user((void *)ioarg, &recvInfo,
+				     sizeof recvInfo);
+		break;
+	}
+
+	case IOCTL_VMCI_QUEUEPAIR_ALLOC:{
+		if (vmciLinux->ctType != VMCIOBJ_CONTEXT) {
+			pr_info("IOCTL_VMCI_QUEUEPAIR_ALLOC only valid for contexts.");
+			retval = -EINVAL;
+			break;
+		}
+
+		if (vmciLinux->userVersion < VMCI_VERSION_NOVMVM) {
+			struct vmci_qp_alloc_info_vmvm queuePairAllocInfo;
+			struct vmci_qp_alloc_info_vmvm *info =
+				(struct vmci_qp_alloc_info_vmvm *)ioarg;
+
+			retval =
+				copy_from_user(&queuePairAllocInfo,
+					       (void *)ioarg,
+					       sizeof queuePairAllocInfo);
+			if (retval) {
+				retval = -EFAULT;
+				break;
+			}
+
+			retval = drv_qp_broker_alloc(queuePairAllocInfo.handle, queuePairAllocInfo.peer, queuePairAllocInfo.flags, queuePairAllocInfo.produceSize, queuePairAllocInfo.consumeSize, NULL, vmciLinux->context, true,	// VM to VM style create
+						     &info->result);
+		} else {
+			struct vmci_qp_alloc_info
+				queuePairAllocInfo;
+			struct vmci_qp_alloc_info *info =
+				(struct vmci_qp_alloc_info *)ioarg;
+			QueuePairPageStore pageStore;
+
+			retval =
+				copy_from_user(&queuePairAllocInfo,
+					       (void *)ioarg,
+					       sizeof queuePairAllocInfo);
+			if (retval) {
+				retval = -EFAULT;
+				break;
+			}
+
+			pageStore.pages = queuePairAllocInfo.ppnVA;
+			pageStore.len = queuePairAllocInfo.numPPNs;
+
+			retval = drv_qp_broker_alloc(
+				queuePairAllocInfo.handle,
+				queuePairAllocInfo.peer,
+				queuePairAllocInfo.flags,
+				queuePairAllocInfo.produceSize,
+				queuePairAllocInfo.consumeSize,
+				&pageStore, vmciLinux->context,
+				false, &info->result);
+		}
+		break;
+	}
+
+	case IOCTL_VMCI_QUEUEPAIR_SETVA:{
+		struct vmci_qp_set_va_info setVAInfo;
+		struct vmci_qp_set_va_info *info =
+			(struct vmci_qp_set_va_info *)ioarg;
+		int32_t result;
+
+		if (vmciLinux->ctType != VMCIOBJ_CONTEXT) {
+			pr_info("IOCTL_VMCI_QUEUEPAIR_SETVA only valid for contexts.");
+			retval = -EINVAL;
+			break;
+		}
+
+		if (vmciLinux->userVersion < VMCI_VERSION_NOVMVM) {
+			pr_info("IOCTL_VMCI_QUEUEPAIR_SETVA not supported for this VMX version.");
+			retval = -EINVAL;
+			break;
+		}
+
+		retval =
+			copy_from_user(&setVAInfo, (void *)ioarg,
+				       sizeof setVAInfo);
+		if (retval) {
+			retval = -EFAULT;
+			break;
+		}
+
+		if (setVAInfo.va) {
+			/*
+			 * VMX is passing down a new VA for the queue pair mapping.
+			 */
+
+			result = vmci_qp_broker_map(setVAInfo.handle,
+						    vmciLinux->context,
+						    setVAInfo.va);
+		} else {
+			/*
+			 * The queue pair is about to be unmapped by the VMX.
+			 */
+
+			result = vmci_qp_broker_unmap(setVAInfo.handle,
+						      vmciLinux->context, 0);
+		}
+
+		retval = copy_to_user(&info->result, &result, sizeof result);
+		if (retval)
+			retval = -EFAULT;
+
+		break;
+	}
+
+	case IOCTL_VMCI_QUEUEPAIR_SETPAGEFILE:{
+		struct vmci_qp_page_file_info pageFileInfo;
+		struct vmci_qp_page_file_info *info =
+			(struct vmci_qp_page_file_info *)ioarg;
+		int32_t result;
+
+		if (vmciLinux->userVersion < VMCI_VERSION_HOSTQP ||
+		    vmciLinux->userVersion >= VMCI_VERSION_NOVMVM) {
+			pr_info("IOCTL_VMCI_QUEUEPAIR_SETPAGEFILE not supported this VMX "
+				"(version=%d).", vmciLinux->userVersion);
+			retval = -EINVAL;
+			break;
+		}
+
+		if (vmciLinux->ctType != VMCIOBJ_CONTEXT) {
+			pr_info("IOCTL_VMCI_QUEUEPAIR_SETPAGEFILE only valid for contexts.");
+			retval = -EINVAL;
+			break;
+		}
+
+		retval =
+			copy_from_user(&pageFileInfo, (void *)ioarg,
+				       sizeof *info);
+		if (retval) {
+			retval = -EFAULT;
+			break;
+		}
+
+		/*
+		 * Communicate success pre-emptively to the caller.  Note that
+		 * the basic premise is that it is incumbent upon the caller not
+		 * to look at the info.result field until after the ioctl()
+		 * returns.  And then, only if the ioctl() result indicates no
+		 * error.  We send up the SUCCESS status before calling
+		 * SetPageStore() store because failing to copy up the result
+		 * code means unwinding the SetPageStore().
+		 *
+		 * It turns out the logic to unwind a SetPageStore() opens a can
+		 * of worms.  For example, if a host had created the QueuePair
+		 * and a guest attaches and SetPageStore() is successful but
+		 * writing success fails, then ... the host has to be stopped
+		 * from writing (anymore) data into the QueuePair.  That means
+		 * an additional test in the VMCI_Enqueue() code path.  Ugh.
+		 */
+
+		result = VMCI_SUCCESS;
+		retval =
+			copy_to_user(&info->result, &result, sizeof result);
+		if (retval == 0) {
+			result =
+				vmci_qp_broker_set_page_store
+				(pageFileInfo.handle,
+				 pageFileInfo.produceVA,
+				 pageFileInfo.consumeVA,
+				 vmciLinux->context);
+			if (result < VMCI_SUCCESS) {
+
+				retval =
+					copy_to_user(&info->result,
+						     &result,
+						     sizeof result);
+				if (retval != 0) {
+					/*
+					 * Note that in this case the SetPageStore() call
+					 * failed but we were unable to communicate that to the
+					 * caller (because the copy_to_user() call failed).
+					 * So, if we simply return an error (in this case
+					 * -EFAULT) then the caller will know that the
+					 * SetPageStore failed even though we couldn't put the
+					 * result code in the result field and indicate exactly
+					 * why it failed.
+					 *
+					 * That says nothing about the issue where we were once
+					 * able to write to the caller's info memory and now
+					 * can't.  Something more serious is probably going on
+					 * than the fact that SetPageStore() didn't work.
+					 */
+					retval = -EFAULT;
+				}
+			}
+
+		} else {
+			/*
+			 * In this case, we can't write a result field of the
+			 * caller's info block.  So, we don't even try to
+			 * SetPageStore().
+			 */
+			retval = -EFAULT;
+		}
+
+		break;
+	}
+
+	case IOCTL_VMCI_QUEUEPAIR_DETACH:{
+		struct vmci_qp_dtch_info detachInfo;
+		struct vmci_qp_dtch_info *info =
+			(struct vmci_qp_dtch_info *)ioarg;
+		int32_t result;
+
+		if (vmciLinux->ctType != VMCIOBJ_CONTEXT) {
+			pr_info("IOCTL_VMCI_QUEUEPAIR_DETACH only valid for contexts.");
+			retval = -EINVAL;
+			break;
+		}
+
+		retval =
+			copy_from_user(&detachInfo, (void *)ioarg,
+				       sizeof detachInfo);
+		if (retval) {
+			retval = -EFAULT;
+			break;
+		}
+
+		result =
+			vmci_qp_broker_detach(detachInfo.handle,
+					      vmciLinux->context);
+		if (result == VMCI_SUCCESS
+		    && vmciLinux->userVersion < VMCI_VERSION_NOVMVM) {
+			result = VMCI_SUCCESS_LAST_DETACH;
+		}
+
+		retval =
+			copy_to_user(&info->result, &result, sizeof result);
+		if (retval) {
+			retval = -EFAULT;
+		}
+
+		break;
+	}
+
+	case IOCTL_VMCI_CTX_ADD_NOTIFICATION:{
+		struct vmci_ctx_info arInfo;
+		struct vmci_ctx_info *info =
+			(struct vmci_ctx_info *)ioarg;
+		int32_t result;
+		uint32_t cid;
+
+		if (vmciLinux->ctType != VMCIOBJ_CONTEXT) {
+			pr_info( 
+			       "IOCTL_VMCI_CTX_ADD_NOTIFICATION only valid for contexts.");
+			retval = -EINVAL;
+			break;
+		}
+
+		retval =
+			copy_from_user(&arInfo, (void *)ioarg,
+				       sizeof arInfo);
+		if (retval) {
+			retval = -EFAULT;
+			break;
+		}
+
+		cid = vmci_ctx_get_id(vmciLinux->context);
+		result =
+			vmci_ctx_add_notification(cid, arInfo.remoteCID);
+		retval =
+			copy_to_user(&info->result, &result, sizeof result);
+		if (retval) {
+			retval = -EFAULT;
+			break;
+		}
+		break;
+	}
+
+	case IOCTL_VMCI_CTX_REMOVE_NOTIFICATION:{
+		struct vmci_ctx_info arInfo;
+		struct vmci_ctx_info *info =
+			(struct vmci_ctx_info *)ioarg;
+		int32_t result;
+		uint32_t cid;
+
+		if (vmciLinux->ctType != VMCIOBJ_CONTEXT) {
+			pr_info("IOCTL_VMCI_CTX_REMOVE_NOTIFICATION only valid for "
+				"contexts.");
+			retval = -EINVAL;
+			break;
+		}
+
+		retval =
+			copy_from_user(&arInfo, (void *)ioarg,
+				       sizeof arInfo);
+		if (retval) {
+			retval = -EFAULT;
+			break;
+		}
+
+		cid = vmci_ctx_get_id(vmciLinux->context);
+		result =
+			vmci_ctx_remove_notification(cid,
+						     arInfo.remoteCID);
+		retval =
+			copy_to_user(&info->result, &result, sizeof result);
+		if (retval) {
+			retval = -EFAULT;
+			break;
+		}
+		break;
+	}
+
+	case IOCTL_VMCI_CTX_GET_CPT_STATE:{
+		struct vmci_ctx_chkpt_buf_info getInfo;
+		uint32_t cid;
+		char *cptBuf;
+
+		if (vmciLinux->ctType != VMCIOBJ_CONTEXT) {
+			pr_info("IOCTL_VMCI_CTX_GET_CPT_STATE only valid for contexts.");
+			retval = -EINVAL;
+			break;
+		}
+
+		retval =
+			copy_from_user(&getInfo, (void *)ioarg,
+				       sizeof getInfo);
+		if (retval) {
+			retval = -EFAULT;
+			break;
+		}
+
+		cid = vmci_ctx_get_id(vmciLinux->context);
+		getInfo.result =
+			vmci_ctx_get_chkpt_state(cid,
+						 getInfo.cptType,
+						 &getInfo.bufSize,
+						 &cptBuf);
+		if (getInfo.result == VMCI_SUCCESS && getInfo.bufSize) {
+			retval = copy_to_user((void *)(uintptr_t)
+					      getInfo.cptBuf, cptBuf,
+					      getInfo.bufSize);
+			kfree(cptBuf);
+			if (retval) {
+				retval = -EFAULT;
+				break;
+			}
+		}
+		retval =
+			copy_to_user((void *)ioarg, &getInfo,
+				     sizeof getInfo);
+		if (retval) {
+			retval = -EFAULT;
+			break;
+		}
+		break;
+	}
+
+	case IOCTL_VMCI_CTX_SET_CPT_STATE:{
+		struct vmci_ctx_chkpt_buf_info setInfo;
+		uint32_t cid;
+		char *cptBuf;
+
+		if (vmciLinux->ctType != VMCIOBJ_CONTEXT) {
+			pr_info("IOCTL_VMCI_CTX_SET_CPT_STATE only valid for contexts.");
+			retval = -EINVAL;
+			break;
+		}
+
+		retval =
+			copy_from_user(&setInfo, (void *)ioarg,
+				       sizeof setInfo);
+		if (retval) {
+			retval = -EFAULT;
+			break;
+		}
+
+		cptBuf = kmalloc(setInfo.bufSize, GFP_KERNEL);
+		if (cptBuf == NULL) {
+			pr_info("Cannot allocate memory to set cpt state (type=%d).",
+			       setInfo.cptType);
+			retval = -ENOMEM;
+			break;
+		}
+		retval =
+			copy_from_user(cptBuf,
+				       (void *)(uintptr_t) setInfo.cptBuf,
+				       setInfo.bufSize);
+		if (retval) {
+			kfree(cptBuf);
+			retval = -EFAULT;
+			break;
+		}
+
+		cid = vmci_ctx_get_id(vmciLinux->context);
+		setInfo.result =
+			vmci_ctx_set_chkpt_state(cid,
+						 setInfo.cptType,
+						 setInfo.bufSize,
+						 cptBuf);
+		kfree(cptBuf);
+		retval =
+			copy_to_user((void *)ioarg, &setInfo,
+				     sizeof setInfo);
+		if (retval) {
+			retval = -EFAULT;
+			break;
+		}
+		break;
+	}
+
+	case IOCTL_VMCI_GET_CONTEXT_ID:{
+		uint32_t cid = VMCI_HOST_CONTEXT_ID;
+
+		retval = copy_to_user((void *)ioarg, &cid, sizeof cid);
+		break;
+	}
+
+	case IOCTL_VMCI_SET_NOTIFY:{
+		struct vmci_set_notify_info notifyInfo;
+
+		if (vmciLinux->ctType != VMCIOBJ_CONTEXT) {
+			pr_info("IOCTL_VMCI_SET_NOTIFY only valid for contexts.");
+			retval = -EINVAL;
+			break;
+		}
+
+		retval =
+			copy_from_user(&notifyInfo, (void *)ioarg,
+				       sizeof notifyInfo);
+		if (retval) {
+			retval = -EFAULT;
+			break;
+		}
+
+		if ((uintptr_t) notifyInfo.notifyUVA !=
+		    (uintptr_t) NULL) {
+			notifyInfo.result =
+				drv_setup_notify(vmciLinux->context,
+						 (uintptr_t)
+						 notifyInfo.notifyUVA);
+		} else {
+			spin_lock(&vmciLinux->context->lock);
+			vmci_ctx_unset_notify(vmciLinux->context);
+			spin_unlock(&vmciLinux->context->lock);
+			notifyInfo.result = VMCI_SUCCESS;
+		}
+
+		retval =
+			copy_to_user((void *)ioarg, &notifyInfo,
+				     sizeof notifyInfo);
+		if (retval) {
+			retval = -EFAULT;
+			break;
+		}
+
+		break;
+	}
+
+	case IOCTL_VMCI_NOTIFY_RESOURCE:{
+		struct vmci_dbell_notify_resource_info info;
+		uint32_t cid;
+
+		if (vmciLinux->userVersion < VMCI_VERSION_NOTIFY) {
+			pr_info("IOCTL_VMCI_NOTIFY_RESOURCE is invalid for current"
+				" VMX versions.");
+			retval = -EINVAL;
+			break;
+		}
+
+		if (vmciLinux->ctType != VMCIOBJ_CONTEXT) {
+			pr_info("IOCTL_VMCI_NOTIFY_RESOURCE is only valid for contexts.");
+			retval = -EINVAL;
+			break;
+		}
+
+		retval =
+			copy_from_user(&info, (void *)ioarg, sizeof info);
+		if (retval) {
+			retval = -EFAULT;
+			break;
+		}
+
+		cid = vmci_ctx_get_id(vmciLinux->context);
+		switch (info.action) {
+		case VMCI_NOTIFY_RESOURCE_ACTION_NOTIFY:
+			if (info.resource ==
+			    VMCI_NOTIFY_RESOURCE_DOOR_BELL) {
+				info.result =
+					vmci_ctx_notify_dbell(cid,
+							      info.
+							      handle,
+							      VMCI_NO_PRIVILEGE_FLAGS);
+			} else {
+				info.result = VMCI_ERROR_UNAVAILABLE;
+			}
+			break;
+		case VMCI_NOTIFY_RESOURCE_ACTION_CREATE:
+			info.result =
+				vmci_ctx_dbell_create(cid,
+						      info.handle);
+			break;
+		case VMCI_NOTIFY_RESOURCE_ACTION_DESTROY:
+			info.result =
+				vmci_ctx_dbell_destroy(cid,
+						       info.handle);
+			break;
+		default:
+			pr_info("IOCTL_VMCI_NOTIFY_RESOURCE got unknown action (action=%d).",
+				info.action);
+			info.result = VMCI_ERROR_INVALID_ARGS;
+		}
+		retval = copy_to_user((void *)ioarg, &info,
+				      sizeof info);
+		if (retval) {
+			retval = -EFAULT;
+			break;
+		}
+
+		break;
+	}
+
+	case IOCTL_VMCI_NOTIFICATIONS_RECEIVE:{
+		struct vmci_ctx_notify_recv_info info;
+		struct vmci_handle_arr *dbHandleArray;
+		struct vmci_handle_arr *qpHandleArray;
+		uint32_t cid;
+
+		if (vmciLinux->ctType != VMCIOBJ_CONTEXT) {
+			pr_info("IOCTL_VMCI_NOTIFICATIONS_RECEIVE is only valid for contexts.");
+			retval = -EINVAL;
+			break;
+		}
+
+		if (vmciLinux->userVersion < VMCI_VERSION_NOTIFY) {
+			pr_info("IOCTL_VMCI_NOTIFICATIONS_RECEIVE is not supported for the "
+				"current vmx version.");
+			retval = -EINVAL;
+			break;
+		}
+
+		retval =
+			copy_from_user(&info, (void *)ioarg, sizeof info);
+		if (retval) {
+			retval = -EFAULT;
+			break;
+		}
+
+		if ((info.dbHandleBufSize && !info.dbHandleBufUVA)
+		    || (info.qpHandleBufSize && !info.qpHandleBufUVA)) {
+			retval = -EINVAL;
+			break;
+		}
+
+		cid = vmci_ctx_get_id(vmciLinux->context);
+		info.result =
+			vmci_ctx_rcv_notifications_get(cid,
+						       &dbHandleArray,
+						       &qpHandleArray);
+		if (info.result == VMCI_SUCCESS) {
+			info.result = drv_cp_harray_to_user((void *)
+							    (uintptr_t)
+							    info.
+							    dbHandleBufUVA,
+							    &info.
+							    dbHandleBufSize,
+							    dbHandleArray,
+							    &retval);
+			if (info.result == VMCI_SUCCESS && !retval) {
+				info.result =
+					drv_cp_harray_to_user((void *)
+							      (uintptr_t)
+							      info.
+							      qpHandleBufUVA,
+							      &info.
+							      qpHandleBufSize,
+							      qpHandleArray,
+							      &retval);
+			}
+			if (!retval) {
+				retval =
+					copy_to_user((void *)ioarg,
+						     &info, sizeof info);
+			}
+			vmci_ctx_rcv_notifications_release
+				(cid, dbHandleArray, qpHandleArray,
+				 info.result == VMCI_SUCCESS && !retval);
+		} else {
+			retval =
+				copy_to_user((void *)ioarg, &info,
+					     sizeof info);
+		}
+		break;
+	}
+
+	default:
+		pr_warn("Unknown ioctl (iocmd=%d).", iocmd);
+		retval = -EINVAL;
+	}
+
+	return retval;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * PCI device support --
+ *
+ *      The following functions implement the support for the VMCI
+ *      guest device. This includes initializing the device and
+ *      interrupt handling.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * drv_dispatch_dgs --
+ *
+ *      Reads and dispatches incoming datagrams.
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      Reads data from the device.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static void drv_dispatch_dgs(unsigned long data)
+{
+	struct vmci_device *dev = (struct vmci_device *)data;
+
+	if (dev == NULL) {
+		pr_devel("No virtual device present in %s.", __func__);
+		return;
+	}
+
+	if (data_buffer == NULL) {
+		pr_devel("No buffer present in %s.", __func__);
+		return;
+	}
+
+	drv_read_dgs_from_port((int)0,
+			       dev->ioaddr + VMCI_DATA_IN_ADDR,
+			       data_buffer, data_buffer_size);
+}
+
+DECLARE_TASKLET(vmci_dg_tasklet, drv_dispatch_dgs, (unsigned long)&vmci_dev);
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * drv_process_bitmap --
+ *
+ *      Scans the notification bitmap for raised flags, clears them
+ *      and handles the notifications.
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
+static void drv_process_bitmap(unsigned long data)
+{
+	struct vmci_device *dev = (struct vmci_device *)data;
+
+	if (dev == NULL) {
+		pr_devel("No virtual device present in %s.", __func__);
+		return;
+	}
+
+	if (notification_bitmap == NULL) {
+		pr_devel("No bitmap present in %s.", __func__);
+		return;
+	}
+
+	vmci_dbell_scan_notification_entries(notification_bitmap);
+}
+
+DECLARE_TASKLET(vmci_bm_tasklet, drv_process_bitmap, (unsigned long)&vmci_dev);
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * drv_enable_msix --
+ *
+ *      Enable MSI-X.  Try exclusive vectors first, then shared vectors.
+ *
+ * Results:
+ *      0 on success, other error codes on failure.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static int drv_enable_msix(struct pci_dev *pdev)	// IN
+{
+	int i;
+	int result;
+
+	for (i = 0; i < VMCI_MAX_INTRS; ++i) {
+		vmci_dev.msix_entries[i].entry = i;
+		vmci_dev.msix_entries[i].vector = i;
+	}
+
+	result = pci_enable_msix(pdev, vmci_dev.msix_entries, VMCI_MAX_INTRS);
+	if (result == 0)
+		vmci_dev.exclusive_vectors = true;
+	else if (result > 0)
+		result = pci_enable_msix(pdev, vmci_dev.msix_entries, 1);
+
+	return result;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * drv_interrupt --
+ *
+ *      Interrupt handler for legacy or MSI interrupt, or for first MSI-X
+ *      interrupt (vector VMCI_INTR_DATAGRAM).
+ *
+ * Results:
+ *      COMPAT_IRQ_HANDLED if the interrupt is handled, COMPAT_IRQ_NONE if
+ *      not an interrupt.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static irqreturn_t drv_interrupt(int irq,	// IN
+				 void *clientdata)	// IN
+{
+	struct vmci_device *dev = clientdata;
+
+	if (dev == NULL) {
+		pr_devel("Irq %d for unknown device in %s.", irq, __func__);
+		return IRQ_NONE;
+	}
+
+	/*
+	 * If we are using MSI-X with exclusive vectors then we simply schedule
+	 * the datagram tasklet, since we know the interrupt was meant for us.
+	 * Otherwise we must read the ICR to determine what to do.
+	 */
+
+	if (dev->intr_type == VMCI_INTR_TYPE_MSIX && dev->exclusive_vectors) {
+		tasklet_schedule(&vmci_dg_tasklet);
+	} else {
+		unsigned int icr;
+
+		ASSERT(dev->intr_type == VMCI_INTR_TYPE_INTX ||
+		       dev->intr_type == VMCI_INTR_TYPE_MSI);
+
+		/* Acknowledge interrupt and determine what needs doing. */
+		icr = inl(dev->ioaddr + VMCI_ICR_ADDR);
+		if (icr == 0 || icr == ~0)
+			return IRQ_NONE;
+
+		if (icr & VMCI_ICR_DATAGRAM) {
+			tasklet_schedule(&vmci_dg_tasklet);
+			icr &= ~VMCI_ICR_DATAGRAM;
+		}
+
+		if (icr & VMCI_ICR_NOTIFICATION) {
+			tasklet_schedule(&vmci_bm_tasklet);
+			icr &= ~VMCI_ICR_NOTIFICATION;
+		}
+
+		if (icr != 0)
+			pr_info("Ignoring unknown interrupt cause (%d).", icr);
+	}
+
+	return IRQ_HANDLED;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * drv_interrupt_bm --
+ *
+ *      Interrupt handler for MSI-X interrupt vector VMCI_INTR_NOTIFICATION,
+ *      which is for the notification bitmap.  Will only get called if we are
+ *      using MSI-X with exclusive vectors.
+ *
+ * Results:
+ *      COMPAT_IRQ_HANDLED if the interrupt is handled, COMPAT_IRQ_NONE if
+ *      not an interrupt.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static irqreturn_t drv_interrupt_bm(int irq,	// IN
+				    void *clientdata)	// IN
+{
+	struct vmci_device *dev = clientdata;
+
+	if (dev == NULL) {
+		pr_devel("Irq %d for unknown device in %s.", irq, __func__);
+		return IRQ_NONE;
+	}
+
+	/* For MSI-X we can just assume it was meant for us. */
+	ASSERT(dev->intr_type == VMCI_INTR_TYPE_MSIX && dev->exclusive_vectors);
+	tasklet_schedule(&vmci_bm_tasklet);
+
+	return IRQ_HANDLED;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * drv_probe_device --
+ *
+ *      Most of the initialization at module load time is done here.
+ *
+ * Results:
+ *      Returns 0 for success, an error otherwise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static int __devinit drv_probe_device(struct pci_dev *pdev,	// IN: vmci PCI device
+				      const struct pci_device_id *id)	// IN: matching device ID
+{
+	unsigned int ioaddr;
+	unsigned int ioaddr_size;
+	unsigned int capabilities;
+	int result;
+
+	pr_info("Probing for vmci/PCI.");
+
+	result = pci_enable_device(pdev);
+	if (result) {
+		printk(KERN_ERR "Cannot enable VMCI device %s: error %d",
+		       pci_name(pdev), result);
+		return result;
+	}
+	pci_set_master(pdev);	/* To enable QueuePair functionality. */
+	ioaddr = pci_resource_start(pdev, 0);
+	ioaddr_size = pci_resource_len(pdev, 0);
+
+	/*
+	 * Request I/O region with adjusted base address and size. The adjusted
+	 * values are needed and used if we release the region in case of failure.
+	 */
+
+	if (!request_region(ioaddr, ioaddr_size, MODULE_NAME)) {
+		pr_info(MODULE_NAME ": Another driver already loaded "
+			"for device in slot %s.", pci_name(pdev));
+		goto pci_disable;
+	}
+
+	pr_info("Found VMCI PCI device at %#x, irq %u.", ioaddr, pdev->irq);
+
+	/*
+	 * Verify that the VMCI Device supports the capabilities that
+	 * we need. If the device is missing capabilities that we would
+	 * like to use, check for fallback capabilities and use those
+	 * instead (so we can run a new VM on old hosts). Fail the load if
+	 * a required capability is missing and there is no fallback.
+	 *
+	 * Right now, we need datagrams. There are no fallbacks.
+	 */
+	capabilities = inl(ioaddr + VMCI_CAPS_ADDR);
+
+	if ((capabilities & VMCI_CAPS_DATAGRAM) == 0) {
+		pr_err("Device does not support datagrams.");
+		goto release;
+	}
+
+	/*
+	 * If the hardware supports notifications, we will use that as
+	 * well.
+	 */
+	if (capabilities & VMCI_CAPS_NOTIFICATIONS) {
+		capabilities = VMCI_CAPS_DATAGRAM;
+		notification_bitmap = vmalloc(PAGE_SIZE);
+		if (notification_bitmap == NULL) {
+			pr_err("Device unable to allocate notification bitmap.");
+		} else {
+			memset(notification_bitmap, 0, PAGE_SIZE);
+			capabilities |= VMCI_CAPS_NOTIFICATIONS;
+		}
+	} else {
+		capabilities = VMCI_CAPS_DATAGRAM;
+	}
+	pr_info("Using capabilities 0x%x.", capabilities);
+
+	/* Let the host know which capabilities we intend to use. */
+	outl(capabilities, ioaddr + VMCI_CAPS_ADDR);
+
+	/* Device struct initialization. */
+	mutex_lock(&vmci_dev.lock);
+	if (vmci_dev.enabled) {
+		pr_err("Device already enabled.");
+		goto unlock;
+	}
+
+	vmci_dev.ioaddr = ioaddr;
+	vmci_dev.ioaddr_size = ioaddr_size;
+	atomic_set(&vmci_dev.datagrams_allowed, 1);
+
+	/*
+	 * Register notification bitmap with device if that capability is
+	 * used
+	 */
+	if (capabilities & VMCI_CAPS_NOTIFICATIONS) {
+		unsigned long bitmapPPN;
+		bitmapPPN = page_to_pfn(vmalloc_to_page(notification_bitmap));
+		if (!vmci_dbell_register_notification_bitmap(bitmapPPN)) {
+			pr_err("VMCI device unable to register notification bitmap "
+			       "with PPN 0x%x.", (uint32_t) bitmapPPN);
+			goto datagram_disallow;
+		}
+	}
+
+	/* Check host capabilities. */
+	if (!drv_check_host_caps()) {
+		goto remove_bitmap;
+	}
+
+	/* Enable device. */
+	vmci_dev.enabled = true;
+	pci_set_drvdata(pdev, &vmci_dev);
+
+	/*
+	 * We do global initialization here because we need datagrams
+	 * during drv_util_init, since it registers for VMCI events. If we
+	 * ever support more than one VMCI device we will have to create
+	 * seperate LateInit/EarlyExit functions that can be used to do
+	 * initialization/cleanup that depends on the device being
+	 * accessible.  We need to initialize VMCI components before
+	 * requesting an irq - the VMCI interrupt handler uses these
+	 * components, and it may be invoked once request_irq() has
+	 * registered the handler (as the irq line may be shared).
+	 */
+	drv_util_init();
+
+	if (vmci_qp_guest_endpoints_init() < VMCI_SUCCESS) {
+		goto util_exit;
+	}
+
+	/*
+	 * Enable interrupts.  Try MSI-X first, then MSI, and then fallback on
+	 * legacy interrupts.
+	 */
+	if (!vmci_disable_msix && !drv_enable_msix(pdev)) {
+		vmci_dev.intr_type = VMCI_INTR_TYPE_MSIX;
+		vmci_dev.irq = vmci_dev.msix_entries[0].vector;
+	} else if (!vmci_disable_msi && !pci_enable_msi(pdev)) {
+		vmci_dev.intr_type = VMCI_INTR_TYPE_MSI;
+		vmci_dev.irq = pdev->irq;
+	} else {
+		vmci_dev.intr_type = VMCI_INTR_TYPE_INTX;
+		vmci_dev.irq = pdev->irq;
+	}
+
+	/* Request IRQ for legacy or MSI interrupts, or for first MSI-X vector. */
+	result = request_irq(vmci_dev.irq, drv_interrupt, IRQF_SHARED,
+			     MODULE_NAME, &vmci_dev);
+	if (result) {
+		pr_err("Irq %u in use: %d", vmci_dev.irq, result);
+		goto components_exit;
+	}
+
+	/*
+	 * For MSI-X with exclusive vectors we need to request an interrupt for each
+	 * vector so that we get a separate interrupt handler routine.  This allows
+	 * us to distinguish between the vectors.
+	 */
+
+	if (vmci_dev.exclusive_vectors) {
+		ASSERT(vmci_dev.intr_type == VMCI_INTR_TYPE_MSIX);
+		result = request_irq(vmci_dev.msix_entries[1].vector,
+				     drv_interrupt_bm, 0, MODULE_NAME,
+				     &vmci_dev);
+		if (result) {
+			pr_err("Irq %u in use: %d",
+			       vmci_dev.msix_entries[1].vector, result);
+			free_irq(vmci_dev.irq, &vmci_dev);
+			goto components_exit;
+		}
+	}
+
+	pr_info("Registered device.");
+	atomic_inc(&guestDeviceActive);
+	mutex_unlock(&vmci_dev.lock);
+
+	/* Enable specific interrupt bits. */
+	if (capabilities & VMCI_CAPS_NOTIFICATIONS) {
+		outl(VMCI_IMR_DATAGRAM | VMCI_IMR_NOTIFICATION,
+		     vmci_dev.ioaddr + VMCI_IMR_ADDR);
+	} else {
+		outl(VMCI_IMR_DATAGRAM, vmci_dev.ioaddr + VMCI_IMR_ADDR);
+	}
+
+	/* Enable interrupts. */
+	outl(VMCI_CONTROL_INT_ENABLE, vmci_dev.ioaddr + VMCI_CONTROL_ADDR);
+
+	return 0;
+
+components_exit:
+	vmci_qp_guest_endpoints_exit();
+util_exit:
+	vmci_util_exit();
+	vmci_dev.enabled = false;
+	if (vmci_dev.intr_type == VMCI_INTR_TYPE_MSIX)
+		pci_disable_msix(pdev);
+	else if (vmci_dev.intr_type == VMCI_INTR_TYPE_MSI)
+		pci_disable_msi(pdev);
+
+remove_bitmap:
+	if (notification_bitmap)
+		outl(VMCI_CONTROL_RESET, vmci_dev.ioaddr + VMCI_CONTROL_ADDR);
+
+datagram_disallow:
+	atomic_set(&vmci_dev.datagrams_allowed, 0);
+unlock:
+	mutex_unlock(&vmci_dev.lock);
+release:
+	if (notification_bitmap) {
+		vfree(notification_bitmap);
+		notification_bitmap = NULL;
+	}
+	release_region(ioaddr, ioaddr_size);
+pci_disable:
+	pci_disable_device(pdev);
+	return -EBUSY;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * drv_remove_device --
+ *
+ *      Cleanup, called for each device on unload.
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
+static void __devexit drv_remove_device(struct pci_dev *pdev)
+{
+	struct vmci_device *dev = pci_get_drvdata(pdev);
+
+	pr_info("Removing device");
+	atomic_dec(&guestDeviceActive);
+	vmci_qp_guest_endpoints_exit();
+	vmci_util_exit();
+	mutex_lock(&dev->lock);
+	atomic_set(&vmci_dev.datagrams_allowed, 0);
+	pr_info("Resetting vmci device");
+	outl(VMCI_CONTROL_RESET, vmci_dev.ioaddr + VMCI_CONTROL_ADDR);
+
+	/*
+	 * Free IRQ and then disable MSI/MSI-X as appropriate.  For MSI-X, we might
+	 * have multiple vectors, each with their own IRQ, which we must free too.
+	 */
+	free_irq(dev->irq, dev);
+	if (dev->intr_type == VMCI_INTR_TYPE_MSIX) {
+		if (dev->exclusive_vectors)
+			free_irq(dev->msix_entries[1].vector, dev);
+
+		pci_disable_msix(pdev);
+	} else if (dev->intr_type == VMCI_INTR_TYPE_MSI) {
+		pci_disable_msi(pdev);
+	}
+	dev->exclusive_vectors = false;
+	dev->intr_type = VMCI_INTR_TYPE_INTX;
+
+	release_region(dev->ioaddr, dev->ioaddr_size);
+	dev->enabled = false;
+	if (notification_bitmap) {
+		/*
+		 * The device reset above cleared the bitmap state of the
+		 * device, so we can safely free it here.
+		 */
+
+		vfree(notification_bitmap);
+		notification_bitmap = NULL;
+	}
+
+	pr_info("Unregistered device.");
+	mutex_unlock(&dev->lock);
+
+	pci_disable_device(pdev);
+}
+
+static struct pci_driver vmci_driver = {
+	.name = MODULE_NAME,
+	.id_table = vmci_ids,
+	.probe = drv_probe_device,
+	.remove = __devexit_p(drv_remove_device),
+};
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * dev_guest_init --
+ *
+ *      Initializes the VMCI PCI device. The initialization might fail
+ *      if there is no VMCI PCI device.
+ *
+ * Results:
+ *      0 on success, other error codes on failure.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static int __init dev_guest_init(void)
+{
+	int retval;
+
+	/* Initialize guest device data. */
+	mutex_init(&vmci_dev.lock);
+	vmci_dev.intr_type = VMCI_INTR_TYPE_INTX;
+	vmci_dev.exclusive_vectors = false;
+	spin_lock_init(&vmci_dev.dev_spinlock);
+	vmci_dev.enabled = false;
+	atomic_set(&vmci_dev.datagrams_allowed, 0);
+	atomic_set(&guestDeviceActive, 0);
+
+	data_buffer = vmalloc(data_buffer_size);
+	if (!data_buffer)
+		return -ENOMEM;
+
+	/* This should be last to make sure we are done initializing. */
+	retval = pci_register_driver(&vmci_driver);
+	if (retval < 0) {
+		vfree(data_buffer);
+		data_buffer = NULL;
+		return retval;
+	}
+
+	return 0;
+}
+
+static const struct file_operations vmuser_fops = {
+	.owner = THIS_MODULE,
+	.open = drv_driver_open,
+	.release = drv_driver_close,
+	.poll = drv_driver_poll,
+	.unlocked_ioctl = drv_driver_unlocked_ioctl,
+	.compat_ioctl = drv_driver_unlocked_ioctl,
+};
+
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * vmci_send_dg --
+ *
+ *      VM to hypervisor call mechanism. We use the standard VMware naming
+ *      convention since shared code is calling this function as well.
+ *
+ * Results:
+ *      The result of the hypercall.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+int vmci_send_dg(struct vmci_dg *dg)
+{
+	unsigned long flags;
+	int result;
+
+	/* Check args. */
+	if (dg == NULL)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	if (atomic_read(&vmci_dev.datagrams_allowed) == 0)
+		return VMCI_ERROR_UNAVAILABLE;
+
+	/*
+	 * Need to acquire spinlock on the device because
+	 * the datagram data may be spread over multiple pages and the monitor may
+	 * interleave device user rpc calls from multiple VCPUs. Acquiring the
+	 * spinlock precludes that possibility. Disabling interrupts to avoid
+	 * incoming datagrams during a "rep out" and possibly landing up in this
+	 * function.
+	 */
+	spin_lock_irqsave(&vmci_dev.dev_spinlock, flags);
+
+	/*
+	 * Send the datagram and retrieve the return value from the result register.
+	 */
+	__asm__ __volatile__("cld\n\t" "rep outsb\n\t":	/* No output. */
+			     :"d"(vmci_dev.ioaddr + VMCI_DATA_OUT_ADDR),
+			      "c"(VMCI_DG_SIZE(dg)), "S"(dg)
+		);
+
+	/*
+	 * XXX Should read result high port as well when updating handlers to
+	 * return 64bit.
+	 */
+	result = inl(vmci_dev.ioaddr + VMCI_RESULT_LOW_ADDR);
+	spin_unlock_irqrestore(&vmci_dev.dev_spinlock, flags);
+
+	return result;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * vmci_guest_code_active --
+ *
+ *      Determines whether the VMCI PCI device has been successfully
+ *      initialized.
+ *
+ * Results:
+ *      true, if VMCI guest device is operational, false otherwise.
+ *
+ * Side effects:
+ *      Reads data from the device.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+bool vmci_guest_code_active(void)
+{
+	return guestDeviceInit && atomic_read(&guestDeviceActive) > 0;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * vmci_host_code_active --
+ *
+ *      Determines whether the VMCI host personality is
+ *      available. Since the core functionality of the host driver is
+ *      always present, all guests could possibly use the host
+ *      personality. However, to minimize the deviation from the
+ *      pre-unified driver state of affairs, we only consider the host
+ *      device active, if there is no active guest device, or if there
+ *      are VMX'en with active VMCI contexts using the host device.
+ *
+ * Results:
+ *      true, if VMCI host driver is operational, false otherwise.
+ *
+ * Side effects:
+ *      Reads data from the device.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+bool vmci_host_code_active(void)
+{
+	return hostDeviceInit &&
+		(!vmci_guest_code_active() ||
+		 atomic_read(&linuxState.activeContexts) > 0);
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * drv_init --
+ *
+ *      linux module entry point. Called by /sbin/insmod command
+ *
+ * Results:
+ *      registers a device driver for a major # that depends
+ *      on the uid. Add yourself to that list.  List is now in
+ *      private/driver-private.c.
+ *
+ *----------------------------------------------------------------------
+ */
+
+static int __init drv_init(void)
+{
+	int retval;
+
+	retval = drv_shared_init();
+	if (retval != VMCI_SUCCESS) {
+		pr_warn("Failed to initialize common "
+			"components (err=%d).", retval);
+		return -ENOMEM;
+	}
+
+	if (!vmci_disable_guest) {
+		retval = dev_guest_init();
+		if (retval != 0) {
+			pr_warn("Failed to initialize guest "
+				"personality (err=%d).", retval);
+		} else {
+			const char *state = vmci_guest_code_active()?
+				"active" : "inactive";
+			guestDeviceInit = true;
+			pr_info("Guest personality initialized and is "
+				"%s.", state);
+		}
+	}
+
+	if (!vmci_disable_host) {
+		retval = drv_host_init();
+		if (retval != 0) {
+			pr_warn("Unable to initialize host "
+				"personality (err=%d).", retval);
+		} else {
+			hostDeviceInit = true;
+			pr_info("Initialized host personality");
+		}
+	}
+
+	if (!guestDeviceInit && !hostDeviceInit) {
+		drv_shared_cleanup();
+		return -ENODEV;
+	}
+
+	pr_info("Module is initialized");
+	return 0;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * drv_exit --
+ *
+ *      Called by /sbin/rmmod
+ *
+ *
+ *----------------------------------------------------------------------
+ */
+
+static void __exit drv_exit(void)
+{
+	if (guestDeviceInit) {
+		pci_unregister_driver(&vmci_driver);
+		vfree(data_buffer);
+		guestDeviceInit = false;
+	}
+
+	if (hostDeviceInit) {
+		drv_host_cleanup();
+
+		if (misc_deregister(&linuxState.misc))
+			pr_warn("Error unregistering");
+		else
+			pr_info("Module unloaded");
+
+		hostDeviceInit = false;
+	}
+
+	drv_shared_cleanup();
+}
+
+module_init(drv_init);
+module_exit(drv_exit);
+MODULE_DEVICE_TABLE(pci, vmci_ids);
+
+module_param_named(disable_host, vmci_disable_host, bool, 0);
+MODULE_PARM_DESC(disable_host, "Disable driver host personality - (default=0)");
+
+module_param_named(disable_guest, vmci_disable_guest, bool, 0);
+MODULE_PARM_DESC(disable_guest,
+		 "Disable driver guest personality - (default=0)");
+
+module_param_named(disable_msi, vmci_disable_msi, bool, 0);
+MODULE_PARM_DESC(disable_msi, "Disable MSI use in driver - (default=0)");
+
+module_param_named(disable_msix, vmci_disable_msix, bool, 0);
+MODULE_PARM_DESC(disable_msix, "Disable MSI-X use in driver - (default=0)");
+
+MODULE_AUTHOR("VMware, Inc.");
+MODULE_DESCRIPTION("VMware Virtual Machine Communication Interface.");
+MODULE_VERSION(VMCI_DRIVER_VERSION_STRING);
+MODULE_LICENSE("GPL v2");
+
+/*
+ * Starting with SLE10sp2, Novell requires that IHVs sign a support agreement
+ * with them and mark their kernel modules as externally supported via a
+ * change to the module header. If this isn't done, the module will not load
+ * by default (i.e., neither mkinitrd nor modprobe will accept it).
+ */
+MODULE_INFO(supported, "external");
diff --git a/drivers/misc/vmw_vmci/vmci_driver.h b/drivers/misc/vmw_vmci/vmci_driver.h
new file mode 100644
index 0000000..91cc0bf
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmci_driver.h
@@ -0,0 +1,52 @@
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
+#ifndef _VMCI_DRIVER_H_
+#define _VMCI_DRIVER_H_
+
+#include <linux/vmw_vmci_defs.h>
+#include <linux/wait.h>
+
+#include "vmci_context.h"
+#include "vmci_queue_pair.h"
+
+enum vmci_obj_type {
+	VMCIOBJ_VMX_VM = 10,
+	VMCIOBJ_CONTEXT,
+	VMCIOBJ_SOCKET,
+	VMCIOBJ_NOT_SET,
+};
+
+/* For storing VMCI structures in file handles. */
+struct vmci_obj {
+	void *ptr;
+	enum vmci_obj_type type;
+};
+
+typedef void (VMCIWorkFn) (void *data);
+bool vmci_host_code_active(void);
+bool vmci_guest_code_active(void);
+bool vmci_drv_wait_on_event_intr(wait_queue_head_t * event,
+				 VMCIEventReleaseCB releaseCB,
+				 void *clientData);
+int vmci_drv_schedule_delayed_work(VMCIWorkFn * workFn, void *data);
+uint32_t VMCI_GetContextID(void);
+int vmci_send_dg(struct vmci_dg *dg);
+
+#endif				// _VMCI_DRIVER_H_
-- 
1.7.0.4

