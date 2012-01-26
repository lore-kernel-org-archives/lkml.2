Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627Ab2AZLIk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 06:08:40 -0500
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:50459 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506Ab2AZLIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 06:08:38 -0500
X-SENDER-IP: [85.230.170.239]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArVRAPgzIU9V5qrvPGdsb2JhbABCiVCkehkBAQEBNzKCIC8TAQ8YgQIKGhOHfrgaE4ksBgQnBQELAgsDgxoIhGQEmwWMbA
X-IronPort-AV: E=Sophos;i="4.71,573,1320620400"; 
   d="scan'208";a="258496461"
From: "Henrik Rydberg" <rydberg@euromail.se>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Jean Delvare <khali@linux-fr.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, Henrik Rydberg <rydberg@euromail.se>
Subject: [PATCH] applesmc: Silence uninitialized warnings
Date: Thu, 26 Jan 2012 12:08:41 +0100
Message-Id: <1327576121-2073-1-git-send-email-rydberg@euromail.se>
X-Mailer: git-send-email 1.7.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some error paths do not set a result, leading to the (false)
assumption that the value may be used uninitialized. Set results for
those paths as well.

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hwmon/applesmc.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
index b989553..11f79bb 100644
--- a/drivers/hwmon/applesmc.c
+++ b/drivers/hwmon/applesmc.c
@@ -344,8 +344,10 @@ static int applesmc_get_lower_bound(unsigned int *lo, const char *key)
 	while (begin != end) {
 		int middle = begin + (end - begin) / 2;
 		entry = applesmc_get_entry_by_index(middle);
-		if (IS_ERR(entry))
+		if (IS_ERR(entry)) {
+			*lo = 0;
 			return PTR_ERR(entry);
+		}
 		if (strcmp(entry->key, key) < 0)
 			begin = middle + 1;
 		else
@@ -364,8 +366,10 @@ static int applesmc_get_upper_bound(unsigned int *hi, const char *key)
 	while (begin != end) {
 		int middle = begin + (end - begin) / 2;
 		entry = applesmc_get_entry_by_index(middle);
-		if (IS_ERR(entry))
+		if (IS_ERR(entry)) {
+			*hi = smcreg.key_count;
 			return PTR_ERR(entry);
+		}
 		if (strcmp(key, entry->key) < 0)
 			end = middle;
 		else
-- 
1.7.8.4

