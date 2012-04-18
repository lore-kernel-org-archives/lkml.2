Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751087Ab2DRGhI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 02:37:08 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43532 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab2DRGhF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 02:37:05 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: "a.zummo@towertech.it" <a.zummo@towertech.it>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>
Date: Tue, 17 Apr 2012 23:37:03 -0700
Subject: [PATCH] rtc-proc: change the limitation on creating rtc proc data
Thread-Topic: [PATCH] rtc-proc: change the limitation on creating rtc proc
 data
Thread-Index: Ac0dLapXX5z4kW1mQKm0jAsJiHh0NA==
Message-ID: <DD6B9D658496A2488636C8C75B9C0CB601CD2D60@EXMAIL04.scwf.nsc.com>
Accept-Language: ko-KR, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: ko-KR, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To get time information via /proc/driver/rtc, only the first device (rtc0) is used.
If the rtcN (eg. rtc1 or rtc2) is used for the system clock, there is no way to
get information of rtcN via /proc/driver/rtc.
With this patch, the time data can be retrieved from the system clock RTC.

If the RTC_HCTOSYS_DEVICE is not defined, then rtc0 is used by default.

Signed-off-by: Milo(Woogyom) Kim <milo.kim@ti.com>
---
 Documentation/rtc.txt  |    5 +++--
 drivers/rtc/Kconfig    |   10 ++++++----
 drivers/rtc/rtc-proc.c |   24 ++++++++++++++++++++++--
 3 files changed, 31 insertions(+), 8 deletions(-)

diff --git a/Documentation/rtc.txt b/Documentation/rtc.txt
index 2501604..32aa400 100644
--- a/Documentation/rtc.txt
+++ b/Documentation/rtc.txt
@@ -119,8 +119,9 @@ three different userspace interfaces:
     *	/sys/class/rtc/rtcN ... sysfs attributes support readonly
 	access to some RTC attributes.
 
-    *	/proc/driver/rtc ... the first RTC (rtc0) may expose itself
-	using a procfs interface.  More information is (currently) shown
+    *	/proc/driver/rtc ... the system clock RTC may expose itself
+	using a procfs interface. If there is no RTC for the system clock,
+	rtc0 is used by default. More information is (currently) shown
 	here than through sysfs.
 
 The RTC Class framework supports a wide variety of RTCs, ranging from those
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 8c8377d..d1927f6 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -69,13 +69,15 @@ config RTC_INTF_SYSFS
 	  If unsure, say Y.
 
 config RTC_INTF_PROC
-	boolean "/proc/driver/rtc (procfs for rtc0)"
+	boolean "/proc/driver/rtc (procfs for rtcN)"
 	depends on PROC_FS
 	default RTC_CLASS
 	help
-	  Say yes here if you want to use your first RTC through the proc
-	  interface, /proc/driver/rtc. Other RTCs will not be available
-	  through that API.
+	  Say yes here if you want to use your system clock RTC through
+	  the proc interface, /proc/driver/rtc.
+	  Other RTCs will not be available through that API.
+	  If there is no RTC for the system clock, then the first RTC(rtc0)
+	  is used by default.
 
 	  If unsure, say Y.
 
diff --git a/drivers/rtc/rtc-proc.c b/drivers/rtc/rtc-proc.c
index 0a59fda..e96236a 100644
--- a/drivers/rtc/rtc-proc.c
+++ b/drivers/rtc/rtc-proc.c
@@ -18,6 +18,26 @@
 
 #include "rtc-core.h"
 
+#define NAME_SIZE	10
+
+#if defined(CONFIG_RTC_HCTOSYS_DEVICE)
+static bool is_rtc_hctosys(struct rtc_device *rtc)
+{
+	int size;
+	char name[NAME_SIZE];
+
+	size = scnprintf(name, NAME_SIZE, "rtc%d", rtc->id);
+	if (size > NAME_SIZE)
+		return false;
+
+	return !strncmp(name, CONFIG_RTC_HCTOSYS_DEVICE, NAME_SIZE);
+}
+#else
+static bool is_rtc_hctosys(struct rtc_device *rtc)
+{
+	return (rtc->id == 0);
+}
+#endif
 
 static int rtc_proc_show(struct seq_file *seq, void *offset)
 {
@@ -117,12 +137,12 @@ static const struct file_operations rtc_proc_fops = {
 
 void rtc_proc_add_device(struct rtc_device *rtc)
 {
-	if (rtc->id == 0)
+	if (is_rtc_hctosys(rtc))
 		proc_create_data("driver/rtc", 0, NULL, &rtc_proc_fops, rtc);
 }
 
 void rtc_proc_del_device(struct rtc_device *rtc)
 {
-	if (rtc->id == 0)
+	if (is_rtc_hctosys(rtc))
 		remove_proc_entry("driver/rtc", NULL);
 }
-- 
1.7.4.1


Best Regards,
Milo (Woogyom) Kim
