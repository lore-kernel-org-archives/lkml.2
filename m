Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760409Ab0KRWsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 17:48:11 -0500
Received: from havoc.gtf.org ([69.61.125.42]:58858 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756542Ab0KRWsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 17:48:10 -0500
Date: Thu, 18 Nov 2010 17:48:02 -0500
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-scsi@vger.kernel.org
Subject: [git patch] libata SCSI locking update
Message-ID: <20101118224802.GA14271@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Selfishly, I think this should go into 2.6.37 rather than 2.6.38, simply
because it is so obviously better for a large number of Linux users.

But I understand if you'd rather wait for 2.6.38.

Please pull from 'upstream-linus' branch of
master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git upstream-linus

to receive the following updates:

 drivers/ata/libata-scsi.c |   21 +++++++++------------
 1 files changed, 9 insertions(+), 12 deletions(-)

Jeff Garzik (1):
      [libata] remove SCSI host lock and serial number usage from ata_scsi_queuecmd

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 19835d3..66aa4be 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3166,8 +3166,8 @@ static inline int __ata_scsi_queuecmd(struct scsi_cmnd *scmd,
 
 /**
  *	ata_scsi_queuecmd - Issue SCSI cdb to libata-managed device
+ *	@shost: SCSI host of command to be sent
  *	@cmd: SCSI command to be sent
- *	@done: Completion function, called when command is complete
  *
  *	In some cases, this function translates SCSI commands into
  *	ATA taskfiles, and queues the taskfiles to be sent to
@@ -3177,42 +3177,39 @@ static inline int __ata_scsi_queuecmd(struct scsi_cmnd *scmd,
  *	ATA and ATAPI devices appearing as SCSI devices.
  *
  *	LOCKING:
- *	Releases scsi-layer-held lock, and obtains host lock.
+ *	ATA host lock
  *
  *	RETURNS:
  *	Return value from __ata_scsi_queuecmd() if @cmd can be queued,
  *	0 otherwise.
  */
-static int ata_scsi_queuecmd_lck(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
+int ata_scsi_queuecmd(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
 {
 	struct ata_port *ap;
 	struct ata_device *dev;
 	struct scsi_device *scsidev = cmd->device;
-	struct Scsi_Host *shost = scsidev->host;
 	int rc = 0;
+	unsigned long irq_flags;
 
 	ap = ata_shost_to_port(shost);
 
-	spin_unlock(shost->host_lock);
-	spin_lock(ap->lock);
+	spin_lock_irqsave(ap->lock, irq_flags);
 
 	ata_scsi_dump_cdb(ap, cmd);
 
 	dev = ata_scsi_find_dev(ap, scsidev);
 	if (likely(dev))
-		rc = __ata_scsi_queuecmd(cmd, done, dev);
+		rc = __ata_scsi_queuecmd(cmd, cmd->scsi_done, dev);
 	else {
 		cmd->result = (DID_BAD_TARGET << 16);
-		done(cmd);
+		cmd->scsi_done(cmd);
 	}
 
-	spin_unlock(ap->lock);
-	spin_lock(shost->host_lock);
+	spin_unlock_irqrestore(ap->lock, irq_flags);
+
 	return rc;
 }
 
-DEF_SCSI_QCMD(ata_scsi_queuecmd)
-
 /**
  *	ata_scsi_simulate - simulate SCSI command on ATA device
  *	@dev: the target device
