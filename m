Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932547Ab1DYUZw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:25:52 -0400
Received: from 1wt.eu ([62.212.114.60]:34626 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932536Ab1DYUZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:25:48 -0400
Message-Id: <20110425200233.129058612@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:02:35 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 003/173] hwmon: (via686a) Initialize fan_div values
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jean Delvare <khali@linux-fr.org>

commit f790674d3f87df6390828ac21a7d1530f71b59c8 upstream.

Functions set_fan_min() and set_fan_div() assume that the fan_div
values have already been read from the register. The driver currently
doesn't initialize them at load time, they are only set when function
via686a_update_device() is called. This means that set_fan_min() and
set_fan_div() misbehave if, for example, "sensors -s" is called
before any monitoring application (e.g. "sensors") is has been run.

Fix the problem by always initializing the fan_div values at device
bind time.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/via686a.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/hwmon/via686a.c
+++ b/drivers/hwmon/via686a.c
@@ -687,6 +687,13 @@ static int __devexit via686a_remove(stru
 	return 0;
 }
 
+static void via686a_update_fan_div(struct via686a_data *data)
+{
+	int reg = via686a_read_value(data, VIA686A_REG_FANDIV);
+	data->fan_div[0] = (reg >> 4) & 0x03;
+	data->fan_div[1] = reg >> 6;
+}
+
 static void __devinit via686a_init_device(struct via686a_data *data)
 {
 	u8 reg;
@@ -700,6 +707,9 @@ static void __devinit via686a_init_devic
 	via686a_write_value(data, VIA686A_REG_TEMP_MODE,
 			    (reg & ~VIA686A_TEMP_MODE_MASK)
 			    | VIA686A_TEMP_MODE_CONTINUOUS);
+
+	/* Pre-read fan clock divisor values */
+	via686a_update_fan_div(data);
 }
 
 static struct via686a_data *via686a_update_device(struct device *dev)
@@ -751,9 +761,7 @@ static struct via686a_data *via686a_upda
 		    (via686a_read_value(data, VIA686A_REG_TEMP_LOW23) &
 		     0xc0) >> 6;
 
-		i = via686a_read_value(data, VIA686A_REG_FANDIV);
-		data->fan_div[0] = (i >> 4) & 0x03;
-		data->fan_div[1] = i >> 6;
+		via686a_update_fan_div(data);
 		data->alarms =
 		    via686a_read_value(data,
 				       VIA686A_REG_ALARM1) |


