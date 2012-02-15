Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761461Ab2BOBOI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 20:14:08 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:43536 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757453Ab2BOBOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 20:14:05 -0500
X-Greylist: delayed 477 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Feb 2012 20:14:05 EST
From: "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
To: linux-kernel@vger.kernel.org
Cc: vm-crosstalk@vmware.com, dtor@vmware.com, cschamp@vmware.com,
        "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
Subject: [PATCH 04/14] Add vmciDriver.*
Date: Tue, 14 Feb 2012 17:05:45 -0800
Message-Id: <1329267955-32367-5-git-send-email-astiegmann@vmware.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1329267955-32367-1-git-send-email-astiegmann@vmware.com>
References: <1329267955-32367-1-git-send-email-astiegmann@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/misc/vmw_vmci/vmciDriver.c |  663 ++++++++++++++++++++++++++++++++++++
 drivers/misc/vmw_vmci/vmciDriver.h |   57 +++
 2 files changed, 720 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/vmw_vmci/vmciDriver.c
 create mode 100644 drivers/misc/vmw_vmci/vmciDriver.h

diff --git a/drivers/misc/vmw_vmci/vmciDriver.c b/drivers/misc/vmw_vmci/vmciDriver.c
new file mode 100644
index 0000000..e121d6d
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmciDriver.c
@@ -0,0 +1,663 @@
+/*
+ *
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
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include "vmci_defs.h"
+#include "vmci_infrastructure.h"
+#include "vmci_kernel_if.h"
+#include "vmciCommonInt.h"
+#include "vmciContext.h"
+#include "vmciDatagram.h"
+#include "vmciDoorbell.h"
+#include "vmciDriver.h"
+#include "vmciEvent.h"
+#include "vmciHashtable.h"
+#include "vmciKernelAPI.h"
+#include "vmciQueuePair.h"
+#include "vmciResource.h"
+
+#define LGPFX "VMCI: "
+#define VMCI_UTIL_NUM_RESOURCES 1
+
+static uint32_t ctxUpdateSubID = VMCI_INVALID_ID;
+static struct vmci_context *hostContext;
+static atomic_t vmContextID = { VMCI_INVALID_ID };
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCI_HostInit --
+ *
+ *      Initializes the host driver specific components of VMCI.
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
+int VMCI_HostInit(void)
+{
+	int result;
+
+	/*
+	 * In theory, it is unsafe to pass an eventHnd of -1 to platforms which use
+	 * it (VMKernel/Windows/Mac OS at the time of this writing). In practice we
+	 * are fine though, because the event is never used in the case of the host
+	 * context.
+	 */
+	result = VMCIContext_InitContext(VMCI_HOST_CONTEXT_ID,
+					 VMCI_DEFAULT_PROC_PRIVILEGE_FLAGS,
+					 -1, VMCI_VERSION, NULL, &hostContext);
+	if (result < VMCI_SUCCESS) {
+		VMCI_WARNING((LGPFX
+			      "Failed to initialize VMCIContext (result=%d).\n",
+			      result));
+		goto errorExit;
+	}
+
+	result = VMCIQPBroker_Init();
+	if (result < VMCI_SUCCESS) {
+		goto hostContextExit;
+	}
+
+	VMCI_LOG((LGPFX "host components initialized.\n"));
+	return VMCI_SUCCESS;
+
+ hostContextExit:
+	VMCIContext_ReleaseContext(hostContext);
+ errorExit:
+	return result;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCI_HostCleanup --
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
+void VMCI_HostCleanup(void)
+{
+	VMCIContext_ReleaseContext(hostContext);
+	VMCIQPBroker_Exit();
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
+	if (!VMCI_DeviceEnabled()) {
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
+ *      None.
+ *
+ * XXX: Remove me?  Used by vsock?
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
+ * VMCIUtilCidUpdate --
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
+static void VMCIUtilCidUpdate(uint32_t subID,	// IN:
+			      struct vmci_event_data *eventData,	// IN:
+			      void *clientData)	// IN:
+{
+	struct vmci_event_payld_ctx *evPayload =
+	    VMCIEventDataPayload(eventData);
+
+	if (subID != ctxUpdateSubID) {
+		VMCI_DEBUG_LOG(4,
+			       (LGPFX "Invalid subscriber (ID=0x%x).\n",
+				subID));
+		return;
+	}
+
+	if (eventData == NULL || evPayload->contextID == VMCI_INVALID_ID) {
+		VMCI_DEBUG_LOG(4, (LGPFX "Invalid event data.\n"));
+		return;
+	}
+
+	VMCI_LOG((LGPFX
+		  "Updating context from (ID=0x%x) to (ID=0x%x) on event "
+		  "(type=%d).\n", atomic_read(&vmContextID),
+		  evPayload->contextID, eventData->event));
+	atomic_set(&vmContextID, evPayload->contextID);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIUtil_Init --
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
+void VMCIUtil_Init(void)
+{
+	/*
+	 * We subscribe to the VMCI_EVENT_CTX_ID_UPDATE here so we can update the
+	 * internal context id when needed.
+	 */
+	if (VMCIEvent_Subscribe
+	    (VMCI_EVENT_CTX_ID_UPDATE, VMCI_FLAG_EVENT_NONE,
+	     VMCIUtilCidUpdate, NULL, &ctxUpdateSubID) < VMCI_SUCCESS) {
+		VMCI_WARNING((LGPFX
+			      "Failed to subscribe to event (type=%d).\n",
+			      VMCI_EVENT_CTX_ID_UPDATE));
+	}
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIUtil_Exit --
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
+void VMCIUtil_Exit(void)
+{
+	if (VMCIEvent_Unsubscribe(ctxUpdateSubID) < VMCI_SUCCESS) {
+		VMCI_WARNING((LGPFX
+			      "Failed to unsubscribe to event (type=%d) with "
+			      "subscriber (ID=0x%x).\n",
+			      VMCI_EVENT_CTX_ID_UPDATE, ctxUpdateSubID));
+	}
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIUtil_CheckHostCapabilities --
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
+static bool VMCIUtilCheckHostCapabilities(void)
+{
+	int result;
+	struct vmci_rscs_query_msg *msg;
+	uint32_t msgSize = sizeof(struct vmci_rsrc_query_hdr) +
+	    VMCI_UTIL_NUM_RESOURCES * sizeof(uint32_t);
+	struct vmci_datagram *checkMsg = kmalloc(msgSize, GFP_KERNEL);
+
+	if (checkMsg == NULL) {
+		VMCI_WARNING((LGPFX "Check host: Insufficient memory.\n"));
+		return false;
+	}
+
+	checkMsg->dst = VMCI_MAKE_HANDLE(VMCI_HYPERVISOR_CONTEXT_ID,
+					 VMCI_RESOURCES_QUERY);
+	checkMsg->src = VMCI_ANON_SRC_HANDLE;
+	checkMsg->payloadSize = msgSize - VMCI_DG_HEADERSIZE;
+	msg = (struct vmci_rscs_query_msg *)VMCI_DG_PAYLOAD(checkMsg);
+
+	msg->numResources = VMCI_UTIL_NUM_RESOURCES;
+	msg->resources[0] = VMCI_GET_CONTEXT_ID;
+
+	result = VMCI_SendDatagram(checkMsg);
+	kfree(checkMsg);
+
+	/* We need the vector. There are no fallbacks. */
+	return (result == 0x1);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCI_CheckHostCapabilities --
+ *
+ *      Tell host which guestcalls we support and let each API check
+ *      that the host supports the hypercalls it needs. If a hypercall
+ *      is not supported, the API can check for a fallback hypercall,
+ *      or fail the check.
+ *
+ * Results:
+ *      true if successful, false otherwise.
+ *
+ * Side effects:
+ *      Fallback mechanisms may be enabled in the API and vmmon.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+bool VMCI_CheckHostCapabilities(void)
+{
+	bool result = VMCIUtilCheckHostCapabilities();
+
+	VMCI_LOG((LGPFX "Host capability check: %s.\n",
+		  result ? "PASSED" : "FAILED"));
+
+	return result;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCI_ReadDatagramsFromPort --
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
+void VMCI_ReadDatagramsFromPort(int ioHandle,	// IN
+				unsigned short int dgInPort,	// IN
+				uint8_t * dgInBuffer,	// IN
+				size_t dgInBufferSize)	// IN
+{
+	struct vmci_datagram *dg;
+	size_t currentDgInBufferSize = PAGE_SIZE;
+	size_t remainingBytes;
+
+	ASSERT(dgInBufferSize >= PAGE_SIZE);
+
+	insb(dgInPort, dgInBuffer, currentDgInBufferSize);
+	dg = (struct vmci_datagram *)dgInBuffer;
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
+			dg = (struct vmci_datagram *)roundup((uintptr_t)
+							     dg + 1, PAGE_SIZE);
+			ASSERT((uint8_t *) dg <
+			       dgInBuffer + currentDgInBufferSize);
+			remainingBytes =
+			    (size_t) (dgInBuffer + currentDgInBufferSize -
+				      (uint8_t *) dg);
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
+					dg = (struct vmci_datagram *)
+					    dgInBuffer;
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
+				result = VMCIEvent_Dispatch(dg);
+			} else {
+				result = VMCIDatagram_InvokeGuestHandler(dg);
+			}
+			if (result < VMCI_SUCCESS) {
+				VMCI_DEBUG_LOG(4,
+					       (LGPFX
+						"Datagram with resource (ID=0x%x) failed "
+						"(err=%d).\n",
+						dg->dst.resource, result));
+			}
+
+			/* On to the next datagram. */
+			dg = (struct vmci_datagram *)((uint8_t *) dg +
+						      dgInSize);
+		} else {
+			size_t bytesToSkip;
+
+			/* Datagram doesn't fit in datagram buffer of maximal size. We drop it. */
+			VMCI_DEBUG_LOG(4,
+				       (LGPFX
+					"Failed to receive datagram (size=%u bytes).\n",
+					dgInSize));
+
+			bytesToSkip = dgInSize - remainingBytes;
+			if (currentDgInBufferSize != dgInBufferSize)
+				currentDgInBufferSize = dgInBufferSize;
+
+			for (;;) {
+				insb(dgInPort, dgInBuffer,
+				     currentDgInBufferSize);
+				if (bytesToSkip <= currentDgInBufferSize) {
+					break;
+				}
+				bytesToSkip -= currentDgInBufferSize;
+			}
+			dg = (struct vmci_datagram *)(dgInBuffer + bytesToSkip);
+		}
+
+		remainingBytes =
+		    (size_t) (dgInBuffer + currentDgInBufferSize -
+			      (uint8_t *) dg);
+
+		if (remainingBytes < VMCI_DG_HEADERSIZE) {
+			/* Get the next batch of datagrams. */
+
+			insb(dgInPort, dgInBuffer, currentDgInBufferSize);
+			dg = (struct vmci_datagram *)dgInBuffer;
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
+	if (VMCI_GuestPersonalityActive()) {
+		if (atomic_read(&vmContextID) == VMCI_INVALID_ID) {
+			uint32_t result;
+			struct vmci_datagram getCidMsg;
+			getCidMsg.dst =
+			    VMCI_MAKE_HANDLE(VMCI_HYPERVISOR_CONTEXT_ID,
+					     VMCI_GET_CONTEXT_ID);
+			getCidMsg.src = VMCI_ANON_SRC_HANDLE;
+			getCidMsg.payloadSize = 0;
+			result = VMCI_SendDatagram(&getCidMsg);
+			atomic_set(&vmContextID, result);
+		}
+		return atomic_read(&vmContextID);
+	} else if (VMCI_HostPersonalityActive()) {
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
+ * VMCI_SharedInit --
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
+int VMCI_SharedInit(void)
+{
+	int result;
+
+	result = VMCIResource_Init();
+	if (result < VMCI_SUCCESS) {
+		VMCI_WARNING((LGPFX
+			      "Failed to initialize VMCIResource (result=%d).\n",
+			      result));
+		goto errorExit;
+	}
+
+	result = VMCIContext_Init();
+	if (result < VMCI_SUCCESS) {
+		VMCI_WARNING((LGPFX
+			      "Failed to initialize VMCIContext (result=%d).\n",
+			      result));
+		goto resourceExit;
+	}
+
+	result = VMCIDatagram_Init();
+	if (result < VMCI_SUCCESS) {
+		VMCI_WARNING((LGPFX
+			      "Failed to initialize VMCIDatagram (result=%d).\n",
+			      result));
+		goto resourceExit;
+	}
+
+	result = VMCIEvent_Init();
+	if (result < VMCI_SUCCESS) {
+		VMCI_WARNING((LGPFX
+			      "Failed to initialize VMCIEvent (result=%d).\n",
+			      result));
+		goto resourceExit;
+	}
+
+	result = VMCIDoorbell_Init();
+	if (result < VMCI_SUCCESS) {
+		VMCI_WARNING((LGPFX
+			      "Failed to initialize VMCIDoorbell (result=%d).\n",
+			      result));
+		goto eventExit;
+	}
+
+	VMCI_LOG((LGPFX "shared components initialized.\n"));
+	return VMCI_SUCCESS;
+
+ eventExit:
+	VMCIEvent_Exit();
+ resourceExit:
+	VMCIResource_Exit();
+ errorExit:
+	return result;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCI_SharedCleanup --
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
+void VMCI_SharedCleanup(void)
+{
+	VMCIEvent_Exit();
+	VMCIResource_Exit();
+}
diff --git a/drivers/misc/vmw_vmci/vmciDriver.h b/drivers/misc/vmw_vmci/vmciDriver.h
new file mode 100644
index 0000000..9f38bee
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmciDriver.h
@@ -0,0 +1,57 @@
+/*
+ *
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
+#include "vmci_defs.h"
+#include "vmci_infrastructure.h"
+#include "vmciContext.h"
+
+/*
+ * A few macros to encapsulate logging in common code. The macros
+ * result in LOG/LOGThrottled on vmkernel and Log on hosted.
+ */
+
+#define VMCI_DEBUG_LEVEL 4
+#define VMCI_DEBUG_LOG(_level, _args)		\
+  do {						\
+    if (_level < VMCI_DEBUG_LEVEL) {		\
+      Log _args ;				\
+    }						\
+  } while(false)
+#define VMCI_LOG(_args) Log _args
+#define VMCI_WARNING(_args) Warning _args
+
+int VMCI_SharedInit(void);
+void VMCI_SharedCleanup(void);
+int VMCI_HostInit(void);
+void VMCI_HostCleanup(void);
+uint32_t VMCI_GetContextID(void);
+int VMCI_SendDatagram(struct vmci_datagram *dg);
+
+void VMCIUtil_Init(void);
+void VMCIUtil_Exit(void);
+bool VMCI_CheckHostCapabilities(void);
+void VMCI_ReadDatagramsFromPort(int ioHandle, unsigned short int dgInPort,
+				uint8_t * dgInBuffer, size_t dgInBufferSize);
+bool VMCI_DeviceEnabled(void);
+
+#endif				// _VMCI_DRIVER_H_
-- 
1.7.0.4

