Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756272Ab1G1Xxd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 19:53:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:27791 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756155Ab1G1XoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 19:44:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,285,1309762800"; 
   d="scan'208";a="31552483"
From: Andi Kleen <andi@firstfloor.org>
References: <20110728444.299940435@firstfloor.org>
In-Reply-To: <20110728444.299940435@firstfloor.org>
To: morpheus.ibis@gmail.com, rmk+kernel@arm.linux.org.uk, pavel@ucw.cz,
        marek.vasut@gmail.com, metan@ucw.cz, utx@penguin.cz,
        khali@linux-fr.org, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [18/50] hwmon: (max1111) Fix race condition causing NULL pointer
Message-Id: <20110728234422.9D0822403FF@tassilo.jf.intel.com>
Date: Thu, 28 Jul 2011 16:44:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Pavel Herrmann <morpheus.ibis@gmail.com>

[ upstream commit d3f684f2820a7f42acef68bea6622d9032127fb2 ]
 exception

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
Cc: stable@kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>

Index: linux-2.6.35.y/drivers/hwmon/max1111.c
===================================================================
--- linux-2.6.35.y.orig/drivers/hwmon/max1111.c
+++ linux-2.6.35.y/drivers/hwmon/max1111.c
@@ -40,6 +40,8 @@ struct max1111_data {
 	struct spi_transfer	xfer[2];
 	uint8_t *tx_buf;
 	uint8_t *rx_buf;
+	struct mutex		drvdata_lock;
+	/* protect msg, xfer and buffers from multiple access */
 };
 
 static int max1111_read(struct device *dev, int channel)
@@ -48,6 +50,9 @@ static int max1111_read(struct device *d
 	uint8_t v1, v2;
 	int err;
 
+	/* writing to drvdata struct is not thread safe, wait on mutex */
+	mutex_lock(&data->drvdata_lock);
+
 	data->tx_buf[0] = (channel << MAX1111_CTRL_SEL_SH) |
 		MAX1111_CTRL_PD0 | MAX1111_CTRL_PD1 |
 		MAX1111_CTRL_SGL | MAX1111_CTRL_UNI | MAX1111_CTRL_STR;
@@ -55,12 +60,15 @@ static int max1111_read(struct device *d
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
 
@@ -176,6 +184,8 @@ static int __devinit max1111_probe(struc
 	if (err)
 		goto err_free_data;
 
+	mutex_init(&data->drvdata_lock);
+
 	data->spi = spi;
 	spi_set_drvdata(spi, data);
 
@@ -213,6 +223,7 @@ static int __devexit max1111_remove(stru
 
 	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&spi->dev.kobj, &max1111_attr_group);
+	mutex_destroy(&data->drvdata_lock);
 	kfree(data->rx_buf);
 	kfree(data->tx_buf);
 	kfree(data);
