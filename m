Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268Ab0DWCSB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 22:18:01 -0400
Received: from havoc.gtf.org ([69.61.125.42]:47505 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755058Ab0DWCR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 22:17:57 -0400
Date: Thu, 22 Apr 2010 22:17:56 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata fixes
Message-ID: <20100423021756.GA26366@havoc.gtf.org>
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

 Documentation/kernel-parameters.txt |    2 +-
 drivers/ata/libata-eh.c             |    5 +++++
 drivers/ata/pata_pcmcia.c           |    4 ++++
 drivers/ide/ide-cs.c                |    4 ++++
 4 files changed, 14 insertions(+), 1 deletions(-)

Jeff Garzik (1):
      libata: ensure NCQ error result taskfile is fully initialized

Kristoffer Ericson (1):
      pata_pcmcia/ide-cs: add IDs for transcend and kingston cards

Roman Fietze (1):
      libata: fix docs, RE port and device of libata.force ID separated by point

Tejun Heo (1):
      libata: fix locking around blk_abort_request()

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index e2202e9..839b21b 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1194,7 +1194,7 @@ and is between 256 and 4096 characters. It is defined in the file
 
 	libata.force=	[LIBATA] Force configurations.  The format is comma
 			separated list of "[ID:]VAL" where ID is
-			PORT[:DEVICE].  PORT and DEVICE are decimal numbers
+			PORT[.DEVICE].  PORT and DEVICE are decimal numbers
 			matching port, link or device.  Basically, it matches
 			the ATA ID string printed on console by libata.  If
 			the whole ID part is omitted, the last PORT and DEVICE
diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 9f6cfac..228740f 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -879,6 +879,8 @@ static void ata_eh_set_pending(struct ata_port *ap, int fastdrain)
 void ata_qc_schedule_eh(struct ata_queued_cmd *qc)
 {
 	struct ata_port *ap = qc->ap;
+	struct request_queue *q = qc->scsicmd->device->request_queue;
+	unsigned long flags;
 
 	WARN_ON(!ap->ops->error_handler);
 
@@ -890,7 +892,9 @@ void ata_qc_schedule_eh(struct ata_queued_cmd *qc)
 	 * Note that ATA_QCFLAG_FAILED is unconditionally set after
 	 * this function completes.
 	 */
+	spin_lock_irqsave(q->queue_lock, flags);
 	blk_abort_request(qc->scsicmd->request);
+	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 
 /**
@@ -1624,6 +1628,7 @@ void ata_eh_analyze_ncq_error(struct ata_link *link)
 	}
 
 	/* okay, this error is ours */
+	memset(&tf, 0, sizeof(tf));
 	rc = ata_eh_read_log_10h(dev, &tag, &tf);
 	if (rc) {
 		ata_link_printk(link, KERN_ERR, "failed to read log page 10h "
diff --git a/drivers/ata/pata_pcmcia.c b/drivers/ata/pata_pcmcia.c
index 3c3172d..4164dd2 100644
--- a/drivers/ata/pata_pcmcia.c
+++ b/drivers/ata/pata_pcmcia.c
@@ -424,6 +424,8 @@ static struct pcmcia_device_id pcmcia_devices[] = {
 	PCMCIA_DEVICE_PROD_ID12("Hyperstone", "Model1", 0x3d5b9ef5, 0xca6ab420),
 	PCMCIA_DEVICE_PROD_ID12("IBM", "microdrive", 0xb569a6e5, 0xa6d76178),
 	PCMCIA_DEVICE_PROD_ID12("IBM", "IBM17JSSFP20", 0xb569a6e5, 0xf2508753),
+	PCMCIA_DEVICE_PROD_ID12("KINGSTON", "CF CARD 1GB", 0x2e6d1829, 0x3e520e17),
+	PCMCIA_DEVICE_PROD_ID12("KINGSTON", "CF CARD 4GB", 0x2e6d1829, 0x531e7d10),
 	PCMCIA_DEVICE_PROD_ID12("KINGSTON", "CF8GB", 0x2e6d1829, 0xacbe682e),
 	PCMCIA_DEVICE_PROD_ID12("IO DATA", "CBIDE2      ", 0x547e66dc, 0x8671043b),
 	PCMCIA_DEVICE_PROD_ID12("IO DATA", "PCIDE", 0x547e66dc, 0x5c5ab149),
@@ -444,6 +446,8 @@ static struct pcmcia_device_id pcmcia_devices[] = {
 	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS1GCF80", 0x709b1bf1, 0x2a54d4b1),
 	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS2GCF120", 0x709b1bf1, 0x969aa4f2),
 	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS4GCF120", 0x709b1bf1, 0xf54a91c8),
+	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS4GCF133", 0x709b1bf1, 0x9351e59d),
+	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS8GCF133", 0x709b1bf1, 0xb2f89b47),
 	PCMCIA_DEVICE_PROD_ID12("WIT", "IDE16", 0x244e5994, 0x3e232852),
 	PCMCIA_DEVICE_PROD_ID12("WEIDA", "TWTTI", 0xcc7cf69c, 0x212bb918),
 	PCMCIA_DEVICE_PROD_ID1("STI Flash", 0xe4a13209),
diff --git a/drivers/ide/ide-cs.c b/drivers/ide/ide-cs.c
index ab87e4f..defce28 100644
--- a/drivers/ide/ide-cs.c
+++ b/drivers/ide/ide-cs.c
@@ -409,6 +409,8 @@ static struct pcmcia_device_id ide_ids[] = {
 	PCMCIA_DEVICE_PROD_ID12("Hyperstone", "Model1", 0x3d5b9ef5, 0xca6ab420),
 	PCMCIA_DEVICE_PROD_ID12("IBM", "microdrive", 0xb569a6e5, 0xa6d76178),
 	PCMCIA_DEVICE_PROD_ID12("IBM", "IBM17JSSFP20", 0xb569a6e5, 0xf2508753),
+	PCMCIA_DEVICE_PROD_ID12("KINGSTON", "CF CARD 1GB", 0x2e6d1829, 0x3e520e17),
+	PCMCIA_DEVICE_PROD_ID12("KINGSTON", "CF CARD 4GB", 0x2e6d1829, 0x531e7d10),
 	PCMCIA_DEVICE_PROD_ID12("KINGSTON", "CF8GB", 0x2e6d1829, 0xacbe682e),
 	PCMCIA_DEVICE_PROD_ID12("IO DATA", "CBIDE2      ", 0x547e66dc, 0x8671043b),
 	PCMCIA_DEVICE_PROD_ID12("IO DATA", "PCIDE", 0x547e66dc, 0x5c5ab149),
@@ -429,6 +431,8 @@ static struct pcmcia_device_id ide_ids[] = {
 	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS1GCF80", 0x709b1bf1, 0x2a54d4b1),
 	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS2GCF120", 0x709b1bf1, 0x969aa4f2),
 	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS4GCF120", 0x709b1bf1, 0xf54a91c8),
+	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS4GCF133", 0x709b1bf1, 0x9351e59d),
+	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS8GCF133", 0x709b1bf1, 0xb2f89b47),
 	PCMCIA_DEVICE_PROD_ID12("WIT", "IDE16", 0x244e5994, 0x3e232852),
 	PCMCIA_DEVICE_PROD_ID12("WEIDA", "TWTTI", 0xcc7cf69c, 0x212bb918),
 	PCMCIA_DEVICE_PROD_ID1("STI Flash", 0xe4a13209),
