Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab2DRSq2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 14:46:28 -0400
Received: from havoc.gtf.org ([69.61.125.42]:49419 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790Ab2DRSq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 14:46:26 -0400
Date: Wed, 18 Apr 2012 14:46:24 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20120418184624.GA16313@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


NOTE: Includes important regression fix.  See signed tag message for more.

Please pull 0c8d32c27f5cf6e14ca14b4758d1e994eebd50fd from
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git tag/upstream-linus


to receive the following updates:

 drivers/ata/ata_piix.c         |    2 ++
 drivers/ata/libata-core.c      |    4 ++--
 drivers/ata/libata-scsi.c      |    4 ++--
 drivers/ata/libata-transport.c |    1 +
 drivers/ata/libata.h           |    2 +-
 drivers/ata/sata_mv.c          |    3 ++-
 6 files changed, 10 insertions(+), 6 deletions(-)

Dan Carpenter (1):
      sata_mv: silence an uninitialized variable warning

Dan Williams (1):
      libata: make ata_print_id atomic

Lin Ming (1):
      libata: forbid port runtime pm by default, fixing regression

Seth Heasley (1):
      ata_piix: IDE-mode SATA patch for Intel DH89xxCC DeviceIDs

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 68013f9..7857e8f 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -329,6 +329,8 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	{ 0x8086, 0x8c08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	/* SATA Controller IDE (Lynx Point) */
 	{ 0x8086, 0x8c09, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	/* SATA Controller IDE (DH89xxCC) */
+	{ 0x8086, 0x2326, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
 	{ }	/* terminate list */
 };
 
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index e0bda9f..28db50b 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -95,7 +95,7 @@ static unsigned int ata_dev_set_xfermode(struct ata_device *dev);
 static void ata_dev_xfermask(struct ata_device *dev);
 static unsigned long ata_dev_blacklisted(const struct ata_device *dev);
 
-unsigned int ata_print_id = 1;
+atomic_t ata_print_id = ATOMIC_INIT(1);
 
 struct ata_force_param {
 	const char	*name;
@@ -6029,7 +6029,7 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 
 	/* give ports names and add SCSI hosts */
 	for (i = 0; i < host->n_ports; i++)
-		host->ports[i]->print_id = ata_print_id++;
+		host->ports[i]->print_id = atomic_inc_return(&ata_print_id);
 
 
 	/* Create associated sysfs transport objects  */
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 1ee00c8..93dabdc 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3843,7 +3843,7 @@ int ata_sas_async_port_init(struct ata_port *ap)
 	int rc = ap->ops->port_start(ap);
 
 	if (!rc) {
-		ap->print_id = ata_print_id++;
+		ap->print_id = atomic_inc_return(&ata_print_id);
 		__ata_port_probe(ap);
 	}
 
@@ -3867,7 +3867,7 @@ int ata_sas_port_init(struct ata_port *ap)
 	int rc = ap->ops->port_start(ap);
 
 	if (!rc) {
-		ap->print_id = ata_print_id++;
+		ap->print_id = atomic_inc_return(&ata_print_id);
 		rc = ata_port_probe(ap);
 	}
 
diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
index 74aaee3..c341904 100644
--- a/drivers/ata/libata-transport.c
+++ b/drivers/ata/libata-transport.c
@@ -294,6 +294,7 @@ int ata_tport_add(struct device *parent,
 	device_enable_async_suspend(dev);
 	pm_runtime_set_active(dev);
 	pm_runtime_enable(dev);
+	pm_runtime_forbid(dev);
 
 	transport_add_device(dev);
 	transport_configure_device(dev);
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 2e26fca..9d0fd0b 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -53,7 +53,7 @@ enum {
 	ATA_DNXFER_QUIET	= (1 << 31),
 };
 
-extern unsigned int ata_print_id;
+extern atomic_t ata_print_id;
 extern int atapi_passthru16;
 extern int libata_fua;
 extern int libata_noacpi;
diff --git a/drivers/ata/sata_mv.c b/drivers/ata/sata_mv.c
index 38950ea..7336d4a 100644
--- a/drivers/ata/sata_mv.c
+++ b/drivers/ata/sata_mv.c
@@ -4025,7 +4025,8 @@ static int mv_platform_probe(struct platform_device *pdev)
 	struct ata_host *host;
 	struct mv_host_priv *hpriv;
 	struct resource *res;
-	int n_ports, rc;
+	int n_ports = 0;
+	int rc;
 
 	ata_print_version_once(&pdev->dev, DRV_VERSION);
 
