Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab2I0PrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 11:47:19 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34102 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755242Ab2I0PrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 11:47:15 -0400
Date: Thu, 27 Sep 2012 19:47:09 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC] tty: Add get- ioctls to fetch tty status
Message-ID: <20120927154709.GC12552@moon>
References: <20120923010953.GA17663@kroah.com>
 <20120923064007.GA2994@moon>
 <34f6ba7b-2c50-492e-9267-52d328a8d37f@email.android.com>
 <20120924141441.GD16532@moon>
 <20120927140502.GB12552@moon>
 <20120927151447.2460ce44@pyramind.ukuu.org.uk>
 <20120927141425.GG6618@moon>
 <5064600D.1090506@zytor.com>
 <20120927142149.GH6618@moon>
 <20120927161312.1eadd5d6@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120927161312.1eadd5d6@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 27, 2012 at 04:13:12PM +0100, Alan Cox wrote:
> > Well, sure inside our tool before doing checkpoint we stop all
> > tasks which are part of dumpee process tree. This unfortunatly
> > doesn't apply to these ioctl calls. Peter, any idea how to deal
> > with that?
> 
> I suspect you can't deal with that. Which isn't to say you can't still
> build something useful. The query interfaces are trivial enough and
> beyond that it's simply a case of documenting that they are not intended
> to be generically "safe" but provide a spot sample.
> 
> Otherwise - TICOGPKT is specific to pty devices. Please therefore put it
> in the pty.c code and note that not all platforms use asm-geneic TTY
> ioctls so check carefully they all build.

Alan, I've moved the TICOGPKT to pty code but where to puts information
about unsafety of the data obtained? Also I fear I can test the build
results and run-time behaviour on x86 machine only, which I own (well,
couple of them). Though I defined this ioctls the same way as existing
ioctl codes are defined so I think all should build the same.
---
From: Cyrill Gorcunov <gorcunov@openvz.org>
Subject: tty: Add get- ioctls to fetch tty status v2

For checkpoint/restore we need to know if tty has
exclusive or packet mode set, as well as if pty
is currently locked. Just to be able to restore
this characteristics.

For this sake the following ioctl codes are introduced

 - TIOCGPKT to get packet mode state
 - TIOCGPTLCK to get Pty locked state
 - TIOCGEXCL to get Exclusive mode state

v2:
 - Use TIOC prefix for ioctl codes (by jslaby@)
 - Move TIOCGPKT to pty code (by alan@)

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 drivers/tty/pty.c            |   34 ++++++++++++++++++++++++++++++++++
 drivers/tty/tty_io.c         |    7 +++++++
 fs/compat_ioctl.c            |    3 +++
 include/asm-generic/ioctls.h |    3 +++
 4 files changed, 47 insertions(+)

Index: tty.git/drivers/tty/pty.c
===================================================================
--- tty.git.orig/drivers/tty/pty.c
+++ tty.git/drivers/tty/pty.c
@@ -174,6 +174,32 @@ static int pty_set_lock(struct tty_struc
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
+static int pty_get_pktmode(struct tty_struct *tty, int __user *arg)
+{
+	unsigned long flags;
+	int pktmode;
+
+	if (tty->driver->subtype != PTY_TYPE_MASTER)
+		return -ENOTTY;
+
+	spin_lock_irqsave(&tty->ctrl_lock, flags);
+	pktmode = tty->packet;
+	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+
+	if (put_user(pktmode, arg))
+		return -EFAULT;
+
+	return 0;
+}
+
 /* Send a signal to the slave */
 static int pty_signal(struct tty_struct *tty, int sig)
 {
@@ -393,8 +419,12 @@ static int pty_bsd_ioctl(struct tty_stru
 	switch (cmd) {
 	case TIOCSPTLCK: /* Set PT Lock (disallow slave open) */
 		return pty_set_lock(tty, (int __user *) arg);
+	case TIOCGPTLCK: /* Get PT Lock status */
+		return pty_get_lock(tty, (int __user *)arg);
 	case TIOCSIG:    /* Send signal to other side of pty */
 		return pty_signal(tty, (int) arg);
+	case TIOCGPKT: /* Get PT packet mode status */
+		return pty_get_pktmode(tty, (int __user *)arg);
 	}
 	return -ENOIOCTLCMD;
 }
@@ -507,10 +537,14 @@ static int pty_unix98_ioctl(struct tty_s
 	switch (cmd) {
 	case TIOCSPTLCK: /* Set PT Lock (disallow slave open) */
 		return pty_set_lock(tty, (int __user *)arg);
+	case TIOCGPTLCK: /* Get PT Lock status */
+		return pty_get_lock(tty, (int __user *)arg);
 	case TIOCGPTN: /* Get PT Number */
 		return put_user(tty->index, (unsigned int __user *)arg);
 	case TIOCSIG:    /* Send signal to other side of pty */
 		return pty_signal(tty, (int) arg);
+	case TIOCGPKT: /* Get PT packet mode status */
+		return pty_get_pktmode(tty, (int __user *)arg);
 	}
 
 	return -ENOIOCTLCMD;
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
