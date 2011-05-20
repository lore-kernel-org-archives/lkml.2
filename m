Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756802Ab1ETARs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:17:48 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:58582 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934654Ab1ETALk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:11:40 -0400
X-Sasl-enc: DIMbh1ZTcJyrw7hAqiqIRopP9bYX+Ox76xywy+RNgXk1 1305850299
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 20/44] driver core/platform_device_add_resources: set resource to NULL if !res
Date: Thu, 19 May 2011 17:10:38 -0700
Message-Id: <1305850262-9575-20-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1305850262-9575-1-git-send-email-gregkh@suse.de>
References: <20110520000821.GA9367@kroah.com>
 <1305850262-9575-1-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

This makes the res = NULL case more consistant to the res != NULL case
as now both overwrite pdev->resource.

Reviewed-by: Viresh Kumar <viresh.kumar@st.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.7.4.2

