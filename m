Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469Ab0KIPRU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 10:17:20 -0500
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:54129 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750702Ab0KIPRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 10:17:17 -0500
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 06/11] hwmon: applesmc: Handle new temperature format (rev2)
Date: Tue,  9 Nov 2010 16:15:06 +0100
Message-Id: <1289315711-3011-7-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1289315711-3011-1-git-send-email-rydberg@euromail.se>
References: <1289315711-3011-1-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1PFpwL-0001mF-4z.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1PFpwL-0001mF-4z f8ee845b4a263d935e722762fe07cbbb
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recent Macbooks have temperature registers of a new type.
This patch adds the logic to handle them.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hwmon/applesmc.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index 55abb5f..6663721 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -728,13 +728,19 @@ static ssize_t applesmc_show_temperature(struct device *dev,
 	entry = applesmc_get_entry_by_index(index);
 	if (IS_ERR(entry))
 		return PTR_ERR(entry);
+	if (entry->len > 2)
+		return -EINVAL;
 
-	ret = applesmc_read_entry(entry, buffer, 2);
+	ret = applesmc_read_entry(entry, buffer, entry->len);
 	if (ret)
 		return ret;
 
-	temp = buffer[0]*1000;
-	temp += (buffer[1] >> 6) * 250;
+	if (entry->len == 2) {
+		temp = buffer[0] * 1000;
+		temp += (buffer[1] >> 6) * 250;
+	} else {
+		temp = buffer[0] * 4000;
+	}
 
 	return snprintf(sysfsbuf, PAGE_SIZE, "%u\n", temp);
 }
-- 
1.7.1

