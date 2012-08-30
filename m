Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab2H3I75 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 04:59:57 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:36985 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab2H3I7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 04:59:54 -0400
X-AuditID: cbfee61b-b7faf6d00000476a-47-503f2b86e6d5
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: myungjoo.ham@gmail.com, rjw@sisk.pl, kyungmin.park@samsung.com,
        khilman@ti.com, markgross@thegnar.org, jean.pihet@newoldbits.com,
        mturquette@ti.com, jonghwa3.lee@samsung.com
Subject: [PATCH v3 2/2] PM / devfreq: support per-dev PM-QoS in devfreq
Date: Thu, 30 Aug 2012 18:00:03 +0900
Message-id: <1346317203-7357-3-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1346317203-7357-1-git-send-email-myungjoo.ham@samsung.com>
References: <1346317203-7357-1-git-send-email-myungjoo.ham@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBJMWRmVeSWpSXmKPExsVy+t9jQd02bfsAg+/fLC0u75rDZvG59wij
	A5PH501yAYxRXDYpqTmZZalF+nYJXBl95z+wFHwUrni44zN7A+MmgS5GTg4JAROJla9Os0PY
	YhIX7q1n62Lk4hASmM4o8fjdPyYIp4VJ4tzvm8wgVWwCuhJbN9xlAbFFBKwkTv/vYAYpYhbY
	yihx7UQDK0hCWMBd4ubJh4wgNouAqkRv91mwBl6g+OXGuYwQ6xQkFtx7ywZicwp4SPy/vQGs
	Vwio5v/d80wTGHkXMDKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAj2/zPpHYyrGiwOMQpw
	MCrx8E6cahcgxJpYVlyZe4hRgoNZSYSXnd8+QIg3JbGyKrUoP76oNCe1+BCjNAeLkjiv0zmg
	aoH0xJLU7NTUgtQimCwTB6dUA6PLzofrzj/cJSW/auE9WTXRpj7D4ivrCv7ZCaiqdavO3fP8
	RpfBTfaduh7tauksV4QUEpW9ztxIfidmecuydV6f6lHvpZvNbpwVN+G9/++lQanOrHVX/Rle
	hGidShdot0q0flLJnbN/l+lesfhwg2nNxgUn7T3P3J7PE6Ujrn/66hvu/3qX/iuxFGckGmox
	FxUnAgCUlbp++wEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added support of per-dev PM-QoS request handling in devfreq core.

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
---
 drivers/devfreq/devfreq.c |   24 ++++++++++++++++--------
 1 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index d74b382..e2ae575 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -268,6 +268,9 @@ static void _remove_devfreq(struct devfreq *devfreq, bool skip)
 
 	devfreq->being_removed = true;
 
+	if (devfreq->profile->enable_dev_pm_qos)
+		dev_pm_qos_remove_notifier(devfreq->dev.parent,
+					   &devfreq->qos_nb);
 	if (devfreq->profile->qos_type)
 		pm_qos_remove_notifier(devfreq->profile->qos_type,
 				       &devfreq->qos_nb);
@@ -484,13 +487,13 @@ struct devfreq *devfreq_add_device(struct device *dev,
 	devfreq->nb.notifier_call = devfreq_notifier_call;
 	devfreq->qos_nb.notifier_call = devfreq_qos_notifier_call;
 
-	/* Check the sanity of qos_list/qos_type */
-	if (profile->qos_type || profile->qos_list) {
-
-		if (WARN(!profile->qos_type || !profile->qos_list,
+	/* Check the sanity of QoS handling specifications */
+	if (profile->qos_type || profile->enable_dev_pm_qos ||
+	    profile->qos_list) {
+		if (WARN(!profile->qos_list ||
+			 (!profile->qos_type && !profile->enable_dev_pm_qos),
 			 "QoS requirement partially omitted for %s.\n",
 			 dev_name(dev))) {
-
 			err = -EINVAL;
 			goto err_dev;
 		}
@@ -498,7 +501,6 @@ struct devfreq *devfreq_add_device(struct device *dev,
 		if (WARN(!profile->qos_list[0].freq,
 			 "The first QoS requirement is the end of list for %s.\n",
 			 dev_name(dev))) {
-
 			err = -EINVAL;
 			goto err_dev;
 		}
@@ -535,7 +537,11 @@ struct devfreq *devfreq_add_device(struct device *dev,
 			}
 		}
 
-		pm_qos_add_notifier(profile->qos_type, &devfreq->qos_nb);
+		if (profile->qos_type)
+			pm_qos_add_notifier(profile->qos_type,
+					    &devfreq->qos_nb);
+		if (profile->enable_dev_pm_qos)
+			dev_pm_qos_add_notifier(dev, &devfreq->qos_nb);
 	}
 
 	devfreq->trans_table =	devm_kzalloc(dev, sizeof(unsigned int) *
@@ -580,7 +586,9 @@ out:
 err_init:
 	device_unregister(&devfreq->dev);
 err_qos_add:
-	if (profile->qos_type || profile->qos_list)
+	if (profile->enable_dev_pm_qos)
+		dev_pm_qos_remove_notifier(dev, &devfreq->qos_nb);
+	if (profile->qos_type)
 		pm_qos_remove_notifier(profile->qos_type, &devfreq->qos_nb);
 err_dev:
 	mutex_unlock(&devfreq->lock);
-- 
1.7.4.1

