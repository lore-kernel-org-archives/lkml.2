Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab1DTHo4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 03:44:56 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41045 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab1DTHoz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 03:44:55 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Viresh Kumar <viresh.kumar@st.com>, shiraz.hashim@st.com,
        =?UTF-8?q?Micha=C5=82=20Miros=C5=82aw?= <mirqus@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH v2 1/5] driver core/platform_device_add_data: set platform_data to NULL if !data
Date: Wed, 20 Apr 2011 09:44:42 +0200
Message-Id: <1303285486-28598-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <20110420074248.GS31131@pengutronix.de>
References: <20110420074248.GS31131@pengutronix.de>
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

This makes the data = NULL case more consistent to the data != NULL case.
The functional change is that now

	platform_device_add_data(somepdev, NULL, somesize)

sets pdev->dev.platform_data to NULL instead of not touching it.

Reviewed-by: Viresh Kumar <viresh.kumar@st.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
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
1.7.4.1

