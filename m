Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162218Ab2GLW5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:57:09 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34801 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162144Ab2GLWns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:43:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Joe Woodward <jw@terrafix.co.uk>
Subject: [ 142/187] OMAPDSS: use DSI_FIFO_BUG workaround only for manual update displays
Date: Thu, 12 Jul 2012 15:34:58 -0700
Message-Id: <20120712191535.568847312@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712191522.742634173@linuxfoundation.org>
References: <20120712192421.GA28926@kroah.com>
 <20120712191522.742634173@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomi Valkeinen <tomi.valkeinen@ti.com>

commit 3568f2a46f2a73bab18c914df06afd98a97e0e0e upstream.

There is a problem related to DSS FIFO thresholds and power management
on OMAP3. It seems that when the full PM hits in, we get underflows. The
core reason is unknown, but after experiments it looks like only
particular FIFO thresholds work correctly.

This bug is related to an earlier patch, which added special FIFO
threshold configuration for OMAP3, because DSI command mode output
didn't work with the normal threshold configuration.

However, as the above work-around worked fine for other output types
also, we currently always configure thresholds in this special way on
OMAP3. In theory there should be negligible difference with this special
way and the standard way. The first paragraph explains what happens in
practice.

This patch changes the driver to use the special threshold configuration
only when the output is a manual update display on OMAP3. This does
include RFBI displays also, and although it hasn't been tested (no
boards using RFBI) I suspect the similar behaviour is present there
also, as the DISPC side should work similarly for DSI command mode and
RFBI.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Joe Woodward <jw@terrafix.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/video/omap2/dss/apply.c |    2 +-
 drivers/video/omap2/dss/dispc.c |    5 +++--
 drivers/video/omap2/dss/dss.h   |    3 ++-
 3 files changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/video/omap2/dss/apply.c
+++ b/drivers/video/omap2/dss/apply.c
@@ -927,7 +927,7 @@ static void dss_ovl_setup_fifo(struct om
 	dssdev = ovl->manager->device;
 
 	dispc_ovl_compute_fifo_thresholds(ovl->id, &fifo_low, &fifo_high,
-			use_fifo_merge);
+			use_fifo_merge, ovl_manual_update(ovl));
 
 	dss_apply_ovl_fifo_thresholds(ovl, fifo_low, fifo_high);
 }
--- a/drivers/video/omap2/dss/dispc.c
+++ b/drivers/video/omap2/dss/dispc.c
@@ -1063,7 +1063,8 @@ void dispc_enable_fifomerge(bool enable)
 }
 
 void dispc_ovl_compute_fifo_thresholds(enum omap_plane plane,
-		u32 *fifo_low, u32 *fifo_high, bool use_fifomerge)
+		u32 *fifo_low, u32 *fifo_high, bool use_fifomerge,
+		bool manual_update)
 {
 	/*
 	 * All sizes are in bytes. Both the buffer and burst are made of
@@ -1091,7 +1092,7 @@ void dispc_ovl_compute_fifo_thresholds(e
 	 * combined fifo size
 	 */
 
-	if (dss_has_feature(FEAT_OMAP3_DSI_FIFO_BUG)) {
+	if (manual_update && dss_has_feature(FEAT_OMAP3_DSI_FIFO_BUG)) {
 		*fifo_low = ovl_fifo_size - burst_size * 2;
 		*fifo_high = total_fifo_size - burst_size;
 	} else {
--- a/drivers/video/omap2/dss/dss.h
+++ b/drivers/video/omap2/dss/dss.h
@@ -424,7 +424,8 @@ int dispc_calc_clock_rates(unsigned long
 
 void dispc_ovl_set_fifo_threshold(enum omap_plane plane, u32 low, u32 high);
 void dispc_ovl_compute_fifo_thresholds(enum omap_plane plane,
-		u32 *fifo_low, u32 *fifo_high, bool use_fifomerge);
+		u32 *fifo_low, u32 *fifo_high, bool use_fifomerge,
+		bool manual_update);
 int dispc_ovl_setup(enum omap_plane plane, struct omap_overlay_info *oi,
 		bool ilace, bool replication);
 int dispc_ovl_enable(enum omap_plane plane, bool enable);


