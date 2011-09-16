Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435Ab1IPWQ2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 18:16:28 -0400
Received: from smtp-out.google.com ([216.239.44.51]:12034 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231Ab1IPWQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 18:16:26 -0400
From: Vincent Palatin <vpalatin@chromium.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
        Linux PCI <linux-pci@vger.kernel.org>
Cc: Olof Johansson <olofj@chromium.org>, Sameer Nanda <snanda@chromium.org>,
        Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org,
        Vincent Palatin <vpalatin@chromium.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 1/2] PM / Runtime: add conditional trace macro
Date: Fri, 16 Sep 2011 15:15:54 -0700
Message-Id: <1316211355-2888-2-git-send-email-vpalatin@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1316211355-2888-1-git-send-email-vpalatin@chromium.org>
References: <1316211355-2888-1-git-send-email-vpalatin@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new "dev_printk_norpm" macro which prints the trace only when the
device has not the runtime PM activated.
Some traces (e.g. PCI configuration) are useful in default mode but when
the runtime PM is activated, they become very noisy if the device is
often enabled/disabled.

If needed, CONFIG_PM_VERBOSE will re-activate all the original traces.

Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
---
 include/linux/pm_runtime.h |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/linux/pm_runtime.h b/include/linux/pm_runtime.h
index daac05d..57da18c 100644
--- a/include/linux/pm_runtime.h
+++ b/include/linux/pm_runtime.h
@@ -22,6 +22,18 @@
 					    usage_count */
 #define RPM_AUTO		0x08	/* Use autosuspend_delay */
 
+/* print trace only if the runtime PM is not activated on the device */
+#ifdef CONFIG_PM_VERBOSE
+#define dev_printk_norpm(level, dev, format, ...)      \
+	dev_printk(level, dev, format, ##__VA_ARGS__);
+#else
+#define dev_printk_norpm(level, dev, format, ...)              \
+({                                                             \
+	if (!pm_runtime_enabled(dev))                          \
+		dev_printk(level, dev, format, ##__VA_ARGS__); \
+})
+#endif
+
 #ifdef CONFIG_PM_RUNTIME
 
 extern struct workqueue_struct *pm_wq;
-- 
1.7.3.1

