Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933280Ab1D2S6h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 14:58:37 -0400
Received: from kroah.org ([198.145.64.141]:50293 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933130Ab1D2S61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:58:27 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Apr 29 11:56:55 2011
Message-Id: <20110429185655.087982902@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 29 Apr 2011 11:55:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@pobox.com>
Subject: [26/55] libata: Implement ATA_FLAG_NO_DIPM and apply it to mcp65
In-Reply-To: <20110429185706.GA12824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit ae01b2493c3bf03c504c32ac4ebb01d528508db3 upstream.

NVIDIA mcp65 familiy of controllers cause command timeouts when DIPM
is used.  Implement ATA_FLAG_NO_DIPM and apply it.

This problem was reported by Stefan Bader in the following thread.

 http://thread.gmane.org/gmane.linux.ide/48841

stable: applicable to 2.6.37 and 38.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Jeff Garzik <jgarzik@pobox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/ahci.c      |    2 +-
 drivers/ata/libata-eh.c |    6 ++++--
 include/linux/libata.h  |    1 +
 3 files changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -150,7 +150,7 @@ static const struct ata_port_info ahci_p
 	{
 		AHCI_HFLAGS	(AHCI_HFLAG_NO_FPDMA_AA | AHCI_HFLAG_NO_PMP |
 				 AHCI_HFLAG_YES_NCQ),
-		.flags		= AHCI_FLAG_COMMON,
+		.flags		= AHCI_FLAG_COMMON | ATA_FLAG_NO_DIPM,
 		.pio_mask	= ATA_PIO4,
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_ops,
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -3276,6 +3276,7 @@ static int ata_eh_set_lpm(struct ata_lin
 	struct ata_eh_context *ehc = &link->eh_context;
 	struct ata_device *dev, *link_dev = NULL, *lpm_dev = NULL;
 	enum ata_lpm_policy old_policy = link->lpm_policy;
+	bool no_dipm = ap->flags & ATA_FLAG_NO_DIPM;
 	unsigned int hints = ATA_LPM_EMPTY | ATA_LPM_HIPM;
 	unsigned int err_mask;
 	int rc;
@@ -3292,7 +3293,7 @@ static int ata_eh_set_lpm(struct ata_lin
 	 */
 	ata_for_each_dev(dev, link, ENABLED) {
 		bool hipm = ata_id_has_hipm(dev->id);
-		bool dipm = ata_id_has_dipm(dev->id);
+		bool dipm = ata_id_has_dipm(dev->id) && !no_dipm;
 
 		/* find the first enabled and LPM enabled devices */
 		if (!link_dev)
@@ -3349,7 +3350,8 @@ static int ata_eh_set_lpm(struct ata_lin
 
 	/* host config updated, enable DIPM if transitioning to MIN_POWER */
 	ata_for_each_dev(dev, link, ENABLED) {
-		if (policy == ATA_LPM_MIN_POWER && ata_id_has_dipm(dev->id)) {
+		if (policy == ATA_LPM_MIN_POWER && !no_dipm &&
+		    ata_id_has_dipm(dev->id)) {
 			err_mask = ata_dev_set_feature(dev,
 					SETFEATURES_SATA_ENABLE, SATA_DIPM);
 			if (err_mask && err_mask != AC_ERR_DEV) {
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -203,6 +203,7 @@ enum {
 					      * management */
 	ATA_FLAG_SW_ACTIVITY	= (1 << 22), /* driver supports sw activity
 					      * led */
+	ATA_FLAG_NO_DIPM	= (1 << 23), /* host not happy with DIPM */
 
 	/* bits 24:31 of ap->flags are reserved for LLD specific flags */
 


