Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754903Ab0LLXqa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:46:30 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36028 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754856Ab0LLXq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:28 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: tj@kernel.org, JosephChan@via.com.tw, jgarzik@redhat.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [87/223] sata_via: apply magic FIFO fix to vt6420 too
Message-Id: <20101212234626.BED1DB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:26 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Tejun Heo <tj@kernel.org>

commit b1353e4f40f6179ab26a3bb1b2e1fe29ffe534f5 upstream.

vt6420 has the same FIFO overflow problem as vt6421 when combined with
certain devices.  This patch applies the magic fix to vt6420 too.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Martin Qvist <q@maq.dk>
Reported-by: Peter Zijlstra <peterz@infradead.org>
Cc: Joseph Chan <JosephChan@via.com.tw>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/ata/sata_via.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

Index: linux/drivers/ata/sata_via.c
===================================================================
--- linux.orig/drivers/ata/sata_via.c
+++ linux/drivers/ata/sata_via.c
@@ -538,7 +538,7 @@ static int vt8251_prepare_host(struct pc
 	return 0;
 }
 
-static void svia_configure(struct pci_dev *pdev)
+static void svia_configure(struct pci_dev *pdev, int board_id)
 {
 	u8 tmp8;
 
@@ -577,7 +577,7 @@ static void svia_configure(struct pci_de
 	}
 
 	/*
-	 * vt6421 has problems talking to some drives.  The following
+	 * vt6420/1 has problems talking to some drives.  The following
 	 * is the fix from Joseph Chan <JosephChan@via.com.tw>.
 	 *
 	 * When host issues HOLD, device may send up to 20DW of data
@@ -596,8 +596,9 @@ static void svia_configure(struct pci_de
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
@@ -652,7 +653,7 @@ static int svia_init_one(struct pci_dev
 	if (rc)
 		return rc;
 
-	svia_configure(pdev);
+	svia_configure(pdev, board_id);
 
 	pci_set_master(pdev);
 	return ata_host_activate(host, pdev->irq, ata_bmdma_interrupt,
