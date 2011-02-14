Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab1BNQ5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 11:57:18 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:59844 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756037Ab1BNQ5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 11:57:14 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 5/6] tty: add a helper for setting termios data from kernel
 side
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 14 Feb 2011 16:27:53 +0000
Message-ID: <20110214162732.10571.18044.stgit@bob.linux.org.uk>
In-Reply-To: <20110214162438.10571.8203.stgit@bob.linux.org.uk>
References: <20110214162438.10571.8203.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

This basically encapsulates the small bit of locking knowledge needed. While
we are at it make sure we blow up on any more abusers and unsafe misuses of
ioctl for this kind of stuff.

We change the function to return an argument as at some point it needs to
honour the POSIX 'I asked for changes but got none of them' error reporting
corner case.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/tty/tty_ioctl.c |   14 +++++++++-----
 include/linux/tty.h     |    1 +
 2 files changed, 10 insertions(+), 5 deletions(-)


diff --git a/drivers/tty/tty_ioctl.c b/drivers/tty/tty_ioctl.c
index 0c18899..1a1135d 100644
--- a/drivers/tty/tty_ioctl.c
+++ b/drivers/tty/tty_ioctl.c
@@ -486,7 +486,7 @@ int tty_termios_hw_change(struct ktermios *a, struct ktermios *b)
 EXPORT_SYMBOL(tty_termios_hw_change);
 
 /**
- *	change_termios		-	update termios values
+ *	tty_set_termios		-	update termios values
  *	@tty: tty to update
  *	@new_termios: desired new value
  *
@@ -497,7 +497,7 @@ EXPORT_SYMBOL(tty_termios_hw_change);
  *	Locking: termios_mutex
  */
 
-static void change_termios(struct tty_struct *tty, struct ktermios *new_termios)
+int tty_set_termios(struct tty_struct *tty, struct ktermios *new_termios)
 {
 	struct ktermios old_termios;
 	struct tty_ldisc *ld;
@@ -553,7 +553,9 @@ static void change_termios(struct tty_struct *tty, struct ktermios *new_termios)
 		tty_ldisc_deref(ld);
 	}
 	mutex_unlock(&tty->termios_mutex);
+	return 0;
 }
+EXPORT_SYMBOL_GPL(tty_set_termios);
 
 /**
  *	set_termios		-	set termios values for a tty
@@ -562,7 +564,7 @@ static void change_termios(struct tty_struct *tty, struct ktermios *new_termios)
  *	@opt: option information
  *
  *	Helper function to prepare termios data and run necessary other
- *	functions before using change_termios to do the actual changes.
+ *	functions before using tty_set_termios to do the actual changes.
  *
  *	Locking:
  *		Called functions take ldisc and termios_mutex locks
@@ -620,7 +622,7 @@ static int set_termios(struct tty_struct *tty, void __user *arg, int opt)
 			return -EINTR;
 	}
 
-	change_termios(tty, &tmp_termios);
+	tty_set_termios(tty, &tmp_termios);
 
 	/* FIXME: Arguably if tmp_termios == tty->termios AND the
 	   actual requested termios was not tmp_termios then we may
@@ -797,7 +799,7 @@ static int set_sgttyb(struct tty_struct *tty, struct sgttyb __user *sgttyb)
 						termios.c_ospeed);
 #endif
 	mutex_unlock(&tty->termios_mutex);
-	change_termios(tty, &termios);
+	tty_set_termios(tty, &termios);
 	return 0;
 }
 #endif
@@ -951,6 +953,8 @@ int tty_mode_ioctl(struct tty_struct *tty, struct file *file,
 	int ret = 0;
 	struct ktermios kterm;
 
+	BUG_ON(file == NULL);
+
 	if (tty->driver->type == TTY_DRIVER_TYPE_PTY &&
 	    tty->driver->subtype == PTY_TYPE_MASTER)
 		real_tty = tty->link;
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 483df15..90bc7d6 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -448,6 +448,7 @@ extern void tty_encode_baud_rate(struct tty_struct *tty,
 						speed_t ibaud, speed_t obaud);
 extern void tty_termios_copy_hw(struct ktermios *new, struct ktermios *old);
 extern int tty_termios_hw_change(struct ktermios *a, struct ktermios *b);
+extern int tty_set_termios(struct tty_struct *tty, struct ktermios *kt);
 
 extern struct tty_ldisc *tty_ldisc_ref(struct tty_struct *);
 extern void tty_ldisc_deref(struct tty_ldisc *);

