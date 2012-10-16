Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab2JPAis (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 20:38:48 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:43286 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755332Ab2JPAh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 20:37:56 -0400
Subject: [PATCH 04/10] VMCI: device driver implementaton.
To: linux-kernel@vger.kernel.org, georgezhang@vmware.com,
        virtualization@lists.linux-foundation.org
From: George Zhang <georgezhang@vmware.com>
Cc: pv-drivers@vmware.com, vm-crosstalk@vmware.com, gregkh@linuxfoundation.org
Date: Mon, 15 Oct 2012 17:28:47 -0700
Message-ID: <20121016002832.26205.60696.stgit@promb-2n-dhcp175.eng.vmware.com>
In-Reply-To: <20121016002550.26205.67037.stgit@promb-2n-dhcp175.eng.vmware.com>
References: <20121016002550.26205.67037.stgit@promb-2n-dhcp175.eng.vmware.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VMCI driver code implementes both the host and guest personalities of the VMCI driver.


Signed-off-by: George Zhang <georgezhang@vmware.com>
---
 drivers/misc/vmw_vmci/vmci_driver.c | 2187 +++++++++++++++++++++++++++++++++++
 drivers/misc/vmw_vmci/vmci_driver.h |   44 +
 2 files changed, 2231 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/vmw_vmci/vmci_driver.c
 create mode 100644 drivers/misc/vmw_vmci/vmci_driver.h

diff --git a/drivers/misc/vmw_vmci/vmci_driver.c b/drivers/misc/vmw_vmci/vmci_driver.c
new file mode 100644
index 0000000..db37bac
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmci_driver.c
@@ -0,0 +1,2187 @@
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
+#include <linux/vmw_vmci_defs.h>
+#include <linux/vmw_vmci_api.h>
+#include <linux/moduleparam.h>
+#include <linux/miscdevice.h>
+#include <linux/interrupt.h>
+#include <linux/highmem.h>
+#include <linux/atomic.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/sched.h>
+#include <linux/file.h>
+#include <linux/init.h>
+#include <linux/poll.h>
+#include <linux/pci.h>
+#include <linux/smp.h>
+#include <linux/fs.h>
+#include <linux/io.h>
+
+#include "vmci_handle_array.h"
+#include "vmci_common_int.h"
+#include "vmci_queue_pair.h"
+#include "vmci_datagram.h"
+#include "vmci_doorbell.h"
+#include "vmci_resource.h"
+#include "vmci_context.h"
+#include "vmci_driver.h"
+#include "vmci_event.h"
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
+static u32 ctx_update_sub_id = VMCI_INVALID_ID;
+static struct vmci_ctx *host_context;
+static atomic_t vm_context_id = { VMCI_INVALID_ID };
+
+struct vmci_delayed_work_info {
+	struct work_struct work;
+	vmci_work_fn *work_fn;
+	void *data;
+};
+
+/*
+ * VMCI driver initialization. This block can also be used to
+ * pass initial group membership etc.
+ */
+struct vmci_init_blk {
+	u32 cid;
+	u32 flags;
+};
+
+/* VMCIqueue_pairAllocInfo_VMToVM */
+struct vmci_qp_alloc_info_vmvm {
+	struct vmci_handle handle;
+	u32 peer;
+	u32 flags;
+	u64 produce_size;
+	u64 consume_size;
+	u64 produce_page_file;	  /* User VA. */
+	u64 consume_page_file;	  /* User VA. */
+	u64 produce_page_file_size;  /* Size of the file name array. */
+	u64 consume_page_file_size;  /* Size of the file name array. */
+	s32 result;
+	u32 _pad;
+};
+
+/* VMCISetNotifyInfo: Used to pass notify flag's address to the host driver. */
+struct vmci_set_notify_info {
+	u64 notify_uva;
+	s32 result;
+	u32 _pad;
+};
+
+struct vmci_device {
+	struct mutex lock;  /* Device access mutex */
+
+	unsigned int ioaddr;
+	unsigned int ioaddr_size;
+	unsigned int irq;
+	unsigned int intr_type;
+	bool exclusive_vectors;
+	struct msix_entry msix_entries[VMCI_MAX_INTRS];
+
+	bool enabled;
+	spinlock_t dev_spinlock;	/* Lock for datagram access
+					 * synchronization */
+	atomic_t datagrams_allowed;
+};
+
+static DEFINE_PCI_DEVICE_TABLE(vmci_ids) = {
+	{PCI_DEVICE(PCI_VENDOR_ID_VMWARE, PCI_DEVICE_ID_VMWARE_VMCI),},
+	{0},
+};
+
+static struct vmci_device vmci_dev;
+
+/* These options are false (0) by default */
+static bool vmci_disable_host;
+static bool vmci_disable_guest;
+static bool vmci_disable_msi;
+static bool vmci_disable_msix;
+
+/*
+ * Allocate a buffer for incoming datagrams globally to avoid repeated
+ * allocation in the interrupt handler's atomic context.
+ */
+static u8 *data_buffer;
+static u32 data_buffer_size = VMCI_MAX_DG_SIZE;
+
+/*
+ * If the VMCI hardware supports the notification bitmap, we allocate
+ * and register a page with the device.
+ */
+static u8 *notification_bitmap;
+
+/*
+ * Per-instance host state
+ */
+struct vmci_linux {
+	struct vmci_ctx *context;
+	int user_version;
+	enum vmci_obj_type ct_type;
+	struct mutex lock;  /* Mutex lock for vmci context access */
+};
+
+/*
+ * Static driver state.
+ */
+struct vmci_linux_state {
+	struct miscdevice misc;
+	char buf[1024];
+	atomic_t active_contexts;
+};
+
+/*
+ * Types and variables shared by both host and guest personality
+ */
+static bool guest_device_init;
+static atomic_t guest_device_active;
+static bool host_device_init;
+
+/*
+ * Cleans up the host specific components of the VMCI module.
+ */
+static void drv_host_cleanup(void)
+{
+	vmci_ctx_release_ctx(host_context);
+	vmci_qp_broker_exit();
+}
+
+/*
+ * Checks whether the VMCI device is enabled.
+ */
+static bool drv_device_enabled(void)
+{
+	return vmci_guest_code_active() || vmci_host_code_active();
+}
+
+/*
+ * Gets called with the new context id if updated or resumed.
+ * Context id.
+ */
+static void drv_util_cid_update(u32 sub_id,
+				struct vmci_event_data *event_data,
+				void *client_data)
+{
+	struct vmci_event_payld_ctx *ev_payload =
+	    vmci_event_data_payload(event_data);
+
+	if (sub_id != ctx_update_sub_id) {
+		pr_devel("Invalid subscriber (ID=0x%x).", sub_id);
+		return;
+	}
+
+	if (event_data == NULL || ev_payload->context_id == VMCI_INVALID_ID) {
+		pr_devel("Invalid event data.");
+		return;
+	}
+
+	pr_devel("Updating context from (ID=0x%x) to (ID=0x%x) on event "
+		 "(type=%d).", atomic_read(&vm_context_id),
+		 ev_payload->context_id, event_data->event);
+
+	atomic_set(&vm_context_id, ev_payload->context_id);
+}
+
+/*
+ * Subscribe to context id update event.
+ */
+static void __devinit drv_util_init(void)
+{
+	/*
+	 * We subscribe to the VMCI_EVENT_CTX_ID_UPDATE here so we can
+	 * update the internal context id when needed.
+	 */
+	if (vmci_event_subscribe
+	    (VMCI_EVENT_CTX_ID_UPDATE, VMCI_FLAG_EVENT_NONE,
+	     drv_util_cid_update, NULL, &ctx_update_sub_id) < VMCI_SUCCESS) {
+		pr_warn("Failed to subscribe to event (type=%d).",
+			VMCI_EVENT_CTX_ID_UPDATE);
+	}
+}
+
+static void vmci_util_exit(void)
+{
+	if (vmci_event_unsubscribe(ctx_update_sub_id) < VMCI_SUCCESS)
+		pr_warn("Failed to unsubscribe to event (type=%d) with "
+			"subscriber (ID=0x%x).", VMCI_EVENT_CTX_ID_UPDATE,
+			ctx_update_sub_id);
+
+}
+
+/*
+ * Verify that the host supports the hypercalls we need. If it does not,
+ * try to find fallback hypercalls and use those instead.  Returns
+ * true if required hypercalls (or fallback hypercalls) are
+ * supported by the host, false otherwise.
+ */
+static bool drv_check_host_caps(void)
+{
+	bool result;
+	struct vmci_resource_query_msg *msg;
+	u32 msg_size = sizeof(struct vmci_resource_query_hdr) +
+	    VMCI_UTIL_NUM_RESOURCES * sizeof(u32);
+	struct vmci_datagram *check_msg = kmalloc(msg_size, GFP_KERNEL);
+
+	if (check_msg == NULL) {
+		pr_warn("Check host: Insufficient memory.");
+		return false;
+	}
+
+	check_msg->dst = vmci_make_handle(VMCI_HYPERVISOR_CONTEXT_ID,
+					  VMCI_RESOURCES_QUERY);
+	check_msg->src = VMCI_ANON_SRC_HANDLE;
+	check_msg->payload_size = msg_size - VMCI_DG_HEADERSIZE;
+	msg = (struct vmci_resource_query_msg *)VMCI_DG_PAYLOAD(check_msg);
+
+	msg->num_resources = VMCI_UTIL_NUM_RESOURCES;
+	msg->resources[0] = VMCI_GET_CONTEXT_ID;
+
+	/* Checks that hyper calls are supported */
+	result = (0x1 == vmci_send_datagram(check_msg));
+	kfree(check_msg);
+
+	pr_info("Host capability check: %s.", result ? "PASSED" : "FAILED");
+
+	/* We need the vector. There are no fallbacks. */
+	return result;
+}
+
+/*
+ * Reads datagrams from the data in port and dispatches them. We
+ * always start reading datagrams into only the first page of the
+ * datagram buffer. If the datagrams don't fit into one page, we
+ * use the maximum datagram buffer size for the remainder of the
+ * invocation. This is a simple heuristic for not penalizing
+ * small datagrams.
+ *
+ * This function assumes that it has exclusive access to the data
+ * in port for the duration of the call.
+ */
+static void drv_read_dgs_from_port(int io_handle,
+				   unsigned short int dg_in_port,
+				   u8 *dg_in_buffer,
+				   size_t dg_in_buffer_size)
+{
+	struct vmci_datagram *dg;
+	size_t current_dg_in_buffer_size = PAGE_SIZE;
+	size_t remaining_bytes;
+
+	ASSERT(dg_in_buffer_size >= PAGE_SIZE);
+
+	insb(dg_in_port, dg_in_buffer, current_dg_in_buffer_size);
+	dg = (struct vmci_datagram *)dg_in_buffer;
+	remaining_bytes = current_dg_in_buffer_size;
+
+	while (dg->dst.resource != VMCI_INVALID_ID ||
+	       remaining_bytes > PAGE_SIZE) {
+		unsigned dg_in_size;
+
+		/*
+		 * When the input buffer spans multiple pages, a datagram can
+		 * start on any page boundary in the buffer.
+		 */
+		if (dg->dst.resource == VMCI_INVALID_ID) {
+			ASSERT(remaining_bytes > PAGE_SIZE);
+			dg = (struct vmci_datagram *)roundup((uintptr_t)
+							     dg + 1, PAGE_SIZE);
+			ASSERT((u8 *) dg <
+			       dg_in_buffer + current_dg_in_buffer_size);
+			remaining_bytes =
+			    (size_t) (dg_in_buffer + current_dg_in_buffer_size -
+				      (u8 *) dg);
+			continue;
+		}
+
+		dg_in_size = VMCI_DG_SIZE_ALIGNED(dg);
+
+		if (dg_in_size <= dg_in_buffer_size) {
+			int result;
+
+			/*
+			 * If the remaining bytes in the datagram
+			 * buffer doesn't contain the complete
+			 * datagram, we first make sure we have enough
+			 * room for it and then we read the reminder
+			 * of the datagram and possibly any following
+			 * datagrams.
+			 */
+			if (dg_in_size > remaining_bytes) {
+				if (remaining_bytes !=
+				    current_dg_in_buffer_size) {
+
+					/*
+					 * We move the partial
+					 * datagram to the front and
+					 * read the reminder of the
+					 * datagram and possibly
+					 * following calls into the
+					 * following bytes.
+					 */
+					memmove(dg_in_buffer, dg_in_buffer +
+						current_dg_in_buffer_size -
+						remaining_bytes,
+						remaining_bytes);
+					dg = (struct vmci_datagram *)
+					    dg_in_buffer;
+				}
+
+				if (current_dg_in_buffer_size !=
+				    dg_in_buffer_size)
+					current_dg_in_buffer_size =
+					    dg_in_buffer_size;
+
+				insb(dg_in_port, dg_in_buffer + remaining_bytes,
+				     current_dg_in_buffer_size -
+				     remaining_bytes);
+			}
+
+			/*
+			 * We special case event datagrams from the
+			 * hypervisor.
+			 */
+			if (dg->src.context == VMCI_HYPERVISOR_CONTEXT_ID &&
+			    dg->dst.resource == VMCI_EVENT_HANDLER) {
+				result = vmci_event_dispatch(dg);
+			} else {
+				result = vmci_datagram_invoke_guest_handler(dg);
+			}
+			if (result < VMCI_SUCCESS)
+				pr_devel("Datagram with resource "
+					 "(ID=0x%x) failed (err=%d).",
+					 dg->dst.resource, result);
+
+			/* On to the next datagram. */
+			dg = (struct vmci_datagram *)((u8 *) dg +
+						      dg_in_size);
+		} else {
+			size_t bytes_to_skip;
+
+			/*
+			 * Datagram doesn't fit in datagram buffer of maximal
+			 * size. We drop it.
+			 */
+			pr_devel("Failed to receive datagram (size=%u bytes).",
+				 dg_in_size);
+
+			bytes_to_skip = dg_in_size - remaining_bytes;
+			if (current_dg_in_buffer_size != dg_in_buffer_size)
+				current_dg_in_buffer_size = dg_in_buffer_size;
+
+			for (;;) {
+				insb(dg_in_port, dg_in_buffer,
+				     current_dg_in_buffer_size);
+				if (bytes_to_skip <= current_dg_in_buffer_size)
+					break;
+
+				bytes_to_skip -= current_dg_in_buffer_size;
+			}
+			dg = (struct vmci_datagram *)(dg_in_buffer +
+						      bytes_to_skip);
+		}
+
+		remaining_bytes =
+		    (size_t) (dg_in_buffer + current_dg_in_buffer_size -
+			      (u8 *) dg);
+
+		if (remaining_bytes < VMCI_DG_HEADERSIZE) {
+			/* Get the next batch of datagrams. */
+
+			insb(dg_in_port, dg_in_buffer,
+			     current_dg_in_buffer_size);
+			dg = (struct vmci_datagram *)dg_in_buffer;
+			remaining_bytes = current_dg_in_buffer_size;
+		}
+	}
+}
+
+/*
+ * Initializes VMCI components shared between guest and host
+ * driver. This registers core hypercalls.
+ */
+static int __init drv_shared_init(void)
+{
+	int result;
+
+	result = vmci_ctx_init();
+	if (result < VMCI_SUCCESS) {
+		pr_warn("Failed to initialize VMCIContext (result=%d).",
+			result);
+		return result;
+	}
+
+	result = vmci_datagram_init();
+	if (result < VMCI_SUCCESS) {
+		pr_warn("Failed to initialize VMCIDatagram (result=%d).",
+			result);
+		return result;
+	}
+
+	result = vmci_event_init();
+	if (result < VMCI_SUCCESS) {
+		pr_warn("Failed to initialize VMCIEvent (result=%d).", result);
+		return result;
+	}
+
+	pr_notice("shared components initialized.");
+	return VMCI_SUCCESS;
+}
+
+/*
+ * Cleans up VMCI components shared between guest and host
+ * driver.
+ */
+static void drv_shared_cleanup(void)
+{
+	vmci_event_exit();
+}
+
+static const struct file_operations vmuser_fops;
+static struct vmci_linux_state linux_state = {
+	.misc = {
+		 .name = MODULE_NAME,
+		 .minor = MISC_DYNAMIC_MINOR,
+		 .fops = &vmuser_fops,
+	},
+	.active_contexts = ATOMIC_INIT(0),
+};
+
+/*
+ * Called on open of /dev/vmci.
+ */
+static int drv_driver_open(struct inode *inode, struct file *filp)
+{
+	struct vmci_linux *vmci_linux;
+
+	vmci_linux = kzalloc(sizeof(struct vmci_linux), GFP_KERNEL);
+	if (vmci_linux == NULL)
+		return -ENOMEM;
+
+	vmci_linux->ct_type = VMCIOBJ_NOT_SET;
+	mutex_init(&vmci_linux->lock);
+	filp->private_data = vmci_linux;
+
+	return 0;
+}
+
+/*
+ * Called on close of /dev/vmci, most often when the process
+ * exits.
+ */
+static int drv_driver_close(struct inode *inode, struct file *filp)
+{
+	struct vmci_linux *vmci_linux;
+
+	vmci_linux = (struct vmci_linux *)filp->private_data;
+	ASSERT(vmci_linux);
+
+	if (vmci_linux->ct_type == VMCIOBJ_CONTEXT) {
+		ASSERT(vmci_linux->context);
+
+		vmci_ctx_release_ctx(vmci_linux->context);
+		vmci_linux->context = NULL;
+
+		/*
+		 * The number of active contexts is used to track whether any
+		 * VMX'en are using the host personality. It is incremented when
+		 * a context is created through the IOCTL_VMCI_INIT_CONTEXT
+		 * ioctl.
+		 */
+		atomic_dec(&linux_state.active_contexts);
+	}
+	vmci_linux->ct_type = VMCIOBJ_NOT_SET;
+
+	kfree(vmci_linux);
+	filp->private_data = NULL;
+	return 0;
+}
+
+/*
+ * This is used to wake up the VMX when a VMCI call arrives, or
+ * to wake up select() or poll() at the next clock tick.
+ */
+static unsigned int drv_driver_poll(struct file *filp, poll_table *wait)
+{
+	struct vmci_linux *vmci_linux = (struct vmci_linux *)filp->private_data;
+	unsigned int mask = 0;
+
+	if (vmci_linux->ct_type == VMCIOBJ_CONTEXT) {
+		ASSERT(vmci_linux->context != NULL);
+
+		/* Check for VMCI calls to this VM context. */
+		if (wait != NULL)
+			poll_wait(filp,
+				  &vmci_linux->context->host_context.wait_queue,
+				  wait);
+
+		spin_lock(&vmci_linux->context->lock);
+		if (vmci_linux->context->pending_datagrams > 0 ||
+		    vmci_handle_arr_get_size(vmci_linux->
+					 context->pending_doorbell_array) > 0) {
+			mask = POLLIN;
+		}
+		spin_unlock(&vmci_linux->context->lock);
+	}
+	return mask;
+}
+
+static int __init drv_host_init(void)
+{
+	int error;
+	int result;
+
+	result = vmci_ctx_init_ctx(VMCI_HOST_CONTEXT_ID,
+				   VMCI_DEFAULT_PROC_PRIVILEGE_FLAGS,
+				   -1, VMCI_VERSION, NULL, &host_context);
+	if (result < VMCI_SUCCESS) {
+		pr_warn("Failed to initialize VMCIContext (result=%d).",
+			result);
+		return -ENOMEM;
+	}
+
+	error = misc_register(&linux_state.misc);
+	if (error) {
+		pr_warn("Module registration error "
+			"(name=%s, major=%d, minor=%d, err=%d).",
+			linux_state.misc.name, MISC_MAJOR,
+			linux_state.misc.minor, error);
+		drv_host_cleanup();
+		return error;
+	}
+
+	pr_notice("Module registered (name=%s, major=%d, minor=%d).",
+		  linux_state.misc.name, MISC_MAJOR, linux_state.misc.minor);
+
+	return 0;
+}
+
+/*
+ * Copies the handles of a handle array into a user buffer, and
+ * returns the new length in userBufferSize. If the copy to the
+ * user buffer fails, the functions still returns VMCI_SUCCESS,
+ * but retval != 0.
+ */
+static int drv_cp_harray_to_user(void __user *user_buf_uva,
+				 u64 *user_buf_size,
+				 struct vmci_handle_arr *handle_array,
+				 int *retval)
+{
+	u32 array_size = 0;
+	struct vmci_handle *handles;
+
+	if (handle_array)
+		array_size = vmci_handle_arr_get_size(handle_array);
+
+	if (array_size * sizeof(*handles) > *user_buf_size)
+		return VMCI_ERROR_MORE_DATA;
+
+	*user_buf_size = array_size * sizeof(*handles);
+	if (*user_buf_size)
+		*retval = copy_to_user(user_buf_uva,
+				       vmci_handle_arr_get_handles
+				       (handle_array), *user_buf_size);
+
+	return VMCI_SUCCESS;
+}
+
+/*
+ * Helper function for creating queue pair and copying the result
+ * to user memory.
+ */
+static int drv_qp_broker_alloc(struct vmci_handle handle,
+			       u32 peer,
+			       u32 flags,
+			       u64 produce_size,
+			       u64 consume_size,
+			       struct vmci_qp_page_store *page_store,
+			       struct vmci_ctx *context,
+			       bool vm_to_vm,
+			       void __user *result_uva)
+{
+	u32 cid;
+	int result;
+	int retval;
+
+	cid = vmci_ctx_get_id(context);
+
+	result =
+	    vmci_qp_broker_alloc(handle, peer, flags,
+				 VMCI_NO_PRIVILEGE_FLAGS, produce_size,
+				 consume_size, page_store, context);
+	if (result == VMCI_SUCCESS && vm_to_vm)
+		result = VMCI_SUCCESS_QUEUEPAIR_CREATE;
+
+	retval = copy_to_user(result_uva, &result, sizeof(result));
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
+ * Lock physical page backing a given user VA.
+ */
+static struct page *drv_user_va_lock_page(uintptr_t addr)
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
+ * Lock physical page backing a given user VA and maps it to kernel
+ * address space.  The range of the mapped memory should be within a
+ * single page otherwise an error is returned.
+ */
+static int drv_map_bool_ptr(uintptr_t notify_uva,
+			    struct page **p,
+			    bool **notify_ptr)
+{
+	if (!access_ok(VERIFY_WRITE, (void __user *)notify_uva,
+		       sizeof(**notify_ptr)) ||
+	    (((notify_uva + sizeof(**notify_ptr) - 1) & ~(PAGE_SIZE - 1)) !=
+	     (notify_uva & ~(PAGE_SIZE - 1))))
+		return -EINVAL;
+
+	*p = drv_user_va_lock_page(notify_uva);
+	if (*p == NULL)
+		return -EAGAIN;
+
+	*notify_ptr =
+	    (bool *) ((u8 *) kmap(*p) + (notify_uva & (PAGE_SIZE - 1)));
+	return 0;
+}
+
+/*
+ * Sets up a given context for notify to work.  Calls drv_map_bool_ptr()
+ * which maps the notify boolean in user VA in kernel space.
+ */
+static int drv_setup_notify(struct vmci_ctx *context, uintptr_t notify_uva)
+{
+	int retval;
+
+	if (context->notify) {
+		pr_warn("Notify mechanism is already set up.");
+		return VMCI_ERROR_DUPLICATE_ENTRY;
+	}
+
+	retval = drv_map_bool_ptr(notify_uva, &context->notify_page,
+				  &context->notify);
+	if (retval == 0) {
+		vmci_ctx_check_signal_notify(context);
+		return VMCI_SUCCESS;
+	}
+
+	return VMCI_ERROR_GENERIC;
+}
+
+static long drv_driver_unlocked_ioctl(struct file *filp,
+				      u_int iocmd, unsigned long ioarg)
+{
+	struct vmci_linux *vmci_linux = (struct vmci_linux *)filp->private_data;
+	int retval = 0;
+
+	switch (iocmd) {
+	case IOCTL_VMCI_VERSION2:{
+		int ver_from_user;
+
+		if (copy_from_user
+		    (&ver_from_user, (void *)ioarg,
+		     sizeof(ver_from_user))) {
+			retval = -EFAULT;
+			break;
+		}
+
+		vmci_linux->user_version = ver_from_user;
+	}
+	/* Fall through. */
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
+		if (vmci_linux->user_version > 0 &&
+		    vmci_linux->user_version < VMCI_VERSION_HOSTQP) {
+			retval = vmci_linux->user_version;
+		} else {
+			retval = VMCI_VERSION;
+		}
+		break;
+
+	case IOCTL_VMCI_INIT_CONTEXT:{
+		struct vmci_init_blk init_block;
+		const struct cred *cred;
+
+		retval = copy_from_user(&init_block, (void *)ioarg,
+					sizeof(init_block));
+		if (retval != 0) {
+			pr_info("Error reading init block.");
+			retval = -EFAULT;
+			break;
+		}
+
+		mutex_lock(&vmci_linux->lock);
+		if (vmci_linux->ct_type != VMCIOBJ_NOT_SET) {
+			pr_info("Received VMCI init on initialized handle.");
+			retval = -EINVAL;
+			goto init_release;
+		}
+
+		if (init_block.flags & ~VMCI_PRIVILEGE_FLAG_RESTRICTED) {
+			pr_info("Unsupported VMCI restriction flag.");
+			retval = -EINVAL;
+			goto init_release;
+		}
+
+		cred = get_current_cred();
+		retval = vmci_ctx_init_ctx(init_block.cid,
+					   init_block.flags,
+					   0, vmci_linux->user_version,
+					   cred, &vmci_linux->context);
+		put_cred(cred);
+		if (retval < VMCI_SUCCESS) {
+			pr_info("Error initializing context.");
+			retval =
+			    (retval == VMCI_ERROR_DUPLICATE_ENTRY) ? -EEXIST :
+			    -EINVAL;
+			goto init_release;
+		}
+
+		/*
+		 * Copy cid to userlevel, we do this to allow the VMX
+		 * to enforce its policy on cid generation.
+		 */
+		init_block.cid = vmci_ctx_get_id(vmci_linux->context);
+		retval = copy_to_user((void *)ioarg, &init_block,
+				      sizeof(init_block));
+		if (retval != 0) {
+			vmci_ctx_release_ctx(vmci_linux->context);
+			vmci_linux->context = NULL;
+			pr_info("Error writing init block.");
+			retval = -EFAULT;
+			goto init_release;
+		}
+
+		ASSERT(init_block.cid != VMCI_INVALID_ID);
+		vmci_linux->ct_type = VMCIOBJ_CONTEXT;
+		atomic_inc(&linux_state.active_contexts);
+
+ init_release:
+		mutex_unlock(&vmci_linux->lock);
+		break;
+	}
+
+	case IOCTL_VMCI_DATAGRAM_SEND:{
+		struct vmci_datagram_snd_rcv_info send_info;
+		struct vmci_datagram *dg = NULL;
+		u32 cid;
+
+		if (vmci_linux->ct_type != VMCIOBJ_CONTEXT) {
+			pr_warn
+			    ("Ioctl only valid for context handle (iocmd=%d).",
+			     iocmd);
+			retval = -EINVAL;
+			break;
+		}
+
+		retval = copy_from_user(&send_info, (void *)ioarg,
+					sizeof(send_info));
+		if (retval) {
+			pr_warn("copy_from_user failed.");
+			retval = -EFAULT;
+			break;
+		}
+
+		if (send_info.len > VMCI_MAX_DG_SIZE) {
+			pr_warn("Datagram too big (size=%d).", send_info.len);
+			retval = -EINVAL;
+			break;
+		}
+
+		if (send_info.len < sizeof(*dg)) {
+			pr_warn("Datagram too small (size=%d).", send_info.len);
+			retval = -EINVAL;
+			break;
+		}
+
+		dg = kmalloc(send_info.len, GFP_KERNEL);
+		if (dg == NULL) {
+			pr_info("Cannot allocate memory to dispatch datagram.");
+			retval = -ENOMEM;
+			break;
+		}
+
+		retval = copy_from_user(dg, (char *)(uintptr_t) send_info.addr,
+					send_info.len);
+		if (retval != 0) {
+			pr_info("Error getting datagram (err=%d).", retval);
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
+			 (unsigned long long)dg->payload_size);
+
+		/* Get source context id. */
+		ASSERT(vmci_linux->context);
+		cid = vmci_ctx_get_id(vmci_linux->context);
+		ASSERT(cid != VMCI_INVALID_ID);
+		send_info.result = vmci_datagram_dispatch(cid, dg, true);
+		kfree(dg);
+		retval = copy_to_user((void *)ioarg, &send_info,
+				 sizeof(send_info));
+		break;
+	}
+
+	case IOCTL_VMCI_DATAGRAM_RECEIVE:{
+		struct vmci_datagram_snd_rcv_info recv_info;
+		struct vmci_datagram *dg = NULL;
+		size_t size;
+
+		if (vmci_linux->ct_type != VMCIOBJ_CONTEXT) {
+			pr_warn
+			    ("Ioctl only valid for context handle (iocmd=%d).",
+			     iocmd);
+			retval = -EINVAL;
+			break;
+		}
+
+		retval = copy_from_user(&recv_info, (void *)ioarg,
+					sizeof(recv_info));
+		if (retval) {
+			pr_warn("copy_from_user failed.");
+			retval = -EFAULT;
+			break;
+		}
+
+		ASSERT(vmci_linux->ct_type == VMCIOBJ_CONTEXT);
+		ASSERT(vmci_linux->context);
+		size = recv_info.len;
+		recv_info.result =
+		    vmci_ctx_dequeue_datagram(vmci_linux->context,
+					      &size, &dg);
+
+		if (recv_info.result >= VMCI_SUCCESS) {
+			ASSERT(dg);
+			retval = copy_to_user((void *)((uintptr_t)
+						       recv_info.addr),
+					      dg, VMCI_DG_SIZE(dg));
+			kfree(dg);
+			if (retval != 0)
+				break;
+		}
+		retval = copy_to_user((void *)ioarg, &recv_info,
+				      sizeof(recv_info));
+		break;
+	}
+
+	case IOCTL_VMCI_QUEUEPAIR_ALLOC:{
+		if (vmci_linux->ct_type != VMCIOBJ_CONTEXT) {
+			pr_info("IOCTL (%d) only valid for contexts.", iocmd);
+			retval = -EINVAL;
+			break;
+		}
+
+		if (vmci_linux->user_version < VMCI_VERSION_NOVMVM) {
+			struct vmci_qp_alloc_info_vmvm
+			    queue_pair_alloc_info;
+			struct vmci_qp_alloc_info_vmvm *info =
+			    (struct vmci_qp_alloc_info_vmvm *)ioarg;
+
+			retval = copy_from_user(&queue_pair_alloc_info,
+						(void *)ioarg,
+						sizeof(queue_pair_alloc_info));
+			if (retval) {
+				retval = -EFAULT;
+				break;
+			}
+
+			retval = drv_qp_broker_alloc(queue_pair_alloc_info.
+						handle,
+						queue_pair_alloc_info.
+						peer,
+						queue_pair_alloc_info.
+						flags,
+						queue_pair_alloc_info.
+						produce_size,
+						queue_pair_alloc_info.
+						consume_size, NULL,
+						vmci_linux->context,
+						true, &info->result);
+		} else {
+			struct vmci_qp_alloc_info queue_pair_alloc_info;
+			struct vmci_qp_alloc_info *info =
+			    (struct vmci_qp_alloc_info *)ioarg;
+			struct vmci_qp_page_store page_store;
+
+			retval = copy_from_user(&queue_pair_alloc_info,
+						(void *)ioarg,
+						sizeof
+						(queue_pair_alloc_info));
+			if (retval) {
+				retval = -EFAULT;
+				break;
+			}
+
+			page_store.pages = queue_pair_alloc_info.ppn_va;
+			page_store.len = queue_pair_alloc_info.num_ppns;
+
+			retval = drv_qp_broker_alloc(queue_pair_alloc_info.
+						handle,
+						queue_pair_alloc_info.
+						peer,
+						queue_pair_alloc_info.
+						flags,
+						queue_pair_alloc_info.
+						produce_size,
+						queue_pair_alloc_info.
+						consume_size,
+						&page_store,
+						vmci_linux->context,
+						false, &info->result);
+		}
+		break;
+	}
+
+	case IOCTL_VMCI_QUEUEPAIR_SETVA:{
+		struct vmci_qp_set_va_info set_va_info;
+		struct vmci_qp_set_va_info *info =
+		    (struct vmci_qp_set_va_info *)ioarg;
+		s32 result;
+
+		if (vmci_linux->ct_type != VMCIOBJ_CONTEXT) {
+			pr_info("IOCTL (%d) only valid for contexts.", iocmd);
+			retval = -EINVAL;
+			break;
+		}
+
+		if (vmci_linux->user_version < VMCI_VERSION_NOVMVM) {
+			pr_info
+			    ("Ioctl only valid for context handle (iocmd=%d).",
+			     iocmd);
+			retval = -EINVAL;
+			break;
+		}
+
+		retval = copy_from_user(&set_va_info, (void *)ioarg,
+						sizeof(set_va_info));
+		if (retval) {
+			retval = -EFAULT;
+			break;
+		}
+
+		if (set_va_info.va) {
+			/*
+			 * VMX is passing down a new VA for the queue
+			 * pair mapping.
+			 */
+			result = vmci_qp_broker_map(set_va_info.handle,
+						    vmci_linux->context,
+						    set_va_info.va);
+		} else {
+			/*
+			 * The queue pair is about to be unmapped by
+			 * the VMX.
+			 */
+			result = vmci_qp_broker_unmap(set_va_info.handle,
+						 vmci_linux->context, 0);
+		}
+
+		retval = copy_to_user(&info->result, &result,
+				 sizeof(result));
+		if (retval)
+			retval = -EFAULT;
+
+		break;
+	}
+
+	case IOCTL_VMCI_QUEUEPAIR_SETPAGEFILE:{
+		struct vmci_qp_page_file_info page_file_info;
+		struct vmci_qp_page_file_info *info =
+		    (struct vmci_qp_page_file_info *)ioarg;
+		s32 result;
+
+		if (vmci_linux->user_version < VMCI_VERSION_HOSTQP ||
+		    vmci_linux->user_version >= VMCI_VERSION_NOVMVM) {
+			pr_info("IOCTL_VMCI_QUEUEPAIR_SETPAGEFILE not "
+				"supported this VMX (version=%d).",
+				vmci_linux->user_version);
+			retval = -EINVAL;
+			break;
+		}
+
+		if (vmci_linux->ct_type != VMCIOBJ_CONTEXT) {
+			pr_info("Ioctl only valid for contexts (iocmd=%d).",
+				iocmd);
+			retval = -EINVAL;
+			break;
+		}
+
+		retval = copy_from_user(&page_file_info, (void *)ioarg,
+					sizeof(*info));
+		if (retval) {
+			retval = -EFAULT;
+			break;
+		}
+
+		/*
+		 * Communicate success pre-emptively to the caller.
+		 * Note that the basic premise is that it is incumbent
+		 * upon the caller not to look at the info.result
+		 * field until after the ioctl() returns.  And then,
+		 * only if the ioctl() result indicates no error.  We
+		 * send up the SUCCESS status before calling
+		 * SetPageStore() store because failing to copy up the
+		 * result code means unwinding the SetPageStore().
+		 *
+		 * It turns out the logic to unwind a SetPageStore()
+		 * opens a can of worms.  For example, if a host had
+		 * created the queue_pair and a guest attaches and
+		 * SetPageStore() is successful but writing success
+		 * fails, then ... the host has to be stopped from
+		 * writing (anymore) data into the queue_pair.  That
+		 * means an additional test in the VMCI_Enqueue() code
+		 * path.  Ugh.
+		 */
+
+		result = VMCI_SUCCESS;
+		retval = copy_to_user(&info->result, &result,
+				 sizeof(result));
+		if (retval == 0) {
+			result =
+			    vmci_qp_broker_set_page_store
+			    (page_file_info.handle,
+			     page_file_info.produce_va,
+			     page_file_info.consume_va,
+			     vmci_linux->context);
+			if (result < VMCI_SUCCESS) {
+				retval = copy_to_user(&info->result,
+						      &result,
+						      sizeof(result));
+				if (retval != 0) {
+					/*
+					 * Note that in this case the
+					 * SetPageStore() call failed
+					 * but we were unable to
+					 * communicate that to the
+					 * caller (because the
+					 * copy_to_user() call
+					 * failed).  So, if we simply
+					 * return an error (in this
+					 * case -EFAULT) then the
+					 * caller will know that the
+					 * SetPageStore failed even
+					 * though we couldn't put the
+					 * result code in the result
+					 * field and indicate exactly
+					 * why it failed.
+					 *
+					 * That says nothing about the
+					 * issue where we were once
+					 * able to write to the
+					 * caller's info memory and
+					 * now can't.  Something more
+					 * serious is probably going
+					 * on than the fact that
+					 * SetPageStore() didn't work.
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
+		struct vmci_qp_dtch_info detach_info;
+		struct vmci_qp_dtch_info *info =
+		    (struct vmci_qp_dtch_info *)ioarg;
+		s32 result;
+
+		if (vmci_linux->ct_type != VMCIOBJ_CONTEXT) {
+			pr_info("Ioctl only valid for contexts (iocmd=%d).",
+				iocmd);
+			retval = -EINVAL;
+			break;
+		}
+
+		retval = copy_from_user(&detach_info, (void *)ioarg,
+					sizeof(detach_info));
+		if (retval) {
+			retval = -EFAULT;
+			break;
+		}
+
+		result = vmci_qp_broker_detach(detach_info.handle,
+					       vmci_linux->context);
+		if (result == VMCI_SUCCESS &&
+		    vmci_linux->user_version < VMCI_VERSION_NOVMVM)
+			result = VMCI_SUCCESS_LAST_DETACH;
+
+		retval = copy_to_user(&info->result, &result,
+				 sizeof(result));
+		if (retval)
+			retval = -EFAULT;
+
+		break;
+	}
+
+	case IOCTL_VMCI_CTX_ADD_NOTIFICATION:{
+		struct vmci_ctx_info ar_info;
+		struct vmci_ctx_info *info = (struct vmci_ctx_info *)ioarg;
+		s32 result;
+		u32 cid;
+
+		if (vmci_linux->ct_type != VMCIOBJ_CONTEXT) {
+			pr_info("Ioctl only valid for contexts (iocmd=%d).",
+				iocmd);
+			retval = -EINVAL;
+			break;
+		}
+
+		retval = copy_from_user(&ar_info, (void *)ioarg,
+					sizeof(ar_info));
+		if (retval) {
+			retval = -EFAULT;
+			break;
+		}
+
+		cid = vmci_ctx_get_id(vmci_linux->context);
+		result = vmci_ctx_add_notification(cid, ar_info.remote_cid);
+		retval = copy_to_user(&info->result, &result, sizeof(result));
+		if (retval) {
+			retval = -EFAULT;
+			break;
+		}
+		break;
+	}
+
+	case IOCTL_VMCI_CTX_REMOVE_NOTIFICATION:{
+		struct vmci_ctx_info ar_info;
+		struct vmci_ctx_info *info =
+		    (struct vmci_ctx_info *)ioarg;
+		s32 result;
+		u32 cid;
+
+		if (vmci_linux->ct_type != VMCIOBJ_CONTEXT) {
+			pr_info("Ioctl only valid for contexts (iocmd=%d).",
+				iocmd);
+			retval = -EINVAL;
+			break;
+		}
+
+		retval = copy_from_user(&ar_info, (void *)ioarg,
+					sizeof(ar_info));
+		if (retval) {
+			retval = -EFAULT;
+			break;
+		}
+
+		cid = vmci_ctx_get_id(vmci_linux->context);
+		result = vmci_ctx_remove_notification(cid,
+						      ar_info.remote_cid);
+		retval = copy_to_user(&info->result, &result, sizeof(result));
+		if (retval) {
+			retval = -EFAULT;
+			break;
+		}
+
+		break;
+	}
+
+	case IOCTL_VMCI_CTX_GET_CPT_STATE:{
+		struct vmci_ctx_chkpt_buf_info get_info;
+		u32 cid;
+		void *cpt_buf;
+
+		if (vmci_linux->ct_type != VMCIOBJ_CONTEXT) {
+			pr_info("Ioctl only valid for contexts (iocmd=%d).",
+				iocmd);
+			retval = -EINVAL;
+			break;
+		}
+
+		retval = copy_from_user(&get_info, (void *)ioarg,
+					sizeof(get_info));
+		if (retval) {
+			retval = -EFAULT;
+			break;
+		}
+
+		cid = vmci_ctx_get_id(vmci_linux->context);
+		get_info.result =
+		    vmci_ctx_get_chkpt_state(cid,
+					     get_info.cpt_type,
+					     &get_info.buf_size,
+					     &cpt_buf);
+		if (get_info.result == VMCI_SUCCESS
+		    && get_info.buf_size) {
+			retval = copy_to_user((void *)(uintptr_t)
+					      get_info.cpt_buf, cpt_buf,
+					      get_info.buf_size);
+			kfree(cpt_buf);
+			if (retval) {
+				retval = -EFAULT;
+				break;
+			}
+		}
+		retval = copy_to_user((void *)ioarg, &get_info,
+				      sizeof(get_info));
+		if (retval)
+			retval = -EFAULT;
+
+		break;
+	}
+
+	case IOCTL_VMCI_CTX_SET_CPT_STATE:{
+		struct vmci_ctx_chkpt_buf_info set_info;
+		u32 cid;
+		void *cpt_buf;
+
+		if (vmci_linux->ct_type != VMCIOBJ_CONTEXT) {
+			pr_info("Ioctl only valid for contexts (iocmd=%d).",
+				iocmd);
+			retval = -EINVAL;
+			break;
+		}
+
+		retval = copy_from_user(&set_info, (void *)ioarg,
+					sizeof(set_info));
+		if (retval) {
+			retval = -EFAULT;
+			break;
+		}
+
+		cpt_buf = kmalloc(set_info.buf_size, GFP_KERNEL);
+		if (cpt_buf == NULL) {
+			pr_info("Cannot allocate memory to set cpt state (type=%d).",
+			     set_info.cpt_type);
+			retval = -ENOMEM;
+			break;
+		}
+		retval = copy_from_user(cpt_buf,
+					(void *)(uintptr_t) set_info.cpt_buf,
+					set_info.buf_size);
+		if (retval) {
+			kfree(cpt_buf);
+			retval = -EFAULT;
+			break;
+		}
+
+		cid = vmci_ctx_get_id(vmci_linux->context);
+		set_info.result = vmci_ctx_set_chkpt_state(cid,
+					     set_info.cpt_type,
+					     set_info.buf_size,
+					     cpt_buf);
+		kfree(cpt_buf);
+		retval = copy_to_user((void *)ioarg, &set_info,
+				      sizeof(set_info));
+		if (retval)
+			retval = -EFAULT;
+
+		break;
+	}
+
+	case IOCTL_VMCI_GET_CONTEXT_ID:{
+		u32 cid = VMCI_HOST_CONTEXT_ID;
+
+		retval = copy_to_user((void *)ioarg, &cid, sizeof(cid));
+		break;
+	}
+
+	case IOCTL_VMCI_SET_NOTIFY:{
+		struct vmci_set_notify_info notify_info;
+
+		if (vmci_linux->ct_type != VMCIOBJ_CONTEXT) {
+			pr_info("IOCTL_VMCI_SET_NOTIFY only valid for contexts.");
+			retval = -EINVAL;
+			break;
+		}
+
+		retval = copy_from_user(&notify_info, (void *)ioarg,
+					sizeof(notify_info));
+		if (retval) {
+			retval = -EFAULT;
+			break;
+		}
+
+		if ((uintptr_t) notify_info.notify_uva !=
+		    (uintptr_t) NULL) {
+			notify_info.result =
+			    drv_setup_notify(vmci_linux->context,
+					     (uintptr_t) notify_info.notify_uva);
+		} else {
+			spin_lock(&vmci_linux->context->lock);
+			vmci_ctx_unset_notify(vmci_linux->context);
+			spin_unlock(&vmci_linux->context->lock);
+			notify_info.result = VMCI_SUCCESS;
+		}
+
+		retval = copy_to_user((void *)ioarg, &notify_info,
+				      sizeof(notify_info));
+		if (retval)
+			retval = -EFAULT;
+
+		break;
+	}
+
+	case IOCTL_VMCI_NOTIFY_RESOURCE:{
+		struct vmci_dbell_notify_resource_info info;
+		u32 cid;
+
+		if (vmci_linux->user_version < VMCI_VERSION_NOTIFY) {
+			pr_info("IOCTL_VMCI_NOTIFY_RESOURCE is invalid "
+				"for current VMX versions.");
+			retval = -EINVAL;
+			break;
+		}
+
+		if (vmci_linux->ct_type != VMCIOBJ_CONTEXT) {
+			pr_info("IOCTL_VMCI_NOTIFY_RESOURCE is only valid for contexts.");
+			retval = -EINVAL;
+			break;
+		}
+
+		retval = copy_from_user(&info, (void *)ioarg, sizeof(info));
+		if (retval) {
+			retval = -EFAULT;
+			break;
+		}
+
+		cid = vmci_ctx_get_id(vmci_linux->context);
+		switch (info.action) {
+		case VMCI_NOTIFY_RESOURCE_ACTION_NOTIFY:
+			if (info.resource ==
+			    VMCI_NOTIFY_RESOURCE_DOOR_BELL) {
+				u32 flags = VMCI_NO_PRIVILEGE_FLAGS;
+				info.result =
+				    vmci_ctx_notify_dbell(cid, info.handle,
+							  flags);
+			} else {
+				info.result = VMCI_ERROR_UNAVAILABLE;
+			}
+			break;
+		case VMCI_NOTIFY_RESOURCE_ACTION_CREATE:
+			info.result = vmci_ctx_dbell_create(cid, info.handle);
+			break;
+		case VMCI_NOTIFY_RESOURCE_ACTION_DESTROY:
+			info.result = vmci_ctx_dbell_destroy(cid, info.handle);
+			break;
+		default:
+			pr_info("IOCTL_VMCI_NOTIFY_RESOURCE got unknown action (action=%d).",
+				info.action);
+			info.result = VMCI_ERROR_INVALID_ARGS;
+		}
+		retval = copy_to_user((void *)ioarg, &info,
+				      sizeof(info));
+		if (retval)
+			retval = -EFAULT;
+
+		break;
+	}
+
+	case IOCTL_VMCI_NOTIFICATIONS_RECEIVE:{
+		struct vmci_ctx_notify_recv_info info;
+		struct vmci_handle_arr *db_handle_array;
+		struct vmci_handle_arr *qp_handle_array;
+		u32 cid;
+
+		if (vmci_linux->ct_type != VMCIOBJ_CONTEXT) {
+			pr_info("IOCTL_VMCI_NOTIFICATIONS_RECEIVE is only valid for contexts.");
+			retval = -EINVAL;
+			break;
+		}
+
+		if (vmci_linux->user_version < VMCI_VERSION_NOTIFY) {
+			pr_info("IOCTL_VMCI_NOTIFICATIONS_RECEIVE is not "
+				"supported for the current vmx version.");
+			retval = -EINVAL;
+			break;
+		}
+
+		retval = copy_from_user(&info, (void *)ioarg, sizeof(info));
+		if (retval) {
+			retval = -EFAULT;
+			break;
+		}
+
+		if ((info.db_handle_buf_size && !info.db_handle_buf_uva)
+		    || (info.qp_handle_buf_size
+			&& !info.qp_handle_buf_uva)) {
+			retval = -EINVAL;
+			break;
+		}
+
+		cid = vmci_ctx_get_id(vmci_linux->context);
+		info.result = vmci_ctx_rcv_notifications_get(cid,
+						   &db_handle_array,
+						   &qp_handle_array);
+		if (info.result == VMCI_SUCCESS) {
+			info.result = drv_cp_harray_to_user((void *)(uintptr_t)
+						info.db_handle_buf_uva,
+						&info.db_handle_buf_size,
+						db_handle_array,
+						&retval);
+			if (info.result == VMCI_SUCCESS && !retval) {
+				info.result = drv_cp_harray_to_user((void *)(uintptr_t)
+						info.qp_handle_buf_uva,
+						&info.qp_handle_buf_size,
+						qp_handle_array,
+						&retval);
+			}
+			if (!retval)
+				retval = copy_to_user((void *)ioarg,
+						      &info,
+						      sizeof(info));
+
+			vmci_ctx_rcv_notifications_release
+			    (cid, db_handle_array, qp_handle_array,
+			     info.result == VMCI_SUCCESS && !retval);
+		} else {
+			retval = copy_to_user((void *)ioarg, &info,
+					      sizeof(info));
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
+ * Reads and dispatches incoming datagrams.
+ */
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
+DECLARE_TASKLET(vmci_datagram_tasklet, drv_dispatch_dgs,
+		(unsigned long)&vmci_dev);
+
+/*
+ * Scans the notification bitmap for raised flags, clears them
+ * and handles the notifications.
+ */
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
+ * Enable MSI-X.  Try exclusive vectors first, then shared vectors.
+ */
+static int drv_enable_msix(struct pci_dev *pdev)
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
+ * Interrupt handler for legacy or MSI interrupt, or for first MSI-X
+ * interrupt (vector VMCI_INTR_DATAGRAM).
+ */
+static irqreturn_t drv_interrupt(int irq, void *clientdata)
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
+		tasklet_schedule(&vmci_datagram_tasklet);
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
+			tasklet_schedule(&vmci_datagram_tasklet);
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
+ * Interrupt handler for MSI-X interrupt vector VMCI_INTR_NOTIFICATION,
+ * which is for the notification bitmap.  Will only get called if we are
+ * using MSI-X with exclusive vectors.
+ */
+static irqreturn_t drv_interrupt_bm(int irq, void *clientdata)
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
+ * Most of the initialization at module load time is done here.
+ */
+static int __devinit drv_probe_device(struct pci_dev *pdev,
+				      const struct pci_device_id *id)
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
+		pr_err("Cannot enable VMCI device %s: error %d",
+		       pci_name(pdev), result);
+		return result;
+	}
+	pci_set_master(pdev);	/* To enable queue_pair functionality. */
+	ioaddr = pci_resource_start(pdev, 0);
+	ioaddr_size = pci_resource_len(pdev, 0);
+
+	/*
+	 * Request I/O region with adjusted base address and size. The
+	 * adjusted values are needed and used if we release the
+	 * region in case of failure.
+	 */
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
+			pr_err("Device unable to allocate notification "
+			       "bitmap.");
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
+		unsigned long bitmap_ppn;
+		bitmap_ppn = page_to_pfn(vmalloc_to_page(notification_bitmap));
+		if (!vmci_dbell_register_notification_bitmap(bitmap_ppn)) {
+			pr_err("VMCI device unable to register notification "
+			       "bitmap with PPN 0x%x.", (u32) bitmap_ppn);
+			goto datagram_disallow;
+		}
+	}
+
+	/* Check host capabilities. */
+	if (!drv_check_host_caps())
+		goto remove_bitmap;
+
+	/* Enable device. */
+	vmci_dev.enabled = true;
+	pci_set_drvdata(pdev, &vmci_dev);
+
+	/*
+	 * We do global initialization here because we need datagrams
+	 * during drv_util_init, since it registers for VMCI
+	 * events. If we ever support more than one VMCI device we
+	 * will have to create seperate LateInit/EarlyExit functions
+	 * that can be used to do initialization/cleanup that depends
+	 * on the device being accessible.  We need to initialize VMCI
+	 * components before requesting an irq - the VMCI interrupt
+	 * handler uses these components, and it may be invoked once
+	 * request_irq() has registered the handler (as the irq line
+	 * may be shared).
+	 */
+	drv_util_init();
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
+	/*
+	 * Request IRQ for legacy or MSI interrupts, or for first
+	 * MSI-X vector.
+	 */
+	result = request_irq(vmci_dev.irq, drv_interrupt, IRQF_SHARED,
+			     MODULE_NAME, &vmci_dev);
+	if (result) {
+		pr_err("Irq %u in use: %d", vmci_dev.irq, result);
+		goto util_exit;
+	}
+
+	/*
+	 * For MSI-X with exclusive vectors we need to request an
+	 * interrupt for each vector so that we get a separate
+	 * interrupt handler routine.  This allows us to distinguish
+	 * between the vectors.
+	 */
+	if (vmci_dev.exclusive_vectors) {
+		ASSERT(vmci_dev.intr_type == VMCI_INTR_TYPE_MSIX);
+		result = request_irq(vmci_dev.msix_entries[1].vector,
+				     drv_interrupt_bm, 0, MODULE_NAME,
+				     &vmci_dev);
+		if (result) {
+			pr_err("Irq %u in use: %d",
+			       vmci_dev.msix_entries[1].vector, result);
+			free_irq(vmci_dev.irq, &vmci_dev);
+			goto util_exit;
+		}
+	}
+
+	pr_info("Registered device.");
+	atomic_inc(&guest_device_active);
+	mutex_unlock(&vmci_dev.lock);
+
+	/* Enable specific interrupt bits. */
+	if (capabilities & VMCI_CAPS_NOTIFICATIONS)
+		outl(VMCI_IMR_DATAGRAM | VMCI_IMR_NOTIFICATION,
+		     vmci_dev.ioaddr + VMCI_IMR_ADDR);
+	else
+		outl(VMCI_IMR_DATAGRAM, vmci_dev.ioaddr + VMCI_IMR_ADDR);
+
+	/* Enable interrupts. */
+	outl(VMCI_CONTROL_INT_ENABLE, vmci_dev.ioaddr + VMCI_CONTROL_ADDR);
+
+	return 0;
+
+ util_exit:
+	vmci_util_exit();
+	vmci_dev.enabled = false;
+	if (vmci_dev.intr_type == VMCI_INTR_TYPE_MSIX)
+		pci_disable_msix(pdev);
+	else if (vmci_dev.intr_type == VMCI_INTR_TYPE_MSI)
+		pci_disable_msi(pdev);
+
+ remove_bitmap:
+	if (notification_bitmap)
+		outl(VMCI_CONTROL_RESET, vmci_dev.ioaddr + VMCI_CONTROL_ADDR);
+
+ datagram_disallow:
+	atomic_set(&vmci_dev.datagrams_allowed, 0);
+ unlock:
+	mutex_unlock(&vmci_dev.lock);
+ release:
+	if (notification_bitmap) {
+		vfree(notification_bitmap);
+		notification_bitmap = NULL;
+	}
+	release_region(ioaddr, ioaddr_size);
+ pci_disable:
+	pci_disable_device(pdev);
+	return -EBUSY;
+}
+
+static void __devexit drv_remove_device(struct pci_dev *pdev)
+{
+	struct vmci_device *dev = pci_get_drvdata(pdev);
+
+	pr_info("Removing device");
+	atomic_dec(&guest_device_active);
+	vmci_qp_guest_endpoints_exit();
+	vmci_util_exit();
+	mutex_lock(&dev->lock);
+	atomic_set(&vmci_dev.datagrams_allowed, 0);
+	pr_info("Resetting vmci device");
+	outl(VMCI_CONTROL_RESET, vmci_dev.ioaddr + VMCI_CONTROL_ADDR);
+
+	/*
+	 * Free IRQ and then disable MSI/MSI-X as appropriate.  For
+	 * MSI-X, we might have multiple vectors, each with their own
+	 * IRQ, which we must free too.
+	 */
+	free_irq(dev->irq, dev);
+	if (dev->intr_type == VMCI_INTR_TYPE_MSIX) {
+		if (dev->exclusive_vectors)
+			free_irq(dev->msix_entries[1].vector, dev);
+
+		pci_disable_msix(pdev);
+	} else if (dev->intr_type == VMCI_INTR_TYPE_MSI)
+		pci_disable_msi(pdev);
+
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
+ * Initializes the VMCI PCI device. The initialization might fail
+ * if there is no VMCI PCI device.
+ */
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
+	atomic_set(&guest_device_active, 0);
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
+/*
+ * VM to hypervisor call mechanism. We use the standard VMware naming
+ * convention since shared code is calling this function as well.
+ */
+int vmci_send_datagram(struct vmci_datagram *dg)
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
+	 * Need to acquire spinlock on the device because the datagram
+	 * data may be spread over multiple pages and the monitor may
+	 * interleave device user rpc calls from multiple
+	 * VCPUs. Acquiring the spinlock precludes that
+	 * possibility. Disabling interrupts to avoid incoming
+	 * datagrams during a "rep out" and possibly landing up in
+	 * this function.
+	 */
+	spin_lock_irqsave(&vmci_dev.dev_spinlock, flags);
+
+	__asm__ __volatile__("cld\n\t" \
+			     "rep outsb\n\t"
+			     :	/* No output. */
+			     :"d"(vmci_dev.ioaddr + VMCI_DATA_OUT_ADDR),
+			     "c"(VMCI_DG_SIZE(dg)), "S"(dg)
+		);
+
+	result = inl(vmci_dev.ioaddr + VMCI_RESULT_LOW_ADDR);
+	spin_unlock_irqrestore(&vmci_dev.dev_spinlock, flags);
+
+	return result;
+}
+
+bool vmci_guest_code_active(void)
+{
+	return guest_device_init && atomic_read(&guest_device_active) > 0;
+}
+
+/*
+ * Determines whether the VMCI host personality is
+ * available. Since the core functionality of the host driver is
+ * always present, all guests could possibly use the host
+ * personality. However, to minimize the deviation from the
+ * pre-unified driver state of affairs, we only consider the host
+ * device active if there is no active guest device or if there
+ * are VMX'en with active VMCI contexts using the host device.
+ */
+bool vmci_host_code_active(void)
+{
+	return host_device_init &&
+	    (!vmci_guest_code_active() ||
+	     atomic_read(&linux_state.active_contexts) > 0);
+}
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
+			const char *state = vmci_guest_code_active() ?
+				"active" : "inactive";
+			guest_device_init = true;
+			pr_info("Guest personality initialized and is %s",
+				state);
+		}
+	}
+
+	if (!vmci_disable_host) {
+		retval = drv_host_init();
+		if (retval != 0) {
+			pr_warn("Unable to initialize host "
+				"personality (err=%d).", retval);
+		} else {
+			host_device_init = true;
+			pr_info("Initialized host personality");
+		}
+	}
+
+	if (!guest_device_init && !host_device_init) {
+		drv_shared_cleanup();
+		return -ENODEV;
+	}
+
+	pr_info("Module is initialized");
+	return 0;
+}
+
+static void __exit drv_exit(void)
+{
+	if (guest_device_init) {
+		pci_unregister_driver(&vmci_driver);
+		vfree(data_buffer);
+		guest_device_init = false;
+	}
+
+	if (host_device_init) {
+		drv_host_cleanup();
+
+		if (misc_deregister(&linux_state.misc))
+			pr_warn("Error unregistering");
+		else
+			pr_info("Module unloaded");
+
+		host_device_init = false;
+	}
+
+	drv_shared_cleanup();
+}
+
+/*
+ * vmci_device_get() - Checks for VMCI device.
+ * @api_version:        The API version to use
+ * @device_shutdown_cb: Callback used when shutdown happens (Unused)
+ * @user_data:  Data to be passed to the callback (Unused)
+ * @device_registration:        A device registration handle. (Unused)
+ *
+ * Verifies that a valid VMCI device is present, and indicates
+ * the callers intention to use the device until it calls
+ * vmci_device_release().
+ */
+bool vmci_device_get(u32 *api_version,
+		     vmci_device_shutdown_fn *device_shutdown_cb,
+		     void *user_data, void **device_registration)
+{
+	if (*api_version > VMCI_KERNEL_API_VERSION) {
+		*api_version = VMCI_KERNEL_API_VERSION;
+		return false;
+	}
+
+	return drv_device_enabled();
+}
+EXPORT_SYMBOL(vmci_device_get);
+
+/*
+ * vmci_device_release() - Releases the device (Unused)
+ * @device_registration:        The device registration handle.
+ *
+ * Indicates that the caller is done using the VMCI device.  This
+ * function is a noop on Linux systems.
+ */
+void vmci_device_release(void *device_registration)
+{
+}
+EXPORT_SYMBOL(vmci_device_release);
+
+/*
+ * vmci_get_context_id() - Gets the current context ID.
+ *
+ * Returns the current context ID.  Note that since this is accessed only
+ * from code running in the host, this always returns the host context ID.
+ */
+u32 vmci_get_context_id(void)
+{
+	if (vmci_guest_code_active()) {
+		if (atomic_read(&vm_context_id) == VMCI_INVALID_ID) {
+			u32 result;
+			struct vmci_datagram get_cid_msg;
+			get_cid_msg.dst =
+			    vmci_make_handle(VMCI_HYPERVISOR_CONTEXT_ID,
+					     VMCI_GET_CONTEXT_ID);
+			get_cid_msg.src = VMCI_ANON_SRC_HANDLE;
+			get_cid_msg.payload_size = 0;
+			result = vmci_send_datagram(&get_cid_msg);
+			atomic_set(&vm_context_id, result);
+		}
+		return atomic_read(&vm_context_id);
+	} else if (vmci_host_code_active())
+		return VMCI_HOST_CONTEXT_ID;
+
+	return VMCI_INVALID_ID;
+}
+EXPORT_SYMBOL(vmci_get_context_id);
+
+/*
+ * vmci_version() - Returns the version of the driver.
+ *
+ * Returns the version of the VMCI driver.
+ */
+u32 vmci_version(void)
+{
+	return VMCI_VERSION;
+}
+EXPORT_SYMBOL(vmci_version);
+
+module_init(drv_init);
+module_exit(drv_exit);
+MODULE_DEVICE_TABLE(pci, vmci_ids);
+
+MODULE_AUTHOR("VMware, Inc.");
+MODULE_DESCRIPTION("VMware Virtual Machine Communication Interface.");
+MODULE_VERSION(VMCI_DRIVER_VERSION_STRING);
+MODULE_LICENSE("GPL v2");
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
diff --git a/drivers/misc/vmw_vmci/vmci_driver.h b/drivers/misc/vmw_vmci/vmci_driver.h
new file mode 100644
index 0000000..e22e73e
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmci_driver.h
@@ -0,0 +1,44 @@
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
+#ifndef _VMCI_DRIVER_H_
+#define _VMCI_DRIVER_H_
+
+#include <linux/vmw_vmci_defs.h>
+#include <linux/wait.h>
+
+#include "vmci_queue_pair.h"
+#include "vmci_context.h"
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
+typedef void (vmci_work_fn) (void *data);
+bool vmci_host_code_active(void);
+bool vmci_guest_code_active(void);
+u32 vmci_get_context_id(void);
+int vmci_send_datagram(struct vmci_datagram *dg);
+
+#endif /* _VMCI_DRIVER_H_ */

