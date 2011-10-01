Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293Ab1JAVCn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 17:02:43 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:54546 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab1JAVCh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 17:02:37 -0400
MIME-Version: 1.0
Message-ID: <83b6aafe-fea3-4d7f-8cd5-47396d74cc81@default>
Date: Sat, 1 Oct 2011 14:02:16 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Konrad Wilk <konrad.wilk@oracle.com>, linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, David Vrabel <david.vrabel@citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH v5] xen: Fix selfballooning and ensure it doesn't go too far
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6562.5003]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet23.oracle.com [156.151.31.71]
X-CT-RefId: str=0001.0A090206.4E877FE8.008F,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note: This patch is also now in a git tree at:
git://oss.oracle.com/git/djm/tmem.git#selfballoon-fix-v5

xen: Fix selfballooning and ensure it doesn't go too far

The balloon driver's "current_pages" is very different from
totalram_pages.  Self-ballooning needs to be driven by
the latter.  Also, Committed_AS doesn't account for pages
used by the kernel so:
1) Add totalreserve_pages to Committed_AS for the normal target.
2) Enforce a floor for when there are little or no user-space threads
   using memory (e.g. single-user mode) to avoid OOMs.  The floor
   function includes a "min_usable_mb" tuneable in case we discover
   later that the floor function is still too aggressive in some
   workloads, though likely it will not be needed.

Changes since version 4:
- change floor calculation so that it is not as aggressive; this version
  uses a piecewise linear function similar to minimum_target in the 2.6.18
  balloon driver, but modified to add to totalreserve_pages instead of
  subtract from max_pfn, the 2.6.18 version causes OOMs on recent kernels
  because the kernel has bloated over time
- change safety_margin to min_usable_mb and comment on its use
- since committed_as does NOT include kernel space (and other reserved
  pages), totalreserve_pages is now added to committed_as.  The result is
  less aggressive self-ballooning, but theoretically more appropriate.
Changes since version 3:
- missing include causes compile problem when CONFIG_FRONTSWAP is disabled
- add comments after includes
Changes since version 2:
- missing include causes compile problem only on 32-bit
Changes since version 1:
- tuneable safety margin added
    
[v5: avi.miller@oracle.com: still too aggressive, seeing some OOMs]
[v4: konrad.wilk@oracle.com: fix compile when CONFIG_FRONTSWAP is disabled]
[v3: guru.anbalagane@oracle.com: fix 32-bit compile]
[v2: konrad.wilk@oracle.com: make safety margin tuneable]

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>

diff --git a/drivers/xen/xen-selfballoon.c b/drivers/xen/xen-selfballoon.c
index 6ea852e..8bb07b6 100644
--- a/drivers/xen/xen-selfballoon.c
+++ b/drivers/xen/xen-selfballoon.c
@@ -68,6 +68,7 @@
  */
 
 #include <linux/kernel.h>
+#include <linux/bootmem.h>
 #include <linux/mm.h>
 #include <linux/mman.h>
 #include <linux/module.h>
@@ -93,6 +94,15 @@ static unsigned int selfballoon_uphysteresis __read_mostly = 1;
 /* In HZ, controls frequency of worker invocation. */
 static unsigned int selfballoon_interval __read_mostly = 5;
 
+/*
+ * Minimum usable RAM in MB for selfballooning target for balloon.
+ * If non-zero, it is added to totalreserve_pages and self-ballooning
+ * will not balloon below the sum.  If zero, a piecewise linear function
+ * is calculated as a minimum and added to totalreserve_pages.  Note that
+ * setting this value indiscriminately may cause OOMs and crashes.
+ */
+static unsigned int selfballoon_min_usable_mb;
+
 static void selfballoon_process(struct work_struct *work);
 static DECLARE_DELAYED_WORK(selfballoon_worker, selfballoon_process);
 
@@ -189,20 +199,23 @@ static int __init xen_selfballooning_setup(char *s)
 __setup("selfballooning", xen_selfballooning_setup);
 #endif /* CONFIG_FRONTSWAP */
 
+#define MB2PAGES(mb)	((mb) << (20 - PAGE_SHIFT))
+
 /*
  * Use current balloon size, the goal (vm_committed_as), and hysteresis
  * parameters to set a new target balloon size
  */
 static void selfballoon_process(struct work_struct *work)
 {
-	unsigned long cur_pages, goal_pages, tgt_pages;
+	unsigned long cur_pages, goal_pages, tgt_pages, floor_pages;
+	unsigned long useful_pages;
 	bool reset_timer = false;
 
 	if (xen_selfballooning_enabled) {
-		cur_pages = balloon_stats.current_pages;
+		cur_pages = totalram_pages;
 		tgt_pages = cur_pages; /* default is no change */
 		goal_pages = percpu_counter_read_positive(&vm_committed_as) +
-			balloon_stats.current_pages - totalram_pages;
+				totalreserve_pages;
 #ifdef CONFIG_FRONTSWAP
 		/* allow space for frontswap pages to be repatriated */
 		if (frontswap_selfshrinking && frontswap_enabled)
@@ -217,7 +230,26 @@ static void selfballoon_process(struct work_struct *work)
 				((goal_pages - cur_pages) /
 				  selfballoon_uphysteresis);
 		/* else if cur_pages == goal_pages, no change */
-		balloon_set_new_target(tgt_pages);
+		useful_pages = max_pfn - totalreserve_pages;
+		if (selfballoon_min_usable_mb != 0)
+			floor_pages = totalreserve_pages +
+					MB2PAGES(selfballoon_min_usable_mb);
+		/* piecewise linear function ending in ~3% slope */
+		else if (useful_pages < MB2PAGES(16))
+			floor_pages = max_pfn; /* not worth ballooning */
+		else if (useful_pages < MB2PAGES(64))
+			floor_pages = totalreserve_pages + MB2PAGES(16) +
+					((useful_pages - MB2PAGES(16)) >> 1);
+		else if (useful_pages < MB2PAGES(512))
+			floor_pages = totalreserve_pages + MB2PAGES(40) +
+					((useful_pages - MB2PAGES(40)) >> 3);
+		else /* useful_pages >= MB2PAGES(512) */
+			floor_pages = totalreserve_pages + MB2PAGES(99) +
+					((useful_pages - MB2PAGES(99)) >> 5);
+		if (tgt_pages < floor_pages)
+			tgt_pages = floor_pages;
+		balloon_set_new_target(tgt_pages +
+			balloon_stats.current_pages - totalram_pages);
 		reset_timer = true;
 	}
 #ifdef CONFIG_FRONTSWAP
@@ -340,6 +372,31 @@ static ssize_t store_selfballoon_uphys(struct sys_device *dev,
 static SYSDEV_ATTR(selfballoon_uphysteresis, S_IRUGO | S_IWUSR,
 		   show_selfballoon_uphys, store_selfballoon_uphys);
 
+SELFBALLOON_SHOW(selfballoon_min_usable_mb, "%d\n",
+				selfballoon_min_usable_mb);
+
+static ssize_t store_selfballoon_min_usable_mb(struct sys_device *dev,
+					       struct sysdev_attribute *attr,
+					       const char *buf,
+					       size_t count)
+{
+	unsigned long val;
+	int err;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	err = strict_strtoul(buf, 10, &val);
+	if (err || val == 0)
+		return -EINVAL;
+	selfballoon_min_usable_mb = val;
+	return count;
+}
+
+static SYSDEV_ATTR(selfballoon_min_usable_mb, S_IRUGO | S_IWUSR,
+		   show_selfballoon_min_usable_mb,
+		   store_selfballoon_min_usable_mb);
+
+
 #ifdef CONFIG_FRONTSWAP
 SELFBALLOON_SHOW(frontswap_selfshrinking, "%d\n", frontswap_selfshrinking);
 
@@ -421,6 +478,7 @@ static struct attribute *selfballoon_attrs[] = {
 	&attr_selfballoon_interval.attr,
 	&attr_selfballoon_downhysteresis.attr,
 	&attr_selfballoon_uphysteresis.attr,
+	&attr_selfballoon_min_usable_mb.attr,
 #ifdef CONFIG_FRONTSWAP
 	&attr_frontswap_selfshrinking.attr,
 	&attr_frontswap_hysteresis.attr,
