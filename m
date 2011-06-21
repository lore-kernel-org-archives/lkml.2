Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371Ab1FUWzO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 18:55:14 -0400
Received: from smtp-out.google.com ([74.125.121.67]:12300 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756893Ab1FUWzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 18:55:12 -0400
From: Bryan Freed <bfreed@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: jic23@cam.ac.uk, jbrenner@taosinc.com, gregkh@suse.de, arnd@arndb.de,
        Bryan Freed <bfreed@chromium.org>
Subject: [PATCH 2/3] light sensor: Fix a panic in the tsl2563 driver.
Date: Tue, 21 Jun 2011 15:54:56 -0700
Message-Id: <1308696897-25161-2-git-send-email-bfreed@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1308696897-25161-1-git-send-email-bfreed@chromium.org>
References: <1308696897-25161-1-git-send-email-bfreed@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a wrapper for this driver around the IIO_CHAN() wrapper to make channel
parameters more readable.  This fixes a panic caused by the info_masks being
accidentally passed in as channel2 parameters which easily surpass the size
of the iio_modifier_names_light array.

Signed-off-by: Bryan Freed <bfreed@chromium.org>
---
 drivers/staging/iio/light/tsl2563.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/iio/light/tsl2563.c b/drivers/staging/iio/light/tsl2563.c
index 04aa155..d9be19c 100644
--- a/drivers/staging/iio/light/tsl2563.c
+++ b/drivers/staging/iio/light/tsl2563.c
@@ -570,15 +570,16 @@ error_ret:
 	return ret;
 }
 
+#define INFO_MASK (1 << IIO_CHAN_INFO_CALIBSCALE_SEPARATE)
+#define EVENT_MASK (IIO_EV_BIT(IIO_EV_TYPE_THRESH, IIO_EV_DIR_RISING) | \
+		    IIO_EV_BIT(IIO_EV_TYPE_THRESH, IIO_EV_DIR_FALLING))
+#define IIO_CHAN_2563(type, mod, proc, chan, imask, emask) \
+	IIO_CHAN(type, mod, 1, proc, NULL, chan, 0, imask, 0, 0, {}, emask)
+
 static const struct iio_chan_spec tsl2563_channels[] = {
-	IIO_CHAN(IIO_LIGHT, 0, 1, 1, NULL, 0, 0, 0, 0, 0, {}, 0),
-	IIO_CHAN(IIO_INTENSITY, 1, 1, 0, "both", 0,
-		 (1 << IIO_CHAN_INFO_CALIBSCALE_SEPARATE), 0, 0, 0, {},
-		 IIO_EV_BIT(IIO_EV_TYPE_THRESH, IIO_EV_DIR_RISING) |
-		 IIO_EV_BIT(IIO_EV_TYPE_THRESH, IIO_EV_DIR_FALLING)),
-	IIO_CHAN(IIO_INTENSITY, 1, 1, 0, "ir", 1,
-		 (1 << IIO_CHAN_INFO_CALIBSCALE_SEPARATE), 0, 0, 0, {},
-		 0)
+	IIO_CHAN_2563(IIO_LIGHT,     0, 1, 0, 0, 0),
+	IIO_CHAN_2563(IIO_INTENSITY, 1, 0, 0, INFO_MASK, EVENT_MASK),
+	IIO_CHAN_2563(IIO_INTENSITY, 1, 0, 1, INFO_MASK, 0),
 };
 
 static int tsl2563_read_thresh(struct iio_dev *indio_dev,
-- 
1.7.3.1

