Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933013Ab2HIOcP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 10:32:15 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:37895 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932913Ab2HIOcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 10:32:09 -0400
X-AuditID: cbfee61b-b7faf6d00000476a-47-5023c9d70fe2
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH] PM / Domains: fix early device initialization failure
Date: Thu, 09 Aug 2012 16:31:34 +0200
Message-id: <1344522694-31164-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.10
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDJMWRmVeSWpSXmKPExsVy+t9jAd3rJ5UDDDbtN7K4vGsOm8Xn3iOM
	DkwenzfJBTBGcdmkpOZklqUW6dslcGVc2/KKreAvW8WUCxwNjNdYuxg5OSQETCRen+5mhLDF
	JC7cW8/WxcjFISSwiFFi/uoPUE4Xk8TGPb3sIFVsAoYSXW+72EBsEQEridP/O5i7GDk4mAXq
	JT5uNQAJCwu4SXz93gJWwiKgKvFs9h02kBJeAQ+JTyfdIXbJSzy938c2gZF7ASPDKkbR1ILk
	guKk9FwjveLE3OLSvHS95PzcTYxgPz6T3sG4qsHiEKMAB6MSD++NLUoBQqyJZcWVuYcYJTiY
	lUR47/QpBwjxpiRWVqUW5ccXleakFh9ilOZgURLnNfH+6i8kkJ5YkpqdmlqQWgSTZeLglGpg
	XFAuK3V4k7U654em3qcezjd/uO6NSZetrXy9r0v66uT4Vf7XN8a9TNd/WD8786BlsVZbld+R
	WbsOsvNHudY8PXSsR76q7ZXGBPV5h13drOzO6OjX7Lr9Z6f/m08ZPaVbTJb8OiayP0tuu9wW
	Q9af7p37Xq05Ua90/eqhwuCKTuey9g/neneGKLEUZyQaajEXFScCAJddgv/fAQAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dev_pm_get_subsys_data() returns 1 when a new object has been created,
what should not be considered as an error for pm_genpd_add_device().

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 drivers/base/power/domain.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index ba3487c..6b61819 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -1323,9 +1323,16 @@ int __pm_genpd_add_device(struct generic_pm_domain *genpd, struct device *dev,
 		}
 
 	ret = dev_pm_get_subsys_data(dev);
-	if (ret)
+
+	if (ret < 0)
 		goto out;
 
+	/*
+	 * dev_pm_get_subsys_data() returns 1 when new object has been created
+	 */
+	if (ret == 1)
+		ret = 0;
+
 	genpd->device_count++;
 	genpd->max_off_time_changed = true;
 
-- 
1.7.1.569.g6f426

