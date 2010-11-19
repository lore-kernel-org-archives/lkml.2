Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348Ab0KSTTS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 14:19:18 -0500
Received: from havoc.gtf.org ([69.61.125.42]:41025 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754332Ab0KSTTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 14:19:17 -0500
Date: Fri, 19 Nov 2010 14:19:16 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patch] libata fix
Message-ID: <20101119191916.GA30172@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/sata_via.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

Tejun Heo (1):
      sata_via: apply magic FIFO fix to vt6420 too

diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index c215899..8b677bb 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -538,7 +538,7 @@ static int vt8251_prepare_host(struct pci_dev *pdev, struct ata_host **r_host)
 	return 0;
 }
 
-static void svia_configure(struct pci_dev *pdev)
+static void svia_configure(struct pci_dev *pdev, int board_id)
 {
 	u8 tmp8;
 
@@ -577,7 +577,7 @@ static void svia_configure(struct pci_dev *pdev)
 	}
 
 	/*
-	 * vt6421 has problems talking to some drives.  The following
+	 * vt6420/1 has problems talking to some drives.  The following
 	 * is the fix from Joseph Chan <JosephChan@via.com.tw>.
 	 *
 	 * When host issues HOLD, device may send up to 20DW of data
@@ -596,8 +596,9 @@ static void svia_configure(struct pci_dev *pdev)
 	 *
 	 * https://bugzilla.kernel.org/show_bug.cgi?id=15173
 	 * http://article.gmane.org/gmane.linux.ide/46352
+	 * http://thread.gmane.org/gmane.linux.kernel/1062139
 	 */
-	if (pdev->device == 0x3249) {
+	if (board_id == vt6420 || board_id == vt6421) {
 		pci_read_config_byte(pdev, 0x52, &tmp8);
 		tmp8 |= 1 << 2;
 		pci_write_config_byte(pdev, 0x52, tmp8);
@@ -652,7 +653,7 @@ static int svia_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (rc)
 		return rc;
 
-	svia_configure(pdev);
+	svia_configure(pdev, board_id);
 
 	pci_set_master(pdev);
 	return ata_host_activate(host, pdev->irq, ata_bmdma_interrupt,
