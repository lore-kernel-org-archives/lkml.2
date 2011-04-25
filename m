Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab1DYUWn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:22:43 -0400
Received: from 1wt.eu ([62.212.114.60]:33639 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752590Ab1DYUWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:22:42 -0400
Message-Id: <20110425200233.518226287@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:02:44 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: James Bottomley <James.Bottomley@suse.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 012/173] [SCSI] fix medium error problems with some arrays which can cause data corruption
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: James Bottomley <James.Bottomley@suse.de>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/sd.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1040,6 +1040,12 @@ static unsigned int sd_completed_bytes(s
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
@@ -1073,7 +1079,8 @@ static unsigned int sd_completed_bytes(s
 	/* This computation should always be done in terms of
 	 * the resolution of the device's medium.
 	 */
-	return (bad_lba - start_lba) * scmd->device->sector_size;
+	good_bytes = (bad_lba - start_lba) * scmd->device->sector_size;
+	return min(good_bytes, transferred);
 }
 
 /**


