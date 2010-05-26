Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857Ab0EZP5t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 11:57:49 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:46275 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755491Ab0EZP5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 11:57:46 -0400
Date: Wed, 26 May 2010 17:57:41 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Tomi Valkeinen <tomi.valkeinen@nokia.com>, linux-omap@vger.kernel.org,
       linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 12/17] drivers/video/omap2/displays: Add missing mutex_unlock
Message-ID: <Pine.LNX.4.64.1005261757240.23743@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Add a mutex_unlock missing on the error paths.  The use of the mutex is
balanced elsewhere in the file.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression E1;
@@

* mutex_lock(E1,...);
  <+... when != E1
  if (...) {
    ... when != E1
*   return ...;
  }
  ...+>
* mutex_unlock(E1,...);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/video/omap2/displays/panel-acx565akm.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/video/omap2/displays/panel-acx565akm.c b/drivers/video/omap2/displays/panel-acx565akm.c
index 1f8eb70..07fbb8a 100644
--- a/drivers/video/omap2/displays/panel-acx565akm.c
+++ b/drivers/video/omap2/displays/panel-acx565akm.c
@@ -592,7 +592,7 @@ static int acx_panel_power_on(struct omap_dss_device *dssdev)
 	r = omapdss_sdi_display_enable(dssdev);
 	if (r) {
 		pr_err("%s sdi enable failed\n", __func__);
-		return r;
+		goto fail_unlock;
 	}
 
 	/*FIXME tweak me */
@@ -633,6 +633,8 @@ static int acx_panel_power_on(struct omap_dss_device *dssdev)
 	return acx565akm_bl_update_status(md->bl_dev);
 fail:
 	omapdss_sdi_display_disable(dssdev);
+fail_unlock:
+	mutex_unlock(&md->mutex);
 	return r;
 }
 
