Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932550Ab2DMIbk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 04:31:40 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:53532 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130Ab2DMIbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 04:31:38 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: [PATCH 1/1] TTY: hvc, fix TTY refcounting
Date: Fri, 13 Apr 2012 10:31:32 +0200
Message-Id: <1334305892-30187-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <5050.1334304567@neuling.org>
References: <5050.1334304567@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A -next commit "TTY: HVC, use tty from tty_port" switched the driver
to use tty_port helper for tty refcounting. But it omitted to remove
manual tty refcounting from open, close and hangup. So now we are
getting random crashes caused by use-after-free:
Unable to handle kernel paging request for data at address 0xc0000003f9d550
Faulting instruction address: 0xc0000000001b7f40
Oops: Kernel access of bad area, sig: 11 [#1]
...
NIP: c0000000001b7f40 LR: c0000000001b7f14 CTR: c0000000000e04f0
...
NIP [c0000000001b7f40] .__kmalloc+0x70/0x230
LR [c0000000001b7f14] .__kmalloc+0x44/0x230
Call Trace:
[c0000003f68bf930] [c0000003f68bf9b0] 0xc0000003f68bf9b0 (unreliable)
[c0000003f68bf9e0] [c0000000001e5424] .alloc_fdmem+0x24/0x70
[c0000003f68bfa60] [c0000000001e54f8] .alloc_fdtable+0x88/0x130
[c0000003f68bfaf0] [c0000000001e5924] .dup_fd+0x384/0x450
[c0000003f68bfbd0] [c00000000009a310] .copy_process+0x880/0x11d0
[c0000003f68bfcd0] [c00000000009aee0] .do_fork+0x70/0x400
[c0000003f68bfdc0] [c0000000000141c4] .sys_clone+0x54/0x70
[c0000003f68bfe30] [c000000000009aa0] .ppc_clone+0x8/0xc

Fix that by complete removal of tty_kref_get/put in open/close/hangup
paths.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Reported-and-tested-by: Michael Neuling <mikey@neuling.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: ppc-dev <linuxppc-dev@lists.ozlabs.org>
---
 drivers/tty/hvc/hvc_console.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/tty/hvc/hvc_console.c b/drivers/tty/hvc/hvc_console.c
index 6c45cbf..2d691eb 100644
--- a/drivers/tty/hvc/hvc_console.c
+++ b/drivers/tty/hvc/hvc_console.c
@@ -317,8 +317,6 @@ static int hvc_open(struct tty_struct *tty, struct file * filp)
 	/* Check and then increment for fast path open. */
 	if (hp->port.count++ > 0) {
 		spin_unlock_irqrestore(&hp->port.lock, flags);
-		/* FIXME why taking a reference here? */
-		tty_kref_get(tty);
 		hvc_kick();
 		return 0;
 	} /* else count == 0 */
@@ -338,7 +336,6 @@ static int hvc_open(struct tty_struct *tty, struct file * filp)
 	 */
 	if (rc) {
 		tty_port_tty_set(&hp->port, NULL);
-		tty_kref_put(tty);
 		tty->driver_data = NULL;
 		tty_port_put(&hp->port);
 		printk(KERN_ERR "hvc_open: request_irq failed with rc %d.\n", rc);
@@ -393,7 +390,6 @@ static void hvc_close(struct tty_struct *tty, struct file * filp)
 		spin_unlock_irqrestore(&hp->port.lock, flags);
 	}
 
-	tty_kref_put(tty);
 	tty_port_put(&hp->port);
 }
 
@@ -433,7 +429,6 @@ static void hvc_hangup(struct tty_struct *tty)
 
 	while(temp_open_count) {
 		--temp_open_count;
-		tty_kref_put(tty);
 		tty_port_put(&hp->port);
 	}
 }
-- 
1.7.9.2


