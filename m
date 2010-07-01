Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932815Ab0GAVfi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 17:35:38 -0400
Received: from kroah.org ([198.145.64.141]:33069 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759230Ab0GAVOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:14:51 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:59 2010
Message-Id: <20100701174259.134155086@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:44:00 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@redhat.com>
Subject: [150/200] sata_via: magic vt6421 fix for transmission problems w/ WD drives
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 8b27ff4cf6d15964aa2987aeb58db4dfb1f87a19 upstream.

vt6421 has problems talking to recent WD drives.  It causes a lot of
transmission errors while high bandwidth transfer as reported in the
following bugzilla entry.

  https://bugzilla.kernel.org/show_bug.cgi?id=15173

Joseph Chan provided the following fix.  I don't have any idea what it
does but I can verify the issue is gone with the patch applied.

Signed-off-by: Tejun Heo <tj@kernel.org>
Originally-from: Joseph Chan <JosephChan@via.com.tw>
Reported-by: Jorrit Tijben <sjorrit@gmail.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/sata_via.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -575,6 +575,19 @@ static void svia_configure(struct pci_de
 		tmp8 |= NATIVE_MODE_ALL;
 		pci_write_config_byte(pdev, SATA_NATIVE_MODE, tmp8);
 	}
+
+	/*
+	 * vt6421 has problems talking to some drives.  The following
+	 * is the magic fix from Joseph Chan <JosephChan@via.com.tw>.
+	 * Please add proper documentation if possible.
+	 *
+	 * https://bugzilla.kernel.org/show_bug.cgi?id=15173
+	 */
+	if (pdev->device == 0x3249) {
+		pci_read_config_byte(pdev, 0x52, &tmp8);
+		tmp8 |= 1 << 2;
+		pci_write_config_byte(pdev, 0x52, tmp8);
+	}
 }
 
 static int svia_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)


