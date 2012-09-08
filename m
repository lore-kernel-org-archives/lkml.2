Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759922Ab2IHB1p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 21:27:45 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:50438 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758667Ab2IHB1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 21:27:43 -0400
Date: Fri, 7 Sep 2012 20:26:50 -0500
From: David Fries <david@fries.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        Matthew Garrett <mjg@redhat.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: [PATCH] rtc_sysfs_show_hctosys(): display 0 if resume failed
Message-ID: <20120908012650.GA32326@spacedout.fries.net>
References: <20120826021931.GA20620@spacedout.fries.net>
 <20120907165626.c9b842b1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20120907165626.c9b842b1.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.7 (SpacedOut.fries.net [127.0.0.1]); Fri, 07 Sep 2012 20:26:53 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Without this patch /sys/class/rtc/$CONFIG_RTC_HCTOSYS_DEVICE/hctosys
contains a 1 (meaning "This rtc was used to initialize the system
clock") even if setting the time by do_settimeofday() at bootup failed.
The RTC can also be used to set the clock on resume, if it did 1,
otherwise 0.  Previously there was no indication if the RTC was used
to set the clock in resume.

This uses only CONFIG_RTC_HCTOSYS_DEVICE for conditional compilation
instead of it and CONFIG_RTC_HCTOSYS to be more consistent.
rtc_hctosys_ret was moved to class.c so class.c no longer depends on
hctosys.c.

Signed-off-by: David Fries <David@Fries.net>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
---

On Fri, Sep 07, 2012 at 04:56:26PM -0700, Andrew Morton wrote:
> On Sat, 25 Aug 2012 21:19:31 -0500
> David Fries <david@fries.net> wrote:
> 
> > Subject: [PATCH] rtc_sysfs_show_hctosys 0 if resume failed
> 
> This doesn't make much sense.  Did you mean "rtc_sysfs_show_hctosys():
> display 0 if resume failed"?

Sounds good, I was just trying to keep it short.

> > The original rtc_sysfs_show_hctosys returnd 1 if this device was the
> > CONFIG_RTC_HCTOSYS_DEVICE device, a later patch checked
> > rtc_hctosys_ret from boot, this verifies boot do_settimeofday
> > succeeded, and sets rtc_hctosys_ret in resume to indicate when
> > adjusting the clock from resume fails.
> > 
> > This uses only CONFIG_RTC_HCTOSYS_DEVICE for conditional compilation
> > instead of it and CONFIG_RTC_HCTOSYS.  rtc_hctosys_ret was moved to
> > class.c so rtc_hctosys can be removed with just a Kconfig change if
> > boot time setting isn't desired.
> 
> And this makes my head spin.  What does the patch actually do?  I think
> it might fix a bug, but it's unclear what that bug is.

Too much history apparently.  The obvious bug is
the previous commit to rtc-sysfs.c
d0ab4a4d5094e5d17b103dc5073529a04f00a469 
failed to check if the clock set function succeeded at boot.

This also includes the results of setting or not the system clock at
the last resume operation instead of continuing to only return the
boot clock set operation.

My original goal came from the Nokia N900 2.6.28.10++ where the RTC
was compiled as a module but Kconfig and Makefile rules required it to
be compiled in to the kernel to use the RTC in resume, but that's not
a code requirement, using the RTC at boot is independent of using the
RTC at resume.  There I changed Kconfig and Makefile to continue
compiling it as a module, not include the boot time set rtc-core.c and
allow it to restore the RTC at resume.  I went to do the same upstream
and found that the v3.0-rc1 kernel no longer allows the RTC core to be
compiled as a module, but I saw these other issues, so I went ahead
and wrote them up.  Currently the RTC is either never used to set the
system time in the kernel, or it allows boot and resume.  I'm not sure
if there is value of setting the time at boot but not resume, or at
resume but not boot, but Kconfig/Makefile can support that (without a
source code change with this patch).

> Can you please write a better changelog and title and resend?
> 
> Sorry.

 drivers/rtc/class.c     |    5 ++++-
 drivers/rtc/hctosys.c   |    4 +---
 drivers/rtc/rtc-sysfs.c |    6 ++++++
 include/linux/rtc.h     |    2 +-
 4 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/rtc/class.c b/drivers/rtc/class.c
index dc4c274..298f69a 100644
--- a/drivers/rtc/class.c
+++ b/drivers/rtc/class.c
@@ -39,7 +39,8 @@ static void rtc_device_release(struct device *dev)
  */
 
 static struct timespec old_rtc, old_system, old_delta;
-
+/* Result of the last RTC to system clock attempt. */
+int rtc_hctosys_ret = -ENODEV;
 
 static int rtc_suspend(struct device *dev, pm_message_t mesg)
 {
@@ -84,6 +85,7 @@ static int rtc_resume(struct device *dev)
 	struct timespec		new_system, new_rtc;
 	struct timespec		sleep_time;
 
+	rtc_hctosys_ret = -ENODEV;
 	if (strcmp(dev_name(&rtc->dev), CONFIG_RTC_HCTOSYS_DEVICE) != 0)
 		return 0;
 
@@ -117,6 +119,7 @@ static int rtc_resume(struct device *dev)
 
 	if (sleep_time.tv_sec >= 0)
 		timekeeping_inject_sleeptime(&sleep_time);
+	rtc_hctosys_ret = 0;
 	return 0;
 }
 
diff --git a/drivers/rtc/hctosys.c b/drivers/rtc/hctosys.c
index bc90b09..4aa60d7 100644
--- a/drivers/rtc/hctosys.c
+++ b/drivers/rtc/hctosys.c
@@ -22,8 +22,6 @@
  * the best guess is to add 0.5s.
  */
 
-int rtc_hctosys_ret = -ENODEV;
-
 static int __init rtc_hctosys(void)
 {
 	int err = -ENODEV;
@@ -56,7 +54,7 @@ static int __init rtc_hctosys(void)
 
 	rtc_tm_to_time(&tm, &tv.tv_sec);
 
-	do_settimeofday(&tv);
+	err = do_settimeofday(&tv);
 
 	dev_info(rtc->dev.parent,
 		"setting system clock to "
diff --git a/drivers/rtc/rtc-sysfs.c b/drivers/rtc/rtc-sysfs.c
index 380083c..b70e2bb 100644
--- a/drivers/rtc/rtc-sysfs.c
+++ b/drivers/rtc/rtc-sysfs.c
@@ -102,6 +102,12 @@ rtc_sysfs_set_max_user_freq(struct device *dev, struct device_attribute *attr,
 	return n;
 }
 
+/**
+ * rtc_sysfs_show_hctosys - indicate if the given RTC set the system time
+ *
+ * Returns 1 if the system clock was set by this RTC at the last
+ * boot or resume event.
+ */
 static ssize_t
 rtc_sysfs_show_hctosys(struct device *dev, struct device_attribute *attr,
 		char *buf)
diff --git a/include/linux/rtc.h b/include/linux/rtc.h
index f071b39..20ec4d3 100644
--- a/include/linux/rtc.h
+++ b/include/linux/rtc.h
@@ -276,7 +276,7 @@ static inline bool is_leap_year(unsigned int year)
 	return (!(year % 4) && (year % 100)) || !(year % 400);
 }
 
-#ifdef CONFIG_RTC_HCTOSYS
+#ifdef CONFIG_RTC_HCTOSYS_DEVICE
 extern int rtc_hctosys_ret;
 #else
 #define rtc_hctosys_ret -ENODEV
-- 
1.7.2.5

