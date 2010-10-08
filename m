Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615Ab0JHO6a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 10:58:30 -0400
Received: from adelie.canonical.com ([91.189.90.139]:60482 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893Ab0JHO6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 10:58:10 -0400
From: Chase Douglas <chase.douglas@canonical.com>
To: linux-input@vger.kernel.org, xorg-devel@lists.x.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Chris Bagwell <chris@cnpbagwell.com>,
        Andy Whitcroft <apw@canonical.com>,
        Henrik Rydberg <rydberg@euromail.se>, linux-kernel@vger.kernel.org,
        Peter Hutterer <peter.hutterer@who-t.net>,
        Duncan McGreggor <duncan.mcgreggor@canonical.com>
Subject: [PATCH 3/3] Input: synaptics - remove touches over button click area
Date: Fri,  8 Oct 2010 10:58:00 -0400
Message-Id: <1286549880-32580-4-git-send-email-chase.douglas@canonical.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1286549880-32580-3-git-send-email-chase.douglas@canonical.com>
References: <1286549880-32580-1-git-send-email-chase.douglas@canonical.com>
 <1286549880-32580-2-git-send-email-chase.douglas@canonical.com>
 <1286549880-32580-3-git-send-email-chase.douglas@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have proper multitouch support, we can handle integrated
buttons better. If we know the top of the buttons on the touchpad, we
can ignore any touches that occur within the touchpad area while a
button is clicked. It may be possible to get the button area by querying
the device, but for now allow the user to manually set it.

A note on why this works: the Synaptics touchpads have pseudo touch
tracking. When two touches are on the touchpad, an MT touch packet with
just the X, Y, and pressure values is sent before a normal Synaptics
touch packet. When one touch is obviously in motion and the other is
stationary, the touchpad controller sends the touch in motion in the
normal packet and the stationary touch in the MT packet. Single touch
emulation is provided by the normal packet, so an action like clicking
a button and dragging with another finger still works as expected.

Tested on a Dell Mini 1012 with synaptics_multitouch=1 and
synaptics_button_thresh=4100.

Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
---
 drivers/input/mouse/synaptics.c |   16 +++++++++++++++-
 1 files changed, 15 insertions(+), 1 deletions(-)

diff --git a/drivers/input/mouse/synaptics.c b/drivers/input/mouse/synaptics.c
index 7289d88..e67778d 100644
--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -49,6 +49,12 @@ module_param(synaptics_multitouch, bool, 0644);
 MODULE_PARM_DESC(synaptics_multitouch,
 		 "Enable multitouch mode on Synaptics devices");
 
+static int synaptics_button_thresh = YMIN_NOMINAL + YMAX_NOMINAL;
+module_param(synaptics_button_thresh, int, 0644);
+MODULE_PARM_DESC(synaptics_button_thres,
+		 "Y coordinate threshold of integrated buttons on Synaptics "
+		 "devices");
+
 /*****************************************************************************
  *	Stuff we need even when we do not want native Synaptics support
  ****************************************************************************/
@@ -463,6 +469,10 @@ static void synaptics_parse_hw_state(unsigned char buf[], struct synaptics_data
 	}
 }
 
+#define TOUCH_OVER_BUTTON(hw) (((hw).left || (hw).middle || (hw).right) && \
+			       (YMAX_NOMINAL + YMIN_NOMINAL - (hw).y > \
+				synaptics_button_thresh))
+
 /*
  *  called for each full received packet from the touchpad
  */
@@ -477,7 +487,7 @@ static void synaptics_process_packet(struct psmouse *psmouse)
 	synaptics_parse_hw_state(psmouse->packet, priv, &hw);
 
 	if (SYN_MULTITOUCH(priv, &hw)) {
-		if (hw.z > 0) {
+		if (hw.z > 0 && !TOUCH_OVER_BUTTON(hw)) {
 			input_report_abs(dev, ABS_MT_POSITION_X, hw.x);
 			input_report_abs(dev, ABS_MT_POSITION_Y,
 					 YMAX_NOMINAL + YMIN_NOMINAL - hw.y);
@@ -509,6 +519,10 @@ static void synaptics_process_packet(struct psmouse *psmouse)
 		return;
 	}
 
+	/* If touch occurs over depressed button, ignore it */
+	if (TOUCH_OVER_BUTTON(hw))
+		hw.z = 0;
+
 	if (hw.z > 0) {
 		priv->num_fingers++;
 		finger_width = 5;
-- 
1.7.1

