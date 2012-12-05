Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab2LEODP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 09:03:15 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:51151 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab2LEODM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 09:03:12 -0500
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Jean Delvare <khali@linux-fr.org>,
        linux-input@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/4] HID: i2c-hid: remove extra .irq field in struct i2c_hid
Date: Wed,  5 Dec 2012 15:02:55 +0100
Message-Id: <1354716176-12558-4-git-send-email-benjamin.tissoires@gmail.com>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1354716176-12558-1-git-send-email-benjamin.tissoires@gmail.com>
References: <1354716176-12558-1-git-send-email-benjamin.tissoires@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no point in keeping the irq in i2c_hid as it's already
there in client.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@gmail.com>
---
 drivers/hid/i2c-hid/i2c-hid.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid.c b/drivers/hid/i2c-hid/i2c-hid.c
index d00f185..c6630d4 100644
--- a/drivers/hid/i2c-hid/i2c-hid.c
+++ b/drivers/hid/i2c-hid/i2c-hid.c
@@ -135,8 +135,6 @@ struct i2c_hid {
 
 	unsigned long		flags;		/* device flags */
 
-	int			irq;		/* the interrupt line irq */
-
 	wait_queue_head_t	wait;		/* For waiting the interrupt */
 };
 
@@ -736,8 +734,6 @@ static int __devinit i2c_hid_init_irq(struct i2c_client *client)
 		return ret;
 	}
 
-	ihid->irq = client->irq;
-
 	return 0;
 }
 
@@ -851,7 +847,7 @@ static int __devinit i2c_hid_probe(struct i2c_client *client,
 	hid = hid_allocate_device();
 	if (IS_ERR(hid)) {
 		ret = PTR_ERR(hid);
-		goto err;
+		goto err_irq;
 	}
 
 	ihid->hid = hid;
@@ -881,10 +877,10 @@ static int __devinit i2c_hid_probe(struct i2c_client *client,
 err_mem_free:
 	hid_destroy_device(hid);
 
-err:
-	if (ihid->irq)
-		free_irq(ihid->irq, ihid);
+err_irq:
+	free_irq(client->irq, ihid);
 
+err:
 	i2c_hid_free_buffers(ihid);
 	kfree(ihid);
 	return ret;
@@ -912,10 +908,9 @@ static int __devexit i2c_hid_remove(struct i2c_client *client)
 static int i2c_hid_suspend(struct device *dev)
 {
 	struct i2c_client *client = to_i2c_client(dev);
-	struct i2c_hid *ihid = i2c_get_clientdata(client);
 
 	if (device_may_wakeup(&client->dev))
-		enable_irq_wake(ihid->irq);
+		enable_irq_wake(client->irq);
 
 	/* Save some power */
 	i2c_hid_set_power(client, I2C_HID_PWR_SLEEP);
-- 
1.8.0.1

