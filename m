Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab2BHRc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 12:32:26 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55791 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964Ab2BHRcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 12:32:24 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] cdrom: move shared static to cdrom_device_info
Date: Wed,  8 Feb 2012 18:32:08 +0100
Message-Id: <1328722329-22728-1-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The keeplocked variable in the cdrom driver is shared across multiple
drives, but set in per-device ioctls.  Move it to the per-device struct,
avoiding that the setting on one drive affects the driver's behavior
when closing another.

[ Impact: limit udev's confusion to one drive when a CD burning program
  unlocks the CD door at the end of burning. ]

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	Would this be acceptable for 3.3?

 drivers/cdrom/cdrom.c |   12 +++++-------
 include/linux/cdrom.h |    3 ++-
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/cdrom/cdrom.c b/drivers/cdrom/cdrom.c
index 129af31..bed4d06 100644
--- a/drivers/cdrom/cdrom.c
+++ b/drivers/cdrom/cdrom.c
@@ -286,8 +286,6 @@
 
 /* used to tell the module to turn on full debugging messages */
 static int debug;
-/* used to keep tray locked at all times */
-static int keeplocked;
 /* default compatibility mode */
 static int autoclose=1;
 static int autoeject;
@@ -1204,7 +1202,7 @@ void cdrom_release(struct cdrom_device_info *cdi, fmode_t mode)
 		cdinfo(CD_CLOSE, "Use count for \"/dev/%s\" now zero\n", cdi->name);
 		cdrom_dvd_rw_close_write(cdi);
 
-		if ((cdo->capability & CDC_LOCK) && !keeplocked) {
+		if ((cdo->capability & CDC_LOCK) && !cdi->keeplocked) {
 			cdinfo(CD_CLOSE, "Unlocking door!\n");
 			cdo->lock_door(cdi, 0);
 		}
@@ -1371,7 +1369,7 @@ static int cdrom_select_disc(struct cdrom_device_info *cdi, int slot)
 	curslot = info->hdr.curslot;
 	kfree(info);
 
-	if (cdi->use_count > 1 || keeplocked) {
+	if (cdi->use_count > 1 || cdi->keeplocked) {
 		if (slot == CDSL_CURRENT) {
 	    		return curslot;
 		} else {
@@ -2295,7 +2293,7 @@ static int cdrom_ioctl_eject(struct cdrom_device_info *cdi)
 
 	if (!CDROM_CAN(CDC_OPEN_TRAY))
 		return -ENOSYS;
-	if (cdi->use_count != 1 || keeplocked)
+	if (cdi->use_count != 1 || cdi->keeplocked)
 		return -EBUSY;
 	if (CDROM_CAN(CDC_LOCK)) {
 		int ret = cdi->ops->lock_door(cdi, 0);
@@ -2322,7 +2320,7 @@ static int cdrom_ioctl_eject_sw(struct cdrom_device_info *cdi,
 
 	if (!CDROM_CAN(CDC_OPEN_TRAY))
 		return -ENOSYS;
-	if (keeplocked)
+	if (cdi->keeplocked)
 		return -EBUSY;
 
 	cdi->options &= ~(CDO_AUTO_CLOSE | CDO_AUTO_EJECT);
@@ -2453,7 +2451,7 @@ static int cdrom_ioctl_lock_door(struct cdrom_device_info *cdi,
 	if (!CDROM_CAN(CDC_LOCK))
 		return -EDRIVE_CANT_DO_THIS;
 
-	keeplocked = arg ? 1 : 0;
+	cdi->keeplocked = arg ? 1 : 0;
 
 	/*
 	 * Don't unlock the door on multiple opens by default, but allow
diff --git a/include/linux/cdrom.h b/include/linux/cdrom.h
index 35eae4b..7c48029 100644
--- a/include/linux/cdrom.h
+++ b/include/linux/cdrom.h
@@ -952,7 +952,8 @@ struct cdrom_device_info {
     	char name[20];                  /* name of the device type */
 /* per-device flags */
         __u8 sanyo_slot		: 2;	/* Sanyo 3 CD changer support */
-        __u8 reserved		: 6;	/* not used yet */
+        __u8 keeplocked		: 1;	/* CDROM_LOCKDOOR status */
+        __u8 reserved		: 5;	/* not used yet */
 	int cdda_method;		/* see flags */
 	__u8 last_sense;
 	__u8 media_written;		/* dirty flag, DVD+RW bookkeeping */
-- 
1.7.7.6

