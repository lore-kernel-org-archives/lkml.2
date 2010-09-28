Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933600Ab0I1CGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 22:06:51 -0400
Received: from nm12.bullet.mail.sp2.yahoo.com ([98.139.91.82]:29577 "HELO
	nm12.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933589Ab0I1CGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 22:06:48 -0400
X-Yahoo-Newman-Id: 47092.80424.bm@omp1055.mail.ne1.yahoo.com
X-Yahoo-SMTP: fzDSGlOswBCWnIOrNw7KwwK1j9PqyNbe5PtLKiS4dDU.UNl_t6bdEZu9tTLW
X-YMail-OSG: MzFIVIMVM1n7ayZKjSfR_o9uzLQot2Mg1FfjWewAnaWP14r
 7e2lehS3381BJ0TVKLhP0cEFthw5VqYWCWDd93kawADTyeHUeSAy9o6wUMLL
 ICpb58W6jWmORoylZSBANfjJL1Tmwovj.adhK0rH2e7S88ouhFdO7EJX_5y_
 mK9It9XPvHexWIbYibesXtcoUWBmN81YB0U_sUlCskBsete6FGmK8_Jkp.h_
 Nm8Hnd64ZklPhixVUXEdt7JNWzr2pwlPehHnYDo6STXlaVU646JhfJzEVCAn
 rRYycqKDwiQxzMGJ7BWHDR4kpjvfbc1WLOKJmBQ61qKhF7.6n1w_3U_w-
X-Yahoo-Newman-Property: ymail-3
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Vasu Dev <vasu.dev@linux.intel.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        James Bottomley <James.Bottomley@suse.de>,
        Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <jaxboe@fusionio.com>
Cc: James Smart <james.smart@emulex.com>,
        Andrew Vasquez <andrew.vasquez@qlogic.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>, Joe Eykholt <jeykholt@cisco.com>,
        Christoph Hellwig <hch@lst.de>, Jon Hawley <warthog9@kernel.org>,
        MPTFusionLinux <DL-MPTFusionLinux@lsi.com>,
        "eata.c maintainer" <dario.ballabio@inwind.it>,
        Luben Tuikov <ltuikov@yahoo.com>, mvsas maintainer <kewei@marvell.com>,
        pm8001 maintainer Jack Wang <jack_wang@usish.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [RFC v4 09/19] libata: Remove host_lock unlock() + lock() from ata_scsi_queuecmd()
Date: Mon, 27 Sep 2010 19:06:41 -0700
Message-Id: <1285639601-7385-1-git-send-email-nab@linux-iscsi.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch removes the now legacy host_lock unlock() + lock() optimization
from libata-scsi.c:ata_scsi_queuecmd().  This also includes setting the
of SHT->unlocked_qcmd=1 for libata ata_scsi_queuecmd().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/ata/libata-scsi.c |    4 +---
 include/linux/libata.h    |    1 +
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index a89172c..acb6669 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3161,7 +3161,7 @@ static inline int __ata_scsi_queuecmd(struct scsi_cmnd *scmd,
  *	ATA and ATAPI devices appearing as SCSI devices.
  *
  *	LOCKING:
- *	Releases scsi-layer-held lock, and obtains host lock.
+ *	None
  *
  *	RETURNS:
  *	Return value from __ata_scsi_queuecmd() if @cmd can be queued,
@@ -3177,7 +3177,6 @@ int ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 
 	ap = ata_shost_to_port(shost);
 
-	spin_unlock(shost->host_lock);
 	spin_lock(ap->lock);
 
 	ata_scsi_dump_cdb(ap, cmd);
@@ -3191,7 +3190,6 @@ int ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
 	}
 
 	spin_unlock(ap->lock);
-	spin_lock(shost->host_lock);
 	return rc;
 }
 
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 45fb296..c08a0b9 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -1171,6 +1171,7 @@ extern struct device_attribute *ata_common_sdev_attrs[];
 	.queuecommand		= ata_scsi_queuecmd,		\
 	.can_queue		= ATA_DEF_QUEUE,		\
 	.this_id		= ATA_SHT_THIS_ID,		\
+	.unlocked_qcmd		= 1,				\
 	.cmd_per_lun		= ATA_SHT_CMD_PER_LUN,		\
 	.emulated		= ATA_SHT_EMULATED,		\
 	.use_clustering		= ATA_SHT_USE_CLUSTERING,	\
-- 
1.7.3

