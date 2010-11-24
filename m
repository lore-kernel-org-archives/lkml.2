Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240Ab0KXT7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 14:59:50 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:47202 "EHLO deliverator"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932087Ab0KXT7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 14:59:38 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 12/12] sep: Fix crash if a device is not found
To: greg@kroah.com, mark.a.allyn@intel.com, linux-kernel@vger.kernel.org
Date: Wed, 24 Nov 2010 19:39:20 +0000
Message-ID: <20101124193917.16425.76966.stgit@bob.linux.org.uk>
In-Reply-To: <20101124192136.16425.49994.stgit@bob.linux.org.uk>
References: <20101124192136.16425.49994.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

The existing code works mostly by luck. The PCI probe is done by the
register and completes before the register returns thus allowing the other
init code to run in time. Without a SEP or if unlucky this doesn't occur
and you get an OOPS which for some reason causes grumpiness.

As the season of good b^Hcheer is supposed to be approaching we should
probably fix it.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/staging/sep/sep_driver.c |  363 +++++++++++++++++---------------------
 1 files changed, 167 insertions(+), 196 deletions(-)


diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index 5e27b5a..7633111 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -256,8 +256,7 @@ static int sep_singleton_open(struct inode *inode_ptr, struct file *file_ptr)
 
 	file_ptr->private_data = sep;
 
-	dev_dbg(&sep->pdev->dev, "Singleton open for pid %d\n",
-		current->pid);
+	dev_dbg(&sep->pdev->dev, "Singleton open for pid %d\n", current->pid);
 
 	dev_dbg(&sep->pdev->dev, "calling test and set for singleton 0\n");
 	if (test_and_set_bit(0, &sep->singleton_access_flag)) {
@@ -265,10 +264,8 @@ static int sep_singleton_open(struct inode *inode_ptr, struct file *file_ptr)
 		goto end_function;
 	}
 
-	dev_dbg(&sep->pdev->dev,
-		"sep_singleton_open end\n");
+	dev_dbg(&sep->pdev->dev, "sep_singleton_open end\n");
 end_function:
-
 	return error;
 }
 
@@ -386,9 +383,7 @@ static int sep_req_daemon_send_reply_command_handler(struct sep_device *sep)
 	sep->reply_ct++;
 
 	/* Send the interrupt to SEP */
-	sep_write_reg(sep, HW_HOST_HOST_SEP_GPR2_REG_ADDR,
-		sep->send_ct);
-
+	sep_write_reg(sep, HW_HOST_HOST_SEP_GPR2_REG_ADDR, sep->send_ct);
 	sep->send_ct++;
 
 	spin_unlock_irqrestore(&sep->snd_rply_lck, lck_flags);
@@ -3305,6 +3300,125 @@ end_function:
 }
 
 /**
+ *	sep_reconfig_shared_area - reconfigure shared area
+ *	@sep: pointer to struct sep_device
+ *
+ *	Reconfig the shared area between HOST and SEP - needed in case
+ *	the DX_CC_Init function was called before OS loading.
+ */
+static int sep_reconfig_shared_area(struct sep_device *sep)
+{
+	int ret_val;
+
+	dev_dbg(&sep->pdev->dev, "reconfig shared area start\n");
+
+	/* Send the new SHARED MESSAGE AREA to the SEP */
+	dev_dbg(&sep->pdev->dev, "sending %08llx to sep\n",
+				(unsigned long long)sep->shared_bus);
+
+	sep_write_reg(sep, HW_HOST_HOST_SEP_GPR1_REG_ADDR, sep->shared_bus);
+
+	/* Poll for SEP response */
+	ret_val = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR1_REG_ADDR);
+
+	while (ret_val != 0xffffffff && ret_val != sep->shared_bus)
+		ret_val = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR1_REG_ADDR);
+
+	/* Check the return value (register) */
+	if (ret_val != sep->shared_bus) {
+		dev_warn(&sep->pdev->dev, "could not reconfig shared area\n");
+		dev_warn(&sep->pdev->dev, "result was %x\n", ret_val);
+		ret_val = -ENOMEM;
+	} else
+		ret_val = 0;
+
+	dev_dbg(&sep->pdev->dev, "reconfig shared area end\n");
+	return ret_val;
+}
+
+/* File operation for singleton SEP operations */
+static const struct file_operations singleton_file_operations = {
+	.owner = THIS_MODULE,
+	.unlocked_ioctl = sep_singleton_ioctl,
+	.poll = sep_poll,
+	.open = sep_singleton_open,
+	.release = sep_singleton_release,
+	.mmap = sep_mmap,
+};
+
+/* File operation for daemon operations */
+static const struct file_operations daemon_file_operations = {
+	.owner = THIS_MODULE,
+	.unlocked_ioctl = sep_request_daemon_ioctl,
+	.poll = sep_request_daemon_poll,
+	.open = sep_request_daemon_open,
+	.release = sep_request_daemon_release,
+	.mmap = sep_request_daemon_mmap,
+};
+
+/* The files operations structure of the driver */
+static const struct file_operations sep_file_operations = {
+	.owner = THIS_MODULE,
+	.unlocked_ioctl = sep_ioctl,
+	.poll = sep_poll,
+	.open = sep_open,
+	.release = sep_release,
+	.mmap = sep_mmap,
+};
+
+/**
+ *	sep_register_driver_with_fs - register misc devices
+ *	@sep: pointer to struct sep_device
+ *
+ *	This function registers the driver with the file system
+ */
+static int sep_register_driver_with_fs(struct sep_device *sep)
+{
+	int ret_val;
+
+	sep->miscdev_sep.minor = MISC_DYNAMIC_MINOR;
+	sep->miscdev_sep.name = SEP_DEV_NAME;
+	sep->miscdev_sep.fops = &sep_file_operations;
+
+	sep->miscdev_singleton.minor = MISC_DYNAMIC_MINOR;
+	sep->miscdev_singleton.name = SEP_DEV_SINGLETON;
+	sep->miscdev_singleton.fops = &singleton_file_operations;
+
+	sep->miscdev_daemon.minor = MISC_DYNAMIC_MINOR;
+	sep->miscdev_daemon.name = SEP_DEV_DAEMON;
+	sep->miscdev_daemon.fops = &daemon_file_operations;
+
+	ret_val = misc_register(&sep->miscdev_sep);
+	if (ret_val) {
+		dev_warn(&sep->pdev->dev, "misc reg fails for SEP %x\n",
+			ret_val);
+		return ret_val;
+	}
+
+	ret_val = misc_register(&sep->miscdev_singleton);
+	if (ret_val) {
+		dev_warn(&sep->pdev->dev, "misc reg fails for sing %x\n",
+			ret_val);
+		misc_deregister(&sep->miscdev_sep);
+		return ret_val;
+	}
+
+	if (!sep->mrst) {
+		ret_val = misc_register(&sep->miscdev_daemon);
+		if (ret_val) {
+			dev_warn(&sep->pdev->dev, "misc reg fails for dmn %x\n",
+				ret_val);
+			misc_deregister(&sep->miscdev_sep);
+			misc_deregister(&sep->miscdev_singleton);
+
+			return ret_val;
+		}
+	}
+	return ret_val;
+}
+
+
+/**
  *	sep_probe - probe a matching PCI device
  *	@pdev: pci_device
  *	@end: pci_device_id
@@ -3349,6 +3463,12 @@ static int __devinit sep_probe(struct pci_dev *pdev,
 
 	sep->pdev = pdev;
 
+	init_waitqueue_head(&sep->event);
+	init_waitqueue_head(&sep->event_request_daemon);
+	spin_lock_init(&sep->snd_rply_lck);
+	mutex_init(&sep->sep_mutex);
+	mutex_init(&sep->ioctl_mutex);
+
 	if (pdev->device == MRST_PCI_DEVICE_ID)
 		sep->mrst = 1;
 
@@ -3435,9 +3555,26 @@ static int __devinit sep_probe(struct pci_dev *pdev,
 	error = request_irq(pdev->irq, sep_inthandler, IRQF_SHARED,
 		"sep_driver", sep);
 
-	if (!error)
-		goto end_function;
+	if (error)
+		goto end_function_dealloc_rar;
 
+	/* The new chip requires ashared area reconfigure */
+	if (sep->pdev->revision == 4) { /* Only for new chip */
+		error = sep_reconfig_shared_area(sep);
+		if (error)
+			goto end_function_free_irq;
+	}
+	/* Finally magic up the device nodes */
+	/* Register driver with the fs */
+	error = sep_register_driver_with_fs(sep);
+	if (error == 0)
+		/* Success */
+		return 0;
+		
+end_function_free_irq:
+	free_irq(pdev->irq, sep);
+
+end_function_dealloc_rar:
 	if (sep->rar_addr)
 		dma_free_coherent(&sep->pdev->dev, sep->rar_size,
 			sep->rar_addr, sep->rar_bus);
@@ -3456,6 +3593,23 @@ end_function:
 	return error;
 }
 
+static void sep_remove(struct pci_dev *pdev)
+{
+	struct sep_device *sep = sep_dev;
+
+	/* Unregister from fs */
+	misc_deregister(&sep->miscdev_sep);
+	misc_deregister(&sep->miscdev_singleton);
+	misc_deregister(&sep->miscdev_daemon);
+
+	/* Free the irq */
+	free_irq(sep->pdev->irq, sep);
+
+	/* Free the shared area  */
+	sep_unmap_and_free_shared_area(sep_dev);
+	iounmap((void *) sep_dev->reg_addr);
+}
+
 static DEFINE_PCI_DEVICE_TABLE(sep_pci_id_tbl) = {
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MRST_PCI_DEVICE_ID)},
 	{PCI_DEVICE(PCI_VENDOR_ID_INTEL, MFLD_PCI_DEVICE_ID)},
@@ -3468,127 +3622,10 @@ MODULE_DEVICE_TABLE(pci, sep_pci_id_tbl);
 static struct pci_driver sep_pci_driver = {
 	.name = "sep_sec_driver",
 	.id_table = sep_pci_id_tbl,
-	.probe = sep_probe
-	/* FIXME: remove handler */
+	.probe = sep_probe,
+	.remove = sep_remove
 };
 
-/* File operation for singleton SEP operations */
-static const struct file_operations singleton_file_operations = {
-	.owner = THIS_MODULE,
-	.unlocked_ioctl = sep_singleton_ioctl,
-	.poll = sep_poll,
-	.open = sep_singleton_open,
-	.release = sep_singleton_release,
-	.mmap = sep_mmap,
-};
-
-/* File operation for daemon operations */
-static const struct file_operations daemon_file_operations = {
-	.owner = THIS_MODULE,
-	.unlocked_ioctl = sep_request_daemon_ioctl,
-	.poll = sep_request_daemon_poll,
-	.open = sep_request_daemon_open,
-	.release = sep_request_daemon_release,
-	.mmap = sep_request_daemon_mmap,
-};
-
-/* The files operations structure of the driver */
-static const struct file_operations sep_file_operations = {
-	.owner = THIS_MODULE,
-	.unlocked_ioctl = sep_ioctl,
-	.poll = sep_poll,
-	.open = sep_open,
-	.release = sep_release,
-	.mmap = sep_mmap,
-};
-
-/**
- *	sep_reconfig_shared_area - reconfigure shared area
- *	@sep: pointer to struct sep_device
- *
- *	Reconfig the shared area between HOST and SEP - needed in case
- *	the DX_CC_Init function was called before OS loading.
- */
-static int sep_reconfig_shared_area(struct sep_device *sep)
-{
-	int ret_val;
-
-	dev_dbg(&sep->pdev->dev, "reconfig shared area start\n");
-
-	/* Send the new SHARED MESSAGE AREA to the SEP */
-	dev_dbg(&sep->pdev->dev, "sending %08llx to sep\n",
-				(unsigned long long)sep->shared_bus);
-
-	sep_write_reg(sep, HW_HOST_HOST_SEP_GPR1_REG_ADDR, sep->shared_bus);
-
-	/* Poll for SEP response */
-	ret_val = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR1_REG_ADDR);
-
-	while (ret_val != 0xffffffff && ret_val != sep->shared_bus)
-		ret_val = sep_read_reg(sep, HW_HOST_SEP_HOST_GPR1_REG_ADDR);
-
-	/* Check the return value (register) */
-	if (ret_val != sep->shared_bus) {
-		dev_warn(&sep->pdev->dev, "could not reconfig shared area\n");
-		dev_warn(&sep->pdev->dev, "result was %x\n", ret_val);
-		ret_val = -ENOMEM;
-	} else
-		ret_val = 0;
-
-	dev_dbg(&sep->pdev->dev, "reconfig shared area end\n");
-	return ret_val;
-}
-
-/**
- *	sep_register_driver_to_fs - register misc devices
- *	@sep: pointer to struct sep_device
- *
- *	This function registers the driver to the file system
- */
-static int sep_register_driver_to_fs(struct sep_device *sep)
-{
-	int ret_val;
-
-	sep->miscdev_sep.minor = MISC_DYNAMIC_MINOR;
-	sep->miscdev_sep.name = SEP_DEV_NAME;
-	sep->miscdev_sep.fops = &sep_file_operations;
-
-	sep->miscdev_singleton.minor = MISC_DYNAMIC_MINOR;
-	sep->miscdev_singleton.name = SEP_DEV_SINGLETON;
-	sep->miscdev_singleton.fops = &singleton_file_operations;
-
-	sep->miscdev_daemon.minor = MISC_DYNAMIC_MINOR;
-	sep->miscdev_daemon.name = SEP_DEV_DAEMON;
-	sep->miscdev_daemon.fops = &daemon_file_operations;
-
-	ret_val = misc_register(&sep->miscdev_sep);
-	if (ret_val) {
-		dev_warn(&sep->pdev->dev, "misc reg fails for SEP %x\n",
-			ret_val);
-		return ret_val;
-	}
-
-	ret_val = misc_register(&sep->miscdev_singleton);
-	if (ret_val) {
-		dev_warn(&sep->pdev->dev, "misc reg fails for sing %x\n",
-			ret_val);
-		misc_deregister(&sep->miscdev_sep);
-		return ret_val;
-	}
-
-	if (!sep->mrst) {
-		ret_val = misc_register(&sep->miscdev_daemon);
-		if (ret_val) {
-			dev_warn(&sep->pdev->dev, "misc reg fails for dmn %x\n",
-				ret_val);
-			misc_deregister(&sep->miscdev_sep);
-			misc_deregister(&sep->miscdev_singleton);
-
-			return ret_val;
-		}
-	}
-	return ret_val;
-}
 
 /**
  *	sep_init - init function
@@ -3597,47 +3634,7 @@ static int sep_register_driver_to_fs(struct sep_device *sep)
  */
 static int __init sep_init(void)
 {
-	int ret_val = 0;
-	struct sep_device *sep = NULL;
-
-	pr_debug("SEP driver: Init start\n");
-
-	ret_val = pci_register_driver(&sep_pci_driver);
-	if (ret_val) {
-		pr_debug("sep_driver:sep_driver_to_device failed, ret_val is %d\n",
-								ret_val);
-		goto end_function;
-	}
-
-	sep = sep_dev;
-
-	init_waitqueue_head(&sep->event);
-	init_waitqueue_head(&sep->event_request_daemon);
-	spin_lock_init(&sep->snd_rply_lck);
-	mutex_init(&sep->sep_mutex);
-	mutex_init(&sep->ioctl_mutex);
-
-	/* The new chip requires ashared area reconfigure */
-	if (sep->pdev->revision == 4) { /* Only for new chip */
-		ret_val = sep_reconfig_shared_area(sep);
-		if (ret_val)
-			goto end_function_unregister_pci;
-	}
-
-	/* Register driver to fs */
-	ret_val = sep_register_driver_to_fs(sep);
-	if (ret_val) {
-		dev_warn(&sep->pdev->dev, "error registering device to file\n");
-		goto end_function_unregister_pci;
-	}
-	goto end_function;
-
-end_function_unregister_pci:
-	pci_unregister_driver(&sep_pci_driver);
-
-end_function:
-	dev_dbg(&sep->pdev->dev, "Init end\n");
-	return ret_val;
+	return pci_register_driver(&sep_pci_driver);
 }
 
 
@@ -3649,33 +3646,7 @@ end_function:
  */
 static void __exit sep_exit(void)
 {
-	struct sep_device *sep;
-
-	sep = sep_dev;
-	pr_debug("Exit start\n");
-
-	/* Unregister from fs */
-	misc_deregister(&sep->miscdev_sep);
-	misc_deregister(&sep->miscdev_singleton);
-	misc_deregister(&sep->miscdev_daemon);
-
-	/* Free the irq */
-	free_irq(sep->pdev->irq, sep);
-
-	/* Unregister the driver */
 	pci_unregister_driver(&sep_pci_driver);
-
-	/* Free the shared area  */
-	if (sep_dev) {
-		sep_unmap_and_free_shared_area(sep_dev);
-		dev_dbg(&sep->pdev->dev,
-			"free pages SEP SHARED AREA\n");
-		iounmap((void *) sep_dev->reg_addr);
-		dev_dbg(&sep->pdev->dev,
-			"iounmap\n");
-	}
-	pr_debug("release_mem_region\n");
-	pr_debug("Exit end\n");
 }
 
 

