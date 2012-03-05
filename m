Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965178Ab2CEOA4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:00:56 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34783 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964794Ab2CENxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:21 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>
Subject: [PATCH 63/68] TTY: pdc_cons, fix racy tty test
Date: Mon,  5 Mar 2012 14:52:50 +0100
Message-Id: <1330955575-26641-64-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tty->count test in the timer was racy. Let's remove the test and
properly delete the timer and wait for the body to finish using _sync
version of del_timer.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
---
 arch/parisc/kernel/pdc_cons.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/parisc/kernel/pdc_cons.c b/arch/parisc/kernel/pdc_cons.c
index fc770be..c1db65f 100644
--- a/arch/parisc/kernel/pdc_cons.c
+++ b/arch/parisc/kernel/pdc_cons.c
@@ -103,7 +103,7 @@ static int pdc_console_tty_open(struct tty_struct *tty, struct file *filp)
 static void pdc_console_tty_close(struct tty_struct *tty, struct file *filp)
 {
 	if (!tty->count)
-		del_timer(&pdc_console_timer);
+		del_timer_sync(&pdc_console_timer);
 }
 
 static int pdc_console_tty_write(struct tty_struct *tty, const unsigned char *buf, int count)
@@ -153,7 +153,7 @@ static void pdc_console_poll(unsigned long unused)
 	if (count)
 		tty_flip_buffer_push(tty);
 
-	if (tty->count && (pdc_cons.flags & CON_ENABLED))
+	if (pdc_cons.flags & CON_ENABLED)
 		mod_timer(&pdc_console_timer, jiffies + PDC_CONS_POLL_DELAY);
 }
 
-- 
1.7.9.2


