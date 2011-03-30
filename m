Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933533Ab1C3WG0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:06:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:4817 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933214Ab1C3VGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="903734052"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: James.Bottomley@suse.de, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [37/275] fix medium error problems with some arrays which can cause data corruption
Message-Id: <20110330210432.A2CA13E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/scsi/sd.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

Index: linux-2.6.35.y/drivers/scsi/sd.c
===================================================================
--- linux-2.6.35.y.orig/drivers/scsi/sd.c	2011-03-29 22:51:54.208336113 -0700
+++ linux-2.6.35.y/drivers/scsi/sd.c	2011-03-29 23:02:58.955326901 -0700
@@ -1111,6 +1111,12 @@
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
@@ -1144,7 +1150,8 @@
 	/* This computation should always be done in terms of
 	 * the resolution of the device's medium.
 	 */
-	return (bad_lba - start_lba) * scmd->device->sector_size;
+	good_bytes = (bad_lba - start_lba) * scmd->device->sector_size;
+	return min(good_bytes, transferred);
 }
 
 /**
