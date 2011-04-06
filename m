Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755453Ab1DFJYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 05:24:53 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35768 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430Ab1DFJYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 05:24:51 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Viresh Kumar <viresh.kumar@st.com>,
        linux-arm-kernel@lists.infradead.org, shiraz.hashim@st.com
Subject: [PATCH 3/5] driver core/platform_device_add_resources: set resource to NULL if !res
Date: Wed,  6 Apr 2011 11:24:23 +0200
Message-Id: <1302081865-2962-3-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <20110301153438.GB15633@suse.de>
References: <20110301153438.GB15633@suse.de>
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

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/base/platform.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 01caf61..812d8ff 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -191,18 +191,17 @@ EXPORT_SYMBOL_GPL(platform_device_alloc);
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
1.7.2.3

