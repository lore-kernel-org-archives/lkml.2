Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755014Ab2BRCGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 21:06:42 -0500
Received: from lunge.queued.net ([173.255.254.236]:53236 "EHLO
	lunge.queued.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab2BRCGk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 21:06:40 -0500
Date: Fri, 17 Feb 2012 18:06:34 -0800
From: Andres Salomon <dilinger@queued.net>
To: Alessandro Rubini <rubini@cvml.unipv.it>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Fox <pgf@laptop.org>,
        Martin Langhoff <martin@laptop.org>
Subject: [PATCH] input: psmouse:  create an 'enabled' sysfs attribute to
 squelch mouse
Message-ID: <20120217180634.6162196e@debxo>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Paul Fox <pgf@laptop.org>

on OLPC XO laptops, at least one model of touchpad (sentelic)
emits continuous jittery motion reports when the laptop is
configured in "ebook" mode.  the touchpad is inaccessible in
that configuration, so we simply disable it.

these motion reports will wake the SoC when put to sleep, so simply
ignoring the events is not a possibilty; the device must be disabled.

[dilinger@queued.net: drop psmouse_resync changes, add attribute comment,
 and add psmouse_cleanup workaround]

Signed-off-by: Andres Salomon <dilinger@queued.net>
---
 drivers/input/mouse/psmouse-base.c |   20 ++++++++++++++++++--
 drivers/input/mouse/psmouse.h      |    1 +
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/input/mouse/psmouse-base.c b/drivers/input/mouse/psmouse-base.c
index 22fe254..a115534 100644
--- a/drivers/input/mouse/psmouse-base.c
+++ b/drivers/input/mouse/psmouse-base.c
@@ -87,6 +87,13 @@ PSMOUSE_DEFINE_ATTR(resetafter, S_IWUSR | S_IRUGO,
 PSMOUSE_DEFINE_ATTR(resync_time, S_IWUSR | S_IRUGO,
 			(void *) offsetof(struct psmouse, resync_time),
 			psmouse_show_int_attr, psmouse_set_int_attr);
+/*
+ * There's no need for a custom handler for the 'enabled' attr;
+ * psmouse_attr_set_helper will take care of disabling and enabling for us.
+ */
+PSMOUSE_DEFINE_ATTR(enabled, S_IWUSR | S_IRUGO,
+			(void *) offsetof(struct psmouse, enabled),
+			psmouse_show_int_attr, psmouse_set_int_attr);
 
 static struct attribute *psmouse_attributes[] = {
 	&psmouse_attr_protocol.dattr.attr,
@@ -94,6 +101,7 @@ static struct attribute *psmouse_attributes[] = {
 	&psmouse_attr_resolution.dattr.attr,
 	&psmouse_attr_resetafter.dattr.attr,
 	&psmouse_attr_resync_time.dattr.attr,
+	&psmouse_attr_enabled.dattr.attr,
 	NULL
 };
 
@@ -1094,6 +1102,9 @@ static void psmouse_initialize(struct psmouse *psmouse)
 
 int psmouse_activate(struct psmouse *psmouse)
 {
+	if (!psmouse->enabled)
+		return 0;
+
 	if (ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_ENABLE)) {
 		psmouse_warn(psmouse, "Failed to enable mouse on %s\n",
 			     psmouse->ps2dev.serio->phys);
@@ -1256,7 +1267,8 @@ static void psmouse_cleanup(struct serio *serio)
  * Some boxes, such as HP nx7400, get terribly confused if mouse
  * is not fully enabled before suspending/shutting down.
  */
-	ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_ENABLE);
+	if (psmouse->enabled)
+		ps2_command(&psmouse->ps2dev, NULL, PSMOUSE_CMD_ENABLE);
 
 	if (parent) {
 		if (parent->pt_deactivate)
@@ -1418,6 +1430,7 @@ static int psmouse_connect(struct serio *serio, struct serio_driver *drv)
 	psmouse->resolution = psmouse_resolution;
 	psmouse->resetafter = psmouse_resetafter;
 	psmouse->resync_time = parent ? 0 : psmouse_resync_time;
+	psmouse->enabled = true;
 	psmouse->smartscroll = psmouse_smartscroll;
 
 	psmouse_switch_protocol(psmouse, NULL);
@@ -1516,7 +1529,10 @@ static int psmouse_reconnect(struct serio *serio)
 	if (parent && parent->pt_activate)
 		parent->pt_activate(parent);
 
-	psmouse_activate(psmouse);
+	if (psmouse->enabled)
+		psmouse_activate(psmouse);
+	else
+		psmouse_deactivate(psmouse);
 	rc = 0;
 
 out:
diff --git a/drivers/input/mouse/psmouse.h b/drivers/input/mouse/psmouse.h
index fe1df23..aa30321 100644
--- a/drivers/input/mouse/psmouse.h
+++ b/drivers/input/mouse/psmouse.h
@@ -62,6 +62,7 @@ struct psmouse {
 	unsigned int resolution;
 	unsigned int resetafter;
 	unsigned int resync_time;
+	bool enabled;
 	bool smartscroll;	/* Logitech only */
 
 	psmouse_ret_t (*protocol_handler)(struct psmouse *psmouse);
-- 
1.7.2.5

