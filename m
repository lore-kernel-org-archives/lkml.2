Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab2CLPXe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 11:23:34 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:42448 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab2CLPXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 11:23:31 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Alan Cox <alan@linux.intel.com>
Subject: [PATCH 1/1] TTY: fix keyboard crash
Date: Mon, 12 Mar 2012 16:23:02 +0100
Message-Id: <1331565782-15300-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get this during bootup:
BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<ffffffff81301a59>] vt_do_kdsk_ioctl+0x2b9/0x3b0
...
Call Trace:
 [<ffffffff812fcbc0>] vt_ioctl+0xce0/0x12f0
 [<ffffffff812f2b1c>] tty_ioctl+0x28c/0xbe0
...

It is due to mistake in commit "vt:tackle kbd_table". It moves the
allocation to be away from the atomic section, but omits to set
key_map to the new pointer properly.

So do it here and now.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@linux.intel.com>
---
 drivers/tty/vt/keyboard.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
index 70d0593..269c6c9 100644
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -1862,7 +1862,7 @@ int vt_do_kdsk_ioctl(int cmd, struct kbentry __user *user_kbe, int perm,
 				kfree(new_map);
 				return -EPERM;
 			}
-			key_maps[s] = new_map;
+			key_map = key_maps[s] = new_map;
 			key_map[0] = U(K_ALLOCATED);
 			for (j = 1; j < NR_KEYS; j++)
 				key_map[j] = U(K_HOLE);
-- 
1.7.9.2


