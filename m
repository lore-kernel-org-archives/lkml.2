Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965093Ab1DNR7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:59:24 -0400
Received: from mail.windriver.com ([147.11.1.11]:42404 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965083Ab1DNR7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:59:17 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 202/209] hwmon: (w83627ehf) Fix max_output and step_output readings
Date: Thu, 14 Apr 2011 13:56:00 -0400
Message-Id: <1302803767-9715-89-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guenter Roeck <guenter.roeck@ericsson.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

[extraction from commit da2e025590cf7038440132d4bbc967a579b11112 upstream]

The value of max_output and step_output registers isn't read from the
respective registers. As a result, zero values are returned to the
user through the respective sysfs attributes, instead of the actual
fan control settings.

The problem is fixed by updating the fan max output and fan step
output information from data in registers.

Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/hwmon/w83627ehf.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/hwmon/w83627ehf.c b/drivers/hwmon/w83627ehf.c
index 0dcaba9..dc53e61 100644
--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -524,7 +524,7 @@ static struct w83627ehf_data *w83627ehf_update_device(struct device *dev)
 			}
 		}
 
-		for (i = 0; i < 4; i++) {
+		for (i = 0; i < data->pwm_num; i++) {
 			/* pwmcfg, tolerance mapped for i=0, i=1 to same reg */
 			if (i != 1) {
 				pwmcfg = w83627ehf_read_value(data,
@@ -546,6 +546,17 @@ static struct w83627ehf_data *w83627ehf_update_device(struct device *dev)
 						W83627EHF_REG_FAN_STOP_OUTPUT[i]);
 			data->fan_stop_time[i] = w83627ehf_read_value(data,
 						W83627EHF_REG_FAN_STOP_TIME[i]);
+
+			if (W83627EHF_REG_FAN_MAX_OUTPUT[i] != 0xff)
+				data->fan_max_output[i] =
+				  w83627ehf_read_value(data,
+					      W83627EHF_REG_FAN_MAX_OUTPUT[i]);
+
+			if (W83627EHF_REG_FAN_STEP_OUTPUT[i] != 0xff)
+				data->fan_step_output[i] =
+				  w83627ehf_read_value(data,
+					      W83627EHF_REG_FAN_STEP_OUTPUT[i]);
+
 			data->target_temp[i] =
 				w83627ehf_read_value(data,
 					W83627EHF_REG_TARGET[i]) &
-- 
1.7.4.4

