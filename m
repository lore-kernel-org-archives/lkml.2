Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565Ab1DTIna (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 04:43:30 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:51017 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab1DTIn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 04:43:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 4/7] Char: moxa, fix locking in moxa_write
Date: Wed, 20 Apr 2011 10:43:15 +0200
Message-Id: <1303288998-31718-4-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1303288998-31718-1-git-send-email-jslaby@suse.cz>
References: <1303288998-31718-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

moxa_write can be called from atomic context with irqs disabled (from
ppp_async_push). Don't enable interrupts by spin_unlock_bh as this
might cause deadlocks in the ppp layer.

Instead, use irqsave/irqrestore spin_lock functions.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/tty/moxa.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/moxa.c b/drivers/tty/moxa.c
index a290e9e..6255561 100644
--- a/drivers/tty/moxa.c
+++ b/drivers/tty/moxa.c
@@ -1202,14 +1202,15 @@ static int moxa_write(struct tty_struct *tty,
 		      const unsigned char *buf, int count)
 {
 	struct moxa_port *ch = tty->driver_data;
+	unsigned long flags;
 	int len;
 
 	if (ch == NULL)
 		return 0;
 
-	spin_lock_bh(&moxa_lock);
+	spin_lock_irqsave(&moxa_lock, flags);
 	len = MoxaPortWriteData(tty, buf, count);
-	spin_unlock_bh(&moxa_lock);
+	spin_unlock_irqrestore(&moxa_lock, flags);
 
 	set_bit(LOWWAIT, &ch->statusflags);
 	return len;
-- 
1.7.4.2


