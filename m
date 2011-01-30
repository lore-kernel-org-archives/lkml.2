Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751829Ab1A3Bba (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 20:31:30 -0500
Received: from proxima.lp0.eu ([81.2.80.65]:37400 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751019Ab1A3Bb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 20:31:29 -0500
Message-ID: <4D44BF64.4060205@simon.arlott.org.uk>
Date: Sun, 30 Jan 2011 01:31:16 +0000
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110116 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: axboe@kernel.dk
CC: Tejun Heo <tj@kernel.org>, jeff@garzik.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kay.sievers@vrfy.org, jack@suse.cz,
        James.Bottomley@HansenPartnership.com
Subject: [PATCH] cdrom: support devices that have check_events but not media_changed
References: <1291838262-21274-1-git-send-email-tj@kernel.org> <1291838262-21274-8-git-send-email-tj@kernel.org> <4D44BE3E.5080107@simon.arlott.org.uk>
In-Reply-To: <4D44BE3E.5080107@simon.arlott.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

93aae17af1172c40c6f74b7294e93a90c3cfaa5d replaced the media_changed op
with the check_events op in drivers/scsi/sr.c

All users that check for the CDC_MEDIA_CHANGED capability try both
the check_events op and the media_changed op, but register_cdrom()
was requiring media_changed.

This patch fixes the capability checking and removes a redundant
check that media_changed != NULL.

The cdrom_select_disc ioctl is also using the two operations, so
they should be required for CDC_SELECT_DISC too.

Signed-off-by: Simon Arlott <simon@fire.lp0.eu>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>
---
 drivers/cdrom/cdrom.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 14033a3..4716d76 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -409,7 +409,9 @@ int register_cdrom(struct cdrom_device_info *cdi)
 	}
 
 	ENSURE(drive_status, CDC_DRIVE_STATUS );
-	ENSURE(media_changed, CDC_MEDIA_CHANGED);
+	if (cdo->check_events == NULL && cdo->media_changed == NULL) {
+		*change_capability = ~(CDC_MEDIA_CHANGED | CDC_SELECT_DISC);
+	}
 	ENSURE(tray_move, CDC_CLOSE_TRAY | CDC_OPEN_TRAY);
 	ENSURE(lock_door, CDC_LOCK);
 	ENSURE(select_speed, CDC_SELECT_SPEED);
@@ -1471,7 +1473,7 @@ int cdrom_media_changed(struct cdrom_device_info *cdi)
 	/* This talks to the VFS, which doesn't like errors - just 1 or 0.  
 	 * Returning "0" is always safe (media hasn't been changed). Do that 
 	 * if the low-level cdrom driver dosn't support media changed. */ 
-	if (cdi == NULL || cdi->ops->media_changed == NULL)
+	if (cdi == NULL)
 		return 0;
 	if (!CDROM_CAN(CDC_MEDIA_CHANGED))
 		return 0;
-- 
1.7.0.4

-- 
Simon Arlott
