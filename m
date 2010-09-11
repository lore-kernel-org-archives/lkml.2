Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab0IKW20 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Sep 2010 18:28:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:45786 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752093Ab0IKW2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Sep 2010 18:28:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "M. Vefa Bicakci" <bicave@superonline.com>
Subject: [PATCH] PM / Hibernate: Make default image size depend on total RAM size (was: Re: PATCH: PM / Hibernate: Avoid hitting OOM ...)
Date: Sun, 12 Sep 2010 00:27:06 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pm@lists.linux-foundation.org,
        Minchan Kim <minchan.kim@gmail.com>
References: <201009062043.37819.rjw@sisk.pl> <4C8BC68B.8050002@superonline.com> <201009112106.07687.rjw@sisk.pl>
In-Reply-To: <201009112106.07687.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009120027.06470.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, September 11, 2010, Rafael J. Wysocki wrote:
> On Saturday, September 11, 2010, M. Vefa Bicakci wrote:
...
> > 
> > I would be glad to test that patch as well, to see if it brings speed-ups.
> > Actually, I might test hibernation with a larger value written to
> > /sys/power/image_size when I have time.
> 
> I think that would improve things, as it probably is impossible to reduce the
> image size to 500 MB on your system.
> 
> Anyway, I'll let you know when the patch is ready.

OK, please try the patch below on top of the previous one and see if it makes
hibernation run faster on your system.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / Hibernate: Make default image size depend on total RAM size

The default hibernation image size is currently hard coded and euqal
to 500 MB, which is not a reasonable default on many contemporary
systems.  Make it equal 2/5 of the total RAM size (this is slightly
below the maximum, i.e. 1/2 of the total RAM size, and seems to be
generally suitable).

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
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
