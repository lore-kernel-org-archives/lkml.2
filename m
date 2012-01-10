Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934438Ab2AJXJJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 18:09:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52722 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934383Ab2AJXDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 18:03:22 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 13:56:02 2012
Message-Id: <20120110215602.221866270@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 13:55:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [08/49] bcma: support for suspend and resume
In-Reply-To: <20120110215609.GA22505@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <zajec5@gmail.com>

commit 775ab52142b02237a54184238e922251c59a2b5c upstream.

bcma used to lock up machine without enabling PCI or initializing CC.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/bcma/bcma_private.h |    3 +++
 drivers/bcma/host_pci.c     |   37 +++++++++++++++++++++++++++++++++++++
 drivers/bcma/main.c         |   16 ++++++++++++++++
 3 files changed, 56 insertions(+)

--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -18,6 +18,9 @@ void bcma_bus_unregister(struct bcma_bus
 int __init bcma_bus_early_register(struct bcma_bus *bus,
 				   struct bcma_device *core_cc,
 				   struct bcma_device *core_mips);
+#ifdef CONFIG_PM
+int bcma_bus_resume(struct bcma_bus *bus);
+#endif
 
 /* scan.c */
 int bcma_bus_scan(struct bcma_bus *bus);
--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -224,6 +224,41 @@ static void bcma_host_pci_remove(struct
 	pci_set_drvdata(dev, NULL);
 }
 
+#ifdef CONFIG_PM
+static int bcma_host_pci_suspend(struct pci_dev *dev, pm_message_t state)
+{
+	/* Host specific */
+	pci_save_state(dev);
+	pci_disable_device(dev);
+	pci_set_power_state(dev, pci_choose_state(dev, state));
+
+	return 0;
+}
+
+static int bcma_host_pci_resume(struct pci_dev *dev)
+{
+	struct bcma_bus *bus = pci_get_drvdata(dev);
+	int err;
+
+	/* Host specific */
+	pci_set_power_state(dev, 0);
+	err = pci_enable_device(dev);
+	if (err)
+		return err;
+	pci_restore_state(dev);
+
+	/* Bus specific */
+	err = bcma_bus_resume(bus);
+	if (err)
+		return err;
+
+	return 0;
+}
+#else /* CONFIG_PM */
+# define bcma_host_pci_suspend	NULL
+# define bcma_host_pci_resume	NULL
+#endif /* CONFIG_PM */
+
 static DEFINE_PCI_DEVICE_TABLE(bcma_pci_bridge_tbl) = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x0576) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4331) },
@@ -239,6 +274,8 @@ static struct pci_driver bcma_pci_bridge
 	.id_table = bcma_pci_bridge_tbl,
 	.probe = bcma_host_pci_probe,
 	.remove = bcma_host_pci_remove,
+	.suspend = bcma_host_pci_suspend,
+	.resume = bcma_host_pci_resume,
 };
 
 int __init bcma_host_pci_init(void)
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -240,6 +240,22 @@ int __init bcma_bus_early_register(struc
 	return 0;
 }
 
+#ifdef CONFIG_PM
+int bcma_bus_resume(struct bcma_bus *bus)
+{
+	struct bcma_device *core;
+
+	/* Init CC core */
+	core = bcma_find_core(bus, BCMA_CORE_CHIPCOMMON);
+	if (core) {
+		bus->drv_cc.setup_done = false;
+		bcma_core_chipcommon_init(&bus->drv_cc);
+	}
+
+	return 0;
+}
+#endif
+
 int __bcma_driver_register(struct bcma_driver *drv, struct module *owner)
 {
 	drv->drv.name = drv->name;


