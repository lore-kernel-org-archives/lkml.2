Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993116Ab2KOIuM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 03:50:12 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:58341 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992992Ab2KOIuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 03:50:04 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 2/9] TTY: pty, fix tty buffers leak
Date: Thu, 15 Nov 2012 09:49:49 +0100
Message-Id: <1352969396-23760-3-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1352969396-23760-1-git-send-email-jslaby@suse.cz>
References: <1352969396-23760-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After commit "TTY: move tty buffers to tty_port", the tty buffers are
not freed in some drivers. This is because tty_port_destructor is not
called whenever a tty_port is freed. This was an assumption I counted
with but was unfortunately untrue. So fix the drivers to fulfil this
assumption.

PTY is one of those, here we just need to use tty_port_put instead of
kfree. (Assuming tty_port_destructor does not need port->ops to be set
which we change here too.)

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/pty.c      | 2 +-
 drivers/tty/tty_port.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 0ce0b3e..a541ec8 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -408,7 +408,7 @@ static void pty_unix98_shutdown(struct tty_struct *tty)
 static void pty_cleanup(struct tty_struct *tty)
 {
 	tty->port->itty = NULL;
-	kfree(tty->port);
+	tty_port_put(tty->port);
 }
 
 /* Traditional BSD devices */
diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index 416b42f..fdc42c2 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -128,7 +128,7 @@ static void tty_port_destructor(struct kref *kref)
 	if (port->xmit_buf)
 		free_page((unsigned long)port->xmit_buf);
 	tty_buffer_free_all(port);
-	if (port->ops->destruct)
+	if (port->ops && port->ops->destruct)
 		port->ops->destruct(port);
 	else
 		kfree(port);
-- 
1.8.0


