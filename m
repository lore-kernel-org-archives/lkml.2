Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754367Ab1HAXhR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:37:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38268 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753458Ab1HAXZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:25:15 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:53 2011
Message-Id: <20110801232053.173762524@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:18:41 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: [26/70] hwmon: (pmbus) Improve auto-detection of temperature status register
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Guenter Roeck <guenter.roeck@ericsson.com>

commit 22e6b2312d221376dcd98a8afb0f314b62d33a91 upstream.

It is possible that a PMBus device supports the READ_TEMPERATURE2 and/or
READ_TEMPERATURE3 registers but does not support READ_TEMPERATURE1.
Improve temperature status register detection to address this condition.

Reported-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

diff --git a/drivers/hwmon/pmbus.c b/drivers/hwmon/pmbus.c
index 931d940..9b1f0c3 100644
--- a/drivers/hwmon/pmbus.c
+++ b/drivers/hwmon/pmbus.c
@@ -59,16 +59,17 @@ static void pmbus_find_sensor_groups(struct i2c_client *client,
 		if (pmbus_check_byte_register(client, 0, PMBUS_STATUS_FAN_34))
 			info->func[0] |= PMBUS_HAVE_STATUS_FAN34;
 	}
-	if (pmbus_check_word_register(client, 0, PMBUS_READ_TEMPERATURE_1)) {
+	if (pmbus_check_word_register(client, 0, PMBUS_READ_TEMPERATURE_1))
 		info->func[0] |= PMBUS_HAVE_TEMP;
-		if (pmbus_check_byte_register(client, 0,
-					      PMBUS_STATUS_TEMPERATURE))
-			info->func[0] |= PMBUS_HAVE_STATUS_TEMP;
-	}
 	if (pmbus_check_word_register(client, 0, PMBUS_READ_TEMPERATURE_2))
 		info->func[0] |= PMBUS_HAVE_TEMP2;
 	if (pmbus_check_word_register(client, 0, PMBUS_READ_TEMPERATURE_3))
 		info->func[0] |= PMBUS_HAVE_TEMP3;
+	if (info->func[0] & (PMBUS_HAVE_TEMP | PMBUS_HAVE_TEMP2
+			     | PMBUS_HAVE_TEMP3)
+	    && pmbus_check_byte_register(client, 0,
+					 PMBUS_STATUS_TEMPERATURE))
+			info->func[0] |= PMBUS_HAVE_STATUS_TEMP;
 
 	/* Sensors detected on all pages */
 	for (page = 0; page < info->pages; page++) {


