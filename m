Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758975Ab2J2UCD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 16:02:03 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:57461 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758688Ab2J2UB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 16:01:58 -0400
From: Nishanth Menon <nm@ti.com>
To: linux-pm <linux-pm@vger.kernel.org>
CC: Nishanth Menon <nm@ti.com>, Rajagopal Venkat <rajagopal.venkat@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: [linux-next PATCH 7/7] PM / devfreq: Add sysfs node to expose available governors
Date: Mon, 29 Oct 2012 15:01:48 -0500
Message-ID: <1351540908-12195-8-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351540908-12195-1-git-send-email-nm@ti.com>
References: <1351540908-12195-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that governor list can be variable, knowing the available governors
is useful to be able to select a governor using relevant sysfs node.

Cc: Rajagopal Venkat <rajagopal.venkat@linaro.org>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kevin Hilman <khilman@ti.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 Documentation/ABI/testing/sysfs-class-devfreq |    7 +++++++
 drivers/devfreq/devfreq.c                     |   22 ++++++++++++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-class-devfreq b/Documentation/ABI/testing/sysfs-class-devfreq
index 293f6b2..0daa83f 100644
--- a/Documentation/ABI/testing/sysfs-class-devfreq
+++ b/Documentation/ABI/testing/sysfs-class-devfreq
@@ -60,3 +60,10 @@ Description:
 		the available frequencies of the corresponding devfreq object.
 		This is a snapshot of available frequencies and not limited
 		by the min/max frequency restrictions.
+
+What:		/sys/class/devfreq/.../available_governors
+Date:		October 2012
+Contact:	Nishanth Menon <nm@ti.com>
+Description:
+		The /sys/class/devfreq/.../available_governors shows
+		currently available governors in the system.
diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 8535f8c..9ed3ca5 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -666,6 +666,27 @@ out:
 		ret = count;
 	return ret;
 }
+static ssize_t show_available_governors(struct device *d,
+				    struct device_attribute *attr,
+				    char *buf)
+{
+	struct devfreq_governor *tmp_governor;
+	ssize_t count = 0;
+
+	mutex_lock(&devfreq_list_lock);
+	list_for_each_entry(tmp_governor, &devfreq_governor_list, node)
+		count += scnprintf(&buf[count], (PAGE_SIZE - count - 2),
+				   "%s ", tmp_governor->name);
+	mutex_unlock(&devfreq_list_lock);
+
+	/* Truncate the trailing space */
+	if (count)
+		count--;
+
+	count += sprintf(&buf[count], "\n");
+
+	return count;
+}
 
 static ssize_t show_freq(struct device *dev,
 			 struct device_attribute *attr, char *buf)
@@ -812,6 +833,7 @@ static ssize_t show_available_freqs(struct device *d,
 
 static struct device_attribute devfreq_attrs[] = {
 	__ATTR(governor, S_IRUGO | S_IWUSR, show_governor, store_governor),
+	__ATTR(available_governors, S_IRUGO, show_available_governors, NULL),
 	__ATTR(cur_freq, S_IRUGO, show_freq, NULL),
 	__ATTR(available_frequencies, S_IRUGO, show_available_freqs, NULL),
 	__ATTR(target_freq, S_IRUGO, show_target_freq, NULL),
-- 
1.7.9.5

