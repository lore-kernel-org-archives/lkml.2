Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758296Ab0FOTC2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 15:02:28 -0400
Received: from lirone.symas.net ([64.71.152.235]:32998 "EHLO lirone.symas.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754779Ab0FOTC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 15:02:26 -0400
Date: Tue, 15 Jun 2010 11:56:08 -0700
Message-Id: <E1OObIu-0004K2-3K@lirone.symas.net>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] tty: Add EXTPROC support for LINEMODE
Cc: <alan@lxorguk.ukuu.org.uk>, <greg@kroah.com>, Alan@symas.com,
       Cox@symas.com, Greg@symas.com, KH@symas.com
From: hyc@symas.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is against the 2.6.34 source.

Paraphrased from the 1989 BSD patch by David Borman @ cray.com:

     These are the changes needed for the kernel to support
     LINEMODE in the server.

     There is a new bit in the termios local flag word, EXTPROC.
     When this bit is set, several aspects of the terminal driver
     are disabled.  Input line editing, character echo, and mapping
     of signals are all disabled.  This allows the telnetd to turn
     off these functions when in linemode, but still keep track of
     what state the user wants the terminal to be in.

     New ioctl:
         TIOCSIG         Generate a signal to processes in the
                         current process group of the pty.

     There is a new mode for packet driver, the TIOCPKT_IOCTL bit.
     When packet mode is turned on in the pty, and the EXTPROC bit
     is set, then whenever the state of the pty is changed, the
     next read on the master side of the pty will have the TIOCPKT_IOCTL
     bit set, and the data will be the contents of a struct termios.
     This allows the process on the server side of the pty to know
     when the state of the terminal has changed, and what the new
     state is.

Since the original BSD patches accompanied the source code for telnet I've 
left that reference here, but obviously the feature is useful for any remote 
terminal protocol, including ssh.

The corresponding feature has existed in the BSD tty driver since 1989. For 
historical reference, a good copy of the relevant files can be found here:

http://anonsvn.mit.edu/viewvc/krb5/trunk/src/appl/telnet/?pathrev=17741

Signed-off-by: Howard Chu <hyc@symas.com>

---
 arch/alpha/include/asm/ioctls.h     |    2 ++
 arch/alpha/include/asm/termbits.h   |    1 +
 arch/arm/include/asm/ioctls.h       |    2 ++
 arch/arm/include/asm/termbits.h     |    1 +
 arch/avr32/include/asm/ioctls.h     |    2 ++
 arch/avr32/include/asm/termbits.h   |    1 +
 arch/cris/include/asm/ioctls.h      |    2 ++
 arch/cris/include/asm/termbits.h    |    1 +
 arch/frv/include/asm/ioctls.h       |    2 ++
 arch/frv/include/asm/termbits.h     |    1 +
 arch/h8300/include/asm/ioctls.h     |    2 ++
 arch/h8300/include/asm/termbits.h   |    1 +
 arch/ia64/include/asm/ioctls.h      |    2 ++
 arch/ia64/include/asm/termbits.h    |    1 +
 arch/m32r/include/asm/ioctls.h      |    2 ++
 arch/m32r/include/asm/termbits.h    |    1 +
 arch/m68k/include/asm/ioctls.h      |    2 ++
 arch/m68k/include/asm/termbits.h    |    1 +
 arch/mips/include/asm/ioctls.h      |    3 ++-
 arch/mips/include/asm/termbits.h    |    1 +
 arch/mn10300/include/asm/ioctls.h   |    2 ++
 arch/mn10300/include/asm/termbits.h |    1 +
 arch/parisc/include/asm/ioctls.h    |    2 ++
 arch/parisc/include/asm/termbits.h  |    1 +
 arch/powerpc/include/asm/ioctls.h   |    2 ++
 arch/powerpc/include/asm/termbits.h |    1 +
 arch/s390/include/asm/ioctls.h      |    2 ++
 arch/sh/include/asm/ioctls.h        |    2 ++
 arch/sparc/include/asm/ioctls.h     |    2 ++
 arch/sparc/include/asm/termbits.h   |    1 +
 arch/xtensa/include/asm/ioctls.h    |    2 ++
 arch/xtensa/include/asm/termbits.h  |    1 +
 drivers/char/n_tty.c                |   25 ++++++++++++++++++++++---
 drivers/char/pty.c                  |   13 +++++++++++++
 drivers/char/tty_ioctl.c            |   18 ++++++++++++------
 fs/compat_ioctl.c                   |    1 +
 include/asm-generic/ioctls.h        |    2 ++
 include/asm-generic/termbits.h      |    1 +
 include/linux/tty.h                 |    1 +
 39 files changed, 101 insertions(+), 10 deletions(-)

diff --git a/arch/alpha/include/asm/ioctls.h b/arch/alpha/include/asm/ioctls.h
index 67bb9f6..8af5ee5 100644
--- a/arch/alpha/include/asm/ioctls.h
+++ b/arch/alpha/include/asm/ioctls.h
@@ -80,6 +80,7 @@
 # define TIOCPKT_START		 8
 # define TIOCPKT_NOSTOP		16
 # define TIOCPKT_DOSTOP		32
+# define TIOCPKT_IOCTL		64
 
 
 #define TIOCNOTTY	0x5422
@@ -91,6 +92,7 @@
 #define TIOCGSID	0x5429  /* Return the session ID of FD */
 #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
+#define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */
 
 #define TIOCSERCONFIG	0x5453
 #define TIOCSERGWILD	0x5454
diff --git a/arch/alpha/include/asm/termbits.h b/arch/alpha/include/asm/termbits.h
index ad854a4..879dd35 100644
--- a/arch/alpha/include/asm/termbits.h
+++ b/arch/alpha/include/asm/termbits.h
@@ -180,6 +180,7 @@ struct ktermios {
 #define FLUSHO	0x00800000
 #define PENDIN	0x20000000
 #define IEXTEN	0x00000400
+#define EXTPROC	0x10000000
 
 /* Values for the ACTION argument to `tcflow'.  */
 #define	TCOOFF		0
diff --git a/arch/arm/include/asm/ioctls.h b/arch/arm/include/asm/ioctls.h
index a91d8a1..e5e22cf 100644
--- a/arch/arm/include/asm/ioctls.h
+++ b/arch/arm/include/asm/ioctls.h
@@ -52,6 +52,7 @@
 #define TCSETSF2	_IOW('T',0x2D, struct termios2)
 #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
+#define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */
 
 #define FIONCLEX	0x5450  /* these numbers need to be adjusted. */
 #define FIOCLEX		0x5451
@@ -78,6 +79,7 @@
 #define TIOCPKT_START		 8
 #define TIOCPKT_NOSTOP		16
 #define TIOCPKT_DOSTOP		32
+#define TIOCPKT_IOCTL		64
 
 #define TIOCSER_TEMT	0x01	/* Transmitter physically empty */
 
diff --git a/arch/arm/include/asm/termbits.h b/arch/arm/include/asm/termbits.h
index f784d11..704135d 100644
--- a/arch/arm/include/asm/termbits.h
+++ b/arch/arm/include/asm/termbits.h
@@ -177,6 +177,7 @@ struct ktermios {
 #define FLUSHO	0010000
 #define PENDIN	0040000
 #define IEXTEN	0100000
+#define EXTPROC	0200000
 
 /* tcflow() and TCXONC use these */
 #define	TCOOFF		0
diff --git a/arch/avr32/include/asm/ioctls.h b/arch/avr32/include/asm/ioctls.h
index 0cf2c0a..f947622 100644
--- a/arch/avr32/include/asm/ioctls.h
+++ b/arch/avr32/include/asm/ioctls.h
@@ -53,6 +53,7 @@
 #define TCSETSF2	_IOW('T',0x2D, struct termios2)
 #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
+#define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */
 
 #define FIONCLEX	0x5450
 #define FIOCLEX		0x5451
@@ -81,6 +82,7 @@
 #define TIOCPKT_START		 8
 #define TIOCPKT_NOSTOP		16
 #define TIOCPKT_DOSTOP		32
+#define TIOCPKT_IOCTL		64
 
 #define TIOCSER_TEMT    0x01	/* Transmitter physically empty */
 
diff --git a/arch/avr32/include/asm/termbits.h b/arch/avr32/include/asm/termbits.h
index db2daab..366adc5 100644
--- a/arch/avr32/include/asm/termbits.h
+++ b/arch/avr32/include/asm/termbits.h
@@ -175,6 +175,7 @@ struct ktermios {
 #define FLUSHO	0010000
 #define PENDIN	0040000
 #define IEXTEN	0100000
+#define EXTPROC	0200000
 
 /* tcflow() and TCXONC use these */
 #define	TCOOFF		0
diff --git a/arch/cris/include/asm/ioctls.h b/arch/cris/include/asm/ioctls.h
index 35bbc18..2569665 100644
--- a/arch/cris/include/asm/ioctls.h
+++ b/arch/cris/include/asm/ioctls.h
@@ -54,6 +54,7 @@
 #define TCSETSF2	_IOW('T',0x2D, struct termios2)
 #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
+#define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */
 
 #define FIONCLEX	0x5450  /* these numbers need to be adjusted. */
 #define FIOCLEX		0x5451
@@ -86,6 +87,7 @@
 #define TIOCPKT_START		 8
 #define TIOCPKT_NOSTOP		16
 #define TIOCPKT_DOSTOP		32
+#define TIOCPKT_IOCTL		64
 
 #define TIOCSER_TEMT    0x01	/* Transmitter physically empty */
 
diff --git a/arch/cris/include/asm/termbits.h b/arch/cris/include/asm/termbits.h
index 66e1a74..1c43bc8 100644
--- a/arch/cris/include/asm/termbits.h
+++ b/arch/cris/include/asm/termbits.h
@@ -214,6 +214,7 @@ struct ktermios {
 #define FLUSHO	0010000
 #define PENDIN	0040000
 #define IEXTEN	0100000
+#define EXTPROC	0200000
 
 /* tcflow() and TCXONC use these */
 #define	TCOOFF		0
diff --git a/arch/frv/include/asm/ioctls.h b/arch/frv/include/asm/ioctls.h
index d0c30e3..a993e37 100644
--- a/arch/frv/include/asm/ioctls.h
+++ b/arch/frv/include/asm/ioctls.h
@@ -53,6 +53,7 @@
 #define TCSETSF2	_IOW('T',0x2D, struct termios2)
 #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
+#define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */
 
 #define FIONCLEX	0x5450  /* these numbers need to be adjusted. */
 #define FIOCLEX		0x5451
@@ -79,6 +80,7 @@
 #define TIOCPKT_START		 8
 #define TIOCPKT_NOSTOP		16
 #define TIOCPKT_DOSTOP		32
+#define TIOCPKT_IOCTL		64
 
 #define TIOCSER_TEMT    0x01	/* Transmitter physically empty */
 
diff --git a/arch/frv/include/asm/termbits.h b/arch/frv/include/asm/termbits.h
index 5568492..7722e19 100644
--- a/arch/frv/include/asm/termbits.h
+++ b/arch/frv/include/asm/termbits.h
@@ -180,6 +180,7 @@ struct ktermios {
 #define FLUSHO	0010000
 #define PENDIN	0040000
 #define IEXTEN	0100000
+#define EXTPROC	0200000
 
 
 /* tcflow() and TCXONC use these */
diff --git a/arch/h8300/include/asm/ioctls.h b/arch/h8300/include/asm/ioctls.h
index 98a53d0..b6b249f 100644
--- a/arch/h8300/include/asm/ioctls.h
+++ b/arch/h8300/include/asm/ioctls.h
@@ -53,6 +53,7 @@
 #define TCSETSF2	_IOW('T',0x2D, struct termios2)
 #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
+#define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */
 
 #define FIONCLEX	0x5450  /* these numbers need to be adjusted. */
 #define FIOCLEX		0x5451
@@ -79,6 +80,7 @@
 #define TIOCPKT_START		 8
 #define TIOCPKT_NOSTOP		16
 #define TIOCPKT_DOSTOP		32
+#define TIOCPKT_IOCTL		64
 
 #define TIOCSER_TEMT    0x01	/* Transmitter physically empty */
 
diff --git a/arch/h8300/include/asm/termbits.h b/arch/h8300/include/asm/termbits.h
index 31eca81..3287a62 100644
--- a/arch/h8300/include/asm/termbits.h
+++ b/arch/h8300/include/asm/termbits.h
@@ -179,6 +179,7 @@ struct ktermios {
 #define FLUSHO	0010000
 #define PENDIN	0040000
 #define IEXTEN	0100000
+#define EXTPROC	0200000
 
 
 /* tcflow() and TCXONC use these */
diff --git a/arch/ia64/include/asm/ioctls.h b/arch/ia64/include/asm/ioctls.h
index f41b636..a11af01 100644
--- a/arch/ia64/include/asm/ioctls.h
+++ b/arch/ia64/include/asm/ioctls.h
@@ -59,6 +59,7 @@
 #define TCSETSF2	_IOW('T',0x2D, struct termios2)
 #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
+#define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */
 
 #define FIONCLEX	0x5450  /* these numbers need to be adjusted. */
 #define FIOCLEX		0x5451
@@ -87,6 +88,7 @@
 #define TIOCPKT_START		 8
 #define TIOCPKT_NOSTOP		16
 #define TIOCPKT_DOSTOP		32
+#define TIOCPKT_IOCTL		64
 
 #define TIOCSER_TEMT    0x01	/* Transmitter physically empty */
 
diff --git a/arch/ia64/include/asm/termbits.h b/arch/ia64/include/asm/termbits.h
index 9f162e0..c009b94 100644
--- a/arch/ia64/include/asm/termbits.h
+++ b/arch/ia64/include/asm/termbits.h
@@ -187,6 +187,7 @@ struct ktermios {
 #define FLUSHO	0010000
 #define PENDIN	0040000
 #define IEXTEN	0100000
+#define EXTPROC	0200000
 
 /* tcflow() and TCXONC use these */
 #define	TCOOFF		0
diff --git a/arch/m32r/include/asm/ioctls.h b/arch/m32r/include/asm/ioctls.h
index b9f54bb..366db76 100644
--- a/arch/m32r/include/asm/ioctls.h
+++ b/arch/m32r/include/asm/ioctls.h
@@ -53,6 +53,7 @@
 #define TCSETSF2	_IOW('T',0x2D, struct termios2)
 #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
+#define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */
 
 #define FIONCLEX	0x5450
 #define FIOCLEX		0x5451
@@ -81,6 +82,7 @@
 #define TIOCPKT_START		 8
 #define TIOCPKT_NOSTOP		16
 #define TIOCPKT_DOSTOP		32
+#define TIOCPKT_IOCTL		64
 
 #define TIOCSER_TEMT    0x01	/* Transmitter physically empty */
 
diff --git a/arch/m32r/include/asm/termbits.h b/arch/m32r/include/asm/termbits.h
index bc10400..957a3c6 100644
--- a/arch/m32r/include/asm/termbits.h
+++ b/arch/m32r/include/asm/termbits.h
@@ -179,6 +179,7 @@ struct ktermios {
 #define FLUSHO	0010000
 #define PENDIN	0040000
 #define IEXTEN	0100000
+#define EXTPROC	0200000
 
 /* tcflow() and TCXONC use these */
 #define	TCOOFF		0
diff --git a/arch/m68k/include/asm/ioctls.h b/arch/m68k/include/asm/ioctls.h
index b8d2f4b..91a57d6 100644
--- a/arch/m68k/include/asm/ioctls.h
+++ b/arch/m68k/include/asm/ioctls.h
@@ -52,6 +52,7 @@
 #define TCSETSF2	_IOW('T',0x2D, struct termios2)
 #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
+#define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */
 
 #define FIONCLEX	0x5450  /* these numbers need to be adjusted. */
 #define FIOCLEX		0x5451
@@ -78,6 +79,7 @@
 #define TIOCPKT_START		 8
 #define TIOCPKT_NOSTOP		16
 #define TIOCPKT_DOSTOP		32
+#define TIOCPKT_IOCTL		64
 
 #define TIOCSER_TEMT    0x01	/* Transmitter physically empty */
 
diff --git a/arch/m68k/include/asm/termbits.h b/arch/m68k/include/asm/termbits.h
index 8c14170..aea1e37 100644
--- a/arch/m68k/include/asm/termbits.h
+++ b/arch/m68k/include/asm/termbits.h
@@ -179,6 +179,7 @@ struct ktermios {
 #define FLUSHO	0010000
 #define PENDIN	0040000
 #define IEXTEN	0100000
+#define EXTPROC	0200000
 
 
 /* tcflow() and TCXONC use these */
diff --git a/arch/mips/include/asm/ioctls.h b/arch/mips/include/asm/ioctls.h
index 3f04a99..767d196 100644
--- a/arch/mips/include/asm/ioctls.h
+++ b/arch/mips/include/asm/ioctls.h
@@ -41,7 +41,7 @@
 #define	 TIOCPKT_START		0x08	/* start output */
 #define	 TIOCPKT_NOSTOP		0x10	/* no more ^S, ^Q */
 #define	 TIOCPKT_DOSTOP		0x20	/* now do ^S ^Q */
-/* #define  TIOCPKT_IOCTL		0x40	state change of pty driver */
+#define  TIOCPKT_IOCTL		0x40	/* state change of pty driver */
 #define TIOCSWINSZ	_IOW('t', 103, struct winsize)	/* set window size */
 #define TIOCGWINSZ	_IOR('t', 104, struct winsize)	/* get window size */
 #define TIOCNOTTY	0x5471		/* void tty association */
@@ -83,6 +83,7 @@
 #define TCSETSF2	_IOW('T', 0x2D, struct termios2)
 #define TIOCGPTN	_IOR('T', 0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T', 0x31, int)  /* Lock/unlock Pty */
+#define TIOCSIG		_IOW('T', 0x36, int)  /* Generate signal on Pty slave */
 
 /* I hope the range from 0x5480 on is free ... */
 #define TIOCSCTTY	0x5480		/* become controlling tty */
diff --git a/arch/mips/include/asm/termbits.h b/arch/mips/include/asm/termbits.h
index c83c684..76630b3 100644
--- a/arch/mips/include/asm/termbits.h
+++ b/arch/mips/include/asm/termbits.h
@@ -203,6 +203,7 @@ struct ktermios {
 #define PENDIN	0040000		/* Retype pending input (state).  */
 #define TOSTOP	0100000		/* Send SIGTTOU for background output.  */
 #define ITOSTOP	TOSTOP
+#define EXTPROC	0200000		/* External processing on pty */
 
 /* ioctl (fd, TIOCSERGETLSR, &result) where result may be as below */
 #define TIOCSER_TEMT    0x01	/* Transmitter physically empty */
diff --git a/arch/mn10300/include/asm/ioctls.h b/arch/mn10300/include/asm/ioctls.h
index dcbfb45..c149fe1 100644
--- a/arch/mn10300/include/asm/ioctls.h
+++ b/arch/mn10300/include/asm/ioctls.h
@@ -54,6 +54,7 @@
 #define TIOCGPTN	_IOR('T', 0x30, unsigned int) /* Get Pty Number
 						       * (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T', 0x31, int)  /* Lock/unlock Pty */
+#define TIOCSIG		_IOW('T', 0x36, int)  /* Generate signal on Pty slave */
 
 #define FIONCLEX	0x5450
 #define FIOCLEX		0x5451
@@ -82,6 +83,7 @@
 #define TIOCPKT_START		 8
 #define TIOCPKT_NOSTOP		16
 #define TIOCPKT_DOSTOP		32
+#define TIOCPKT_IOCTL		64
 
 #define TIOCSER_TEMT    0x01	/* Transmitter physically empty */
 
diff --git a/arch/mn10300/include/asm/termbits.h b/arch/mn10300/include/asm/termbits.h
index eb2b0dc..130d424 100644
--- a/arch/mn10300/include/asm/termbits.h
+++ b/arch/mn10300/include/asm/termbits.h
@@ -180,6 +180,7 @@ struct ktermios {
 #define FLUSHO	0010000
 #define PENDIN	0040000
 #define IEXTEN	0100000
+#define EXTPROC	0200000
 
 /* tcflow() and TCXONC use these */
 #define	TCOOFF		0
diff --git a/arch/parisc/include/asm/ioctls.h b/arch/parisc/include/asm/ioctls.h
index 6747fad..bf73dbb 100644
--- a/arch/parisc/include/asm/ioctls.h
+++ b/arch/parisc/include/asm/ioctls.h
@@ -52,6 +52,7 @@
 #define TCSETSF2	_IOW('T',0x2D, struct termios2)
 #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
+#define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */
 
 #define FIONCLEX	0x5450  /* these numbers need to be adjusted. */
 #define FIOCLEX		0x5451
@@ -84,6 +85,7 @@
 #define TIOCPKT_START		 8
 #define TIOCPKT_NOSTOP		16
 #define TIOCPKT_DOSTOP		32
+#define TIOCPKT_IOCTL		64
 
 #define TIOCSER_TEMT    0x01	/* Transmitter physically empty */
 
diff --git a/arch/parisc/include/asm/termbits.h b/arch/parisc/include/asm/termbits.h
index d8bbc73..d1ab921 100644
--- a/arch/parisc/include/asm/termbits.h
+++ b/arch/parisc/include/asm/termbits.h
@@ -180,6 +180,7 @@ struct ktermios {
 #define FLUSHO  0010000
 #define PENDIN  0040000
 #define IEXTEN  0100000
+#define EXTPROC	0200000
 
 /* tcflow() and TCXONC use these */
 #define	TCOOFF		0
diff --git a/arch/powerpc/include/asm/ioctls.h b/arch/powerpc/include/asm/ioctls.h
index 1842186..8519200 100644
--- a/arch/powerpc/include/asm/ioctls.h
+++ b/arch/powerpc/include/asm/ioctls.h
@@ -80,6 +80,7 @@
 # define TIOCPKT_START		 8
 # define TIOCPKT_NOSTOP		16
 # define TIOCPKT_DOSTOP		32
+# define TIOCPKT_IOCTL		64
 
 
 #define TIOCNOTTY	0x5422
@@ -93,6 +94,7 @@
 #define TIOCSRS485	0x542f
 #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
+#define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */
 
 #define TIOCSERCONFIG	0x5453
 #define TIOCSERGWILD	0x5454
diff --git a/arch/powerpc/include/asm/termbits.h b/arch/powerpc/include/asm/termbits.h
index 6698188..549d700 100644
--- a/arch/powerpc/include/asm/termbits.h
+++ b/arch/powerpc/include/asm/termbits.h
@@ -189,6 +189,7 @@ struct ktermios {
 #define FLUSHO	0x00800000
 #define PENDIN	0x20000000
 #define IEXTEN	0x00000400
+#define EXTPROC	0x10000000
 
 /* Values for the ACTION argument to `tcflow'.  */
 #define	TCOOFF		0
diff --git a/arch/s390/include/asm/ioctls.h b/arch/s390/include/asm/ioctls.h
index 40e481b..2f3d873 100644
--- a/arch/s390/include/asm/ioctls.h
+++ b/arch/s390/include/asm/ioctls.h
@@ -60,6 +60,7 @@
 #define TCSETSF2	_IOW('T',0x2D, struct termios2)
 #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
+#define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */
 
 #define FIONCLEX	0x5450  /* these numbers need to be adjusted. */
 #define FIOCLEX		0x5451
@@ -86,6 +87,7 @@
 #define TIOCPKT_START		 8
 #define TIOCPKT_NOSTOP		16
 #define TIOCPKT_DOSTOP		32
+#define TIOCPKT_IOCTL		64
 
 #define TIOCSER_TEMT    0x01	/* Transmitter physically empty */
 
diff --git a/arch/sh/include/asm/ioctls.h b/arch/sh/include/asm/ioctls.h
index c212c37..eb6c4c6 100644
--- a/arch/sh/include/asm/ioctls.h
+++ b/arch/sh/include/asm/ioctls.h
@@ -69,6 +69,7 @@
 # define TIOCPKT_START		 8
 # define TIOCPKT_NOSTOP		16
 # define TIOCPKT_DOSTOP		32
+# define TIOCPKT_IOCTL		64
 
 
 #define TIOCNOTTY	_IO('T', 34) /* 0x5422 */
@@ -84,6 +85,7 @@
 #define TCSETSF2	_IOW('T', 45, struct termios2)
 #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
+#define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */
 
 #define TIOCSERCONFIG	_IO('T', 83) /* 0x5453 */
 #define TIOCSERGWILD	_IOR('T', 84,  int) /* 0x5454 */
diff --git a/arch/sparc/include/asm/ioctls.h b/arch/sparc/include/asm/ioctls.h
index 1fe6855..53f4ee0 100644
--- a/arch/sparc/include/asm/ioctls.h
+++ b/arch/sparc/include/asm/ioctls.h
@@ -80,6 +80,7 @@
 /* Get minor device of a pty master's FD -- Solaris equiv is ISPTM */
 #define TIOCGPTN	_IOR('t', 134, unsigned int) /* Get Pty Number */
 #define TIOCSPTLCK	_IOW('t', 135, int) /* Lock/unlock PTY */
+#define TIOCSIG		_IOW('t', 136, int) /* Generate signal on Pty slave */
 
 /* Little f */
 #define FIOCLEX		_IO('f', 1)
@@ -132,5 +133,6 @@
 #define TIOCPKT_START		 8
 #define TIOCPKT_NOSTOP		16
 #define TIOCPKT_DOSTOP		32
+#define TIOCPKT_IOCTL		64
 
 #endif /* !(_ASM_SPARC_IOCTLS_H) */
diff --git a/arch/sparc/include/asm/termbits.h b/arch/sparc/include/asm/termbits.h
index d72dfed..23b10ff 100644
--- a/arch/sparc/include/asm/termbits.h
+++ b/arch/sparc/include/asm/termbits.h
@@ -225,6 +225,7 @@ struct ktermios {
 #define FLUSHO	0x00002000
 #define PENDIN	0x00004000
 #define IEXTEN	0x00008000
+#define EXTPROC	0x00010000
 
 /* modem lines */
 #define TIOCM_LE	0x001
diff --git a/arch/xtensa/include/asm/ioctls.h b/arch/xtensa/include/asm/ioctls.h
index 0ffa942..ab18000 100644
--- a/arch/xtensa/include/asm/ioctls.h
+++ b/arch/xtensa/include/asm/ioctls.h
@@ -81,6 +81,7 @@
 # define TIOCPKT_START		 8
 # define TIOCPKT_NOSTOP		16
 # define TIOCPKT_DOSTOP		32
+# define TIOCPKT_IOCTL		64
 
 
 #define TIOCNOTTY	_IO('T', 34)
@@ -97,6 +98,7 @@
 #define TCSETSF2	_IOW('T', 45, struct termios2)
 #define TIOCGPTN	_IOR('T',0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T',0x31, int)  /* Lock/unlock Pty */
+#define TIOCSIG		_IOW('T',0x36, int)  /* Generate signal on Pty slave */
 
 #define TIOCSERCONFIG	_IO('T', 83)
 #define TIOCSERGWILD	_IOR('T', 84,  int)
diff --git a/arch/xtensa/include/asm/termbits.h b/arch/xtensa/include/asm/termbits.h
index 85aa6a3..0d6c871 100644
--- a/arch/xtensa/include/asm/termbits.h
+++ b/arch/xtensa/include/asm/termbits.h
@@ -196,6 +196,7 @@ struct ktermios {
 #define FLUSHO	0010000
 #define PENDIN	0040000
 #define IEXTEN	0100000
+#define EXTPROC	0200000
 
 /* tcflow() and TCXONC use these */
 
diff --git a/drivers/char/n_tty.c b/drivers/char/n_tty.c
index bdae832..67caa01 100644
--- a/drivers/char/n_tty.c
+++ b/drivers/char/n_tty.c
@@ -1102,6 +1102,11 @@ static inline void n_tty_receive_char(struct tty_struct *tty, unsigned char c)
 	if (I_IUCLC(tty) && L_IEXTEN(tty))
 		c = tolower(c);
 
+	if (L_EXTPROC(tty)) {
+		put_tty_queue(c, tty);
+		return;
+	}
+
 	if (tty->stopped && !tty->flow_stopped && I_IXON(tty) &&
 	    I_IXANY(tty) && c != START_CHAR(tty) && c != STOP_CHAR(tty) &&
 	    c != INTR_CHAR(tty) && c != QUIT_CHAR(tty) && c != SUSP_CHAR(tty)) {
@@ -1409,7 +1414,8 @@ static void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 
 	n_tty_set_room(tty);
 
-	if (!tty->icanon && (tty->read_cnt >= tty->minimum_to_wake)) {
+	if ((!tty->icanon && (tty->read_cnt >= tty->minimum_to_wake)) ||
+		L_EXTPROC(tty)) {
 		kill_fasync(&tty->fasync, SIGIO, POLL_IN);
 		if (waitqueue_active(&tty->read_wait))
 			wake_up_interruptible(&tty->read_wait);
@@ -1585,7 +1591,7 @@ static int n_tty_open(struct tty_struct *tty)
 static inline int input_available_p(struct tty_struct *tty, int amt)
 {
 	tty_flush_to_ldisc(tty);
-	if (tty->icanon) {
+	if (tty->icanon && !L_EXTPROC(tty)) {
 		if (tty->canon_data)
 			return 1;
 	} else if (tty->read_cnt >= (amt ? amt : 1))
@@ -1632,6 +1638,11 @@ static int copy_from_read_buf(struct tty_struct *tty,
 		spin_lock_irqsave(&tty->read_lock, flags);
 		tty->read_tail = (tty->read_tail + n) & (N_TTY_BUF_SIZE-1);
 		tty->read_cnt -= n;
+		/* Check if last character is EOF */
+		if (L_EXTPROC(tty) && tty->icanon) {
+			if (!tty->read_cnt && *b[n-1] == EOF_CHAR(tty))
+				n--;
+		}
 		spin_unlock_irqrestore(&tty->read_lock, flags);
 		*b += n;
 		*nr -= n;
@@ -1767,6 +1778,14 @@ do_it_again:
 				break;
 			}
 			nr--;
+			if (cs & TIOCPKT_IOCTL) {
+				c = sizeof(struct termios);
+				if (c > nr)
+					c = nr;
+				copy_to_user(b, tty->link->termios, c);
+				nr -= c;
+				b += c;
+			}
 			break;
 		}
 		/* This statement must be first before checking for input
@@ -1812,7 +1831,7 @@ do_it_again:
 			nr--;
 		}
 
-		if (tty->icanon) {
+		if (tty->icanon && !L_EXTPROC(tty)) {
 			/* N.B. avoid overrun if nr == 0 */
 			while (nr && tty->read_cnt) {
 				int eol;
diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index d83a431..c429e9f 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -171,6 +171,15 @@ static int pty_set_lock(struct tty_struct *tty, int __user *arg)
 	return 0;
 }
 
+/* Send a signal to the slave */
+static int pty_signal(struct tty_struct *tty, int sig)
+{
+	if (tty->link) {
+		kill_pgrp(tty->link->pgrp, sig, 1);
+	}
+	return 0;
+}
+
 static void pty_flush_buffer(struct tty_struct *tty)
 {
 	struct tty_struct *to = tty->link;
@@ -321,6 +330,8 @@ static int pty_bsd_ioctl(struct tty_struct *tty, struct file *file,
 	switch (cmd) {
 	case TIOCSPTLCK: /* Set PT Lock (disallow slave open) */
 		return pty_set_lock(tty, (int __user *) arg);
+	case TIOCSIG:    /* Send signal to other side of pty */
+		return pty_signal(tty, (int) arg);
 	}
 	return -ENOIOCTLCMD;
 }
@@ -476,6 +487,8 @@ static int pty_unix98_ioctl(struct tty_struct *tty, struct file *file,
 		return pty_set_lock(tty, (int __user *)arg);
 	case TIOCGPTN: /* Get PT Number */
 		return put_user(tty->index, (unsigned int __user *)arg);
+	case TIOCSIG:    /* Send signal to other side of pty */
+		return pty_signal(tty, (int) arg);
 	}
 
 	return -ENOIOCTLCMD;
diff --git a/drivers/char/tty_ioctl.c b/drivers/char/tty_ioctl.c
index 6bd5f88..0c18899 100644
--- a/drivers/char/tty_ioctl.c
+++ b/drivers/char/tty_ioctl.c
@@ -517,19 +517,25 @@ static void change_termios(struct tty_struct *tty, struct ktermios *new_termios)
 
 	/* See if packet mode change of state. */
 	if (tty->link && tty->link->packet) {
+		int extproc = (old_termios.c_lflag & EXTPROC) |
+				(tty->termios->c_lflag & EXTPROC);
 		int old_flow = ((old_termios.c_iflag & IXON) &&
 				(old_termios.c_cc[VSTOP] == '\023') &&
 				(old_termios.c_cc[VSTART] == '\021'));
 		int new_flow = (I_IXON(tty) &&
 				STOP_CHAR(tty) == '\023' &&
 				START_CHAR(tty) == '\021');
-		if (old_flow != new_flow) {
+		if ((old_flow != new_flow) || extproc) {
 			spin_lock_irqsave(&tty->ctrl_lock, flags);
-			tty->ctrl_status &= ~(TIOCPKT_DOSTOP | TIOCPKT_NOSTOP);
-			if (new_flow)
-				tty->ctrl_status |= TIOCPKT_DOSTOP;
-			else
-				tty->ctrl_status |= TIOCPKT_NOSTOP;
+			if (old_flow != new_flow) {
+				tty->ctrl_status &= ~(TIOCPKT_DOSTOP | TIOCPKT_NOSTOP);
+				if (new_flow)
+					tty->ctrl_status |= TIOCPKT_DOSTOP;
+				else
+					tty->ctrl_status |= TIOCPKT_NOSTOP;
+			}
+			if (extproc)
+				tty->ctrl_status |= TIOCPKT_IOCTL;
 			spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 			wake_up_interruptible(&tty->link->read_wait);
 		}
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 641640d..766636d 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -966,6 +966,7 @@ COMPATIBLE_IOCTL(TIOCGPGRP)
 COMPATIBLE_IOCTL(TIOCGPTN)
 COMPATIBLE_IOCTL(TIOCSPTLCK)
 COMPATIBLE_IOCTL(TIOCSERGETLSR)
+COMPATIBLE_IOCTL(TIOCSIG)
 #ifdef TCGETS2
 COMPATIBLE_IOCTL(TCGETS2)
 COMPATIBLE_IOCTL(TCSETS2)
diff --git a/include/asm-generic/ioctls.h b/include/asm-generic/ioctls.h
index a799e20..87661c8 100644
--- a/include/asm-generic/ioctls.h
+++ b/include/asm-generic/ioctls.h
@@ -69,6 +69,7 @@
 #define TCSETX		0x5433
 #define TCSETXF		0x5434
 #define TCSETXW		0x5435
+#define TIOCSIG		_IOW('T', 0x36, int)  /* pty: generate signal */
 
 #define FIONCLEX	0x5450
 #define FIOCLEX		0x5451
@@ -104,6 +105,7 @@
 #define TIOCPKT_START		 8
 #define TIOCPKT_NOSTOP		16
 #define TIOCPKT_DOSTOP		32
+#define TIOCPKT_IOCTL		64
 
 #define TIOCSER_TEMT	0x01	/* Transmitter physically empty */
 
diff --git a/include/asm-generic/termbits.h b/include/asm-generic/termbits.h
index 1c9773d..232b478 100644
--- a/include/asm-generic/termbits.h
+++ b/include/asm-generic/termbits.h
@@ -178,6 +178,7 @@ struct ktermios {
 #define FLUSHO	0010000
 #define PENDIN	0040000
 #define IEXTEN	0100000
+#define EXTPROC	0200000
 
 /* tcflow() and TCXONC use these */
 #define	TCOOFF		0
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 4409967..3cfe448 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -178,6 +178,7 @@ struct tty_bufhead {
 #define L_FLUSHO(tty)	_L_FLAG((tty), FLUSHO)
 #define L_PENDIN(tty)	_L_FLAG((tty), PENDIN)
 #define L_IEXTEN(tty)	_L_FLAG((tty), IEXTEN)
+#define L_EXTPROC(tty)	_L_FLAG((tty), EXTPROC)
 
 struct device;
 struct signal_struct;
--
1.7.0.4

-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/

