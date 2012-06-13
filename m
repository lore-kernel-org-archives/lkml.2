Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab2FMEnZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 00:43:25 -0400
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:41207 "HELO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751417Ab2FMEnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 00:43:23 -0400
From: Xiaoguang Chen <chenxg@marvell.com>
To: linux-kernel@vger.kernel.org
Cc: myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        Xiaoguang Chen <chenxg@marvell.com>
Subject: [PATCH 2/2] PM: Devfreq: Add frequency get function in profile
Date: Wed, 13 Jun 2012 12:39:39 +0800
Message-Id: <1339562379-17602-1-git-send-email-chenxg@marvell.com>
X-Mailer: git-send-email 1.7.4.1
X-OriginalArrivalTime: 13 Jun 2012 04:39:41.0752 (UTC) FILETIME=[8C6EA380:01CD491E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when devfreq set one frequency, the final frequency may not
the same as the requested frequency. Add get function in profile
to let devfreq driver return the final frequency.

Signed-off-by: Xiaoguang Chen <chenxg@marvell.com>
---
 drivers/devfreq/devfreq.c |   12 +++++++++++-
 include/linux/devfreq.h   |    2 ++
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 2144200..50a4fc0 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -72,6 +72,16 @@ static struct devfreq *find_device_devfreq(struct device *dev)
 	return ERR_PTR(-ENODEV);
 }
 
+static unsigned long __devfreq_get(struct device *dev)
+{
+	struct devfreq *devfreq = to_devfreq(dev);
+	unsigned long ret_freq = devfreq->previous_freq;
+	if (!devfreq->profile->get)
+		return ret_freq;
+	ret_freq = devfreq->profile->get(devfreq->dev.parent);
+	return ret_freq;
+}
+
 /**
  * update_devfreq() - Reevaluate the device and configure frequency.
  * @devfreq:	the devfreq instance.
@@ -116,7 +126,7 @@ int update_devfreq(struct devfreq *devfreq)
 	if (err)
 		return err;
 
-	devfreq->previous_freq = freq;
+	devfreq->previous_freq = __devfreq_get(&devfreq->dev);
 	return err;
 }
 
diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
index e5e4036..f789314 100644
--- a/include/linux/devfreq.h
+++ b/include/linux/devfreq.h
@@ -65,6 +65,7 @@ struct devfreq_frequency_table {
  * @initial_freq	The operating frequency when devfreq_add_device() is
  *			called.
  * @polling_ms		The polling interval in ms. 0 disables polling.
+ * @get			Get the devices's actual frequency
  * @target		The device should set its operating frequency at
  *			freq or lowest-upper-than-freq value. If freq is
  *			higher than any operable frequency, set maximum.
@@ -84,6 +85,7 @@ struct devfreq_dev_profile {
 	unsigned long initial_freq;
 	unsigned int polling_ms;
 
+	unsigned long	(*get)(struct device *dev);
 	int (*target)(struct device *dev, unsigned long *freq, u32 flags);
 	int (*get_dev_status)(struct device *dev,
 			      struct devfreq_dev_status *stat);
-- 
1.7.0.4

