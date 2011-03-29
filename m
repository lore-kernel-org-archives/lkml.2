Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021Ab1C2VXt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 17:23:49 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:32862 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab1C2VXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 17:23:48 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/1] Char: moxa, do not touch NORMAL_ACTIVE bit
Date: Tue, 29 Mar 2011 23:23:41 +0200
Message-Id: <1301433821-4246-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The bit is set in tty_port_block_til_ready (via moxa_open) and unset
in tty_port_close (via moxa_close). No need to pin it in the driver.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/tty/moxa.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/moxa.c b/drivers/tty/moxa.c
index ffdaab3..a290e9e 100644
--- a/drivers/tty/moxa.c
+++ b/drivers/tty/moxa.c
@@ -1129,7 +1129,6 @@ static void moxa_shutdown(struct tty_port *port)
 	struct moxa_port *ch = container_of(port, struct moxa_port, port);
         MoxaPortDisable(ch);
 	MoxaPortFlushData(ch, 2);
-	clear_bit(ASYNCB_NORMAL_ACTIVE, &port->flags);
 }
 
 static int moxa_carrier_raised(struct tty_port *port)
@@ -1155,7 +1154,6 @@ static int moxa_open(struct tty_struct *tty, struct file *filp)
 	struct moxa_board_conf *brd;
 	struct moxa_port *ch;
 	int port;
-	int retval;
 
 	port = tty->index;
 	if (port == MAX_PORTS) {
@@ -1190,10 +1188,7 @@ static int moxa_open(struct tty_struct *tty, struct file *filp)
 	mutex_unlock(&ch->port.mutex);
 	mutex_unlock(&moxa_openlock);
 
-	retval = tty_port_block_til_ready(&ch->port, tty, filp);
-	if (retval == 0)
-	        set_bit(ASYNCB_NORMAL_ACTIVE, &ch->port.flags);
-	return retval;
+	return tty_port_block_til_ready(&ch->port, tty, filp);
 }
 
 static void moxa_close(struct tty_struct *tty, struct file *filp)
-- 
1.7.4.1


