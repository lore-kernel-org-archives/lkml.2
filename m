Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394Ab2HPGtl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 02:49:41 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:56145 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331Ab2HPGth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 02:49:37 -0400
X-AuditID: cbfee61b-b7faf6d00000476a-57-502c9800542d
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Mike Turquette <mturquette@ti.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Xiaoguang Chen <chenxg@marvell.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH 1/2] devfreq: Add sysfs node for representing frequency
 transition information.
Date: Thu, 16 Aug 2012 15:49:26 +0900
Message-id: <1345099767-13467-2-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1345099767-13467-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1345099767-13467-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGJMWRmVeSWpSXmKPExsVy+t9jQV2GGToBBqfvCVtc3jWHzeJz7xFG
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDJu3DrLUvBQs2Lhl2ksDYxfFbsYOTgkBEwkZv9L72Lk
	BDLFJC7cW88GYgsJTGeUmHeCo4uRC8huYZLo/HEHLMEmoCPxf99NdhBbRMBK4kX7K3aQImaB
	D4wS2/pXs4IkhAUSJba9b2ACsVkEVCV2X38IZvMKeEhcXvmTDWKbgsSCe2/BbE4BT4kZ06+y
	Qmz2kFh9ro91AiPvAkaGVYyiqQXJBcVJ6blGesWJucWleel6yfm5mxjBvn8mvYNxVYPFIUYB
	DkYlHt4D/7UDhFgTy4orcw8xSnAwK4nw3q7VCRDiTUmsrEotyo8vKs1JLT7EKM3BoiTOa+L9
	1V9IID2xJDU7NbUgtQgmy8TBKdXAuNonPccwU27X55tH2jJ8GDbypxo46ASUN7ImOd04YN/Z
	EOqm/OCbinTxg8WyefZqae9+/kwMM2DI0YiLUl7e2S5W+Nn2EcurQyqXu+0/5gjGtD5XkFR6
	J+ZjEDN7FYtRCNtu5UZP1T/9vGcz3C4Z3vR5Y5B09oXpuVufdnspnfiZpx29O0CJpTgj0VCL
	uag4EQBnkBeW+QEAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds sysfs node which can be used to get information of frequency
transition. It represents transition table which contains total number of transition of
each freqeuncy state and time spent. It is inspired CPUFREQ's status driver.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
---
 drivers/devfreq/devfreq.c |   89 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/devfreq.h   |    9 +++++
 2 files changed, 98 insertions(+), 0 deletions(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 70c31d4..8b53eaf 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -72,6 +72,41 @@ static struct devfreq *find_device_devfreq(struct device *dev)
 	return ERR_PTR(-ENODEV);
 }
 
+int devfreq_get_freq_level(struct devfreq *devfreq, unsigned long freq)
+{
+	int lev;
+
+	for (lev = 0; lev < devfreq->profile->max_state; lev++)
+		if (freq == devfreq->profile->freq_table[lev])
+			return lev;
+
+	return -EINVAL;
+}
+
+int devfreq_update_status(struct devfreq *devfreq, unsigned long freq)
+{
+	int lev, prev_lev;
+	unsigned long cur_time;
+
+	lev = devfreq_get_freq_level(devfreq, freq);
+	if (lev < 0)
+		return lev;
+
+	cur_time = jiffies;
+	devfreq->time_in_state[lev] +=
+			 cur_time - devfreq->last_stat_updated;
+	if (freq != devfreq->previous_freq) {
+		prev_lev = devfreq_get_freq_level(devfreq,
+						devfreq->previous_freq);
+		devfreq->trans_table[(prev_lev *
+				devfreq->profile->max_state) + lev]++;
+		devfreq->total_trans++;
+	}
+	devfreq->last_stat_updated = cur_time;
+
+	return 0;
+}
+
 /**
  * update_devfreq() - Reevaluate the device and configure frequency.
  * @devfreq:	the devfreq instance.
@@ -115,6 +150,10 @@ int update_devfreq(struct devfreq *devfreq)
 	err = devfreq->profile->target(devfreq->dev.parent, &freq, flags);
 	if (err)
 		return err;
+	if (devfreq->profile->freq_table)
+		if (devfreq_update_status(devfreq, freq))
+			dev_err(&devfreq->dev,
+				"Couldn't update frequency transition information.\n");
 
 	devfreq->previous_freq = freq;
 	return err;
@@ -390,6 +429,15 @@ struct devfreq *devfreq_add_device(struct device *dev,
 			      = msecs_to_jiffies(devfreq->profile->polling_ms);
 	devfreq->nb.notifier_call = devfreq_notifier_call;
 
+	devfreq->trans_table =	devm_kzalloc(dev, sizeof(unsigned int) *
+						devfreq->profile->max_state *
+						devfreq->profile->max_state,
+						GFP_KERNEL);
+	devfreq->time_in_state = devm_kzalloc(dev, sizeof(unsigned int) *
+						devfreq->profile->max_state,
+						GFP_KERNEL);
+	devfreq->last_stat_updated = jiffies;
+
 	dev_set_name(&devfreq->dev, dev_name(dev));
 	err = device_register(&devfreq->dev);
 	if (err) {
@@ -587,6 +635,46 @@ static ssize_t show_max_freq(struct device *dev, struct device_attribute *attr,
 	return sprintf(buf, "%lu\n", to_devfreq(dev)->max_freq);
 }
 
+static ssize_t show_trans_table(struct device *dev, struct device_attribute *attr,
+				char *buf)
+{
+	struct devfreq *devfreq = to_devfreq(dev);
+	ssize_t len;
+	int i, j, err;
+
+	err = devfreq_update_status(devfreq, devfreq->previous_freq);
+	if (err)
+		return 0;
+
+	len = sprintf(buf, "   From  :   To\n");
+	len += sprintf(buf + len, "         :");
+	for (i = 0; i < devfreq->profile->max_state; i++)
+		len += sprintf(buf + len, "%8u",
+				devfreq->profile->freq_table[i]);
+
+	len += sprintf(buf + len, "   time(ms)\n");
+
+	for (i = 0; i < devfreq->profile->max_state; i++) {
+		if (devfreq->profile->freq_table[i]
+					== devfreq->previous_freq) {
+			len += sprintf(buf + len, "*");
+		} else {
+			len += sprintf(buf + len, " ");
+		}
+		len += sprintf(buf + len, "%8u:",
+				devfreq->profile->freq_table[i]);
+		for (j = 0; j < devfreq->profile->max_state; j++)
+			len += sprintf(buf + len, "%8u",
+					devfreq->trans_table[(i * 3) + j]);
+		len += sprintf(buf + len, "%10u\n",
+			jiffies_to_msecs(devfreq->time_in_state[i]));
+	}
+
+	len += sprintf(buf + len, "Total transition : %u\n",
+					devfreq->total_trans);
+	return len;
+}
+
 static struct device_attribute devfreq_attrs[] = {
 	__ATTR(governor, S_IRUGO, show_governor, NULL),
 	__ATTR(cur_freq, S_IRUGO, show_freq, NULL),
@@ -595,6 +683,7 @@ static struct device_attribute devfreq_attrs[] = {
 	       store_polling_interval),
 	__ATTR(min_freq, S_IRUGO | S_IWUSR, show_min_freq, store_min_freq),
 	__ATTR(max_freq, S_IRUGO | S_IWUSR, show_max_freq, store_max_freq),
+	__ATTR(trans_stat, S_IRUGO, show_trans_table, NULL),
 	{ },
 };
 
diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
index 281c72a..30dc0d8 100644
--- a/include/linux/devfreq.h
+++ b/include/linux/devfreq.h
@@ -80,6 +80,9 @@ struct devfreq_dev_profile {
 	int (*get_dev_status)(struct device *dev,
 			      struct devfreq_dev_status *stat);
 	void (*exit)(struct device *dev);
+
+	unsigned int *freq_table;
+	unsigned int max_state;
 };
 
 /**
@@ -164,6 +167,12 @@ struct devfreq {
 
 	unsigned long min_freq;
 	unsigned long max_freq;
+
+	/* information for device freqeuncy transition */
+	unsigned int total_trans;
+	unsigned int *trans_table;
+	unsigned long *time_in_state;
+	unsigned long last_stat_updated;
 };
 
 #if defined(CONFIG_PM_DEVFREQ)
-- 
1.7.4.1

