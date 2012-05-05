Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598Ab2EEUtT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 16:49:19 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:57230 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245Ab2EEUtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 16:49:18 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: gmsof@tuxicoman.be, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>
Subject: [PATCH 1/1] TTY: pdc_cons, fix regression in close
Date: Sat,  5 May 2012 22:49:10 +0200
Message-Id: <1336250950-24645-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <Pine.LNX.4.64.1205051443520.2623@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1205051443520.2623@file.rdu.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The test in pdc_console_tty_close '!tty->count' was always wrong
because tty->count is decremented after tty->ops->close is called and
thus can never be zero. Hence the 'then' branch was never executed and
the timer never deleted.

This did not matter until 5dd5bc40f3b6e0ccdaad948dbadc94ad0906cb25
(TTY: pdc_cons, use tty_port). There we needed to set TTY in tty_port
to NULL, but this never happened due to the bug above.

So change the test to really trigger at the last close by changing the
condition to 'tty->count == 1'.

Well, the driver should not touch tty->count at all. It should use
tty_port->count and count open count there itself.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Reported-and-tested-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
---
 arch/parisc/kernel/pdc_cons.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/parisc/kernel/pdc_cons.c b/arch/parisc/kernel/pdc_cons.c
index 4f00459..0b33933 100644
--- a/arch/parisc/kernel/pdc_cons.c
+++ b/arch/parisc/kernel/pdc_cons.c
@@ -104,7 +104,7 @@ static int pdc_console_tty_open(struct tty_struct *tty, struct file *filp)
 
 static void pdc_console_tty_close(struct tty_struct *tty, struct file *filp)
 {
-	if (!tty->count) {
+	if (tty->count == 1) {
 		del_timer_sync(&pdc_console_timer);
 		tty_port_tty_set(&tty_port, NULL);
 	}
-- 
1.7.9.2


