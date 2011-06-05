Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204Ab1FEOT7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 10:19:59 -0400
Received: from d1.icnet.pl ([212.160.220.21]:37864 "EHLO d1.icnet.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753574Ab1FEOT6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 10:19:58 -0400
X-Greylist: delayed 1678 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Jun 2011 10:19:58 EDT
From: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
Organization: Tele-Info-System, Poznan, PL
To: linux-pm@lists.linux-foundation.org
Subject: [PATCH 3.0-rc1] PM / runtime: fix broken iteration over clock ids
Date: Sun, 5 Jun 2011 15:31:12 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-gentoo-r5; KDE/4.4.5; i686; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, "Greg Kroah-Hartman" <gregkh@suse.de>,
        linux-kernel@vger.kernel.org,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201106051531.32878.jkrzyszt@tis.icnet.pl>
X-SA-Exim-Scanned: No (on d1.icnet); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In its current form, pm_runtime_clk_notify() iterates through sub-
strings of pm_clk_notifier_block.con_ids[0] rather than consecutive 
pm_clk_notifier_block.con_ids[] elements. As a noticeable result, McBSP1 
port no longer worked for me on updated arch/arm/mach-omap1/pm_bus.c 
(commit 600b776eb39a13a28b090ba9efceb0c69d4508aa, "OMAP1 / PM: Use 
generic clock manipulation routines for runtime PM"), not being able to 
activate "fck" when required.

Tested on Amstrad Delta.

Signed-off-by: Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>
---
 drivers/base/power/clock_ops.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- git/drivers/base/power/clock_ops.c.orig	2011-05-30 22:16:35.000000000 +0200
+++ git/drivers/base/power/clock_ops.c	2011-06-05 15:19:55.000000000 +0200
@@ -291,7 +291,7 @@ static int pm_runtime_clk_notify(struct 
 {
 	struct pm_clk_notifier_block *clknb;
 	struct device *dev = data;
-	char *con_id;
+	char **con_id;
 	int error;
 
 	dev_dbg(dev, "%s() %ld\n", __func__, action);
@@ -309,8 +309,8 @@ static int pm_runtime_clk_notify(struct 
 
 		dev->pwr_domain = clknb->pwr_domain;
 		if (clknb->con_ids[0]) {
-			for (con_id = clknb->con_ids[0]; *con_id; con_id++)
-				pm_runtime_clk_add(dev, con_id);
+			for (con_id = &clknb->con_ids[0]; *con_id; con_id++)
+				pm_runtime_clk_add(dev, *con_id);
 		} else {
 			pm_runtime_clk_add(dev, NULL);
 		}
