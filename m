Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab0ICXQg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 19:16:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58329 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752057Ab0ICXQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 19:16:35 -0400
Date: Fri, 3 Sep 2010 16:16:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: achew@nvidia.com
Cc: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-i2c@vger.kernel.org, khali@linux-fr.org, ldewangan@nvidia.com
Subject: Re: [PATCH 1/1] iio: ak8975: Add Ak8975 magnetometer sensor
Message-Id: <20100903161623.26ab9c76.akpm@linux-foundation.org>
In-Reply-To: <1283470837-18210-1-git-send-email-achew@nvidia.com>
References: <1283470837-18210-1-git-send-email-achew@nvidia.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  2 Sep 2010 16:40:37 -0700
achew@nvidia.com wrote:

> This is for the Asahi Kasei AK8975 3-axis magnetometer.  It resides within
> the magnetometer section of the IIO subsystem, and implements the raw
> magn_x,y,z attributes, as well as x,y,z factory calibration attributes.
> 
> Signed-off-by: Andrew Chew <achew@nvidia.com>
> ---
>  drivers/staging/iio/magnetometer/Kconfig  |   11 +
>  drivers/staging/iio/magnetometer/Makefile |    1 +
>  drivers/staging/iio/magnetometer/ak8975.c |  521 +++++++++++++++++++++++++++++
>  3 files changed, 533 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/staging/iio/magnetometer/ak8975.c

This is version 2, yes?

It would be nice to provide some accounting of how it differs from
version 1, for those who already reviewed version 1.  The v1->v2 diff
is below.

--- a/drivers/staging/iio/magnetometer/ak8975.c~a
+++ a/drivers/staging/iio/magnetometer/ak8975.c
@@ -192,14 +192,14 @@ static int ak8975_setup(struct i2c_clien
 				   AK8975_REG_CNTL_MODE_SHIFT);
 	if (!status) {
 		dev_err(&client->dev, "Error in setting fuse access mode\n");
-		return false;
+		return -EINVAL;
 	}
 
 	/* Get asa data and store in the device data. */
 	status = ak8975_read_data(client, AK8975_REG_ASAX, 3, buffer);
 	if (!status) {
 		dev_err(&client->dev, "Not able to read asa data\n");
-		return -ENODEV;
+		return -EINVAL;
 	}
 
 	data->asa[0] = buffer[0] & 0xFF;
@@ -236,10 +236,10 @@ static ssize_t store_mode(struct device 
 
 	/* Convert mode string and do some basic sanity checking on it.
 	   only 0 or 1 are valid. */
-	if (strict_strtol(buf, 10, &oval))
+	if (strict_strtoul(buf, 10, &oval))
 		return -EINVAL;
 
-	if ((oval < 0) || (oval > 1)) {
+	if (oval > 1) {
 		dev_err(dev, "mode value is not supported\n");
 		return -EINVAL;
 	}
@@ -320,7 +320,7 @@ static ssize_t show_raw(struct device *d
 				   AK8975_REG_CNTL_MODE_SHIFT);
 	if (!status) {
 		dev_err(&client->dev, "Error in setting operating mode\n");
-		return false;
+		return -EINVAL;
 	}
 
 	/* Wait for the conversion to complete. */
@@ -333,13 +333,13 @@ static ssize_t show_raw(struct device *d
 	}
 	if (!timeout_ms) {
 		dev_err(&client->dev, "Conversion timeout happend\n");
-		return false;
+		return -EINVAL;
 	}
 
 	status = ak8975_read_data(client, AK8975_REG_ST1, 1, &read_status);
 	if (!status) {
 		dev_err(&client->dev, "Error in reading ST1\n");
-		return false;
+		return -EINVAL;
 	}
 
 	if (read_status & AK8975_REG_ST1_DRDY_MASK) {
@@ -347,13 +347,13 @@ static ssize_t show_raw(struct device *d
 					  1, &read_status);
 		if (!status) {
 			dev_err(&client->dev, "Error in reading ST2\n");
-			return false;
+			return -EINVAL;
 		}
 		if (read_status & (AK8975_REG_ST2_DERR_MASK |
 				   AK8975_REG_ST2_HOFL_MASK)) {
 			dev_err(&client->dev, "ST2 status error 0x%x\n",
 				read_status);
-			return false;
+			return -EINVAL;
 		}
 	}
 
@@ -363,7 +363,7 @@ static ssize_t show_raw(struct device *d
 				  (u8 *)&meas_reg);
 	if (!status) {
 		dev_err(&client->dev, "Read axis data fails\n");
-		return false;
+		return -EINVAL;
 	}
 
 	/* Endian conversion of the measured values */
@@ -418,6 +418,11 @@ static int ak8975_probe(struct i2c_clien
 	data->eoc_irq = client->irq;
 	data->eoc_gpio = irq_to_gpio(client->irq);
 
+	if (!data->eoc_gpio) {
+		dev_err(&client->dev, "failed, no valid GPIO\n");
+		goto exit_free;
+	}
+
 	err = gpio_request(data->eoc_gpio, "ak_8975");
 	if (err < 0) {
 		dev_err(&client->dev, "failed to request GPIO %d, error %d\n",
@@ -429,7 +434,6 @@ static int ak8975_probe(struct i2c_clien
 	if (err < 0) {
 		dev_err(&client->dev, "Failed to configure input direction for"
 			" GPIO %d, error %d\n", data->eoc_gpio, err);
-		gpio_free(data->eoc_gpio);
 		goto exit_gpio;
 	}
 
_

