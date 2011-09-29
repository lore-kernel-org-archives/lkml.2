Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755983Ab1I2MTF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 08:19:05 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:18135 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755866Ab1I2MSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 08:18:49 -0400
X-AuditID: cbfee61a-b7cf1ae00000208e-90-4e846224856b
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-pm@lists.linux-foundation.org
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@suse.de>, Kevin Hilman <khilman@ti.com>,
        Nishanth Menon <nm@ti.com>, Kyungmin Park <kyungmin.park@samsung.com>,
        Colin Cross <ccross@google.com>, Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@ti.com>, myungjoo.ham@gmail.com
Subject: [PATCH v13 3/4] PM / devfreq: add common sysfs interfaces
Date: Thu, 29 Sep 2011 21:18:49 +0900
Message-id: <1317298730-10442-4-git-send-email-myungjoo.ham@samsung.com>
X-Mailer: git-send-email 1.7.4.1
In-reply-to: <1317298730-10442-1-git-send-email-myungjoo.ham@samsung.com>
References: <1317298730-10442-1-git-send-email-myungjoo.ham@samsung.com>
X-OriginalArrivalTime: 29 Sep 2011 12:18:42.0837 (UTC)
 FILETIME=[ED9F3450:01CC7EA1]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Device specific sysfs interface /sys/devices/.../power/devfreq_*
- governor	R: name of governor
- cur_freq	R: current frequency
- polling_interval	R: polling interval in ms given with devfreq profile
			W: update polling interval.
- central_polling	R: 1 if polling is managed by devfreq framework

Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Reviewed-by: Mike Turquette <mturquette@ti.com>
Acked-by: Kevin Hilman <khilman@ti.com>

--
Changes from v11
- Revised sysfs function style
- Revised lock usages in store_polling_interval()
- Moved "devfreq_class->dev_attrs = devfreq_attrs;" statement from 2/4
  to 3/4 patch.

Changes from v10
- removed min_freq, max_freq as OPP dependency is removed and devfreq
object does not aware of such values.

Changes from v9
- removed find_devfreq loop in sysfs functions
- moved ABI document location due to sysfs location change
- removed unnecessary locks

Changes from v8
- applied per-devfreq locking mechanism

Changes from v7
- removed set_freq from the common devfreq interface
- added get_devfreq, a mutex-protected wrapper for find_device_devfreq
(for sysfs interfaces and later with governor-support)
- corrected ABI documentation.

Changes from v6
- poling_interval is writable.

Changes from v5
- updated devferq_update usage.

Changes from v4
- removed system-wide sysfs interface
- removed tickling sysfs interface
- added set_freq for userspace governor (and any other governors that
  require user input)

Changes from v3
- corrected sysfs API usage
- corrected error messages
- moved sysfs entry location
- added sysfs entries

Changes from v2
- add ABI entries for devfreq sysfs interface
---
 Documentation/ABI/testing/sysfs-class-devfreq |   44 ++++++++++++++++
 drivers/devfreq/devfreq.c                     |   69 +++++++++++++++++++++++++
 2 files changed, 113 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-devfreq

diff --git a/Documentation/ABI/testing/sysfs-class-devfreq b/Documentation/ABI/testing/sysfs-class-devfreq
new file mode 100644
index 0000000..0ec855f
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-class-devfreq
@@ -0,0 +1,44 @@
+What:		/sys/class/devfreq/.../
+Date:		September 2011
+Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
+Description:
+		Provide a place in sysfs for the devfreq objects.
+		This allows accessing various devfreq specific variables.
+		The name of devfreq object denoted as ... is same as the
+		name of device using devfreq.
+
+What:		/sys/class/devfreq/.../governor
+Date:		September 2011
+Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
+Description:
+		The /sys/class/devfreq/.../governor shows the name of the
+		governor used by the corresponding devfreq object.
+
+What:		/sys/class/devfreq/.../cur_freq
+Date:		September 2011
+Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
+Description:
+		The /sys/class/devfreq/.../cur_freq shows the current
+		frequency of the corresponding devfreq object.
+
+What:		/sys/class/devfreq/.../central_polling
+Date:		September 2011
+Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
+Description:
+		The /sys/class/devfreq/.../central_polling shows whether
+		the devfreq ojbect is using devfreq-provided central
+		polling mechanism or not.
+
+What:		/sys/class/devfreq/.../polling_interval
+Date:		September 2011
+Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
+Description:
+		The /sys/class/devfreq/.../polling_interval shows and sets
+		the requested polling interval of the corresponding devfreq
+		object. The values are represented in ms. If the value is
+		less than 1 jiffy, it is considered to be 0, which means
+		no polling. This value is meaningless if the governor is
+		not polling; thus. If the governor is not using
+		devfreq-provided central polling
+		(/sys/class/devfreq/.../central_polling is 0), this value
+		may be useless.
diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 8ecab66..fe65bc4 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -437,6 +437,74 @@ int devfreq_remove_device(struct devfreq *devfreq)
 	return 0;
 }
 
+static ssize_t show_governor(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%s\n", to_devfreq(dev)->governor->name);
+}
+
+static ssize_t show_freq(struct device *dev,
+			 struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%lu\n", to_devfreq(dev)->previous_freq);
+}
+
+static ssize_t show_polling_interval(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d\n", to_devfreq(dev)->profile->polling_ms);
+}
+
+static ssize_t store_polling_interval(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
+{
+	struct devfreq *df = to_devfreq(dev);
+	unsigned int value;
+	int ret;
+
+	ret = sscanf(buf, "%u", &value);
+	if (ret != 1)
+		goto out;
+
+	mutex_lock(&df->lock);
+	df->profile->polling_ms = value;
+	df->next_polling = df->polling_jiffies
+			 = msecs_to_jiffies(value);
+	mutex_unlock(&df->lock);
+
+	ret = count;
+
+	if (df->governor->no_central_polling)
+		goto out;
+
+	mutex_lock(&devfreq_list_lock);
+	if (df->next_polling > 0 && !polling) {
+		polling = true;
+		queue_delayed_work(devfreq_wq, &devfreq_work,
+				   df->next_polling);
+	}
+	mutex_unlock(&devfreq_list_lock);
+out:
+	return ret;
+}
+
+static ssize_t show_central_polling(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d\n",
+		       !to_devfreq(dev)->governor->no_central_polling);
+}
+
+static struct device_attribute devfreq_attrs[] = {
+	__ATTR(governor, S_IRUGO, show_governor, NULL),
+	__ATTR(cur_freq, S_IRUGO, show_freq, NULL),
+	__ATTR(central_polling, S_IRUGO, show_central_polling, NULL),
+	__ATTR(polling_interval, S_IRUGO | S_IWUSR, show_polling_interval,
+	       store_polling_interval),
+	{ },
+};
+
 /**
  * devfreq_start_polling() - Initialize data structure for devfreq framework and
  *			   start polling registered devfreq devices.
@@ -461,6 +529,7 @@ static int __init devfreq_init(void)
 		pr_err("%s: couldn't create class\n", __FILE__);
 		return PTR_ERR(devfreq_class);
 	}
+	devfreq_class->dev_attrs = devfreq_attrs;
 	return 0;
 }
 subsys_initcall(devfreq_init);
-- 
1.7.4.1

