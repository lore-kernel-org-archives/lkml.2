Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442Ab2BAVSa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:18:30 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:33191 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757382Ab2BAVRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:17:39 -0500
X-Sasl-enc: x6MyjRS74i7n4WUgAv6yV1j2X1QoDAC5sWJ6bXSIgiko 1328131058
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Feb  1 13:00:49 2012
Message-Id: <20120201210049.542235964@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Wed, 01 Feb 2012 13:00:28 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Guenter Roeck <linux@roeck-us.net>,
        Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [64/89] hwmon: (w83627ehf) Disable setting DC mode for pwm2, pwm3 on NCT6776F
In-Reply-To: <20120201210505.GA26028@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit ad77c3e1808f07fa70f707b1c92a683b7c7d3f85 upstream.

NCT6776F only supports pwm mode for pwm2 and pwm3. Return error if an attempt
is made to set those pwm channels to DC mode.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/w83627ehf.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -1319,6 +1319,7 @@ store_pwm_mode(struct device *dev, struc
 {
 	struct w83627ehf_data *data = dev_get_drvdata(dev);
 	struct sensor_device_attribute *sensor_attr = to_sensor_dev_attr(attr);
+	struct w83627ehf_sio_data *sio_data = dev->platform_data;
 	int nr = sensor_attr->index;
 	unsigned long val;
 	int err;
@@ -1330,6 +1331,11 @@ store_pwm_mode(struct device *dev, struc
 
 	if (val > 1)
 		return -EINVAL;
+
+	/* On NCT67766F, DC mode is only supported for pwm1 */
+	if (sio_data->kind == nct6776 && nr && val != 1)
+		return -EINVAL;
+
 	mutex_lock(&data->update_lock);
 	reg = w83627ehf_read_value(data, W83627EHF_REG_PWM_ENABLE[nr]);
 	data->pwm_mode[nr] = val;


