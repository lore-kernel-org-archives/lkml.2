Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026Ab1CWJso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 05:48:44 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:54664 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab1CWJsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 05:48:42 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Julian Anastasov <ja@ssi.bg>
Subject: [PATCH 1/6] TTY: unify tty_init_dev fail path handling
Date: Wed, 23 Mar 2011 10:48:32 +0100
Message-Id: <1300873717-27941-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change it so that we call the deinit functions at one place at the end
of the function (by gotos). And while at it use some sane label names.

This is a preparation for the deinitialization of tty in the next
patch.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Julian Anastasov <ja@ssi.bg>
---

This is not tested yet, I'm building a kernel to test it a bit, but it
will take some time. If you could too to check if your problem
dissapears, it would be great.

P.S. the drivers/char/tty_<TAB><TAB> habit sucks :).
                 ^^^^

 drivers/tty/tty_io.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 936a4ea..6312cc3 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1391,16 +1391,15 @@ struct tty_struct *tty_init_dev(struct tty_driver *driver, int idx,
 		return ERR_PTR(-ENODEV);
 
 	tty = alloc_tty_struct();
-	if (!tty)
-		goto fail_no_mem;
+	if (!tty) {
+		retval = -ENOMEM;
+		goto err_module_put;
+	}
 	initialize_tty_struct(tty, driver, idx);
 
 	retval = tty_driver_install_tty(driver, tty);
-	if (retval < 0) {
-		free_tty_struct(tty);
-		module_put(driver->owner);
-		return ERR_PTR(retval);
-	}
+	if (retval < 0)
+		goto err_free_tty;
 
 	/*
 	 * Structures all installed ... call the ldisc open routines.
@@ -1409,15 +1408,17 @@ struct tty_struct *tty_init_dev(struct tty_driver *driver, int idx,
 	 */
 	retval = tty_ldisc_setup(tty, tty->link);
 	if (retval)
-		goto release_mem_out;
+		goto err_release_tty;
 	return tty;
 
-fail_no_mem:
+err_free_tty:
+	free_tty_struct(tty);
+err_module_put:
 	module_put(driver->owner);
-	return ERR_PTR(-ENOMEM);
+	return ERR_PTR(retval);
 
 	/* call the tty release_tty routine to clean out this slot */
-release_mem_out:
+err_release_tty:
 	if (printk_ratelimit())
 		printk(KERN_INFO "tty_init_dev: ldisc open failed, "
 				 "clearing slot %d\n", idx);
-- 
1.7.4.1


