Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754163Ab2CLBRD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 21:17:03 -0400
Received: from mga03.intel.com ([143.182.124.21]:45038 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670Ab2CLBQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 21:16:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="76231946"
Subject: [PATCH] libata: disable runtime pm for hotpluggable port
From: Lin Ming <ming.m.lin@intel.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        jslaby@suse.cz, cwillu@cwillu.com, jackdachef@gmail.com
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Mar 2012 09:16:52 +0800
Message-ID: <1331515012.3412.37.camel@minggr>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, hotplug doesn't work if port is already runtime suspended.
For now, we simply disable runtime pm for hotpluggable port.
Later, we should add runtime pm support for hotpluggable port too.

https://lkml.org/lkml/2012/2/19/70

TODO: add similar hotpluggable port check for controllers other than AHCI.

Reported-and-tested-by: Jiri Slaby <jslaby@suse.cz>
Reported-and-tested-by: cwillu@cwillu.com
Reported-and-tested-by: jackdachef@gmail.com
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 drivers/ata/ahci.c             |    3 +++
 drivers/ata/ahci.h             |    3 +++
 drivers/ata/libahci.c          |   20 ++++++++++++++++++++
 drivers/ata/libata-transport.c |    6 ++++--
 include/linux/libata.h         |    4 +++-
 5 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index fb659c8..fb7de91 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -1153,6 +1153,9 @@ static int ahci_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (hpriv->cap & HOST_CAP_PMP)
 		pi.flags |= ATA_FLAG_PMP;
 
+	if (hpriv->cap & HOST_CAP_SXS)
+		pi.flags |= ATA_FLAG_EXTERNAL;
+
 	ahci_set_em_messages(hpriv, &pi);
 
 	if (ahci_broken_system_poweroff(pdev)) {
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index b175000..92f7172 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -172,6 +172,9 @@ enum {
 	PORT_CMD_ALPE		= (1 << 26), /* Aggressive Link PM enable */
 	PORT_CMD_ATAPI		= (1 << 24), /* Device is ATAPI */
 	PORT_CMD_FBSCP		= (1 << 22), /* FBS Capable Port */
+	PORT_CMD_ESP		= (1 << 21), /* External SATA Port */
+	PORT_CMD_MPSP		= (1 << 19), /* Mechanical Presence Switch Attached to Port */
+	PORT_CMD_HPCP		= (1 << 18), /* Hot Plug Capable Port */
 	PORT_CMD_PMP		= (1 << 17), /* PMP attached */
 	PORT_CMD_LIST_ON	= (1 << 15), /* cmd list DMA engine running */
 	PORT_CMD_FIS_ON		= (1 << 14), /* FIS DMA engine running */
diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index a72bfd0..7d72d3c 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -1097,6 +1097,23 @@ static void ahci_port_init(struct device *dev, struct ata_port *ap,
 	writel(1 << port_no, mmio + HOST_IRQ_STAT);
 }
 
+static bool ahci_port_pluggable(struct ata_port *ap)
+{
+	void __iomem *port_mmio = ahci_port_base(ap);
+	u32 cmd;
+
+	cmd = readl(port_mmio + PORT_CMD);
+
+	if ((ap->flags & ATA_FLAG_EXTERNAL) &&
+	    (cmd & PORT_CMD_ESP))
+		return true;
+
+	if (cmd & (PORT_CMD_MPSP | PORT_CMD_HPCP))
+		return true;
+
+	return false;
+}
+
 void ahci_init_controller(struct ata_host *host)
 {
 	struct ahci_host_priv *hpriv = host->private_data;
@@ -1112,6 +1129,9 @@ void ahci_init_controller(struct ata_host *host)
 		if (ata_port_is_dummy(ap))
 			continue;
 
+		if (ahci_port_pluggable(ap))
+			ap->flags |= ATA_FLAG_PLUGGABLE;
+
 		ahci_port_init(host->dev, ap, i, mmio, port_mmio);
 	}
 
diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
index 74aaee3..a7166b9 100644
--- a/drivers/ata/libata-transport.c
+++ b/drivers/ata/libata-transport.c
@@ -292,8 +292,10 @@ int ata_tport_add(struct device *parent,
 	}
 
 	device_enable_async_suspend(dev);
-	pm_runtime_set_active(dev);
-	pm_runtime_enable(dev);
+	if (!(ap->flags & ATA_FLAG_PLUGGABLE)) {
+		pm_runtime_set_active(dev);
+		pm_runtime_enable(dev);
+	}
 
 	transport_add_device(dev);
 	transport_configure_device(dev);
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 3085bdc..ccf0282 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -209,8 +209,10 @@ enum {
 	ATA_FLAG_SW_ACTIVITY	= (1 << 22), /* driver supports sw activity
 					      * led */
 	ATA_FLAG_NO_DIPM	= (1 << 23), /* host not happy with DIPM */
+	ATA_FLAG_EXTERNAL	= (1 << 24), /* controller supports external SATA */
+	ATA_FLAG_PLUGGABLE	= (1 << 25), /* port is hotpluggable */
 
-	/* bits 24:31 of ap->flags are reserved for LLD specific flags */
+	/* bits 26:31 of ap->flags are reserved for LLD specific flags */
 
 
 	/* struct ata_port pflags */
-- 
1.7.2.5



