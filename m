Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372Ab2HHGi0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 02:38:26 -0400
Received: from mail.ispras.ru ([83.149.199.43]:41562 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755748Ab2HHGiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 02:38:24 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Peter Meerwald <pmeerw@pmeerw.net>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Jonathan Cameron <jic23@cam.ac.uk>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH] iio/adjd_s311: Fix potential memory leak in adjd_s311_update_scan_mode()
Date: Wed,  8 Aug 2012 10:36:56 +0400
Message-Id: <1344407816-13480-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not leak memory by updating pointer with potentially
NULL realloc return value.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/iio/light/adjd_s311.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/light/adjd_s311.c b/drivers/iio/light/adjd_s311.c
index 1cbb449..0adda5b 100644
--- a/drivers/iio/light/adjd_s311.c
+++ b/drivers/iio/light/adjd_s311.c
@@ -271,12 +271,18 @@ static int adjd_s311_update_scan_mode(struct iio_dev *indio_dev,
 	const unsigned long *scan_mask)
 {
 	struct adjd_s311_data *data = iio_priv(indio_dev);
-	data->buffer = krealloc(data->buffer, indio_dev->scan_bytes,
+	u16 *new_buffer;
+	int ret = 0;
+
+	new_buffer = krealloc(data->buffer, indio_dev->scan_bytes,
 				GFP_KERNEL);
-	if (!data->buffer)
-		return -ENOMEM;
+	if (new_buffer == NULL) {
+		kfree(data->buffer);
+		ret = -ENOMEM;
+	}
+	data->buffer = new_buffer;
 
-	return 0;
+	return ret;
 }
 
 static const struct iio_info adjd_s311_info = {
-- 
1.7.9.5

