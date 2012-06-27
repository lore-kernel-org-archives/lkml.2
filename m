Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258Ab2F0VrL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 17:47:11 -0400
Received: from mail01.worldserver.net ([217.13.200.41]:40195 "EHLO
	mail01.worldserver.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932136Ab2F0VrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 17:47:10 -0400
X-Greylist: delayed 622 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Jun 2012 17:47:09 EDT
From: Olivier Goffart <ogoffart@woboq.com>
To: avatar@sentelic.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olivier Goffart <ogoffart@woboq.com>
Subject: [PATCH] Fix sentelic multi-touch driver
Date: Wed, 27 Jun 2012 22:36:15 +0200
Message-Id: <1340829375-4995-1-git-send-email-ogoffart@woboq.com>
X-Mailer: git-send-email 1.7.11.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Always report both finger between the sync.  Even if the documentation
of input-mt says one can only report one at the time, it does not
work otherwise. This fix scrolling in X11 which flickers a lot.

Ignore the duplicate or release events. They keep some gestures from
working (such as the two-finger tap)

This seems to fix the problems reported here:
https://bugzilla.kernel.org/show_bug.cgi?id=43591

Signed-off-by: Olivier Goffart <ogoffart@woboq.com>
---
 drivers/input/mouse/sentelic.c | 46 +++++++++++++++++++++++++++++++++++++-----
 drivers/input/mouse/sentelic.h |  3 +++
 2 files changed, 44 insertions(+), 5 deletions(-)

diff --git a/drivers/input/mouse/sentelic.c b/drivers/input/mouse/sentelic.c
index 3f5649f..b205857 100644
--- a/drivers/input/mouse/sentelic.c
+++ b/drivers/input/mouse/sentelic.c
@@ -731,6 +731,17 @@ static psmouse_ret_t fsp_process_byte(struct psmouse *psmouse)
 			 */
 			fgrs = 2;
 
+			if (abs_x == 0 && abs_y == 0) {
+				/*
+				 * We can ignore multi-finger release events.
+				 * We notice a finger has left the touchpad
+				 * when we receive events for the other finger.
+				 * And for the last finger, we receive
+				 * single-finger release events.
+				 */
+				return PSMOUSE_FULL_PACKET;
+			}
+
 			/* MFMC packet */
 			if (packet[0] & FSP_PB0_MFMC_FGR2) {
 				/* 2nd finger */
@@ -742,10 +753,16 @@ static psmouse_ret_t fsp_process_byte(struct psmouse *psmouse)
 					 */
 					fgrs = 1;
 					fsp_set_slot(dev, 0, false, 0, 0);
+					fsp_set_slot(dev, 1, fgrs == 1,
+						     abs_x, abs_y);
+				} else {
+					ad->last_mt_fgr = 2;
+					fsp_set_slot(dev, 0, true,
+						     ad->finger1_abs_x,
+						     ad->finger1_abs_y);
+					fsp_set_slot(dev, 1, fgrs == 2,
+						     abs_x, abs_y);
 				}
-				ad->last_mt_fgr = 2;
-
-				fsp_set_slot(dev, 1, fgrs == 2, abs_x, abs_y);
 			} else {
 				/* 1st finger */
 				if (ad->last_mt_fgr == 1) {
@@ -755,10 +772,29 @@ static psmouse_ret_t fsp_process_byte(struct psmouse *psmouse)
 					 * the 2nd finger is up
 					 */
 					fgrs = 1;
+					fsp_set_slot(dev, 0, fgrs != 0,
+						     abs_x, abs_y);
 					fsp_set_slot(dev, 1, false, 0, 0);
+				} else {
+					ad->finger1_abs_x = abs_x;
+					ad->finger1_abs_y = abs_y;
+
+					/*
+					 * There is a superflous event from the
+					 * driver when the two fingers are put
+					 * on the touchpad. Don't set
+					 * last_mt_fgr if we have not seen the
+					 * second figner yet, so the previous
+					 * workarond is not triggered and the
+					 * superflous event is ignored.
+					 * This is required to get the two
+					 * finger tap gesture working.
+					 */
+					if (ad->last_mt_fgr != 0)
+						ad->last_mt_fgr = 1;
+
+					return PSMOUSE_FULL_PACKET;
 				}
-				ad->last_mt_fgr = 1;
-				fsp_set_slot(dev, 0, fgrs != 0, abs_x, abs_y);
 			}
 		} else {
 			/* SFAC packet */
diff --git a/drivers/input/mouse/sentelic.h b/drivers/input/mouse/sentelic.h
index aa697ec..7224f84 100644
--- a/drivers/input/mouse/sentelic.h
+++ b/drivers/input/mouse/sentelic.h
@@ -117,6 +117,9 @@ struct fsp_data {
 	unsigned char	last_reg;	/* Last register we requested read from */
 	unsigned char	last_val;
 	unsigned int	last_mt_fgr;	/* Last seen finger(multitouch) */
+
+	unsigned short finger1_abs_x; /* finger1 absolute position */
+	unsigned short finger1_abs_y;
 };
 
 #ifdef CONFIG_MOUSE_PS2_SENTELIC
-- 
1.7.11.1

