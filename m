Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab1DFJYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 05:24:38 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35738 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223Ab1DFJYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 05:24:37 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Viresh Kumar <viresh.kumar@st.com>,
        linux-arm-kernel@lists.infradead.org, shiraz.hashim@st.com
Subject: [PATCH 5/5] driver core: let dev_set_drvdata return int instead of void as it can fail
Date: Wed,  6 Apr 2011 11:24:25 +0200
Message-Id: <1302081865-2962-5-git-send-email-u.kleine-koenig@pengutronix.de>
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

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
Hello,

I wasn't sure what to return when dev_set_drvdata is called with
dev=NULL.  I choosed 0, but -EINVAL would be OK for me, too. What do you
think?

And we could add __must_check, maybe do this later =:-)

Best regards
Uwe

 drivers/base/dd.c      |    8 +++++---
 include/linux/device.h |    2 +-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index da57ee9..29ff339 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -408,17 +408,19 @@ void *dev_get_drvdata(const struct device *dev)
 }
 EXPORT_SYMBOL(dev_get_drvdata);
 
-void dev_set_drvdata(struct device *dev, void *data)
+int dev_set_drvdata(struct device *dev, void *data)
 {
 	int error;
 
 	if (!dev)
-		return;
+		return 0;
+
 	if (!dev->p) {
 		error = device_private_init(dev);
 		if (error)
-			return;
+			return error;
 	}
 	dev->p->driver_data = data;
+	return 0;
 }
 EXPORT_SYMBOL(dev_set_drvdata);
diff --git a/include/linux/device.h b/include/linux/device.h
index 1bf5cf0..9e754c7 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -558,7 +558,7 @@ extern int device_move(struct device *dev, struct device *new_parent,
 extern const char *device_get_devnode(struct device *dev,
 				      mode_t *mode, const char **tmp);
 extern void *dev_get_drvdata(const struct device *dev);
-extern void dev_set_drvdata(struct device *dev, void *data);
+extern int dev_set_drvdata(struct device *dev, void *data);
 
 /*
  * Root device objects for grouping under /sys/devices
-- 
1.7.2.3

