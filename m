Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933038Ab1BPCOf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 21:14:35 -0500
Received: from kroah.org ([198.145.64.141]:48700 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758058Ab1BPBtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 20:49:03 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 17:46:54 2011
Message-Id: <20110216014654.800264538@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 17:44:31 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [005/115] hwmon: (via686a) Initialize fan_div values
In-Reply-To: <20110216014741.GA24678@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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


