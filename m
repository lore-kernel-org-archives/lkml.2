Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936Ab2BIG6Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 01:58:24 -0500
Received: from lunge.queued.net ([173.255.254.236]:52655 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab2BIG6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 01:58:20 -0500
Date: Wed, 8 Feb 2012 22:58:19 -0800
From: Andres Salomon <dilinger@queued.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Alessandro Rubini <rubini@cvml.unipv.it>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, pgf@laptop.org
Subject: [PATCH 2/2] input: psmouse: use psmouse_[de]activate() from
 sentelic and hgpk drivers
Message-ID: <20120208225819.042d5b55@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Fox <pgf@laptop.org>

Make use of psmouse_activate() and psmouse_deactivate() from psmouse-base.c

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/input/mouse/hgpk.c     |    9 ++-------
 drivers/input/mouse/sentelic.c |   12 ++++--------
 2 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/input/mouse/hgpk.c b/drivers/input/mouse/hgpk.c
index 1c5d521..575f880 100644
--- a/drivers/input/mouse/hgpk.c
+++ b/drivers/input/mouse/hgpk.c
@@ -640,7 +640,6 @@ static int hgpk_reset_device(struct psmouse *psmouse, bool recalibrate)
 
 static int hgpk_force_recalibrate(struct psmouse *psmouse)
 {
-	struct ps2dev *ps2dev = &psmouse->ps2dev;
 	struct hgpk_data *priv = psmouse->private;
 	int err;
 
@@ -669,12 +668,9 @@ static int hgpk_force_recalibrate(struct psmouse *psmouse)
 	 * we don't have a good way to deal with it.  The 2s window stuff
 	 * (below) is our best option for now.
 	 */
-
-	if (ps2_command(ps2dev, NULL, PSMOUSE_CMD_ENABLE))
+	if (psmouse_activate(psmouse))
 		return -1;
 
-	psmouse_set_state(psmouse, PSMOUSE_ACTIVATED);
-
 	if (tpdebug)
 		psmouse_dbg(psmouse, "touchpad reactivated\n");
 
@@ -733,8 +729,7 @@ static int hgpk_toggle_powersave(struct psmouse *psmouse, int enable)
 		}
 
 		/* should be all set, enable the touchpad */
-		ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_ENABLE);
-		psmouse_set_state(psmouse, PSMOUSE_ACTIVATED);
+		psmouse_activate(psmouse);
 		psmouse_dbg(psmouse, "Touchpad powered up.\n");
 	} else {
 		psmouse_dbg(psmouse, "Powering off touchpad.\n");
diff --git a/drivers/input/mouse/sentelic.c b/drivers/input/mouse/sentelic.c
index e36847d..2a77a52 100644
--- a/drivers/input/mouse/sentelic.c
+++ b/drivers/input/mouse/sentelic.c
@@ -90,8 +90,7 @@ static int fsp_reg_read(struct psmouse *psmouse, int reg_addr, int *reg_val)
 	 * to do that for writes because sysfs set helper does this for
 	 * us.
 	 */
-	ps2_command(ps2dev, NULL, PSMOUSE_CMD_DISABLE);
-	psmouse_set_state(psmouse, PSMOUSE_CMD_MODE);
+	psmouse_deactivate(psmouse);
 
 	ps2_begin_command(ps2dev);
 
@@ -128,8 +127,7 @@ static int fsp_reg_read(struct psmouse *psmouse, int reg_addr, int *reg_val)
 
  out:
 	ps2_end_command(ps2dev);
-	ps2_command(ps2dev, NULL, PSMOUSE_CMD_ENABLE);
-	psmouse_set_state(psmouse, PSMOUSE_ACTIVATED);
+	psmouse_activate(psmouse);
 	dev_dbg(&ps2dev->serio->dev, "READ REG: 0x%02x is 0x%02x (rc = %d)\n",
 		reg_addr, *reg_val, rc);
 	return rc;
@@ -213,8 +211,7 @@ static int fsp_page_reg_read(struct psmouse *psmouse, int *reg_val)
 	unsigned char param[3];
 	int rc = -1;
 
-	ps2_command(ps2dev, NULL, PSMOUSE_CMD_DISABLE);
-	psmouse_set_state(psmouse, PSMOUSE_CMD_MODE);
+	psmouse_deactivate(psmouse);
 
 	ps2_begin_command(ps2dev);
 
@@ -239,8 +236,7 @@ static int fsp_page_reg_read(struct psmouse *psmouse, int *reg_val)
 
  out:
 	ps2_end_command(ps2dev);
-	ps2_command(ps2dev, NULL, PSMOUSE_CMD_ENABLE);
-	psmouse_set_state(psmouse, PSMOUSE_ACTIVATED);
+	psmouse_activate(psmouse);
 	dev_dbg(&ps2dev->serio->dev, "READ PAGE REG: 0x%02x (rc = %d)\n",
 		*reg_val, rc);
 	return rc;
-- 
1.7.2.5

