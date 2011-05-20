Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934673Ab1ETALl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:11:41 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:44268 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934622Ab1ETALg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:11:36 -0400
X-Sasl-enc: uHiuOQaOsGJTy6m9xEUEyzwV+K4T3tDtbk0YaKSrgwbw 1305850295
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 18/44] driver core/platform_device_add_data: set platform_data to NULL if !data
Date: Thu, 19 May 2011 17:10:36 -0700
Message-Id: <1305850262-9575-18-git-send-email-gregkh@suse.de>
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

This makes the data = NULL case more consistent to the data != NULL case.
The functional change is that now

	platform_device_add_data(somepdev, NULL, somesize)

sets pdev->dev.platform_data to NULL instead of not touching it.

Reviewed-by: Viresh Kumar <viresh.kumar@st.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/platform.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 9e0e4fc..65cb4c3 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -220,17 +220,16 @@ EXPORT_SYMBOL_GPL(platform_device_add_resources);
 int platform_device_add_data(struct platform_device *pdev, const void *data,
 			     size_t size)
 {
-	void *d;
+	void *d = NULL;
 
-	if (!data)
-		return 0;
-
-	d = kmemdup(data, size, GFP_KERNEL);
-	if (d) {
-		pdev->dev.platform_data = d;
-		return 0;
+	if (data) {
+		d = kmemdup(data, size, GFP_KERNEL);
+		if (!d)
+			return -ENOMEM;
 	}
-	return -ENOMEM;
+
+	pdev->dev.platform_data = d;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(platform_device_add_data);
 
-- 
1.7.4.2

