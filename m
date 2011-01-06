Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab1AFW3h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:29:37 -0500
Received: from kroah.org ([198.145.64.141]:55644 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754469Ab1AFWXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 17:23:42 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jiri Slaby <jslaby@suse.cz>, Helge Deller <deller@gmx.de>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        linux-parisc@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 12/36] parisc: cleanup console handling
Date: Thu,  6 Jan 2011 14:23:01 -0800
Message-Id: <1294352605-31906-12-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <20110106215404.GA30624@kroah.com>
References: <20110106215404.GA30624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

* use newly added for_each_console for iterating consoles
* add proper console locking
* do not initialize tmp twice
* no need to declare console_drivers, it's already done in console.h

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Acked-by: Kyle McMartin <kyle@mcmartin.ca>
Cc: Helge Deller <deller@gmx.de>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: linux-parisc@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.7.3.2

