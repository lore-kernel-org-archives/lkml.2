Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340Ab0FOSLK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 14:11:10 -0400
Received: from lirone.symas.net ([64.71.152.235]:44397 "EHLO lirone.symas.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753775Ab0FOSLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 14:11:08 -0400
Message-ID: <4C17C233.2080106@symas.com>
Date: Tue, 15 Jun 2010 11:10:59 -0700
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; rv:1.9.3a5pre) Gecko/20100607 Firefox 3.6
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/2] tty: add EXTPROC support for LINEMODE
References: <4C120D8A.8050207@symas.com> <87631pq2aj.fsf@basil.nowhere.org> <4C121B4C.2000702@symas.com> <4C12E4B7.4020900@symas.com> <4C17C190.1020000@symas.com>
In-Reply-To: <4C17C190.1020000@symas.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds the basic driver support. Tested on x86 and x86-64.

Signed-off-by: Howard Chu <hyc@symas.com>
---
  drivers/char/n_tty.c           |   25 ++++++++++++++++++++++---
  drivers/char/pty.c             |   13 +++++++++++++
  drivers/char/tty_ioctl.c       |   18 ++++++++++++------
  fs/compat_ioctl.c              |    1 +
  include/asm-generic/ioctls.h   |    2 ++
  include/asm-generic/termbits.h |    1 +
  include/linux/tty.h            |    1 +
  7 files changed, 52 insertions(+), 9 deletions(-)

diff --git a/drivers/char/n_tty.c b/drivers/char/n_tty.c
index bdae832..67caa01 100644
--- a/drivers/char/n_tty.c
+++ b/drivers/char/n_tty.c
@@ -1102,6 +1102,11 @@ static inline void n_tty_receive_char(struct tty_struct 
*tty, unsigned char c)
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
@@ -1409,7 +1414,8 @@ static void n_tty_receive_buf(struct tty_struct *tty, 
const unsigned char *cp,

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
@@ -171,6 +171,15 @@ static int pty_set_lock(struct tty_struct *tty, int 
__user *arg)
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
@@ -321,6 +330,8 @@ static int pty_bsd_ioctl(struct tty_struct *tty, struct 
file *file,
  	switch (cmd) {
  	case TIOCSPTLCK: /* Set PT Lock (disallow slave open) */
  		return pty_set_lock(tty, (int __user *) arg);
+	case TIOCSIG:    /* Send signal to other side of pty */
+		return pty_signal(tty, (int) arg);
  	}
  	return -ENOIOCTLCMD;
  }
@@ -476,6 +487,8 @@ static int pty_unix98_ioctl(struct tty_struct *tty, struct 
file *file,
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
@@ -517,19 +517,25 @@ static void change_termios(struct tty_struct *tty, 
struct ktermios *new_termios)

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
-- 1.7.0.4


-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/
