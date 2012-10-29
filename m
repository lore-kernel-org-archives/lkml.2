Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759115Ab2J2UCO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:02:14 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:59322 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758869Ab2J2UCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:02:01 -0400
From: Nishanth Menon <nm@ti.com>
To: linux-pm <linux-pm@vger.kernel.org>
CC: Nishanth Menon <nm@ti.com>, Rajagopal Venkat <rajagopal.venkat@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: [linux-next PATCH 6/7] PM / devfreq: allow sysfs governor node to switch governor
Date: Mon, 29 Oct 2012 15:01:47 -0500
Message-ID: <1351540908-12195-7-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351540908-12195-1-git-send-email-nm@ti.com>
References: <1351540908-12195-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This allows us to select governor runtime from the
default configuration without having to rebuild kernel
or the devfreq driver using the sysfs node:
/sys/class/devfreq/.../governor
cat of the governor will return valid governor
and an echo 'governor_name'>governor will switch
governor

Cc: Rajagopal Venkat <rajagopal.venkat@linaro.org>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kevin Hilman <khilman@ti.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 Documentation/ABI/testing/sysfs-class-devfreq |    2 +-
 drivers/devfreq/devfreq.c                     |   40 ++++++++++++++++++++++++-
 2 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-class-devfreq b/Documentation/ABI/testing/sysfs-class-devfreq
index e672ccb..293f6b2 100644
--- a/Documentation/ABI/testing/sysfs-class-devfreq
+++ b/Documentation/ABI/testing/sysfs-class-devfreq
@@ -11,7 +11,7 @@ What:		/sys/class/devfreq/.../governor
 Date:		September 2011
 Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
 Description:
-		The /sys/class/devfreq/.../governor shows the name of the
+		The /sys/class/devfreq/.../governor show or set the name of the
 		governor used by the corresponding devfreq object.
 
 What:		/sys/class/devfreq/.../cur_freq
diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index bd96e32..8535f8c 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -629,6 +629,44 @@ static ssize_t show_governor(struct device *dev,
 	return sprintf(buf, "%s\n", to_devfreq(dev)->governor->name);
 }
 
+static ssize_t store_governor(struct device *dev, struct device_attribute *attr,
+			      const char *buf, size_t count)
+{
+	struct devfreq *df = to_devfreq(dev);
+	int ret = 0;
+	struct devfreq_governor *governor;
+
+	mutex_lock(&devfreq_list_lock);
+	governor = find_devfreq_governor(buf);
+	if (IS_ERR(governor)) {
+		ret = PTR_ERR(governor);
+		goto out;
+	}
+	if (df->governor == governor)
+		goto out;
+
+	if (df->governor) {
+		ret = df->governor->event_handler(df, DEVFREQ_GOV_STOP, NULL);
+		if (ret) {
+			dev_warn(dev, "%s: Governor %s not stopped(%d)\n",
+				 __func__, df->governor->name, ret);
+			goto out;
+		}
+	}
+	df->governor = governor;
+	strncpy(df->governor_name, governor->name, DEVFREQ_NAME_LEN);
+	ret = df->governor->event_handler(df, DEVFREQ_GOV_START, NULL);
+	if (ret)
+		dev_warn(dev, "%s: Governor %s not started(%d)\n",
+			 __func__, df->governor->name, ret);
+out:
+	mutex_unlock(&devfreq_list_lock);
+
+	if (!ret)
+		ret = count;
+	return ret;
+}
+
 static ssize_t show_freq(struct device *dev,
 			 struct device_attribute *attr, char *buf)
 {
@@ -773,7 +811,7 @@ static ssize_t show_available_freqs(struct device *d,
 }
 
 static struct device_attribute devfreq_attrs[] = {
-	__ATTR(governor, S_IRUGO, show_governor, NULL),
+	__ATTR(governor, S_IRUGO | S_IWUSR, show_governor, store_governor),
 	__ATTR(cur_freq, S_IRUGO, show_freq, NULL),
 	__ATTR(available_frequencies, S_IRUGO, show_available_freqs, NULL),
 	__ATTR(target_freq, S_IRUGO, show_target_freq, NULL),
-- 
1.7.9.5

