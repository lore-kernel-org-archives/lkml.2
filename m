Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635Ab2BMTQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 14:16:31 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:36537 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982Ab2BMTQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 14:16:30 -0500
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>,
        Hannes Reinecke <hare@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: scsi_error: do not allow IO errors with certain ILLEGAL_REQUEST sense to be retryable
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <1322857889-2623-1-git-send-email-snitzer@redhat.com>
	<yq1zkf5pfx1.fsf@sermon.lab.mkp.net>
	<20111206212704.GB30719@redhat.com>
	<yq1vcptpdch.fsf@sermon.lab.mkp.net>
	<20111206224218.GA31543@redhat.com>
	<20120213162923.GA29578@redhat.com>
	<yq1d39iipra.fsf@sermon.lab.mkp.net>
	<20120213181359.GA5803@redhat.com>
Date: Mon, 13 Feb 2012 14:16:14 -0500
In-Reply-To: <20120213181359.GA5803@redhat.com> (Mike Snitzer's message of
	"Mon, 13 Feb 2012 13:13:59 -0500")
Message-ID: <yq14nuuilxd.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.110017 (No Gnus v0.17) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090201.4F396183.00E7,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

>> I don't have a fundamental problem with your patch. But since we
>> explicitly handle ILLEGAL REQUEST with 0x20 and 0x24 in sd.c I wonder
>> what's broken? We should disable discard support if the WRITE SAME w/
>> UNMAP fails.

Mike> Yeah, I thought the disabling would be sufficient too.  But
Mike> unfortunately multipath doesn't inspect the request it is retrying
Mike> (after it fails the path the request just failed on).

Well, we shouldn't be returning something that multipath should ever act
on.

I think I understand what's going on. Can you try the following patch?

-- 
Martin K. Petersen	Oracle Linux Engineering


diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b2c95db..4e8d0b6 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -879,6 +879,7 @@ void scsi_io_completion(struct scsi_cmnd *cmd, unsigned int good_bytes)
 				    cmd->cmnd[0] == WRITE_SAME_16 ||
 				    cmd->cmnd[0] == WRITE_SAME)) {
 				description = "Discard failure";
+				error = -EREMOTEIO;
 				action = ACTION_FAIL;
 			} else
 				action = ACTION_FAIL;
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index c691fb5..5f0d383 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -497,6 +497,8 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 		max(sdkp->physical_block_size,
 		    sdkp->unmap_granularity * logical_block_size);
 
+	sdkp->provisioning_mode = mode;
+
 	switch (mode) {
 
 	case SD_LBP_DISABLE:
@@ -524,8 +526,6 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 
 	q->limits.max_discard_sectors = max_blocks * (logical_block_size >> 9);
 	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);
-
-	sdkp->provisioning_mode = mode;
 }
 
 /**
