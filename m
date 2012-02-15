Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757539Ab2BOBPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 20:15:48 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:52384 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761468Ab2BOBOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 20:14:45 -0500
From: "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
To: linux-kernel@vger.kernel.org
Cc: vm-crosstalk@vmware.com, dtor@vmware.com, cschamp@vmware.com,
        "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
Subject: [PATCH 12/14] Add misc header files used by VMCI
Date: Tue, 14 Feb 2012 17:05:53 -0800
Message-Id: <1329267955-32367-13-git-send-email-astiegmann@vmware.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1329267955-32367-1-git-send-email-astiegmann@vmware.com>
References: <1329267955-32367-1-git-send-email-astiegmann@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/misc/vmw_vmci/vmci_call_defs.h      |  264 +++++++++
 drivers/misc/vmw_vmci/vmci_defs.h           |  772 +++++++++++++++++++++++++++
 drivers/misc/vmw_vmci/vmci_handle_array.h   |  339 ++++++++++++
 drivers/misc/vmw_vmci/vmci_infrastructure.h |  119 ++++
 drivers/misc/vmw_vmci/vmci_iocontrols.h     |  411 ++++++++++++++
 drivers/misc/vmw_vmci/vmci_kernel_if.h      |  111 ++++
 6 files changed, 2016 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/vmw_vmci/vmci_call_defs.h
 create mode 100644 drivers/misc/vmw_vmci/vmci_defs.h
 create mode 100644 drivers/misc/vmw_vmci/vmci_handle_array.h
 create mode 100644 drivers/misc/vmw_vmci/vmci_infrastructure.h
 create mode 100644 drivers/misc/vmw_vmci/vmci_iocontrols.h
 create mode 100644 drivers/misc/vmw_vmci/vmci_kernel_if.h

diff --git a/drivers/misc/vmw_vmci/vmci_call_defs.h b/drivers/misc/vmw_vmci/vmci_call_defs.h
new file mode 100644
index 0000000..480c0dc
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmci_call_defs.h
@@ -0,0 +1,264 @@
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
+#ifndef _VMCI_CALL_DEFS_H_
+#define _VMCI_CALL_DEFS_H_
+
+#include "vmci_defs.h"
+
+/*
+ * All structs here are an integral size of their largest member, ie. a struct
+ * with at least one 8-byte member will have a size that is an integral of 8.
+ * A struct which has a largest member of size 4 will have a size that is an
+ * integral of 4. This is because Windows CL enforces this rule. 32 bit gcc
+ * doesn't e.g. 32 bit gcc can misalign an 8 byte member if it is preceeded by
+ * a 4 byte member.
+ */
+
+/* Base struct for vmci datagrams. */
+struct vmci_datagram {
+	struct vmci_handle dst;
+	struct vmci_handle src;
+	uint64_t payloadSize;
+};
+
+/*
+ * Second flag is for creating a well-known handle instead of a per context
+ * handle.  Next flag is for deferring datagram delivery, so that the
+ * datagram callback is invoked in a delayed context (not interrupt context).
+ */
+#define VMCI_FLAG_DG_NONE          0
+#define VMCI_FLAG_WELLKNOWN_DG_HND 0x1
+#define VMCI_FLAG_ANYCID_DG_HND    0x2
+#define VMCI_FLAG_DG_DELAYED_CB    0x4
+
+/* Event callback should fire in a delayed context (not interrupt context.) */
+#define VMCI_FLAG_EVENT_NONE       0
+#define VMCI_FLAG_EVENT_DELAYED_CB 0x1
+
+/*
+ * Maximum supported size of a VMCI datagram for routable datagrams.
+ * Datagrams going to the hypervisor are allowed to be larger.
+ */
+#define VMCI_MAX_DG_SIZE (17 * 4096)
+#define VMCI_MAX_DG_PAYLOAD_SIZE (VMCI_MAX_DG_SIZE - sizeof(struct vmci_datagram))
+#define VMCI_DG_PAYLOAD(_dg) (void *)((char *)(_dg) + sizeof(struct vmci_datagram))
+#define VMCI_DG_HEADERSIZE sizeof(struct vmci_datagram)
+#define VMCI_DG_SIZE(_dg) (VMCI_DG_HEADERSIZE + (size_t)(_dg)->payloadSize)
+#define VMCI_DG_SIZE_ALIGNED(_dg) ((VMCI_DG_SIZE(_dg) + 7) & (size_t)CONST64U(0xfffffffffffffff8))
+#define VMCI_MAX_DATAGRAM_QUEUE_SIZE (VMCI_MAX_DG_SIZE * 2)
+
+/*
+ * We allow at least 1024 more event datagrams from the hypervisor past the
+ * normally allowed datagrams pending for a given context.  We define this
+ * limit on event datagrams from the hypervisor to guard against DoS attack
+ * from a malicious VM which could repeatedly attach to and detach from a queue
+ * pair, causing events to be queued at the destination VM.  However, the rate
+ * at which such events can be generated is small since it requires a VM exit
+ * and handling of queue pair attach/detach call at the hypervisor.  Event
+ * datagrams may be queued up at the destination VM if it has interrupts
+ * disabled or if it is not draining events for some other reason.  1024
+ * datagrams is a grossly conservative estimate of the time for which
+ * interrupts may be disabled in the destination VM, but at the same time does
+ * not exacerbate the memory pressure problem on the host by much (size of each
+ * event datagram is small).
+ */
+#define VMCI_MAX_DATAGRAM_AND_EVENT_QUEUE_SIZE				\
+	(VMCI_MAX_DATAGRAM_QUEUE_SIZE +					\
+	 1024 * (sizeof(struct vmci_datagram) + sizeof(struct vmci_event_data_max)))
+
+/*
+ * Struct used for querying, via VMCI_RESOURCES_QUERY, the availability of
+ * hypervisor resources.
+ * Struct size is 16 bytes. All fields in struct are aligned to their natural
+ * alignment.
+ */
+struct vmci_rsrc_query_hdr {
+	struct vmci_datagram hdr;
+	uint32_t numResources;
+	uint32_t _padding;
+};
+
+/*
+ * Convenience struct for negotiating vectors. Must match layout of
+ * VMCIResourceQueryHdr minus the struct vmci_datagram header.
+ */
+struct vmci_rscs_query_msg {
+	uint32_t numResources;
+	uint32_t _padding;
+	uint32_t resources[1];
+};
+
+/*
+ * The maximum number of resources that can be queried using
+ * VMCI_RESOURCE_QUERY is 31, as the result is encoded in the lower 31
+ * bits of a positive return value. Negative values are reserved for
+ * errors.
+ */
+#define VMCI_RESOURCE_QUERY_MAX_NUM 31
+
+/* Maximum size for the VMCI_RESOURCE_QUERY request. */
+#define VMCI_RESOURCE_QUERY_MAX_SIZE sizeof(struct vmci_rsrc_query_hdr)	\
+	+ VMCI_RESOURCE_QUERY_MAX_NUM * sizeof(uint32_t)
+
+/*
+ * Struct used for setting the notification bitmap.  All fields in
+ * struct are aligned to their natural alignment.
+ */
+struct vmci_ntfy_bm_set_msg {
+	struct vmci_datagram hdr;
+	uint32_t bitmapPPN;
+	uint32_t _pad;
+};
+
+/*
+ * Struct used for linking a doorbell handle with an index in the
+ * notify bitmap. All fields in struct are aligned to their natural
+ * alignment.
+ */
+struct vmci_doorbell_link_msg {
+	struct vmci_datagram hdr;
+	struct vmci_handle handle;
+	uint64_t notifyIdx;
+};
+
+/*
+ * Struct used for unlinking a doorbell handle from an index in the
+ * notify bitmap. All fields in struct are aligned to their natural
+ * alignment.
+ */
+struct vmci_doorbell_unlink_msg {
+	struct vmci_datagram hdr;
+	struct vmci_handle handle;
+};
+
+/*
+ * Struct used for generating a notification on a doorbell handle. All
+ * fields in struct are aligned to their natural alignment.
+ */
+struct vmci_doorbell_ntfy_msg {
+	struct vmci_datagram hdr;
+	struct vmci_handle handle;
+};
+
+/*
+ * This struct is used to contain data for events.  Size of this struct is a
+ * multiple of 8 bytes, and all fields are aligned to their natural alignment.
+ */
+struct vmci_event_data {
+	uint32_t event;		/* 4 bytes. */
+	uint32_t _pad;
+	/* Event payload is put here. */
+};
+
+/* Callback needed for correctly waiting on events. */
+typedef int
+ (*VMCIDatagramRecvCB) (void *clientData,	// IN: client data for handler
+			struct vmci_datagram * msg);	// IN:
+
+/*
+ * We use the following inline function to access the payload data associated
+ * with an event data.
+ */
+static inline void *VMCIEventDataPayload(struct vmci_event_data *evData)	// IN:
+{
+	return (void *)((char *)evData + sizeof *evData);
+}
+
+/*
+ * Define the different VMCI_EVENT payload data types here.  All structs must
+ * be a multiple of 8 bytes, and fields must be aligned to their natural
+ * alignment.
+ */
+struct vmci_event_payld_ctx {
+	uint32_t contextID;	/* 4 bytes. */
+	uint32_t _pad;
+};
+
+struct vmci_event_payld_qp {
+	struct vmci_handle handle;	/* QueuePair handle. */
+	uint32_t peerId;	/* Context id of attaching/detaching VM. */
+	uint32_t _pad;
+};
+
+/*
+ * We define the following struct to get the size of the maximum event data
+ * the hypervisor may send to the guest.  If adding a new event payload type
+ * above, add it to the following struct too (inside the union).
+ */
+struct vmci_event_data_max {
+	struct vmci_event_data eventData;
+	union {
+		struct vmci_event_payld_ctx contextPayload;
+		struct vmci_event_payld_qp qpPayload;
+	} evDataPayload;
+};
+
+/*
+ * Struct used for VMCI_EVENT_SUBSCRIBE/UNSUBSCRIBE and VMCI_EVENT_HANDLER
+ * messages.  Struct size is 32 bytes.  All fields in struct are aligned to
+ * their natural alignment.
+ */
+struct vmci_event_msg {
+	struct vmci_datagram hdr;
+	struct vmci_event_data eventData;	/* Has event type and payload. */
+	/* Payload gets put here. */
+};
+
+/*
+ * We use the following inline function to access the payload data associated
+ * with an event message.
+ *
+ * XXX: NUKE ME.
+ */
+static inline void *VMCIEventMsgPayload(struct vmci_event_msg *eMsg)	// IN:
+{
+	return VMCIEventDataPayload(&eMsg->eventData);
+}
+
+/* Flags for VMCI QueuePair API. */
+#define VMCI_QPFLAG_ATTACH_ONLY 0x1	/* Fail alloc if QP not created by peer. */
+#define VMCI_QPFLAG_LOCAL       0x2	/* Only allow attaches from local context. */
+#define VMCI_QPFLAG_NONBLOCK    0x4	/* Host won't block when guest is quiesced. */
+/* Update the following (bitwise OR flags) while adding new flags. */
+#define VMCI_QP_ALL_FLAGS       (VMCI_QPFLAG_ATTACH_ONLY | VMCI_QPFLAG_LOCAL | \
+                                 VMCI_QPFLAG_NONBLOCK)
+
+/*
+ * Structs used for QueuePair alloc and detach messages.  We align fields of
+ * these structs to 64bit boundaries.
+ */
+struct vmci_qp_alloc_msg {
+	struct vmci_datagram hdr;
+	struct vmci_handle handle;
+	uint32_t peer;		/* 32bit field. */
+	uint32_t flags;
+	uint64_t produceSize;
+	uint64_t consumeSize;
+	uint64_t numPPNs;
+	/* List of PPNs placed here. */
+};
+
+struct vmci_qp_detach_msg {
+	struct vmci_datagram hdr;
+	struct vmci_handle handle;
+};
+
+#endif
diff --git a/drivers/misc/vmw_vmci/vmci_defs.h b/drivers/misc/vmw_vmci/vmci_defs.h
new file mode 100644
index 0000000..bf1569b
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmci_defs.h
@@ -0,0 +1,772 @@
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
+#ifndef _VMCI_DEF_H_
+#define _VMCI_DEF_H_
+
+#include <linux/atomic.h>
+#include <linux/printk.h>
+
+#define DEBUG
+
+#ifdef DEBUG
+#define VMCI_DBG(msg, args...) do {					\
+		pr_devel("VMCI_DBG %s - %s - %d: msg", __FILE__,	\
+			 __func__, __LINE__, ##args );			\
+	} while (0)
+#else
+#define VMCI_DBG(msg, args...)
+#endif
+
+/* Register offsets. */
+#define VMCI_STATUS_ADDR      0x00
+#define VMCI_CONTROL_ADDR     0x04
+#define VMCI_ICR_ADDR	      0x08
+#define VMCI_IMR_ADDR         0x0c
+#define VMCI_DATA_OUT_ADDR    0x10
+#define VMCI_DATA_IN_ADDR     0x14
+#define VMCI_CAPS_ADDR        0x18
+#define VMCI_RESULT_LOW_ADDR  0x1c
+#define VMCI_RESULT_HIGH_ADDR 0x20
+
+/* Max number of devices. */
+#define VMCI_MAX_DEVICES 1
+
+/* Status register bits. */
+#define VMCI_STATUS_INT_ON     0x1
+
+/* Control register bits. */
+#define VMCI_CONTROL_RESET        0x1
+#define VMCI_CONTROL_INT_ENABLE   0x2
+#define VMCI_CONTROL_INT_DISABLE  0x4
+
+/* Capabilities register bits. */
+#define VMCI_CAPS_HYPERCALL     0x1
+#define VMCI_CAPS_GUESTCALL     0x2
+#define VMCI_CAPS_DATAGRAM      0x4
+#define VMCI_CAPS_NOTIFICATIONS 0x8
+
+/* Interrupt Cause register bits. */
+#define VMCI_ICR_DATAGRAM      0x1
+#define VMCI_ICR_NOTIFICATION  0x2
+
+/* Interrupt Mask register bits. */
+#define VMCI_IMR_DATAGRAM      0x1
+#define VMCI_IMR_NOTIFICATION  0x2
+
+/* Interrupt type. */
+enum {
+	VMCI_INTR_TYPE_INTX = 0,
+	VMCI_INTR_TYPE_MSI = 1,
+	VMCI_INTR_TYPE_MSIX = 2
+};
+
+/* Maximum MSI/MSI-X interrupt vectors in the device. */
+#define VMCI_MAX_INTRS 2
+
+/*
+ * Supported interrupt vectors.  There is one for each ICR value above,
+ * but here they indicate the position in the vector array/message ID.
+ */
+#define VMCI_INTR_DATAGRAM     0
+#define VMCI_INTR_NOTIFICATION 1
+
+/*
+ * A single VMCI device has an upper limit of 128MB on the amount of
+ * memory that can be used for queue pairs.
+ */
+#define VMCI_MAX_GUEST_QP_MEMORY (128 * 1024 * 1024)
+
+/*
+ * We have a fixed set of resource IDs available in the VMX.
+ * This allows us to have a very simple implementation since we statically
+ * know how many will create datagram handles. If a new caller arrives and
+ * we have run out of slots we can manually increment the maximum size of
+ * available resource IDs.
+ *
+ * VMCI reserved hypervisor datagram resource IDs.
+ */
+#define VMCI_RESOURCES_QUERY      0
+#define VMCI_GET_CONTEXT_ID       1
+#define VMCI_SET_NOTIFY_BITMAP    2
+#define VMCI_DOORBELL_LINK        3
+#define VMCI_DOORBELL_UNLINK      4
+#define VMCI_DOORBELL_NOTIFY      5
+/*
+ * VMCI_DATAGRAM_REQUEST_MAP and VMCI_DATAGRAM_REMOVE_MAP are
+ * obsoleted by the removal of VM to VM communication.
+ */
+#define VMCI_DATAGRAM_REQUEST_MAP 6
+#define VMCI_DATAGRAM_REMOVE_MAP  7
+#define VMCI_EVENT_SUBSCRIBE      8
+#define VMCI_EVENT_UNSUBSCRIBE    9
+#define VMCI_QUEUEPAIR_ALLOC      10
+#define VMCI_QUEUEPAIR_DETACH     11
+
+/*
+ * VMCI_VSOCK_VMX_LOOKUP was assigned to 12 for Fusion 3.0/3.1,
+ * WS 7.0/7.1 and ESX 4.1
+ */
+#define VMCI_HGFS_TRANSPORT       13
+#define VMCI_UNITY_PBRPC_REGISTER 14
+#define VMCI_RESOURCE_MAX         15
+
+#define Log(fmt, args...) printk(KERN_INFO fmt, ##args)
+#define Warning(fmt, args...) printk(KERN_WARNING fmt, ##args)
+#define PCI_VENDOR_ID_VMWARE                    0x15AD
+#define PCI_DEVICE_ID_VMWARE_VMCI               0x0740
+#define VMCI_DRIVER_VERSION          9.3.14.0-k
+#define VMCI_DRIVER_VERSION_STRING   "9.3.14.0-k"
+
+#define ASSERT(cond) ({if (unlikely(!(cond))) panic("ASSERT Failed at %s:%d\n", __FILE__, __LINE__);})
+#define QWORD(_hi, _lo)   ((((uint64_t)(_hi)) << 32) | ((uint32_t)(_lo)))
+
+/*
+ * Compile-time assertions.
+ *
+ * The implementation uses both enum and typedef because the typedef alone is
+ * insufficient; gcc allows arrays to be declared with non-constant expressions
+ * (even in typedefs, where it makes no sense).
+ */
+#define ASSERT_ON_COMPILE(e)						\
+	do {								\
+		enum { AssertOnCompileMisused = ((e) ? 1 : -1) };	\
+		typedef char AssertOnCompileFailed[AssertOnCompileMisused]; \
+	} while (0)
+
+/* XXX: Replacement? */
+#define CEILING(x, y) (((x) + (y) - 1) / (y))
+
+#ifdef CONFIG_X86_64
+#   define CONST64(c) c##L
+#   define CONST64U(c) c##uL
+#   define FMT64 "ll"
+#else
+#   define CONST64(c) c##LL
+#   define CONST64U(c) c##uLL
+#   define FMT64 "L"
+#endif
+
+#define UNUSED_PARAM(_parm) _parm  __attribute__((__unused__))
+
+/* VMCI Ids. */
+struct vmci_handle {
+	uint32_t context;
+	uint32_t resource;
+};
+
+static inline struct vmci_handle VMCI_MAKE_HANDLE(uint32_t cid, uint32_t rid)
+{
+	struct vmci_handle h;
+	h.context = cid;
+	h.resource = rid;
+	return h;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCI_HANDLE_TO_UINT64 --
+ *
+ *     Helper for VMCI handle to uint64_t conversion.
+ *
+ * Results:
+ *     The uint64_t value.
+ *
+ * Side effects:
+ *     None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+static inline uint64_t VMCI_HANDLE_TO_UINT64(struct vmci_handle handle)	// IN:
+{
+	uint64_t handle64;
+
+	handle64 = handle.context;
+	handle64 <<= 32;
+	handle64 |= handle.resource;
+	return handle64;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCI_UINT64_TO_HANDLE --
+ *
+ *     Helper for uint64_t to VMCI handle conversion.
+ *
+ * Results:
+ *     The VMCI handle value.
+ *
+ * Side effects:
+ *     None.
+ *
+ *----------------------------------------------------------------------
+ */
+
+static inline struct vmci_handle VMCI_UINT64_TO_HANDLE(uint64_t handle64)	// IN:
+{
+	uint32_t context = (uint32_t) (handle64 >> 32);
+	uint32_t resource = (uint32_t) handle64;
+
+	return VMCI_MAKE_HANDLE(context, resource);
+}
+
+#define VMCI_HANDLE_TO_CONTEXT_ID(_handle) ((_handle).context)
+#define VMCI_HANDLE_TO_RESOURCE_ID(_handle) ((_handle).resource)
+#define VMCI_HANDLE_EQUAL(_h1, _h2) ((_h1).context == (_h2).context &&	\
+				     (_h1).resource == (_h2).resource)
+
+#define VMCI_INVALID_ID 0xFFFFFFFF
+static const struct vmci_handle VMCI_INVALID_HANDLE = { VMCI_INVALID_ID,
+	VMCI_INVALID_ID
+};
+
+#define VMCI_HANDLE_INVALID(_handle)				\
+	VMCI_HANDLE_EQUAL((_handle), VMCI_INVALID_HANDLE)
+
+/*
+ * The below defines can be used to send anonymous requests.
+ * This also indicates that no response is expected.
+ */
+#define VMCI_ANON_SRC_CONTEXT_ID   VMCI_INVALID_ID
+#define VMCI_ANON_SRC_RESOURCE_ID  VMCI_INVALID_ID
+#define VMCI_ANON_SRC_HANDLE       VMCI_MAKE_HANDLE(VMCI_ANON_SRC_CONTEXT_ID, \
+						    VMCI_ANON_SRC_RESOURCE_ID)
+
+/* The lowest 16 context ids are reserved for internal use. */
+#define VMCI_RESERVED_CID_LIMIT (uint32_t) 16
+
+/*
+ * Hypervisor context id, used for calling into hypervisor
+ * supplied services from the VM.
+ */
+#define VMCI_HYPERVISOR_CONTEXT_ID 0
+
+/*
+ * Well-known context id, a logical context that contains a set of
+ * well-known services. This context ID is now obsolete.
+ */
+#define VMCI_WELL_KNOWN_CONTEXT_ID 1
+
+/*
+ * Context ID used by host endpoints.
+ */
+#define VMCI_HOST_CONTEXT_ID  2
+
+#define VMCI_CONTEXT_IS_VM(_cid) (VMCI_INVALID_ID != _cid &&	\
+                                  _cid > VMCI_HOST_CONTEXT_ID)
+
+/*
+ * The VMCI_CONTEXT_RESOURCE_ID is used together with VMCI_MAKE_HANDLE to make
+ * handles that refer to a specific context.
+ */
+#define VMCI_CONTEXT_RESOURCE_ID 0
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCI error codes.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+#define VMCI_SUCCESS_QUEUEPAIR_ATTACH     5
+#define VMCI_SUCCESS_QUEUEPAIR_CREATE     4
+#define VMCI_SUCCESS_LAST_DETACH          3
+#define VMCI_SUCCESS_ACCESS_GRANTED       2
+#define VMCI_SUCCESS_ENTRY_DEAD           1
+#define VMCI_SUCCESS                      0LL
+#define VMCI_ERROR_INVALID_RESOURCE      (-1)
+#define VMCI_ERROR_INVALID_ARGS          (-2)
+#define VMCI_ERROR_NO_MEM                (-3)
+#define VMCI_ERROR_DATAGRAM_FAILED       (-4)
+#define VMCI_ERROR_MORE_DATA             (-5)
+#define VMCI_ERROR_NO_MORE_DATAGRAMS     (-6)
+#define VMCI_ERROR_NO_ACCESS             (-7)
+#define VMCI_ERROR_NO_HANDLE             (-8)
+#define VMCI_ERROR_DUPLICATE_ENTRY       (-9)
+#define VMCI_ERROR_DST_UNREACHABLE       (-10)
+#define VMCI_ERROR_PAYLOAD_TOO_LARGE     (-11)
+#define VMCI_ERROR_INVALID_PRIV          (-12)
+#define VMCI_ERROR_GENERIC               (-13)
+#define VMCI_ERROR_PAGE_ALREADY_SHARED   (-14)
+#define VMCI_ERROR_CANNOT_SHARE_PAGE     (-15)
+#define VMCI_ERROR_CANNOT_UNSHARE_PAGE   (-16)
+#define VMCI_ERROR_NO_PROCESS            (-17)
+#define VMCI_ERROR_NO_DATAGRAM           (-18)
+#define VMCI_ERROR_NO_RESOURCES          (-19)
+#define VMCI_ERROR_UNAVAILABLE           (-20)
+#define VMCI_ERROR_NOT_FOUND             (-21)
+#define VMCI_ERROR_ALREADY_EXISTS        (-22)
+#define VMCI_ERROR_NOT_PAGE_ALIGNED      (-23)
+#define VMCI_ERROR_INVALID_SIZE          (-24)
+#define VMCI_ERROR_REGION_ALREADY_SHARED (-25)
+#define VMCI_ERROR_TIMEOUT               (-26)
+#define VMCI_ERROR_DATAGRAM_INCOMPLETE   (-27)
+#define VMCI_ERROR_INCORRECT_IRQL        (-28)
+#define VMCI_ERROR_EVENT_UNKNOWN         (-29)
+#define VMCI_ERROR_OBSOLETE              (-30)
+#define VMCI_ERROR_QUEUEPAIR_MISMATCH    (-31)
+#define VMCI_ERROR_QUEUEPAIR_NOTSET      (-32)
+#define VMCI_ERROR_QUEUEPAIR_NOTOWNER    (-33)
+#define VMCI_ERROR_QUEUEPAIR_NOTATTACHED (-34)
+#define VMCI_ERROR_QUEUEPAIR_NOSPACE     (-35)
+#define VMCI_ERROR_QUEUEPAIR_NODATA      (-36)
+#define VMCI_ERROR_BUSMEM_INVALIDATION   (-37)
+#define VMCI_ERROR_MODULE_NOT_LOADED     (-38)
+#define VMCI_ERROR_DEVICE_NOT_FOUND      (-39)
+#define VMCI_ERROR_QUEUEPAIR_NOT_READY   (-40)
+#define VMCI_ERROR_WOULD_BLOCK           (-41)
+
+/* VMCI clients should return error code within this range */
+#define VMCI_ERROR_CLIENT_MIN     (-500)
+#define VMCI_ERROR_CLIENT_MAX     (-550)
+
+/* Internal error codes. */
+#define VMCI_SHAREDMEM_ERROR_BAD_CONTEXT (-1000)
+
+#define VMCI_PATH_MAX 256
+
+/* VMCI reserved events. */
+#define VMCI_EVENT_CTX_ID_UPDATE  0	// Only applicable to guest endpoints
+#define VMCI_EVENT_CTX_REMOVED    1	// Applicable to guest and host
+#define VMCI_EVENT_QP_RESUMED     2	// Only applicable to guest endpoints
+#define VMCI_EVENT_QP_PEER_ATTACH 3	// Applicable to guest and host
+#define VMCI_EVENT_QP_PEER_DETACH 4	// Applicable to guest and host
+#define VMCI_EVENT_MEM_ACCESS_ON  5	// Applicable to VMX and vmk.  On vmk,
+				     // this event has the Context payload type.
+#define VMCI_EVENT_MEM_ACCESS_OFF 6	// Applicable to VMX and vmk.  Same as
+				     // above for the payload type.
+#define VMCI_EVENT_MAX            7
+
+/*
+ * Of the above events, a few are reserved for use in the VMX, and
+ * other endpoints (guest and host kernel) should not use them. For
+ * the rest of the events, we allow both host and guest endpoints to
+ * subscribe to them, to maintain the same API for host and guest
+ * endpoints.
+ */
+
+#define VMCI_EVENT_VALID_VMX(_event) (_event == VMCI_EVENT_MEM_ACCESS_ON || \
+                                      _event == VMCI_EVENT_MEM_ACCESS_OFF)
+
+#define VMCI_EVENT_VALID(_event) (_event < VMCI_EVENT_MAX &&		\
+                                  !VMCI_EVENT_VALID_VMX(_event))
+
+/* Reserved guest datagram resource ids. */
+#define VMCI_EVENT_HANDLER 0
+
+/*
+ * VMCI coarse-grained privileges (per context or host
+ * process/endpoint. An entity with the restricted flag is only
+ * allowed to interact with the hypervisor and trusted entities.
+ */
+#define VMCI_PRIVILEGE_FLAG_RESTRICTED     0x01
+#define VMCI_PRIVILEGE_FLAG_TRUSTED        0x02
+#define VMCI_PRIVILEGE_ALL_FLAGS           (VMCI_PRIVILEGE_FLAG_RESTRICTED | \
+				            VMCI_PRIVILEGE_FLAG_TRUSTED)
+#define VMCI_NO_PRIVILEGE_FLAGS            0x00
+#define VMCI_DEFAULT_PROC_PRIVILEGE_FLAGS  VMCI_NO_PRIVILEGE_FLAGS
+#define VMCI_LEAST_PRIVILEGE_FLAGS         VMCI_PRIVILEGE_FLAG_RESTRICTED
+#define VMCI_MAX_PRIVILEGE_FLAGS           VMCI_PRIVILEGE_FLAG_TRUSTED
+
+#define VMCI_PUBLIC_GROUP_NAME "vmci public group"
+/* 0 through VMCI_RESERVED_RESOURCE_ID_MAX are reserved. */
+#define VMCI_RESERVED_RESOURCE_ID_MAX 1023
+
+#define VMCI_DOMAIN_NAME_MAXLEN  32
+
+#define VMCI_LGPFX "VMCI: "
+
+/*
+ * struct vmci_queue_header
+ *
+ * A Queue cannot stand by itself as designed.  Each Queue's header
+ * contains a pointer into itself (the producerTail) and into its peer
+ * (consumerHead).  The reason for the separation is one of
+ * accessibility: Each end-point can modify two things: where the next
+ * location to enqueue is within its produceQ (producerTail); and
+ * where the next dequeue location is in its consumeQ (consumerHead).
+ *
+ * An end-point cannot modify the pointers of its peer (guest to
+ * guest; NOTE that in the host both queue headers are mapped r/w).
+ * But, each end-point needs read access to both Queue header
+ * structures in order to determine how much space is used (or left)
+ * in the Queue.  This is because for an end-point to know how full
+ * its produceQ is, it needs to use the consumerHead that points into
+ * the produceQ but -that- consumerHead is in the Queue header for
+ * that end-points consumeQ.
+ *
+ * Thoroughly confused?  Sorry.
+ *
+ * producerTail: the point to enqueue new entrants.  When you approach
+ * a line in a store, for example, you walk up to the tail.
+ *
+ * consumerHead: the point in the queue from which the next element is
+ * dequeued.  In other words, who is next in line is he who is at the
+ * head of the line.
+ *
+ * Also, producerTail points to an empty byte in the Queue, whereas
+ * consumerHead points to a valid byte of data (unless producerTail ==
+ * consumerHead in which case consumerHead does not point to a valid
+ * byte of data).
+ *
+ * For a queue of buffer 'size' bytes, the tail and head pointers will be in
+ * the range [0, size-1].
+ *
+ * If produceQHeader->producerTail == consumeQHeader->consumerHead
+ * then the produceQ is empty.
+ */
+
+struct vmci_queue_header {
+	/* All fields are 64bit and aligned. */
+	struct vmci_handle handle;	/* Identifier. */
+	atomic64_t producerTail;	/* Offset in this queue. */
+	atomic64_t consumerHead;	/* Offset in peer queue. */
+};
+
+/*
+ * If one client of a QueuePair is a 32bit entity, we restrict the QueuePair
+ * size to be less than 4GB, and use 32bit atomic operations on the head and
+ * tail pointers. 64bit atomic read on a 32bit entity involves cmpxchg8b which
+ * is an atomic read-modify-write. This will cause traces to fire when a 32bit
+ * consumer tries to read the producer's tail pointer, for example, because the
+ * consumer has read-only access to the producer's tail pointer.
+ *
+ * We provide the following macros to invoke 32bit or 64bit atomic operations
+ * based on the architecture the code is being compiled on.
+ */
+
+/* Architecture independent maximum queue size. */
+#define QP_MAX_QUEUE_SIZE_ARCH_ANY   CONST64U(0xffffffff)
+
+#ifdef __x86_64__
+#  define QP_MAX_QUEUE_SIZE_ARCH  CONST64U(0xffffffffffffffff)
+#else
+#  define QP_MAX_QUEUE_SIZE_ARCH  CONST64U(0xffffffff)
+#endif				/* __x86_64__  */
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * QPAddPointer --
+ *
+ *      Helper to add a given offset to a head or tail pointer. Wraps the value
+ *      of the pointer around the max size of the queue.
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
+static inline void QPAddPointer(atomic64_t * var,	// IN:
+				size_t add,	// IN:
+				uint64_t size)	// IN:
+{
+	uint64_t newVal = atomic64_read(var);
+
+	if (newVal >= size - add) {
+		newVal -= size;
+	}
+	newVal += add;
+
+	atomic64_set(var, newVal);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQueueHeader_ProducerTail() --
+ *
+ *      Helper routine to get the Producer Tail from the supplied queue.
+ *
+ * Results:
+ *      The contents of the queue's producer tail.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static inline uint64_t VMCIQueueHeader_ProducerTail(const struct vmci_queue_header *qHeader)	// IN:
+{
+	struct vmci_queue_header *qh = (struct vmci_queue_header *)qHeader;
+	return atomic64_read(&qh->producerTail);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQueueHeader_ConsumerHead() --
+ *
+ *      Helper routine to get the Consumer Head from the supplied queue.
+ *
+ * Results:
+ *      The contents of the queue's consumer tail.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static inline uint64_t VMCIQueueHeader_ConsumerHead(const struct vmci_queue_header *qHeader)	// IN:
+{
+	struct vmci_queue_header *qh = (struct vmci_queue_header *)qHeader;
+	return atomic64_read(&qh->consumerHead);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQueueHeader_AddProducerTail() --
+ *
+ *      Helper routine to increment the Producer Tail.  Fundamentally,
+ *      QPAddPointer() is used to manipulate the tail itself.
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
+static inline void VMCIQueueHeader_AddProducerTail(struct vmci_queue_header *qHeader,	// IN/OUT:
+						   size_t add,	// IN:
+						   uint64_t queueSize)	// IN:
+{
+	QPAddPointer(&qHeader->producerTail, add, queueSize);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQueueHeader_AddConsumerHead() --
+ *
+ *      Helper routine to increment the Consumer Head.  Fundamentally,
+ *      QPAddPointer() is used to manipulate the head itself.
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
+static inline void VMCIQueueHeader_AddConsumerHead(struct vmci_queue_header *qHeader,	// IN/OUT:
+						   size_t add,	// IN:
+						   uint64_t queueSize)	// IN:
+{
+	QPAddPointer(&qHeader->consumerHead, add, queueSize);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQueueHeader_CheckAlignment --
+ *
+ *      Checks if the given queue is aligned to page boundary.  Returns true if
+ *      the alignment is good.
+ *
+ * Results:
+ *      true or false.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static inline bool VMCIQueueHeader_CheckAlignment(const struct vmci_queue_header *qHeader)	// IN:
+{
+	uintptr_t hdr, offset;
+
+	hdr = (uintptr_t) qHeader;
+	offset = hdr & (PAGE_SIZE - 1);
+
+	return offset == 0;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQueueHeader_GetPointers --
+ *
+ *      Helper routine for getting the head and the tail pointer for a queue.
+ *      Both the VMCIQueues are needed to get both the pointers for one queue.
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
+static inline void VMCIQueueHeader_GetPointers(const struct vmci_queue_header *produceQHeader,	// IN:
+					       const struct vmci_queue_header *consumeQHeader,	// IN:
+					       uint64_t * producerTail,	// OUT:
+					       uint64_t * consumerHead)	// OUT:
+{
+	if (producerTail)
+		*producerTail = VMCIQueueHeader_ProducerTail(produceQHeader);
+
+	if (consumerHead)
+		*consumerHead = VMCIQueueHeader_ConsumerHead(consumeQHeader);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQueueHeader_ResetPointers --
+ *
+ *      Reset the tail pointer (of "this" queue) and the head pointer (of
+ *      "peer" queue).
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
+static inline void VMCIQueueHeader_ResetPointers(struct vmci_queue_header *qHeader)	// IN/OUT:
+{
+	atomic64_set(&qHeader->producerTail, CONST64U(0));
+	atomic64_set(&qHeader->consumerHead, CONST64U(0));
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQueueHeader_Init --
+ *
+ *      Initializes a queue's state (head & tail pointers).
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
+static inline void VMCIQueueHeader_Init(struct vmci_queue_header *qHeader,	// IN/OUT:
+					const struct vmci_handle handle)	// IN:
+{
+	qHeader->handle = handle;
+	VMCIQueueHeader_ResetPointers(qHeader);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQueueHeader_FreeSpace --
+ *
+ *      Finds available free space in a produce queue to enqueue more
+ *      data or reports an error if queue pair corruption is detected.
+ *
+ * Results:
+ *      Free space size in bytes or an error code.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static inline int64_t VMCIQueueHeader_FreeSpace(const struct vmci_queue_header *produceQHeader,	// IN:
+						const struct vmci_queue_header *consumeQHeader,	// IN:
+						const uint64_t produceQSize)	// IN:
+{
+	uint64_t tail;
+	uint64_t head;
+	uint64_t freeSpace;
+
+	tail = VMCIQueueHeader_ProducerTail(produceQHeader);
+	head = VMCIQueueHeader_ConsumerHead(consumeQHeader);
+
+	if (tail >= produceQSize || head >= produceQSize)
+		return VMCI_ERROR_INVALID_SIZE;
+
+	/*
+	 * Deduct 1 to avoid tail becoming equal to head which causes ambiguity. If
+	 * head and tail are equal it means that the queue is empty.
+	 */
+
+	if (tail >= head) {
+		freeSpace = produceQSize - (tail - head) - 1;
+	} else {
+		freeSpace = head - tail - 1;
+	}
+
+	return freeSpace;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIQueueHeader_BufReady --
+ *
+ *      VMCIQueueHeader_FreeSpace() does all the heavy lifting of
+ *      determing the number of free bytes in a Queue.  This routine,
+ *      then subtracts that size from the full size of the Queue so
+ *      the caller knows how many bytes are ready to be dequeued.
+ *
+ * Results:
+ *      On success, available data size in bytes (up to MAX_INT64).
+ *      On failure, appropriate error code.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static inline int64_t VMCIQueueHeader_BufReady(const struct vmci_queue_header *consumeQHeader,	// IN:
+					       const struct vmci_queue_header *produceQHeader,	// IN:
+					       const uint64_t consumeQSize)	// IN:
+{
+	int64_t freeSpace;
+
+	freeSpace = VMCIQueueHeader_FreeSpace(consumeQHeader,
+					      produceQHeader, consumeQSize);
+	if (freeSpace < VMCI_SUCCESS) {
+		return freeSpace;
+	} else {
+		return consumeQSize - freeSpace - 1;
+	}
+}
+
+#endif				/* _VMCI_DEF_H_ */
diff --git a/drivers/misc/vmw_vmci/vmci_handle_array.h b/drivers/misc/vmw_vmci/vmci_handle_array.h
new file mode 100644
index 0000000..eb237e3
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmci_handle_array.h
@@ -0,0 +1,339 @@
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
+#ifndef _VMCI_HANDLE_ARRAY_H_
+#define _VMCI_HANDLE_ARRAY_H_
+
+#include <linux/slab.h>
+
+#include "vmci_defs.h"
+#include "vmci_kernel_if.h"
+
+#define VMCI_HANDLE_ARRAY_DEFAULT_SIZE 4
+#define VMCI_ARR_CAP_MULT 2	/* Array capacity multiplier */
+
+struct vmci_handle_arr {
+	uint32_t capacity;
+	uint32_t size;
+	struct vmci_handle entries[1];
+};
+
+/*
+ *-----------------------------------------------------------------------------------
+ *
+ * VMCIHandleArray_Create --
+ *
+ * Results:
+ *      Array if successful, NULL if not.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------------
+ */
+
+static inline struct vmci_handle_arr *VMCIHandleArray_Create(uint32_t capacity)
+{
+	struct vmci_handle_arr *array;
+
+	if (capacity == 0)
+		capacity = VMCI_HANDLE_ARRAY_DEFAULT_SIZE;
+
+	array = (struct vmci_handle_arr *)kmalloc(sizeof array->capacity +
+						  sizeof array->size +
+						  capacity *
+						  sizeof(struct
+							 vmci_handle),
+						  GFP_ATOMIC);
+	if (array == NULL)
+		return NULL;
+
+	array->capacity = capacity;
+	array->size = 0;
+
+	return array;
+}
+
+/*
+ *-----------------------------------------------------------------------------------
+ *
+ * VMCIHandleArray_Destroy --
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------------
+ */
+
+static inline void VMCIHandleArray_Destroy(struct vmci_handle_arr *array)
+{
+	kfree(array);
+}
+
+/*
+ *-----------------------------------------------------------------------------------
+ *
+ * VMCIHandleArray_AppendEntry --
+ *
+ * Results:
+ *      None.
+ *
+ * Side effects:
+ *      Array may be reallocated.
+ *
+ *-----------------------------------------------------------------------------------
+ */
+
+static inline void
+VMCIHandleArray_AppendEntry(struct vmci_handle_arr **arrayPtr,
+			    struct vmci_handle handle)
+{
+	struct vmci_handle_arr *array;
+
+	ASSERT(arrayPtr && *arrayPtr);
+	array = *arrayPtr;
+
+	if (unlikely(array->size >= array->capacity)) {
+		/* reallocate. */
+		uint32_t arraySize =
+		    sizeof array->capacity + sizeof array->size +
+		    array->capacity * sizeof(struct vmci_handle) *
+		    VMCI_ARR_CAP_MULT;
+		struct vmci_handle_arr *newArray = (struct vmci_handle_arr *)
+		    kmalloc(arraySize, GFP_ATOMIC);
+
+		if (newArray == NULL)
+			return;
+
+		memcpy(newArray, array, arraySize);
+		newArray->capacity *= VMCI_ARR_CAP_MULT;
+		kfree(array);
+		*arrayPtr = newArray;
+		array = newArray;
+	}
+	array->entries[array->size] = handle;
+	array->size++;
+}
+
+/*
+ *-----------------------------------------------------------------------------------
+ *
+ * VMCIHandleArray_RemoveEntry --
+ *
+ * Results:
+ *      Handle that was removed, VMCI_INVALID_HANDLE if entry not found.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------------
+ */
+
+static inline struct vmci_handle
+VMCIHandleArray_RemoveEntry(struct vmci_handle_arr *array,
+			    struct vmci_handle entryHandle)
+{
+	uint32_t i;
+	struct vmci_handle handle = VMCI_INVALID_HANDLE;
+
+	ASSERT(array);
+	for (i = 0; i < array->size; i++) {
+		if (VMCI_HANDLE_EQUAL(array->entries[i], entryHandle)) {
+			handle = array->entries[i];
+			array->size--;
+			array->entries[i] = array->entries[array->size];
+			array->entries[array->size] = VMCI_INVALID_HANDLE;
+			break;
+		}
+	}
+
+	return handle;
+}
+
+/*
+ *-----------------------------------------------------------------------------------
+ *
+ * VMCIHandleArray_RemoveTail --
+ *
+ * Results:
+ *      Handle that was removed, VMCI_INVALID_HANDLE if array was empty.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------------
+ */
+
+static inline struct vmci_handle
+VMCIHandleArray_RemoveTail(struct vmci_handle_arr *array)
+{
+	struct vmci_handle handle = VMCI_INVALID_HANDLE;
+
+	if (array->size) {
+		array->size--;
+		handle = array->entries[array->size];
+		array->entries[array->size] = VMCI_INVALID_HANDLE;
+	}
+
+	return handle;
+}
+
+/*
+ *-----------------------------------------------------------------------------------
+ *
+ * VMCIHandleArray_GetEntry --
+ *
+ * Results:
+ *      Handle at given index, VMCI_INVALID_HANDLE if invalid index.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------------
+ */
+
+static inline struct vmci_handle
+VMCIHandleArray_GetEntry(const struct vmci_handle_arr *array, uint32_t index)
+{
+	ASSERT(array);
+
+	if (unlikely(index >= array->size))
+		return VMCI_INVALID_HANDLE;
+
+	return array->entries[index];
+}
+
+/*
+ *-----------------------------------------------------------------------------------
+ *
+ * VMCIHandleArray_GetSize --
+ *
+ * Results:
+ *      Number of entries in array.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------------
+ */
+
+static inline uint32_t
+VMCIHandleArray_GetSize(const struct vmci_handle_arr *array)
+{
+	ASSERT(array);
+	return array->size;
+}
+
+/*
+ *-----------------------------------------------------------------------------------
+ *
+ * VMCIHandleArray_HasEntry --
+ *
+ * Results:
+ *      true is entry exists in array, false if not.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------------
+ */
+
+static inline bool
+VMCIHandleArray_HasEntry(const struct vmci_handle_arr *array,
+			 struct vmci_handle entryHandle)
+{
+	uint32_t i;
+
+	ASSERT(array);
+	for (i = 0; i < array->size; i++)
+		if (VMCI_HANDLE_EQUAL(array->entries[i], entryHandle))
+			return true;
+
+	return false;
+}
+
+/*
+ *-----------------------------------------------------------------------------------
+ *
+ * VMCIHandleArray_GetCopy --
+ *
+ * Results:
+ *      Returns pointer to copy of array on success or NULL, if memory allocation
+ *      fails.
+ *
+ * Side effects:
+ *      Allocates nonpaged memory.
+ *
+ *-----------------------------------------------------------------------------------
+ */
+
+static inline struct vmci_handle_arr *VMCIHandleArray_GetCopy(const struct
+							      vmci_handle_arr
+							      *array)
+{
+	struct vmci_handle_arr *arrayCopy;
+
+	ASSERT(array);
+
+	arrayCopy =
+	    (struct vmci_handle_arr *)kmalloc(sizeof array->capacity +
+					      sizeof array->size +
+					      array->size *
+					      sizeof(struct vmci_handle),
+					      GFP_ATOMIC);
+	if (arrayCopy != NULL) {
+		memcpy(&arrayCopy->size, &array->size,
+		       sizeof array->size +
+		       array->size * sizeof(struct vmci_handle));
+		arrayCopy->capacity = array->size;
+	}
+
+	return arrayCopy;
+}
+
+/*
+ *-----------------------------------------------------------------------------------
+ *
+ * VMCIHandleArray_GetHandles --
+ *
+ * Results:
+ *      NULL if the array is empty. Otherwise, a pointer to the array
+ *      of VMCI handles in the handle array.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------------
+ */
+
+static inline struct vmci_handle *VMCIHandleArray_GetHandles(struct vmci_handle_arr *array)	// IN
+{
+	ASSERT(array);
+
+	if (array->size)
+		return array->entries;
+
+	return NULL;
+}
+
+#endif				// _VMCI_HANDLE_ARRAY_H_
diff --git a/drivers/misc/vmw_vmci/vmci_infrastructure.h b/drivers/misc/vmw_vmci/vmci_infrastructure.h
new file mode 100644
index 0000000..04a9ba6
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmci_infrastructure.h
@@ -0,0 +1,119 @@
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
+#ifndef _VMCI_INFRASTRUCTURE_H_
+#define _VMCI_INFRASTRUCTURE_H_
+
+#include "vmci_defs.h"
+
+typedef enum {
+	VMCIOBJ_VMX_VM = 10,
+	VMCIOBJ_CONTEXT,
+	VMCIOBJ_SOCKET,
+	VMCIOBJ_NOT_SET,
+} VMCIObjType;
+
+/* For storing VMCI structures in file handles. */
+typedef struct VMCIObj {
+	void *ptr;
+	VMCIObjType type;
+} VMCIObj;
+
+/* Guestcalls currently support a maximum of 8 uint64_t arguments. */
+#define VMCI_GUESTCALL_MAX_ARGS_SIZE 64
+
+/*
+ * Structure used for checkpointing the doorbell mappings. It is
+ * written to the checkpoint as is, so changing this structure will
+ * break checkpoint compatibility.
+ */
+struct dbell_cpt_state {
+	struct vmci_handle handle;
+	uint64_t bitmapIdx;
+};
+
+/* Used to determine what checkpoint state to get and set. */
+#define VMCI_NOTIFICATION_CPT_STATE 0x1
+#define VMCI_WELLKNOWN_CPT_STATE    0x2
+#define VMCI_DG_OUT_STATE           0x3
+#define VMCI_DG_IN_STATE            0x4
+#define VMCI_DG_IN_SIZE_STATE       0x5
+#define VMCI_DOORBELL_CPT_STATE     0x6
+
+/*
+ *-------------------------------------------------------------------------
+ *
+ *  VMCI_Hash --
+ *
+ *     Hash function used by the Simple Datagram API. Based on the djb2
+ *     hash function by Dan Bernstein.
+ *
+ *  Result:
+ *     Returns guest call size.
+ *
+ *  Side effects:
+ *     None.
+ *
+ *-------------------------------------------------------------------------
+ */
+
+static inline int VMCI_Hash(struct vmci_handle handle, unsigned size)
+{
+	unsigned i;
+	int hash = 5381;
+	const uint64_t handleValue = QWORD(handle.resource, handle.context);
+
+	for (i = 0; i < sizeof handle; i++)
+		hash =
+		    ((hash << 5) + hash) + (uint8_t) (handleValue >> (i * 8));
+
+	return hash & (size - 1);
+}
+
+/*
+ *-------------------------------------------------------------------------
+ *
+ *  VMCI_HashId --
+ *
+ *     Hash function used by the Simple Datagram API. Hashes only a VMCI id
+ *     (not the full VMCI handle) Based on the djb2
+ *     hash function by Dan Bernstein.
+ *
+ *  Result:
+ *     Returns guest call size.
+ *
+ *  Side effects:
+ *     None.
+ *
+ *-------------------------------------------------------------------------
+ */
+
+static inline int VMCI_HashId(uint32_t id, unsigned size)
+{
+	unsigned i;
+	int hash = 5381;
+
+	for (i = 0; i < sizeof id; i++)
+		hash = ((hash << 5) + hash) + (uint8_t) (id >> (i * 8));
+
+	return hash & (size - 1);
+}
+
+#endif				// _VMCI_INFRASTRUCTURE_H_
diff --git a/drivers/misc/vmw_vmci/vmci_iocontrols.h b/drivers/misc/vmw_vmci/vmci_iocontrols.h
new file mode 100644
index 0000000..06f5776
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmci_iocontrols.h
@@ -0,0 +1,411 @@
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
+#ifndef _VMCI_IOCONTROLS_H_
+#define _VMCI_IOCONTROLS_H_
+
+#include "vmci_defs.h"
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIVA64ToPtr --
+ *
+ *      Convert a VA64 to a pointer.
+ *
+ * Results:
+ *      Virtual address.
+ *
+ * Side effects:
+ *      None
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static inline void *VMCIVA64ToPtr(uint64_t va64)	// IN
+{
+#ifdef CONFIG_X86_64
+	ASSERT_ON_COMPILE(sizeof(void *) == 8);
+#else
+	ASSERT_ON_COMPILE(sizeof(void *) == 4);
+	/* Check that nothing of value will be lost. */
+	ASSERT(!(va64 >> 32));
+#endif
+	return (void *)(uintptr_t) va64;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIPtrToVA64 --
+ *
+ *      Convert a pointer to a uint64_t.
+ *
+ * Results:
+ *      Virtual address.
+ *
+ * Side effects:
+ *      None
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+static inline uint64_t VMCIPtrToVA64(void const *ptr)	// IN
+{
+	ASSERT_ON_COMPILE(sizeof ptr <= sizeof(uint64_t));
+	return (uint64_t) (uintptr_t) ptr;
+}
+
+/*
+ * Driver version.
+ *
+ * Increment major version when you make an incompatible change.
+ * Compatibility goes both ways (old driver with new executable
+ * as well as new driver with old executable).
+ */
+#define VMCI_VERSION_SHIFT_WIDTH   16	/* Never change this. */
+#define VMCI_MAKE_VERSION(_major, _minor)    ((_major) <<		\
+                                              VMCI_VERSION_SHIFT_WIDTH | \
+                                              (uint16_t) (_minor))
+#define VMCI_VERSION_MAJOR(v)  ((uint32) (v) >> VMCI_VERSION_SHIFT_WIDTH)
+#define VMCI_VERSION_MINOR(v)  ((uint16_t) (v))
+
+/*
+ * VMCI_VERSION is always the current version.  Subsequently listed
+ * versions are ways of detecting previous versions of the connecting
+ * application (i.e., VMX).
+ *
+ * VMCI_VERSION_NOVMVM: This version removed support for VM to VM
+ * communication.
+ *
+ * VMCI_VERSION_NOTIFY: This version introduced doorbell notification
+ * support.
+ *
+ * VMCI_VERSION_HOSTQP: This version introduced host end point support
+ * for hosted products.
+ *
+ * VMCI_VERSION_PREHOSTQP: This is the version prior to the adoption of
+ * support for host end-points.
+ *
+ * VMCI_VERSION_PREVERS2: This fictional version number is intended to
+ * represent the version of a VMX which doesn't call into the driver
+ * with ioctl VERSION2 and thus doesn't establish its version with the
+ * driver.
+ */
+
+#define VMCI_VERSION                VMCI_VERSION_NOVMVM
+#define VMCI_VERSION_NOVMVM         VMCI_MAKE_VERSION(11, 0)
+#define VMCI_VERSION_NOTIFY         VMCI_MAKE_VERSION(10, 0)
+#define VMCI_VERSION_HOSTQP         VMCI_MAKE_VERSION(9, 0)
+#define VMCI_VERSION_PREHOSTQP      VMCI_MAKE_VERSION(8, 0)
+#define VMCI_VERSION_PREVERS2       VMCI_MAKE_VERSION(1, 0)
+
+/*
+ * Linux defines _IO* macros, but the core kernel code ignore the encoded
+ * ioctl value. It is up to individual drivers to decode the value (for
+ * example to look at the size of a structure to determine which version
+ * of a specific command should be used) or not (which is what we
+ * currently do, so right now the ioctl value for a given command is the
+ * command itself).
+ *
+ * Hence, we just define the IOCTL_VMCI_foo values directly, with no
+ * intermediate IOCTLCMD_ representation.
+ */
+#  define IOCTLCMD(_cmd) IOCTL_VMCI_ ## _cmd
+
+enum IOCTLCmd_VMCI {
+	/*
+	 * We need to bracket the range of values used for ioctls, because x86_64
+	 * Linux forces us to explicitly register ioctl handlers by value for
+	 * handling 32 bit ioctl syscalls.  Hence FIRST and LAST.  Pick something
+	 * for FIRST that doesn't collide with vmmon (2001+).
+	 */
+	IOCTLCMD(FIRST) = 1951,
+	IOCTLCMD(VERSION) = IOCTLCMD(FIRST),
+
+	/* BEGIN VMCI */
+	IOCTLCMD(INIT_CONTEXT),
+
+	/*
+	 * The following two were used for process and datagram process creation.
+	 * They are not used anymore and reserved for future use.
+	 * They will fail if issued.
+	 */
+	IOCTLCMD(RESERVED1),
+	IOCTLCMD(RESERVED2),
+
+	/*
+	 * The following used to be for shared memory. It is now unused and and is
+	 * reserved for future use. It will fail if issued.
+	 */
+	IOCTLCMD(RESERVED3),
+
+	/*
+	 * The follwoing three were also used to be for shared memory. An
+	 * old WS6 user-mode client might try to use them with the new
+	 * driver, but since we ensure that only contexts created by VMX'en
+	 * of the appropriate version (VMCI_VERSION_NOTIFY or
+	 * VMCI_VERSION_NEWQP) or higher use these ioctl, everything is
+	 * fine.
+	 */
+	IOCTLCMD(QUEUEPAIR_SETVA),
+	IOCTLCMD(NOTIFY_RESOURCE),
+	IOCTLCMD(NOTIFICATIONS_RECEIVE),
+	IOCTLCMD(VERSION2),
+	IOCTLCMD(QUEUEPAIR_ALLOC),
+	IOCTLCMD(QUEUEPAIR_SETPAGEFILE),
+	IOCTLCMD(QUEUEPAIR_DETACH),
+	IOCTLCMD(DATAGRAM_SEND),
+	IOCTLCMD(DATAGRAM_RECEIVE),
+	IOCTLCMD(DATAGRAM_REQUEST_MAP),
+	IOCTLCMD(DATAGRAM_REMOVE_MAP),
+	IOCTLCMD(CTX_ADD_NOTIFICATION),
+	IOCTLCMD(CTX_REMOVE_NOTIFICATION),
+	IOCTLCMD(CTX_GET_CPT_STATE),
+	IOCTLCMD(CTX_SET_CPT_STATE),
+	IOCTLCMD(GET_CONTEXT_ID),
+	/* END VMCI */
+
+	/*
+	 * BEGIN VMCI SOCKETS
+	 * XXX: NEEDED?
+	 *
+	 * We mark the end of the vmci commands and the start of the vmci sockets
+	 * commands since they are used in separate modules on Linux.
+	 * */
+	IOCTLCMD(LAST),
+	IOCTLCMD(SOCKETS_FIRST) = IOCTLCMD(LAST),
+
+	/*
+	 * This used to be for accept() on Windows and Mac OS, which is now
+	 * redundant (since we now use real handles).  It is used instead for
+	 * getting the version.  This value is now public, so it cannot change.
+	 */
+	IOCTLCMD(SOCKETS_VERSION) = IOCTLCMD(SOCKETS_FIRST),
+	IOCTLCMD(SOCKETS_BIND),
+
+	/*
+	 * This used to be for close() on Windows and Mac OS, but is no longer
+	 * used for the same reason as accept() above.  It is used instead for
+	 * sending private symbols to the Mac OS driver.
+	 */
+	IOCTLCMD(SOCKETS_SET_SYMBOLS),
+	IOCTLCMD(SOCKETS_CONNECT),
+
+	/*
+	 * The next two values are public (vmci_sockets.h) and cannot be changed.
+	 * That means the number of values above these cannot be changed either
+	 * unless the base index (specified below) is updated accordingly.
+	 */
+	IOCTLCMD(SOCKETS_GET_AF_VALUE),
+	IOCTLCMD(SOCKETS_GET_LOCAL_CID),
+	IOCTLCMD(SOCKETS_GET_SOCK_NAME),
+	IOCTLCMD(SOCKETS_GET_SOCK_OPT),
+	IOCTLCMD(SOCKETS_GET_VM_BY_NAME),
+	IOCTLCMD(SOCKETS_IOCTL),
+	IOCTLCMD(SOCKETS_LISTEN),
+	IOCTLCMD(SOCKETS_RECV),
+	IOCTLCMD(SOCKETS_RECV_FROM),
+	IOCTLCMD(SOCKETS_SELECT),
+	IOCTLCMD(SOCKETS_SEND),
+	IOCTLCMD(SOCKETS_SEND_TO),
+	IOCTLCMD(SOCKETS_SET_SOCK_OPT),
+	IOCTLCMD(SOCKETS_SHUTDOWN),
+	IOCTLCMD(SOCKETS_SOCKET),	/* 1990 on Linux. */
+	/* END VMCI SOCKETS */
+
+	/*
+	 * We reserve a range of 4 ioctls for VMCI Sockets to grow.  We cannot
+	 * reserve many ioctls here since we are close to overlapping with vmmon
+	 * ioctls.  Define a meta-ioctl if running out of this binary space.
+	 *
+	 * Must be last.
+	 */
+	IOCTLCMD(SOCKETS_LAST) = IOCTLCMD(SOCKETS_SOCKET) + 4,	/* 1994 on Linux. */
+
+	/*
+	 * The VSockets ioctls occupy the block above.  We define a new range of
+	 * VMCI ioctls to maintain binary compatibility between the user land and
+	 * the kernel driver.  Careful, vmmon ioctls start from 2001, so this means
+	 * we can add only 4 new VMCI ioctls.  Define a meta-ioctl if running out of
+	 * this binary space.
+	 */
+
+	IOCTLCMD(FIRST2),
+	IOCTLCMD(SET_NOTIFY) = IOCTLCMD(FIRST2),	/* 1995 on Linux. */
+	IOCTLCMD(LAST2),
+};
+
+/* Clean up helper macros */
+#undef IOCTLCMD
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
+struct vmci_qp_ai_vmvm {
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
+/* VMCIQueuePairAllocInfo */
+struct vmci_qp_alloc_info {
+	struct vmci_handle handle;
+	uint32_t peer;
+	uint32_t flags;
+	uint64_t produceSize;
+	uint64_t consumeSize;
+	uint64_t ppnVA;		/* Start VA of queue pair PPNs. */
+	uint64_t numPPNs;
+	int32_t result;
+	uint32_t version;
+};
+
+/* VMCIQueuePairSetVAInfo */
+struct vmci_qp_set_va_info {
+	struct vmci_handle handle;
+	uint64_t va;		/* Start VA of queue pair PPNs. */
+	uint64_t numPPNs;
+	uint32_t version;
+	int32_t result;
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
+/* VMCIQueuePairPageFileInfo */
+struct vmci_qp_page_file_info {
+	struct vmci_handle handle;
+	uint64_t producePageFile;	/* User VA. */
+	uint64_t consumePageFile;	/* User VA. */
+	uint64_t producePageFileSize;	/* Size of the file name array. */
+	uint64_t consumePageFileSize;	/* Size of the file name array. */
+	int32_t result;
+	uint32_t version;	/* Was _pad. */
+	uint64_t produceVA;	/* User VA of the mapped file. */
+	uint64_t consumeVA;	/* User VA of the mapped file. */
+};
+
+/* VMCIQueuePairDetachInfo */
+struct vmci_qp_dtch_info {
+	struct vmci_handle handle;
+	int32_t result;
+	uint32_t _pad;
+};
+
+/* VMCIDatagramSendRecvInfo */
+struct vmci_dg_snd_rcv_info {
+	uint64_t addr;
+	uint32_t len;
+	int32_t result;
+};
+
+/* VMCINotifyAddRemoveInfo: Used to add/remove remote context notifications. */
+struct vmci_notify_add_rm_info {
+	uint32_t remoteCID;
+	int result;
+};
+
+/* VMCICptBufInfo: Used to set/get current context's checkpoint state. */
+struct vmci_chkpt_buf_info {
+	uint64_t cptBuf;
+	uint32_t cptType;
+	uint32_t bufSize;
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
+#define VMCI_NOTIFY_RESOURCE_QUEUE_PAIR 0
+#define VMCI_NOTIFY_RESOURCE_DOOR_BELL  1
+
+#define VMCI_NOTIFY_RESOURCE_ACTION_NOTIFY  0
+#define VMCI_NOTIFY_RESOURCE_ACTION_CREATE  1
+#define VMCI_NOTIFY_RESOURCE_ACTION_DESTROY 2
+
+/*
+ * VMCINotifyResourceInfo: Used to create and destroy doorbells, and
+ * generate a notification for a doorbell or queue pair.
+ */
+struct vmci_notify_rsrc_info {
+	struct vmci_handle handle;
+	uint16_t resource;
+	uint16_t action;
+	int32_t result;
+};
+
+/*
+ * VMCINotificationReceiveInfo: Used to recieve pending notifications
+ * for doorbells and queue pairs.
+ */
+struct vmci_notify_recv_info {
+	uint64_t dbHandleBufUVA;
+	uint64_t dbHandleBufSize;
+	uint64_t qpHandleBufUVA;
+	uint64_t qpHandleBufSize;
+	int32_t result;
+	uint32_t _pad;
+};
+
+#endif				// ifndef _VMCI_IOCONTROLS_H_
diff --git a/drivers/misc/vmw_vmci/vmci_kernel_if.h b/drivers/misc/vmw_vmci/vmci_kernel_if.h
new file mode 100644
index 0000000..9b4e114
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmci_kernel_if.h
@@ -0,0 +1,111 @@
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
+/*
+ * This file defines helper functions for VMCI host _and_ guest
+ * kernel code.
+ */
+
+#ifndef _VMCI_KERNEL_IF_H_
+#define _VMCI_KERNEL_IF_H_
+
+#include <linux/kernel.h>
+#include <linux/wait.h>
+
+#include "vmci_defs.h"
+
+/* Callback needed for correctly waiting on events. */
+typedef int (*VMCIEventReleaseCB) (void *clientData);
+
+/* Host specific struct used for signalling */
+struct vmci_host {
+	wait_queue_head_t waitQueue;
+};
+
+/* Guest device port I/O. */
+bool VMCIHost_WaitForCallLocked(struct vmci_host *hostContext,
+				spinlock_t * lock,
+				unsigned long *flags, bool useBH);
+
+bool VMCIWellKnownID_AllowMap(uint32_t wellKnownID, uint32_t privFlags);
+
+int VMCIHost_CompareUser(uid_t * user1, uid_t * user2);
+
+void VMCI_WaitOnEvent(wait_queue_head_t * event,
+		      VMCIEventReleaseCB releaseCB, void *clientData);
+
+bool VMCI_WaitOnEventInterruptible(wait_queue_head_t * event,
+				   VMCIEventReleaseCB releaseCB,
+				   void *clientData);
+
+typedef void (VMCIWorkFn) (void *data);
+int VMCI_ScheduleDelayedWork(VMCIWorkFn * workFn, void *data);
+
+void *VMCI_AllocQueue(uint64_t size);
+void VMCI_FreeQueue(void *q, uint64_t size);
+struct PPNSet {
+	uint64_t numProducePages;
+	uint64_t numConsumePages;
+	uint32_t *producePPNs;
+	uint32_t *consumePPNs;
+	bool initialized;
+};
+int VMCI_AllocPPNSet(void *produceQ, uint64_t numProducePages,
+		     void *consumeQ, uint64_t numConsumePages,
+		     struct PPNSet *ppnSet);
+void VMCI_FreePPNSet(struct PPNSet *ppnSet);
+int VMCI_PopulatePPNList(uint8_t * callBuf, const struct PPNSet *ppnSet);
+
+struct vmci_queue;
+
+struct PageStoreAttachInfo;
+struct vmci_queue *VMCIHost_AllocQueue(uint64_t queueSize);
+void VMCIHost_FreeQueue(struct vmci_queue *queue, uint64_t queueSize);
+
+#define INVALID_VMCI_GUEST_MEM_ID  0
+
+struct QueuePairPageStore;
+int VMCIHost_RegisterUserMemory(struct QueuePairPageStore *pageStore,
+				struct vmci_queue *produceQ,
+				struct vmci_queue *consumeQ);
+void VMCIHost_UnregisterUserMemory(struct vmci_queue *produceQ,
+				   struct vmci_queue *consumeQ);
+int VMCIHost_MapQueueHeaders(struct vmci_queue *produceQ,
+			     struct vmci_queue *consumeQ);
+int VMCIHost_UnmapQueueHeaders(uint32_t gid,
+			       struct vmci_queue *produceQ,
+			       struct vmci_queue *consumeQ);
+void VMCI_InitQueueMutex(struct vmci_queue *produceQ,
+			 struct vmci_queue *consumeQ);
+void VMCI_CleanupQueueMutex(struct vmci_queue *produceQ,
+			    struct vmci_queue *consumeQ);
+void VMCI_AcquireQueueMutex(struct vmci_queue *queue);
+void VMCI_ReleaseQueueMutex(struct vmci_queue *queue);
+
+int VMCIHost_GetUserMemory(uint64_t produceUVA, uint64_t consumeUVA,
+			   struct vmci_queue *produceQ,
+			   struct vmci_queue *consumeQ);
+void VMCIHost_ReleaseUserMemory(struct vmci_queue *produceQ,
+				struct vmci_queue *consumeQ);
+
+bool VMCI_GuestPersonalityActive(void);
+bool VMCI_HostPersonalityActive(void);
+
+#endif				// _VMCI_KERNEL_IF_H_
-- 
1.7.0.4

