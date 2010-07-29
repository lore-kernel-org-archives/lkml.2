Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab0G2Jql (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 05:46:41 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:50442 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab0G2Jqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 05:46:38 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@linux.intel.com>
Subject: [PATCH 1/1] Char: nozomi, set tty->driver_data appropriately
Date: Thu, 29 Jul 2010 11:46:32 +0200
Message-Id: <1280396792-32060-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.2
In-Reply-To: <1280394587-31670-1-git-send-email-jslaby@suse.cz>
References: <1280394587-31670-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, one more fix, this one depends on the other, so this is rather 2/2.
--

tty->driver_data is used all over the code, but never set. This
results in oopses like:
BUG: unable to handle kernel NULL pointer dereference at 0000000000000130
IP: [<ffffffff814a0040>] mutex_lock+0x10/0x40
...
Pid: 2157, comm: modem-manager Not tainted 2.6.34.1-0.1-desktop #1 2768DR7/2768DR7
RIP: 0010:[<ffffffff814a0040>]  [<ffffffff814a0040>] mutex_lock+0x10/0x40
RSP: 0018:ffff88007b16fa50  EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000130 RCX: 0000000000000003
RDX: 0000000000000003 RSI: 0000000000000286 RDI: 0000000000000130
RBP: 0000000000001000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000130
R13: 0000000000000001 R14: 0000000000000000 R15: ffff88007b16feb4
...
Call Trace:
 [<ffffffffa077690d>] ntty_write_room+0x4d/0x90 [nozomi]
...

Set tty->driver_data to the computed port in .install to not recompute it in
every place where needed. Switch .open to use driver_data too.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@linux.intel.com>
---
 drivers/char/nozomi.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/char/nozomi.c b/drivers/char/nozomi.c
index 7f9b858..817169c 100644
--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -1612,6 +1612,7 @@ static int ntty_install(struct tty_driver *driver, struct tty_struct *tty)
 	if (ret == 0) {
 		tty_driver_kref_get(driver);
 		tty->count++;
+		tty->driver_data = port;
 		driver->ttys[tty->index] = tty;
 	}
 	return ret;
@@ -1640,7 +1641,7 @@ static int ntty_activate(struct tty_port *tport, struct tty_struct *tty)
 
 static int ntty_open(struct tty_struct *tty, struct file *filp)
 {
-	struct port *port = get_port_by_tty(tty);
+	struct port *port = tty->driver_data;
 	return tty_port_open(&port->port, tty, filp);
 }
 
-- 
1.7.2


