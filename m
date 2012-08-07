Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148Ab2HGJFo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 05:05:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60233 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab2HGJFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 05:05:42 -0400
From: Tushar Behera <tushar.behera@linaro.org>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: len.brown@intel.com, pavel@ucw.cz, rjw@sisk.pl, patches@linaro.org
Subject: [PATCH] PM / Domains: Not return error when dev_pm_get_subsys_data returns 1
Date: Tue,  7 Aug 2012 14:34:16 +0530
Message-Id: <1344330256-6939-1-git-send-email-tushar.behera@linaro.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 1d5fcfec22 ("PM / Domains: Add device domain data reference
counter") returns error when dev_pm_get_subsys_data() returns a
non-zero value.

However, dev_pm_get_subsys_data() returns 1 when dev->power.subsys_data
is allocated during this call. Hence we should only check for the error
codes in the return value.

Without this patch, following errors are encountered while adding
devices to powerdomain on Origen board (based on EXYNOS4210).

exynos_pm_add_dev_to_genpd: error in adding exynos4-fb.0 device to pd-lcd0 powerdomain

Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
---
 drivers/base/power/domain.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index ba3487c..f6802cb 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -1323,7 +1323,7 @@ int __pm_genpd_add_device(struct generic_pm_domain *genpd, struct device *dev,
 		}
 
 	ret = dev_pm_get_subsys_data(dev);
-	if (ret)
+	if (ret < 0)
 		goto out;
 
 	genpd->device_count++;
@@ -1358,7 +1358,7 @@ int __pm_genpd_add_device(struct generic_pm_domain *genpd, struct device *dev,
 	if (gpd_data != gpd_data_new)
 		__pm_genpd_free_dev_data(dev, gpd_data_new);
 
-	return ret;
+	return (ret < 0) ? : 0;
 }
 
 /**
-- 
1.7.4.1

