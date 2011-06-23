Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932722Ab1FWS2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:28:38 -0400
Received: from mail.windriver.com ([147.11.1.11]:63034 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932688Ab1FWRWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:22:20 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, James Bottomley <James.Bottomley@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 031/247] fix medium error problems with some arrays which can cause data corruption
Date: Thu, 23 Jun 2011 13:17:54 -0400
Message-Id: <1308849690-14530-32-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Bottomley <James.Bottomley@suse.de>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit a8733c7baf457b071528e385a0b7d4aaec79287c upstream.

Our current handling of medium error assumes that data is returned up
to the bad sector.  This assumption holds good for all disk devices,
all DIF arrays and most ordinary arrays.  However, an LSI array engine
was recently discovered which reports a medium error without returning
any data.  This means that when we report good data up to the medium
error, we've reported junk originally in the buffer as good.  Worse,
if the read consists of requested data plus a readahead, and the error
occurs in readahead, we'll just strip off the readahead and report
junk up to userspace as good data with no error.

The fix for this is to have the error position computation take into
account the amount of data returned by the driver using the scsi
residual data.  Unfortunately, not every driver fills in this data,
but for those who don't, it's set to zero, which means we'll think a
full set of data was transferred and the behaviour will be identical
to the prior behaviour of the code (believe the buffer up to the error
sector).  All modern drivers seem to set the residual, so that should
fix up the LSI failure/corruption case.

Reported-by: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: James Bottomley <James.Bottomley@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/scsi/sd.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 892f446..18e6c59 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1109,6 +1109,12 @@ static unsigned int sd_completed_bytes(struct scsi_cmnd *scmd)
 	u64 end_lba = blk_rq_pos(scmd->request) + (scsi_bufflen(scmd) / 512);
 	u64 bad_lba;
 	int info_valid;
+	/*
+	 * resid is optional but mostly filled in.  When it's unused,
+	 * its value is zero, so we assume the whole buffer transferred
+	 */
+	unsigned int transferred = scsi_bufflen(scmd) - scsi_get_resid(scmd);
+	unsigned int good_bytes;
 
 	if (!blk_fs_request(scmd->request))
 		return 0;
@@ -1142,7 +1148,8 @@ static unsigned int sd_completed_bytes(struct scsi_cmnd *scmd)
 	/* This computation should always be done in terms of
 	 * the resolution of the device's medium.
 	 */
-	return (bad_lba - start_lba) * scmd->device->sector_size;
+	good_bytes = (bad_lba - start_lba) * scmd->device->sector_size;
+	return min(good_bytes, transferred);
 }
 
 /**
-- 
1.7.4.4

