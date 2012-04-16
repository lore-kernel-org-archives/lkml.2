Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750993Ab2DPP5y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 11:57:54 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14540 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699Ab2DPP5x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 11:57:53 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Mon, 16 Apr 2012 08:57:52 -0700
From: Laxman Dewangan <ldewangan@nvidia.com>
To: jic23@cam.ac.uk, gregkh@linuxfoundation.org, linux-iio@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Laxman Dewangan <ldewangan@nvidia.com>
Subject: [PATCH] staging: iio: light: isl29028: fix correct mask value
Date: Mon, 16 Apr 2012 21:27:42 +0530
Message-Id: <1334591862-5169-1-git-send-email-ldewangan@nvidia.com>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mask value in the read_raw/write_raw is absolute
value, not the bit position value.
Fixing this in the implemented function to check value,
not with the bit position value.

Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
---
Somehow this was missed on my testing.
I tested today again with linux next and found this issue.

 drivers/staging/iio/light/isl29028.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/iio/light/isl29028.c b/drivers/staging/iio/light/isl29028.c
index e705e45..4e6ac24 100644
--- a/drivers/staging/iio/light/isl29028.c
+++ b/drivers/staging/iio/light/isl29028.c
@@ -272,7 +272,7 @@ static int isl29028_write_raw(struct iio_dev *indio_dev,
 	mutex_lock(&chip->lock);
 	switch (chan->type) {
 	case IIO_PROXIMITY:
-		if (mask != IIO_CHAN_INFO_SAMP_FREQ_SEPARATE_BIT) {
+		if (mask != IIO_CHAN_INFO_SAMP_FREQ) {
 			dev_err(chip->dev,
 				"proximity: mask value 0x%08lx not supported\n",
 				mask);
@@ -294,7 +294,7 @@ static int isl29028_write_raw(struct iio_dev *indio_dev,
 		break;
 
 	case IIO_LIGHT:
-		if (mask != IIO_CHAN_INFO_SCALE_SEPARATE_BIT) {
+		if (mask != IIO_CHAN_INFO_SCALE) {
 			dev_err(chip->dev,
 				"light: mask value 0x%08lx not supported\n",
 				mask);
@@ -349,14 +349,14 @@ static int isl29028_read_raw(struct iio_dev *indio_dev,
 		ret = IIO_VAL_INT;
 		break;
 
-	case IIO_CHAN_INFO_SAMP_FREQ_SEPARATE_BIT:
+	case IIO_CHAN_INFO_SAMP_FREQ:
 		if (chan->type != IIO_PROXIMITY)
 			break;
 		*val = chip->prox_sampling;
 		ret = IIO_VAL_INT;
 		break;
 
-	case IIO_CHAN_INFO_SCALE_SEPARATE_BIT:
+	case IIO_CHAN_INFO_SCALE:
 		if (chan->type != IIO_LIGHT)
 			break;
 		*val = chip->lux_scale;
-- 
1.7.1.1

