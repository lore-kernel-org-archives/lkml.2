Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933038Ab0GAUxk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 16:53:40 -0400
Received: from kroah.org ([198.145.64.141]:47899 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932854Ab0GAUvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 16:51:20 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:34:38 2010
Message-Id: <20100701173438.457605950@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:35:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dmitry Torokhov <dtor@mail.ru>, Tim Gardner <tim.gardner@canonical.com>
Subject: [patch 138/164] Input: psmouse - reset all types of mice before reconnecting
In-Reply-To: <20100701175152.GA2135@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit ef110b24e28f36620f63dab94708a17c7e267358 upstream.

Synaptics hardware requires resetting device after suspend to ram
in order for the device to be operational. The reset lives in
synaptics-specific reconnect handler, but it is not being invoked
if synaptics support is disabled and the device is handled as a
standard PS/2 device (bare or IntelliMouse protocol).

Let's add reset into generic reconnect handler as well.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
Cc: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/input/mouse/psmouse-base.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/input/mouse/psmouse-base.c
+++ b/drivers/input/mouse/psmouse-base.c
@@ -1382,6 +1382,7 @@ static int psmouse_reconnect(struct seri
 	struct psmouse *psmouse = serio_get_drvdata(serio);
 	struct psmouse *parent = NULL;
 	struct serio_driver *drv = serio->drv;
+	unsigned char type;
 	int rc = -1;
 
 	if (!drv || !psmouse) {
@@ -1401,10 +1402,15 @@ static int psmouse_reconnect(struct seri
 	if (psmouse->reconnect) {
 		if (psmouse->reconnect(psmouse))
 			goto out;
-	} else if (psmouse_probe(psmouse) < 0 ||
-		   psmouse->type != psmouse_extensions(psmouse,
-						psmouse_max_proto, false)) {
-		goto out;
+	} else {
+		psmouse_reset(psmouse);
+
+		if (psmouse_probe(psmouse) < 0)
+			goto out;
+
+		type = psmouse_extensions(psmouse, psmouse_max_proto, false);
+		if (psmouse->type != type)
+			goto out;
 	}
 
 	/* ok, the device type (and capabilities) match the old one,


