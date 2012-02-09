Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755805Ab2BIG5h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 01:57:37 -0500
Received: from lunge.queued.net ([173.255.254.236]:52650 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab2BIG5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 01:57:35 -0500
Date: Wed, 8 Feb 2012 22:57:34 -0800
From: Andres Salomon <dilinger@queued.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Alessandro Rubini <rubini@cvml.unipv.it>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, pgf@laptop.org
Subject: [PATCH 1/2] input: psmouse: allow drivers to use
 psmouse_{de,}activate
Message-ID: <20120208225734.68007a5b@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Other drivers duplicate this code; no sense in having it be private
to psmouse-base.

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/input/mouse/psmouse-base.c |   15 ++++++++++-----
 drivers/input/mouse/psmouse.h      |    2 ++
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/input/mouse/psmouse-base.c b/drivers/input/mouse/psmouse-base.c
index e6c9931..22fe254 100644
--- a/drivers/input/mouse/psmouse-base.c
+++ b/drivers/input/mouse/psmouse-base.c
@@ -1092,28 +1092,33 @@ static void psmouse_initialize(struct psmouse *psmouse)
  * psmouse_activate() enables the mouse so that we get motion reports from it.
  */
 
-static void psmouse_activate(struct psmouse *psmouse)
+int psmouse_activate(struct psmouse *psmouse)
 {
-	if (ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_ENABLE))
+	if (ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_ENABLE)) {
 		psmouse_warn(psmouse, "Failed to enable mouse on %s\n",
 			     psmouse->ps2dev.serio->phys);
+		return -1;
+	}
 
 	psmouse_set_state(psmouse, PSMOUSE_ACTIVATED);
+	return 0;
 }
 
-
 /*
  * psmouse_deactivate() puts the mouse into poll mode so that we don't get motion
  * reports from it unless we explicitly request it.
  */
 
-static void psmouse_deactivate(struct psmouse *psmouse)
+int psmouse_deactivate(struct psmouse *psmouse)
 {
-	if (ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_DISABLE))
+	if (ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_DISABLE)) {
 		psmouse_warn(psmouse, "Failed to deactivate mouse on %s\n",
 			     psmouse->ps2dev.serio->phys);
+		return -1;
+	}
 
 	psmouse_set_state(psmouse, PSMOUSE_CMD_MODE);
+	return 0;
 }
 
 
diff --git a/drivers/input/mouse/psmouse.h b/drivers/input/mouse/psmouse.h
index 6a41709..fe1df23 100644
--- a/drivers/input/mouse/psmouse.h
+++ b/drivers/input/mouse/psmouse.h
@@ -105,6 +105,8 @@ int psmouse_reset(struct psmouse *psmouse);
 void psmouse_set_state(struct psmouse *psmouse, enum psmouse_state new_state);
 void psmouse_set_resolution(struct psmouse *psmouse, unsigned int resolution);
 psmouse_ret_t psmouse_process_byte(struct psmouse *psmouse);
+int psmouse_activate(struct psmouse *psmouse);
+int psmouse_deactivate(struct psmouse *psmouse);
 
 struct psmouse_attribute {
 	struct device_attribute dattr;
-- 
1.7.2.5

