Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab2KSXaj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 18:30:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48160 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab2KSXaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 18:30:35 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>
Cc: David Solda <dso@cypress.com>, Troy Abercrombia <ta@cypress.com>,
        Cypress Semiconductor Corporation <customercare@cypress.com>,
        Kamal Mostafa <kamal@canonical.com>,
        Kyle Fazzari <git@status.e4ward.com>,
        Mario Limonciello <mario_limonciello@dell.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Herton Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 2/2] input: Cypress PS/2 Trackpad link into psmouse-base
Date: Mon, 19 Nov 2012 15:30:37 -0800
Message-Id: <1353367837-18229-3-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353367837-18229-1-git-send-email-kamal@canonical.com>
References: <1353367837-18229-1-git-send-email-kamal@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cypress Semiconductor Corporation <customercare@cypress.com>

Original code contributed by Cypress Semiconductor Corporation,
modified by Kamal Mostafa.

BugLink: http://launchpad.net/bugs/978807

Signed-off-by: Kamal Mostafa <kamal@canonical.com>
Signed-off-by: Mario Limonciello <mario_limonciello@dell.com>
Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 drivers/input/mouse/Kconfig        |   10 +++++++++
 drivers/input/mouse/Makefile       |    1 +
 drivers/input/mouse/psmouse-base.c |   40 ++++++++++++++++++++++++++++++++++++
 drivers/input/mouse/psmouse.h      |    2 ++
 4 files changed, 53 insertions(+)

diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
index cd6268c..88954dd 100644
--- a/drivers/input/mouse/Kconfig
+++ b/drivers/input/mouse/Kconfig
@@ -68,6 +68,16 @@ config MOUSE_PS2_SYNAPTICS
 
 	  If unsure, say Y.
 
+config MOUSE_PS2_CYPRESS
+       bool "Cypress PS/2 mouse protocol extension" if EXPERT
+       default y
+       depends on MOUSE_PS2
+       help
+         Say Y here if you have a Cypress PS/2 Trackpad connected to
+         your system.
+
+         If unsure, say Y.
+
 config MOUSE_PS2_LIFEBOOK
 	bool "Fujitsu Lifebook PS/2 mouse protocol extension" if EXPERT
 	default y
diff --git a/drivers/input/mouse/Makefile b/drivers/input/mouse/Makefile
index 46ba755..323e352 100644
--- a/drivers/input/mouse/Makefile
+++ b/drivers/input/mouse/Makefile
@@ -32,3 +32,4 @@ psmouse-$(CONFIG_MOUSE_PS2_LIFEBOOK)	+= lifebook.o
 psmouse-$(CONFIG_MOUSE_PS2_SENTELIC)	+= sentelic.o
 psmouse-$(CONFIG_MOUSE_PS2_TRACKPOINT)	+= trackpoint.o
 psmouse-$(CONFIG_MOUSE_PS2_TOUCHKIT)	+= touchkit_ps2.o
+psmouse-$(CONFIG_MOUSE_PS2_CYPRESS)	+= cypress_ps2.o
diff --git a/drivers/input/mouse/psmouse-base.c b/drivers/input/mouse/psmouse-base.c
index 22fe254..32c06e7 100644
--- a/drivers/input/mouse/psmouse-base.c
+++ b/drivers/input/mouse/psmouse-base.c
@@ -23,6 +23,7 @@
 #include <linux/init.h>
 #include <linux/libps2.h>
 #include <linux/mutex.h>
+#include <linux/sched.h>
 
 #include "psmouse.h"
 #include "synaptics.h"
@@ -34,6 +35,7 @@
 #include "touchkit_ps2.h"
 #include "elantech.h"
 #include "sentelic.h"
+#include "cypress_ps2.h"
 
 #define DRIVER_DESC	"PS/2 mouse driver"
 
@@ -321,6 +323,13 @@ static irqreturn_t psmouse_interrupt(struct serio *serio,
 	if (psmouse->state <= PSMOUSE_RESYNCING)
 		goto out;
 
+	/* For Cypress Trackpad to read some special data more than 6 bytes. */
+	if (psmouse->state == PSMOUSE_CMD_CYTP) {
+		psmouse->packet[psmouse->pktcnt++] = data;
+		wake_up(&psmouse->ps2dev.wait);
+		goto out;
+	}
+
 	if (psmouse->state == PSMOUSE_ACTIVATED &&
 	    psmouse->pktcnt && time_after(jiffies, psmouse->last + HZ/2)) {
 		psmouse_info(psmouse, "%s at %s lost synchronization, throwing %d bytes away.\n",
@@ -759,6 +768,28 @@ static int psmouse_extensions(struct psmouse *psmouse,
 	}
 
 /*
+ * Try Cypress Trackpad.
+ * Must try it before Finger Sensing Pad because Finger Sensing Pad probe
+ * upsets some modules of Cypress Trackpads.
+ */
+	if (max_proto > PSMOUSE_IMEX &&
+			cypress_detect(psmouse, set_properties) == 0) {
+		if (cypress_supported()) {
+			if (cypress_init(psmouse) == 0)
+				return PSMOUSE_CYPRESS;
+
+			/*
+			 * Finger Sensing Pad probe upsets some modules of
+			 * Cypress Trackpad, must avoid Finger Sensing Pad
+			 * probe if Cypress Trackpad device detected.
+			 */
+			return PSMOUSE_PS2;
+		}
+
+		max_proto = PSMOUSE_IMEX;
+	}
+
+/*
  * Try ALPS TouchPad
  */
 	if (max_proto > PSMOUSE_IMEX) {
@@ -896,6 +927,15 @@ static const struct psmouse_protocol psmouse_protocols[] = {
 		.alias		= "thinkps",
 		.detect		= thinking_detect,
 	},
+#ifdef CONFIG_MOUSE_PS2_CYPRESS
+	{
+		.type		= PSMOUSE_CYPRESS,
+		.name		= "CyPS/2",
+		.alias		= "cypress",
+		.detect		= cypress_detect,
+		.init		= cypress_init,
+	},
+#endif
 	{
 		.type		= PSMOUSE_GENPS,
 		.name		= "GenPS/2",
diff --git a/drivers/input/mouse/psmouse.h b/drivers/input/mouse/psmouse.h
index fe1df23..054893f 100644
--- a/drivers/input/mouse/psmouse.h
+++ b/drivers/input/mouse/psmouse.h
@@ -26,6 +26,7 @@ enum psmouse_state {
 	PSMOUSE_INITIALIZING,
 	PSMOUSE_RESYNCING,
 	PSMOUSE_CMD_MODE,
+	PSMOUSE_CMD_CYTP,	/* Cypress Trackpad detecting and initializing state. */
 	PSMOUSE_ACTIVATED,
 };
 
@@ -95,6 +96,7 @@ enum psmouse_type {
 	PSMOUSE_ELANTECH,
 	PSMOUSE_FSP,
 	PSMOUSE_SYNAPTICS_RELATIVE,
+	PSMOUSE_CYPRESS,
 	PSMOUSE_AUTO		/* This one should always be last */
 };
 
-- 
1.7.10.4

