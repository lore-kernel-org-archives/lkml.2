Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933193Ab2JaKMM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 06:12:12 -0400
Received: from mail-ee0-f74.google.com ([74.125.83.74]:57550 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932992Ab2JaKMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 06:12:09 -0400
From: Chung-yih Wang <cywang@chromium.org>
To: linux-input@vger.kernel.org
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Tai-hwa Liang <avatar@sentelic.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Paul Fox <pgf@laptop.org>,
        Chung-yih Wang <cywang@chromium.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] Input: psmouse - retry getid command in psmouse_probe()
Date: Wed, 31 Oct 2012 18:11:19 +0800
Message-Id: <1351678279-32615-1-git-send-email-cywang@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the synaptics device may not respond to the first command in psmouse_probe
when a machine is booting up, the patch gives a second probe if the first
one fails.

Signed-off-by: Chung-yih Wang <cywang@chromium.org>
---
 drivers/input/mouse/psmouse-base.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/input/mouse/psmouse-base.c b/drivers/input/mouse/psmouse-base.c
index 22fe254..c4fc5ad 100644
--- a/drivers/input/mouse/psmouse-base.c
+++ b/drivers/input/mouse/psmouse-base.c
@@ -1053,8 +1053,17 @@ static int psmouse_probe(struct psmouse *psmouse)
  */
 
 	param[0] = 0xa5;
-	if (ps2_command(ps2dev, param, PSMOUSE_CMD_GETID))
-		return -1;
+	if (ps2_command(ps2dev, param, PSMOUSE_CMD_GETID)) {
+		/*
+		 * Reprobe the device if it did not respond to the GETID
+		 * command. Before retry, additional dummy command is sent
+		 * to clear the 'RESEND' response if exists.
+		 */
+		psmouse_warn(psmouse, "GETID probe failed, retrying...\n");
+		ps2_command(ps2dev, NULL, PSMOUSE_CMD_SETSCALE11);
+		if (ps2_command(ps2dev, param, PSMOUSE_CMD_GETID))
+			return -1;
+	}
 
 	if (param[0] != 0x00 && param[0] != 0x03 &&
 	    param[0] != 0x04 && param[0] != 0xff)
-- 
1.7.7.3

