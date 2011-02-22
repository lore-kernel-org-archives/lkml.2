Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427Ab1BVWWM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:22:12 -0500
Received: from kroah.org ([198.145.64.141]:46820 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754773Ab1BVWWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:22:09 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:41 2011
Message-Id: <20110222221841.589788182@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:17:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jan Beulich <jbeulich@novell.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>
Subject: [46/70] hwmon: (lm85) extend to support EMC6D103 chips
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jan Beulich <JBeulich@novell.com>

commit f065a93e168299569078bc6f52128b57f602fff3 upstream.

The interface is identical EMC6D102, so all that needs to be added are
some definitions and their uses.

Registers apparently missing in EMC6D103S/EMC6D103:A2 compared to EMC6D103:A0,
EMC6D103:A1, and EMC6D102 (according to the data sheets), but used
unconditionally in the driver: 62[5:7], 6D[0:7], and 6E[0:7]. For that
reason, EMC6D103S chips don't get enabled for the time being.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
(Guenter Roeck: Replaced EMC6D103_A2 with EMC6D103S per EMC6D103S datasheet)
Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/hwmon/Kconfig |    2 +-
 drivers/hwmon/lm85.c  |   23 +++++++++++++++++++++--
 2 files changed, 22 insertions(+), 3 deletions(-)

--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -564,7 +564,7 @@ config SENSORS_LM85
 	help
 	  If you say yes here you get support for National Semiconductor LM85
 	  sensor chips and clones: ADM1027, ADT7463, ADT7468, EMC6D100,
-	  EMC6D101 and EMC6D102.
+	  EMC6D101, EMC6D102, and EMC6D103.
 
 	  This driver can also be built as a module.  If so, the module
 	  will be called lm85.
--- a/drivers/hwmon/lm85.c
+++ b/drivers/hwmon/lm85.c
@@ -41,7 +41,7 @@ static const unsigned short normal_i2c[]
 enum chips {
 	any_chip, lm85b, lm85c,
 	adm1027, adt7463, adt7468,
-	emc6d100, emc6d102
+	emc6d100, emc6d102, emc6d103
 };
 
 /* The LM85 registers */
@@ -90,6 +90,9 @@ enum chips {
 #define	LM85_VERSTEP_EMC6D100_A0        0x60
 #define	LM85_VERSTEP_EMC6D100_A1        0x61
 #define	LM85_VERSTEP_EMC6D102		0x65
+#define	LM85_VERSTEP_EMC6D103_A0	0x68
+#define	LM85_VERSTEP_EMC6D103_A1	0x69
+#define	LM85_VERSTEP_EMC6D103S		0x6A	/* Also known as EMC6D103:A2 */
 
 #define	LM85_REG_CONFIG			0x40
 
@@ -348,6 +351,7 @@ static const struct i2c_device_id lm85_i
 	{ "emc6d100", emc6d100 },
 	{ "emc6d101", emc6d100 },
 	{ "emc6d102", emc6d102 },
+	{ "emc6d103", emc6d103 },
 	{ }
 };
 MODULE_DEVICE_TABLE(i2c, lm85_id);
@@ -1250,6 +1254,20 @@ static int lm85_detect(struct i2c_client
 		case LM85_VERSTEP_EMC6D102:
 			type_name = "emc6d102";
 			break;
+		case LM85_VERSTEP_EMC6D103_A0:
+		case LM85_VERSTEP_EMC6D103_A1:
+			type_name = "emc6d103";
+			break;
+		/*
+		 * Registers apparently missing in EMC6D103S/EMC6D103:A2
+		 * compared to EMC6D103:A0, EMC6D103:A1, and EMC6D102
+		 * (according to the data sheets), but used unconditionally
+		 * in the driver: 62[5:7], 6D[0:7], and 6E[0:7].
+		 * So skip EMC6D103S for now.
+		case LM85_VERSTEP_EMC6D103S:
+			type_name = "emc6d103s";
+			break;
+		 */
 		}
 	} else {
 		dev_dbg(&adapter->dev,
@@ -1283,6 +1301,7 @@ static int lm85_probe(struct i2c_client
 	case adt7468:
 	case emc6d100:
 	case emc6d102:
+	case emc6d103:
 		data->freq_map = adm1027_freq_map;
 		break;
 	default:
@@ -1468,7 +1487,7 @@ static struct lm85_data *lm85_update_dev
 			/* More alarm bits */
 			data->alarms |= lm85_read_value(client,
 						EMC6D100_REG_ALARM3) << 16;
-		} else if (data->type == emc6d102) {
+		} else if (data->type == emc6d102 || data->type == emc6d103) {
 			/* Have to read LSB bits after the MSB ones because
 			   the reading of the MSB bits has frozen the
 			   LSBs (backward from the ADM1027).


