Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754419Ab0JaHxP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 03:53:15 -0400
Received: from ch-smtp03.sth.basefarm.net ([80.76.149.214]:47941 "EHLO
	ch-smtp03.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752867Ab0JaHxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 03:53:11 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Jean Delvare <khali@linux-fr.org>
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH 4/8] hwmon: applesmc: Handle new temperature format
Date: Sun, 31 Oct 2010 08:50:30 +0100
Message-Id: <1288511434-5662-5-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288511434-5662-1-git-send-email-rydberg@euromail.se>
References: <1288511434-5662-1-git-send-email-rydberg@euromail.se>
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1PCSiM-0002tQ-BW.
X-Scan-Signature: ch-smtp03.sth.basefarm.net 1PCSiM-0002tQ-BW 392a564771f94313061a36880e537396
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
index 0207618..ec92aff 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -733,13 +733,19 @@ static ssize_t applesmc_show_temperature(struct device *dev,
 	ret = applesmc_get_entry_by_index(index, &entry);
 	if (ret)
 		return ret;
+	if (entry.len > 2)
+		return -EINVAL;
 
-	ret = applesmc_read_entry(&entry, buffer, 2);
+	ret = applesmc_read_entry(&entry, buffer, entry.len);
 	if (ret)
 		return ret;
 
-	temp = buffer[0]*1000;
-	temp += (buffer[1] >> 6) * 250;
+	if (entry.len == 2) {
+		temp = buffer[0]*1000;
+		temp += (buffer[1] >> 6) * 250;
+	} else {
+		temp = buffer[0] * 4000;
+	}
 
 	return snprintf(sysfsbuf, PAGE_SIZE, "%u\n", temp);
 }
-- 
1.7.1

