Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab1KXBXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 20:23:46 -0500
Received: from havoc.gtf.org ([69.61.125.42]:46081 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827Ab1KXBXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 20:23:45 -0500
Date: Wed, 23 Nov 2011 20:23:44 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20111124012344.GA2235@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Please pull aab9440453d19c1885fa391d4aafd7705f316247 from
git://github.com/jgarzik/libata-dev.git upstream-linus

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTs2cLCWzCDIBeCsvAQJDIA//cLLKLlfw/KTo53VYqrvVEtFcIHTaeeBU
r8F0VLswOnn7vYqNdl35q6zidJK6KH/A/UO7+hhmT/CRDZky3YZFW1XUDiispp8D
saoUbQqQvdFCUsi7RxSEf1vbVj7Wc/pbH7taFpsvxjzcTBICfAHB0kGqfoz1oS/F
VKJDKZ3z8k16OQYCzRGmMEZwhjzp/+UK/lHdjzCIdvOX38SvqYALfm4jjzFlzWh9
TSUQPhZQ/08K6h28P73wpTXl/r12Qr3SO5Ir1Pk9KOF69ohb7BOzme0N7iWauEzk
qi4shdtxZOAAnImnH/M3Lp+P/gHhJyNQ9FgO+DeV/sZdh0YeDJPLQpkDE/KIdFOQ
Gg670ek2UGzarorn7cfJinLRbblFKuGSrqUPkBulYntSdwOr7Qwt7HGQgpFjkh5A
Hix4OOGVp0F6X9mdaap4YtzjSTpxbzHWrUql4W4v80Vxhd3YHk5F7DMozOfSg3SE
QeI4pocMDgle550/cIY00DTuPRknnQP1g1ZIItjrJsZhNs4UY6jyOz+LWEu2+Zbi
kua748BSk+wm6EgbgCPK0W+T4CQel2LipHLT15RxZGwqdqVligs21QTlMX0WYWdA
sDDyfeWaDPH1FLIpdKAZW56EfiykIiZ3cvCvz8xqTRYs64b9oikAHJmCdWor7joq
rV934ybVLNo=
=Yu/Q
-----END PGP SIGNATURE-----

to receive the following updates:

 drivers/ata/ahci_platform.c |    2 +-
 drivers/ata/libata-sff.c    |    4 ++++
 2 files changed, 5 insertions(+), 1 deletions(-)

Alexander Beregalov (1):
      libata: fix build without BMDMA

Rob Herring (1):
      [libata] ahci_platform: fix DT probing

diff --git a/drivers/ata/ahci_platform.c b/drivers/ata/ahci_platform.c
index ec55595..43b8758 100644
--- a/drivers/ata/ahci_platform.c
+++ b/drivers/ata/ahci_platform.c
@@ -67,7 +67,7 @@ static int __init ahci_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct ahci_platform_data *pdata = dev_get_platdata(dev);
 	const struct platform_device_id *id = platform_get_device_id(pdev);
-	struct ata_port_info pi = ahci_port_info[id->driver_data];
+	struct ata_port_info pi = ahci_port_info[id ? id->driver_data : 0];
 	const struct ata_port_info *ppi[] = { &pi, NULL };
 	struct ahci_host_priv *hpriv;
 	struct ata_host *host;
diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 63d5327..4cadfa2 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -2533,10 +2533,12 @@ static int ata_pci_init_one(struct pci_dev *pdev,
 	if (rc)
 		goto out;
 
+#ifdef CONFIG_ATA_BMDMA
 	if (bmdma)
 		/* prepare and activate BMDMA host */
 		rc = ata_pci_bmdma_prepare_host(pdev, ppi, &host);
 	else
+#endif
 		/* prepare and activate SFF host */
 		rc = ata_pci_sff_prepare_host(pdev, ppi, &host);
 	if (rc)
@@ -2544,10 +2546,12 @@ static int ata_pci_init_one(struct pci_dev *pdev,
 	host->private_data = host_priv;
 	host->flags |= hflags;
 
+#ifdef CONFIG_ATA_BMDMA
 	if (bmdma) {
 		pci_set_master(pdev);
 		rc = ata_pci_sff_activate_host(host, ata_bmdma_interrupt, sht);
 	} else
+#endif
 		rc = ata_pci_sff_activate_host(host, ata_sff_interrupt, sht);
 out:
 	if (rc == 0)
