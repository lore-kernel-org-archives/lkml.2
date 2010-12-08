Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959Ab0LHBgg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:36:36 -0500
Received: from kroah.org ([198.145.64.141]:48970 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757107Ab0LHBBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:01:16 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:34 2010
Message-Id: <20101208005734.173165509@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:58:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Joseph Chan <JosephChan@via.com.tw>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: [128/289] sata_via: apply magic FIFO fix to vt6420 too
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 drivers/ata/sata_via.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
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


