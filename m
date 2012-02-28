Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965312Ab2B1B0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 20:26:38 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54256 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965134Ab2B1BLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 20:11:47 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.129.4 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
MIME-Version: 1.0
Message-Id: <20120228010433.819076125@linuxfoundation.org>
User-Agent: quilt/0.51-17.1
Date: Mon, 27 Feb 2012 17:05:19 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Chris D Schimp <silverchris@gmail.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Roland Stigge <stigge@antcom.de>
Subject: [ 50/72] hwmon: (max6639) Fix FAN_FROM_REG calculation
In-Reply-To: <20120228010511.GA8453@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris D Schimp <silverchris@gmail.com>

commit b63d97a36edb1aecf8c13e5f5783feff4d64c24b upstream.

RPM calculation from tachometer value does not depend on PPR.
Also, do not report negative RPM values.

Signed-off-by: Chris D Schimp <silverchris@gmail.com>
[guenter.roeck@ericsson.com: do not report negative RPM values]
Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Acked-by: Roland Stigge <stigge@antcom.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/max6639.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/hwmon/max6639.c
+++ b/drivers/hwmon/max6639.c
@@ -72,8 +72,8 @@ static unsigned short normal_i2c[] = { 0
 
 static const int rpm_ranges[] = { 2000, 4000, 8000, 16000 };
 
-#define FAN_FROM_REG(val, div, rpm_range)	((val) == 0 ? -1 : \
-	(val) == 255 ? 0 : (rpm_ranges[rpm_range] * 30) / ((div + 1) * (val)))
+#define FAN_FROM_REG(val, rpm_range)	((val) == 0 || (val) == 255 ? \
+				0 : (rpm_ranges[rpm_range] * 30) / (val))
 #define TEMP_LIMIT_TO_REG(val)	SENSORS_LIMIT((val) / 1000, 0, 255)
 
 /*
@@ -333,7 +333,7 @@ static ssize_t show_fan_input(struct dev
 		return PTR_ERR(data);
 
 	return sprintf(buf, "%d\n", FAN_FROM_REG(data->fan[attr->index],
-		       data->ppr, data->rpm_range));
+		       data->rpm_range));
 }
 
 static ssize_t show_alarm(struct device *dev,


