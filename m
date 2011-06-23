Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933823Ab1FWUxA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 16:53:00 -0400
Received: from havoc.gtf.org ([69.61.125.42]:42487 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932755Ab1FWUw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 16:52:58 -0400
Date: Thu, 23 Jun 2011 16:52:57 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20110623205257.GA2013@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1) regression fix for our SAS brethren still using the old EH (== ipr)

2) new PCI IDs, for which apparently I screwed up the credit.  Do you
want me to redo, or is there some way to annotate without rewriting git
history?

3) expand Pioneer CD-ROM quirks to cover all firmware versions for
   each quirk'd CD-ROM model.

4) speling fix


Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/libata-core.c    |    6 +++---
 drivers/ata/libata-scsi.c    |    6 ++++++
 drivers/ata/pata_marvell.c   |    3 +++
 drivers/ata/sata_dwc_460ex.c |    2 +-
 4 files changed, 13 insertions(+), 4 deletions(-)

Justin P. Mattock (1):
      drivers/ata/sata_dwc_460ex: Fix typo 'corrresponding'

Linus Torvalds (1):
      pata_marvell: Add support for 88SE91A0, 88SE91A4

Nishanth Aravamudan (1):
      libata/sas: only set FROZEN flag if new EH is supported

Tejun Heo (1):
      libata: apply NOSETXFER horkage to the affected Pioneer drives

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 736bee5..000d03a 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4143,9 +4143,9 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	 * Devices which choke on SETXFER.  Applies only if both the
 	 * device and controller are SATA.
 	 */
-	{ "PIONEER DVD-RW  DVRTD08",	"1.00",	ATA_HORKAGE_NOSETXFER },
-	{ "PIONEER DVD-RW  DVR-212D",	"1.28", ATA_HORKAGE_NOSETXFER },
-	{ "PIONEER DVD-RW  DVR-216D",	"1.08", ATA_HORKAGE_NOSETXFER },
+	{ "PIONEER DVD-RW  DVRTD08",	NULL,	ATA_HORKAGE_NOSETXFER },
+	{ "PIONEER DVD-RW  DVR-212D",	NULL,	ATA_HORKAGE_NOSETXFER },
+	{ "PIONEER DVD-RW  DVR-216D",	NULL,	ATA_HORKAGE_NOSETXFER },
 
 	/* End Marker */
 	{ }
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index d51f979..927f968 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3797,6 +3797,12 @@ EXPORT_SYMBOL_GPL(ata_sas_port_alloc);
  */
 int ata_sas_port_start(struct ata_port *ap)
 {
+	/*
+	 * the port is marked as frozen at allocation time, but if we don't
+	 * have new eh, we won't thaw it
+	 */
+	if (!ap->ops->error_handler)
+		ap->pflags &= ~ATA_PFLAG_FROZEN;
 	return 0;
 }
 EXPORT_SYMBOL_GPL(ata_sas_port_start);
diff --git a/drivers/ata/pata_marvell.c b/drivers/ata/pata_marvell.c
index 75a6a0c..5d7f58a 100644
--- a/drivers/ata/pata_marvell.c
+++ b/drivers/ata/pata_marvell.c
@@ -161,6 +161,9 @@ static const struct pci_device_id marvell_pci_tbl[] = {
 	{ PCI_DEVICE(0x11AB, 0x6121), },
 	{ PCI_DEVICE(0x11AB, 0x6123), },
 	{ PCI_DEVICE(0x11AB, 0x6145), },
+	{ PCI_DEVICE(0x1B4B, 0x91A0), },
+	{ PCI_DEVICE(0x1B4B, 0x91A4), },
+
 	{ }	/* terminate list */
 };
 
diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
index 1c4b3aa..dc88a39 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -389,7 +389,7 @@ static void sata_dwc_tf_dump(struct ata_taskfile *tf)
 /*
  * Function: get_burst_length_encode
  * arguments: datalength: length in bytes of data
- * returns value to be programmed in register corrresponding to data length
+ * returns value to be programmed in register corresponding to data length
  * This value is effectively the log(base 2) of the length
  */
 static  int get_burst_length_encode(int datalength)
