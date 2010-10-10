Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757529Ab0JJBHh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 21:07:37 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:44180 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753091Ab0JJBHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 21:07:35 -0400
From: James Hogan <james@albanarts.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] pm_trace: Add sysfs attr for rechecking dev hash.
Date: Sun, 10 Oct 2010 02:06:39 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7-custom+; KDE/4.4.5; x86_64; ; )
Cc: linux-doc@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        Randy Dunlap <rdunlap@xenotime.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        markgross <markgross@thegnar.org>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, "Greg Kroah-Hartman" <gregkh@suse.de>
References: <201010100202.01605.james@albanarts.com>
In-Reply-To: <201010100202.01605.james@albanarts.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201010100206.39777.james@albanarts.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the device which fails to resume is part of a loadable kernel module
it won't be checked at startup against the magic number stored in the
RTC.

Add a read-only sysfs attribute /sys/power/pm_trace_dev_match which
contains a list of newline separated devices (usually just the one)
which currently match the last magic number. This allows the device
which is failing to resume to be found after the modules are loaded
again.

Signed-off-by: James Hogan <james@albanarts.com>
---
 Documentation/ABI/testing/sysfs-power |   29 +++++++++++++++++++++++++++++
 Documentation/power/s2ram.txt         |    7 +++++++
 drivers/base/power/trace.c            |   31 +++++++++++++++++++++++++++++++
 include/linux/resume-trace.h          |    2 ++
 kernel/power/main.c                   |   18 ++++++++++++++++++
 5 files changed, 87 insertions(+), 0 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-power b/Documentation/ABI/testing/sysfs-power
index 2875f1f..194ca44 100644
--- a/Documentation/ABI/testing/sysfs-power
+++ b/Documentation/ABI/testing/sysfs-power
@@ -99,9 +99,38 @@ Description:
 
 		dmesg -s 1000000 | grep 'hash matches'
 
+		If you do not get any matches (or they appear to be false
+		positives), it is possible that the last PM event point
+		referred to a device created by a loadable kernel module.  In
+		this case cat /sys/power/pm_trace_dev_match (see below) after
+		your system is started up and the kernel modules are loaded.
+
 		CAUTION: Using it will cause your machine's real-time (CMOS)
 		clock to be set to a random invalid time after a resume.
 
+What;		/sys/power/pm_trace_dev_match
+Date:		October 2010
+Contact:	James Hogan <james@albanarts.com>
+Description:
+		The /sys/power/pm_trace_dev_match file contains the name of the
+		device associated with the last PM event point saved in the RTC
+		across reboots when pm_trace has been used.  More precisely it
+		contains the list of current devices (including those
+		registered by loadable kernel modules since boot) which match
+		the device hash in the RTC at boot, with a newline after each
+		one.
+
+		The advantage of this file over the hash matches printed to the
+		kernel log (see /sys/power/pm_trace), is that it includes
+		devices created after boot by loadable kernel modules.
+
+		Due to the small hash size necessary to fit in the RTC, it is
+		possible that more than one device matches the hash, in which
+		case further investigation is required to determine which
+		device is causing the problem.  Note that genuine RTC clock
+		values (such as when pm_trace has not been used), can still
+		match a device and output it's name here.
+
 What:		/sys/power/pm_async
 Date:		January 2009
 Contact:	Rafael J. Wysocki <rjw@sisk.pl>
diff --git a/Documentation/power/s2ram.txt b/Documentation/power/s2ram.txt
index 514b94f..1bdfa04 100644
--- a/Documentation/power/s2ram.txt
+++ b/Documentation/power/s2ram.txt
@@ -49,6 +49,13 @@ machine that doesn't boot) is:
    device (lspci and /sys/devices/pci* is your friend), and see if you can
    fix it, disable it, or trace into its resume function.
 
+   If no device matches the hash (or any matches appear to be false positives),
+   the culprit may be a device from a loadable kernel module that is not loaded
+   until after the hash is checked. You can check the hash against the current
+   devices again after more modules are loaded using sysfs:
+
+	cat /sys/power/pm_trace_dev_match
+
 For example, the above happens to be the VGA device on my EVO, which I
 used to run with "radeonfb" (it's an ATI Radeon mobility). It turns out
 that "radeonfb" simply cannot resume that device - it tries to set the
diff --git a/drivers/base/power/trace.c b/drivers/base/power/trace.c
index 17e24e3..9f4258d 100644
--- a/drivers/base/power/trace.c
+++ b/drivers/base/power/trace.c
@@ -207,6 +207,37 @@ static int show_dev_hash(unsigned int value)
 
 static unsigned int hash_value_early_read;
 
+int show_trace_dev_match(char *buf, size_t size)
+{
+	unsigned int value = hash_value_early_read / (USERHASH * FILEHASH);
+	int ret = 0;
+	struct list_head *entry;
+
+	/*
+	 * It's possible that multiple devices will match the hash and we can't
+	 * tell which is the culprit, so it's best to output them all.
+	 */
+	device_pm_lock();
+	entry = dpm_list.prev;
+	while (size && entry != &dpm_list) {
+		struct device *dev = to_device(entry);
+		unsigned int hash = hash_string(DEVSEED, dev_name(dev),
+						DEVHASH);
+		if (hash == value) {
+			int len = snprintf(buf, size, "%s\n",
+					    dev_driver_string(dev));
+			if (len > size)
+				len = size;
+			buf += len;
+			ret += len;
+			size -= len;
+		}
+		entry = entry->prev;
+	}
+	device_pm_unlock();
+	return ret;
+}
+
 static int early_resume_init(void)
 {
 	hash_value_early_read = read_magic_time();
diff --git a/include/linux/resume-trace.h b/include/linux/resume-trace.h
index bc8c388..f31db23 100644
--- a/include/linux/resume-trace.h
+++ b/include/linux/resume-trace.h
@@ -3,6 +3,7 @@
 
 #ifdef CONFIG_PM_TRACE
 #include <asm/resume-trace.h>
+#include <linux/types.h>
 
 extern int pm_trace_enabled;
 
@@ -14,6 +15,7 @@ static inline int pm_trace_is_enabled(void)
 struct device;
 extern void set_trace_device(struct device *);
 extern void generate_resume_trace(const void *tracedata, unsigned int user);
+extern int show_trace_dev_match(char *buf, size_t size);
 
 #define TRACE_DEVICE(dev) do { \
 	if (pm_trace_enabled) \
diff --git a/kernel/power/main.c b/kernel/power/main.c
index 62b0bc6..1a357b3 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -281,12 +281,30 @@ pm_trace_store(struct kobject *kobj, struct kobj_attribute *attr,
 }
 
 power_attr(pm_trace);
+
+static ssize_t pm_trace_dev_match_show(struct kobject *kobj,
+				       struct kobj_attribute *attr,
+				       char *buf)
+{
+	return show_trace_dev_match(buf, PAGE_SIZE);
+}
+
+static ssize_t
+pm_trace_dev_match_store(struct kobject *kobj, struct kobj_attribute *attr,
+			 const char *buf, size_t n)
+{
+	return -EINVAL;
+}
+
+power_attr(pm_trace_dev_match);
+
 #endif /* CONFIG_PM_TRACE */
 
 static struct attribute * g[] = {
 	&state_attr.attr,
 #ifdef CONFIG_PM_TRACE
 	&pm_trace_attr.attr,
+	&pm_trace_dev_match_attr.attr,
 #endif
 #ifdef CONFIG_PM_SLEEP
 	&pm_async_attr.attr,
-- 
1.7.2.3

