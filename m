Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191Ab1K0CsK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 21:48:10 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53401 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751974Ab1K0CsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 21:48:08 -0500
From: Liu Ping Fan <kernelfans@gmail.com>
To: kvm@vger.kernel.org, qemu-devel@nongnu.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, aliguori@us.ibm.com,
        jan.kiszka@web.de, ryanh@us.ibm.com
Subject: [PATCH] virtio: add a pci driver to notify host the CPU_DEAD event
Date: Sun, 27 Nov 2011 10:47:43 +0800
Message-Id: <1322362063-22569-1-git-send-email-kernelfans@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1322188529-11609-1-git-send-email-kernelfans@gmail.com>
References: <1322188529-11609-1-git-send-email-kernelfans@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>

A driver for qemu device "cpustate". This driver catch the guest
CPU_DEAD event, and notify host.

Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
---
 drivers/virtio/Kconfig         |    6 ++
 drivers/virtio/Makefile        |    1 +
 drivers/virtio/cpustate_stub.c |  154 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 161 insertions(+), 0 deletions(-)
 create mode 100644 drivers/virtio/cpustate_stub.c

diff --git a/drivers/virtio/Kconfig b/drivers/virtio/Kconfig
index 816ed08..96ad253 100644
--- a/drivers/virtio/Kconfig
+++ b/drivers/virtio/Kconfig
@@ -46,4 +46,10 @@ config VIRTIO_BALLOON
 
  	 If unsure, say N.
 
+ config VIRTIO_CPUSTATE
+ 	tristate "Driver to notify host the cpu dead event (EXPERIMENTAL)"
+ 	depends on EXPERIMENTAL
+ 	---help---
+ 	 This drivers provides support to notify host the cpu dead event.
+
 endmenu
diff --git a/drivers/virtio/Makefile b/drivers/virtio/Makefile
index 5a4c63c..06a5ecf 100644
--- a/drivers/virtio/Makefile
+++ b/drivers/virtio/Makefile
@@ -3,3 +3,4 @@ obj-$(CONFIG_VIRTIO_RING) += virtio_ring.o
 obj-$(CONFIG_VIRTIO_MMIO) += virtio_mmio.o
 obj-$(CONFIG_VIRTIO_PCI) += virtio_pci.o
 obj-$(CONFIG_VIRTIO_BALLOON) += virtio_balloon.o
+obj-$(VIRTIO_CPUSTATE) += cpustate_stub.o
diff --git a/drivers/virtio/cpustate_stub.c b/drivers/virtio/cpustate_stub.c
new file mode 100644
index 0000000..614da9d
--- /dev/null
+++ b/drivers/virtio/cpustate_stub.c
@@ -0,0 +1,154 @@
+/*
+ * PCI driver for qemu cpustate device. It notifies host the CPU_DEAD event
+ * in guest.
+ *
+ * Copyright IBM Corp. 2011
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2 or later.
+ * See the COPYING file in the top-level directory.
+ *
+ */
+#include <linux/module.h>
+#include <linux/list.h>
+#include <linux/cpu.h>
+#include <linux/pci.h>
+#include <linux/slab.h>
+#include <linux/interrupt.h>
+#include <linux/spinlock.h>
+
+#define PCI_DEVICE_ID_CPUSTATE 0x1010
+
+struct cpustate_stub_regs {
+	unsigned int cpu_phyid;
+	unsigned int event;
+};
+
+struct cpustate_stub {
+	struct work_struct work;
+
+	unsigned int cpu_phyid;
+	unsigned int event;
+
+	struct cpustate_stub_regs __iomem *regs;
+};
+
+static struct cpustate_stub *agent;
+
+static void cpustate_work(struct work_struct *work)
+{
+	struct cpustate_stub *stub = container_of(work,
+					struct cpustate_stub, work);
+	printk(KERN_INFO "%s,cpu_phyid=0x%x, event=0x%x\n",
+		__func__, stub->cpu_phyid, stub->event);
+	stub->regs->cpu_phyid = stub->cpu_phyid;
+	stub->regs->event = stub->event;
+	barrier();
+}
+
+static int cpu_dead_callback(struct notifier_block *b, unsigned long action,
+				 void *data)
+{
+	unsigned long cpu = (unsigned long)data;
+	int cpu_phyid;
+	switch (action) {
+	case CPU_DEAD:{
+		cpu_phyid = per_cpu(x86_cpu_to_apicid, cpu);
+		agent->cpu_phyid = cpu_phyid;
+		agent->event = CPU_DEAD;
+		schedule_work(&agent->work);
+		break;
+	}
+	default:
+		break;
+	}
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block __cpuinitdata cpu_dead_notifier = {
+	.notifier_call	= cpu_dead_callback,
+	.priority	= 10,
+};
+
+static int __devinit cpustate_probe(struct pci_dev *pci_dev,
+	const struct pci_device_id *id)
+{
+	int ret = 0;
+	agent = kzalloc(sizeof(struct cpustate_stub), GFP_KERNEL);
+	if (agent == NULL) {
+		ret = -1;
+		goto fail;
+	}
+	/* enable the device */
+	ret = pci_enable_device(pci_dev);
+	if (ret) {
+		printk(KERN_WARNING "%s, pci_enable_device fail,ret=0x%x\n",
+			__func__, ret);
+		goto fail;
+	}
+
+	ret = pci_request_regions(pci_dev, "cpustate");
+	if (ret) {
+		printk(KERN_WARNING "%s, pci_request_regions fail,ret=0x%x\n",
+			__func__, ret);
+		goto out_enable_device;
+	}
+
+	agent->regs = ioremap(pci_dev->resource[0].start,
+			pci_dev->resource[0].end - pci_dev->resource[0].start);
+	if (agent->regs == NULL) {
+		printk(KERN_WARNING "%s, ioremap fail\n", __func__);
+		goto out_req_regions;
+	}
+
+	INIT_WORK(&agent->work, cpustate_work);
+	register_cpu_notifier(&cpu_dead_notifier);
+	printk(KERN_INFO "%s, success\n", __func__);
+	return 0;
+
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
+static void __devexit cpustate_remove(struct pci_dev *pci_dev)
+{
+	unregister_cpu_notifier(&cpu_dead_notifier);
+}
+
+/* Qumranet donated their vendor ID for devices 0x1000 thru 0x10FF. */
+static DEFINE_PCI_DEVICE_TABLE(pci_cpustate_id_table) = {
+	{ PCI_VENDOR_ID_IBM, PCI_DEVICE_ID_CPUSTATE,
+		PCI_ANY_ID, PCI_ANY_ID,
+		PCI_CLASS_SYSTEM_OTHER, 0,
+		0 },
+	{ 0 },
+};
+MODULE_DEVICE_TABLE(pci, pci_cpustate_id_table);
+
+static struct pci_driver pci_cpustate_driver = {
+	.name		= "cpustate",
+	.id_table	= pci_cpustate_id_table,
+	.probe		= cpustate_probe,
+	.remove		= __devexit_p(cpustate_remove),
+};
+
+static int __init pci_cpustate_init(void)
+{
+	return pci_register_driver(&pci_cpustate_driver);
+}
+module_init(pci_cpustate_init);
+
+static void __exit pci_cpustate_exit(void)
+{
+	pci_unregister_driver(&pci_cpustate_driver);
+}
+module_exit(pci_cpustate_exit);
+MODULE_DESCRIPTION("cpustate");
+MODULE_LICENSE("GPL");
+MODULE_VERSION("1");
-- 
1.7.4.4

