Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758426Ab1BRTjV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 14:39:21 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:38820 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758406Ab1BRTjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 14:39:18 -0500
X-Greylist: delayed 557 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Feb 2011 14:39:18 EST
Date: Fri, 18 Feb 2011 14:30:00 -0500
To: Jean Delvare <khali@linux-fr.org>
Cc: Len Sorensen <lsorense@csclub.uwaterloo.ca>, linux-kernel@vger.kernel.org
Subject: Add support for LM75A.
Message-ID: <20110218193000.GE343@caffeine.csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The LM75A can not be detected with the same logic as previous LM75
designs.  Previous designs would return the last value read when an
unused register was read.  The LM75 returns 0xff when an usesed register
is read and it also has a new identity register.

This patch adds the new detection logic for the LM75A, allowing the lm75
driver to correctly detect the presence of an LM75A as well as older
LM75 designs.

Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>

diff --git a/drivers/hwmon/lm75.c b/drivers/hwmon/lm75.c
index f36eb80..6d04cf6 100644
--- a/drivers/hwmon/lm75.c
+++ b/drivers/hwmon/lm75.c
@@ -250,23 +250,40 @@ static int lm75_detect(struct i2c_client *new_client,
 	   addresses 0x04-0x07 returning the last read value.
 	   The cycling+unused addresses combination is not tested,
 	   since it would significantly slow the detection down and would
-	   hardly add any value. */
+	   hardly add any value.
+
+	   The LM75A is different.  It has an id byte of 0xaX (where
+	   X is the chip revision) in register 7, and unused registers
+	   return 0xff rather than the last read value. */
 
-	/* Unused addresses */
 	cur = i2c_smbus_read_word_data(new_client, 0);
 	conf = i2c_smbus_read_byte_data(new_client, 1);
-	hyst = i2c_smbus_read_word_data(new_client, 2);
-	if (i2c_smbus_read_word_data(new_client, 4) != hyst
-	 || i2c_smbus_read_word_data(new_client, 5) != hyst
-	 || i2c_smbus_read_word_data(new_client, 6) != hyst
-	 || i2c_smbus_read_word_data(new_client, 7) != hyst)
-		return -ENODEV;
-	os = i2c_smbus_read_word_data(new_client, 3);
-	if (i2c_smbus_read_word_data(new_client, 4) != os
-	 || i2c_smbus_read_word_data(new_client, 5) != os
-	 || i2c_smbus_read_word_data(new_client, 6) != os
-	 || i2c_smbus_read_word_data(new_client, 7) != os)
-		return -ENODEV;
+
+	/* First check for LM75A */
+	if ((i2c_smbus_read_byte_data(new_client, 7) & 0xf0) == 0xa0) {
+		/* LM 75A returns 0xff on unused registers so
+		   just to be sure we check for that too. */
+		if (i2c_smbus_read_byte_data(new_client, 4) != 0xff
+		 || i2c_smbus_read_byte_data(new_client, 5) != 0xff
+		 || i2c_smbus_read_byte_data(new_client, 6) != 0xff)
+			return -ENODEV;
+		hyst = i2c_smbus_read_word_data(new_client, 2);
+		os = i2c_smbus_read_word_data(new_client, 3);
+	} else { /* Traditional style LM75 detection */
+		/* Unused addresses */
+		hyst = i2c_smbus_read_word_data(new_client, 2);
+		if (i2c_smbus_read_word_data(new_client, 4) != hyst
+		 || i2c_smbus_read_word_data(new_client, 5) != hyst
+		 || i2c_smbus_read_word_data(new_client, 6) != hyst
+		 || i2c_smbus_read_word_data(new_client, 7) != hyst)
+			return -ENODEV;
+		os = i2c_smbus_read_word_data(new_client, 3);
+		if (i2c_smbus_read_word_data(new_client, 4) != os
+		 || i2c_smbus_read_word_data(new_client, 5) != os
+		 || i2c_smbus_read_word_data(new_client, 6) != os
+		 || i2c_smbus_read_word_data(new_client, 7) != os)
+			return -ENODEV;
+	}
 
 	/* Unused bits */
 	if (conf & 0xe0)

-- 
Len Sorensen
