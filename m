Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab0LHAq4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:46:56 -0500
Received: from kroah.org ([198.145.64.141]:45952 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755799Ab0LHAqt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:46:49 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:26 2010
Message-Id: <20101208004426.785832221@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:43:30 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Peer Chen <pchen@nvidia.com>,
        Jeff Garzik <jgarzik@redhat.com>,
        Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
Subject: [024/127] ahci,ata_generic: let ata_generic handle new MBP w/ MCP89
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit c6353b4520788e34098bbf61c73fb9618ca7fdd6 upstream.

For yet unknown reason, MCP89 on MBP 7,1 doesn't work w/ ahci under
linux but the controller doesn't require explicit mode setting and
works fine with ata_generic.  Make ahci ignore the controller on MBP
7,1 and let ata_generic take it for now.

Reported in bko#15923.

  https://bugzilla.kernel.org/show_bug.cgi?id=15923

NVIDIA is investigating why ahci mode doesn't work.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Peer Chen <pchen@nvidia.com>
Reported-by: Anders Østhus <grapz666@gmail.com>
Reported-by: Andreas Graf <andreas_graf@csgraf.de>
Reported-by: Benoit Gschwind <gschwind@gnu-log.net>
Reported-by: Damien Cassou <damien.cassou@gmail.com>
Reported-by: tixetsal@juno.com
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Cc: Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/ahci.c        |   10 ++++++++++
 drivers/ata/ata_generic.c |    6 ++++++
 include/linux/pci_ids.h   |    1 +
 3 files changed, 17 insertions(+)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -3037,6 +3037,16 @@ static int ahci_init_one(struct pci_dev
 	if (pdev->vendor == PCI_VENDOR_ID_MARVELL && !marvell_enable)
 		return -ENODEV;
 
+	/*
+	 * For some reason, MCP89 on MacBook 7,1 doesn't work with
+	 * ahci, use ata_generic instead.
+	 */
+	if (pdev->vendor == PCI_VENDOR_ID_NVIDIA &&
+	    pdev->device == PCI_DEVICE_ID_NVIDIA_NFORCE_MCP89_SATA &&
+	    pdev->subsystem_vendor == PCI_VENDOR_ID_APPLE &&
+	    pdev->subsystem_device == 0xcb89)
+		return -ENODEV;
+
 	/* acquire resources */
 	rc = pcim_enable_device(pdev);
 	if (rc)
--- a/drivers/ata/ata_generic.c
+++ b/drivers/ata/ata_generic.c
@@ -169,6 +169,12 @@ static struct pci_device_id ata_generic[
 	{ PCI_DEVICE(PCI_VENDOR_ID_OPTI,   PCI_DEVICE_ID_OPTI_82C558), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_CENATEK,PCI_DEVICE_ID_CENATEK_IDE), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO), },
+	/*
+	 * For some reason, MCP89 on MacBook 7,1 doesn't work with
+	 * ahci, use ata_generic instead.
+	 */
+	{ PCI_VENDOR_ID_NVIDIA, PCI_DEVICE_ID_NVIDIA_NFORCE_MCP89_SATA,
+	  PCI_VENDOR_ID_APPLE, 0xcb89, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_1), },
 	{ PCI_DEVICE(PCI_VENDOR_ID_TOSHIBA,PCI_DEVICE_ID_TOSHIBA_PICCOLO_2),  },
 	/* Must come last. If you add entries adjust this table appropriately */
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1265,6 +1265,7 @@
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP77_IDE       0x0759
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP73_SMBUS     0x07D8
 #define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP79_SMBUS     0x0AA2
+#define PCI_DEVICE_ID_NVIDIA_NFORCE_MCP89_SATA	    0x0D85
 
 #define PCI_VENDOR_ID_IMS		0x10e0
 #define PCI_DEVICE_ID_IMS_TT128		0x9128


