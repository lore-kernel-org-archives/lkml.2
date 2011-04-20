Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab1DTIny (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 04:43:54 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:51021 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab1DTIn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 04:43:28 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Jack Stone <jwjstone@fastmail.fm>, Alan Cox <alan@linux.intel.com>
Subject: [PATCH 3/7] Char: nozomi, remove useless tty_sem
Date: Wed, 20 Apr 2011 10:43:14 +0200
Message-Id: <1303288998-31718-3-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1303288998-31718-1-git-send-email-jslaby@suse.cz>
References: <1303288998-31718-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tty_sem used to protect tty open count. This was removed in 33dd474a
but the lock remained in place.

So remove it completely as it protects nothing now.

Also this solves Mac's problem with inatomic operation called from
atomic context (ppp):
BUG: scheduling while atomic: firefox-bin/1992/0x10000800
Modules linked in: ...
Pid: 1992, comm: firefox-bin Not tainted 2.6.38 #1
Call Trace:
...
 [] ? mutex_lock+0xe/0x21
 [] ? ntty_write+0x5d/0x192 [nozomi]
 [] ? __mod_timer.clone.30+0xbe/0xcc
 [] ? check_preempt_curr+0x60/0x6d
 [] ? __nf_ct_refresh_acct+0x75/0xbe
 [] ? ppp_async_push+0xa9/0x3bd [ppp_async]
 [] ? ppp_async_send+0x34/0x40 [ppp_async]
 [] ? ppp_push+0x6c/0x4f9 [ppp_generic]
...

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Reported-by: Mac <kmac@poczta.fm>
Tested-by: Gerald Pfeifer <gerald@pfeifer.com>
Cc: Jack Stone <jwjstone@fastmail.fm>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/tty/nozomi.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/tty/nozomi.c b/drivers/tty/nozomi.c
index c34d622..b1aecc7 100644
--- a/drivers/tty/nozomi.c
+++ b/drivers/tty/nozomi.c
@@ -364,8 +364,6 @@ struct port {
 	u8 toggle_ul;
 	u16 token_dl;
 
-	/* mutex to ensure one access patch to this port */
-	struct mutex tty_sem;
 	wait_queue_head_t tty_wait;
 	struct async_icount tty_icount;
 
@@ -1474,7 +1472,6 @@ static int __devinit nozomi_card_init(struct pci_dev *pdev,
 		struct device *tty_dev;
 		struct port *port = &dc->port[i];
 		port->dc = dc;
-		mutex_init(&port->tty_sem);
 		tty_port_init(&port->port);
 		port->port.ops = &noz_tty_port_ops;
 		tty_dev = tty_register_device(ntty_driver, dc->index_start + i,
@@ -1688,8 +1685,6 @@ static int ntty_write(struct tty_struct *tty, const unsigned char *buffer,
 	if (!dc || !port)
 		return -ENODEV;
 
-	mutex_lock(&port->tty_sem);
-
 	rval = kfifo_in(&port->fifo_ul, (unsigned char *)buffer, count);
 
 	/* notify card */
@@ -1714,7 +1709,6 @@ static int ntty_write(struct tty_struct *tty, const unsigned char *buffer,
 	spin_unlock_irqrestore(&dc->spin_mutex, flags);
 
 exit:
-	mutex_unlock(&port->tty_sem);
 	return rval;
 }
 
@@ -1733,11 +1727,9 @@ static int ntty_write_room(struct tty_struct *tty)
 	int room = 4096;
 	const struct nozomi *dc = get_dc_by_tty(tty);
 
-	if (dc) {
-		mutex_lock(&port->tty_sem);
+	if (dc)
 		room = kfifo_avail(&port->fifo_ul);
-		mutex_unlock(&port->tty_sem);
-	}
+
 	return room;
 }
 
-- 
1.7.4.2


