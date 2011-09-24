Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752478Ab1IXU6q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Sep 2011 16:58:46 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:61808 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361Ab1IXU6p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Sep 2011 16:58:45 -0400
MIME-Version: 1.0
Message-ID: <9827a70d-dfb2-4bbc-9df6-207b10c835ac@default>
Date: Sat, 24 Sep 2011 13:58:08 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Konrad Wilk <konrad.wilk@oracle.com>, linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com, David Vrabel <david.vrabel@citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH] xen: Fix selfballooning and ensure it doesn't go too far
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6557.5001]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4E7E4480.0020:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] xen: Fix selfballooning and ensure it doesn't go too far

The balloon driver's "current_pages" is very different from
totalram_pages.  Self-ballooning needs to be driven by
the latter.  Also, Committed_AS doesn't account for pages
used by the kernel so enforce a floor for when there
are little or no user-space threads using memory.

Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>

diff --git a/drivers/xen/xen-selfballoon.c b/drivers/xen/xen-selfballoon.c
index 6ea852e..e3e48f1 100644
--- a/drivers/xen/xen-selfballoon.c
+++ b/drivers/xen/xen-selfballoon.c
@@ -195,14 +195,13 @@ __setup("selfballooning", xen_selfballooning_setup);
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
@@ -217,7 +216,13 @@ static void selfballoon_process(struct work_struct *work)
 				((goal_pages - cur_pages) /
 				  selfballoon_uphysteresis);
 		/* else if cur_pages == goal_pages, no change */
-		balloon_set_new_target(tgt_pages);
+		floor_pages = totalreserve_pages +
+				(roundup_pow_of_two(max_pfn) >> 5);
+		/* don't balloon too far, lest OOMs occur... */
+		if (tgt_pages < floor_pages)
+			tgt_pages = floor_pages;
+		balloon_set_new_target(tgt_pages +
+			balloon_stats.current_pages - totalram_pages);
 		reset_timer = true;
 	}
 #ifdef CONFIG_FRONTSWAP
