Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab0IRTOl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:14:41 -0400
Received: from kroah.org ([198.145.64.141]:43134 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755939Ab0IRTOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:14:40 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:12:57 2010
Message-Id: <20100918191257.361005249@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:11:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Axel Lin <axel.lin@gmail.com>, Jean Delvare <khali@linux-fr.org>
Subject: [001/129] hwmon: (ads7871) Fix ads7871_probe error paths
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Axel Lin <axel.lin@gmail.com>

commit c12c507d7185fe4e8ada7ed9832957576eefecf8 upstream.

1. remove 'status' variable
2. remove unneeded initialization of 'err' variable
3. return missing error code if sysfs_create_group fail.
4. fix the init sequence as:
   - check hardware existence
   - kzalloc for ads7871_data
   - sysfs_create_group
   - hwmon_device_register

Signed-off-by: Axel Lin <axel.lin@gmail.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/ads7871.c |   38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

--- a/drivers/hwmon/ads7871.c
+++ b/drivers/hwmon/ads7871.c
@@ -160,30 +160,12 @@ static const struct attribute_group ads7
 
 static int __devinit ads7871_probe(struct spi_device *spi)
 {
-	int status, ret, err = 0;
+	int ret, err;
 	uint8_t val;
 	struct ads7871_data *pdata;
 
 	dev_dbg(&spi->dev, "probe\n");
 
-	pdata = kzalloc(sizeof(struct ads7871_data), GFP_KERNEL);
-	if (!pdata) {
-		err = -ENOMEM;
-		goto exit;
-	}
-
-	status = sysfs_create_group(&spi->dev.kobj, &ads7871_group);
-	if (status < 0)
-		goto error_free;
-
-	pdata->hwmon_dev = hwmon_device_register(&spi->dev);
-	if (IS_ERR(pdata->hwmon_dev)) {
-		err = PTR_ERR(pdata->hwmon_dev);
-		goto error_remove;
-	}
-
-	spi_set_drvdata(spi, pdata);
-
 	/* Configure the SPI bus */
 	spi->mode = (SPI_MODE_0);
 	spi->bits_per_word = 8;
@@ -201,6 +183,24 @@ static int __devinit ads7871_probe(struc
 	we need to make sure we really have a chip*/
 	if (val != ret) {
 		err = -ENODEV;
+		goto exit;
+	}
+
+	pdata = kzalloc(sizeof(struct ads7871_data), GFP_KERNEL);
+	if (!pdata) {
+		err = -ENOMEM;
+		goto exit;
+	}
+
+	err = sysfs_create_group(&spi->dev.kobj, &ads7871_group);
+	if (err < 0)
+		goto error_free;
+
+	spi_set_drvdata(spi, pdata);
+
+	pdata->hwmon_dev = hwmon_device_register(&spi->dev);
+	if (IS_ERR(pdata->hwmon_dev)) {
+		err = PTR_ERR(pdata->hwmon_dev);
 		goto error_remove;
 	}
 


