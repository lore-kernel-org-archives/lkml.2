Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282Ab0JVTwI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 15:52:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36552 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755333Ab0JVTwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 15:52:06 -0400
Date: Fri, 22 Oct 2010 12:51:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isl29020: ambient light sensor
Message-Id: <20101022125130.064710ba.akpm@linux-foundation.org>
In-Reply-To: <20101022124554.19822.58177.stgit@localhost.localdomain>
References: <20101022124554.19822.58177.stgit@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Oct 2010 13:46:07 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> From: Kalhan Trisal <kalhan.trisal@intel.com>
> 
> The LS driver will read the latest Lux measurement based upon the
> light brightness and will report the LUX output through sysfs interface.
> 
> This hardware isn't quite the same as the ISL29003 so has a different driver.
> 
>
> ...
>
> +static ssize_t als_lux_input_data_show(struct device *dev,
> +			struct device_attribute *attr, char *buf)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	int ret_val, val;
> +	unsigned long int lux;
> +	int temp;
> +
> +	pm_runtime_get_sync(dev);
> +	msleep(100);

The msleep() is a bit mysterious.  And long!  A little code comment
explaining why it's here would illuminate things (heh, I kill me).

> +	mutex_lock(&mutex);
> +	temp = i2c_smbus_read_byte_data(client, 0x02); /* MSB data */
> +	if (temp < 0) {
> +		pm_runtime_put_sync(dev);
> +		mutex_unlock(&mutex);
> +		return temp;
> +	}
> +
> +	ret_val = i2c_smbus_read_byte_data(client, 0x01); /* LSB data */
> +	mutex_unlock(&mutex);
> +
> +	if (ret_val < 0) {
> +		pm_runtime_put_sync(dev);
> +		return ret_val;
> +	}
> +	
> +	ret_val |= temp << 8;
> +	val = i2c_smbus_read_byte_data(client, 0x00);
> +	pm_runtime_put_sync(dev);
> +	if (val < 0)
> +		return val;
> +	lux = ((((1 << (2 * (val & 3))))*1000) * ret_val) / 65536;
> +	return sprintf(buf, "%ld\n", lux);
> +}
> +
>
> ...
>
> +static int isl29020_runtime_suspend(struct device *dev)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	als_set_power_state(client, 0);
> +	return 0;
> +}
> +
> +static int isl29020_runtime_resume(struct device *dev)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	als_set_power_state(client, 1);
> +	return 0;
> +}
> +
> +MODULE_DEVICE_TABLE(i2c, isl29020_id);
> +
> +static const struct dev_pm_ops isl29020_pm_ops = {
> +	.runtime_suspend = isl29020_runtime_suspend,
> +	.runtime_resume = isl29020_runtime_resume,
> +};
>
> +static struct i2c_driver isl29020_driver = {
> +	.driver = {
> +		.name = "isl29020",
> +		.pm = &isl29020_pm_ops,
> +	},
> +	.probe = isl29020_probe,
> +	.remove = isl29020_remove,
> +	.id_table = isl29020_id,
> +};

Could/should we make the PM code disappear if !CONFIG_PM?  Such as


--- a/drivers/misc/isl29020.c~isl29020-ambient-light-sensor-fix
+++ a/drivers/misc/isl29020.c
@@ -192,6 +192,10 @@ static struct i2c_device_id isl29020_id[
 	{ }
 };
 
+MODULE_DEVICE_TABLE(i2c, isl29020_id);
+
+#ifdef CONFIG_PM
+
 static int isl29020_runtime_suspend(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
@@ -206,17 +210,20 @@ static int isl29020_runtime_resume(struc
 	return 0;
 }
 
-MODULE_DEVICE_TABLE(i2c, isl29020_id);
-
 static const struct dev_pm_ops isl29020_pm_ops = {
 	.runtime_suspend = isl29020_runtime_suspend,
 	.runtime_resume = isl29020_runtime_resume,
 };
 
+#define ISL29020_PM_OPS (&isl29020_pm_ops)
+#else	/* CONFIG_PM */
+#define ISL29020_PM_OPS NULL
+#endif	/* CONFIG_PM */
+
 static struct i2c_driver isl29020_driver = {
 	.driver = {
 		.name = "isl29020",
-		.pm = &isl29020_pm_ops,
+		.pm = ISL29020_PM_OPS,
 	},
 	.probe = isl29020_probe,
 	.remove = isl29020_remove,
_

before: 3066 bytes, after: 2705 bytes.

