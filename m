Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030247Ab2HHKAF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 06:00:05 -0400
Received: from mail.ispras.ru ([83.149.199.43]:42501 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964924Ab2HHKAD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 06:00:03 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Peter Meerwald <pmeerw@pmeerw.net>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Jonathan Cameron <jic23@cam.ac.uk>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2] iio/adjd_s311: Fix potential memory leak in adjd_s311_update_scan_mode()
Date: Wed,  8 Aug 2012 13:58:55 +0400
Message-Id: <1344419935-20885-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.01.1208080911260.9959@pmeerw.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not leak memory by updating pointer with potentially NULL realloc return value.
There is no need to preserve data in the buffer,
so replace krealloc() by kfree()-kmalloc() pair.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/iio/light/adjd_s311.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/light/adjd_s311.c b/drivers/iio/light/adjd_s311.c
index 1cbb449..9a99f43 100644
--- a/drivers/iio/light/adjd_s311.c
+++ b/drivers/iio/light/adjd_s311.c
@@ -271,9 +271,10 @@ static int adjd_s311_update_scan_mode(struct iio_dev *indio_dev,
 	const unsigned long *scan_mask)
 {
 	struct adjd_s311_data *data = iio_priv(indio_dev);
-	data->buffer = krealloc(data->buffer, indio_dev->scan_bytes,
-				GFP_KERNEL);
-	if (!data->buffer)
+
+	kfree(data->buffer);
+	data->buffer = kmalloc(indio_dev->scan_bytes, GFP_KERNEL);
+	if (data->buffer == NULL)
 		return -ENOMEM;
 
 	return 0;
-- 
1.7.9.5

