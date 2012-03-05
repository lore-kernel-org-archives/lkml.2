Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965138Ab2CEOAw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 09:00:52 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34789 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964805Ab2CENxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:22 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>
Subject: [PATCH 64/68] TTY: pdc_cons, fix open vs timer race
Date: Mon,  5 Mar 2012 14:52:51 +0100
Message-Id: <1330955575-26641-65-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The timer is initialized too late. tty->open may fire an invalid
timer. So initialize the timer earlier using DEFINE_TIMER.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
---
 arch/parisc/kernel/pdc_cons.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/parisc/kernel/pdc_cons.c b/arch/parisc/kernel/pdc_cons.c
index c1db65f..8ad0521 100644
--- a/arch/parisc/kernel/pdc_cons.c
+++ b/arch/parisc/kernel/pdc_cons.c
@@ -90,7 +90,8 @@ static int pdc_console_setup(struct console *co, char *options)
 
 #define PDC_CONS_POLL_DELAY (30 * HZ / 1000)
 
-static struct timer_list pdc_console_timer;
+static void pdc_console_poll(unsigned long unused);
+static DEFINE_TIMER(pdc_console_timer, pdc_console_poll, 0, 0);
 
 static int pdc_console_tty_open(struct tty_struct *tty, struct file *filp)
 {
@@ -205,10 +206,6 @@ static int __init pdc_console_tty_driver_init(void)
 
 	pdc_console_tty_driver = drv;
 
-	/* No need to initialize the pdc_console_timer if tty isn't allocated */
-	init_timer(&pdc_console_timer);
-	pdc_console_timer.function = pdc_console_poll;
-
 	return 0;
 }
 
-- 
1.7.9.2


