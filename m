Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab2JPAaE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 20:30:04 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:39486 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754771Ab2JPAaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 20:30:00 -0400
Subject: [PATCH 10/10] VMCI: Some header and config files.
To: linux-kernel@vger.kernel.org, georgezhang@vmware.com,
        virtualization@lists.linux-foundation.org
From: George Zhang <georgezhang@vmware.com>
Cc: pv-drivers@vmware.com, vm-crosstalk@vmware.com, gregkh@linuxfoundation.org
Date: Mon, 15 Oct 2012 17:29:59 -0700
Message-ID: <20121016002953.26205.74406.stgit@promb-2n-dhcp175.eng.vmware.com>
In-Reply-To: <20121016002550.26205.67037.stgit@promb-2n-dhcp175.eng.vmware.com>
References: <20121016002550.26205.67037.stgit@promb-2n-dhcp175.eng.vmware.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VMCI header config patch adds all the necessary files to enable building of the VMCI
module with the Linux Makefiles and Kconfig systems. Also adds the header
files used for building modules against the driver.


Signed-off-by: George Zhang <georgezhang@vmware.com>
---
 drivers/misc/Kconfig                    |    1 
 drivers/misc/Makefile                   |    2 
 drivers/misc/vmw_vmci/Kconfig           |   16 +
 drivers/misc/vmw_vmci/Makefile          |   41 +
 drivers/misc/vmw_vmci/vmci_common_int.h |   34 +
 include/linux/vmw_vmci_api.h            |   89 +++
 include/linux/vmw_vmci_defs.h           |  971 +++++++++++++++++++++++++++++++
 7 files changed, 1154 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/vmw_vmci/Kconfig
 create mode 100644 drivers/misc/vmw_vmci/Makefile
 create mode 100644 drivers/misc/vmw_vmci/vmci_common_int.h
 create mode 100644 include/linux/vmw_vmci_api.h
 create mode 100644 include/linux/vmw_vmci_defs.h

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 2661f6e..fe38c7a 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -517,4 +517,5 @@ source "drivers/misc/lis3lv02d/Kconfig"
 source "drivers/misc/carma/Kconfig"
 source "drivers/misc/altera-stapl/Kconfig"
 source "drivers/misc/mei/Kconfig"
+source "drivers/misc/vmw_vmci/Kconfig"
 endmenu
diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
index 456972f..21ed953 100644
--- a/drivers/misc/Makefile
+++ b/drivers/misc/Makefile
@@ -51,3 +51,5 @@ obj-y				+= carma/
 obj-$(CONFIG_USB_SWITCH_FSA9480) += fsa9480.o
 obj-$(CONFIG_ALTERA_STAPL)	+=altera-stapl/
 obj-$(CONFIG_INTEL_MEI)		+= mei/
+obj-$(CONFIG_MAX8997_MUIC)	+= max8997-muic.o
+obj-$(CONFIG_VMWARE_VMCI)	+= vmw_vmci/
diff --git a/drivers/misc/vmw_vmci/Kconfig b/drivers/misc/vmw_vmci/Kconfig
new file mode 100644
index 0000000..55015e7
--- /dev/null
+++ b/drivers/misc/vmw_vmci/Kconfig
@@ -0,0 +1,16 @@
+#
+# VMware VMCI device
+#
+
+config VMWARE_VMCI
+	tristate "VMware VMCI Driver"
+	depends on X86
+	help
+	  This is VMware's Virtual Machine Communication Interface.  It enables
+	  high-speed communication between host and guest in a virtual
+	  environment via the VMCI virtual device.
+
+	  If unsure, say N.
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called vmw_vmci.
diff --git a/drivers/misc/vmw_vmci/Makefile b/drivers/misc/vmw_vmci/Makefile
new file mode 100644
index 0000000..bcc3b6c
--- /dev/null
+++ b/drivers/misc/vmw_vmci/Makefile
@@ -0,0 +1,41 @@
+################################################################################
+#
+# Linux driver for VMware's VMCI device.
+#
+# Copyright (C) 2007-2012, VMware, Inc. All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or modify it
+# under the terms of the GNU General Public License as published by the
+# Free Software Foundation; version 2 of the License and no later version.
+#
+# This program is distributed in the hope that it will be useful, but
+# WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
+# NON INFRINGEMENT.  See the GNU General Public License for more
+# details.
+#
+# Maintained by: Andrew Stiegmann <pv-drivers@vmware.com>
+#
+################################################################################
+
+#
+# Makefile for the VMware VMCI
+#
+
+obj-$(CONFIG_VMWARE_VMCI) += vmw_vmci.o
+
+vmw_vmci-y += vmci_context.o
+vmw_vmci-y += vmci_datagram.o
+vmw_vmci-y += vmci_doorbell.o
+vmw_vmci-y += vmci_driver.o
+vmw_vmci-y += vmci_event.o
+vmw_vmci-y += vmci_handle_array.o
+vmw_vmci-y += vmci_queue_pair.o
+vmw_vmci-y += vmci_resource.o
+vmw_vmci-y += vmci_route.o
+
+vmci:
+	$(MAKE) -C ../../.. SUBDIRS=$$PWD CONFIG_VMWARE_VMCI=m modules
+
+clean:
+	$(MAKE) -C ../../.. SUBDIRS=$$PWD CONFIG_VMWARE_VMCI=m clean
diff --git a/drivers/misc/vmw_vmci/vmci_common_int.h b/drivers/misc/vmw_vmci/vmci_common_int.h
new file mode 100644
index 0000000..77667ec
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmci_common_int.h
@@ -0,0 +1,34 @@
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
+ */
+
+#ifndef _VMCI_COMMONINT_H_
+#define _VMCI_COMMONINT_H_
+
+#include <linux/printk.h>
+
+#define ASSERT(cond) BUG_ON(!(cond))
+
+#define PCI_VENDOR_ID_VMWARE	0x15AD
+#define PCI_DEVICE_ID_VMWARE_VMCI	0x0740
+#define VMCI_DRIVER_VERSION_STRING	"1.0.0.0-k"
+#define MODULE_NAME "vmw_vmci"
+
+/* Print magic... whee! */
+#ifdef pr_fmt
+#undef pr_fmt
+#define pr_fmt(fmt) MODULE_NAME ": " fmt
+#endif
+
+#endif /* _VMCI_COMMONINT_H_ */
diff --git a/include/linux/vmw_vmci_api.h b/include/linux/vmw_vmci_api.h
new file mode 100644
index 0000000..73f8d68
--- /dev/null
+++ b/include/linux/vmw_vmci_api.h
@@ -0,0 +1,89 @@
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
+ */
+
+#ifndef __VMW_VMCI_API_H__
+#define __VMW_VMCI_API_H__
+
+#include <linux/uidgid.h>
+#include <linux/vmw_vmci_defs.h>
+
+#undef  VMCI_KERNEL_API_VERSION
+#define VMCI_KERNEL_API_VERSION_1 1
+#define VMCI_KERNEL_API_VERSION_2 2
+#define VMCI_KERNEL_API_VERSION   VMCI_KERNEL_API_VERSION_2
+
+typedef void (vmci_device_shutdown_fn) (void *device_registration,
+					void *user_data);
+
+bool vmci_device_get(u32 *api_version,
+		     vmci_device_shutdown_fn *device_shutdown_cb,
+		     void *user_data, void **device_registration);
+void vmci_device_release(void *device_registration);
+int vmci_datagram_create_handle(u32 resource_id, u32 flags,
+				vmci_datagram_recv_cb recv_cb,
+				void *client_data,
+				struct vmci_handle *out_handle);
+int vmci_datagram_create_handle_priv(u32 resource_id, u32 flags, u32 priv_flags,
+				     vmci_datagram_recv_cb recv_cb,
+				     void *client_data,
+				     struct vmci_handle *out_handle);
+int vmci_datagram_destroy_handle(struct vmci_handle handle);
+int vmci_datagram_send(struct vmci_datagram *msg);
+int vmci_doorbell_create(struct vmci_handle *handle, u32 flags,
+			 u32 priv_flags,
+			 vmci_callback notify_cb, void *client_data);
+int vmci_doorbell_destroy(struct vmci_handle handle);
+int vmci_doorbell_notify(struct vmci_handle handle, u32 priv_flags);
+u32 vmci_get_contextid(void);
+u32 vmci_version(void);
+int vmci_context_id_to_host_vmid(u32 context_id, void *host_vmid,
+				 size_t host_vmid_len);
+bool vmci_is_context_owner(u32 context_id, kuid_t uid);
+
+int vmci_event_subscribe(u32 event, u32 flags,
+			 vmci_event_cb callback, void *callback_data,
+			 u32 *subid);
+int vmci_event_unsubscribe(u32 subid);
+u32 vmci_context_get_priv_flags(u32 context_id);
+int vmci_qpair_alloc(struct vmci_qp **qpair,
+		     struct vmci_handle *handle,
+		     u64 produce_qsize,
+		     u64 consume_qsize,
+		     u32 peer, u32 flags, u32 priv_flags);
+int vmci_qpair_detach(struct vmci_qp **qpair);
+int vmci_qpair_get_produce_indexes(const struct vmci_qp *qpair,
+				   u64 *producer_tail,
+				   u64 *consumer_head);
+int vmci_qpair_get_consume_indexes(const struct vmci_qp *qpair,
+				   u64 *consumer_tail,
+				   u64 *producer_head);
+s64 vmci_qpair_produce_free_space(const struct vmci_qp *qpair);
+s64 vmci_qpair_produce_buf_ready(const struct vmci_qp *qpair);
+s64 vmci_qpair_consume_free_space(const struct vmci_qp *qpair);
+s64 vmci_qpair_consume_buf_ready(const struct vmci_qp *qpair);
+ssize_t vmci_qpair_enqueue(struct vmci_qp *qpair,
+			   const void *buf, size_t buf_size, int mode);
+ssize_t vmci_qpair_dequeue(struct vmci_qp *qpair,
+			   void *buf, size_t buf_size, int mode);
+ssize_t vmci_qpair_peek(struct vmci_qp *qpair, void *buf, size_t buf_size,
+			int mode);
+ssize_t vmci_qpair_enquev(struct vmci_qp *qpair,
+			  void *iov, size_t iov_size, int mode);
+ssize_t vmci_qpair_dequev(struct vmci_qp *qpair,
+			  void *iov, size_t iov_size, int mode);
+ssize_t vmci_qpair_peekv(struct vmci_qp *qpair, void *iov, size_t iov_size,
+			 int mode);
+
+#endif /* !__VMW_VMCI_API_H__ */
diff --git a/include/linux/vmw_vmci_defs.h b/include/linux/vmw_vmci_defs.h
new file mode 100644
index 0000000..119c161
--- /dev/null
+++ b/include/linux/vmw_vmci_defs.h
@@ -0,0 +1,971 @@
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
+ */
+
+#ifndef _VMW_VMCI_DEF_H_
+#define _VMW_VMCI_DEF_H_
+
+#include <linux/atomic.h>
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
+	VMCI_INTR_TYPE_MSIX = 2,
+};
+
+/* Maximum MSI/MSI-X interrupt vectors in the device. */
+#define VMCI_MAX_INTRS 2
+
+/*
+ * Supported interrupt vectors.  There is one for each ICR value above,
+ * but here they indicate the position in the vector array/message ID.
+ */
+enum {
+	VMCI_INTR_DATAGRAM = 0,
+	VMCI_INTR_NOTIFICATION = 1,
+};
+
+/*
+ * A single VMCI device has an upper limit of 128MB on the amount of
+ * memory that can be used for queue pairs.
+ */
+#define VMCI_MAX_GUEST_QP_MEMORY (128 * 1024 * 1024)
+
+/*
+ * Queues with pre-mapped data pages must be small, so that we don't pin
+ * too much kernel memory (especially on vmkernel).  We limit a queuepair to
+ * 32 KB, or 16 KB per queue for symmetrical pairs.
+ */
+#define VMCI_MAX_PINNED_QP_MEMORY (32 * 1024)
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
+enum {
+	VMCI_RESOURCES_QUERY = 0,
+	VMCI_GET_CONTEXT_ID = 1,
+	VMCI_SET_NOTIFY_BITMAP = 2,
+	VMCI_DOORBELL_LINK = 3,
+	VMCI_DOORBELL_UNLINK = 4,
+	VMCI_DOORBELL_NOTIFY = 5,
+	/*
+	 * VMCI_DATAGRAM_REQUEST_MAP and VMCI_DATAGRAM_REMOVE_MAP are
+	 * obsoleted by the removal of VM to VM communication.
+	 */
+	VMCI_DATAGRAM_REQUEST_MAP = 6,
+	VMCI_DATAGRAM_REMOVE_MAP = 7,
+	VMCI_EVENT_SUBSCRIBE = 8,
+	VMCI_EVENT_UNSUBSCRIBE = 9,
+	VMCI_QUEUEPAIR_ALLOC = 10,
+	VMCI_QUEUEPAIR_DETACH = 11,
+
+	/*
+	 * VMCI_VSOCK_VMX_LOOKUP was assigned to 12 for Fusion 3.0/3.1,
+	 * WS 7.0/7.1 and ESX 4.1
+	 */
+	VMCI_HGFS_TRANSPORT = 13,
+	VMCI_UNITY_PBRPC_REGISTER = 14,
+	VMCI_RPC_PRIVILEGED = 15,
+	VMCI_RPC_UNPRIVILEGED = 16,
+	VMCI_RESOURCE_MAX = 17,
+};
+
+/*
+ * struct vmci_handle - Ownership information structure
+ * @context:    The VMX context ID.
+ * @resource:   The resource ID (used for locating in resource hash).
+ *
+ * The vmci_handle structure is used to track resources used within
+ * vmw_vmci.
+ */
+struct vmci_handle {
+	u32 context;
+	u32 resource;
+};
+
+typedef u32 vmci_id;
+typedef u32 vmci_privilege_flags;
+typedef u32 vmci_event;
+
+static inline struct vmci_handle VMCI_MAKE_HANDLE(vmci_id cid, vmci_id rid)
+{
+	struct vmci_handle h;
+	h.context = cid;
+	h.resource = rid;
+	return h;
+}
+
+#define VMCI_HANDLE_TO_CONTEXT_ID(_handle) ((_handle).context)
+#define VMCI_HANDLE_TO_RESOURCE_ID(_handle) ((_handle).resource)
+#define VMCI_HANDLE_EQUAL(_h1, _h2) ((_h1).context == (_h2).context &&	\
+				     (_h1).resource == (_h2).resource)
+
+#define VMCI_INVALID_ID ~0
+static const struct vmci_handle VMCI_INVALID_HANDLE = { VMCI_INVALID_ID,
+	VMCI_INVALID_ID
+};
+
+#define VMCI_HANDLE_INVALID(_handle)				            \
+	VMCI_HANDLE_EQUAL((_handle), VMCI_INVALID_HANDLE)
+
+/*
+ * The below defines can be used to send anonymous requests.
+ * This also indicates that no response is expected.
+ */
+#define VMCI_ANON_SRC_CONTEXT_ID   VMCI_INVALID_ID
+#define VMCI_ANON_SRC_RESOURCE_ID  VMCI_INVALID_ID
+#define VMCI_ANON_SRC_HANDLE       vmci_make_handle(VMCI_ANON_SRC_CONTEXT_ID, \
+						    VMCI_ANON_SRC_RESOURCE_ID)
+
+/* The lowest 16 context ids are reserved for internal use. */
+#define VMCI_RESERVED_CID_LIMIT ((u32) 16)
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
+#define VMCI_CONTEXT_IS_VM(_cid) (VMCI_INVALID_ID != (_cid) &&		\
+				  (_cid) > VMCI_HOST_CONTEXT_ID)
+
+/*
+ * The VMCI_CONTEXT_RESOURCE_ID is used together with vmci_make_handle to make
+ * handles that refer to a specific context.
+ */
+#define VMCI_CONTEXT_RESOURCE_ID 0
+
+/*
+ * VMCI error codes.
+ */
+enum {
+	VMCI_SUCCESS_QUEUEPAIR_ATTACH	= 5,
+	VMCI_SUCCESS_QUEUEPAIR_CREATE	= 4,
+	VMCI_SUCCESS_LAST_DETACH	= 3,
+	VMCI_SUCCESS_ACCESS_GRANTED	= 2,
+	VMCI_SUCCESS_ENTRY_DEAD		= 1,
+	VMCI_SUCCESS			 = 0,
+	VMCI_ERROR_INVALID_RESOURCE	 = (-1),
+	VMCI_ERROR_INVALID_ARGS		 = (-2),
+	VMCI_ERROR_NO_MEM		 = (-3),
+	VMCI_ERROR_DATAGRAM_FAILED	 = (-4),
+	VMCI_ERROR_MORE_DATA		 = (-5),
+	VMCI_ERROR_NO_MORE_DATAGRAMS	 = (-6),
+	VMCI_ERROR_NO_ACCESS		 = (-7),
+	VMCI_ERROR_NO_HANDLE		 = (-8),
+	VMCI_ERROR_DUPLICATE_ENTRY	 = (-9),
+	VMCI_ERROR_DST_UNREACHABLE	 = (-10),
+	VMCI_ERROR_PAYLOAD_TOO_LARGE	 = (-11),
+	VMCI_ERROR_INVALID_PRIV		 = (-12),
+	VMCI_ERROR_GENERIC		 = (-13),
+	VMCI_ERROR_PAGE_ALREADY_SHARED	 = (-14),
+	VMCI_ERROR_CANNOT_SHARE_PAGE	 = (-15),
+	VMCI_ERROR_CANNOT_UNSHARE_PAGE	 = (-16),
+	VMCI_ERROR_NO_PROCESS		 = (-17),
+	VMCI_ERROR_NO_DATAGRAM		 = (-18),
+	VMCI_ERROR_NO_RESOURCES		 = (-19),
+	VMCI_ERROR_UNAVAILABLE		 = (-20),
+	VMCI_ERROR_NOT_FOUND		 = (-21),
+	VMCI_ERROR_ALREADY_EXISTS	 = (-22),
+	VMCI_ERROR_NOT_PAGE_ALIGNED	 = (-23),
+	VMCI_ERROR_INVALID_SIZE		 = (-24),
+	VMCI_ERROR_REGION_ALREADY_SHARED = (-25),
+	VMCI_ERROR_TIMEOUT		 = (-26),
+	VMCI_ERROR_DATAGRAM_INCOMPLETE	 = (-27),
+	VMCI_ERROR_INCORRECT_IRQL	 = (-28),
+	VMCI_ERROR_EVENT_UNKNOWN	 = (-29),
+	VMCI_ERROR_OBSOLETE		 = (-30),
+	VMCI_ERROR_QUEUEPAIR_MISMATCH	 = (-31),
+	VMCI_ERROR_QUEUEPAIR_NOTSET	 = (-32),
+	VMCI_ERROR_QUEUEPAIR_NOTOWNER	 = (-33),
+	VMCI_ERROR_QUEUEPAIR_NOTATTACHED = (-34),
+	VMCI_ERROR_QUEUEPAIR_NOSPACE	 = (-35),
+	VMCI_ERROR_QUEUEPAIR_NODATA	 = (-36),
+	VMCI_ERROR_BUSMEM_INVALIDATION	 = (-37),
+	VMCI_ERROR_MODULE_NOT_LOADED	 = (-38),
+	VMCI_ERROR_DEVICE_NOT_FOUND	 = (-39),
+	VMCI_ERROR_QUEUEPAIR_NOT_READY	 = (-40),
+	VMCI_ERROR_WOULD_BLOCK		 = (-41),
+
+	/* VMCI clients should return error code within this range */
+	VMCI_ERROR_CLIENT_MIN		 = (-500),
+	VMCI_ERROR_CLIENT_MAX		 = (-550),
+
+	/* Internal error codes. */
+	VMCI_SHAREDMEM_ERROR_BAD_CONTEXT = (-1000),
+};
+
+/* VMCI reserved events. */
+enum {
+	/* Only applicable to guest endpoints */
+	VMCI_EVENT_CTX_ID_UPDATE  = 0,
+
+	/* Applicable to guest and host */
+	VMCI_EVENT_CTX_REMOVED	  = 1,
+
+	/* Only applicable to guest endpoints */
+	VMCI_EVENT_QP_RESUMED	  = 2,
+
+	/* Applicable to guest and host */
+	VMCI_EVENT_QP_PEER_ATTACH = 3,
+
+	/* Applicable to guest and host */
+	VMCI_EVENT_QP_PEER_DETACH = 4,
+
+	/*
+	 * Applicable to VMX and vmk.  On vmk,
+	 * this event has the Context payload type.
+	 */
+	VMCI_EVENT_MEM_ACCESS_ON  = 5,
+
+	/*
+	 * Applicable to VMX and vmk.  Same as
+	 * above for the payload type.
+	 */
+	VMCI_EVENT_MEM_ACCESS_OFF = 6,
+	VMCI_EVENT_MAX		  = 7,
+};
+
+/*
+ * Of the above events, a few are reserved for use in the VMX, and
+ * other endpoints (guest and host kernel) should not use them. For
+ * the rest of the events, we allow both host and guest endpoints to
+ * subscribe to them, to maintain the same API for host and guest
+ * endpoints.
+ */
+#define VMCI_EVENT_VALID_VMX(_event) ((_event) == VMCI_EVENT_MEM_ACCESS_ON || \
+				      (_event) == VMCI_EVENT_MEM_ACCESS_OFF)
+
+#define VMCI_EVENT_VALID(_event) ((_event) < VMCI_EVENT_MAX &&		\
+				  !VMCI_EVENT_VALID_VMX(_event))
+
+/* Reserved guest datagram resource ids. */
+#define VMCI_EVENT_HANDLER 0
+
+/*
+ * VMCI coarse-grained privileges (per context or host
+ * process/endpoint. An entity with the restricted flag is only
+ * allowed to interact with the hypervisor and trusted entities.
+ */
+enum {
+	VMCI_NO_PRIVILEGE_FLAGS = 0,
+	VMCI_PRIVILEGE_FLAG_RESTRICTED = 1,
+	VMCI_PRIVILEGE_FLAG_TRUSTED = 2,
+	VMCI_PRIVILEGE_ALL_FLAGS = (VMCI_PRIVILEGE_FLAG_RESTRICTED |
+				    VMCI_PRIVILEGE_FLAG_TRUSTED),
+	VMCI_DEFAULT_PROC_PRIVILEGE_FLAGS = VMCI_NO_PRIVILEGE_FLAGS,
+	VMCI_LEAST_PRIVILEGE_FLAGS = VMCI_PRIVILEGE_FLAG_RESTRICTED,
+	VMCI_MAX_PRIVILEGE_FLAGS = VMCI_PRIVILEGE_FLAG_TRUSTED,
+};
+
+/* 0 through VMCI_RESERVED_RESOURCE_ID_MAX are reserved. */
+#define VMCI_RESERVED_RESOURCE_ID_MAX 1023
+
+/*
+ * Driver version.
+ *
+ * Increment major version when you make an incompatible change.
+ * Compatibility goes both ways (old driver with new executable
+ * as well as new driver with old executable).
+ */
+
+/* Never change VMCI_VERSION_SHIFT_WIDTH */
+#define VMCI_VERSION_SHIFT_WIDTH 16
+#define VMCI_MAKE_VERSION(_major, _minor)			\
+	((_major) << VMCI_VERSION_SHIFT_WIDTH | (u16) (_minor))
+
+#define VMCI_VERSION_MAJOR(v)  ((u32) (v) >> VMCI_VERSION_SHIFT_WIDTH)
+#define VMCI_VERSION_MINOR(v)  ((u16) (v))
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
+#define VMCI_SOCKETS_MAKE_VERSION(_p)					\
+	((((_p)[0] & 0xFF) << 24) | (((_p)[1] & 0xFF) << 16) | ((_p)[2]))
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
+#define IOCTLCMD(_cmd) IOCTL_VMCI_ ## _cmd
+
+enum {
+	/*
+	 * We need to bracket the range of values used for ioctls,
+	 * because x86_64 Linux forces us to explicitly register ioctl
+	 * handlers by value for handling 32 bit ioctl syscalls.
+	 * Hence FIRST and LAST.  Pick something for FIRST that
+	 * doesn't collide with vmmon (2001+).
+	 */
+	IOCTLCMD(FIRST) = 1951,
+	IOCTLCMD(VERSION) = IOCTLCMD(FIRST),
+
+	/* BEGIN VMCI */
+	IOCTLCMD(INIT_CONTEXT),
+
+	/*
+	 * The following two were used for process and datagram
+	 * process creation.  They are not used anymore and reserved
+	 * for future use.  They will fail if issued.
+	 */
+	IOCTLCMD(RESERVED1),
+	IOCTLCMD(RESERVED2),
+
+	/*
+	 * The following used to be for shared memory. It is now
+	 * unused and and is reserved for future use. It will fail if
+	 * issued.
+	 */
+	IOCTLCMD(RESERVED3),
+
+	/*
+	 * The follwoing three were also used to be for shared
+	 * memory. An old WS6 user-mode client might try to use them
+	 * with the new driver, but since we ensure that only contexts
+	 * created by VMX'en of the appropriate version
+	 * (VMCI_VERSION_NOTIFY or VMCI_VERSION_NEWQP) or higher use
+	 * these ioctl, everything is fine.
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
+	IOCTLCMD(LAST),
+	/* END VMCI */
+
+	/*
+	 * VMCI Socket IOCTLS are defined next and go from
+	 * IOCTLCMD(LAST) (1972) to 1990.  VMware reserves a range of
+	 * 4 ioctls for VMCI Sockets to grow.  We cannot reserve many
+	 * ioctls here since we are close to overlapping with vmmon
+	 * ioctls (2001+).  Define a meta-ioctl if running out of this
+	 * binary space.
+	 */
+	IOCTLCMD(SOCKETS_FIRST) = IOCTLCMD(LAST),
+	IOCTLCMD(SOCKETS_VERSION) = IOCTLCMD(SOCKETS_FIRST),
+	IOCTLCMD(SOCKETS_BIND),
+	IOCTLCMD(SOCKETS_SET_SYMBOLS),
+	IOCTLCMD(SOCKETS_CONNECT),
+	/*
+	 * The next two values are public (vmci_sockets.h) and cannot be
+	 * changed. That means the number of values above these cannot be
+	 * changed either unless the base index (specified below) is updated
+	 * accordingly.
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
+
+	IOCTLCMD(SOCKETS_LAST) = 1994,	/* 1994 on Linux. */
+
+	/*
+	 * The VSockets ioctls occupy the block above.  We define a
+	 * new range of VMCI ioctls to maintain binary compatibility
+	 * between the user land and the kernel driver.  Careful,
+	 * vmmon ioctls start from 2001, so this means we can add only
+	 * 4 new VMCI ioctls.  Define a meta-ioctl if running out of
+	 * this binary space.
+	 */
+	IOCTLCMD(FIRST2),
+	IOCTLCMD(SET_NOTIFY) = IOCTLCMD(FIRST2),	/* 1995 on Linux. */
+	IOCTLCMD(LAST2),
+};
+
+/* Clean up helper macros */
+#undef IOCTLCMD
+
+/*
+ * struct vmci_queue_header - VMCI Queue Header information.
+ *
+ * A Queue cannot stand by itself as designed.  Each Queue's header
+ * contains a pointer into itself (the producer_tail) and into its peer
+ * (consumer_head).  The reason for the separation is one of
+ * accessibility: Each end-point can modify two things: where the next
+ * location to enqueue is within its produce_q (producer_tail); and
+ * where the next dequeue location is in its consume_q (consumer_head).
+ *
+ * An end-point cannot modify the pointers of its peer (guest to
+ * guest; NOTE that in the host both queue headers are mapped r/w).
+ * But, each end-point needs read access to both Queue header
+ * structures in order to determine how much space is used (or left)
+ * in the Queue.  This is because for an end-point to know how full
+ * its produce_q is, it needs to use the consumer_head that points into
+ * the produce_q but -that- consumer_head is in the Queue header for
+ * that end-points consume_q.
+ *
+ * Thoroughly confused?  Sorry.
+ *
+ * producer_tail: the point to enqueue new entrants.  When you approach
+ * a line in a store, for example, you walk up to the tail.
+ *
+ * consumer_head: the point in the queue from which the next element is
+ * dequeued.  In other words, who is next in line is he who is at the
+ * head of the line.
+ *
+ * Also, producer_tail points to an empty byte in the Queue, whereas
+ * consumer_head points to a valid byte of data (unless producer_tail ==
+ * consumer_head in which case consumer_head does not point to a valid
+ * byte of data).
+ *
+ * For a queue of buffer 'size' bytes, the tail and head pointers will be in
+ * the range [0, size-1].
+ *
+ * If produce_q_header->producer_tail == consume_q_header->consumer_head
+ * then the produce_q is empty.
+ */
+struct vmci_queue_header {
+	/* All fields are 64bit and aligned. */
+	struct vmci_handle handle;	/* Identifier. */
+	atomic64_t producer_tail;	/* Offset in this queue. */
+	atomic64_t consumer_head;	/* Offset in peer queue. */
+};
+
+/*
+ * struct vmci_datagram - Base struct for vmci datagrams.
+ * @dst:        A vmci_handle that tracks the destination of the datagram.
+ * @src:        A vmci_handle that tracks the source of the datagram.
+ * @payload_size:       The size of the payload.
+ *
+ * vmci_datagram structs are used when sending vmci datagrams.  They include
+ * the necessary source and destination information to properly route
+ * the information along with the size of the package.
+ */
+struct vmci_datagram {
+	struct vmci_handle dst;
+	struct vmci_handle src;
+	u64 payload_size;
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
+#define VMCI_MAX_DG_PAYLOAD_SIZE (VMCI_MAX_DG_SIZE - \
+				  sizeof(struct vmci_datagram))
+#define VMCI_DG_PAYLOAD(_dg) (void *)((char *)(_dg) +			\
+				      sizeof(struct vmci_datagram))
+#define VMCI_DG_HEADERSIZE sizeof(struct vmci_datagram)
+#define VMCI_DG_SIZE(_dg) (VMCI_DG_HEADERSIZE + (size_t)(_dg)->payload_size)
+#define VMCI_DG_SIZE_ALIGNED(_dg) ((VMCI_DG_SIZE(_dg) + 7) & (~((size_t) 0x7)))
+#define VMCI_MAX_DATAGRAM_QUEUE_SIZE (VMCI_MAX_DG_SIZE * 2)
+
+struct vmci_event_payload_qp {
+	struct vmci_handle handle;  /* queue_pair handle. */
+	u32 peer_id;		    /* Context id of attaching/detaching VM. */
+	u32 _pad;
+};
+
+/* Flags for VMCI queue_pair API. */
+enum {
+	/* Fail alloc if QP not created by peer. */
+	VMCI_QPFLAG_ATTACH_ONLY = 1 << 0,
+
+	/* Only allow attaches from local context. */
+	VMCI_QPFLAG_LOCAL = 1 << 1,
+
+	/* Host won't block when guest is quiesced. */
+	VMCI_QPFLAG_NONBLOCK = 1 << 2,
+
+	/* Pin data pages in ESX.  Used with NONBLOCK */
+	VMCI_QPFLAG_PINNED = 1 << 3,
+
+	/* Update the following flag when adding new flags. */
+	VMCI_QP_ALL_FLAGS = (VMCI_QPFLAG_ATTACH_ONLY | VMCI_QPFLAG_LOCAL |
+			     VMCI_QPFLAG_NONBLOCK | VMCI_QPFLAG_PINNED),
+
+	/* Convenience flags */
+	VMCI_QP_ASYMM = (VMCI_QPFLAG_NONBLOCK | VMCI_QPFLAG_PINNED),
+	VMCI_QP_ASYMM_PEER = (VMCI_QPFLAG_ATTACH_ONLY | VMCI_QP_ASYMM),
+};
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
+	 1024 * (sizeof(struct vmci_datagram) +				\
+		 sizeof(struct vmci_event_data_max)))
+
+/*
+ * Struct used for querying, via VMCI_RESOURCES_QUERY, the availability of
+ * hypervisor resources.  Struct size is 16 bytes. All fields in struct are
+ * aligned to their natural alignment.
+ */
+struct vmci_resource_query_hdr {
+	struct vmci_datagram hdr;
+	u32 num_resources;
+	u32 _padding;
+};
+
+/*
+ * Convenience struct for negotiating vectors. Must match layout of
+ * VMCIResourceQueryHdr minus the struct vmci_datagram header.
+ */
+struct vmci_resource_query_msg {
+	u32 num_resources;
+	u32 _padding;
+	u32 resources[1];
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
+#define VMCI_RESOURCE_QUERY_MAX_SIZE				\
+	(sizeof(struct vmci_resource_query_hdr) +		\
+	 sizeof(u32) * VMCI_RESOURCE_QUERY_MAX_NUM)
+
+/*
+ * Struct used for setting the notification bitmap.  All fields in
+ * struct are aligned to their natural alignment.
+ */
+struct vmci_notify_bm_set_msg {
+	struct vmci_datagram hdr;
+	u32 bitmap_ppn;
+	u32 _pad;
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
+	u64 notify_idx;
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
+struct vmci_doorbell_notify_msg {
+	struct vmci_datagram hdr;
+	struct vmci_handle handle;
+};
+
+/*
+ * This struct is used to contain data for events.  Size of this struct is a
+ * multiple of 8 bytes, and all fields are aligned to their natural alignment.
+ */
+struct vmci_event_data {
+	u32 event;		/* 4 bytes. */
+	u32 _pad;
+	/* Event payload is put here. */
+};
+
+/*
+ * Define the different VMCI_EVENT payload data types here.  All structs must
+ * be a multiple of 8 bytes, and fields must be aligned to their natural
+ * alignment.
+ */
+struct vmci_event_payld_ctx {
+	u32 context_id;	/* 4 bytes. */
+	u32 _pad;
+};
+
+struct vmci_event_payld_qp {
+	struct vmci_handle handle;  /* queue_pair handle. */
+	u32 peer_id;	    /* Context id of attaching/detaching VM. */
+	u32 _pad;
+};
+
+/*
+ * We define the following struct to get the size of the maximum event
+ * data the hypervisor may send to the guest.  If adding a new event
+ * payload type above, add it to the following struct too (inside the
+ * union).
+ */
+struct vmci_event_data_max {
+	struct vmci_event_data event_data;
+	union {
+		struct vmci_event_payld_ctx context_payload;
+		struct vmci_event_payld_qp qp_payload;
+	} ev_data_payload;
+};
+
+/*
+ * Struct used for VMCI_EVENT_SUBSCRIBE/UNSUBSCRIBE and
+ * VMCI_EVENT_HANDLER messages.  Struct size is 32 bytes.  All fields
+ * in struct are aligned to their natural alignment.
+ */
+struct vmci_event_msg {
+	struct vmci_datagram hdr;
+
+	/* Has event type and payload. */
+	struct vmci_event_data event_data;
+
+	/* Payload gets put here. */
+};
+
+/*
+ * Structs used for queue_pair alloc and detach messages.  We align fields of
+ * these structs to 64bit boundaries.
+ */
+struct vmci_qp_alloc_msg {
+	struct vmci_datagram hdr;
+	struct vmci_handle handle;
+	u32 peer;
+	u32 flags;
+	u64 produce_size;
+	u64 consume_size;
+	u64 num_ppns;
+
+	/* List of PPNs placed here. */
+};
+
+struct vmci_qp_detach_msg {
+	struct vmci_datagram hdr;
+	struct vmci_handle handle;
+};
+
+/* VMCI Doorbell API. */
+#define VMCI_FLAG_DELAYED_CB 0x01
+
+typedef void (*vmci_callback) (void *client_data);
+
+/*
+ * struct vmci_qp - A vmw_vmci queue pair handle.
+ *
+ * This structure is used as a handle to a queue pair created by
+ * VMCI.  It is intentionally left opaque to clients.
+ */
+struct vmci_qp;
+
+/* Callback needed for correctly waiting on events. */
+typedef int (*vmci_datagram_recv_cb) (void *client_data,
+				      struct vmci_datagram *msg);
+
+/* VMCI Event API. */
+typedef void (*vmci_event_cb) (u32 sub_id, struct vmci_event_data *ed,
+			       void *client_data);
+
+/*
+ * We use the following inline function to access the payload data
+ * associated with an event data.
+ */
+static inline void *vmci_event_data_payload(struct vmci_event_data *ev_data)
+{
+	return (void *)((char *)ev_data + sizeof *ev_data);
+}
+
+/*
+ * Helper to add a given offset to a head or tail pointer. Wraps the
+ * value of the pointer around the max size of the queue.
+ */
+static inline void vmci_qp_add_pointer(atomic64_t *var,
+				       size_t add,
+				       u64 size)
+{
+	u64 new_val = atomic64_read(var);
+
+	if (new_val >= size - add)
+		new_val -= size;
+
+	new_val += add;
+
+	atomic64_set(var, new_val);
+}
+
+/*
+ * Helper routine to get the Producer Tail from the supplied queue.
+ */
+static inline u64
+vmci_q_header_producer_tail(const struct vmci_queue_header *q_header)
+{
+	struct vmci_queue_header *qh = (struct vmci_queue_header *)q_header;
+	return atomic64_read(&qh->producer_tail);
+}
+
+/*
+ * Helper routine to get the Consumer Head from the supplied queue.
+ */
+static inline u64
+vmci_q_header_consumer_head(const struct vmci_queue_header *q_header)
+{
+	struct vmci_queue_header *qh = (struct vmci_queue_header *)q_header;
+	return atomic64_read(&qh->consumer_head);
+}
+
+/*
+ * Helper routine to increment the Producer Tail.  Fundamentally,
+ * vmci_qp_add_pointer() is used to manipulate the tail itself.
+ */
+static inline void
+vmci_q_header_add_producer_tail(struct vmci_queue_header *q_header,
+				size_t add,
+				u64 queue_size)
+{
+	vmci_qp_add_pointer(&q_header->producer_tail, add, queue_size);
+}
+
+/*
+ * Helper routine to increment the Consumer Head.  Fundamentally,
+ * vmci_qp_add_pointer() is used to manipulate the head itself.
+ */
+static inline void
+vmci_q_header_add_consumer_head(struct vmci_queue_header *q_header,
+				size_t add,
+				u64 queue_size)
+{
+	vmci_qp_add_pointer(&q_header->consumer_head, add, queue_size);
+}
+
+/*
+ * Helper routine for getting the head and the tail pointer for a queue.
+ * Both the VMCIQueues are needed to get both the pointers for one queue.
+ */
+static inline void
+vmci_q_header_get_pointers(const struct vmci_queue_header *produce_q_header,
+			   const struct vmci_queue_header *consume_q_header,
+			   u64 *producer_tail,
+			   u64 *consumer_head)
+{
+	if (producer_tail)
+		*producer_tail = vmci_q_header_producer_tail(produce_q_header);
+
+	if (consumer_head)
+		*consumer_head = vmci_q_header_consumer_head(consume_q_header);
+}
+
+static inline void vmci_q_header_init(struct vmci_queue_header *q_header,
+				      const struct vmci_handle handle)
+{
+	q_header->handle = handle;
+	atomic64_set(&q_header->producer_tail, 0);
+	atomic64_set(&q_header->consumer_head, 0);
+}
+
+/*
+ * Finds available free space in a produce queue to enqueue more
+ * data or reports an error if queue pair corruption is detected.
+ */
+static s64
+vmci_q_header_free_space(const struct vmci_queue_header *produce_q_header,
+			 const struct vmci_queue_header *consume_q_header,
+			 const u64 produce_q_size)
+{
+	u64 tail;
+	u64 head;
+	u64 free_space;
+
+	tail = vmci_q_header_producer_tail(produce_q_header);
+	head = vmci_q_header_consumer_head(consume_q_header);
+
+	if (tail >= produce_q_size || head >= produce_q_size)
+		return VMCI_ERROR_INVALID_SIZE;
+
+	/*
+	 * Deduct 1 to avoid tail becoming equal to head which causes
+	 * ambiguity. If head and tail are equal it means that the
+	 * queue is empty.
+	 */
+	if (tail >= head)
+		free_space = produce_q_size - (tail - head) - 1;
+	else
+		free_space = head - tail - 1;
+
+	return free_space;
+}
+
+/*
+ * vmci_q_header_free_space() does all the heavy lifting of
+ * determing the number of free bytes in a Queue.  This routine,
+ * then subtracts that size from the full size of the Queue so
+ * the caller knows how many bytes are ready to be dequeued.
+ * Results:
+ * On success, available data size in bytes (up to MAX_INT64).
+ * On failure, appropriate error code.
+ */
+static inline s64
+vmci_q_header_buf_ready(const struct vmci_queue_header *consume_q_header,
+			const struct vmci_queue_header *produce_q_header,
+			const u64 consume_q_size)
+{
+	s64 free_space;
+
+	free_space = vmci_q_header_free_space(consume_q_header,
+					      produce_q_header, consume_q_size);
+	if (free_space < VMCI_SUCCESS)
+		return free_space;
+
+	return consume_q_size - free_space - 1;
+}
+
+static inline struct vmci_handle vmci_make_handle(u32 cid, u32 rid)
+{
+	struct vmci_handle h;
+
+	h.context = cid;
+	h.resource = rid;
+
+	return h;
+}
+
+#endif /* _VMW_VMCI_DEF_H_ */

