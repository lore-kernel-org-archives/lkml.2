Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696Ab2BOBOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 20:14:14 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:43544 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761445Ab2BOBOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 20:14:05 -0500
From: "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
To: linux-kernel@vger.kernel.org
Cc: vm-crosstalk@vmware.com, dtor@vmware.com, cschamp@vmware.com,
        "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
Subject: [PATCH 11/14] Add VMCI kernel API defs and the internal header file
Date: Tue, 14 Feb 2012 17:05:52 -0800
Message-Id: <1329267955-32367-12-git-send-email-astiegmann@vmware.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1329267955-32367-1-git-send-email-astiegmann@vmware.com>
References: <1329267955-32367-1-git-send-email-astiegmann@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/misc/vmw_vmci/vmciCommonInt.h  |  105 ++++++++++++++++++++++
 drivers/misc/vmw_vmci/vmciKernelAPI.h  |   28 ++++++
 drivers/misc/vmw_vmci/vmciKernelAPI1.h |  148 ++++++++++++++++++++++++++++++++
 drivers/misc/vmw_vmci/vmciKernelAPI2.h |   48 ++++++++++
 4 files changed, 329 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/vmw_vmci/vmciCommonInt.h
 create mode 100644 drivers/misc/vmw_vmci/vmciKernelAPI.h
 create mode 100644 drivers/misc/vmw_vmci/vmciKernelAPI1.h
 create mode 100644 drivers/misc/vmw_vmci/vmciKernelAPI2.h

diff --git a/drivers/misc/vmw_vmci/vmciCommonInt.h b/drivers/misc/vmw_vmci/vmciCommonInt.h
new file mode 100644
index 0000000..936c7f1
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmciCommonInt.h
@@ -0,0 +1,105 @@
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
+#ifndef _VMCI_COMMONINT_H_
+#define _VMCI_COMMONINT_H_
+
+#include "vmci_defs.h"
+#include "vmci_call_defs.h"
+#include "vmci_infrastructure.h"
+#include "vmci_handle_array.h"
+#include "vmci_kernel_if.h"
+
+/*
+ *  The struct datagram_queue_entry is a queue header for the in-kernel VMCI
+ *  datagram queues. It is allocated in non-paged memory, as the
+ *  content is accessed while holding a spinlock. The pending datagram
+ *  itself may be allocated from paged memory. We shadow the size of
+ *  the datagram in the non-paged queue entry as this size is used
+ *  while holding the same spinlock as above.
+ */
+
+struct datagram_queue_entry {
+	struct list_head listItem;	/* For queuing. */
+	size_t dgSize;		/* Size of datagram. */
+	struct vmci_datagram *dg;	/* Pending datagram. */
+};
+
+struct vmci_context {
+	struct list_head listItem;	/* For global VMCI list. */
+	uint32_t cid;
+	atomic_t refCount;
+	struct list_head datagramQueue;	/* Head of per VM queue. */
+	uint32_t pendingDatagrams;
+	size_t datagramQueueSize;	/* Size of datagram queue in bytes. */
+	int userVersion;	/*
+				 * Version of the code that created
+				 * this context; e.g., VMX.
+				 */
+	spinlock_t lock;	/* Locks callQueue and handleArrays. */
+	struct vmci_handle_arr *queuePairArray;	/*
+						 * QueuePairs attached to.  The array of
+						 * handles for queue pairs is accessed
+						 * from the code for QP API, and there
+						 * it is protected by the QP lock.  It
+						 * is also accessed from the context
+						 * clean up path, which does not
+						 * require a lock.  VMCILock is not
+						 * used to protect the QP array field.
+						 */
+	struct vmci_handle_arr *doorbellArray;	/* Doorbells created by context. */
+	struct vmci_handle_arr *pendingDoorbellArray;	/* Doorbells pending for context. */
+	struct vmci_handle_arr *notifierArray;	/* Contexts current context is subscribing to. */
+	struct vmci_host hostContext;
+	uint32_t privFlags;
+	uid_t user;
+	bool validUser;
+	bool *notify;		/* Notify flag pointer - hosted only. */
+	struct page *notifyPage;	/* Page backing the notify UVA. */
+};
+
+/*
+ *------------------------------------------------------------------------------
+ *
+ *  VMCIDenyInteraction --
+ *
+ *     Utilility function that checks whether two entities are allowed
+ *     to interact. If one of them is restricted, the other one must
+ *     be trusted.
+ *
+ *  Result:
+ *     true if the two entities are not allowed to interact. false otherwise.
+ *
+ *  Side effects:
+ *     None.
+ *
+ *------------------------------------------------------------------------------
+ */
+
+static inline bool VMCIDenyInteraction(uint32_t partOne,	// IN
+				       uint32_t partTwo)	// IN
+{
+	return (((partOne & VMCI_PRIVILEGE_FLAG_RESTRICTED) &&
+		 !(partTwo & VMCI_PRIVILEGE_FLAG_TRUSTED)) ||
+		((partTwo & VMCI_PRIVILEGE_FLAG_RESTRICTED) &&
+		 !(partOne & VMCI_PRIVILEGE_FLAG_TRUSTED)));
+}
+
+#endif				/* _VMCI_COMMONINT_H_ */
diff --git a/drivers/misc/vmw_vmci/vmciKernelAPI.h b/drivers/misc/vmw_vmci/vmciKernelAPI.h
new file mode 100644
index 0000000..7a6a964
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmciKernelAPI.h
@@ -0,0 +1,28 @@
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
+#ifndef __VMCI_KERNELAPI_H__
+#define __VMCI_KERNELAPI_H__
+
+/* With this file you always get the latest version. */
+#include "vmciKernelAPI1.h"
+#include "vmciKernelAPI2.h"
+
+#endif				/* !__VMCI_KERNELAPI_H__ */
diff --git a/drivers/misc/vmw_vmci/vmciKernelAPI1.h b/drivers/misc/vmw_vmci/vmciKernelAPI1.h
new file mode 100644
index 0000000..bf11a51
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmciKernelAPI1.h
@@ -0,0 +1,148 @@
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
+#ifndef __VMCI_KERNELAPI_1_H__
+#define __VMCI_KERNELAPI_1_H__
+
+#include "vmci_call_defs.h"
+#include "vmci_defs.h"
+
+/* VMCI module namespace on vmkernel. */
+#define MOD_VMCI_NAMESPACE "com.vmware.vmci"
+
+/* Define version 1. */
+#undef  VMCI_KERNEL_API_VERSION
+#define VMCI_KERNEL_API_VERSION_1 1
+#define VMCI_KERNEL_API_VERSION   VMCI_KERNEL_API_VERSION_1
+
+/* Macros to operate on the driver version number. */
+#define VMCI_MAJOR_VERSION(v) (((v) >> 16) & 0xffff)
+#define VMCI_MINOR_VERSION(v) ((v) & 0xffff)
+
+/* VMCI Device Usage API. */
+typedef void (VMCI_DeviceShutdownFn) (void *deviceRegistration, void *userData);
+
+bool VMCI_DeviceGet(uint32_t * apiVersion,
+		    VMCI_DeviceShutdownFn * deviceShutdownCB,
+		    void *userData, void **deviceRegistration);
+void VMCI_DeviceRelease(void *deviceRegistration);
+
+/* VMCI Datagram API. */
+int VMCIDatagram_CreateHnd(uint32_t resourceID, uint32_t flags,
+			   VMCIDatagramRecvCB recvCB, void *clientData,
+			   struct vmci_handle *outHandle);
+int VMCIDatagram_CreateHndPriv(uint32_t resourceID, uint32_t flags,
+			       uint32_t privFlags,
+			       VMCIDatagramRecvCB recvCB, void *clientData,
+			       struct vmci_handle *outHandle);
+int VMCIDatagram_DestroyHnd(struct vmci_handle handle);
+int VMCIDatagram_Send(struct vmci_datagram *msg);
+
+/* VMCI Utility API. */
+uint32_t VMCI_GetContextID(void);
+uint32_t VMCI_Version(void);
+int VMCI_ContextID2HostVmID(uint32_t contextID, void *hostVmID,
+			    size_t hostVmIDLen);
+int VMCI_IsContextOwner(uint32_t contextID, void *hostUser);
+
+/* VMCI Event API. */
+typedef void (*VMCI_EventCB) (uint32_t subID, struct vmci_event_data * ed,
+			      void *clientData);
+
+int VMCIEvent_Subscribe(uint32_t event, uint32_t flags,
+			VMCI_EventCB callback, void *callbackData,
+			uint32_t * subID);
+int VMCIEvent_Unsubscribe(uint32_t subID);
+
+/* VMCI Context API */
+uint32_t VMCIContext_GetPrivFlags(uint32_t contextID);
+
+/* VMCI Queue Pair API. */
+typedef struct VMCIQPair VMCIQPair;
+
+int VMCIQPair_Alloc(VMCIQPair ** qpair,
+		    struct vmci_handle *handle,
+		    uint64_t produceQSize,
+		    uint64_t consumeQSize,
+		    uint32_t peer, uint32_t flags, uint32_t privFlags);
+
+int VMCIQPair_Detach(VMCIQPair ** qpair);
+
+int VMCIQPair_GetProduceIndexes(const VMCIQPair * qpair,
+				uint64_t * producerTail,
+				uint64_t * consumerHead);
+int VMCIQPair_GetConsumeIndexes(const VMCIQPair * qpair,
+				uint64_t * consumerTail,
+				uint64_t * producerHead);
+int64_t VMCIQPair_ProduceFreeSpace(const VMCIQPair * qpair);
+int64_t VMCIQPair_ProduceBufReady(const VMCIQPair * qpair);
+int64_t VMCIQPair_ConsumeFreeSpace(const VMCIQPair * qpair);
+int64_t VMCIQPair_ConsumeBufReady(const VMCIQPair * qpair);
+ssize_t VMCIQPair_Enqueue(VMCIQPair * qpair,
+			  const void *buf, size_t bufSize, int mode);
+ssize_t VMCIQPair_Dequeue(VMCIQPair * qpair,
+			  void *buf, size_t bufSize, int mode);
+ssize_t VMCIQPair_Peek(VMCIQPair * qpair, void *buf, size_t bufSize, int mode);
+
+/* Environments that support struct iovec */
+ssize_t VMCIQPair_EnqueueV(VMCIQPair * qpair,
+			   void *iov, size_t iovSize, int mode);
+ssize_t VMCIQPair_DequeueV(VMCIQPair * qpair,
+			   void *iov, size_t iovSize, int mode);
+ssize_t VMCIQPair_PeekV(VMCIQPair * qpair, void *iov, size_t iovSize, int mode);
+
+/* Typedefs for all of the above, used by the IOCTLs and the kernel library. */
+typedef void (VMCI_DeviceReleaseFct) (void *);
+typedef int (VMCIDatagram_CreateHndFct) (uint32_t, uint32_t,
+					 VMCIDatagramRecvCB, void *,
+					 struct vmci_handle *);
+typedef int (VMCIDatagram_CreateHndPrivFct) (uint32_t, uint32_t, uint32_t,
+					     VMCIDatagramRecvCB, void *,
+					     struct vmci_handle *);
+typedef int (VMCIDatagram_DestroyHndFct) (struct vmci_handle);
+typedef int (VMCIDatagram_SendFct) (struct vmci_datagram *);
+typedef uint32_t(VMCI_GetContextIDFct) (void);
+typedef uint32_t(VMCI_VersionFct) (void);
+typedef int (VMCI_ContextID2HostVmIDFct) (uint32_t, void *, size_t);
+typedef int (VMCI_IsContextOwnerFct) (uint32_t, void *);
+typedef int (VMCIEvent_SubscribeFct) (uint32_t, uint32_t, VMCI_EventCB,
+				      void *, uint32_t *);
+typedef int (VMCIEvent_UnsubscribeFct) (uint32_t);
+typedef uint32_t(VMCIContext_GetPrivFlagsFct) (uint32_t);
+typedef int (VMCIQPair_AllocFct) (VMCIQPair **, struct vmci_handle *,
+				  uint64_t, uint64_t, uint32_t, uint32_t,
+				  uint32_t);
+typedef int (VMCIQPair_DetachFct) (VMCIQPair **);
+typedef int (VMCIQPair_GetProduceIndexesFct) (const VMCIQPair *,
+					      uint64_t *, uint64_t *);
+typedef int (VMCIQPair_GetConsumeIndexesFct) (const VMCIQPair *,
+					      uint64_t *, uint64_t *);
+typedef int64_t(VMCIQPair_ProduceFreeSpaceFct) (const VMCIQPair *);
+typedef int64_t(VMCIQPair_ProduceBufReadyFct) (const VMCIQPair *);
+typedef int64_t(VMCIQPair_ConsumeFreeSpaceFct) (const VMCIQPair *);
+typedef int64_t(VMCIQPair_ConsumeBufReadyFct) (const VMCIQPair *);
+typedef ssize_t(VMCIQPair_EnqueueFct) (VMCIQPair *, const void *, size_t, int);
+typedef ssize_t(VMCIQPair_DequeueFct) (VMCIQPair *, void *, size_t, int);
+typedef ssize_t(VMCIQPair_PeekFct) (VMCIQPair *, void *, size_t, int);
+typedef ssize_t(VMCIQPair_EnqueueVFct) (VMCIQPair * qpair, void *, size_t, int);
+typedef ssize_t(VMCIQPair_DequeueVFct) (VMCIQPair * qpair, void *, size_t, int);
+typedef ssize_t(VMCIQPair_PeekVFct) (VMCIQPair * qpair, void *, size_t, int);
+
+#endif				/* !__VMCI_KERNELAPI_1_H__ */
diff --git a/drivers/misc/vmw_vmci/vmciKernelAPI2.h b/drivers/misc/vmw_vmci/vmciKernelAPI2.h
new file mode 100644
index 0000000..bcd65cb
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmciKernelAPI2.h
@@ -0,0 +1,48 @@
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
+#ifndef __VMCI_KERNELAPI_2_H__
+#define __VMCI_KERNELAPI_2_H__
+
+#include "vmciKernelAPI1.h"
+
+/* Define version 2. */
+#undef  VMCI_KERNEL_API_VERSION
+#define VMCI_KERNEL_API_VERSION_2 2
+#define VMCI_KERNEL_API_VERSION   VMCI_KERNEL_API_VERSION_2
+
+/* VMCI Doorbell API. */
+#define VMCI_FLAG_DELAYED_CB 0x01
+
+typedef void (*VMCICallback) (void *clientData);
+
+int VMCIDoorbell_Create(struct vmci_handle *handle, uint32_t flags,
+			uint32_t privFlags,
+			VMCICallback notifyCB, void *clientData);
+int VMCIDoorbell_Destroy(struct vmci_handle handle);
+int VMCIDoorbell_Notify(struct vmci_handle handle, uint32_t privFlags);
+
+/* Typedefs for all of the above, used by the IOCTLs and the kernel library. */
+typedef int (VMCIDoorbell_CreateFct) (struct vmci_handle *, uint32_t,
+				      uint32_t, VMCICallback, void *);
+typedef int (VMCIDoorbell_DestroyFct) (struct vmci_handle);
+typedef int (VMCIDoorbell_NotifyFct) (struct vmci_handle, uint32_t);
+
+#endif				/* !__VMCI_KERNELAPI_2_H__ */
-- 
1.7.0.4

