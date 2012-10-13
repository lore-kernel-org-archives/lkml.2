Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab2JMB6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 21:58:34 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:9260 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017Ab2JMB6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 21:58:33 -0400
X-AuditID: cbfee61a-b7f976d000001eb9-65-5078cac7772e
From: Jonghwan Choi <jhbird.choi@samsung.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: "'Pavel Machek'" <pavel@ucw.cz>, "'Rafael J. Wysocki'" <rjw@sisk.pl>
Subject: [PATCH] PM / Domains: Fix memory leak on error path in
 pm_genpd_attach_cpuidle
Date: Sat, 13 Oct 2012 10:58:31 +0900
Message-id: <001d01cda8e6$3ec8bda0$bc5a38e0$%choi@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2o5j5BgKr1Vd0DQ1mxcg3jpedf9w==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOLMWRmVeSWpSXmKPExsVy+t9jAd3jpyoCDLb/krK4vGsOm8Xn3iOM
	DkwenzfJBTBGcdmkpOZklqUW6dslcGXcnctRcIG9YtasNpYGxkusXYycHBICJhIvl81mhrDF
	JC7cW8/WxcjFISSwiFFiRsccJpCEkMBfRonnB6VAbDYBXYlj67eANYsIWEmc/t8B1sws4Cbx
	6PJ7NhBbWCBSonH/ZTCbRUBVYt351WBzeAXsJBq/nmeHsAUlfky+xwLRqyWxfudxJghbXmLz
	mrdAMzmADlKXePRXF8QUEdCT+P6nEqJCRGLfi3eMExgFZiEZNAvJoFlIBs1C0rKAkWUVo2hq
	QXJBcVJ6rqFecWJucWleul5yfu4mRnBwPpPawbiyweIQowAHoxIP783uigAh1sSy4srcQ4wS
	HMxKIrx86UAh3pTEyqrUovz4otKc1OJDjNIcLErivM0eKQFCAumJJanZqakFqUUwWSYOTqkG
	RnM14w9VL/29Gfdti0g6knbtB18Tw7OD8r82f3diW/Ml53vIo1Lx5viH0zfkMghM5hY6on3t
	iGV5wM1pSx5HesS7iD5UCw9qe27n5GjHxD5X7JDT1sgz8Y7zJyRyuPTf6c2+Kx5/n6nVe+Em
	ezV2FdsLUbllu4L1657WsuyUv1Nxke3Z1e/WSizFGYmGWsxFxYkASRVpW0oCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If pm_genpd_attach_cpudidle failed we leak memory stored in 'cpu_data'.

Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/base/power/domain.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index c22b869..96b71b6 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -1862,7 +1862,7 @@ int pm_genpd_attach_cpuidle(struct generic_pm_domain
*genpd, int state)
        cpuidle_drv = cpuidle_driver_ref();
        if (!cpuidle_drv) {
                ret = -ENODEV;
-               goto out;
+               goto err_drv;
        }
        if (cpuidle_drv->state_count <= state) {
                ret = -EINVAL;
@@ -1884,6 +1884,9 @@ int pm_genpd_attach_cpuidle(struct generic_pm_domain
*genpd, int state)

  err:
        cpuidle_driver_unref();
+
+ err_drv:
+       kfree(cpu_data);
        goto out;
 }

--
1.7.1

