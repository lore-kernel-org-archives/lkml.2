Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965285Ab2J3SMw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 14:12:52 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:59057 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934073Ab2J3SMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 14:12:45 -0400
From: Pantelis Antoniou <panto@antoniou-consulting.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Koen Kooi <koen@dominion.thruhere.net>, Matt Porter <mporter@ti.com>,
        Russ Dill <Russ.Dill@ti.com>, linux-omap@vger.kernel.org
Subject: [PATCH] i2c-EEPROM: Export memory accessor
Date: Wed, 31 Oct 2012 17:56:49 +0200
Message-Id: <1351699009-4217-1-git-send-email-panto@antoniou-consulting.com>
X-Mailer: git-send-email 1.7.12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Various platforms need access to the EEPROM in other
places besides their platform registration callbacks.
Export the memory accessor to the i2c_client and implement
it for the at24 driver.

And before you ask, no, the platform callback can't be used
for anything that depends on DT.

Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
---
 drivers/misc/eeprom/at24.c |  5 +++++
 include/linux/i2c.h        | 24 ++++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/drivers/misc/eeprom/at24.c b/drivers/misc/eeprom/at24.c
index ab1ad41..4f88ae65 100644
--- a/drivers/misc/eeprom/at24.c
+++ b/drivers/misc/eeprom/at24.c
@@ -609,6 +609,9 @@ static int at24_probe(struct i2c_client *client, const struct i2c_device_id *id)
 
 	at24->client[0] = client;
 
+	/* export accessor */
+	client->macc = &at24->macc;
+
 	/* use dummy devices for multiple-address chips */
 	for (i = 1; i < num_addresses; i++) {
 		at24->client[i] = i2c_new_dummy(client->adapter,
@@ -619,6 +622,7 @@ static int at24_probe(struct i2c_client *client, const struct i2c_device_id *id)
 			err = -EADDRINUSE;
 			goto err_clients;
 		}
+		at24->client[i]->macc = &at24->macc;
 	}
 
 	err = sysfs_create_bin_file(&client->dev.kobj, &at24->bin);
@@ -637,6 +641,7 @@ static int at24_probe(struct i2c_client *client, const struct i2c_device_id *id)
 			   I2C_SMBUS_WORD_DATA ? "word" : "byte");
 	}
 
+
 	/* export data to kernel code */
 	if (chip.setup)
 		chip.setup(&at24->macc, chip.context);
diff --git a/include/linux/i2c.h b/include/linux/i2c.h
index 800de22..e20ad4e 100644
--- a/include/linux/i2c.h
+++ b/include/linux/i2c.h
@@ -33,6 +33,7 @@
 #include <linux/of.h>		/* for struct device_node */
 #include <linux/swab.h>		/* for swab16 */
 #include <uapi/linux/i2c.h>
+#include <linux/memory.h>
 
 extern struct bus_type i2c_bus_type;
 extern struct device_type i2c_adapter_type;
@@ -229,9 +230,32 @@ struct i2c_client {
 	struct device dev;		/* the device structure		*/
 	int irq;			/* irq issued by device		*/
 	struct list_head detected;
+
+	/* export accessor */
+	struct memory_accessor *macc;
 };
 #define to_i2c_client(d) container_of(d, struct i2c_client, dev)
 
+static inline ssize_t i2c_memory_read(struct i2c_client *client, char *buf, off_t offset,
+		size_t count)
+{
+	struct memory_accessor *macc = client->macc;
+
+	if (macc == NULL || macc->read == NULL)
+		return -ENODEV;
+	return (*client->macc->read)(macc, buf, offset, count);
+}
+
+static inline ssize_t i2c_memory_write(struct i2c_client *client, const char *buf, off_t offset,
+		size_t count)
+{
+	struct memory_accessor *macc = client->macc;
+
+	if (macc == NULL || macc->write == NULL)
+		return -ENODEV;
+	return (*client->macc->write)(macc, buf, offset, count);
+}
+
 extern struct i2c_client *i2c_verify_client(struct device *dev);
 extern struct i2c_adapter *i2c_verify_adapter(struct device *dev);
 
-- 
1.7.12

