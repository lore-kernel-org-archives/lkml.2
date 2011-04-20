Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab1DTHpH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 03:45:07 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41080 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489Ab1DTHpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 03:45:04 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Viresh Kumar <viresh.kumar@st.com>, shiraz.hashim@st.com,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirqus@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 3/5] driver core/platform_device_add_resources: set resource to NULL if !res
Date: Wed, 20 Apr 2011 09:44:44 +0200
Message-Id: <1303285486-28598-3-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1303285486-28598-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20110420074248.GS31131@pengutronix.de>
 <1303285486-28598-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the res = NULL case more consistant to the res != NULL case
as now both overwrite pdev->resource.

Reviewed-by: Viresh Kumar <viresh.kumar@st.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/base/platform.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 58ad8e8..667f282 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -192,18 +192,17 @@ EXPORT_SYMBOL_GPL(platform_device_alloc);
 int platform_device_add_resources(struct platform_device *pdev,
 				  const struct resource *res, unsigned int num)
 {
-	struct resource *r;
+	struct resource *r = NULL;
 
-	if (!res)
-		return 0;
-
-	r = kmemdup(res, sizeof(struct resource) * num, GFP_KERNEL);
-	if (r) {
-		pdev->resource = r;
-		pdev->num_resources = num;
-		return 0;
+	if (res) {
+		r = kmemdup(res, sizeof(struct resource) * num, GFP_KERNEL);
+		if (!r)
+			return -ENOMEM;
 	}
-	return -ENOMEM;
+
+	pdev->resource = r;
+	pdev->num_resources = num;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(platform_device_add_resources);
 
-- 
1.7.4.1

