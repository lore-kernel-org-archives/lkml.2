Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716Ab1GBUNs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 16:13:48 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:14787 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755198Ab1GBUNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 16:13:47 -0400
Date: Sat, 2 Jul 2011 22:04:29 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: lm-sensors@lm-sensors.org, Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: [PATCH] hwmon: Don't leak info in adm1275_probe
Message-ID: <alpine.LNX.2.00.1107022202520.16316@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In drivers/hwmon/adm1275.c:adm1275_probe() we'll leak the memory
allocated to 'info' if the call to i2c_smbus_read_byte_data() returns
less than zero.

This patch fixes the leak by simply calling kfree(info) when needed.
I also considered just moving the 'info' memory allocation below the
call to i2c_smbus_read_byte_data(), but I was not sure if it mattered
to get the -ENOMEM first in that case or if it would be bad to first
have a successful i2c_smbus_read_byte_data() call and then fail the
mem alloc, so I stuck with the safe option.

Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 drivers/hwmon/adm1275.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

  Compile tested only.

diff --git a/drivers/hwmon/adm1275.c b/drivers/hwmon/adm1275.c
index c2ee204..2ebf255 100644
--- a/drivers/hwmon/adm1275.c
+++ b/drivers/hwmon/adm1275.c
@@ -43,8 +43,10 @@ static int adm1275_probe(struct i2c_client *client,
 		return -ENOMEM;
 
 	config = i2c_smbus_read_byte_data(client, ADM1275_PMON_CONFIG);
-	if (config < 0)
+	if (config < 0) {
+		kfree(info);
 		return config;
+	}
 
 	info->pages = 1;
 	info->direct[PSC_VOLTAGE_IN] = true;
-- 
1.7.6


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

