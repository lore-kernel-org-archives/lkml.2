Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab0IDCN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 22:13:27 -0400
Received: from kroah.org ([198.145.64.141]:48224 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753733Ab0IDCNZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 22:13:25 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Francisco Jerez <currojerez@riseup.net>, qiaochong <qiaochong@loongson.cn>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>
Subject: [PATCH 1/5] vt: Fix console corruption on driver hand-over.
Date: Fri,  3 Sep 2010 19:13:18 -0700
Message-Id: <1283566402-28832-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <20100904020937.GA28645@kroah.com>
References: <20100904020937.GA28645@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Francisco Jerez <currojerez@riseup.net>

After 02f0777a0d6560eb995aade34a1b82f95c0452da "vc_origin" is no
longer reset to the screen buffer before calling the con_init() hook
of the new console driver.

If the old driver wasn't using a fixed scanout buffer (e.g. the case
of vgacon) "vc_origin" may be a pointer to a VRAM location, and its
contents aren't guaranteed to be preserved after calling con_deinit()
on the old driver and con_init() on the new driver, i.e. the
subsequent console resize may fill the framebuffer with garbage.

It can be reproduced in the transition from vgacon to the nouveau
framebuffer driver: in that case the legacy VGA aperture "vc_origin"
points to becomes unreadable after fbcon_init().

This patch reverts the mentioned commit. To avoid the problem it
intended to fix, stop using "vc_scr_end" in vc_do_resize() to
calculate how many rows we have to copy (actually the code looks
simpler this way without the help of "vc_scr_end").

Signed-off-by: Francisco Jerez <currojerez@riseup.net>
Cc: qiaochong <qiaochong@loongson.cn>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/vt.c |   15 ++++-----------
 1 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 50590c7..281aada 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -906,22 +906,16 @@ static int vc_do_resize(struct tty_struct *tty, struct vc_data *vc,
 			 * bottom of buffer
 			 */
 			old_origin += (old_rows - new_rows) * old_row_size;
-			end = vc->vc_scr_end;
 		} else {
 			/*
 			 * Cursor is in no man's land, copy 1/2 screenful
 			 * from the top and bottom of cursor position
 			 */
 			old_origin += (vc->vc_y - new_rows/2) * old_row_size;
-			end = old_origin + (old_row_size * new_rows);
 		}
-	} else
-		/*
-		 * Cursor near the top, copy contents from the top of buffer
-		 */
-		end = (old_rows > new_rows) ? old_origin +
-			(old_row_size * new_rows) :
-			vc->vc_scr_end;
+	}
+
+	end = old_origin + old_row_size * min(old_rows, new_rows);
 
 	update_attr(vc);
 
@@ -3075,8 +3069,7 @@ static int bind_con_driver(const struct consw *csw, int first, int last,
 
 		old_was_color = vc->vc_can_do_color;
 		vc->vc_sw->con_deinit(vc);
-		if (!vc->vc_origin)
-			vc->vc_origin = (unsigned long)vc->vc_screenbuf;
+		vc->vc_origin = (unsigned long)vc->vc_screenbuf;
 		visual_init(vc, i, 0);
 		set_origin(vc);
 		update_attr(vc);
-- 
1.7.2

