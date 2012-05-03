Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758084Ab2ECS1i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 14:27:38 -0400
Received: from havoc.gtf.org ([69.61.125.42]:37962 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754518Ab2ECS1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 14:27:36 -0400
Date: Thu, 3 May 2012 14:27:35 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20120503182735.GA24318@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull 5f098a3ea72e73ad3733c3280fd5ee04816dc999 from
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git tag/upstream-linus


to receive the following updates:

 Documentation/devicetree/bindings/ata/ahci-platform.txt |   16 +++++++++++++++
 Documentation/devicetree/bindings/ata/calxeda-sata.txt  |   17 ----------------
 drivers/ata/ahci.c                                      |    2 +
 drivers/ata/ahci_platform.c                             |    1 
 drivers/ata/libata-core.c                               |    2 -
 drivers/ata/libata-eh.c                                 |    3 +-
 drivers/ata/pata_arasan_cf.c                            |    4 ---
 7 files changed, 23 insertions(+), 22 deletions(-)

Lin Ming (1):
      libata: skip old error history when counting probe trials

Matt Johnson (1):
      ahci: Detect Marvell 88SE9172 SATA controller

Tero Roponen (1):
      libata: init ata_print_id to 0

Viresh Kumar (2):
      ata/pata_arasan_cf: Move arasan_cf_pm_ops out of #ifdef, #endif macros
      ata: ahci_platform: Add synopsys ahci controller in DT's compatible list


diff --git a/Documentation/devicetree/bindings/ata/ahci-platform.txt b/Documentation/devicetree/bindings/ata/ahci-platform.txt
new file mode 100644
index 0000000..8bb8a76
--- /dev/null
+++ b/Documentation/devicetree/bindings/ata/ahci-platform.txt
@@ -0,0 +1,16 @@
+* AHCI SATA Controller
+
+SATA nodes are defined to describe on-chip Serial ATA controllers.
+Each SATA controller should have its own node.
+
+Required properties:
+- compatible        : compatible list, contains "calxeda,hb-ahci" or "snps,spear-ahci"
+- interrupts        : <interrupt mapping for SATA IRQ>
+- reg               : <registers mapping>
+
+Example:
+        sata@ffe08000 {
+		compatible = "calxeda,hb-ahci";
+                reg = <0xffe08000 0x1000>;
+                interrupts = <115>;
+        };
diff --git a/Documentation/devicetree/bindings/ata/calxeda-sata.txt b/Documentation/devicetree/bindings/ata/calxeda-sata.txt
deleted file mode 100644
index 79caa56..0000000
--- a/Documentation/devicetree/bindings/ata/calxeda-sata.txt
+++ /dev/null
@@ -1,17 +0,0 @@
-* Calxeda SATA Controller
-
-SATA nodes are defined to describe on-chip Serial ATA controllers.
-Each SATA controller should have its own node.
-
-Required properties:
-- compatible        : compatible list, contains "calxeda,hb-ahci"
-- interrupts        : <interrupt mapping for SATA IRQ>
-- reg               : <registers mapping>
-
-Example:
-        sata@ffe08000 {
-		compatible = "calxeda,hb-ahci";
-                reg = <0xffe08000 0x1000>;
-                interrupts = <115>;
-        };
-
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 79a1e9d..ebaf67e 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -394,6 +394,8 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9128 */
 	{ PCI_DEVICE(0x1b4b, 0x9125),
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9125 */
+	{ PCI_DEVICE(0x1b4b, 0x917a),
+	  .driver_data = board_ahci_yes_fbs },			/* 88se9172 */
 	{ PCI_DEVICE(0x1b4b, 0x91a3),
 	  .driver_data = board_ahci_yes_fbs },
 
diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index 0c86c77..9e419e1 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -280,6 +280,7 @@ static struct dev_pm_ops ahci_pm_ops = {
 
 static const struct of_device_id ahci_of_match[] = {
 	{ .compatible = "calxeda,hb-ahci", },
+	{ .compatible = "snps,spear-ahci", },
 	{},
 };
 MODULE_DEVICE_TABLE(of, ahci_of_match);
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 28db50b..23763a1 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -95,7 +95,7 @@ static unsigned int ata_dev_set_xfermode(struct ata_device *dev);
 static void ata_dev_xfermask(struct ata_device *dev);
 static unsigned long ata_dev_blacklisted(const struct ata_device *dev);
 
-atomic_t ata_print_id = ATOMIC_INIT(1);
+atomic_t ata_print_id = ATOMIC_INIT(0);
 
 struct ata_force_param {
 	const char	*name;
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index c61316e..d1fbd59 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -3501,7 +3501,8 @@ static int ata_count_probe_trials_cb(struct ata_ering_entry *ent, void *void_arg
 	u64 now = get_jiffies_64();
 	int *trials = void_arg;
 
-	if (ent->timestamp < now - min(now, interval))
+	if ((ent->eflags & ATA_EFLAG_OLD_ER) ||
+	    (ent->timestamp < now - min(now, interval)))
 		return -1;
 
 	(*trials)++;
diff --git a/drivers/ata/pata_arasan_cf.c b/drivers/ata/pata_arasan_cf.c
index fc2db2a..3239517 100644
--- a/drivers/ata/pata_arasan_cf.c
+++ b/drivers/ata/pata_arasan_cf.c
@@ -943,9 +943,9 @@ static int arasan_cf_resume(struct device *dev)
 
 	return 0;
 }
+#endif
 
 static SIMPLE_DEV_PM_OPS(arasan_cf_pm_ops, arasan_cf_suspend, arasan_cf_resume);
-#endif
 
 static struct platform_driver arasan_cf_driver = {
 	.probe		= arasan_cf_probe,
@@ -953,9 +953,7 @@ static struct platform_driver arasan_cf_driver = {
 	.driver		= {
 		.name	= DRIVER_NAME,
 		.owner	= THIS_MODULE,
-#ifdef CONFIG_PM
 		.pm	= &arasan_cf_pm_ops,
-#endif
 	},
 };
 
