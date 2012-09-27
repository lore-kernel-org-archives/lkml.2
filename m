Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab2I0OFM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 10:05:12 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:41179 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab2I0OFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 10:05:07 -0400
Date: Thu, 27 Sep 2012 18:05:02 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Emelyanov <xemul@parallels.com>,
        Jiri Slaby <jslaby@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [RFC] tty: Add get- ioctls to fetch tty status
Message-ID: <20120927140502.GB12552@moon>
References: <20120913125401.GK19956@moon>
 <20120913172507.5039e3c6@pyramind.ukuu.org.uk>
 <20120922180639.GC11610@moon>
 <20120922200731.GD14004@kroah.com>
 <20120922201144.GD11610@moon>
 <20120922215232.GA25778@moon>
 <20120923010953.GA17663@kroah.com>
 <20120923064007.GA2994@moon>
 <34f6ba7b-2c50-492e-9267-52d328a8d37f@email.android.com>
 <20120924141441.GD16532@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120924141441.GD16532@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 06:14:41PM +0400, Cyrill Gorcunov wrote:
> 
> As to Alan's point on "what's the use of this if it can instantly change
> after you read the value" I guess it's the same as what we have when we
> simply set the value. Imagine we have two tasks fork'ed, first task do
> lock the pty while another task does unlock it immediately after that,
> as far as I see there is nothing preventing user space to do that, thus
> first task will think it has locked the peer while in real the peer remains
> unlocked. Same here with reading this value -- it's valid once read but
> can be changed right after. Isn't it?

Alan, Greg, what's opinion? This flags fetching is the same as say fetching
of termios settings, once fetched they can be changed immediately, and it's
up to caller what to do with termios settings. No?
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: tty: Add get- ioctls to fetch tty status

For checkpoint/restore we need to know if tty has
exclusive or packet mode set, as well as if pty
is currently locked. Just to be able to restore
this characteristics.

For this sake the following ioctl codes are introduced

 - TIOCGPKT to get packet mode state
 - TIOCGPTLCK to get Pty locked state
 - TIOCGEXCL to get Exclusive mode state

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 drivers/tty/pty.c            |   12 ++++++++++++
 drivers/tty/tty_io.c         |    7 +++++++
 drivers/tty/tty_ioctl.c      |   16 ++++++++++++++++
 fs/compat_ioctl.c            |    3 +++
 include/asm-generic/ioctls.h |    3 +++
 5 files changed, 41 insertions(+)

Index: tty.git/drivers/tty/pty.c
===================================================================
--- tty.git.orig/drivers/tty/pty.c
+++ tty.git/drivers/tty/pty.c
@@ -174,6 +174,14 @@ static int pty_set_lock(struct tty_struc
 	return 0;
 }
 
+static int pty_get_lock(struct tty_struct *tty, int __user *arg)
+{
+	int locked = test_bit(TTY_PTY_LOCK, &tty->flags);
+	if (put_user(locked, arg))
+		return -EFAULT;
+	return 0;
+}
+
 /* Send a signal to the slave */
 static int pty_signal(struct tty_struct *tty, int sig)
 {
@@ -393,6 +401,8 @@ static int pty_bsd_ioctl(struct tty_stru
 	switch (cmd) {
 	case TIOCSPTLCK: /* Set PT Lock (disallow slave open) */
 		return pty_set_lock(tty, (int __user *) arg);
+	case TIOCGPTLCK:
+		return pty_get_lock(tty, (int __user *) arg);
 	case TIOCSIG:    /* Send signal to other side of pty */
 		return pty_signal(tty, (int) arg);
 	}
@@ -507,6 +517,8 @@ static int pty_unix98_ioctl(struct tty_s
 	switch (cmd) {
 	case TIOCSPTLCK: /* Set PT Lock (disallow slave open) */
 		return pty_set_lock(tty, (int __user *)arg);
+	case TIOCGPTLCK:
+		return pty_get_lock(tty, (int __user *) arg);
 	case TIOCGPTN: /* Get PT Number */
 		return put_user(tty->index, (unsigned int __user *)arg);
 	case TIOCSIG:    /* Send signal to other side of pty */
Index: tty.git/drivers/tty/tty_io.c
===================================================================
--- tty.git.orig/drivers/tty/tty_io.c
+++ tty.git/drivers/tty/tty_io.c
@@ -2693,6 +2693,13 @@ long tty_ioctl(struct file *file, unsign
 	case TIOCNXCL:
 		clear_bit(TTY_EXCLUSIVE, &tty->flags);
 		return 0;
+	case TIOCGEXCL:
+	{
+		int excl = test_bit(TTY_EXCLUSIVE, &tty->flags);
+		if (put_user(excl, (int __user *)p))
+			return -EFAULT;
+		return 0;
+	}
 	case TIOCNOTTY:
 		if (current->signal->tty != tty)
 			return -ENOTTY;
Index: tty.git/drivers/tty/tty_ioctl.c
===================================================================
--- tty.git.orig/drivers/tty/tty_ioctl.c
+++ tty.git/drivers/tty/tty_ioctl.c
@@ -1173,6 +1173,22 @@ int n_tty_ioctl_helper(struct tty_struct
 		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 		return 0;
 	}
+	case TIOCGPKT:
+	{
+		int pktmode;
+
+		if (tty->driver->type != TTY_DRIVER_TYPE_PTY ||
+		    tty->driver->subtype != PTY_TYPE_MASTER)
+			return -ENOTTY;
+
+		spin_lock_irqsave(&tty->ctrl_lock, flags);
+		pktmode = tty->packet;
+		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+
+		if (put_user(pktmode, (int __user *) arg))
+			return -EFAULT;
+		return 0;
+	}
 	default:
 		/* Try the mode commands */
 		return tty_mode_ioctl(tty, file, cmd, arg);
Index: tty.git/fs/compat_ioctl.c
===================================================================
--- tty.git.orig/fs/compat_ioctl.c
+++ tty.git/fs/compat_ioctl.c
@@ -842,6 +842,9 @@ COMPATIBLE_IOCTL(TIOCGDEV)
 COMPATIBLE_IOCTL(TIOCCBRK)
 COMPATIBLE_IOCTL(TIOCGSID)
 COMPATIBLE_IOCTL(TIOCGICOUNT)
+COMPATIBLE_IOCTL(TIOCGPKT)
+COMPATIBLE_IOCTL(TIOCGPTLCK)
+COMPATIBLE_IOCTL(TIOCGEXCL)
 /* Little t */
 COMPATIBLE_IOCTL(TIOCGETD)
 COMPATIBLE_IOCTL(TIOCSETD)
Index: tty.git/include/asm-generic/ioctls.h
===================================================================
--- tty.git.orig/include/asm-generic/ioctls.h
+++ tty.git/include/asm-generic/ioctls.h
@@ -74,6 +74,9 @@
 #define TCSETXW		0x5435
 #define TIOCSIG		_IOW('T', 0x36, int)  /* pty: generate signal */
 #define TIOCVHANGUP	0x5437
+#define TIOCGPKT	_IOR('T', 0x38, int) /* Get packet mode state */
+#define TIOCGPTLCK	_IOR('T', 0x39, int) /* Get Pty lock state */
+#define TIOCGEXCL	_IOR('T', 0x40, int) /* Get exclusive mode state */
 
 #define FIONCLEX	0x5450
 #define FIOCLEX		0x5451
