Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280Ab3AIG1l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 01:27:41 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:41735 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071Ab3AIG1i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 01:27:38 -0500
From: "Pandarathil, Vijaymohan R" <vijaymohan.pandarathil@hp.com>
To: Alex Williamson <alex.williamson@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Gleb Natapov <gleb@redhat.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] VFIO-AER: Vfio-pci driver changes for supporting AER
Thread-Topic: [PATCH 1/2] VFIO-AER: Vfio-pci driver changes for supporting
 AER
Thread-Index: AQHN7jI7dpem711Q/kq5KDVD8qeBlA==
Date: Wed, 9 Jan 2013 06:26:16 +0000
Message-ID: <F9E001219150CB45BEDC82A650F360C90149602F@G9W0717.americas.hpqcorp.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [15.201.58.14]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


	- New ioctl which is used to pass the eventfd that is signaled when
          an error occurs in the vfio_pci_device

	- Register pci_error_handler for the vfio_pci driver

	- When the device encounters an error, the error handler registered by
          the vfio_pci driver gets invoked by the AER infrastructure

	- In the error handler, signal the eventfd registered for the device.

	- This results in the qemu eventfd handler getting invoked and
          appropriate action taken for the guest.

Signed-off-by: Vijay Mohan Pandarathil <vijaymohan.pandarathil@hp.com>
---
 drivers/vfio/pci/vfio_pci.c         | 29 +++++++++++++++++++++++++++++
 drivers/vfio/pci/vfio_pci_private.h |  1 +
 drivers/vfio/vfio.c                 |  8 ++++++++
 include/linux/vfio.h                |  1 +
 include/uapi/linux/vfio.h           |  9 +++++++++
 5 files changed, 48 insertions(+)

diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 6c11994..4ae9526 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -207,6 +207,8 @@ static long vfio_pci_ioctl(void *device_data,
 		if (vdev->reset_works)
 			info.flags |= VFIO_DEVICE_FLAGS_RESET;
 
+		info.flags |= VFIO_DEVICE_FLAGS_AER_NOTIFY;
+
 		info.num_regions = VFIO_PCI_NUM_REGIONS;
 		info.num_irqs = VFIO_PCI_NUM_IRQS;
 
@@ -348,6 +350,19 @@ static long vfio_pci_ioctl(void *device_data,
 
 		return ret;
 
+	} else if (cmd == VFIO_DEVICE_SET_ERRFD) {
+		int32_t fd = (int32_t)arg;
+
+		if (fd < 0)
+			return -EINVAL;
+
+		vdev->err_trigger = eventfd_ctx_fdget(fd);
+
+		if (IS_ERR(vdev->err_trigger))
+			return PTR_ERR(vdev->err_trigger);
+
+		return 0;
+
 	} else if (cmd == VFIO_DEVICE_RESET)
 		return vdev->reset_works ?
 			pci_reset_function(vdev->pdev) : -EINVAL;
@@ -527,11 +542,25 @@ static void vfio_pci_remove(struct pci_dev *pdev)
 	kfree(vdev);
 }
 
+static pci_ers_result_t vfio_err_detected(struct pci_dev *pdev,
+				pci_channel_state_t state)
+{
+	struct vfio_pci_device *vdev = vfio_get_vdev(&pdev->dev);
+
+	eventfd_signal(vdev->err_trigger, 1);
+	return PCI_ERS_RESULT_CAN_RECOVER;
+}
+
+static const struct pci_error_handlers vfio_err_handlers = {
+	.error_detected = vfio_err_detected,
+};
+
 static struct pci_driver vfio_pci_driver = {
 	.name		= "vfio-pci",
 	.id_table	= NULL, /* only dynamic ids */
 	.probe		= vfio_pci_probe,
 	.remove		= vfio_pci_remove,
+	.err_handler	= &vfio_err_handlers,
 };
 
 static void __exit vfio_pci_cleanup(void)
diff --git a/drivers/vfio/pci/vfio_pci_private.h b/drivers/vfio/pci/vfio_pci_private.h
index 611827c..daee62f 100644
--- a/drivers/vfio/pci/vfio_pci_private.h
+++ b/drivers/vfio/pci/vfio_pci_private.h
@@ -55,6 +55,7 @@ struct vfio_pci_device {
 	bool			bardirty;
 	struct pci_saved_state	*pci_saved_state;
 	atomic_t		refcnt;
+	struct eventfd_ctx	*err_trigger;
 };
 
 #define is_intx(vdev) (vdev->irq_type == VFIO_PCI_INTX_IRQ_INDEX)
diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
index 56097c6..5ed5a54 100644
--- a/drivers/vfio/vfio.c
+++ b/drivers/vfio/vfio.c
@@ -693,6 +693,14 @@ void *vfio_del_group_dev(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(vfio_del_group_dev);
 
+void *vfio_get_vdev(struct device *dev)
+{
+	struct vfio_device *device = dev_get_drvdata(dev);
+
+	return device->device_data;
+}
+EXPORT_SYMBOL_GPL(vfio_get_vdev);
+
 /**
  * VFIO base fd, /dev/vfio/vfio
  */
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index ab9e862..3c97b03 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -45,6 +45,7 @@ extern int vfio_add_group_dev(struct device *dev,
 			      void *device_data);
 
 extern void *vfio_del_group_dev(struct device *dev);
+extern void *vfio_get_vdev(struct device *dev);
 
 /**
  * struct vfio_iommu_driver_ops - VFIO IOMMU driver callbacks
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index 4758d1b..fa67213 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -147,6 +147,7 @@ struct vfio_device_info {
 	__u32	flags;
 #define VFIO_DEVICE_FLAGS_RESET	(1 << 0)	/* Device supports reset */
 #define VFIO_DEVICE_FLAGS_PCI	(1 << 1)	/* vfio-pci device */
+#define VFIO_DEVICE_FLAGS_AER_NOTIFY (1 << 2)	/* Supports aer notify */
 	__u32	num_regions;	/* Max region index + 1 */
 	__u32	num_irqs;	/* Max IRQ index + 1 */
 };
@@ -288,6 +289,14 @@ struct vfio_irq_set {
  */
 #define VFIO_DEVICE_RESET		_IO(VFIO_TYPE, VFIO_BASE + 11)
 
+/**
+ * VFIO_DEVICE_SET_ERRFD - _IO(VFIO_TYPE, VFIO_BASE + 12)
+ *
+ * Pass the eventfd to the vfio-pci driver for signalling any device
+ * error notifications
+ */
+#define VFIO_DEVICE_SET_ERRFD		_IO(VFIO_TYPE, VFIO_BASE + 12)
+
 /*
  * The VFIO-PCI bus driver makes use of the following fixed region and
  * IRQ index mapping.  Unimplemented regions return a size of zero.
-- 
1.7.11.3

