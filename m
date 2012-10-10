Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab2JJAJs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 20:09:48 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:54731 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab2JJAJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 20:09:47 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: rtc-linux@googlegroups.com, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [PATCH] rtc: kconfig: fix RTC_INTF defaults connected to RTC_CLASS
Date: Tue,  9 Oct 2012 17:09:44 -0700
Message-Id: <1349827784-8646-1-git-send-email-khilman@deeprootsystems.com>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Hilman <khilman@ti.com>

commit 6b8029fab64164b5895d58d23229b75c82e3a6fc (rtc: kconfig: remove
unnecessary dependencies) removed various 'depends on RTC_CLASS'
dependencies but also removed a few 'default RTC_CLASS' statements,
which actually changed default behavior.

This resulted in the various RTC interfaces (sysfs, proc, dev) all
being disabled by default, even when RTC_CLASS is enabled:

   # CONFIG_RTC_INTF_SYSFS is not set
   # CONFIG_RTC_INTF_PROC is not set
   # CONFIG_RTC_INTF_DEV is not set

which is different from previous behavior (all of these where enabled.)

To fix, add back the 'default RTC_CLASS' statments to each of the
RTC_INTF_* options.

I noticed this because some RTC tests started failing on my TI OMAP
platforms because /dev/rtc0 was not present anymore, even though the
driver was present and RTC_CLASS was enabled.

Cc: Venu Byravarasu <vbyravarasu@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Kevin Hilman <khilman@ti.com>
---
Targeted as a fix for v3.7-rc.
Applies on Linus' master, just after merging "Andrew's patch bomb"
commit 11126c611e10abb18b6f1ed0300c0548c3906b54

 drivers/rtc/Kconfig |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index e069f17..19c03ab 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -59,6 +59,7 @@ comment "RTC interfaces"
 config RTC_INTF_SYSFS
 	boolean "/sys/class/rtc/rtcN (sysfs)"
 	depends on SYSFS
+	default RTC_CLASS
 	help
 	  Say yes here if you want to use your RTCs using sysfs interfaces,
 	  /sys/class/rtc/rtc0 through /sys/.../rtcN.
@@ -68,6 +69,7 @@ config RTC_INTF_SYSFS
 config RTC_INTF_PROC
 	boolean "/proc/driver/rtc (procfs for rtcN)"
 	depends on PROC_FS
+	default RTC_CLASS
 	help
 	  Say yes here if you want to use your system clock RTC through
 	  the proc interface, /proc/driver/rtc.
@@ -79,6 +81,7 @@ config RTC_INTF_PROC
 
 config RTC_INTF_DEV
 	boolean "/dev/rtcN (character devices)"
+	default RTC_CLASS
 	help
 	  Say yes here if you want to use your RTCs using the /dev
 	  interfaces, which "udev" sets up as /dev/rtc0 through
-- 
1.7.9.2

