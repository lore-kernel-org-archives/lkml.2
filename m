Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965465Ab1C3WJM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:09:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:35488 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933182Ab1C3VGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:06:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="903733768"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: khali@linux-fr.org, guenter.roeck@ericsson.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [11/275] hwmon: (via686a) Initialize fan_div values
Message-Id: <20110330210405.481C33E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:04:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/hwmon/via686a.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

Index: linux-2.6.35.y/drivers/hwmon/via686a.c
===================================================================
--- linux-2.6.35.y.orig/drivers/hwmon/via686a.c	2011-03-29 22:52:03.381101405 -0700
+++ linux-2.6.35.y/drivers/hwmon/via686a.c	2011-03-29 23:02:58.460339566 -0700
@@ -687,6 +687,13 @@
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
@@ -700,6 +707,9 @@
 	via686a_write_value(data, VIA686A_REG_TEMP_MODE,
 			    (reg & ~VIA686A_TEMP_MODE_MASK)
 			    | VIA686A_TEMP_MODE_CONTINUOUS);
+
+	/* Pre-read fan clock divisor values */
+	via686a_update_fan_div(data);
 }
 
 static struct via686a_data *via686a_update_device(struct device *dev)
@@ -751,9 +761,7 @@
 		    (via686a_read_value(data, VIA686A_REG_TEMP_LOW23) &
 		     0xc0) >> 6;
 
-		i = via686a_read_value(data, VIA686A_REG_FANDIV);
-		data->fan_div[0] = (i >> 4) & 0x03;
-		data->fan_div[1] = i >> 6;
+		via686a_update_fan_div(data);
 		data->alarms =
 		    via686a_read_value(data,
 				       VIA686A_REG_ALARM1) |
