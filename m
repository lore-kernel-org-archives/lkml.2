Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab2IQAuJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 20:50:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33311 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752922Ab2IQAtW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:49:22 -0400
Message-Id: <20120917003626.612267462@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:36:28 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jon Hunter <jon-hunter@ti.com>,
        Kevin Hilman <khilman@ti.com>, Tony Lindgren <tony@atomide.com>
Subject: [ 003/135] ARM: OMAP2+: Fix dmtimer set source clock failure
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jon Hunter <jon-hunter@ti.com>

commit 54f32a35f4d3a653a18a2c8c239f19ae060bd803 upstream.

Calling the dmtimer function omap_dm_timer_set_source() fails if following a
call to pm_runtime_put() to disable the timer. For example the following
sequence would fail to set the parent clock ...

	omap_dm_timer_stop(gptimer);
	omap_dm_timer_set_source(gptimer, OMAP_TIMER_SRC_32_KHZ);

The following error message would be seen ...

omap_dm_timer_set_source: failed to set timer_32k_ck as parent

The problem is that, by design, pm_runtime_put() simply decrements the usage
count and returns before the timer has actually been disabled. Therefore,
setting the parent clock failed because the timer was still active when the
trying to set the parent clock. Setting a parent clock will fail if the clock
you are setting the parent of has a non-zero usage count. To ensure that this
does not fail use pm_runtime_put_sync() when disabling the timer.

Note that this will not be seen on OMAP1 devices, because these devices do
not use the clock framework for dmtimers.

Signed-off-by: Jon Hunter <jon-hunter@ti.com>
Acked-by: Kevin Hilman <khilman@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/arm/plat-omap/dmtimer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/plat-omap/dmtimer.c b/arch/arm/plat-omap/dmtimer.c
index 626ad8c..7b6689a 100644
--- a/arch/arm/plat-omap/dmtimer.c
+++ b/arch/arm/plat-omap/dmtimer.c
@@ -258,7 +258,7 @@ EXPORT_SYMBOL_GPL(omap_dm_timer_enable);
 
 void omap_dm_timer_disable(struct omap_dm_timer *timer)
 {
-	pm_runtime_put(&timer->pdev->dev);
+	pm_runtime_put_sync(&timer->pdev->dev);
 }
 EXPORT_SYMBOL_GPL(omap_dm_timer_disable);
 


