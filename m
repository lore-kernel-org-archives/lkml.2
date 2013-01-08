Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751760Ab3AHFyo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 00:54:44 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:46724 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab3AHFyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 00:54:41 -0500
From: Rajagopal Venkat <rajagopal.venkat@linaro.org>
To: myungjoo.ham@samsung.com, kyungmin.park@samsung.com, mturquette@linaro.org,
        rjw@sisk.pl
Cc: patches@linaro.org, linaro-dev@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Rajagopal Venkat <rajagopal.venkat@linaro.org>
Subject: [PATCH 2/3] PM / devfreq: fix stats start time stamp
Date: Tue,  8 Jan 2013 11:20:38 +0530
Message-Id: <1357624239-13938-2-git-send-email-rajagopal.venkat@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357624239-13938-1-git-send-email-rajagopal.venkat@linaro.org>
References: <1357624239-13938-1-git-send-email-rajagopal.venkat@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark the stats start time stamp when actual load monitoring is
started for accuracy.

Signed-off-by: Rajagopal Venkat <rajagopal.venkat@linaro.org>
---
 drivers/devfreq/devfreq.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 5782c9b..2843a22 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -254,9 +254,12 @@ static void devfreq_monitor(struct work_struct *work)
 void devfreq_monitor_start(struct devfreq *devfreq)
 {
 	INIT_DEFERRABLE_WORK(&devfreq->work, devfreq_monitor);
-	if (devfreq->profile->polling_ms)
+	if (devfreq->profile->polling_ms) {
 		queue_delayed_work(devfreq_wq, &devfreq->work,
 			msecs_to_jiffies(devfreq->profile->polling_ms));
+
+		devfreq->last_stat_updated = jiffies;
+	}
 }
 EXPORT_SYMBOL(devfreq_monitor_start);
 
@@ -498,7 +501,6 @@ struct devfreq *devfreq_add_device(struct device *dev,
 	devfreq->time_in_state = devm_kzalloc(dev, sizeof(unsigned int) *
 						devfreq->profile->max_state,
 						GFP_KERNEL);
-	devfreq->last_stat_updated = jiffies;
 	devfreq_set_freq_limits(devfreq);
 
 	dev_set_name(&devfreq->dev, dev_name(dev));
-- 
1.7.10.4

