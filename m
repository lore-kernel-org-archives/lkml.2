Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab2EPPbF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 11:31:05 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:47162 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686Ab2EPPbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 11:31:00 -0400
Date: Wed, 16 May 2012 16:33:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Preston Fick <pffick@gmail.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        preston.fick@silabs.com,
        "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>
Subject: Re: [PATCH] usb: cp210x: Added support for GPIO (CP2103/4/5)
Message-ID: <20120516163347.1721406e@pyramind.ukuu.org.uk>
In-Reply-To: <20120505003208.GA30718@kroah.com>
References: <1335817637-2862-1-git-send-email-preston.fick@silabs.com>
	<20120503213456.77c55c51@pyramind.ukuu.org.uk>
	<20120505003208.GA30718@kroah.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So the patch looks like this, which seems nice and compact (UNTESTED)

commit 4164f9b7074e682fe71dad3b57e78521ef9df492
Author: Alan Cox <alan@linux.intel.com>
Date:   Wed May 16 15:13:02 2012 +0100

    tty: Add a gpio helper set
    
    Various tty devices have additional control lines which are sometimes used
    as GPIO pins and sometimes also tied with the serial port to implement
    protocols such as ISO7816.
    
    This code provides a kernel interface for querying the GPIO range of a tty,
    and to describe the mapping between GPIO pins and control lines. The latter
    will be needed for some upcoming line discipline support.
    
    [Proposal do not merge yet]
    
    Not-Signed-off-by: Alan Cox <alan@linux.intel.com>

diff --git a/drivers/tty/tty_ioctl.c b/drivers/tty/tty_ioctl.c
index a1b9a2f..60550e7 100644
--- a/drivers/tty/tty_ioctl.c
+++ b/drivers/tty/tty_ioctl.c
@@ -1071,6 +1071,39 @@ int tty_mode_ioctl(struct tty_struct *tty, struct file *file,
 	case TCSETXF:
 		return set_termiox(real_tty, p, TERMIOS_FLUSH);
 #endif		
+#ifdef TCGGPIO
+	case TCGGPIO: {
+		struct tcgpio gpio;
+
+		if (tty->gpio == NULL)
+			return -EOPNOTSUPP;
+		mutex_lock(&real_tty->termios_mutex);
+		memset(&gpio, 0, sizeof(gpio));
+		gpio.base = tty->gpio->base;
+		gpio.num = tty->gpio->num;
+		memcpy(gpio.map, tty->gpio->map, sizeof(gpio.map));
+		mutex_unlock(&real_tty->termios_mutex);
+		if (copy_to_user(p, &gpio, sizeof(gpio)))
+			return -EFAULT;
+		return 0;
+	}
+	case TCSGPIO:
+        {
+		struct tcgpio gpio;
+
+		if (tty->gpio == NULL)
+			return -EOPNOTSUPP;
+		if (copy_from_user(&gpio, p, sizeof(gpio)))
+			return -EFAULT;
+		mutex_lock(&real_tty->termios_mutex);
+		memcpy(tty->gpio->map, gpio.map, sizeof(tty->gpio->map));
+		/* An ldisc can see this by watching the ioctl go through
+		but we may want to add a hook */
+		mutex_unlock(&real_tty->termios_mutex);
+                return 0;
+        }
+                
+#endif
 	case TIOCGSOFTCAR:
 		copy_termios(real_tty, &kterm);
 		ret = put_user((kterm.c_cflag & CLOCAL) ? 1 : 0,
diff --git a/include/asm-generic/ioctls.h b/include/asm-generic/ioctls.h
index 199975f..fee17d3 100644
--- a/include/asm-generic/ioctls.h
+++ b/include/asm-generic/ioctls.h
@@ -74,6 +74,8 @@
 #define TCSETXW		0x5435
 #define TIOCSIG		_IOW('T', 0x36, int)  /* pty: generate signal */
 #define TIOCVHANGUP	0x5437
+#define TCGGPIO		_IOR('T', 0x38, struct tcgpio)
+#define TCSGPIO		_IOW('T', 0x39, struct tcgpio)
 
 #define FIONCLEX	0x5450
 #define FIOCLEX		0x5451
diff --git a/include/asm-generic/termios.h b/include/asm-generic/termios.h
index d0922ad..3adda38 100644
--- a/include/asm-generic/termios.h
+++ b/include/asm-generic/termios.h
@@ -18,6 +18,18 @@ struct winsize {
 	unsigned short ws_ypixel;
 };
 
+
+/* GPIO handling */
+#define NR_TTY_GPIOMAP	8
+struct tcgpio			/* User copied version */
+{
+	u32 base;
+	u16 num;
+	u16 reserved;
+	u32 map[NR_TTY_GPIOMAP];
+	u32 reserved2[6];
+};
+
 #define NCC 8
 struct termio {
 	unsigned short c_iflag;		/* input mode flags */
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 9f47ab5..19daf03 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -243,6 +243,18 @@ struct tty_port {
 };
 
 /*
+ * GPIO block, optional
+ */
+
+struct tty_kgpio		/* Kernel gpio struct */
+{
+	u32 base;
+	u16 num;
+	u16 reserved;
+	u32 map[NR_TTY_GPIOMAP];
+};
+	
+/* 
  * Where all of the state associated with a tty is kept while the tty
  * is open.  Since the termios state should be kept even if the tty
  * has been closed --- for things like the baud rate, etc --- it is
@@ -331,6 +343,8 @@ struct tty_struct {
 	/* If the tty has a pending do_SAK, queue it here - akpm */
 	struct work_struct SAK_work;
 	struct tty_port *port;
+
+	struct tty_kgpio *gpio;	/* Optional */
 };
 
 /* Each of a tty's open files has private_data pointing to tty_file_private */
