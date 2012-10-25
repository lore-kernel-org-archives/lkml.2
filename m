Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab2JYXc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 19:32:58 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:41902 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751387Ab2JYXc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 19:32:57 -0400
From: Nishanth Menon <nm@ti.com>
To: linux-pm <linux-pm@vger.kernel.org>
CC: Nishanth Menon <nm@ti.com>, Rajagopal Venkat <rajagopal.venkat@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>,
        <linux-kernel@vger.kernel.org>
Subject: [for-next PATCH] PM / devfreq: Add sysfs node to expose available frequencies
Date: Thu, 25 Oct 2012 18:32:43 -0500
Message-ID: <1351207963-30075-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

devfreq governors such as ondemand are controlled by a min and
max frequency, while governors like userspace governor allow us
to set a specific frequency.
However, for the same specific device, depending on the SoC, the
available frequencies can vary.

So expose the available frequencies as a snapshot over sysfs to
allow informed decisions.

This was inspired by cpufreq framework's equivalent for similar
usage sysfs node: scaling_available_frequencies.

Cc: Rajagopal Venkat <rajagopal.venkat@linaro.org>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Kevin Hilman <khilman@ti.com>
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Signed-off-by: Nishanth Menon <nm@ti.com>
---
Applies on top of Rafael's linux-next branch:
git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git
 linux-next                                   b960e9a Merge branch 'pm-sleep-next' into linux-next

Example output from Beagleboard XM (3730) using a dummy test driver
http://pastebin.pandaboard.org/index.php/view/85100576 :

/sys/devices/platform/iva.0/devfreq/iva.0 # cat available_frequencies 
260000000 520000000 660000000 

 Documentation/ABI/testing/sysfs-class-devfreq |    9 +++++++++
 drivers/devfreq/devfreq.c                     |   26 +++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-class-devfreq b/Documentation/ABI/testing/sysfs-class-devfreq
index e6cf08e..e672ccb 100644
--- a/Documentation/ABI/testing/sysfs-class-devfreq
+++ b/Documentation/ABI/testing/sysfs-class-devfreq
@@ -51,3 +51,12 @@ Description:
 		The /sys/class/devfreq/.../userspace/set_freq shows and
 		sets the requested frequency for the devfreq object if
 		userspace governor is in effect.
+
+What:		/sys/class/devfreq/.../available_frequencies
+Date:		October 2012
+Contact:	Nishanth Menon <nm@ti.com>
+Description:
+		The /sys/class/devfreq/.../available_frequencies shows
+		the available frequencies of the corresponding devfreq object.
+		This is a snapshot of available frequencies and not limited
+		by the min/max frequency restrictions.
diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index d02ee7e..2f6ad6b 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -571,9 +571,35 @@ static ssize_t show_max_freq(struct device *dev, struct device_attribute *attr,
 	return sprintf(buf, "%lu\n", to_devfreq(dev)->max_freq);
 }
 
+static ssize_t show_available_freqs(struct device *d,
+				    struct device_attribute *attr,
+				    char *buf)
+{
+	struct devfreq *df = to_devfreq(d);
+	struct device *dev = df->dev.parent;
+	struct opp *opp;
+	ssize_t count = 0;
+	unsigned long freq = 0;
+
+	rcu_read_lock();
+	do {
+		opp = opp_find_freq_ceil(dev, &freq);
+		if (IS_ERR(opp))
+			break;
+
+		count += sprintf(&buf[count], "%lu ", freq);
+		freq++;
+	} while (1);
+	rcu_read_unlock();
+	count += sprintf(&buf[count], "\n");
+
+	return count;
+}
+
 static struct device_attribute devfreq_attrs[] = {
 	__ATTR(governor, S_IRUGO, show_governor, NULL),
 	__ATTR(cur_freq, S_IRUGO, show_freq, NULL),
+	__ATTR(available_frequencies, S_IRUGO, show_available_freqs, NULL),
 	__ATTR(target_freq, S_IRUGO, show_target_freq, NULL),
 	__ATTR(polling_interval, S_IRUGO | S_IWUSR, show_polling_interval,
 	       store_polling_interval),
-- 
1.7.9.5

