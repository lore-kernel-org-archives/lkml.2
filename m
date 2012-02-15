Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761557Ab2BOBP5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 20:15:57 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:52349 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761438Ab2BOBOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 20:14:45 -0500
From: "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
To: linux-kernel@vger.kernel.org
Cc: vm-crosstalk@vmware.com, dtor@vmware.com, cschamp@vmware.com,
        "Andrew Stiegmann (stieg)" <astiegmann@vmware.com>
Subject: [PATCH 13/14] Add main driver and kernel interface file
Date: Tue, 14 Feb 2012 17:05:54 -0800
Message-Id: <1329267955-32367-14-git-send-email-astiegmann@vmware.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1329267955-32367-1-git-send-email-astiegmann@vmware.com>
References: <1329267955-32367-1-git-send-email-astiegmann@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/misc/vmw_vmci/driver.c       | 2352 ++++++++++++++++++++++++++++++++++
 drivers/misc/vmw_vmci/vmciKernelIf.c | 1351 +++++++++++++++++++
 2 files changed, 3703 insertions(+), 0 deletions(-)
 create mode 100644 drivers/misc/vmw_vmci/driver.c
 create mode 100644 drivers/misc/vmw_vmci/vmciKernelIf.c

diff --git a/drivers/misc/vmw_vmci/driver.c b/drivers/misc/vmw_vmci/driver.c
new file mode 100644
index 0000000..ea9dc90
--- /dev/null
+++ b/drivers/misc/vmw_vmci/driver.c
@@ -0,0 +1,2352 @@
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
+#include <asm/atomic.h>
+#include <asm/io.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/highmem.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/miscdevice.h>
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/mutex.h>
+#include <linux/pci.h>
+#include <linux/poll.h>
+#include <linux/sched.h>
+#include <linux/smp.h>
+#include <linux/version.h>
+
+#include "vmci_defs.h"
+#include "vmci_handle_array.h"
+#include "vmci_infrastructure.h"
+#include "vmci_iocontrols.h"
+#include "vmci_kernel_if.h"
+#include "vmciCommonInt.h"
+#include "vmciContext.h"
+#include "vmciDatagram.h"
+#include "vmciDoorbell.h"
+#include "vmciDriver.h"
+#include "vmciEvent.h"
+#include "vmciKernelAPI.h"
+#include "vmciQueuePair.h"
+#include "vmciResource.h"
+
+#define LGPFX "VMCI: "
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
+ * VMCI PCI driver state
+ */
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
+static int vmci_probe_device(struct pci_dev *pdev,
+			     const struct pci_device_id *id);
+
+static void vmci_remove_device(struct pci_dev *pdev);
+
+static struct pci_driver vmci_driver = {
+	.name = "vmci",
+	.id_table = vmci_ids,
+	.probe = vmci_probe_device,
+	.remove = __devexit_p(vmci_remove_device),
+};
+
+static struct vmci_device vmci_dev;
+static int vmci_disable_host = 0;
+static int vmci_disable_guest = 0;
+static int vmci_disable_msi;
+static int vmci_disable_msix = 0;
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
+
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
+	struct vmci_context *context;
+	int userVersion;
+	VMCIObjType ctType;
+	struct mutex lock;
+};
+
+/*
+ * Static driver state.
+ */
+struct vmci_linux_state {
+	int major;
+	int minor;
+	struct miscdevice misc;
+	char deviceName[32];
+	char buf[1024];
+	atomic_t activeContexts;
+};
+
+static struct vmci_linux_state linuxState;
+
+static int VMCISetupNotify(struct vmci_context *context, uintptr_t notifyUVA);
+
+static void VMCIUnsetNotifyInt(struct vmci_context *context, bool useLock);
+
+static int LinuxDriver_Open(struct inode *inode, struct file *filp);
+
+static long LinuxDriver_UnlockedIoctl(struct file *filp,
+				      u_int iocmd, unsigned long ioarg);
+
+static int LinuxDriver_Close(struct inode *inode, struct file *filp);
+
+static unsigned int LinuxDriverPoll(struct file *file, poll_table * wait);
+
+static struct file_operations vmuser_fops;
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
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * vmci_host_init --
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
+int vmci_host_init(void)
+{
+	int retval;
+
+	if (VMCI_HostInit() < VMCI_SUCCESS) {
+		return -ENOMEM;
+	}
+
+	/*
+	 * Initialize the file_operations structure. Because this code is always
+	 * compiled as a module, this is fine to do it here and not in a static
+	 * initializer.
+	 */
+
+	memset(&vmuser_fops, 0, sizeof vmuser_fops);
+	vmuser_fops.owner = THIS_MODULE;
+	vmuser_fops.poll = LinuxDriverPoll;
+	vmuser_fops.unlocked_ioctl = LinuxDriver_UnlockedIoctl;
+	vmuser_fops.compat_ioctl = LinuxDriver_UnlockedIoctl;
+	vmuser_fops.open = LinuxDriver_Open;
+	vmuser_fops.release = LinuxDriver_Close;
+
+	sprintf(linuxState.deviceName, "vmci");
+	linuxState.major = 10;
+	linuxState.misc.minor = MISC_DYNAMIC_MINOR;
+	linuxState.misc.name = linuxState.deviceName;
+	linuxState.misc.fops = &vmuser_fops;
+	atomic_set(&linuxState.activeContexts, 0);
+
+	retval = misc_register(&linuxState.misc);
+
+	if (retval) {
+		printk(KERN_WARNING LGPFX "Module registration error "
+		       "(name=%s,major=%d,minor=%d,err=%d).\n",
+		       linuxState.deviceName, -retval, linuxState.major,
+		       linuxState.minor);
+		VMCI_HostCleanup();
+	} else {
+		linuxState.minor = linuxState.misc.minor;
+		printk(KERN_INFO LGPFX
+		       "Module registered (name=%s,major=%d,"
+		       "minor=%d).\n", linuxState.deviceName,
+		       linuxState.major, linuxState.minor);
+	}
+
+	return retval;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * LinuxDriver_Open  --
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
+static int LinuxDriver_Open(struct inode *inode,	// IN
+			    struct file *filp)	// IN
+{
+	struct vmci_linux *vmciLinux;
+
+	vmciLinux = kmalloc(sizeof(struct vmci_linux), GFP_KERNEL);
+	if (vmciLinux == NULL) {
+		return -ENOMEM;
+	}
+	memset(vmciLinux, 0, sizeof *vmciLinux);	/* XXX: Necessary? */
+	vmciLinux->ctType = VMCIOBJ_NOT_SET;
+	vmciLinux->userVersion = 0;	/* XXX: Not necessary w/ memset */
+	mutex_init(&vmciLinux->lock);
+	filp->private_data = vmciLinux;
+
+	return 0;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * LinuxDriver_Close  --
+ *
+ *      Called on close of /dev/vmci, most often when the process
+ *      exits.
+ *
+ *----------------------------------------------------------------------
+ */
+
+static int LinuxDriver_Close(struct inode *inode,	// IN
+			     struct file *filp)	// IN
+{
+	struct vmci_linux *vmciLinux;
+
+	vmciLinux = (struct vmci_linux *)filp->private_data;
+	ASSERT(vmciLinux);
+
+	if (vmciLinux->ctType == VMCIOBJ_CONTEXT) {
+		ASSERT(vmciLinux->context);
+
+		VMCIContext_ReleaseContext(vmciLinux->context);
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
+ * LinuxDriverPoll  --
+ *
+ *      This is used to wake up the VMX when a VMCI call arrives, or
+ *      to wake up select() or poll() at the next clock tick.
+ *
+ *----------------------------------------------------------------------
+ */
+
+static unsigned int LinuxDriverPoll(struct file *filp, poll_table * wait)
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
+		    VMCIHandleArray_GetSize(vmciLinux->
+					    context->pendingDoorbellArray) >
+		    0) {
+			mask = POLLIN;
+		}
+		spin_unlock(&vmciLinux->context->lock);
+	}
+	return mask;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCICopyHandleArrayToUser  --
+ *
+ *      Copies the handles of a handle array into a user buffer, and
+ *      returns the new length in userBufferSize. If the copy to the
+ *      user buffer fails, the functions still returns VMCI_SUCCESS,
+ *      but retval != 0.
+ *
+ *----------------------------------------------------------------------
+ */
+
+static int VMCICopyHandleArrayToUser(void *userBufUVA,	// IN
+				     uint64_t * userBufSize,	// IN/OUT
+				     struct vmci_handle_arr *handleArray,	// IN
+				     int *retval)	// IN
+{
+	uint32_t arraySize;
+	struct vmci_handle *handles;
+
+	if (handleArray) {
+		arraySize = VMCIHandleArray_GetSize(handleArray);
+	} else {
+		arraySize = 0;
+	}
+
+	if (arraySize * sizeof *handles > *userBufSize) {
+		return VMCI_ERROR_MORE_DATA;
+	}
+
+	*userBufSize = arraySize * sizeof *handles;
+	if (*userBufSize) {
+		*retval = copy_to_user(userBufUVA,
+				       VMCIHandleArray_GetHandles
+				       (handleArray), *userBufSize);
+	}
+
+	return VMCI_SUCCESS;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIDoQPBrokerAlloc --
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
+static int
+VMCIDoQPBrokerAlloc(struct vmci_handle handle,
+		    uint32_t peer,
+		    uint32_t flags,
+		    uint64_t produceSize,
+		    uint64_t consumeSize,
+		    QueuePairPageStore * pageStore,
+		    struct vmci_context *context, bool vmToVm, void *resultUVA)
+{
+	uint32_t cid;
+	int result;
+	int retval;
+
+	cid = VMCIContext_GetId(context);
+
+	result =
+	    VMCIQPBroker_Alloc(handle, peer, flags,
+			       VMCI_NO_PRIVILEGE_FLAGS, produceSize,
+			       consumeSize, pageStore, context);
+	if (result == VMCI_SUCCESS && vmToVm) {
+		result = VMCI_SUCCESS_QUEUEPAIR_CREATE;
+	}
+	retval = copy_to_user(resultUVA, &result, sizeof result);
+	if (retval) {
+		retval = -EFAULT;
+		if (result >= VMCI_SUCCESS) {
+			result = VMCIQPBroker_Detach(handle, context);
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
+ * LinuxDriver_UnlockedIoctl --
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
+static long
+LinuxDriver_UnlockedIoctl(struct file *filp, u_int iocmd, unsigned long ioarg)
+{
+	struct vmci_linux *vmciLinux = (struct vmci_linux *)filp->private_data;
+	int retval = 0;
+
+	switch (iocmd) {
+	case IOCTL_VMCI_VERSION2:{
+			int verFromUser;
+
+			if (copy_from_user
+			    (&verFromUser, (void *)ioarg, sizeof verFromUser)) {
+				retval = -EFAULT;
+				break;
+			}
+
+			vmciLinux->userVersion = verFromUser;
+		}
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
+			struct vmci_init_blk initBlock;
+			uid_t user;
+
+			retval =
+			    copy_from_user(&initBlock, (void *)ioarg,
+					   sizeof initBlock);
+			if (retval != 0) {
+				printk(KERN_INFO LGPFX
+				       "Error reading init block.\n");
+				retval = -EFAULT;
+				break;
+			}
+
+			mutex_lock(&vmciLinux->lock);
+			if (vmciLinux->ctType != VMCIOBJ_NOT_SET) {
+				printk(KERN_INFO LGPFX
+				       "Received VMCI init on initialized handle.\n");
+				retval = -EINVAL;
+				goto init_release;
+			}
+
+			if (initBlock.flags & ~VMCI_PRIVILEGE_FLAG_RESTRICTED) {
+				printk(KERN_INFO LGPFX
+				       "Unsupported VMCI restriction flag.\n");
+				retval = -EINVAL;
+				goto init_release;
+			}
+
+			user = current_uid();
+			retval =
+			    VMCIContext_InitContext(initBlock.cid,
+						    initBlock.flags,
+						    0 /* Unused */ ,
+						    vmciLinux->userVersion,
+						    &user, &vmciLinux->context);
+			if (retval < VMCI_SUCCESS) {
+				printk(KERN_INFO LGPFX
+				       "Error initializing context.\n");
+				retval =
+				    retval ==
+				    VMCI_ERROR_DUPLICATE_ENTRY ? -EEXIST :
+				    -EINVAL;
+				goto init_release;
+			}
+
+			/*
+			 * Copy cid to userlevel, we do this to allow the VMX to enforce its
+			 * policy on cid generation.
+			 */
+			initBlock.cid = VMCIContext_GetId(vmciLinux->context);
+			retval =
+			    copy_to_user((void *)ioarg, &initBlock,
+					 sizeof initBlock);
+			if (retval != 0) {
+				VMCIContext_ReleaseContext(vmciLinux->context);
+				vmciLinux->context = NULL;
+				printk(KERN_INFO LGPFX
+				       "Error writing init block.\n");
+				retval = -EFAULT;
+				goto init_release;
+			}
+			ASSERT(initBlock.cid != VMCI_INVALID_ID);
+
+			vmciLinux->ctType = VMCIOBJ_CONTEXT;
+
+			atomic_inc(&linuxState.activeContexts);
+
+ init_release:
+			mutex_unlock(&vmciLinux->lock);
+			break;
+		}
+
+	case IOCTL_VMCI_DATAGRAM_SEND:{
+			struct vmci_dg_snd_rcv_info sendInfo;
+			struct vmci_datagram *dg = NULL;
+			uint32_t cid;
+
+			if (vmciLinux->ctType != VMCIOBJ_CONTEXT) {
+				Warning(LGPFX
+					"Ioctl only valid for context handle (iocmd=%d).\n",
+					iocmd);
+				retval = -EINVAL;
+				break;
+			}
+
+			retval =
+			    copy_from_user(&sendInfo, (void *)ioarg,
+					   sizeof sendInfo);
+			if (retval) {
+				Warning(LGPFX "copy_from_user failed.\n");
+				retval = -EFAULT;
+				break;
+			}
+
+			if (sendInfo.len > VMCI_MAX_DG_SIZE) {
+				Warning(LGPFX
+					"Datagram too big (size=%d).\n",
+					sendInfo.len);
+				retval = -EINVAL;
+				break;
+			}
+
+			if (sendInfo.len < sizeof *dg) {
+				Warning(LGPFX
+					"Datagram too small (size=%d).\n",
+					sendInfo.len);
+				retval = -EINVAL;
+				break;
+			}
+
+			dg = kmalloc(sendInfo.len, GFP_KERNEL);
+			if (dg == NULL) {
+				printk(KERN_INFO LGPFX
+				       "Cannot allocate memory to dispatch datagram.\n");
+				retval = -ENOMEM;
+				break;
+			}
+
+			retval =
+			    copy_from_user(dg,
+					   (char *)(uintptr_t) sendInfo.addr,
+					   sendInfo.len);
+			if (retval != 0) {
+				printk(KERN_INFO LGPFX
+				       "Error getting datagram (err=%d).\n",
+				       retval);
+				kfree(dg);
+				retval = -EFAULT;
+				break;
+			}
+
+			VMCI_DEBUG_LOG(10,
+				       (LGPFX
+					"Datagram dst (handle=0x%x:0x%x) src "
+					"(handle=0x%x:0x%x), payload (size=%"
+					FMT64 "u " "bytes).\n",
+					dg->dst.context, dg->dst.resource,
+					dg->src.context, dg->src.resource,
+					dg->payloadSize));
+
+			/* Get source context id. */
+			ASSERT(vmciLinux->context);
+			cid = VMCIContext_GetId(vmciLinux->context);
+			ASSERT(cid != VMCI_INVALID_ID);
+			sendInfo.result = VMCIDatagram_Dispatch(cid, dg, true);
+			kfree(dg);
+			retval =
+			    copy_to_user((void *)ioarg, &sendInfo,
+					 sizeof sendInfo);
+			break;
+		}
+
+	case IOCTL_VMCI_DATAGRAM_RECEIVE:{
+			struct vmci_dg_snd_rcv_info recvInfo;
+			struct vmci_datagram *dg = NULL;
+			size_t size;
+
+			if (vmciLinux->ctType != VMCIOBJ_CONTEXT) {
+				Warning(LGPFX
+					"Ioctl only valid for context handle (iocmd=%d).\n",
+					iocmd);
+				retval = -EINVAL;
+				break;
+			}
+
+			retval =
+			    copy_from_user(&recvInfo, (void *)ioarg,
+					   sizeof recvInfo);
+			if (retval) {
+				Warning(LGPFX "copy_from_user failed.\n");
+				retval = -EFAULT;
+				break;
+			}
+
+			ASSERT(vmciLinux->ctType == VMCIOBJ_CONTEXT);
+
+			size = recvInfo.len;
+			ASSERT(vmciLinux->context);
+			recvInfo.result =
+			    VMCIContext_DequeueDatagram(vmciLinux->context,
+							&size, &dg);
+
+			if (recvInfo.result >= VMCI_SUCCESS) {
+				ASSERT(dg);
+				retval = copy_to_user((void *)((uintptr_t)
+							       recvInfo.addr),
+						      dg, VMCI_DG_SIZE(dg));
+				kfree(dg);
+				if (retval != 0) {
+					break;
+				}
+			}
+			retval =
+			    copy_to_user((void *)ioarg, &recvInfo,
+					 sizeof recvInfo);
+			break;
+		}
+
+	case IOCTL_VMCI_QUEUEPAIR_ALLOC:{
+			if (vmciLinux->ctType != VMCIOBJ_CONTEXT) {
+				printk(KERN_INFO LGPFX
+				       "IOCTL_VMCI_QUEUEPAIR_ALLOC only valid for contexts.\n");
+				retval = -EINVAL;
+				break;
+			}
+
+			if (vmciLinux->userVersion < VMCI_VERSION_NOVMVM) {
+				struct vmci_qp_ai_vmvm queuePairAllocInfo;
+				struct vmci_qp_ai_vmvm *info =
+				    (struct vmci_qp_ai_vmvm *)ioarg;
+
+				retval =
+				    copy_from_user(&queuePairAllocInfo,
+						   (void *)ioarg,
+						   sizeof queuePairAllocInfo);
+				if (retval) {
+					retval = -EFAULT;
+					break;
+				}
+
+				retval = VMCIDoQPBrokerAlloc(queuePairAllocInfo.handle, queuePairAllocInfo.peer, queuePairAllocInfo.flags, queuePairAllocInfo.produceSize, queuePairAllocInfo.consumeSize, NULL, vmciLinux->context, true,	// VM to VM style create
+							     &info->result);
+			} else {
+				struct vmci_qp_alloc_info
+				 queuePairAllocInfo;
+				struct vmci_qp_alloc_info *info =
+				    (struct vmci_qp_alloc_info *)ioarg;
+				QueuePairPageStore pageStore;
+
+				retval =
+				    copy_from_user(&queuePairAllocInfo,
+						   (void *)ioarg,
+						   sizeof queuePairAllocInfo);
+				if (retval) {
+					retval = -EFAULT;
+					break;
+				}
+
+				pageStore.pages = queuePairAllocInfo.ppnVA;
+				pageStore.len = queuePairAllocInfo.numPPNs;
+
+				retval = VMCIDoQPBrokerAlloc(queuePairAllocInfo.handle, queuePairAllocInfo.peer, queuePairAllocInfo.flags, queuePairAllocInfo.produceSize, queuePairAllocInfo.consumeSize, &pageStore, vmciLinux->context, false,	// Not VM to VM style create
+							     &info->result);
+			}
+			break;
+		}
+
+	case IOCTL_VMCI_QUEUEPAIR_SETVA:{
+			struct vmci_qp_set_va_info setVAInfo;
+			struct vmci_qp_set_va_info *info =
+			    (struct vmci_qp_set_va_info *)ioarg;
+			int32_t result;
+
+			if (vmciLinux->ctType != VMCIOBJ_CONTEXT) {
+				printk(KERN_INFO LGPFX
+				       "IOCTL_VMCI_QUEUEPAIR_SETVA only valid for contexts.\n");
+				retval = -EINVAL;
+				break;
+			}
+
+			if (vmciLinux->userVersion < VMCI_VERSION_NOVMVM) {
+				printk(KERN_INFO LGPFX
+				       "IOCTL_VMCI_QUEUEPAIR_SETVA not supported for this VMX version.\n");
+				retval = -EINVAL;
+				break;
+			}
+
+			retval =
+			    copy_from_user(&setVAInfo, (void *)ioarg,
+					   sizeof setVAInfo);
+			if (retval) {
+				retval = -EFAULT;
+				break;
+			}
+
+			if (setVAInfo.va) {
+				/*
+				 * VMX is passing down a new VA for the queue pair mapping.
+				 */
+
+				result =
+				    VMCIQPBroker_Map(setVAInfo.handle,
+						     vmciLinux->context,
+						     setVAInfo.va);
+			} else {
+				/*
+				 * The queue pair is about to be unmapped by the VMX.
+				 */
+
+				result =
+				    VMCIQPBroker_Unmap(setVAInfo.handle,
+						       vmciLinux->context, 0);
+			}
+
+			retval =
+			    copy_to_user(&info->result, &result, sizeof result);
+			if (retval) {
+				retval = -EFAULT;
+			}
+
+			break;
+		}
+
+	case IOCTL_VMCI_QUEUEPAIR_SETPAGEFILE:{
+			struct vmci_qp_page_file_info pageFileInfo;
+			struct vmci_qp_page_file_info *info =
+			    (struct vmci_qp_page_file_info *)ioarg;
+			int32_t result;
+
+			if (vmciLinux->userVersion < VMCI_VERSION_HOSTQP ||
+			    vmciLinux->userVersion >= VMCI_VERSION_NOVMVM) {
+				printk(KERN_INFO LGPFX
+				       "IOCTL_VMCI_QUEUEPAIR_SETPAGEFILE not supported this VMX "
+				       "(version=%d).\n",
+				       vmciLinux->userVersion);
+				retval = -EINVAL;
+				break;
+			}
+
+			if (vmciLinux->ctType != VMCIOBJ_CONTEXT) {
+				printk(KERN_INFO LGPFX
+				       "IOCTL_VMCI_QUEUEPAIR_SETPAGEFILE only valid for contexts.\n");
+				retval = -EINVAL;
+				break;
+			}
+
+			retval =
+			    copy_from_user(&pageFileInfo, (void *)ioarg,
+					   sizeof *info);
+			if (retval) {
+				retval = -EFAULT;
+				break;
+			}
+
+			/*
+			 * Communicate success pre-emptively to the caller.  Note that
+			 * the basic premise is that it is incumbent upon the caller not
+			 * to look at the info.result field until after the ioctl()
+			 * returns.  And then, only if the ioctl() result indicates no
+			 * error.  We send up the SUCCESS status before calling
+			 * SetPageStore() store because failing to copy up the result
+			 * code means unwinding the SetPageStore().
+			 *
+			 * It turns out the logic to unwind a SetPageStore() opens a can
+			 * of worms.  For example, if a host had created the QueuePair
+			 * and a guest attaches and SetPageStore() is successful but
+			 * writing success fails, then ... the host has to be stopped
+			 * from writing (anymore) data into the QueuePair.  That means
+			 * an additional test in the VMCI_Enqueue() code path.  Ugh.
+			 */
+
+			result = VMCI_SUCCESS;
+			retval =
+			    copy_to_user(&info->result, &result, sizeof result);
+			if (retval == 0) {
+				result =
+				    VMCIQPBroker_SetPageStore
+				    (pageFileInfo.handle,
+				     pageFileInfo.produceVA,
+				     pageFileInfo.consumeVA,
+				     vmciLinux->context);
+				if (result < VMCI_SUCCESS) {
+
+					retval =
+					    copy_to_user(&info->result,
+							 &result,
+							 sizeof result);
+					if (retval != 0) {
+						/*
+						 * Note that in this case the SetPageStore() call
+						 * failed but we were unable to communicate that to the
+						 * caller (because the copy_to_user() call failed).
+						 * So, if we simply return an error (in this case
+						 * -EFAULT) then the caller will know that the
+						 * SetPageStore failed even though we couldn't put the
+						 * result code in the result field and indicate exactly
+						 * why it failed.
+						 *
+						 * That says nothing about the issue where we were once
+						 * able to write to the caller's info memory and now
+						 * can't.  Something more serious is probably going on
+						 * than the fact that SetPageStore() didn't work.
+						 */
+						retval = -EFAULT;
+					}
+				}
+
+			} else {
+				/*
+				 * In this case, we can't write a result field of the
+				 * caller's info block.  So, we don't even try to
+				 * SetPageStore().
+				 */
+				retval = -EFAULT;
+			}
+
+			break;
+		}
+
+	case IOCTL_VMCI_QUEUEPAIR_DETACH:{
+			struct vmci_qp_dtch_info detachInfo;
+			struct vmci_qp_dtch_info *info =
+			    (struct vmci_qp_dtch_info *)ioarg;
+			int32_t result;
+
+			if (vmciLinux->ctType != VMCIOBJ_CONTEXT) {
+				printk(KERN_INFO LGPFX
+				       "IOCTL_VMCI_QUEUEPAIR_DETACH only valid for contexts.\n");
+				retval = -EINVAL;
+				break;
+			}
+
+			retval =
+			    copy_from_user(&detachInfo, (void *)ioarg,
+					   sizeof detachInfo);
+			if (retval) {
+				retval = -EFAULT;
+				break;
+			}
+
+			result =
+			    VMCIQPBroker_Detach(detachInfo.handle,
+						vmciLinux->context);
+			if (result == VMCI_SUCCESS
+			    && vmciLinux->userVersion < VMCI_VERSION_NOVMVM) {
+				result = VMCI_SUCCESS_LAST_DETACH;
+			}
+
+			retval =
+			    copy_to_user(&info->result, &result, sizeof result);
+			if (retval) {
+				retval = -EFAULT;
+			}
+
+			break;
+		}
+
+	case IOCTL_VMCI_CTX_ADD_NOTIFICATION:{
+			struct vmci_notify_add_rm_info arInfo;
+			struct vmci_notify_add_rm_info *info =
+			    (struct vmci_notify_add_rm_info *)ioarg;
+			int32_t result;
+			uint32_t cid;
+
+			if (vmciLinux->ctType != VMCIOBJ_CONTEXT) {
+				printk(KERN_INFO LGPFX
+				       "IOCTL_VMCI_CTX_ADD_NOTIFICATION only valid for contexts.\n");
+				retval = -EINVAL;
+				break;
+			}
+
+			retval =
+			    copy_from_user(&arInfo, (void *)ioarg,
+					   sizeof arInfo);
+			if (retval) {
+				retval = -EFAULT;
+				break;
+			}
+
+			cid = VMCIContext_GetId(vmciLinux->context);
+			result =
+			    VMCIContext_AddNotification(cid, arInfo.remoteCID);
+			retval =
+			    copy_to_user(&info->result, &result, sizeof result);
+			if (retval) {
+				retval = -EFAULT;
+				break;
+			}
+			break;
+		}
+
+	case IOCTL_VMCI_CTX_REMOVE_NOTIFICATION:{
+			struct vmci_notify_add_rm_info arInfo;
+			struct vmci_notify_add_rm_info *info =
+			    (struct vmci_notify_add_rm_info *)ioarg;
+			int32_t result;
+			uint32_t cid;
+
+			if (vmciLinux->ctType != VMCIOBJ_CONTEXT) {
+				printk(KERN_INFO LGPFX
+				       "IOCTL_VMCI_CTX_REMOVE_NOTIFICATION only valid for "
+				       "contexts.\n");
+				retval = -EINVAL;
+				break;
+			}
+
+			retval =
+			    copy_from_user(&arInfo, (void *)ioarg,
+					   sizeof arInfo);
+			if (retval) {
+				retval = -EFAULT;
+				break;
+			}
+
+			cid = VMCIContext_GetId(vmciLinux->context);
+			result =
+			    VMCIContext_RemoveNotification(cid,
+							   arInfo.remoteCID);
+			retval =
+			    copy_to_user(&info->result, &result, sizeof result);
+			if (retval) {
+				retval = -EFAULT;
+				break;
+			}
+			break;
+		}
+
+	case IOCTL_VMCI_CTX_GET_CPT_STATE:{
+			struct vmci_chkpt_buf_info getInfo;
+			uint32_t cid;
+			char *cptBuf;
+
+			if (vmciLinux->ctType != VMCIOBJ_CONTEXT) {
+				printk(KERN_INFO LGPFX
+				       "IOCTL_VMCI_CTX_GET_CPT_STATE only valid for contexts.\n");
+				retval = -EINVAL;
+				break;
+			}
+
+			retval =
+			    copy_from_user(&getInfo, (void *)ioarg,
+					   sizeof getInfo);
+			if (retval) {
+				retval = -EFAULT;
+				break;
+			}
+
+			cid = VMCIContext_GetId(vmciLinux->context);
+			getInfo.result =
+			    VMCIContext_GetCheckpointState(cid,
+							   getInfo.cptType,
+							   &getInfo.bufSize,
+							   &cptBuf);
+			if (getInfo.result == VMCI_SUCCESS && getInfo.bufSize) {
+				retval = copy_to_user((void *)(uintptr_t)
+						      getInfo.cptBuf, cptBuf,
+						      getInfo.bufSize);
+				kfree(cptBuf);
+				if (retval) {
+					retval = -EFAULT;
+					break;
+				}
+			}
+			retval =
+			    copy_to_user((void *)ioarg, &getInfo,
+					 sizeof getInfo);
+			if (retval) {
+				retval = -EFAULT;
+				break;
+			}
+			break;
+		}
+
+	case IOCTL_VMCI_CTX_SET_CPT_STATE:{
+			struct vmci_chkpt_buf_info setInfo;
+			uint32_t cid;
+			char *cptBuf;
+
+			if (vmciLinux->ctType != VMCIOBJ_CONTEXT) {
+				printk(KERN_INFO LGPFX
+				       "IOCTL_VMCI_CTX_SET_CPT_STATE only valid for contexts.\n");
+				retval = -EINVAL;
+				break;
+			}
+
+			retval =
+			    copy_from_user(&setInfo, (void *)ioarg,
+					   sizeof setInfo);
+			if (retval) {
+				retval = -EFAULT;
+				break;
+			}
+
+			cptBuf = kmalloc(setInfo.bufSize, GFP_KERNEL);
+			if (cptBuf == NULL) {
+				printk(KERN_INFO LGPFX
+				       "Cannot allocate memory to set cpt state (type=%d).\n",
+				       setInfo.cptType);
+				retval = -ENOMEM;
+				break;
+			}
+			retval =
+			    copy_from_user(cptBuf,
+					   (void *)(uintptr_t) setInfo.cptBuf,
+					   setInfo.bufSize);
+			if (retval) {
+				kfree(cptBuf);
+				retval = -EFAULT;
+				break;
+			}
+
+			cid = VMCIContext_GetId(vmciLinux->context);
+			setInfo.result =
+			    VMCIContext_SetCheckpointState(cid,
+							   setInfo.cptType,
+							   setInfo.bufSize,
+							   cptBuf);
+			kfree(cptBuf);
+			retval =
+			    copy_to_user((void *)ioarg, &setInfo,
+					 sizeof setInfo);
+			if (retval) {
+				retval = -EFAULT;
+				break;
+			}
+			break;
+		}
+
+	case IOCTL_VMCI_GET_CONTEXT_ID:{
+			uint32_t cid = VMCI_HOST_CONTEXT_ID;
+
+			retval = copy_to_user((void *)ioarg, &cid, sizeof cid);
+			break;
+		}
+
+	case IOCTL_VMCI_SET_NOTIFY:{
+			struct vmci_set_notify_info notifyInfo;
+
+			if (vmciLinux->ctType != VMCIOBJ_CONTEXT) {
+				printk(KERN_INFO LGPFX
+				       "IOCTL_VMCI_SET_NOTIFY only valid for contexts.\n");
+				retval = -EINVAL;
+				break;
+			}
+
+			retval =
+			    copy_from_user(&notifyInfo, (void *)ioarg,
+					   sizeof notifyInfo);
+			if (retval) {
+				retval = -EFAULT;
+				break;
+			}
+
+			if ((uintptr_t) notifyInfo.notifyUVA !=
+			    (uintptr_t) NULL) {
+				notifyInfo.result =
+				    VMCISetupNotify(vmciLinux->context,
+						    (uintptr_t)
+						    notifyInfo.notifyUVA);
+			} else {
+				VMCIUnsetNotifyInt(vmciLinux->context, true);
+				notifyInfo.result = VMCI_SUCCESS;
+			}
+
+			retval =
+			    copy_to_user((void *)ioarg, &notifyInfo,
+					 sizeof notifyInfo);
+			if (retval) {
+				retval = -EFAULT;
+				break;
+			}
+
+			break;
+		}
+
+	case IOCTL_VMCI_NOTIFY_RESOURCE:{
+			struct vmci_notify_rsrc_info info;
+			uint32_t cid;
+
+			if (vmciLinux->userVersion < VMCI_VERSION_NOTIFY) {
+				printk(KERN_INFO LGPFX
+				       "IOCTL_VMCI_NOTIFY_RESOURCE is invalid for current"
+				       " VMX versions.\n");
+				retval = -EINVAL;
+				break;
+			}
+
+			if (vmciLinux->ctType != VMCIOBJ_CONTEXT) {
+				printk(KERN_INFO LGPFX
+				       "IOCTL_VMCI_NOTIFY_RESOURCE is only valid for contexts.\n");
+				retval = -EINVAL;
+				break;
+			}
+
+			retval =
+			    copy_from_user(&info, (void *)ioarg, sizeof info);
+			if (retval) {
+				retval = -EFAULT;
+				break;
+			}
+
+			cid = VMCIContext_GetId(vmciLinux->context);
+			switch (info.action) {
+			case VMCI_NOTIFY_RESOURCE_ACTION_NOTIFY:
+				if (info.resource ==
+				    VMCI_NOTIFY_RESOURCE_DOOR_BELL) {
+					info.result =
+					    VMCIContext_NotifyDoorbell(cid,
+								       info.handle,
+								       VMCI_NO_PRIVILEGE_FLAGS);
+				} else {
+					info.result = VMCI_ERROR_UNAVAILABLE;
+				}
+				break;
+			case VMCI_NOTIFY_RESOURCE_ACTION_CREATE:
+				info.result =
+				    VMCIContext_DoorbellCreate(cid,
+							       info.handle);
+				break;
+			case VMCI_NOTIFY_RESOURCE_ACTION_DESTROY:
+				info.result =
+				    VMCIContext_DoorbellDestroy(cid,
+								info.handle);
+				break;
+			default:
+				printk(KERN_INFO LGPFX
+				       "IOCTL_VMCI_NOTIFY_RESOURCE got unknown action (action=%d).\n",
+				       info.action);
+				info.result = VMCI_ERROR_INVALID_ARGS;
+			}
+			retval = copy_to_user((void *)ioarg, &info,
+					      sizeof info);
+			if (retval) {
+				retval = -EFAULT;
+				break;
+			}
+
+			break;
+		}
+
+	case IOCTL_VMCI_NOTIFICATIONS_RECEIVE:{
+			struct vmci_notify_recv_info info;
+			struct vmci_handle_arr *dbHandleArray;
+			struct vmci_handle_arr *qpHandleArray;
+			uint32_t cid;
+
+			if (vmciLinux->ctType != VMCIOBJ_CONTEXT) {
+				printk(KERN_INFO LGPFX
+				       "IOCTL_VMCI_NOTIFICATIONS_RECEIVE is only valid for contexts.\n");
+				retval = -EINVAL;
+				break;
+			}
+
+			if (vmciLinux->userVersion < VMCI_VERSION_NOTIFY) {
+				printk(KERN_INFO LGPFX
+				       "IOCTL_VMCI_NOTIFICATIONS_RECEIVE is not supported for the"
+				       " current vmx version.\n");
+				retval = -EINVAL;
+				break;
+			}
+
+			retval =
+			    copy_from_user(&info, (void *)ioarg, sizeof info);
+			if (retval) {
+				retval = -EFAULT;
+				break;
+			}
+
+			if ((info.dbHandleBufSize && !info.dbHandleBufUVA)
+			    || (info.qpHandleBufSize && !info.qpHandleBufUVA)) {
+				retval = -EINVAL;
+				break;
+			}
+
+			cid = VMCIContext_GetId(vmciLinux->context);
+			info.result =
+			    VMCIContext_ReceiveNotificationsGet(cid,
+								&dbHandleArray,
+								&qpHandleArray);
+			if (info.result == VMCI_SUCCESS) {
+				info.result = VMCICopyHandleArrayToUser((void *)
+									(uintptr_t)
+									info.dbHandleBufUVA,
+									&info.dbHandleBufSize,
+									dbHandleArray,
+									&retval);
+				if (info.result == VMCI_SUCCESS && !retval) {
+					info.result =
+					    VMCICopyHandleArrayToUser((void *)
+								      (uintptr_t)
+								      info.qpHandleBufUVA,
+								      &info.qpHandleBufSize,
+								      qpHandleArray,
+								      &retval);
+				}
+				if (!retval) {
+					retval =
+					    copy_to_user((void *)ioarg,
+							 &info, sizeof info);
+				}
+				VMCIContext_ReceiveNotificationsRelease
+				    (cid, dbHandleArray, qpHandleArray,
+				     info.result == VMCI_SUCCESS && !retval);
+			} else {
+				retval =
+				    copy_to_user((void *)ioarg, &info,
+						 sizeof info);
+			}
+			break;
+		}
+
+	default:
+		Warning(LGPFX "Unknown ioctl (iocmd=%d).\n", iocmd);
+		retval = -EINVAL;
+	}
+
+	return retval;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIUserVALockPage --
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
+static inline struct page *VMCIUserVALockPage(uintptr_t addr)	// IN:
+{
+	struct page *page = NULL;
+	int retval;
+
+	down_read(&current->mm->mmap_sem);
+	retval = get_user_pages(current, current->mm, addr,
+				1, 1, 0, &page, NULL);
+	up_read(&current->mm->mmap_sem);
+
+	if (retval != 1) {
+		return NULL;
+	}
+
+	return page;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIMapBoolPtr --
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
+static inline int VMCIMapBoolPtr(uintptr_t notifyUVA,	// IN:
+				 struct page **p,	// OUT:
+				 bool ** notifyPtr)	// OUT:
+{
+	if (!access_ok(VERIFY_WRITE, notifyUVA, sizeof **notifyPtr) ||
+	    (((notifyUVA + sizeof **notifyPtr - 1) & ~(PAGE_SIZE - 1)) !=
+	     (notifyUVA & ~(PAGE_SIZE - 1)))) {
+		return -EINVAL;
+	}
+
+	*p = VMCIUserVALockPage(notifyUVA);
+	if (*p == NULL) {
+		return -EAGAIN;
+	}
+
+	*notifyPtr =
+	    (bool *) ((uint8_t *) kmap(*p) + (notifyUVA & (PAGE_SIZE - 1)));
+	return 0;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCISetupNotify --
+ *
+ *      Sets up a given context for notify to work.  Calls VMCIMapBoolPtr()
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
+static int VMCISetupNotify(struct vmci_context *context,	// IN:
+			   uintptr_t notifyUVA)	// IN:
+{
+	int retval;
+
+	if (context->notify) {
+		Warning(LGPFX "Notify mechanism is already set up.\n");
+		return VMCI_ERROR_DUPLICATE_ENTRY;
+	}
+
+	retval =
+	    VMCIMapBoolPtr(notifyUVA, &context->notifyPage,
+			   &context->notify) ==
+	    0 ? VMCI_SUCCESS : VMCI_ERROR_GENERIC;
+	if (retval == VMCI_SUCCESS) {
+		VMCIContext_CheckAndSignalNotify(context);
+	}
+
+	return retval;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIUnsetNotifyInt --
+ *
+ *      Internal version of VMCIUnsetNotify, that allows for locking
+ *      the context before unsetting the notify pointer. If useLock is
+ *      true, the context lock is grabbed.
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
+static void VMCIUnsetNotifyInt(struct vmci_context *context,	// IN
+			       bool useLock)	// IN
+{
+	if (useLock) {
+		spin_lock(&context->lock);
+	}
+
+	if (context->notifyPage) {
+		struct page *notifyPage = context->notifyPage;
+
+		context->notify = NULL;
+		context->notifyPage = NULL;
+
+		if (useLock) {
+			spin_unlock(&context->lock);
+		}
+
+		kunmap(notifyPage);
+		put_page(notifyPage);
+	} else {
+		if (useLock) {
+			spin_unlock(&context->lock);
+		}
+	}
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIUnsetNotify --
+ *
+ *      Reverts actions set up by VMCISetupNotify().  Unmaps and unlocks the
+ *      page mapped/locked by VMCISetupNotify().
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
+void VMCIUnsetNotify(struct vmci_context *context)	// IN:
+{
+	VMCIUnsetNotifyInt(context, false);
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
+ * dispatch_datagrams --
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
+void dispatch_datagrams(unsigned long data)
+{
+	struct vmci_device *dev = (struct vmci_device *)data;
+
+	if (dev == NULL) {
+		printk(KERN_DEBUG
+		       "vmci: dispatch_datagrams(): no vmci device"
+		       "present.\n");
+		return;
+	}
+
+	if (data_buffer == NULL) {
+		printk(KERN_DEBUG
+		       "vmci: dispatch_datagrams(): no buffer present.\n");
+		return;
+	}
+
+	VMCI_ReadDatagramsFromPort((int)0,
+				   dev->ioaddr + VMCI_DATA_IN_ADDR,
+				   data_buffer, data_buffer_size);
+}
+DECLARE_TASKLET(vmci_dg_tasklet, dispatch_datagrams, (unsigned long)&vmci_dev);
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * process_bitmap --
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
+void process_bitmap(unsigned long data)
+{
+	struct vmci_device *dev = (struct vmci_device *)data;
+
+	if (dev == NULL) {
+		printk(KERN_DEBUG "vmci: process_bitmaps(): no vmci device"
+		       "present.\n");
+		return;
+	}
+
+	if (notification_bitmap == NULL) {
+		printk(KERN_DEBUG
+		       "vmci: process_bitmaps(): no bitmap present.\n");
+		return;
+	}
+
+	VMCI_ScanNotificationBitmap(notification_bitmap);
+}
+DECLARE_TASKLET(vmci_bm_tasklet, process_bitmap, (unsigned long)&vmci_dev);
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * vmci_guest_init --
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
+static int vmci_guest_init(void)
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
+	if (!data_buffer) {
+		return -ENOMEM;
+	}
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
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * vmci_enable_msix --
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
+static int vmci_enable_msix(struct pci_dev *pdev)	// IN
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
+	if (!result) {
+		vmci_dev.exclusive_vectors = true;
+	} else if (result > 0) {
+		result = pci_enable_msix(pdev, vmci_dev.msix_entries, 1);
+	}
+	return result;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * vmci_interrupt --
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
+static irqreturn_t vmci_interrupt(int irq,	// IN
+				  void *clientdata)	// IN
+{
+	struct vmci_device *dev = clientdata;
+
+	if (dev == NULL) {
+		printk(KERN_DEBUG
+		       "vmci_interrupt(): irq %d for unknown device.\n", irq);
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
+		if (icr == 0 || icr == 0xffffffff) {
+			return IRQ_NONE;
+		}
+
+		if (icr & VMCI_ICR_DATAGRAM) {
+			tasklet_schedule(&vmci_dg_tasklet);
+			icr &= ~VMCI_ICR_DATAGRAM;
+		}
+		if (icr & VMCI_ICR_NOTIFICATION) {
+			tasklet_schedule(&vmci_bm_tasklet);
+			icr &= ~VMCI_ICR_NOTIFICATION;
+		}
+		if (icr != 0) {
+			printk(KERN_INFO LGPFX
+			       "Ignoring unknown interrupt cause (%d).\n", icr);
+		}
+	}
+
+	return IRQ_HANDLED;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * vmci_interrupt_bm --
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
+static irqreturn_t vmci_interrupt_bm(int irq,	// IN
+				     void *clientdata)	// IN
+{
+	struct vmci_device *dev = clientdata;
+
+	if (dev == NULL) {
+		printk(KERN_DEBUG
+		       "vmci_interrupt_bm(): irq %d for unknown device.\n",
+		       irq);
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
+ * vmci_probe_device --
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
+static int __devinit vmci_probe_device(struct pci_dev *pdev,	// IN: vmci PCI device
+				       const struct pci_device_id *id)	// IN: matching device ID
+{
+	unsigned int ioaddr;
+	unsigned int ioaddr_size;
+	unsigned int capabilities;
+	int result;
+
+	printk(KERN_INFO "Probing for vmci/PCI.\n");
+
+	result = pci_enable_device(pdev);
+	if (result) {
+		printk(KERN_ERR "Cannot VMCI device %s: error %d\n",
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
+	if (!request_region(ioaddr, ioaddr_size, "vmci")) {
+		printk(KERN_INFO "vmci: Another driver already loaded "
+		       "for device in slot %s.\n", pci_name(pdev));
+		goto pci_disable;
+	}
+
+	printk(KERN_INFO "Found vmci/PCI at %#x, irq %u.\n", ioaddr, pdev->irq);
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
+		printk(KERN_ERR "VMCI device does not support datagrams.\n");
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
+			printk(KERN_ERR
+			       "VMCI device unable to allocate notification bitmap.\n");
+		} else {
+			memset(notification_bitmap, 0, PAGE_SIZE);
+			capabilities |= VMCI_CAPS_NOTIFICATIONS;
+		}
+	} else {
+		capabilities = VMCI_CAPS_DATAGRAM;
+	}
+	printk(KERN_INFO "VMCI: using capabilities 0x%x.\n", capabilities);
+
+	/* Let the host know which capabilities we intend to use. */
+	outl(capabilities, ioaddr + VMCI_CAPS_ADDR);
+
+	/* Device struct initialization. */
+	mutex_lock(&vmci_dev.lock);
+	if (vmci_dev.enabled) {
+		printk(KERN_ERR "VMCI device already enabled.\n");
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
+		if (!VMCI_RegisterNotificationBitmap(bitmapPPN)) {
+			printk(KERN_ERR
+			       "VMCI device unable to register notification bitmap "
+			       "with PPN 0x%x.\n", (uint32_t) bitmapPPN);
+			goto datagram_disallow;
+		}
+	}
+
+	/* Check host capabilities. */
+	if (!VMCI_CheckHostCapabilities()) {
+		goto remove_bitmap;
+	}
+
+	/* Enable device. */
+	vmci_dev.enabled = true;
+	pci_set_drvdata(pdev, &vmci_dev);
+
+	/*
+	 * We do global initialization here because we need datagrams
+	 * during VMCIUtil_Init, since it registers for VMCI events. If we
+	 * ever support more than one VMCI device we will have to create
+	 * seperate LateInit/EarlyExit functions that can be used to do
+	 * initialization/cleanup that depends on the device being
+	 * accessible.  We need to initialize VMCI components before
+	 * requesting an irq - the VMCI interrupt handler uses these
+	 * components, and it may be invoked once request_irq() has
+	 * registered the handler (as the irq line may be shared).
+	 */
+	VMCIUtil_Init();
+
+	if (VMCIQPGuestEndpoints_Init() < VMCI_SUCCESS) {
+		goto util_exit;
+	}
+
+	/*
+	 * Enable interrupts.  Try MSI-X first, then MSI, and then fallback on
+	 * legacy interrupts.
+	 */
+	if (!vmci_disable_msix && !vmci_enable_msix(pdev)) {
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
+	result = request_irq(vmci_dev.irq, vmci_interrupt, IRQF_SHARED,
+			     "vmci", &vmci_dev);
+	if (result) {
+		printk(KERN_ERR "vmci: irq %u in use: %d\n", vmci_dev.irq,
+		       result);
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
+				     vmci_interrupt_bm, 0, "vmci", &vmci_dev);
+		if (result) {
+			printk(KERN_ERR "vmci: irq %u in use: %d\n",
+			       vmci_dev.msix_entries[1].vector, result);
+			free_irq(vmci_dev.irq, &vmci_dev);
+			goto components_exit;
+		}
+	}
+
+	printk(KERN_INFO "Registered vmci device.\n");
+
+	atomic_inc(&guestDeviceActive);
+
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
+ components_exit:
+	VMCIQPGuestEndpoints_Exit();
+ util_exit:
+	VMCIUtil_Exit();
+	vmci_dev.enabled = false;
+	if (vmci_dev.intr_type == VMCI_INTR_TYPE_MSIX) {
+		pci_disable_msix(pdev);
+	} else if (vmci_dev.intr_type == VMCI_INTR_TYPE_MSI) {
+		pci_disable_msi(pdev);
+	}
+ remove_bitmap:
+	if (notification_bitmap) {
+		outl(VMCI_CONTROL_RESET, vmci_dev.ioaddr + VMCI_CONTROL_ADDR);
+	}
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
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * vmci_remove_device --
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
+static void __devexit vmci_remove_device(struct pci_dev *pdev)
+{
+	struct vmci_device *dev = pci_get_drvdata(pdev);
+
+	printk(KERN_INFO "Removing vmci device\n");
+
+	atomic_dec(&guestDeviceActive);
+
+	VMCIQPGuestEndpoints_Exit();
+	VMCIUtil_Exit();
+
+	mutex_lock(&dev->lock);
+
+	atomic_set(&vmci_dev.datagrams_allowed, 0);
+
+	printk(KERN_INFO "Resetting vmci device\n");
+	outl(VMCI_CONTROL_RESET, vmci_dev.ioaddr + VMCI_CONTROL_ADDR);
+
+	/*
+	 * Free IRQ and then disable MSI/MSI-X as appropriate.  For MSI-X, we might
+	 * have multiple vectors, each with their own IRQ, which we must free too.
+	 */
+
+	free_irq(dev->irq, dev);
+	if (dev->intr_type == VMCI_INTR_TYPE_MSIX) {
+		if (dev->exclusive_vectors) {
+			free_irq(dev->msix_entries[1].vector, dev);
+		}
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
+	printk(KERN_INFO "Unregistered vmci device.\n");
+	mutex_unlock(&dev->lock);
+
+	pci_disable_device(pdev);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCI_DeviceEnabled --
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
+bool VMCI_DeviceEnabled(void)
+{
+	return VMCI_GuestPersonalityActive()
+	    || VMCI_HostPersonalityActive();
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCI_SendDatagram --
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
+int VMCI_SendDatagram(struct vmci_datagram *dg)
+{
+	unsigned long flags;
+	int result;
+
+	/* Check args. */
+	if (dg == NULL) {
+		return VMCI_ERROR_INVALID_ARGS;
+	}
+
+	if (atomic_read(&vmci_dev.datagrams_allowed) == 0) {
+		return VMCI_ERROR_UNAVAILABLE;
+	}
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
+			     "c"(VMCI_DG_SIZE(dg)), "S"(dg)
+	    );
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
+ *----------------------------------------------------------------------
+ *
+ * Shared functions --
+ *
+ *      Functions shared between host and guest personality.
+ *
+ *----------------------------------------------------------------------
+ */
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCI_GuestPersonalityActive --
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
+bool VMCI_GuestPersonalityActive(void)
+{
+	return guestDeviceInit && atomic_read(&guestDeviceActive) > 0;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCI_HostPersonalityActive --
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
+bool VMCI_HostPersonalityActive(void)
+{
+	return hostDeviceInit &&
+	    (!VMCI_GuestPersonalityActive() ||
+	     atomic_read(&linuxState.activeContexts) > 0);
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * Module definitions --
+ *
+ *      Implements support for module load/unload.
+ *
+ *----------------------------------------------------------------------
+ */
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * vmci_init --
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
+static int __init vmci_init(void)
+{
+	int retval;
+
+	retval = VMCI_SharedInit();
+	if (retval != VMCI_SUCCESS) {
+		Warning(LGPFX
+			"Failed to initialize VMCI common components (err=%d).\n",
+			retval);
+		return -ENOMEM;
+	}
+
+	if (vmci_disable_guest) {
+		guestDeviceInit = 0;
+	} else {
+		retval = vmci_guest_init();
+		if (retval != 0) {
+			Warning(LGPFX
+				"VMCI PCI device not initialized (err=%d).\n",
+				retval);
+		}
+		guestDeviceInit = (retval == 0);
+		if (VMCI_GuestPersonalityActive()) {
+			printk(KERN_INFO LGPFX "Using guest personality\n");
+		}
+	}
+
+	if (vmci_disable_host) {
+		hostDeviceInit = 0;
+	} else {
+		retval = vmci_host_init();
+		if (retval != 0) {
+			Warning(LGPFX
+				"Unable to initialize host personality (err=%d).\n",
+				retval);
+		}
+		hostDeviceInit = (retval == 0);
+		if (hostDeviceInit) {
+			printk(KERN_INFO LGPFX "Using host personality\n");
+		}
+	}
+
+	if (!guestDeviceInit && !hostDeviceInit) {
+		VMCI_SharedCleanup();
+		return -ENODEV;
+	}
+
+	printk(KERN_INFO LGPFX "Module (name=%s) is initialized\n",
+	       linuxState.deviceName);
+
+	return 0;
+}
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * vmci_exit --
+ *
+ *      Called by /sbin/rmmod
+ *
+ *
+ *----------------------------------------------------------------------
+ */
+
+static void __exit vmci_exit(void)
+{
+	int retval;
+
+	if (guestDeviceInit) {
+		pci_unregister_driver(&vmci_driver);
+		vfree(data_buffer);
+		guestDeviceInit = false;
+	}
+
+	if (hostDeviceInit) {
+		VMCI_HostCleanup();
+
+		retval = misc_deregister(&linuxState.misc);
+		if (retval) {
+			Warning(LGPFX "Module %s: error unregistering\n",
+				linuxState.deviceName);
+		} else {
+			printk(KERN_INFO LGPFX "Module %s: unloaded\n",
+			       linuxState.deviceName);
+		}
+
+		hostDeviceInit = false;
+	}
+
+	VMCI_SharedCleanup();
+}
+
+module_init(vmci_init);
+module_exit(vmci_exit);
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
+MODULE_DESCRIPTION("VMware Virtual Machine Communication Interface (VMCI).");
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
diff --git a/drivers/misc/vmw_vmci/vmciKernelIf.c b/drivers/misc/vmw_vmci/vmciKernelIf.c
new file mode 100644
index 0000000..7001149
--- /dev/null
+++ b/drivers/misc/vmw_vmci/vmciKernelIf.c
@@ -0,0 +1,1351 @@
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
+#include <linux/mm.h>		/* For vmalloc_to_page() and get_user_pages() */
+#include <linux/pagemap.h>	/* For page_cache_release() */
+#include <linux/sched.h>
+#include <linux/semaphore.h>
+#include <linux/socket.h>	/* For memcpy_{to,from}iovec(). */
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/version.h>
+#include <linux/vmalloc.h>
+#include <linux/wait.h>
+#include <linux/workqueue.h>
+
+#include "vmci_iocontrols.h"
+#include "vmci_kernel_if.h"
+#include "vmciQueue.h"
+#include "vmciQueuePair.h"
+
+/* The Kernel specific component of the struct vmci_queue structure. */
+struct vmci_queue_kern_if {
+	struct page **page;
+	struct page **headerPage;
+	struct semaphore __mutex;
+	struct semaphore *mutex;
+	bool host;
+	size_t numPages;
+};
+
+struct vmci_dlyd_wrk_info {
+	struct work_struct work;
+	VMCIWorkFn *workFn;
+	void *data;
+};
+
+/*
+ *----------------------------------------------------------------------
+ *
+ * VMCIHost_WaitForCallLocked --
+ *
+ *      Wait until a VMCI call is pending or the waiting thread is
+ *      interrupted. It is assumed that a lock is held prior to
+ *      calling this function. The lock will be released during the
+ *      wait. The correctnes of this funtion depends on that the same
+ *      lock is held when the call is signalled.
+ *
+ * Results:
+ *      true on success
+ *      false if the wait was interrupted.
+ *
+ * Side effects:
+ *      The call may block.
+ *
+ *----------------------------------------------------------------------
+ */
+
+bool VMCIHost_WaitForCallLocked(struct vmci_host *hostContext,	// IN
+				spinlock_t * lock,	// IN
+				unsigned long *flags,	// IN
+				bool useBH)	// IN
+{
+	DECLARE_WAITQUEUE(wait, current);
+
+	/*
+	 * The thread must be added to the wait queue and have its state
+	 * changed while holding the lock - otherwise a signal may change
+	 * the state in between and have it overwritten causing a loss of
+	 * the event.
+	 */
+
+	add_wait_queue(&hostContext->waitQueue, &wait);
+	current->state = TASK_INTERRUPTIBLE;
+
+	if (useBH) {
+		spin_unlock_bh(lock);
+	} else {
+		spin_unlock(lock);
+	}
+
+	schedule();
+
+	if (useBH) {
+		spin_lock_bh(lock);
+	} else {
+		spin_lock(lock);
+	}
+
+	current->state = TASK_RUNNING;
+
+	remove_wait_queue(&hostContext->waitQueue, &wait);
+
+	if (signal_pending(current))
+		return false;
+
+	return true;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIHost_CompareUser --
+ *
+ *      Determines whether the two users are the same.
+ *
+ * Results:
+ *      VMCI_SUCCESS if equal, error code otherwise.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+int VMCIHost_CompareUser(uid_t * user1, uid_t * user2)
+{
+	if (!user1 || !user2)
+		return VMCI_ERROR_INVALID_ARGS;
+
+	if (*user1 == *user2)
+		return VMCI_SUCCESS;
+
+	return VMCI_ERROR_GENERIC;
+}
+
+/*
+ *----------------------------------------------------------------------------
+ *
+ * VMCIDelayedWorkCB
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
+static void VMCIDelayedWorkCB(struct work_struct *work)	// IN
+{
+	struct vmci_dlyd_wrk_info *delayedWorkInfo;
+
+	delayedWorkInfo = container_of(work, struct vmci_dlyd_wrk_info, work);
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
+ * VMCI_ScheduleDelayedWork --
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
+int VMCI_ScheduleDelayedWork(VMCIWorkFn * workFn,	// IN
+			     void *data)	// IN
+{
+	struct vmci_dlyd_wrk_info *delayedWorkInfo;
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
+	INIT_WORK(&delayedWorkInfo->work, VMCIDelayedWorkCB);
+
+	schedule_work(&delayedWorkInfo->work);
+
+	return VMCI_SUCCESS;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCI_WaitOnEvent --
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
+void VMCI_WaitOnEvent(wait_queue_head_t * event,	// IN:
+		      VMCIEventReleaseCB releaseCB,	// IN:
+		      void *clientData)	// IN:
+{
+	/*
+	 * XXX Should this be a TASK_UNINTERRUPTIBLE wait? I'm leaving it
+	 * as it was for now.
+	 */
+	VMCI_WaitOnEventInterruptible(event, releaseCB, clientData);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCI_WaitOnEventInterruptible --
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
+bool VMCI_WaitOnEventInterruptible(wait_queue_head_t * event,	// IN:
+				   VMCIEventReleaseCB releaseCB,	// IN:
+				   void *clientData)	// IN:
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
+ *-----------------------------------------------------------------------------
+ *
+ * VMCI_AllocQueue --
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
+void *VMCI_AllocQueue(uint64_t size)	// IN: size of queue (not including header)
+{
+	uint64_t i;
+	struct vmci_queue *queue;
+	struct vmci_queue_header *qHeader;
+	const uint64_t numDataPages = CEILING(size, PAGE_SIZE);
+	const uint queueSize =
+	    PAGE_SIZE +
+	    sizeof *queue + sizeof *(queue->kernelIf) +
+	    numDataPages * sizeof *(queue->kernelIf->page);
+
+	/*
+	 * Size should be enforced by VMCIQPair_Alloc(), double-check here.
+	 * Allocating too much on Linux can cause the system to become
+	 * unresponsive, because we allocate page-by-page, and we allow the
+	 * system to wait for pages rather than fail.
+	 */
+	if (size > VMCI_MAX_GUEST_QP_MEMORY) {
+		ASSERT(false);
+		return NULL;
+	}
+
+	qHeader = (struct vmci_queue_header *)vmalloc(queueSize);
+	if (!qHeader)
+		return NULL;
+
+	queue = (struct vmci_queue *)((uint8_t *) qHeader + PAGE_SIZE);
+	queue->qHeader = qHeader;
+	queue->savedHeader = NULL;
+	queue->kernelIf =
+	    (struct vmci_queue_kern_if *)((uint8_t *) queue + sizeof *queue);
+	queue->kernelIf->headerPage = NULL;	// Unused in guest.
+	queue->kernelIf->page =
+	    (struct page **)((uint8_t *) queue->kernelIf +
+			     sizeof *(queue->kernelIf));
+	queue->kernelIf->host = false;
+
+	for (i = 0; i < numDataPages; i++) {
+		queue->kernelIf->page[i] = alloc_pages(GFP_KERNEL, 0);
+		if (!queue->kernelIf->page[i]) {
+			while (i) {
+				__free_page(queue->kernelIf->page[--i]);
+			}
+			vfree(qHeader);
+			return NULL;
+		}
+	}
+
+	return (void *)queue;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCI_FreeQueue --
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
+void VMCI_FreeQueue(void *q,	// IN:
+		    uint64_t size)	// IN: size of queue (not including header)
+{
+	struct vmci_queue *queue = q;
+
+	if (queue) {
+		uint64_t i;
+		for (i = 0; i < CEILING(size, PAGE_SIZE); i++) {
+			__free_page(queue->kernelIf->page[i]);
+		}
+		vfree(queue->qHeader);
+	}
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCI_AllocPPNSet --
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
+int VMCI_AllocPPNSet(void *prodQ,	// IN:
+		     uint64_t numProducePages,	// IN: for queue plus header
+		     void *consQ,	// IN:
+		     uint64_t numConsumePages,	// IN: for queue plus header
+		     struct PPNSet *ppnSet)	// OUT:
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
+	    kmalloc(numProducePages * sizeof *producePPNs, GFP_KERNEL);
+	if (!producePPNs)
+		return VMCI_ERROR_NO_MEM;
+
+	consumePPNs =
+	    kmalloc(numConsumePages * sizeof *consumePPNs, GFP_KERNEL);
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
+		    page_to_pfn(produceQ->kernelIf->page[i - 1]);
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
+		    page_to_pfn(consumeQ->kernelIf->page[i - 1]);
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
+ ppnError:
+	kfree(producePPNs);
+	kfree(consumePPNs);
+	return VMCI_ERROR_INVALID_ARGS;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCI_FreePPNSet --
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
+void VMCI_FreePPNSet(struct PPNSet *ppnSet)	// IN:
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
+ * VMCI_PopulatePPNList --
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
+int VMCI_PopulatePPNList(uint8_t * callBuf,	// OUT:
+			 const struct PPNSet *ppnSet)	// IN:
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
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * __VMCIMemcpyToQueue --
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
+int __VMCIMemcpyToQueue(struct vmci_queue *queue,	// OUT:
+			uint64_t queueOffset,	// IN:
+			const void *src,	// IN:
+			size_t size,	// IN:
+			bool isIovec)	// IN: if src is a struct iovec *
+{
+	struct vmci_queue_kern_if *kernelIf = queue->kernelIf;
+	size_t bytesCopied = 0;
+
+	while (bytesCopied < size) {
+		uint64_t pageIndex = (queueOffset + bytesCopied) / PAGE_SIZE;
+		size_t pageOffset =
+		    (queueOffset + bytesCopied) & (PAGE_SIZE - 1);
+		void *va = kmap(kernelIf->page[pageIndex]);
+		size_t toCopy;
+
+		ASSERT(va);
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
+			err =
+			    memcpy_fromiovec((uint8_t *) va + pageOffset,
+					     iov, toCopy);
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
+		kunmap(kernelIf->page[pageIndex]);
+	}
+
+	return VMCI_SUCCESS;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * __VMCIMemcpyFromQueue --
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
+int __VMCIMemcpyFromQueue(void *dest,	// OUT:
+			  const struct vmci_queue *queue,	// IN:
+			  uint64_t queueOffset,	// IN:
+			  size_t size,	// IN:
+			  bool isIovec)	// IN: if dest is a struct iovec *
+{
+	struct vmci_queue_kern_if *kernelIf = queue->kernelIf;
+	size_t bytesCopied = 0;
+
+	while (bytesCopied < size) {
+		uint64_t pageIndex = (queueOffset + bytesCopied) / PAGE_SIZE;
+		size_t pageOffset =
+		    (queueOffset + bytesCopied) & (PAGE_SIZE - 1);
+		void *va = kmap(kernelIf->page[pageIndex]);
+		size_t toCopy;
+
+		ASSERT(va);
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
+			err =
+			    memcpy_toiovec(iov,
+					   (uint8_t *) va + pageOffset, toCopy);
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
+		kunmap(kernelIf->page[pageIndex]);
+	}
+
+	return VMCI_SUCCESS;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIMemcpyToQueue --
+ *
+ *      Copies from a given buffer to a VMCI Queue.
+ *
+ * Results:
+ *      Zero on success, negative error code on failure.
+ *
+ * Side effects:
+ *      None.
+ *
+ * XXX: REMOVE
+ *-----------------------------------------------------------------------------
+ */
+
+int VMCIMemcpyToQueue(struct vmci_queue *queue,	// OUT:
+		      uint64_t queueOffset,	// IN:
+		      const void *src,	// IN:
+		      size_t srcOffset,	// IN:
+		      size_t size,	// IN:
+		      int bufType)	// IN: Unused
+{
+	return __VMCIMemcpyToQueue(queue, queueOffset,
+				   (uint8_t *) src + srcOffset, size, false);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIMemcpyFromQueue --
+ *
+ *      Copies to a given buffer from a VMCI Queue.
+ *
+ * Results:
+ *      Zero on success, negative error code on failure.
+ *
+ * Side effects:
+ *      None.
+ *
+ * XXX: REMOVE
+ *-----------------------------------------------------------------------------
+ */
+
+int VMCIMemcpyFromQueue(void *dest,	// OUT:
+			size_t destOffset,	// IN:
+			const struct vmci_queue *queue,	// IN:
+			uint64_t queueOffset,	// IN:
+			size_t size,	// IN:
+			int bufType)	// IN: Unused
+{
+	return __VMCIMemcpyFromQueue((uint8_t *) dest + destOffset,
+				     queue, queueOffset, size, false);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIMemcpyToQueueLocal --
+ *
+ *      Copies from a given buffer to a local VMCI queue. On Linux, this is the
+ *      same as a regular copy.
+ *
+ * Results:
+ *      Zero on success, negative error code on failure.
+ *
+ * Side effects:
+ *      None.
+ *
+ * XXX: REMOVE
+ *-----------------------------------------------------------------------------
+ */
+
+int VMCIMemcpyToQueueLocal(struct vmci_queue *queue,	// OUT
+			   uint64_t queueOffset,	// IN
+			   const void *src,	// IN
+			   size_t srcOffset,	// IN
+			   size_t size,	// IN
+			   int bufType)	// IN
+{
+	return __VMCIMemcpyToQueue(queue, queueOffset,
+				   (uint8_t *) src + srcOffset, size, false);;
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIMemcpyFromQueueLocal --
+ *
+ *      Copies to a given buffer from a VMCI Queue.
+ *
+ * Results:
+ *      Zero on success, negative error code on failure.
+ *
+ * Side effects:
+ *      None.
+ *
+ * XXX: REMOVE
+ *-----------------------------------------------------------------------------
+ */
+
+int VMCIMemcpyFromQueueLocal(void *dest,	// OUT:
+			     size_t destOffset,	// IN:
+			     const struct vmci_queue *queue,	// IN:
+			     uint64_t queueOffset,	// IN:
+			     size_t size,	// IN:
+			     int bufType)	// IN: Unused
+{
+	return __VMCIMemcpyFromQueue((uint8_t *) dest + destOffset,
+				     queue, queueOffset, size, false);
+}
+
+/*
+ *----------------------------------------------------------------------------
+ *
+ * VMCIMemcpyToQueueV --
+ *
+ *      Copies from a given iovec from a VMCI Queue.
+ *
+ * Results:
+ *      Zero on success, negative error code on failure.
+ *
+ * Side effects:
+ *      None.
+ *
+ * XXX: REMOVE
+ *----------------------------------------------------------------------------
+ */
+
+int VMCIMemcpyToQueueV(struct vmci_queue *queue,	// OUT:
+		       uint64_t queueOffset,	// IN:
+		       const void *src,	// IN: iovec
+		       size_t srcOffset,	// IN: ignored
+		       size_t size,	// IN:
+		       int bufType)	// IN: ignored
+{
+
+	/*
+	 * We ignore srcOffset because src is really a struct iovec * and will
+	 * maintain offset internally.
+	 */
+	return __VMCIMemcpyToQueue(queue, queueOffset, src, size, true);
+}
+
+/*
+ *----------------------------------------------------------------------------
+ *
+ * VMCIMemcpyFromQueueV --
+ *
+ *      Copies to a given iovec from a VMCI Queue.
+ *
+ * Results:
+ *      Zero on success, negative error code on failure.
+ *
+ * Side effects:
+ *      None.
+ *
+ * XXX: REMOVE
+ *----------------------------------------------------------------------------
+ */
+
+int VMCIMemcpyFromQueueV(void *dest,	// OUT: iovec
+			 size_t destOffset,	// IN: ignored
+			 const struct vmci_queue *queue,	// IN:
+			 uint64_t queueOffset,	// IN:
+			 size_t size,	// IN:
+			 int bufType)	// IN: ignored
+{
+	/*
+	 * We ignore destOffset because dest is really a struct iovec * and will
+	 * maintain offset internally.
+	 */
+	return __VMCIMemcpyFromQueue(dest, queue, queueOffset, size, true);
+}
+
+/*
+ *-----------------------------------------------------------------------------
+ *
+ * VMCIWellKnownID_AllowMap --
+ *
+ *      Checks whether the calling context is allowed to register for the given
+ *      well known service ID.  Currently returns false if the service ID is
+ *      within the reserved range and VMCI_PRIVILEGE_FLAG_TRUSTED is not
+ *      provided as the input privilege flags.  Otherwise returns true.
+ *      XXX TODO access control based on host configuration information; this
+ *      will be platform specific implementation.
+ *
+ * Results:
+ *      Boolean value indicating access granted or denied.
+ *
+ * Side effects:
+ *      None.
+ *
+ *-----------------------------------------------------------------------------
+ */
+
+bool VMCIWellKnownID_AllowMap(uint32_t wellKnownID,	// IN:
+			      uint32_t privFlags)	// IN:
+{
+	return (!(wellKnownID < VMCI_RESERVED_RESOURCE_ID_MAX &&
+		  !(privFlags & VMCI_PRIVILEGE_FLAG_TRUSTED)));
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
+	const size_t numPages = CEILING(size, PAGE_SIZE) + 1;
+	const size_t queueSize = sizeof *queue + sizeof *(queue->kernelIf);
+	const size_t queuePageSize = numPages * sizeof *queue->kernelIf->page;
+
+	queue = kmalloc(queueSize + queuePageSize, GFP_KERNEL);
+	if (queue) {
+		queue->qHeader = NULL;
+		queue->savedHeader = NULL;
+		queue->kernelIf =
+		    (struct vmci_queue_kern_if *)((uint8_t *) queue +
+						  sizeof *queue);
+		queue->kernelIf->host = true;
+		queue->kernelIf->mutex = NULL;
+		queue->kernelIf->numPages = numPages;
+		queue->kernelIf->headerPage =
+		    (struct page **)((uint8_t *) queue + queueSize);
+		queue->kernelIf->page = &queue->kernelIf->headerPage[1];
+		memset(queue->kernelIf->headerPage, 0,
+		       sizeof *queue->kernelIf->headerPage *
+		       queue->kernelIf->numPages);
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
+	    pageStore->pages + produceQ->kernelIf->numPages * PAGE_SIZE;
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
+ * VMCIHost_MapQueueHeaders --
+ *
+ *       Once VMCIHost_RegisterUserMemory has been performed on a
+ *       queue, the queue pair headers can be mapped into the
+ *       kernel. Once mapped, they must be unmapped with
+ *       VMCIHost_UnmapQueueHeaders prior to calling
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
+int VMCIHost_MapQueueHeaders(struct vmci_queue *produceQ,	// IN/OUT
+			     struct vmci_queue *consumeQ)	// IN/OUT
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
+			    (struct vmci_queue_header *)((uint8_t *)
+							 produceQ->qHeader +
+							 PAGE_SIZE);
+			result = VMCI_SUCCESS;
+		} else {
+			Log("vmap failed\n");
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
+ * VMCIHost_UnmapQueueHeaders --
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
+int VMCIHost_UnmapQueueHeaders(uint32_t gid,	// IN
+			       struct vmci_queue *produceQ,	// IN/OUT
+			       struct vmci_queue *consumeQ)	// IN/OUT
+{
+	if (produceQ->qHeader) {
+		ASSERT(consumeQ->qHeader);
+
+		if (produceQ->qHeader < consumeQ->qHeader) {
+			vunmap(produceQ->qHeader);
+		} else {
+			vunmap(consumeQ->qHeader);
+		}
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
+		Log("get_user_pages(produce) failed (retval=%d)\n", retval);
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
+		Log("get_user_pages(consume) failed (retval=%d)\n", retval);
+		VMCIReleasePages(consumeQ->kernelIf->headerPage, retval, false);
+		VMCIReleasePages(produceQ->kernelIf->headerPage,
+				 produceQ->kernelIf->numPages, false);
+		err = VMCI_ERROR_NO_MEM;
+	}
+
+ out:
+	up_write(&current->mm->mmap_sem);
+
+	return err;
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
-- 
1.7.0.4

