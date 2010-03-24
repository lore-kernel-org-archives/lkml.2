Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579Ab0CXRQu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 13:16:50 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35036 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753740Ab0CXRQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 13:16:48 -0400
Date: Wed, 24 Mar 2010 17:20:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pavan Savoy <pavan_savoy@yahoo.co.in>
Cc: Greg KH <gregkh@suse.de>, Marcel Holtmann <marcel@holtmann.org>,
       PavanSavoy <pavan_savoy@ti.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] drivers:misc: sources for Init manager module
Message-ID: <20100324172037.4894f89a@lxorguk.ukuu.org.uk>
In-Reply-To: <802911.82166.qm@web94909.mail.in2.yahoo.com>
References: <20100324165222.GA9922@suse.de>
	<802911.82166.qm@web94909.mail.in2.yahoo.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Alan's talking about opening up the LDISC installation to kernel (say EXPORTING tty_set_ldisc/tiocsetd), That's like ideal scenario in this case.

Ok I lied - its four lines of code changing, and just set

	.ldisc = N_whatever

in your tty_driver

Marcel - that should also clean up some of the other pending goodies

[Untested Patch]

--

tty: Allow the driver to force an ldisc on open

From: Alan Cox <alan@linux.intel.com>

We need this because some hardware is always in various mux or control
modes. At the moment we do handstands via userspace to sort this out on
devices where it makes no sense. Given the size of the patch to fix this
inanity we might as well do so.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/tty_ldisc.c   |    6 +++---
 include/linux/tty_driver.h |    1 +
 2 files changed, 4 insertions(+), 3 deletions(-)


diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index 500e740..b149f9c 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -863,8 +863,8 @@ void tty_ldisc_release(struct tty_struct *tty, struct tty_struct *o_tty)
 	/* Force an oops if we mess this up */
 	tty->ldisc = NULL;
 
-	/* Ensure the next open requests the N_TTY ldisc */
-	tty_set_termios_ldisc(tty, N_TTY);
+	/* Ensure the next open requests the expected (usually N_TTY) ldisc */
+	tty_set_termios_ldisc(tty, tty->driver->ldisc);
 	mutex_unlock(&tty->ldisc_mutex);
 
 	/* This will need doing differently if we need to lock */
@@ -885,7 +885,7 @@ void tty_ldisc_release(struct tty_struct *tty, struct tty_struct *o_tty)
 
 void tty_ldisc_init(struct tty_struct *tty)
 {
-	struct tty_ldisc *ld = tty_ldisc_get(N_TTY);
+	struct tty_ldisc *ld = tty_ldisc_get(tty->driver->ldisc);
 	if (IS_ERR(ld))
 		panic("n_tty: init_tty");
 	tty_ldisc_assign(tty, ld);
diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index b086779..fc22a41 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -291,6 +291,7 @@ struct tty_driver {
 	short	type;		/* type of tty driver */
 	short	subtype;	/* subtype of tty driver */
 	struct ktermios init_termios; /* Initial termios */
+	int	ldisc;		/* initial ldisc */
 	int	flags;		/* tty driver flags */
 	struct proc_dir_entry *proc_entry; /* /proc fs entry */
 	struct tty_driver *other; /* only used for the PTY driver */
