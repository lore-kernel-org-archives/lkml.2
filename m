Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab0L2RTi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 12:19:38 -0500
Received: from router-fw.net-space.pl ([89.174.63.77]:47397 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508Ab0L2RTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 12:19:32 -0500
Date: Wed, 29 Dec 2010 18:04:41 +0100
From: Daniel Kiper <dkiper@net-space.pl>
To: ian.campbell@citrix.com, akpm@linux-foundation.org, andi.kleen@intel.com,
        haicheng.li@linux.intel.com, fengguang.wu@intel.com, jeremy@goop.org,
        konrad.wilk@oracle.com, dan.magenheimer@oracle.com,
        v.tolstov@selfip.ru, xen-devel@lists.xensource.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH R2 4/7] xen/balloon: migration from mod_timer() to schedule_delayed_work()
Message-ID: <20101229170441.GI2743@router-fw-old.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

migration from mod_timer() to schedule_delayed_work().

Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
---
 drivers/xen/balloon.c |   16 +++-------------
 1 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index 878f54c..11143af 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -98,8 +98,7 @@ static LIST_HEAD(ballooned_pages);
 
 /* Main work function, always executed in process context. */
 static void balloon_process(struct work_struct *work);
-static DECLARE_WORK(balloon_worker, balloon_process);
-static struct timer_list balloon_timer;
+static DECLARE_DELAYED_WORK(balloon_worker, balloon_process);
 
 /* When ballooning out (allocating memory to return to Xen) we don't really
    want the kernel to try too hard since that can trigger the oom killer. */
@@ -167,11 +166,6 @@ static struct page *balloon_next_page(struct page *page)
 	return list_entry(next, struct page, lru);
 }
 
-static void balloon_alarm(unsigned long unused)
-{
-	schedule_work(&balloon_worker);
-}
-
 static unsigned long current_target(void)
 {
 	unsigned long target = balloon_stats.target_pages;
@@ -336,7 +330,7 @@ static void balloon_process(struct work_struct *work)
 
 	/* Schedule more work if there is some still to be done. */
 	if (current_target() != balloon_stats.current_pages)
-		mod_timer(&balloon_timer, jiffies + HZ);
+		schedule_delayed_work(&balloon_worker, HZ);
 
 	mutex_unlock(&balloon_mutex);
 }
@@ -346,7 +340,7 @@ static void balloon_set_new_target(unsigned long target)
 {
 	/* No need for lock. Not read-modify-write updates. */
 	balloon_stats.target_pages = target;
-	schedule_work(&balloon_worker);
+	schedule_delayed_work(&balloon_worker, 0);
 }
 
 static struct xenbus_watch target_watch =
@@ -405,10 +399,6 @@ static int __init balloon_init(void)
 	balloon_stats.balloon_low   = 0;
 	balloon_stats.balloon_high  = 0;
 
-	init_timer(&balloon_timer);
-	balloon_timer.data = 0;
-	balloon_timer.function = balloon_alarm;
-
 	register_balloon(&balloon_sysdev);
 
 	/* Initialise the balloon with excess memory space. */
-- 
1.4.4.4

