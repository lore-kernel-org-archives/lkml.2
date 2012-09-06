Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933025Ab2IFSc2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 14:32:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61693 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932373Ab2IFSc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 14:32:26 -0400
From: Olof Johansson <olof@lixom.net>
To: Anton Vorontsov <cbou@mail.ru>
Cc: Rhyland Klein <rklein@nvidia.com>, David Woodhouse <dwmw2@infradead.org>,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: [PATCH] sbs-battery: probe should try talking to the device
Date: Thu,  6 Sep 2012 11:32:29 -0700
Message-Id: <1346956349-21980-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.7.10.1.488.g05fbf7a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Turns out this driver doesn't actually try talking to the device at
probe time, so if it's incorrectly configured in the device tree or
platform data (or if the battery has been removed from the system), then
probe will succeed and every access will sit there and time out. The
end result is a possibly laggy system that thinks it has a battery but
can never read status, which isn't very useful.

Instead, just read any register (I chose status) at probe, and if that
fails, don't register the device.

Signed-off-by: Olof Johansson <olof@lixom.net>
---
 drivers/power/sbs-battery.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/power/sbs-battery.c b/drivers/power/sbs-battery.c
index a65e8f5..2f24253 100644
--- a/drivers/power/sbs-battery.c
+++ b/drivers/power/sbs-battery.c
@@ -760,6 +760,16 @@ static int __devinit sbs_probe(struct i2c_client *client,
 
 skip_gpio:
 
+	/* Before we register, we need to make sure we can actually talk
+	 * to the battery.
+	 */
+	rc = sbs_read_word_data(client, sbs_data[REG_STATUS].addr);
+	if (rc < 0) {
+		dev_err(&client->dev, "%s: Failed to get device status\n",
+			__func__);
+		goto exit_psupply;
+	}
+
 	rc = power_supply_register(&client->dev, &chip->power_supply);
 	if (rc) {
 		dev_err(&client->dev,
-- 
1.7.10.1.488.g05fbf7a

