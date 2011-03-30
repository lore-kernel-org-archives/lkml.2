Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933705Ab1C3VPx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:15:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:38344 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965278Ab1C3VKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:10:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="411279217"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: rjw@sisk.pl, bicave@superonline.com, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [255/275] PM / Hibernate: Make default image size depend on total RAM size
Message-Id: <20110330210822.2CB7D3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:08:22 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Rafael J. Wysocki <rjw@sisk.pl>

[ upstream commit ac5c24ec1e983313ef0015258fba6f630e54e7cf ]

The default hibernation image size is currently hard coded and euqal
to 500 MB, which is not a reasonable default on many contemporary
systems.  Make it equal 2/5 of the total RAM size (this is slightly
below the maximum, i.e. 1/2 of the total RAM size, and seems to be
generally suitable).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Tested-by: M. Vefa Bicakci <bicave@superonline.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 Documentation/power/interface.txt |    2 +-
 kernel/power/main.c               |    1 +
 kernel/power/power.h              |    9 ++++++++-
 kernel/power/snapshot.c           |    7 ++++++-
 4 files changed, 16 insertions(+), 3 deletions(-)

Index: linux-2.6.35.y/Documentation/power/interface.txt
===================================================================
--- linux-2.6.35.y.orig/Documentation/power/interface.txt	2011-03-29 22:50:08.637037418 -0700
+++ linux-2.6.35.y/Documentation/power/interface.txt	2011-03-29 23:03:03.570208818 -0700
@@ -57,7 +57,7 @@
 suspend image will be as small as possible.
 
 Reading from this file will display the current image size limit, which
-is set to 500 MB by default.
+is set to 2/5 of available RAM by default.
 
 /sys/power/pm_trace controls the code which saves the last PM event point in
 the RTC across reboots, so that you can debug a machine that just hangs
Index: linux-2.6.35.y/kernel/power/main.c
===================================================================
--- linux-2.6.35.y.orig/kernel/power/main.c	2011-03-29 22:50:08.637037418 -0700
+++ linux-2.6.35.y/kernel/power/main.c	2011-03-29 23:03:03.570208818 -0700
@@ -266,6 +266,7 @@
 	int error = pm_start_workqueue();
 	if (error)
 		return error;
+	hibernate_image_size_init();
 	power_kobj = kobject_create_and_add("power", NULL);
 	if (!power_kobj)
 		return -ENOMEM;
Index: linux-2.6.35.y/kernel/power/power.h
===================================================================
--- linux-2.6.35.y.orig/kernel/power/power.h	2011-03-29 22:50:08.637037418 -0700
+++ linux-2.6.35.y/kernel/power/power.h	2011-03-29 23:03:03.571208793 -0700
@@ -14,6 +14,9 @@
 } __attribute__((aligned(PAGE_SIZE)));
 
 #ifdef CONFIG_HIBERNATION
+/* kernel/power/snapshot.c */
+extern void __init hibernate_image_size_init(void);
+
 #ifdef CONFIG_ARCH_HIBERNATION_HEADER
 /* Maximum size of architecture specific data in a hibernation header */
 #define MAX_ARCH_HEADER_SIZE	(sizeof(struct new_utsname) + 4)
@@ -49,7 +52,11 @@
 extern int hibernation_snapshot(int platform_mode);
 extern int hibernation_restore(int platform_mode);
 extern int hibernation_platform_enter(void);
-#endif
+
+#else /* !CONFIG_HIBERNATION */
+
+static inline void hibernate_image_size_init(void) {}
+#endif /* !CONFIG_HIBERNATION */
 
 extern int pfn_is_nosave(unsigned long);
 
Index: linux-2.6.35.y/kernel/power/snapshot.c
===================================================================
--- linux-2.6.35.y.orig/kernel/power/snapshot.c	2011-03-29 23:03:03.551209304 -0700
+++ linux-2.6.35.y/kernel/power/snapshot.c	2011-03-29 23:03:03.573208741 -0700
@@ -46,7 +46,12 @@
  * size will not exceed N bytes, but if that is impossible, it will
  * try to create the smallest image possible.
  */
-unsigned long image_size = 500 * 1024 * 1024;
+unsigned long image_size;
+
+void __init hibernate_image_size_init(void)
+{
+	image_size = ((totalram_pages * 2) / 5) * PAGE_SIZE;
+}
 
 /* List of PBEs needed for restoring the pages that were allocated before
  * the suspend and included in the suspend image, but have also been
