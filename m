Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab2HPGty (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 02:49:54 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:56145 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755332Ab2HPGtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 02:49:39 -0400
X-AuditID: cbfee61b-b7faf6d00000476a-61-502c98010c3b
From: Jonghwa Lee <jonghwa3.lee@samsung.com>
To: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Mike Turquette <mturquette@ti.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Xiaoguang Chen <chenxg@marvell.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>
Subject: [PATCH 2/2] devfreq: exynos4: Support initialization of freq_table and
 max_state of devfreq's profile.
Date: Thu, 16 Aug 2012 15:49:27 +0900
Message-id: <1345099767-13467-3-git-send-email-jonghwa3.lee@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1345099767-13467-1-git-send-email-jonghwa3.lee@samsung.com>
References: <1345099767-13467-1-git-send-email-jonghwa3.lee@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGJMWRmVeSWpSXmKPExsVy+t9jQV3GGToBBtd+allc3jWHzeJz7xFG
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDKu9D9iLrjEV3H6yi72BsaJPF2MnBwSAiYSSx/9ZoOw
	xSQu3FsPZHNxCAlMZ5T4drGbFcJpYZLo+nGdBaSKTUBH4v++m+wgtoiAlcSL9lfsIEXMAh8Y
	Jbb1r2YFSQgLFEocv9AF1MDBwSKgKrFzawSIySvgIfF/axnEMgWJBffegi3mFPCUmDH9Klin
	EFDJ6nN9rBMYeRcwMqxiFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECPb9M+kdjKsaLA4xCnAw
	KvHwHvivHSDEmlhWXJl7iFGCg1lJhPd2rU6AEG9KYmVValF+fFFpTmrxIUZpDhYlcV4T76/+
	QgLpiSWp2ampBalFMFkmDk6pBsbeh3MKBKXmHo36fGvtmezYS5OyCn8FmEde6rn3acKTwztS
	zb05/z/ZwnlWePa+9iT+Qp9g68N5ss/YO47Xp972rH7ct/9WVm7Stejur/8fcP+v0l262k18
	6p5ob91I48CVN9fUuR27anNq5ZJzgsulQ2SiXFy6PXrTXA81PL505O1U5i8cKrOVWIozEg21
	mIuKEwEF3niA+QEAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch initializes freq_table and max_state of devfreq's profile.
They will be used for creating transition table.

Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
---
 drivers/devfreq/exynos4_bus.c |   30 +++++++++++++++++++++++++++++-
 1 files changed, 29 insertions(+), 1 deletions(-)

diff --git a/drivers/devfreq/exynos4_bus.c b/drivers/devfreq/exynos4_bus.c
index 88ddc77..9c08855 100644
--- a/drivers/devfreq/exynos4_bus.c
+++ b/drivers/devfreq/exynos4_bus.c
@@ -985,7 +985,8 @@ static __devinit int exynos4_busfreq_probe(struct platform_device *pdev)
 	struct busfreq_data *data;
 	struct opp *opp;
 	struct device *dev = &pdev->dev;
-	int err = 0;
+	int err = 0, i;
+	unsigned int *freq_table;
 
 	data = kzalloc(sizeof(struct busfreq_data), GFP_KERNEL);
 	if (data == NULL) {
@@ -1042,6 +1043,33 @@ static __devinit int exynos4_busfreq_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, data);
 
+	switch (data->type) {
+	case TYPE_BUSF_EXYNOS4210:
+		freq_table = devm_kzalloc(&pdev->dev, sizeof(unsigned int) * EX4210_LV_NUM,
+					GFP_KERNEL);
+
+		for (i = 0; i < EX4210_LV_NUM; i++)
+			freq_table[i] = exynos4210_busclk_table[i].clk;
+
+		exynos4_devfreq_profile.max_state = EX4210_LV_NUM;
+		break;
+	case TYPE_BUSF_EXYNOS4x12:
+		freq_table = devm_kzalloc(&pdev->dev, sizeof(unsigned int) * EX4x12_LV_NUM,
+					GFP_KERNEL);
+
+		for (i = 0; i < EX4x12_LV_NUM; i++)
+			freq_table[i] = exynos4x12_mifclk_table[i].clk;
+
+		exynos4_devfreq_profile.max_state = EX4x12_LV_NUM;
+		break;
+	default:
+		dev_err(dev, "Cannot determine the device id %d\n", data->type);
+		err = -EINVAL;
+		goto err_opp_add;
+	}
+
+	exynos4_devfreq_profile.freq_table = freq_table;
+
 	busfreq_mon_reset(data);
 
 	data->devfreq = devfreq_add_device(dev, &exynos4_devfreq_profile,
-- 
1.7.4.1

