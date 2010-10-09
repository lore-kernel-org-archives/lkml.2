Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332Ab0JIWhy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 18:37:54 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42834 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212Ab0JIWhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 18:37:52 -0400
From: James Hogan <james@albanarts.com>
To: linux-pm@lists.linux-foundation.org
Subject: [PATCH 2/2] pm_trace: Add sysfs attr for rechecking dev hash.
Date: Sat, 9 Oct 2010 23:37:47 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7-custom+; KDE/4.4.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Randy Dunlap <rdunlap@xenotime.net>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        markgross <markgross@thegnar.org>
References: <201010092334.27808.james@albanarts.com>
In-Reply-To: <201010092334.27808.james@albanarts.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201010092337.47821.james@albanarts.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the device which fails to resume is part of a loadable kernel module
it won't be checked at startup against the magic number stored in the
RTC.

Add a read-only sysfs attribute /sys/power/pm_trace_dev_hash which
contains a list of newline separated devices (usually just the one)
which currently match the last magic number. This allows the device
which is failing to resume to be found after the modules are loaded
again.

Signed-off-by: James Hogan <james@albanarts.com>
---
 Documentation/power/s2ram.txt |    7 +++++++
 drivers/base/power/trace.c    |   27 +++++++++++++++++++++++++++
 include/linux/resume-trace.h  |    2 ++
 kernel/power/main.c           |   18 ++++++++++++++++++
 4 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/Documentation/power/s2ram.txt b/Documentation/power/s2ram.txt
index 514b94f..3a2801a 100644
--- a/Documentation/power/s2ram.txt
+++ b/Documentation/power/s2ram.txt
@@ -49,6 +49,13 @@ machine that doesn't boot) is:
    device (lspci and /sys/devices/pci* is your friend), and see if you can
    fix it, disable it, or trace into its resume function.
 
+   If no device matches the hash, it may be a device from a loadable kernel
+   module that is not loaded until after the hash is checked. You can check
+   the hash against the current devices again after more modules are loaded
+   using sysfs:
+
+	cat /sys/power/pm_trace_dev_hash
+
 For example, the above happens to be the VGA device on my EVO, which I
 used to run with "radeonfb" (it's an ATI Radeon mobility). It turns out
 that "radeonfb" simply cannot resume that device - it tries to set the
diff --git a/drivers/base/power/trace.c b/drivers/base/power/trace.c
index 17e24e3..e0cdba1 100644
--- a/drivers/base/power/trace.c
+++ b/drivers/base/power/trace.c
@@ -207,6 +207,33 @@ static int show_dev_hash(unsigned int value)
 
 static unsigned int hash_value_early_read;
 
+int snprint_trace_dev_hash(char *buf, size_t size)
+{
+	unsigned int value = hash_value_early_read / (USERHASH * FILEHASH);
+	int ret = 0;
+	struct list_head *entry;
+
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
index bc8c388..02b114c 100644
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
+extern int snprint_trace_dev_hash(char *buf, size_t size);
 
 #define TRACE_DEVICE(dev) do { \
 	if (pm_trace_enabled) \
diff --git a/kernel/power/main.c b/kernel/power/main.c
index 62b0bc6..42f8d1d 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -281,12 +281,30 @@ pm_trace_store(struct kobject *kobj, struct kobj_attribute *attr,
 }
 
 power_attr(pm_trace);
+
+static ssize_t pm_trace_dev_hash_show(struct kobject *kobj,
+				  struct kobj_attribute *attr,
+				  char *buf)
+{
+	return snprint_trace_dev_hash(buf, PAGE_SIZE);
+}
+
+static ssize_t
+pm_trace_dev_hash_store(struct kobject *kobj, struct kobj_attribute *attr,
+	       const char *buf, size_t n)
+{
+	return -EINVAL;
+}
+
+power_attr(pm_trace_dev_hash);
+
 #endif /* CONFIG_PM_TRACE */
 
 static struct attribute * g[] = {
 	&state_attr.attr,
 #ifdef CONFIG_PM_TRACE
 	&pm_trace_attr.attr,
+	&pm_trace_dev_hash_attr.attr,
 #endif
 #ifdef CONFIG_PM_SLEEP
 	&pm_async_attr.attr,
-- 
1.7.2.3

