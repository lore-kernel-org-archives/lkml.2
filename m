Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab1CWJso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 05:48:44 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:54665 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249Ab1CWJsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 05:48:42 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Julian Anastasov <ja@ssi.bg>
Subject: [PATCH 4/6] TTY: introduce deinit helpers for proper ldisc shutdown
Date: Wed, 23 Mar 2011 10:48:35 +0100
Message-Id: <1300873717-27941-4-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300873717-27941-1-git-send-email-jslaby@suse.cz>
References: <1300873717-27941-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce deinitialize_tty_struct which should be called after
initialize_tty_struct and before successfull tty_ldisc_setup.

It calls tty_ldisc_deinit which is opposite of tty_ldisc_init. It only
puts a reference to ldisc and assigns NULL to tty->ldisc.

It will be used to shut down ldisc when tty_release cannot be called
yet.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Julian Anastasov <ja@ssi.bg>
---
 drivers/tty/tty_io.c    |   14 ++++++++++++++
 drivers/tty/tty_ldisc.c |   13 +++++++++++++
 include/linux/tty.h     |    2 ++
 3 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 6312cc3..a4d47fa 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2889,6 +2889,20 @@ void initialize_tty_struct(struct tty_struct *tty,
 }
 
 /**
+ *	deinitialize_tty_struct
+ *	@tty: tty to deinitialize
+ *
+ *	This subroutine deinitializes a tty structure that has been newly
+ *	allocated but tty_release cannot be called on that yet.
+ *
+ *	Locking: none - tty in question must not be exposed at this point
+ */
+void deinitialize_tty_struct(struct tty_struct *tty)
+{
+	tty_ldisc_deinit(tty);
+}
+
+/**
  *	tty_put_char	-	write one character to a tty
  *	@tty: tty
  *	@ch: character
diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 0fc564a..525a901 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -956,6 +956,19 @@ void tty_ldisc_init(struct tty_struct *tty)
 	tty_ldisc_assign(tty, ld);
 }
 
+/**
+ *	tty_ldisc_init		-	ldisc cleanup for new tty
+ *	@tty: tty that was allocated recently
+ *
+ *	The tty structure must not becompletely set up (tty_ldisc_setup) when
+ *      this call is made.
+ */
+void tty_ldisc_deinit(struct tty_struct *tty)
+{
+	put_ldisc(tty->ldisc);
+	tty_ldisc_assign(tty, NULL);
+}
+
 void tty_ldisc_begin(void)
 {
 	/* Setup the default TTY line discipline. */
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 4e53d46..a39e2b1 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -472,6 +472,7 @@ extern int tty_add_file(struct tty_struct *tty, struct file *file);
 extern void free_tty_struct(struct tty_struct *tty);
 extern void initialize_tty_struct(struct tty_struct *tty,
 		struct tty_driver *driver, int idx);
+extern void deinitialize_tty_struct(struct tty_struct *tty);
 extern struct tty_struct *tty_init_dev(struct tty_driver *driver, int idx,
 								int first_ok);
 extern int tty_release(struct inode *inode, struct file *filp);
@@ -525,6 +526,7 @@ extern int tty_set_ldisc(struct tty_struct *tty, int ldisc);
 extern int tty_ldisc_setup(struct tty_struct *tty, struct tty_struct *o_tty);
 extern void tty_ldisc_release(struct tty_struct *tty, struct tty_struct *o_tty);
 extern void tty_ldisc_init(struct tty_struct *tty);
+extern void tty_ldisc_deinit(struct tty_struct *tty);
 extern void tty_ldisc_begin(void);
 /* This last one is just for the tty layer internals and shouldn't be used elsewhere */
 extern void tty_ldisc_enable(struct tty_struct *tty);
-- 
1.7.4.1


