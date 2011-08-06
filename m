Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964785Ab1HFAMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 20:12:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39685 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932365Ab1HFAME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 20:12:04 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Aug  5 17:04:12 2011
Message-Id: <20110806000412.461024718@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 05 Aug 2011 17:03:27 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Pavel Herrmann <morpheus.ibis@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Pavel Machek <pavel@ucw.cz>, Marek Vasut <marek.vasut@gmail.com>,
        Cyril Hrubis <metan@ucw.cz>, Jean Delvare <khali@linux-fr.org>
Subject: [09/50] hwmon: (max1111) Fix race condition causing NULL pointer exception
In-Reply-To: <20110806000419.GA28392@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Pavel Herrmann <morpheus.ibis@gmail.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/max1111.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/hwmon/max1111.c
+++ b/drivers/hwmon/max1111.c
@@ -39,6 +39,8 @@ struct max1111_data {
 	struct spi_transfer	xfer[2];
 	uint8_t *tx_buf;
 	uint8_t *rx_buf;
+	struct mutex		drvdata_lock;
+	/* protect msg, xfer and buffers from multiple access */
 };
 
 static int max1111_read(struct device *dev, int channel)
@@ -47,6 +49,9 @@ static int max1111_read(struct device *d
 	uint8_t v1, v2;
 	int err;
 
+	/* writing to drvdata struct is not thread safe, wait on mutex */
+	mutex_lock(&data->drvdata_lock);
+
 	data->tx_buf[0] = (channel << MAX1111_CTRL_SEL_SH) |
 		MAX1111_CTRL_PD0 | MAX1111_CTRL_PD1 |
 		MAX1111_CTRL_SGL | MAX1111_CTRL_UNI | MAX1111_CTRL_STR;
@@ -54,12 +59,15 @@ static int max1111_read(struct device *d
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
 
@@ -175,6 +183,8 @@ static int __devinit max1111_probe(struc
 	if (err)
 		goto err_free_data;
 
+	mutex_init(&data->drvdata_lock);
+
 	data->spi = spi;
 	spi_set_drvdata(spi, data);
 
@@ -212,6 +222,7 @@ static int __devexit max1111_remove(stru
 
 	hwmon_device_unregister(data->hwmon_dev);
 	sysfs_remove_group(&spi->dev.kobj, &max1111_attr_group);
+	mutex_destroy(&data->drvdata_lock);
 	kfree(data->rx_buf);
 	kfree(data->tx_buf);
 	kfree(data);


