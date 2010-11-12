Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203Ab0KLLOv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 06:14:51 -0500
Received: from exprod5og112.obsmtp.com ([64.18.0.24]:40305 "EHLO
	exprod5og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932182Ab0KLLOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 06:14:49 -0500
Subject: [PATCH 07/17] staging/vme/tsi148: fix warning in free_irq
To: Greg KH <greg@kroah.com>
From: Martyn Welch <martyn.welch@ge.com>
Cc: devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        "Emilio G. Cota" <cota@braap.org>, LKML <linux-kernel@vger.kernel.org>,
        Bill Pemberton <wfp5p@virginia.edu>
Date: Fri, 12 Nov 2010 11:14:47 +0000
Message-ID: <20101112111447.11631.53375.stgit@ES-BJ21R4J>
In-Reply-To: <20101112111359.11631.84086.stgit@ES-BJ21R4J>
References: <20101112111359.11631.84086.stgit@ES-BJ21R4J>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio G. Cota <cota@braap.org>

The cookie passed to request_irq isn't the same as the one passed
to free_irq, which results in the following warning:

[   63.243533] WARNING: at kernel/irq/manage.c:899 __free_irq+0x9b/0x17d()
[   63.243533] Hardware name:
[   63.243533] Trying to free already-free IRQ 17
[   63.243533] Modules linked in: vme_tsi148(-) vme e1000e iTCO_wdt iTCO_vendor_support [last unloaded: scsi_wait_scan]
[   63.243533] Pid: 2013, comm: rmmod Not tainted 2.6.35 #2
[   63.243533] Call Trace:
[   63.243533]  [<ffffffff81036ea3>] warn_slowpath_common+0x80/0x98
[   63.243533]  [<ffffffff81036f4f>] warn_slowpath_fmt+0x41/0x43
[   63.243533]  [<ffffffff810678c4>] __free_irq+0x9b/0x17d
[   63.243533]  [<ffffffff810679d9>] free_irq+0x33/0x4e
[   63.243533]  [<ffffffffa004a897>] tsi148_irq_exit+0x6b/0x70 [vme_tsi148]
[...]
[   63.243533] ---[ end trace bbf92311d969efb4 ]---

Fix it by passing the same cookie to both functions.

Signed-off-by: Emilio G. Cota <cota@braap.org>
[martyn.welch@ge.com: modified to remove checkpatch warnings]
Signed-off-by: Martyn Welch <martyn.welch@ge.com>
---

 drivers/staging/vme/bridges/Module.symvers |    0 
 drivers/staging/vme/bridges/vme_tsi148.c   |   11 +++++++----
 2 files changed, 7 insertions(+), 4 deletions(-)
 create mode 100644 drivers/staging/vme/bridges/Module.symvers


diff --git a/drivers/staging/vme/bridges/Module.symvers b/drivers/staging/vme/bridges/Module.symvers
new file mode 100644
index 0000000..e69de29
diff --git a/drivers/staging/vme/bridges/vme_tsi148.c b/drivers/staging/vme/bridges/vme_tsi148.c
index 2f8f399..70c9e41 100644
--- a/drivers/staging/vme/bridges/vme_tsi148.c
+++ b/drivers/staging/vme/bridges/vme_tsi148.c
@@ -374,8 +374,11 @@ static int tsi148_irq_init(struct vme_bridge *tsi148_bridge)
 	return 0;
 }
 
-static void tsi148_irq_exit(struct tsi148_driver *bridge, struct pci_dev *pdev)
+static void tsi148_irq_exit(struct vme_bridge *tsi148_bridge,
+	struct pci_dev *pdev)
 {
+	struct tsi148_driver *bridge = tsi148_bridge->driver_priv;
+
 	/* Turn off interrupts */
 	iowrite32be(0x0, bridge->base + TSI148_LCSR_INTEO);
 	iowrite32be(0x0, bridge->base + TSI148_LCSR_INTEN);
@@ -384,7 +387,7 @@ static void tsi148_irq_exit(struct tsi148_driver *bridge, struct pci_dev *pdev)
 	iowrite32be(0xFFFFFFFF, bridge->base + TSI148_LCSR_INTC);
 
 	/* Detach interrupt handler */
-	free_irq(pdev->irq, pdev);
+	free_irq(pdev->irq, tsi148_bridge);
 }
 
 /*
@@ -2511,7 +2514,7 @@ err_master:
 		kfree(master_image);
 	}
 
-	tsi148_irq_exit(tsi148_device, pdev);
+	tsi148_irq_exit(tsi148_bridge, pdev);
 err_irq:
 err_test:
 	iounmap(tsi148_device->base);
@@ -2583,7 +2586,7 @@ static void tsi148_remove(struct pci_dev *pdev)
 	iowrite32be(0x0, bridge->base + TSI148_LCSR_INTM1);
 	iowrite32be(0x0, bridge->base + TSI148_LCSR_INTM2);
 
-	tsi148_irq_exit(bridge, pdev);
+	tsi148_irq_exit(tsi148_bridge, pdev);
 
 	vme_unregister_bridge(tsi148_bridge);
 


--
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square, Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189
