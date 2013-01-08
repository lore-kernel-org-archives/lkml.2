Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752457Ab3AHFyv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 00:54:51 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:51107 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab3AHFyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 00:54:49 -0500
From: Rajagopal Venkat <rajagopal.venkat@linaro.org>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com, mturquette@linaro.org,
        rjw@sisk.pl
Cc: patches@linaro.org, linaro-dev@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Rajagopal Venkat <rajagopal.venkat@linaro.org>
Subject: [PATCH 3/3] PM / devfreq: account suspend/resume for stats
Date: Tue,  8 Jan 2013 11:20:39 +0530
Message-Id: <1357624239-13938-3-git-send-email-rajagopal.venkat@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357624239-13938-1-git-send-email-rajagopal.venkat@linaro.org>
References: <1357624239-13938-1-git-send-email-rajagopal.venkat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devfreq stats is not taking device suspend and resume into
account. Fix it.

Signed-off-by: Rajagopal Venkat <rajagopal.venkat@linaro.org>
---
 drivers/devfreq/devfreq.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 2843a22..4c50235 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -297,6 +297,7 @@ void devfreq_monitor_suspend(struct devfreq *devfreq)
 		return;
 	}
 
+	devfreq_update_status(devfreq, devfreq->previous_freq);
 	devfreq->stop_polling = true;
 	mutex_unlock(&devfreq->lock);
 	cancel_delayed_work_sync(&devfreq->work);
@@ -313,6 +314,8 @@ EXPORT_SYMBOL(devfreq_monitor_suspend);
  */
 void devfreq_monitor_resume(struct devfreq *devfreq)
 {
+	unsigned long freq;
+
 	mutex_lock(&devfreq->lock);
 	if (!devfreq->stop_polling)
 		goto out;
@@ -321,8 +324,14 @@ void devfreq_monitor_resume(struct devfreq *devfreq)
 			devfreq->profile->polling_ms)
 		queue_delayed_work(devfreq_wq, &devfreq->work,
 			msecs_to_jiffies(devfreq->profile->polling_ms));
+
+	devfreq->last_stat_updated = jiffies;
 	devfreq->stop_polling = false;
 
+	if (devfreq->profile->get_cur_freq &&
+		!devfreq->profile->get_cur_freq(devfreq->dev.parent, &freq))
+		devfreq->previous_freq = freq;
+
 out:
 	mutex_unlock(&devfreq->lock);
 }
@@ -931,11 +940,11 @@ static ssize_t show_trans_table(struct device *dev, struct device_attribute *att
 {
 	struct devfreq *devfreq = to_devfreq(dev);
 	ssize_t len;
-	int i, j, err;
+	int i, j;
 	unsigned int max_state = devfreq->profile->max_state;
 
-	err = devfreq_update_status(devfreq, devfreq->previous_freq);
-	if (err)
+	if (!devfreq->stop_polling &&
+			devfreq_update_status(devfreq, devfreq->previous_freq))
 		return 0;
 
 	len = sprintf(buf, "   From  :   To\n");
-- 
1.7.10.4

