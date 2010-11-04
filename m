Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab0KDPV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 11:21:27 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:33070 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab0KDPVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 11:21:13 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: werner@suse.de, alan@lxorguk.ukuu.org.uk, gregkh@suse.de,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Kyle McMartin <kyle@mcmartin.ca>, Helge Deller <deller@gmx.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        linux-parisc@vger.kernel.org
Subject: [PATCH v2 2/5] parisc: cleanup console handling
Date: Thu,  4 Nov 2010 16:20:21 +0100
Message-Id: <1288884024-23873-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1288884024-23873-1-git-send-email-jslaby@suse.cz>
References: <1288884024-23873-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* use newly added for_each_console for iterating consoles
* add proper console locking
* do not initialize tmp twice
* no need to declare console_drivers, it's already done in console.h

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: linux-parisc@vger.kernel.org
---
 arch/parisc/kernel/pdc_cons.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/parisc/kernel/pdc_cons.c b/arch/parisc/kernel/pdc_cons.c
index 66d1f17..11bdd68 100644
--- a/arch/parisc/kernel/pdc_cons.c
+++ b/arch/parisc/kernel/pdc_cons.c
@@ -92,8 +92,6 @@ static int pdc_console_setup(struct console *co, char *options)
 
 static struct timer_list pdc_console_timer;
 
-extern struct console * console_drivers;
-
 static int pdc_console_tty_open(struct tty_struct *tty, struct file *filp)
 {
 
@@ -169,11 +167,13 @@ static int __init pdc_console_tty_driver_init(void)
 	 * It is unregistered if the pdc console was not selected as the
 	 * primary console. */
 
-	struct console *tmp = console_drivers;
+	struct console *tmp;
 
-	for (tmp = console_drivers; tmp; tmp = tmp->next)
+	acquire_console_sem();
+	for_each_console(tmp)
 		if (tmp == &pdc_cons)
 			break;
+	release_console_sem();
 
 	if (!tmp) {
 		printk(KERN_INFO "PDC console driver not registered anymore, not creating %s\n", pdc_cons.name);
-- 
1.7.3.1


