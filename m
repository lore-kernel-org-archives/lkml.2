Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758218Ab1FAWXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 18:23:43 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59663 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754270Ab1FAWXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 18:23:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=N0795kIzFv1yn5FCuYVUScWJBrlkTOdVunPBJkOAYGEWxWdInr6WdJIjuAkgBKY1Lo
         E6GVEx34+Gxp0ezPFSwsdojS5UMojAeOOIfV/nOHqEKtDTOU0Fsgb1whZdhWuvTkjLrd
         iU+UD/zXGZYwE2z9scMHXNUP7h8RbDx4dnHJE=
From: Andre Bartke <andre.bartke@googlemail.com>
To: gregkh@suse.de
Cc: jic23@cam.ac.uk, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Andre Bartke <andre.bartke@gmail.com>
Subject: [PATCH] staging/iio: error case memory leak fix
Date: Thu,  2 Jun 2011 00:21:45 +0200
Message-Id: <1306966905-13799-1-git-send-email-andre.bartke@gmail.com>
X-Mailer: git-send-email 1.7.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The data pointer should be freed in the error
cases of adis16400_trigger_handler().

Signed-off-by: Andre Bartke <andre.bartke@gmail.com>
---
 drivers/staging/iio/imu/adis16400_ring.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/iio/imu/adis16400_ring.c b/drivers/staging/iio/imu/adis16400_ring.c
index 2589a7e..3612373 100644
--- a/drivers/staging/iio/imu/adis16400_ring.c
+++ b/drivers/staging/iio/imu/adis16400_ring.c
@@ -137,13 +137,13 @@ static irqreturn_t adis16400_trigger_handler(int irq, void *p)
 		if (st->variant->flags & ADIS16400_NO_BURST) {
 			ret = adis16350_spi_read_all(&indio_dev->dev, st->rx);
 			if (ret < 0)
-				return ret;
+				goto err;
 			for (; i < ring->scan_count; i++)
 				data[i]	= *(s16 *)(st->rx + i*2);
 		} else {
 			ret = adis16400_spi_read_burst(&indio_dev->dev, st->rx);
 			if (ret < 0)
-				return ret;
+				goto err;
 			for (; i < indio_dev->ring->scan_count; i++) {
 				j = __ffs(mask);
 				mask &= ~(1 << j);
@@ -158,9 +158,13 @@ static irqreturn_t adis16400_trigger_handler(int irq, void *p)
 	ring->access->store_to(indio_dev->ring, (u8 *) data, pf->timestamp);
 
 	iio_trigger_notify_done(indio_dev->trig);
-	kfree(data);
 
+	kfree(data);
 	return IRQ_HANDLED;
+
+err:
+	kfree(data);
+	return ret;
 }
 
 void adis16400_unconfigure_ring(struct iio_dev *indio_dev)
-- 
1.7.5.2

