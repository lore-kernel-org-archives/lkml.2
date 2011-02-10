Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab1BJJzb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 04:55:31 -0500
Received: from mga01.intel.com ([192.55.52.88]:42719 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756028Ab1BJJz1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 04:55:27 -0500
Message-Id: <b7da2f$qd3ngv@fmsmga001.fm.intel.com>
Date: 10 Feb 2011 01:55:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,451,1291622400"; 
   d="scan'";a="886169133"
From: Oren Weil <oren.jer.weil@intel.com>
To: gregkh@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: david@woodhou.se, david.woodhouse@intel.com
Subject: [RFC PATCH 10/13] Intel(R) MEI Driver
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/drivers/char/mei/main.c b/drivers/char/mei/main.c
new file mode 100644
index 0000000..82ac436
--- /dev/null
+++ b/drivers/char/mei/main.c
@@ -0,0 +1,1466 @@
+/*
+ *
+ * Intel(R) Management Engine Interface (Intel(R) MEI) Linux driver
+ * Copyright (c) 2003-2011, Intel Corporation.
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
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
+ *
+ */
+
+
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/fs.h>
+#include <linux/errno.h>
+#include <linux/types.h>
+#include <linux/fcntl.h>
+#include <linux/aio.h>
+#include <linux/pci.h>
+#include <linux/poll.h>
+#include <linux/init.h>
+#include <linux/ioctl.h>
+#include <linux/cdev.h>
+#include <linux/version.h>
+#include <linux/sched.h>
+
+#include "mei.h"
+#include "interface.h"
+#include "mei_version.h"
+
+
+#define MEI_READ_TIMEOUT 45
+#define MEI_DRIVER_NAME	"mei"
+#define MEI_DEV_NAME "mei"
+
+/*
+ *  mei driver strings
+ */
+static char mei_driver_name[] = MEI_DRIVER_NAME;
+static const char mei_driver_string[] = "Intel(R) Management Engine Interface";
+static const char mei_driver_version[] = MEI_DRIVER_VERSION;
+
+#ifdef MEI_DEBUG
+int mei_debug = 1;
+#else
+int mei_debug;
+#endif
+MODULE_PARM_DESC(mei_debug,  "Debug enabled or not");
+module_param(mei_debug, int, 0644);
+
+
+
+/* mei char device for registration */
+static struct cdev mei_cdev;
+
+/* major number for device */
+static int mei_major;
+/* The device pointer */
+/* Currently this driver works as long as there is only a single AMT device. */
+static struct pci_dev *mei_device;
+
+static struct class *mei_class;
+
+
+/* mei_pci_tbl - PCI Device ID Table */
+static DEFINE_PCI_DEVICE_TABLE(mei_pci_tbl) = {
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_82946GZ)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_82G35)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_82Q965)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_82G965)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_82GM965)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_82GME965)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9_82Q35)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9_82G33)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9_82Q33)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9_82X38)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9_3200)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9_6)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9_7)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9_8)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9_9)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9_10)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9M_1)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9M_2)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9M_3)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH9M_4)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH10_1)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH10_2)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH10_3)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_ICH10_4)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_IBXPK_1)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_IBXPK_2)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_CPT_1)},
+	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MEI_DEV_ID_PBG_1)},
+	/* required last entry */
+	{0, }
+};
+
+MODULE_DEVICE_TABLE(pci, mei_pci_tbl);
+
+#ifdef CONFIG_PM
+static u16 g_sus_wd_timeout;
+#endif
+
+static DEFINE_MUTEX(mei_mutex);
+
+/**
+ * mei_probe - Device Initialization Routine
+ *
+ * @pdev: PCI device structure
+ * @ent: entry in kcs_pci_tbl
+ *
+ * returns 0 on success, <0 on failure.
+ */
+static int __devinit mei_probe(struct pci_dev *pdev,
+				const struct pci_device_id *ent)
+{
+	struct iamt_mei_device *dev;
+	int i, err;
+
+	mutex_lock(&mei_mutex);
+	if (mei_device) {
+		err = -EEXIST;
+		goto end;
+	}
+	/* enable pci dev */
+	err = pci_enable_device(pdev);
+	if (err) {
+		printk(KERN_ERR "mei: Failed to enable pci device.\n");
+		goto end;
+	}
+	/* set PCI host mastering  */
+	pci_set_master(pdev);
+	/* pci request regions for mei driver */
+	err = pci_request_regions(pdev, mei_driver_name);
+	if (err) {
+		printk(KERN_ERR "mei: Failed to get pci regions.\n");
+		goto disable_device;
+	}
+	/* allocates and initializes the mei dev structure */
+	dev = init_mei_device(pdev);
+	if (!dev) {
+		err = -ENOMEM;
+		goto release_regions;
+	}
+	/* mapping  IO device memory */
+	for (i = 0; i <= 5; i++) {
+		if (pci_resource_len(pdev, i) == 0)
+			continue;
+		if (pci_resource_flags(pdev, i) & IORESOURCE_IO) {
+			printk(KERN_ERR "mei: mei has IO ports.\n");
+			goto free_device;
+		} else if (pci_resource_flags(pdev, i) & IORESOURCE_MEM) {
+			if (dev->mem_base) {
+				printk(KERN_ERR
+					"mei: Too many mem addresses.\n");
+				goto free_device;
+			}
+			dev->mem_base = pci_resource_start(pdev, i);
+			dev->mem_length = pci_resource_len(pdev, i);
+		}
+	}
+	if (!dev->mem_base) {
+		printk(KERN_ERR "mei: No address to use.\n");
+		err = -ENODEV;
+		goto free_device;
+	}
+	dev->mem_addr = ioremap_nocache(dev->mem_base, dev->mem_length);
+	if (!dev->mem_addr) {
+		printk(KERN_ERR "mei: Remap IO device memory failure.\n");
+		err = -ENOMEM;
+		goto free_device;
+	}
+	/* request and enable interrupt   */
+	err = request_threaded_irq(pdev->irq,
+			mei_interrupt_quick_handler,
+			mei_interrupt_thread_handler,
+			IRQF_SHARED, mei_driver_name, dev);
+	if (err) {
+		printk(KERN_ERR "mei: request_threaded_irq failure. irq = %d\n",
+		       pdev->irq);
+		goto unmap_memory;
+	}
+	INIT_DELAYED_WORK(&dev->wd_work, mei_wd_timer);
+	if (mei_hw_init(dev)) {
+		printk(KERN_ERR "mei: Init hw failure.\n");
+		err = -ENODEV;
+		goto release_irq;
+	}
+	mei_device = pdev;
+	pci_set_drvdata(pdev, dev);
+	schedule_delayed_work(&dev->wd_work, HZ);
+
+#ifdef CONFIG_PM
+	g_sus_wd_timeout = 0;
+#endif
+	mutex_unlock(&mei_mutex);
+	printk(KERN_INFO "mei: driver initialization successful.\n");
+	return 0;
+
+release_irq:
+	/* disable interrupts */
+	dev->host_hw_state = get_host_hw_state(dev);
+	mei_csr_disable_interrupts(dev);
+	flush_scheduled_work();
+	free_irq(pdev->irq, dev);
+unmap_memory:
+	if (dev->mem_addr)
+		iounmap(dev->mem_addr);
+free_device:
+	kfree(dev);
+release_regions:
+	pci_release_regions(pdev);
+disable_device:
+	pci_disable_device(pdev);
+end:
+	mutex_unlock(&mei_mutex);
+	printk(KERN_ERR "mei: driver initialization failed.\n");
+	return err;
+}
+
+/**
+ * mei_remove - Device Removal Routine
+ *
+ * @pdev: PCI device structure
+ *
+ * mei_remove is called by the PCI subsystem to alert the driver
+ * that it should release a PCI device.
+ */
+static void __devexit mei_remove(struct pci_dev *pdev)
+{
+	struct iamt_mei_device *dev;
+
+	if (mei_device != pdev)
+		return;
+
+	dev = pci_get_drvdata(pdev);
+	if (!dev)
+		return;
+
+	mutex_lock(&dev->device_lock);
+	cancel_delayed_work(&dev->wd_work);
+	if (dev->wd_file_ext.state == MEI_FILE_CONNECTED && dev->wd_timeout) {
+		dev->wd_timeout = 0;
+		dev->wd_due_counter = 0;
+		memcpy(dev->wd_data, mei_stop_wd_params, MEI_WD_PARAMS_SIZE);
+		dev->stop = 1;
+		if (dev->host_buffer_is_empty &&
+		    flow_ctrl_creds(dev, &dev->wd_file_ext)) {
+			dev->host_buffer_is_empty = 0;
+
+			if (!mei_send_wd(dev))
+				DBG("send stop WD failed\n");
+			else
+				flow_ctrl_reduce(dev, &dev->wd_file_ext);
+
+			dev->wd_pending = 0;
+		} else {
+			dev->wd_pending = 1;
+		}
+		dev->wd_stopped = 0;
+		mutex_unlock(&dev->device_lock);
+
+		wait_event_interruptible_timeout(dev->wait_stop_wd,
+				(dev->wd_stopped), 10 * HZ);
+		mutex_lock(&dev->device_lock);
+		if (!dev->wd_stopped)
+			DBG("stop wd failed to complete.\n");
+		else
+			DBG("stop wd complete.\n");
+
+	}
+
+	mei_device = NULL;
+
+	if (dev->iamthif_file_ext.state == MEI_FILE_CONNECTED) {
+		dev->iamthif_file_ext.state = MEI_FILE_DISCONNECTING;
+		mei_disconnect_host_client(dev, &dev->iamthif_file_ext);
+	}
+	if (dev->wd_file_ext.state == MEI_FILE_CONNECTED) {
+		dev->wd_file_ext.state = MEI_FILE_DISCONNECTING;
+		mei_disconnect_host_client(dev, &dev->wd_file_ext);
+	}
+
+	/* remove entry if already in list */
+	DBG("list del iamthif and wd file list.\n");
+	mei_remove_client_from_file_list(dev, dev->wd_file_ext.
+					  host_client_id);
+	mei_remove_client_from_file_list(dev,
+			dev->iamthif_file_ext.host_client_id);
+
+	dev->iamthif_current_cb = NULL;
+	dev->iamthif_file_ext.file = NULL;
+	dev->num_mei_me_clients = 0;
+
+	mutex_unlock(&dev->device_lock);
+
+	flush_scheduled_work();
+
+	/* disable interrupts */
+	mei_csr_disable_interrupts(dev);
+
+	free_irq(pdev->irq, dev);
+	pci_set_drvdata(pdev, NULL);
+
+	if (dev->mem_addr)
+		iounmap(dev->mem_addr);
+
+	kfree(dev);
+
+	pci_release_regions(pdev);
+	pci_disable_device(pdev);
+}
+
+/**
+ * mei_clear_list - removes all callbacks associated with file
+ *		from mei_cb_list
+ *
+ * @file: file structure
+ * @mei_cb_list: callbacks list
+ *
+ * mei_clear_list is called to clear resources associated with file
+ * when application calls close function or Ctrl-C was pressed
+ *
+ * returns true if callback removed from the list, false otherwise
+ */
+static bool mei_clear_list(struct iamt_mei_device *dev,
+		struct file *file, struct list_head *mei_cb_list)
+{
+	struct mei_cb_private *priv_cb_pos = NULL;
+	struct mei_cb_private *priv_cb_next = NULL;
+	struct file *file_temp;
+	bool removed = false;
+
+	/* list all list member */
+	list_for_each_entry_safe(priv_cb_pos, priv_cb_next,
+				 mei_cb_list, cb_list) {
+		file_temp = (struct file *)priv_cb_pos->file_object;
+		/* check if list member associated with a file */
+		if (file_temp == file) {
+			/* remove member from the list */
+			list_del(&priv_cb_pos->cb_list);
+			/* check if cb equal to current iamthif cb */
+			if (dev->iamthif_current_cb == priv_cb_pos) {
+				dev->iamthif_current_cb = NULL;
+				/* send flow control to iamthif client */
+				mei_send_flow_control(dev,
+						       &dev->iamthif_file_ext);
+			}
+			/* free all allocated buffers */
+			mei_free_cb_private(priv_cb_pos);
+			priv_cb_pos = NULL;
+			removed = true;
+		}
+	}
+	return removed;
+}
+
+/**
+ * mei_clear_lists - removes all callbacks associated with file
+ *
+ * @dev: device structure
+ * @file: file structure
+ *
+ * mei_clear_lists is called to clear resources associated with file
+ * when application calls close function or Ctrl-C was pressed
+ *
+ * returns true if callback removed from the list, false otherwise
+ */
+static bool mei_clear_lists(struct iamt_mei_device *dev, struct file *file)
+{
+	bool removed = false;
+
+	/* remove callbacks associated with a file */
+	mei_clear_list(dev, file, &dev->pthi_cmd_list.mei_cb.cb_list);
+	if (mei_clear_list(dev, file,
+			    &dev->pthi_read_complete_list.mei_cb.cb_list))
+		removed = true;
+
+	mei_clear_list(dev, file, &dev->ctrl_rd_list.mei_cb.cb_list);
+
+	if (mei_clear_list(dev, file, &dev->ctrl_wr_list.mei_cb.cb_list))
+		removed = true;
+
+	if (mei_clear_list(dev, file,
+			    &dev->write_waiting_list.mei_cb.cb_list))
+		removed = true;
+
+	if (mei_clear_list(dev, file, &dev->write_list.mei_cb.cb_list))
+		removed = true;
+
+	/* check if iamthif_current_cb not NULL */
+	if (dev->iamthif_current_cb && !removed) {
+		/* check file and iamthif current cb association */
+		if (dev->iamthif_current_cb->file_object == file) {
+			/* remove cb */
+			mei_free_cb_private(dev->iamthif_current_cb);
+			dev->iamthif_current_cb = NULL;
+			removed = true;
+		}
+	}
+	return removed;
+}
+/**
+ * find_read_list_entry - find read list entry
+ *
+ * @dev: device structure
+ * @file: pointer to file structure
+ *
+ * returns cb on success, NULL on error
+ */
+static struct mei_cb_private *find_read_list_entry(
+		struct iamt_mei_device *dev,
+		struct mei_file_private *file_ext)
+{
+	struct mei_cb_private *priv_cb_pos = NULL;
+	struct mei_cb_private *priv_cb_next = NULL;
+	struct mei_file_private *file_ext_list_temp;
+
+	if (dev->read_list.status == 0
+	    && !list_empty(&dev->read_list.mei_cb.cb_list)) {
+		DBG("remove read_list CB\n");
+		list_for_each_entry_safe(priv_cb_pos,
+				priv_cb_next,
+				&dev->read_list.mei_cb.cb_list, cb_list) {
+
+			file_ext_list_temp = (struct mei_file_private *)
+				priv_cb_pos->file_private;
+
+			if ((file_ext_list_temp != NULL) &&
+			    mei_fe_same_id(file_ext, file_ext_list_temp))
+				return priv_cb_pos;
+
+		}
+	}
+	return NULL;
+}
+
+/**
+ * mei_open - the open function
+ *
+ * @inode: pointer to inode structure
+ * @file: pointer to file structure
+ *
+ * returns 0 on success, <0 on error
+ */
+static int mei_open(struct inode *inode, struct file *file)
+{
+	struct mei_file_private *file_ext;
+	int if_num = iminor(inode), err;
+	struct iamt_mei_device *dev;
+
+	err = -ENODEV;
+	if (!mei_device)
+		goto out;
+
+	dev = pci_get_drvdata(mei_device);
+	if ((if_num != MEI_MINOR_NUMBER) || !dev)
+		goto out;
+
+	mutex_lock(&dev->device_lock);
+	err = -ENOMEM;
+	file_ext = mei_alloc_file_private(file);
+	if (file_ext == NULL)
+		goto out;
+
+	err = -ENODEV;
+	if (dev->mei_state != MEI_ENABLED) {
+		DBG("mei_state != MEI_ENABLED  mei_state= %d\n",
+		    dev->mei_state);
+		goto out_unlock;
+	}
+	err = -EMFILE;
+	if (dev->open_handle_count >= MEI_MAX_OPEN_HANDLE_COUNT)
+		goto out_unlock;
+
+	dev->open_handle_count++;
+	list_add_tail(&file_ext->link, &dev->file_list);
+	while ((dev->mei_host_clients[dev->current_host_client_id / 8]
+		& (1 << (dev->current_host_client_id % 8))) != 0) {
+
+		dev->current_host_client_id++; /* allow overflow */
+		DBG("current_host_client_id = %d\n",
+		    dev->current_host_client_id);
+		DBG("dev->open_handle_count = %lu\n",
+		    dev->open_handle_count);
+	}
+	DBG("current_host_client_id = %d\n", dev->current_host_client_id);
+	file_ext->host_client_id = dev->current_host_client_id;
+	dev->mei_host_clients[file_ext->host_client_id / 8] |=
+		(1 << (file_ext->host_client_id % 8));
+	file_ext->state = MEI_FILE_INITIALIZING;
+	file_ext->sm_state = 0;
+
+	file->private_data = file_ext;
+	mutex_unlock(&dev->device_lock);
+
+	return 0;
+
+out_unlock:
+	mutex_unlock(&dev->device_lock);
+	kfree(file_ext);
+out:
+	return err;
+}
+
+/**
+ * mei_release - the release function
+ *
+ * @inode: pointer to inode structure
+ * @file: pointer to file structure
+ *
+ * returns 0 on success, <0 on error
+ */
+static int mei_release(struct inode *inode, struct file *file)
+{
+	struct mei_file_private *file_ext = file->private_data;
+	struct mei_cb_private *priv_cb;
+	struct iamt_mei_device *dev;
+	int if_num = iminor(inode);
+	int rets = 0;
+
+	if (!mei_device)
+		return -ENODEV;
+
+	dev = pci_get_drvdata(mei_device);
+	if ((if_num != MEI_MINOR_NUMBER) || !dev || !file_ext)
+		return -ENODEV;
+
+	mutex_lock(&dev->device_lock);
+	if (file_ext != &dev->iamthif_file_ext) {
+		if (file_ext->state == MEI_FILE_CONNECTED) {
+			file_ext->state = MEI_FILE_DISCONNECTING;
+			DBG("disconnecting client host client = %d, "
+			    "ME client = %d\n",
+			    file_ext->host_client_id,
+			    file_ext->me_client_id);
+			rets = mei_disconnect_host_client(dev, file_ext);
+		}
+		mei_flush_queues(dev, file_ext);
+		DBG("remove client host client = %d, ME client = %d\n",
+		    file_ext->host_client_id,
+		    file_ext->me_client_id);
+
+		if (dev->open_handle_count > 0) {
+			dev->mei_host_clients[file_ext->host_client_id / 8] &=
+			~(1 << (file_ext->host_client_id % 8));
+			dev->open_handle_count--;
+		}
+		mei_remove_client_from_file_list(dev,
+						file_ext->host_client_id);
+
+		/* free read cb */
+		priv_cb = NULL;
+		if (file_ext->read_cb != NULL) {
+			priv_cb = find_read_list_entry(dev, file_ext);
+			/* Remove entry from read list */
+			if (priv_cb != NULL)
+				list_del(&priv_cb->cb_list);
+
+			priv_cb = file_ext->read_cb;
+			file_ext->read_cb = NULL;
+		}
+
+		file->private_data = NULL;
+
+		if (priv_cb != NULL) {
+			mei_free_cb_private(priv_cb);
+			priv_cb = NULL;
+		}
+
+		kfree(file_ext);
+	} else {
+		if (dev->open_handle_count > 0)
+			dev->open_handle_count--;
+
+		if (dev->iamthif_file_object == file
+		    && dev->iamthif_state != MEI_IAMTHIF_IDLE) {
+			DBG("pthi canceled iamthif state %d\n",
+			    dev->iamthif_state);
+			dev->iamthif_canceled = 1;
+			if (dev->iamthif_state == MEI_IAMTHIF_READ_COMPLETE) {
+				DBG("run next pthi iamthif cb\n");
+				run_next_iamthif_cmd(dev);
+			}
+		}
+
+		if (mei_clear_lists(dev, file))
+			dev->iamthif_state = MEI_IAMTHIF_IDLE;
+
+	}
+	mutex_unlock(&dev->device_lock);
+	return rets;
+}
+
+
+/**
+ * mei_read - the read function.
+ *
+ * @file: pointer to file structure
+ * @ubuf: pointer to user buffer
+ * @length: buffer length
+ * @offset: data offset in buffer
+ *
+ * returns >=0 data length on success , <0 on error
+ */
+static ssize_t mei_read(struct file *file, char __user *ubuf,
+			 size_t length, loff_t *offset)
+{
+	int i;
+	int rets = 0, err = 0;
+	int if_num = iminor(file->f_dentry->d_inode);
+	struct mei_file_private *file_ext = file->private_data;
+	struct mei_cb_private *priv_cb_pos = NULL;
+	struct mei_cb_private *priv_cb = NULL;
+	struct iamt_mei_device *dev;
+
+	if (!mei_device)
+		return -ENODEV;
+
+	dev = pci_get_drvdata(mei_device);
+	if ((if_num != MEI_MINOR_NUMBER) || (!dev) || (!file_ext))
+		return -ENODEV;
+
+	mutex_lock(&dev->device_lock);
+	if (dev->mei_state != MEI_ENABLED) {
+		rets = -ENODEV;
+		goto out;
+	}
+
+	if ((file_ext->sm_state & MEI_WD_STATE_INDEPENDENCE_MSG_SENT) == 0) {
+		/* Do not allow to read watchdog client */
+		for (i = 0; i < dev->num_mei_me_clients; i++) {
+			struct mei_me_client *me_client = &dev->me_clients[i];
+			if ((memcmp(&mei_wd_guid,
+					&me_client->props.protocol_name,
+					sizeof(struct guid)) == 0) &&
+			    (file_ext->me_client_id == me_client->client_id)) {
+				rets = -EBADF;
+				goto out;
+			}
+
+		}
+	} else {
+		file_ext->sm_state &= ~MEI_WD_STATE_INDEPENDENCE_MSG_SENT;
+	}
+
+	if (file_ext == &dev->iamthif_file_ext) {
+		rets = pthi_read(dev, if_num, file, ubuf, length, offset);
+		goto out;
+	}
+
+	if (file_ext->read_cb && file_ext->read_cb->information > *offset) {
+		priv_cb = file_ext->read_cb;
+		goto copy_buffer;
+	} else if (file_ext->read_cb && file_ext->read_cb->information > 0 &&
+		   file_ext->read_cb->information <= *offset) {
+		priv_cb = file_ext->read_cb;
+		rets = 0;
+		goto free;
+	} else if ((!file_ext->read_cb || file_ext->read_cb->information == 0)
+		    && *offset > 0) {
+		/*Offset needs to be cleaned for contingous reads*/
+		*offset = 0;
+		rets = 0;
+		goto out;
+	}
+
+	err = mei_start_read(dev, if_num, file_ext);
+	if (err != 0 && err != -EBUSY) {
+		DBG("mei start read failure with status = %d\n", err);
+		rets = err;
+		goto out;
+	}
+
+	if (MEI_READ_COMPLETE != file_ext->reading_state
+			&& !waitqueue_active(&file_ext->rx_wait)) {
+		if (file->f_flags & O_NONBLOCK) {
+			rets = -EAGAIN;
+			goto out;
+		}
+
+		mutex_unlock(&dev->device_lock);
+
+		if (wait_event_interruptible(file_ext->rx_wait,
+			(MEI_READ_COMPLETE == file_ext->reading_state
+			 || MEI_FILE_INITIALIZING == file_ext->state
+			 || MEI_FILE_DISCONNECTED == file_ext->state
+			 || MEI_FILE_DISCONNECTING == file_ext->state))) {
+			if (signal_pending(current))
+				return -EINTR;
+			return -ERESTARTSYS;
+		}
+
+		mutex_lock(&dev->device_lock);
+		if (MEI_FILE_INITIALIZING == file_ext->state ||
+		    MEI_FILE_DISCONNECTED == file_ext->state ||
+		    MEI_FILE_DISCONNECTING == file_ext->state) {
+			rets = -EBUSY;
+			goto out;
+		}
+	}
+
+	priv_cb = file_ext->read_cb;
+
+	if (!priv_cb) {
+		rets = -ENODEV;
+		goto out;
+	}
+	if (file_ext->reading_state != MEI_READ_COMPLETE) {
+		rets = 0;
+		goto out;
+	}
+	/* now copy the data to user space */
+copy_buffer:
+	DBG("priv_cb->response_buffer size - %d\n",
+	    priv_cb->response_buffer.size);
+	DBG("priv_cb->information - %lu\n",
+	    priv_cb->information);
+	if (length == 0 || ubuf == NULL ||
+	    *offset > priv_cb->information) {
+		rets = -EMSGSIZE;
+		goto free;
+	}
+
+	/* length is being turncated to PAGE_SIZE, however, */
+	/* information size may be longer */
+	length = (length < (priv_cb->information - *offset) ?
+			length : (priv_cb->information - *offset));
+
+	if (copy_to_user(ubuf,
+			 priv_cb->response_buffer.data + *offset,
+			 length)) {
+		rets = -EFAULT;
+		goto free;
+	}
+
+	rets = length;
+	*offset += length;
+	if ((unsigned long)*offset < priv_cb->information)
+		goto out;
+
+free:
+	priv_cb_pos = find_read_list_entry(dev, file_ext);
+	/* Remove entry from read list */
+	if (priv_cb_pos != NULL)
+		list_del(&priv_cb_pos->cb_list);
+	mei_free_cb_private(priv_cb);
+	file_ext->reading_state = MEI_IDLE;
+	file_ext->read_cb = NULL;
+	file_ext->read_pending = 0;
+out:
+	DBG("end mei read rets= %d\n", rets);
+	mutex_unlock(&dev->device_lock);
+	return rets;
+}
+
+/**
+ * mei_write - the write function.
+ *
+ * @file: pointer to file structure
+ * @ubuf: pointer to user buffer
+ * @length: buffer length
+ * @offset: data offset in buffer
+ *
+ * returns >=0 data length on success , <0 on error
+ */
+static ssize_t mei_write(struct file *file, const char __user *ubuf,
+			  size_t length, loff_t *offset)
+{
+	struct mei_file_private *file_ext = file->private_data;
+	struct mei_cb_private *priv_write_cb = NULL;
+	struct mei_msg_hdr mei_hdr;
+	struct iamt_mei_device *dev;
+	unsigned long currtime = get_seconds();
+	int if_num = iminor(file->f_dentry->d_inode);
+	int rets;
+	u8 i;
+
+	if (!mei_device)
+		return -ENODEV;
+
+	dev = pci_get_drvdata(mei_device);
+
+	if ((if_num != MEI_MINOR_NUMBER) || !dev || !file_ext)
+		return -ENODEV;
+
+	mutex_lock(&dev->device_lock);
+
+	if (dev->mei_state != MEI_ENABLED) {
+		mutex_unlock(&dev->device_lock);
+		return -ENODEV;
+	}
+	if (file_ext == &dev->iamthif_file_ext) {
+		priv_write_cb = find_pthi_read_list_entry(dev, file);
+		if ((priv_write_cb != NULL) &&
+		     (((currtime - priv_write_cb->read_time) >=
+			    IAMTHIF_READ_TIMER) ||
+		      (file_ext->reading_state == MEI_READ_COMPLETE))) {
+			*offset = 0;
+			list_del(&priv_write_cb->cb_list);
+			mei_free_cb_private(priv_write_cb);
+			priv_write_cb = NULL;
+		}
+	}
+
+	/* free entry used in read */
+	if (file_ext->reading_state == MEI_READ_COMPLETE) {
+		*offset = 0;
+		priv_write_cb = find_read_list_entry(dev, file_ext);
+		if (priv_write_cb != NULL) {
+			list_del(&priv_write_cb->cb_list);
+			mei_free_cb_private(priv_write_cb);
+			priv_write_cb = NULL;
+			file_ext->reading_state = MEI_IDLE;
+			file_ext->read_cb = NULL;
+			file_ext->read_pending = 0;
+		}
+	} else if (file_ext->reading_state == MEI_IDLE &&
+			file_ext->read_pending == 0)
+		*offset = 0;
+
+
+	priv_write_cb = kzalloc(sizeof(struct mei_cb_private), GFP_KERNEL);
+	if (!priv_write_cb) {
+		mutex_unlock(&dev->device_lock);
+		return -ENOMEM;
+	}
+
+	priv_write_cb->file_object = file;
+	priv_write_cb->file_private = file_ext;
+	priv_write_cb->request_buffer.data = kmalloc(length, GFP_KERNEL);
+	rets = -ENOMEM;
+	if (!priv_write_cb->request_buffer.data)
+		goto unlock_dev;
+
+	DBG("length =%d\n", (int) length);
+
+	rets = -EFAULT;
+	if (copy_from_user(priv_write_cb->request_buffer.data, ubuf, length))
+		goto unlock_dev;
+
+	file_ext->sm_state = 0;
+	if ((length == 4) &&
+	    ((memcmp(mei_wd_state_independence_msg[0],
+				 priv_write_cb->request_buffer.data, 4) == 0) ||
+	     (memcmp(mei_wd_state_independence_msg[1],
+				 priv_write_cb->request_buffer.data, 4) == 0) ||
+	     (memcmp(mei_wd_state_independence_msg[2],
+				 priv_write_cb->request_buffer.data, 4) == 0)))
+		file_ext->sm_state |= MEI_WD_STATE_INDEPENDENCE_MSG_SENT;
+
+	INIT_LIST_HEAD(&priv_write_cb->cb_list);
+	if (file_ext == &dev->iamthif_file_ext) {
+		priv_write_cb->response_buffer.data =
+		    kmalloc(dev->iamthif_mtu, GFP_KERNEL);
+		if (!priv_write_cb->response_buffer.data) {
+			rets = -ENOMEM;
+			goto unlock_dev;
+		}
+		if (dev->mei_state != MEI_ENABLED) {
+			rets = -ENODEV;
+			goto unlock_dev;
+		}
+		for (i = 0; i < dev->num_mei_me_clients; i++) {
+			if (dev->me_clients[i].client_id ==
+				dev->iamthif_file_ext.me_client_id)
+				break;
+		}
+
+		BUG_ON(dev->me_clients[i].client_id != file_ext->me_client_id);
+		if ((i == dev->num_mei_me_clients) ||
+		    (dev->me_clients[i].client_id !=
+		      dev->iamthif_file_ext.me_client_id)) {
+			rets = -ENODEV;
+			goto unlock_dev;
+		} else if ((length > dev->me_clients[i].props.max_msg_length)
+			    || (length <= 0)) {
+			rets = -EMSGSIZE;
+			goto unlock_dev;
+		}
+
+		priv_write_cb->response_buffer.size = dev->iamthif_mtu;
+		priv_write_cb->major_file_operations = MEI_IOCTL;
+		priv_write_cb->information = 0;
+		priv_write_cb->request_buffer.size = length;
+		if (dev->iamthif_file_ext.state != MEI_FILE_CONNECTED) {
+			rets = -ENODEV;
+			goto unlock_dev;
+		}
+
+		if (!list_empty(&dev->pthi_cmd_list.mei_cb.cb_list)
+				|| dev->iamthif_state != MEI_IAMTHIF_IDLE) {
+			DBG("pthi_state = %d\n", (int) dev->iamthif_state);
+			DBG("add PTHI cb to pthi cmd waiting list\n");
+			list_add_tail(&priv_write_cb->cb_list,
+					&dev->pthi_cmd_list.mei_cb.cb_list);
+			rets = length;
+		} else {
+			DBG("call pthi write\n");
+			rets = pthi_write(dev, priv_write_cb);
+
+			if (rets != 0) {
+				DBG("pthi write failed with status = %d\n",
+				    rets);
+				goto unlock_dev;
+			}
+			rets = length;
+		}
+		mutex_unlock(&dev->device_lock);
+		return rets;
+	}
+
+	priv_write_cb->major_file_operations = MEI_WRITE;
+	/* make sure information is zero before we start */
+
+	priv_write_cb->information = 0;
+	priv_write_cb->request_buffer.size = length;
+
+	DBG("host client = %d, ME client = %d\n",
+	    file_ext->host_client_id, file_ext->me_client_id);
+	if (file_ext->state != MEI_FILE_CONNECTED) {
+		rets = -ENODEV;
+		DBG("host client = %d,  is not connected to ME client = %d",
+		    file_ext->host_client_id,
+		    file_ext->me_client_id);
+		goto unlock_dev;
+	}
+	for (i = 0; i < dev->num_mei_me_clients; i++) {
+		if (dev->me_clients[i].client_id ==
+		    file_ext->me_client_id)
+			break;
+	}
+	BUG_ON(dev->me_clients[i].client_id != file_ext->me_client_id);
+	if (i == dev->num_mei_me_clients) {
+		rets = -ENODEV;
+		goto unlock_dev;
+	}
+	if (length > dev->me_clients[i].props.max_msg_length || length <= 0) {
+		rets = -EINVAL;
+		goto unlock_dev;
+	}
+	priv_write_cb->file_private = file_ext;
+
+	if (flow_ctrl_creds(dev, file_ext) &&
+		dev->host_buffer_is_empty) {
+		dev->host_buffer_is_empty = 0;
+		if (length > ((((dev->host_hw_state & H_CBD) >> 24) *
+			sizeof(u32)) -sizeof(struct mei_msg_hdr))) {
+
+			mei_hdr.length =
+				(((dev->host_hw_state & H_CBD) >> 24) *
+				sizeof(u32)) -
+				sizeof(struct mei_msg_hdr);
+			mei_hdr.msg_complete = 0;
+		} else {
+			mei_hdr.length = length;
+			mei_hdr.msg_complete = 1;
+		}
+		mei_hdr.host_addr = file_ext->host_client_id;
+		mei_hdr.me_addr = file_ext->me_client_id;
+		mei_hdr.reserved = 0;
+		DBG("call mei_write_message header=%08x.\n",
+		    *((u32 *) &mei_hdr));
+		if (!mei_write_message(dev, &mei_hdr,
+			(unsigned char *) (priv_write_cb->request_buffer.data),
+			mei_hdr.length)) {
+			rets = -ENODEV;
+			goto unlock_dev;
+		}
+		file_ext->writing_state = MEI_WRITING;
+		priv_write_cb->information = mei_hdr.length;
+		if (mei_hdr.msg_complete) {
+			flow_ctrl_reduce(dev, file_ext);
+			list_add_tail(&priv_write_cb->cb_list,
+				      &dev->write_waiting_list.mei_cb.cb_list);
+		} else {
+			list_add_tail(&priv_write_cb->cb_list,
+				      &dev->write_list.mei_cb.cb_list);
+		}
+
+	} else {
+
+		priv_write_cb->information = 0;
+		file_ext->writing_state = MEI_WRITING;
+		list_add_tail(&priv_write_cb->cb_list,
+			      &dev->write_list.mei_cb.cb_list);
+	}
+	mutex_unlock(&dev->device_lock);
+	return length;
+
+unlock_dev:
+	mutex_unlock(&dev->device_lock);
+	mei_free_cb_private(priv_write_cb);
+	return rets;
+}
+
+/**
+ * mei_ioctl - the IOCTL function
+ *
+ * @inode: pointer to inode structure
+ * @file: pointer to file structure
+ * @cmd: ioctl command
+ * @data: pointer to mei message structure
+ *
+ * returns 0 on success , <0 on error
+ */
+static long mei_ioctl(struct file *file,
+		      unsigned int cmd, unsigned long data)
+{
+	struct inode *inode;
+	struct mei_file_private *file_ext = file->private_data;
+	int rets = 0;
+	int if_num;
+
+	/* in user space */
+	struct mei_message_data __user *u_msg;
+	struct mei_message_data k_msg;	/* all in kernel on the stack */
+	struct iamt_mei_device *dev;
+
+	/* Fix in order to use unlocked_ioctl for suppoer kernel >= 2.6.36 */
+	inode = file->f_dentry->d_inode;
+	if_num = iminor(inode);
+
+	if (!mei_device)
+		return -ENODEV;
+
+	dev = pci_get_drvdata(mei_device);
+	if ((if_num != MEI_MINOR_NUMBER) || !dev || !file_ext)
+		return -ENODEV;
+
+	mutex_lock(&dev->device_lock);
+	if (dev->mei_state != MEI_ENABLED) {
+		mutex_unlock(&dev->device_lock);
+		return -ENODEV;
+	}
+
+	/* first copy from user all data needed */
+	u_msg = (struct mei_message_data __user *)data;
+	if (copy_from_user(&k_msg, u_msg, sizeof(k_msg))) {
+		DBG("first copy from user all data needed filled\n");
+		mutex_unlock(&dev->device_lock);
+		return -EFAULT;
+	}
+	DBG("user message size is %d\n", k_msg.size);
+
+	switch (cmd) {
+	case IOCTL_MEI_GET_VERSION:
+		DBG(": IOCTL_MEI_GET_VERSION\n");
+		rets = mei_ioctl_get_version(dev, if_num, u_msg, k_msg,
+					      file_ext);
+		break;
+
+	case IOCTL_MEI_CONNECT_CLIENT:
+		DBG(": IOCTL_MEI_CONNECT_CLIENT.\n");
+		rets = mei_ioctl_connect_client(dev, if_num, u_msg, k_msg,
+						 file);
+		break;
+
+	case IOCTL_MEI_WD:
+		DBG(": IOCTL_MEI_WD.\n");
+		rets = mei_ioctl_wd(dev, if_num, k_msg, file_ext);
+		break;
+
+	case IOCTL_MEI_BYPASS_WD:
+		DBG(": IOCTL_MEI_BYPASS_WD.\n");
+		rets = mei_ioctl_bypass_wd(dev, if_num, k_msg, file_ext);
+		break;
+
+	default:
+		rets = -EINVAL;
+		break;
+	}
+	mutex_unlock(&dev->device_lock);
+	return rets;
+}
+
+/**
+ * mei_poll - the poll function
+ *
+ * @file: pointer to file structure
+ * @wait: pointer to poll_table structure
+ *
+ * returns poll mask
+ */
+static unsigned int mei_poll(struct file *file, poll_table *wait)
+{
+	int if_num = iminor(file->f_dentry->d_inode);
+	unsigned int mask = 0;
+	struct mei_file_private *file_ext = file->private_data;
+	struct iamt_mei_device *dev;
+
+	if (!mei_device)
+		return mask;
+
+	dev = pci_get_drvdata(mei_device);
+
+	if ((if_num != MEI_MINOR_NUMBER) || !dev || !file_ext)
+		return mask;
+
+	mutex_lock(&dev->device_lock);
+	if (dev->mei_state != MEI_ENABLED) {
+		mutex_unlock(&dev->device_lock);
+		return mask;
+	}
+
+	if (file_ext == &dev->iamthif_file_ext) {
+		mutex_unlock(&dev->device_lock);
+		poll_wait(file, &dev->iamthif_file_ext.wait, wait);
+		mutex_lock(&dev->device_lock);
+		if ((dev->iamthif_state == MEI_IAMTHIF_READ_COMPLETE)
+		    && dev->iamthif_file_object == file) {
+			mask |= (POLLIN | POLLRDNORM);
+			DBG("run next pthi cb\n");
+			run_next_iamthif_cmd(dev);
+		}
+
+	} else {
+		mutex_unlock(&dev->device_lock);
+		poll_wait(file, &file_ext->tx_wait, wait);
+		mutex_lock(&dev->device_lock);
+		if (MEI_WRITE_COMPLETE == file_ext->writing_state)
+			mask |= (POLLIN | POLLRDNORM);
+
+	}
+	mutex_unlock(&dev->device_lock);
+	return mask;
+}
+
+#ifdef CONFIG_PM
+static int mei_pci_suspend(struct device *device)
+{
+	struct pci_dev *pdev = to_pci_dev(device);
+	struct iamt_mei_device *dev = pci_get_drvdata(pdev);
+	int err = 0;
+
+	if (!dev)
+		return -ENODEV;
+	mutex_lock(&dev->device_lock);
+	/* Stop watchdog if exists */
+	cancel_delayed_work(&dev->wd_work);
+	if ((dev->wd_file_ext.state == MEI_FILE_CONNECTED) && dev->wd_timeout) {
+		g_sus_wd_timeout = dev->wd_timeout;
+		dev->wd_timeout = 0;
+		dev->wd_due_counter = 0;
+		memcpy(dev->wd_data, mei_stop_wd_params, MEI_WD_PARAMS_SIZE);
+		dev->stop = 1;
+		if (dev->host_buffer_is_empty &&
+		    flow_ctrl_creds(dev, &dev->wd_file_ext)) {
+			dev->host_buffer_is_empty = 0;
+			if (!mei_send_wd(dev))
+				DBG("send stop WD failed\n");
+			else
+				flow_ctrl_reduce(dev, &dev->wd_file_ext);
+
+			dev->wd_pending = 0;
+		} else {
+			dev->wd_pending = 1;
+		}
+		dev->wd_stopped = 0;
+
+		mutex_unlock(&dev->device_lock);
+		err = wait_event_interruptible_timeout(dev->wait_stop_wd,
+						       (dev->wd_stopped),
+						       10 * HZ);
+		mutex_lock(&dev->device_lock);
+		if (!dev->wd_stopped)
+			DBG("stop wd failed to complete.\n");
+		else {
+			DBG("stop wd complete %d.\n", err);
+			err = 0;
+		}
+	}
+	/* Set new mei state */
+	if ((dev->mei_state == MEI_ENABLED) ||
+	    (dev->mei_state == MEI_RECOVERING_FROM_RESET)) {
+		dev->mei_state = MEI_POWER_DOWN;
+		mei_reset(dev, 0);
+	}
+	mutex_unlock(&dev->device_lock);
+
+	free_irq(pdev->irq, dev);
+
+
+	return err;
+}
+
+static int mei_pci_resume(struct device *device)
+{
+	struct pci_dev *pdev = to_pci_dev(device);
+	struct iamt_mei_device *dev;
+	int err;
+
+	dev = pci_get_drvdata(pdev);
+	if (!dev)
+		return -ENODEV;
+
+	/* request and enable interrupt   */
+	err = request_threaded_irq(pdev->irq,
+			mei_interrupt_quick_handler,
+			mei_interrupt_thread_handler,
+			IRQF_SHARED, mei_driver_name, dev);
+	if (err) {
+		printk(KERN_ERR "mei: Request_irq failure. irq = %d\n",
+		       pdev->irq);
+		return err;
+	}
+
+	mutex_lock(&dev->device_lock);
+	dev->mei_state = MEI_POWER_UP;
+	mei_reset(dev, 1);
+	mutex_unlock(&dev->device_lock);
+
+	/* Start watchdog if stopped in suspend */
+	if (g_sus_wd_timeout != 0) {
+		dev->wd_timeout = g_sus_wd_timeout;
+
+		memcpy(dev->wd_data, mei_start_wd_params,
+			MEI_WD_PARAMS_SIZE);
+		memcpy(dev->wd_data + MEI_WD_PARAMS_SIZE,
+			&dev->wd_timeout, sizeof(u16));
+		dev->wd_due_counter = 1;
+
+		if (dev->wd_timeout)
+			schedule_delayed_work(&dev->wd_work, HZ);
+
+		g_sus_wd_timeout = 0;
+	}
+	return err;
+}
+static SIMPLE_DEV_PM_OPS(mei_pm_ops, mei_pci_suspend, mei_pci_resume);
+#define MEI_PM_OPS	(&mei_pm_ops)
+#else
+#define MIE_PM_OPS	NULL
+#endif /* CONFIG_PM */
+/*
+ *  PCI driver structure
+ */
+static struct pci_driver mei_driver = {
+	.name = mei_driver_name,
+	.id_table = mei_pci_tbl,
+	.probe = mei_probe,
+	.remove = __devexit_p(mei_remove),
+	.shutdown = __devexit_p(mei_remove),
+	.driver.pm = MEI_PM_OPS,
+};
+
+/*
+ * file operations structure will be used for mei char device.
+ */
+static const struct file_operations mei_fops = {
+	.owner = THIS_MODULE,
+	.read = mei_read,
+	.unlocked_ioctl = mei_ioctl,
+	.open = mei_open,
+	.release = mei_release,
+	.write = mei_write,
+	.poll = mei_poll,
+};
+
+/**
+ * mei_registration_cdev - sets up the cdev structure for mei device.
+ *
+ * @dev: char device struct
+ * @hminor: minor number for registration char device
+ * @fops: file operations structure
+ *
+ * returns 0 on success, <0 on failure.
+ */
+static int mei_registration_cdev(struct cdev *dev, int hminor,
+				  const struct file_operations *fops)
+{
+	int ret, devno = MKDEV(mei_major, hminor);
+
+	cdev_init(dev, fops);
+	dev->owner = THIS_MODULE;
+	ret = cdev_add(dev, devno, 1);
+	/* Fail gracefully if need be */
+	if (ret)
+		printk(KERN_ERR "mei: Error %d registering mei device %d\n",
+		       ret, hminor);
+	return ret;
+}
+
+static ssize_t version_show(struct class *class,
+			    struct class_attribute *attr,
+			    char *buf)
+{
+	return sprintf(buf, "%s %s.\n", mei_driver_string, mei_driver_version);
+}
+
+static CLASS_ATTR(version, S_IRUGO, version_show, NULL);
+
+/**
+ * mei_register_cdev - registers mei char device
+ *
+ * returns 0 on success, <0 on failure.
+ */
+static int mei_register_cdev(void)
+{
+	int ret;
+	dev_t dev;
+
+	/* registration of char devices */
+	ret = alloc_chrdev_region(&dev, MEI_MINORS_BASE, MEI_MINORS_COUNT,
+				  MEI_DRIVER_NAME);
+	if (ret) {
+		printk(KERN_ERR "mei: Error allocating char device region.\n");
+		return ret;
+	}
+
+	mei_major = MAJOR(dev);
+
+	ret = mei_registration_cdev(&mei_cdev, MEI_MINOR_NUMBER,
+				     &mei_fops);
+	if (ret)
+		unregister_chrdev_region(MKDEV(mei_major, MEI_MINORS_BASE),
+					 MEI_MINORS_COUNT);
+
+	return ret;
+}
+
+/**
+ * mei_unregister_cdev - unregisters mei char device
+ */
+static void mei_unregister_cdev(void)
+{
+	cdev_del(&mei_cdev);
+	unregister_chrdev_region(MKDEV(mei_major, MEI_MINORS_BASE),
+				 MEI_MINORS_COUNT);
+}
+
+#ifndef MEI_DEVICE_CREATE
+#define MEI_DEVICE_CREATE device_create
+#endif
+/**
+ * mei_sysfs_device_create - adds device entry to sysfs
+ *
+ * returns 0 on success, <0 on failure.
+ */
+static int mei_sysfs_device_create(void)
+{
+	struct class *class;
+	void *tmphdev;
+	int err;
+
+	class = class_create(THIS_MODULE, MEI_DRIVER_NAME);
+	if (IS_ERR(class)) {
+		err = PTR_ERR(class);
+		printk(KERN_ERR "mei: Error creating mei class.\n");
+		goto err_out;
+	}
+
+	err = class_create_file(class, &class_attr_version);
+	if (err) {
+		printk(KERN_ERR "mei: Error creating mei class file.\n");
+		goto err_destroy;
+	}
+
+	tmphdev = MEI_DEVICE_CREATE(class, NULL, mei_cdev.dev, NULL,
+					MEI_DEV_NAME);
+	if (IS_ERR(tmphdev)) {
+		err = PTR_ERR(tmphdev);
+		goto err_remove;
+	}
+
+	mei_class = class;
+	return 0;
+
+err_remove:
+	class_remove_file(class, &class_attr_version);
+err_destroy:
+	class_destroy(class);
+err_out:
+	return err;
+}
+
+/**
+ * mei_sysfs_device_remove - unregisters the device entry on sysfs
+ */
+static void mei_sysfs_device_remove(void)
+{
+	if ((mei_class == NULL) || (IS_ERR(mei_class)))
+		return;
+
+	device_destroy(mei_class, mei_cdev.dev);
+	class_remove_file(mei_class, &class_attr_version);
+	class_destroy(mei_class);
+}
+
+/**
+ * mei_init_module - Driver Registration Routine
+ *
+ * mei_init_module is the first routine called when the driver is
+ * loaded. All it does is to register with the PCI subsystem.
+ *
+ * returns 0 on success, <0 on failure.
+ */
+static int __init mei_init_module(void)
+{
+	int ret;
+
+	printk(KERN_INFO "mei: %s - version %s\n", mei_driver_string,
+			mei_driver_version);
+	/* init pci module */
+	ret = pci_register_driver(&mei_driver);
+	if (ret < 0) {
+		printk(KERN_ERR "mei: Error registering driver.\n");
+		goto end;
+	}
+
+	ret = mei_register_cdev();
+	if (ret)
+		goto unregister_pci;
+
+	ret = mei_sysfs_device_create();
+	if (ret)
+		goto unregister_cdev;
+
+	return ret;
+
+unregister_cdev:
+	mei_unregister_cdev();
+unregister_pci:
+	pci_unregister_driver(&mei_driver);
+end:
+	return ret;
+}
+
+module_init(mei_init_module);
+
+/**
+ * mei_exit_module - Driver Exit Cleanup Routine
+ *
+ * mei_exit_module is called just before the driver is removed
+ * from memory.
+ */
+static void __exit mei_exit_module(void)
+{
+	pci_unregister_driver(&mei_driver);
+	mei_sysfs_device_remove();
+	mei_unregister_cdev();
+
+	printk(KERN_INFO "mei: Driver unloaded successfully.\n");
+}
+
+module_exit(mei_exit_module);
+
+
+MODULE_AUTHOR("Intel Corporation");
+MODULE_DESCRIPTION("Intel(R) Management Engine Interface");
+MODULE_LICENSE("GPL v2");
+MODULE_VERSION(MEI_DRIVER_VERSION);


---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

