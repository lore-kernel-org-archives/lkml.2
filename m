Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab2GASTe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 14:19:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:47042 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932386Ab2GASQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 14:16:47 -0400
Message-Id: <20120701172012.078559139@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 01 Jul 2012 18:20:44 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Stern <stern@rowland.harvard.edu>,
        Hans de Goede <hdegoede@redhat.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 38/48] SCSI & usb-storage: add try_rc_10_first flag
In-Reply-To: <20120701172006.535271340@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 6a0bdffa0073857870a4ed1b4489762146359eb4 upstream.

Several bug reports have been received recently for USB mass-storage
devices that don't handle READ CAPACITY(16) commands properly.  They
report bogus sizes, in some cases becoming unusable as a result.

The bugs were triggered by commit
09b6b51b0b6c1b9bb61815baf205e4d74c89ff04 (SCSI & usb-storage: add
flags for VPD pages and REPORT LUNS), which caused usb-storage to stop
overriding the SCSI level reported by devices.  By default, the sd
driver will try READ CAPACITY(16) first for any device whose level is
above SCSI_SPC_2.

It seems likely that any device large enough to require the use of
READ CAPACITY(16) (i.e., 2 TB or more) would be able to handle READ
CAPACITY(10) commands properly.  Indeed, I don't know of any devices
that don't handle READ CAPACITY(10) properly.

Therefore this patch (as1559) adds a new flag telling the sd driver
to try READ CAPACITY(10) before READ CAPACITY(16), and sets this flag
for every USB mass-storage device.  If a device really is larger than
2 TB, sd will fall back to READ CAPACITY(16) just as it used to.

This fixes Bugzilla #43391.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Hans de Goede <hdegoede@redhat.com>
CC: "James E.J. Bottomley" <JBottomley@parallels.com>
CC: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/scsi/sd.c              |    2 ++
 drivers/usb/storage/scsiglue.c |    6 ++++++
 include/scsi/scsi_device.h     |    1 +
 3 files changed, 9 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 6f0a4c6..6f72b80 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1899,6 +1899,8 @@ static int sd_try_rc16_first(struct scsi_device *sdp)
 {
 	if (sdp->host->max_cmd_len < 16)
 		return 0;
+	if (sdp->try_rc_10_first)
+		return 0;
 	if (sdp->scsi_level > SCSI_SPC_2)
 		return 1;
 	if (scsi_device_protection(sdp))
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index a324a5d..11418da 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -202,6 +202,12 @@ static int slave_configure(struct scsi_device *sdev)
 		if (us->fflags & US_FL_NO_READ_CAPACITY_16)
 			sdev->no_read_capacity_16 = 1;
 
+		/*
+		 * Many devices do not respond properly to READ_CAPACITY_16.
+		 * Tell the SCSI layer to try READ_CAPACITY_10 first.
+		 */
+		sdev->try_rc_10_first = 1;
+
 		/* assume SPC3 or latter devices support sense size > 18 */
 		if (sdev->scsi_level > SCSI_SPC_2)
 			us->fflags |= US_FL_SANE_SENSE;
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 6efb2e1..ba96988 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -151,6 +151,7 @@ struct scsi_device {
 					   SD_LAST_BUGGY_SECTORS */
 	unsigned no_read_disc_info:1;	/* Avoid READ_DISC_INFO cmds */
 	unsigned no_read_capacity_16:1; /* Avoid READ_CAPACITY_16 cmds */
+	unsigned try_rc_10_first:1;	/* Try READ_CAPACACITY_10 first */
 	unsigned is_visible:1;	/* is the device visible in sysfs */
 
 	DECLARE_BITMAP(supported_events, SDEV_EVT_MAXBITS); /* supported events */


