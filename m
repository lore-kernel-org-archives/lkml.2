Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab0LHT6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 14:58:34 -0500
Received: from hera.kernel.org ([140.211.167.34]:59050 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756543Ab0LHT6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 14:58:32 -0500
From: Tejun Heo <tj@kernel.org>
To: jeff@garzik.org, linux-ide@vger.kernel.org, axboe@kernel.dk,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kay.sievers@vrfy.org, jack@suse.cz,
        James.Bottomley@HansenPartnership.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/8] scsi: fix TUR error handling in sr_media_change()
Date: Wed,  8 Dec 2010 20:57:39 +0100
Message-Id: <1291838262-21274-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1291838262-21274-1-git-send-email-tj@kernel.org>
References: <1291838262-21274-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 08 Dec 2010 19:57:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sr_test_unit_ready() returns 0 iff TUR succeeded - IOW, when media is
present and the device is actually ready, so the return value wouldn't
be zero when TUR ends with sense data. sr_media_change() incorrectly
tests (retval || (scsi_sense_valid(sshdr)...)) when it tries to test
whether TUR failed without sense data or with sense data indicating
media-not-present.

Fix the test using scsi_status_is_good() and update comments.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/scsi/sr.c |   18 +++++++++++-------
 1 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index d7b383c..deb24f0 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -214,13 +214,17 @@ static int sr_media_change(struct cdrom_device_info *cdi, int slot)
 
 	sshdr =  kzalloc(sizeof(*sshdr), GFP_KERNEL);
 	retval = sr_test_unit_ready(cd->device, sshdr);
-	if (retval || (scsi_sense_valid(sshdr) &&
-		       /* 0x3a is medium not present */
-		       sshdr->asc == 0x3a)) {
-		/* Media not present or unable to test, unit probably not
-		 * ready. This usually means there is no disc in the drive.
-		 * Mark as changed, and we will figure it out later once
-		 * the drive is available again.
+	/*
+	 * Media is considered to be present if TUR succeeds or fails with
+	 * sense data indicating something other than media-not-present
+	 * (ASC 0x3a).
+	 */
+	if (!scsi_status_is_good(retval) &&
+	    (!scsi_sense_valid(sshdr) || sshdr->asc == 0x3a)) {
+		/*
+		 * Probably not media in the device.  Mark as changed, and
+		 * we will figure it out later once the drive is available
+		 * again.
 		 */
 		cd->device->changed = 1;
 		/* This will force a flush, if called from check_disk_change */
-- 
1.7.1

