Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762122Ab2FVNYL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 09:24:11 -0400
Received: from the-brannons.com ([64.62.188.119]:36483 "EHLO
	hurricane.the-brannons.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762087Ab2FVNYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 09:24:09 -0400
X-Greylist: delayed 451 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Jun 2012 09:24:09 EDT
From: Christopher Brannon <chris@the-brannons.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] tty: keyboard.c: Remove locking from vt_get_leds.
Date: Fri, 22 Jun 2012 08:16:34 -0500
Message-Id: <1340370994-6914-1-git-send-email-chris@the-brannons.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are three call sites for this function, and all three
are called within a keyboard handler.
kbd_event_lock is already held within keyboard handlers,
so attempting to lock it in vt_get_leds causes deadlock.

Signed-off-by: Christopher Brannon <chris@the-brannons.com>
---
 drivers/tty/vt/keyboard.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
index 48cc6f2..770a854 100644
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -1049,13 +1049,10 @@ static int kbd_update_leds_helper(struct input_handle *handle, void *data)
  */
 int vt_get_leds(int console, int flag)
 {
-	unsigned long flags;
 	struct kbd_struct * kbd = kbd_table + console;
 	int ret;
 
-	spin_lock_irqsave(&kbd_event_lock, flags);
 	ret = vc_kbd_led(kbd, flag);
-	spin_unlock_irqrestore(&kbd_event_lock, flags);
 
 	return ret;
 }
-- 
1.7.10.4

