Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932343Ab1IPVjY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 17:39:24 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:18436 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079Ab1IPVjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 17:39:23 -0400
X-Greylist: delayed 434 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Sep 2011 17:39:23 EDT
Date: Fri, 16 Sep 2011 16:32:00 -0500
From: Mike Miller <mike.miller@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>
Cc: LKML <linux-kernel@vger.kernel.org>,
        LKML-scsi <linux-scsi@vger.kernel.org>, scameron@beardog.cce.hp.com,
        thenzel@redhat.com
Subject: PATCH [1/1] cciss: auto engage scsi subsystem for tape support
Message-ID: <20110916213200.GA24786@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


commit 608b0262ce818901b931d7e6534aad375c698924
Author: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Date:   Mon Aug 29 13:27:46 2011 -0500

    cciss: auto engage scsi mid-layer

Acked-by: Mike Miller <mike.miller@hp.com>

diff --git a/Documentation/blockdev/cciss.txt b/Documentation/blockdev/cciss.txt
index c00c6a5..7c81283 100644
--- a/Documentation/blockdev/cciss.txt
+++ b/Documentation/blockdev/cciss.txt
@@ -88,14 +88,12 @@ You must enable "SCSI tape drive support for Smart Array 5xxx" and
 "SCSI support" in your kernel configuration to be able to use SCSI
 tape drives with your Smart Array 5xxx controller.
 
-Additionally, note that the driver will not engage the SCSI core at init 
-time.  The driver must be directed to dynamically engage the SCSI core via 
-the /proc filesystem entry which the "block" side of the driver creates as 
-/proc/driver/cciss/cciss* at runtime.  This is because at driver init time, 
-the SCSI core may not yet be initialized (because the driver is a block 
-driver) and attempting to register it with the SCSI core in such a case 
-would cause a hang.  This is best done via an initialization script 
-(typically in /etc/init.d, but could vary depending on distribution). 
+Additionally, note that the driver will engage the SCSI core at init 
+time if any tape drives or medium changers are detected.  The driver may
+also be directed to dynamically engage the SCSI core via the /proc filesystem
+entry which the "block" side of the driver creates as
+/proc/driver/cciss/cciss* at runtime.  This is best done via a script.
+
 For example:
 
 	for x in /proc/driver/cciss/cciss[0-9]*
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 8f4ef65..c945024 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -5126,6 +5126,7 @@ reinit_after_soft_reset:
 	h->cciss_max_sectors = 8192;
 
 	rebuild_lun_table(h, 1, 0);
+	cciss_engage_scsi(h);
 	h->busy_initializing = 0;
 	return 1;
 
diff --git a/drivers/block/cciss_scsi.c b/drivers/block/cciss_scsi.c
index 951a4e3..e820b68 100644
--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -1720,5 +1720,6 @@ static int  cciss_eh_abort_handler(struct scsi_cmnd *scsicmd)
 /* If no tape support, then these become defined out of existence */
 
 #define cciss_scsi_setup(cntl_num)
+#define cciss_engage_scsi(h)
 
 #endif /* CONFIG_CISS_SCSI_TAPE */
