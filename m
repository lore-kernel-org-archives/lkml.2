Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755681Ab0INWYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 18:24:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56270 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754935Ab0INWYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 18:24:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 2/2] PM / Hibernate: Make default image size depend on total RAM size
Date: Wed, 15 Sep 2010 00:23:30 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4-rjw+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "M. Vefa Bicakci" <bicave@superonline.com>
References: <201009150021.45101.rjw@sisk.pl>
In-Reply-To: <201009150021.45101.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009150023.30635.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / Hibernate: Make default image size depend on total RAM size

The default hibernation image size is currently hard coded and euqal
to 500 MB, which is not a reasonable default on many contemporary
systems.  Make it equal 2/5 of the total RAM size (this is slightly
below the maximum, i.e. 1/2 of the total RAM size, and seems to be
generally suitable).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Tested-by: M. Vefa Bicakci <bicave@superonline.com>
---
 Documentation/power/interface.txt |    2 +-
 kernel/power/main.c               |    1 +
 kernel/power/power.h              |    9 ++++++++-
 kernel/power/snapshot.c           |    7 ++++++-
 4 files changed, 16 insertions(+), 3 deletions(-)

Index: linux-2.6/kernel/power/snapshot.c
===================================================================
--- linux-2.6.orig/kernel/power/snapshot.c
+++ linux-2.6/kernel/power/snapshot.c
@@ -46,7 +46,12 @@ static void swsusp_unset_page_forbidden(
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
Index: linux-2.6/kernel/power/power.h
===================================================================
--- linux-2.6.orig/kernel/power/power.h
+++ linux-2.6/kernel/power/power.h
@@ -14,6 +14,9 @@ struct swsusp_info {
 } __attribute__((aligned(PAGE_SIZE)));
 
 #ifdef CONFIG_HIBERNATION
+/* kernel/power/snapshot.c */
+extern void __init hibernate_image_size_init(void);
+
 #ifdef CONFIG_ARCH_HIBERNATION_HEADER
 /* Maximum size of architecture specific data in a hibernation header */
 #define MAX_ARCH_HEADER_SIZE	(sizeof(struct new_utsname) + 4)
@@ -49,7 +52,11 @@ static inline char *check_image_kernel(s
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
 
Index: linux-2.6/kernel/power/main.c
===================================================================
--- linux-2.6.orig/kernel/power/main.c
+++ linux-2.6/kernel/power/main.c
@@ -321,6 +321,7 @@ static int __init pm_init(void)
 	int error = pm_start_workqueue();
 	if (error)
 		return error;
+	hibernate_image_size_init();
 	power_kobj = kobject_create_and_add("power", NULL);
 	if (!power_kobj)
 		return -ENOMEM;
Index: linux-2.6/Documentation/power/interface.txt
===================================================================
--- linux-2.6.orig/Documentation/power/interface.txt
+++ linux-2.6/Documentation/power/interface.txt
@@ -57,7 +57,7 @@ smallest image possible.  In particular,
 suspend image will be as small as possible.
 
 Reading from this file will display the current image size limit, which
-is set to 500 MB by default.
+is set to 2/5 of available RAM by default.
 
 /sys/power/pm_trace controls the code which saves the last PM event point in
 the RTC across reboots, so that you can debug a machine that just hangs

