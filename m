Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965246Ab2EOCph (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 22:45:37 -0400
Received: from mail.windriver.com ([147.11.1.11]:49731 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965216Ab2EOCRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 22:17:33 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [34-longterm 114/179] hwmon: (max1111) Fix race condition causing NULL pointer exception
Date: Mon, 14 May 2012 22:13:30 -0400
Message-ID: <1337048075-6132-115-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.6
In-Reply-To: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pavel Herrmann <morpheus.ibis@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit d3f684f2820a7f42acef68bea6622d9032127fb2 upstream.

spi_sync call uses its spi_message parameter to keep completion information,
using a drvdata structure is not thread-safe. Use a mutex to prevent
multiple access to shared driver data.

Signed-off-by: Pavel Herrmann <morpheus.ibis@gmail.com>
Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
Acked-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Marek Vasut <marek.vasut@gmail.com>
Acked-by: Cyril Hrubis <metan@ucw.cz>
Tested-by: Stanislav Brabec <utx@penguin.cz>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/hwmon/max1111.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/hwmon/max1111.c b/drivers/hwmon/max1111.c
index 12a54aa..14335bb 100644
--- a/drivers/hwmon/max1111.c
+++ b/drivers/hwmon/max1111.c
@@ -40,6 +40,8 @@ struct max1111_data {
 	struct spi_transfer	xfer[2];
 	uint8_t *tx_buf;
 	uint8_t *rx_buf;
+	struct mutex		drvdata_lock;
+	/* protect msg, xfer and buffers from multiple access */
 };
 
 static int max1111_read(struct device *dev, int channel)
@@ -48,6 +50,9 @@ static int max1111_read(struct device *dev, int channel)
 	uint8_t v1, v2;
 	int err;
 
+	/* writing to drvdata struct is not thread safe, wait on mutex */
+	mutex_lock(&data->drvdata_lock);
+
 	data->tx_buf[0] = (channel << MAX1111_CTRL_SEL_SH) |
 		MAX1111_CTRL_PD0 | MAX1111_CTRL_PD1 |
 		MAX1111_CTRL_SGL | MAX1111_CTRL_UNI | MAX1111_CTRL_STR;
@@ -55,12 +60,15 @@ static int max1111_read(struct device *dev, int channel)
 	err = spi_sync(data->spi, &data->msg);
 	if (err < 0) {
 		dev_err(dev, "spi_sync failed with %d\n", err);
+		mutex_unlock(&data->drvdata_lock);
 		return err;
 	}
 
 	v1 = data->rx_buf[0];
 	v2 = data->rx_buf[1];
 
+	mutex_unlock(&data->drvdata_lock);
+
 	if ((v1 & 0xc0) || (v2 & 0x3f))
 		return -EINVAL;
 
@@ -176,6 +184,8 @@ static int __devinit max1111_probe(struct spi_device *spi)
 	if (err)
 		goto err_free_data;
 
+	mutex_init(&data->drvdata_lock);
+
 	data->spi = spi;
 	spi_set_drvdata(spi, data);
 
@@ -213,6 +223,7 @@ static int __devexit max1111_remove(struct spi_device *spi)
 
 	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&spi->dev.kobj, &max1111_attr_group);
+	mutex_destroy(&data->drvdata_lock);
 	kfree(data->rx_buf);
 	kfree(data->tx_buf);
 	kfree(data);
-- 
1.7.9.6

