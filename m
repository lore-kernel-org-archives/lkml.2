Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933584Ab2EWGdE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 02:33:04 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57958 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933559Ab2EWGdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 02:33:00 -0400
From: Liu Ping Fan <kernelfans@gmail.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, qemu-devel@nongnu.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Avi Kivity <avi@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>
Subject: [PATCH 2/2] sched: add virt domain device's driver
Date: Wed, 23 May 2012 14:32:29 +0800
Message-Id: <1337754751-9018-3-git-send-email-kernelfans@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1337754751-9018-1-git-send-email-kernelfans@gmail.com>
References: <1337754751-9018-1-git-send-email-kernelfans@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>

A driver plays with Qemu's emulated "virt domain device". They aims to
export the host numa info to the guest.

--todo:
  A more proper place to archive this driver?

Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
---
 drivers/virtio/Kconfig  |    4 ++
 drivers/virtio/Makefile |    1 +
 drivers/virtio/vsd.c    |  124 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 129 insertions(+), 0 deletions(-)
 create mode 100644 drivers/virtio/vsd.c

diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
index 1a61939..2ab6faa 100644
--- a/drivers/virtio/Kconfig
+++ b/drivers/virtio/Kconfig
@@ -45,5 +45,9 @@ config VIRTIO_BALLOON
 	 platform device driver.
 
  	 If unsure, say N.
+config VIRT_SCHED_DOMAIN
+	tristate "virt sched domain driver (EXPERIMENTAL)"
+	---help---
+	This driver make guest scheduler know the NUMA info on host
 
 endmenu
diff --git a/drivers/virtio/Makefile b/drivers/virtio/Makefile
index 5a4c63c..20a565d 100644
--- a/drivers/virtio/Makefile
+++ b/drivers/virtio/Makefile
@@ -1,4 +1,5 @@
 obj-$(CONFIG_VIRTIO) += virtio.o
+obj-$(CONFIG_VIRT_SCHED_DOMAIN) += vsd.o
 obj-$(CONFIG_VIRTIO_RING) += virtio_ring.o
 obj-$(CONFIG_VIRTIO_MMIO) += virtio_mmio.o
 obj-$(CONFIG_VIRTIO_PCI) += virtio_pci.o
diff --git a/drivers/virtio/vsd.c b/drivers/virtio/vsd.c
new file mode 100644
index 0000000..628dba0
--- /dev/null
+++ b/drivers/virtio/vsd.c
@@ -0,0 +1,124 @@
+/*
+ * PCI driver for qemu virt sched domain device.
+ *
+ * Copyright IBM Corp. 2012
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or later.
+ * See the COPYING file in the top-level directory.
+ *
+ */
+#include <linux/module.h>
+#include <linux/list.h>
+#include <linux/pci.h>
+#include <linux/interrupt.h>
+
+#define PCI_DEVICE_ID_CPUSTATE 0x1010
+struct vsd_regs {
+	/* __vapicid_to_vnode[]; addr wr by gst,rd by hst; content wr by hst,
+	 * rd by gst
+	 */
+	unsigned int apic_to_node;
+	unsigned int smem_size;
+};
+
+struct vsd_stub {
+	struct vsd_regs __iomem *regs;
+};
+
+/* fill in by host */
+s16 __vapicid_to_vnode[MAX_LOCAL_APIC];
+static struct vsd_stub *agent;
+
+extern int rebuild_virt_sd(void);
+
+static irqreturn_t virt_sd_thread_irq(int irq, void *data)
+{
+	rebuild_virt_sd();
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t vsd_irq(int irq, void *data)
+{
+	return IRQ_WAKE_THREAD;
+}
+
+static int __devinit vsd_probe(struct pci_dev *pci_dev,
+	const struct pci_device_id *id)
+{
+	int ret = 0;
+	agent = kzalloc(sizeof(struct vsd_stub), GFP_KERNEL);
+	if (agent == NULL) {
+		ret = -1;
+		goto fail;
+	}
+	ret = pci_enable_device(pci_dev);
+	if (ret) {
+		printk(KERN_WARNING "%s, pci_enable_device fail,ret=0x%x\n",
+			__func__, ret);
+		goto fail;
+	}
+	ret = pci_request_regions(pci_dev, "vsd");
+	if (ret) {
+		printk(KERN_WARNING "%s, pci_request_regions fail,ret=0x%x\n",
+			__func__, ret);
+		goto out_enable_device;
+	}
+	agent->regs = ioremap(pci_dev->resource[0].start,
+		pci_dev->resource[0].end - pci_dev->resource[0].start);
+	if (agent->regs == NULL) {
+		printk(KERN_WARNING "%s, ioremap fail\n", __func__);
+		goto out_req_regions;
+	}
+	agent->regs->apic_to_node = __pa(__vapicid_to_vnode);
+	agent->regs->smem_size = sizeof(__vapicid_to_vnode);
+	ret = request_threaded_irq(pci_dev->irq, vsd_irq, virt_sd_thread_irq,
+		IRQF_SHARED, "virt domain irq", agent);
+	if (ret < 0)
+		goto out_req_regions;
+	return 0;
+out_req_regions:
+	pci_release_regions(pci_dev);
+out_enable_device:
+	pci_disable_device(pci_dev);
+	kfree(agent);
+	agent = NULL;
+fail:
+	printk(KERN_WARNING "%s fail\n", __func__);
+	return ret;
+}
+
+static void __devexit vsd_remove(struct pci_dev *pci_dev)
+{
+}
+
+/* Qumranet donated their vendor ID for devices 0x1000 thru 0x10FF. */
+static DEFINE_PCI_DEVICE_TABLE(pci_vsd_id_table) = {
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_CPUSTATE,
+		PCI_ANY_ID, PCI_ANY_ID,
+		PCI_CLASS_SYSTEM_OTHER, 0,
+		 0 },
+	{ 0 },
+};
+MODULE_DEVICE_TABLE(pci, pci_vsd_id_table);
+
+static struct pci_driver pci_vsd_driver = {
+	.name = "vsd",
+	.id_table = pci_vsd_id_table,
+	.probe = vsd_probe,
+	.remove  = __devexit_p(vsd_remove),
+};
+
+static int __init pci_vsd_init(void)
+{
+	return pci_register_driver(&pci_vsd_driver);
+}
+module_init(pci_vsd_init);
+
+static void __exit pci_vsd_exit(void)
+{
+	pci_unregister_driver(&pci_vsd_driver);
+}
+module_exit(pci_vsd_exit);
+MODULE_DESCRIPTION("vsd");
+MODULE_LICENSE("GPL");
+MODULE_VERSION("1");
-- 
1.7.4.4

