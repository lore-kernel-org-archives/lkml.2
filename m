Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab2ACWgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:36:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39582 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755133Ab2ACWgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:36:39 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:30:32 2012
Message-Id: <20120103223032.596347851@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:29:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Dmitry Torokhov <dtor@mail.ru>
Subject: [15/67] Input: synaptics - fix touchpad not working after S2R on Vostro V13
In-Reply-To: <20120103223043.GA26738@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 8521478f67e95ada4e87970c7b41e504c724b2cf upstream.

Synaptics touchpads on several Dell laptops, particularly Vostro V13
systems, may not respond properly to PS/2 commands and queries immediately
after resuming from suspend to RAM. This leads to unresponsive touchpad
after suspend/resume cycle.

Adding a 1-second delay after resetting the device allows touchpad to
finish initializing (calibrating?) and start reacting properly.

Reported-by: Daniel Manrique <daniel.manrique@canonical.com>
Tested-by: Daniel Manrique <daniel.manrique@canonical.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/mouse/synaptics.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/input/mouse/synaptics.c
+++ b/drivers/input/mouse/synaptics.c
@@ -24,6 +24,7 @@
  */
 
 #include <linux/module.h>
+#include <linux/delay.h>
 #include <linux/dmi.h>
 #include <linux/input/mt.h>
 #include <linux/serio.h>
@@ -760,6 +761,16 @@ static int synaptics_reconnect(struct ps
 
 	do {
 		psmouse_reset(psmouse);
+		if (retry) {
+			/*
+			 * On some boxes, right after resuming, the touchpad
+			 * needs some time to finish initializing (I assume
+			 * it needs time to calibrate) and start responding
+			 * to Synaptics-specific queries, so let's wait a
+			 * bit.
+			 */
+			ssleep(1);
+		}
 		error = synaptics_detect(psmouse, 0);
 	} while (error && ++retry < 3);
 


