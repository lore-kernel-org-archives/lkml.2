Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab2JRUb5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 16:31:57 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:56790 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397Ab2JRU0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 16:26:54 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 06/21] TTY: vt, fix paste_selection ldisc handling
Date: Thu, 18 Oct 2012 22:26:32 +0200
Message-Id: <1350592007-9216-7-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.12.3
In-Reply-To: <1350592007-9216-1-git-send-email-jslaby@suse.cz>
References: <1350592007-9216-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There used to be a single tty_ldisc_ref_wait. But then, when a
big-tty-mutex (BTM) was introduced, it has to be tty_ldisc_ref +
tty_unlock + tty_ldisc_ref_wait + tty_lock. Later, BTM was removed
from that path and tty_ldisc_ref + tty_ldisc_ref_wait remained there.
But it makes no sense now. So leave there only tty_ldisc_ref_wait.

And when we have a reference to an ldisc, actually use it in the loop.
Otherwise it may be racy.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/vt/selection.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/vt/selection.c b/drivers/tty/vt/selection.c
index 8e9b4be..60b7b69 100644
--- a/drivers/tty/vt/selection.c
+++ b/drivers/tty/vt/selection.c
@@ -341,15 +341,11 @@ int paste_selection(struct tty_struct *tty)
 	struct  tty_ldisc *ld;
 	DECLARE_WAITQUEUE(wait, current);
 
-
 	console_lock();
 	poke_blanked_console();
 	console_unlock();
 
-	/* FIXME: wtf is this supposed to achieve ? */
-	ld = tty_ldisc_ref(tty);
-	if (!ld)
-		ld = tty_ldisc_ref_wait(tty);
+	ld = tty_ldisc_ref_wait(tty);
 
 	/* FIXME: this is completely unsafe */
 	add_wait_queue(&vc->paste_wait, &wait);
@@ -361,8 +357,7 @@ int paste_selection(struct tty_struct *tty)
 		}
 		count = sel_buffer_lth - pasted;
 		count = min(count, tty->receive_room);
-		tty->ldisc->ops->receive_buf(tty, sel_buffer + pasted,
-								NULL, count);
+		ld->ops->receive_buf(tty, sel_buffer + pasted, NULL, count);
 		pasted += count;
 	}
 	remove_wait_queue(&vc->paste_wait, &wait);
-- 
1.7.12.3


