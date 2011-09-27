Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751237Ab1I0PEd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 11:04:33 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:63702 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932Ab1I0PEc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 11:04:32 -0400
MIME-Version: 1.0
Message-ID: <2de59b55-4ecc-4155-8709-f8b0f5e012bc@default>
Date: Tue, 27 Sep 2011 08:03:56 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Konrad Wilk <konrad.wilk@oracle.com>, linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, David Vrabel <david.vrabel@citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH v2] xen: Fix selfballooning and ensure it doesn't go too far
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4E81E5FB.00B9:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note: This patch is also now in a git tree at:

git://oss.oracle.com/git/djm/tmem.git#selfballoon-fix-v2

The balloon driver's "current_pages" is very different from
totalram_pages.  Self-ballooning needs to be driven by
the latter.  Also, Committed_AS doesn't account for pages
used by the kernel so enforce a floor for when there are little
or no user-space threads using memory.  The floor function
includes a "safety margin" tuneable in case we discover later
that the floor function is still too aggressive in some workloads,
though likely it will not be needed.

Changes since version 1:
- tuneable safety margin added

[v2: konrad.wilk@oracle.com: make safety margin tuneable]

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>

diff --git a/drivers/xen/xen-selfballoon.c b/drivers/xen/xen-selfballoon.c
index 6ea852e..ceaada6 100644
--- a/drivers/xen/xen-selfballoon.c
+++ b/drivers/xen/xen-selfballoon.c
@@ -93,6 +93,12 @@ static unsigned int selfballoon_uphysteresis __read_mostly = 1;
 /* In HZ, controls frequency of worker invocation. */
 static unsigned int selfballoon_interval __read_mostly = 5;
 
+/*
+ * Scale factor for safety margin for minimum selfballooning target for balloon.
+ * Default adds about 3% (4/128) of max_pfn.
+ */
+static unsigned int selfballoon_safety_margin = 4;
+
 static void selfballoon_process(struct work_struct *work);
 static DECLARE_DELAYED_WORK(selfballoon_worker, selfballoon_process);
 
@@ -195,14 +201,13 @@ __setup("selfballooning", xen_selfballooning_setup);
  */
 static void selfballoon_process(struct work_struct *work)
 {
-	unsigned long cur_pages, goal_pages, tgt_pages;
+	unsigned long cur_pages, goal_pages, tgt_pages, floor_pages;
 	bool reset_timer = false;
 
 	if (xen_selfballooning_enabled) {
-		cur_pages = balloon_stats.current_pages;
+		cur_pages = totalram_pages;
 		tgt_pages = cur_pages; /* default is no change */
-		goal_pages = percpu_counter_read_positive(&vm_committed_as) +
-			balloon_stats.current_pages - totalram_pages;
+		goal_pages = percpu_counter_read_positive(&vm_committed_as);
 #ifdef CONFIG_FRONTSWAP
 		/* allow space for frontswap pages to be repatriated */
 		if (frontswap_selfshrinking && frontswap_enabled)
@@ -217,7 +222,13 @@ static void selfballoon_process(struct work_struct *work)
 				((goal_pages - cur_pages) /
 				  selfballoon_uphysteresis);
 		/* else if cur_pages == goal_pages, no change */
-		balloon_set_new_target(tgt_pages);
+		floor_pages = totalreserve_pages +
+			((roundup_pow_of_two(max_pfn) / 128) *
+				selfballoon_safety_margin);
+		if (tgt_pages < floor_pages)
+			tgt_pages = floor_pages;
+		balloon_set_new_target(tgt_pages +
+			balloon_stats.current_pages - totalram_pages);
 		reset_timer = true;
 	}
 #ifdef CONFIG_FRONTSWAP
@@ -340,6 +351,30 @@ static ssize_t store_selfballoon_uphys(struct sys_device *dev,
 static SYSDEV_ATTR(selfballoon_uphysteresis, S_IRUGO | S_IWUSR,
 		   show_selfballoon_uphys, store_selfballoon_uphys);
 
+SELFBALLOON_SHOW(selfballoon_safety_margin, "%d\n", selfballoon_safety_margin);
+
+static ssize_t store_selfballoon_safety_margin(struct sys_device *dev,
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
+	if (err || val == 0 || val > 128)
+		return -EINVAL;
+	selfballoon_safety_margin = val;
+	return count;
+}
+
+static SYSDEV_ATTR(selfballoon_safety_margin, S_IRUGO | S_IWUSR,
+		   show_selfballoon_safety_margin,
+		   store_selfballoon_safety_margin);
+
+
 #ifdef CONFIG_FRONTSWAP
 SELFBALLOON_SHOW(frontswap_selfshrinking, "%d\n", frontswap_selfshrinking);
 
@@ -421,6 +456,7 @@ static struct attribute *selfballoon_attrs[] = {
 	&attr_selfballoon_interval.attr,
 	&attr_selfballoon_downhysteresis.attr,
 	&attr_selfballoon_uphysteresis.attr,
+	&attr_selfballoon_safety_margin.attr,
 #ifdef CONFIG_FRONTSWAP
 	&attr_frontswap_selfshrinking.attr,
 	&attr_frontswap_hysteresis.attr,
