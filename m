Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab2DWJji (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 05:39:38 -0400
Received: from emcscan.emc.com.tw ([192.72.220.5]:57593 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab2DWJjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 05:39:37 -0400
X-Greylist: delayed 695 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Apr 2012 05:39:37 EDT
From: JJ Ding <jj_ding@emc.com.tw>
To: ubase133@gmail.com
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, JJ Ding <jj_ding@emc.com.tw>
Subject: [PATCH] Input: elantech - make synaptics_send_cmd() retry for 3 times
Date: Mon, 23 Apr 2012 17:30:00 +0800
Message-Id: <1335173400-15719-1-git-send-email-jj_ding@emc.com.tw>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

synaptics_send_cmd() doesn't seem to be very reliable with Elan touchapds,
so people could see infrequent failures when it is called in elantech_detect(),
resulting touchpads fail to be recognized as Elan.

Teach synaptics_send_cmd() to retry for 3 times to make sure we are properly
detected.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=43136
Reported-by: ubase133@gmail.com
Signed-off-by: JJ Ding <jj_ding@emc.com.tw>
---
Hi ubase133,

Dmitry forwarded your bugzilla report to me.

I used to see rare cases when this also happened on my test machine, but we
don't really know why. Does this always happen on your machine?

Anyway, could you please try this patch out? This is really the only fix I can
think of. If it doesn't work for you, then I will have to dig deeper.

P.S. Patch is against 3.4-rc4.

Thanks,
JJ

 drivers/input/mouse/elantech.c |   19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/input/mouse/elantech.c b/drivers/input/mouse/elantech.c
index 4790110..6b8df09 100644
--- a/drivers/input/mouse/elantech.c
+++ b/drivers/input/mouse/elantech.c
@@ -30,7 +30,7 @@
 /*
  * Send a Synaptics style sliced query command
  */
-static int synaptics_send_cmd(struct psmouse *psmouse, unsigned char c,
+static int __synaptics_send_cmd(struct psmouse *psmouse, unsigned char c,
 				unsigned char *param)
 {
 	if (psmouse_sliced_command(psmouse, c) ||
@@ -42,6 +42,23 @@ static int synaptics_send_cmd(struct psmouse *psmouse, unsigned char c,
 	return 0;
 }
 
+static int synaptics_send_cmd(struct psmouse *psmouse, unsigned char c,
+				unsigned char *param)
+{
+	int rc;
+	int tries = ETP_PS2_COMMAND_TRIES;
+
+	do {
+		rc = __synaptics_send_cmd(psmouse, c, param);
+		if (rc == 0)
+			break;
+		tries--;
+		msleep(ETP_PS2_COMMAND_DELAY);
+	} while (tries > 0);
+
+	return rc;
+}
+
 /*
  * V3 and later support this fast command
  */
-- 
1.7.10

