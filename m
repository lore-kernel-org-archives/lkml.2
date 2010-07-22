Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262Ab0GVB4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 21:56:45 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39869 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754062Ab0GVB4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 21:56:42 -0400
Date: Thu, 22 Jul 2010 11:56:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>,
        James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: linux-next: manual merge of the block tree with the scsi tree
Message-Id: <20100722115639.e331979e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

Today's linux-next merge of the block tree got a conflict in
drivers/scsi/scsi_error.c between commit
a953809f9d1deb97bb27716d773cadd2feebccf8 ("[SCSI] Log msg when getting
Unit Attention") from the scsi tree and commit
f9ccdfe846639f7a4529ccab78468b2207382380 ("scsi: use REQ_TYPE_FS for
flush request") from the block tree.

Just context changes.  I fixed it up (see below) and can carry the fax as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/scsi/scsi_error.c
index c60cffb,2768bf6..0000000
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@@ -307,33 -307,7 +307,20 @@@ static int scsi_check_sense(struct scsi
  		    (sshdr.asc == 0x04) && (sshdr.ascq == 0x02))
  			return FAILED;
  
 +		if (sshdr.asc == 0x3f && sshdr.ascq == 0x0e)
 +			scmd_printk(KERN_WARNING, scmd,
 +				    "Warning! Received an indication that the "
 +				    "LUN assignments on this target have "
 +				    "changed. The Linux SCSI layer does not "
 +				    "automatically remap LUN assignments.\n");
 +		else if (sshdr.asc == 0x3f)
 +			scmd_printk(KERN_WARNING, scmd,
 +				    "Warning! Received an indication that the "
 +				    "operating parameters on this target have "
 +				    "changed. The Linux SCSI layer does not "
 +				    "automatically adjust these parameters.\n");
 +
- 		if (blk_barrier_rq(scmd->request))
- 			/*
- 			 * barrier requests should always retry on UA
- 			 * otherwise block will get a spurious error
- 			 */
- 			return NEEDS_RETRY;
- 		else
- 			/*
- 			 * for normal (non barrier) commands, pass the
- 			 * UA upwards for a determination in the
- 			 * completion functions
- 			 */
- 			return SUCCESS;
- 
+ 		return NEEDS_RETRY;
  		/* these three are not supported */
  	case COPY_ABORTED:
  	case VOLUME_OVERFLOW:
