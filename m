Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab0FKKTF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 06:19:05 -0400
Received: from lirone.symas.net ([64.71.152.235]:38001 "EHLO lirone.symas.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760112Ab0FKKS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 06:18:57 -0400
X-Greylist: delayed 1489 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Jun 2010 06:18:57 EDT
Message-ID: <4C120D8A.8050207@symas.com>
Date: Fri, 11 Jun 2010 03:18:50 -0700
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; rv:1.9.3a5pre) Gecko/20100607 Firefox 3.6
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: EXTPROC, telnetd LINEMODE, revisited
Content-Type: multipart/mixed;
 boundary="------------020709030009040802060405"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020709030009040802060405
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

It's been over 10 years since I looked at this last

http://lkml.indiana.edu/hypermail/linux/kernel/9911.3/0650.html

and apparently no one else has been interested since then. A random 
conversation got me looking into it again, and now I have it working. However, 
obviously the world has moved on from telnet to ssh, and my goal in posting 
now is to hash out what needs to be done in the kernel so that LINEMODE can be 
fully supported in ssh.

First you'll note that this patch is fairly similar to the one I posted back 
in 1999. The bug I was chasing down back then turned out to be in the telnetd 
source, not in the tty driver, so this patch has only needed minor refreshing 
to bring it up to date.

There are some other issues that need to be addressed though to make this 
feature maximally useful today:

GNU readline and other similar code is prevalent today, and uses many 
additional editing characters that aren't represented in termios. The telnet 
Linemode spec in RFC 1184 accomodates most of these characters but without 
termios support there's no way to communicate these settings between telnetd 
and the readline library (or whatever other app). Most of the editing features 
provided by readline really belong on the local client anyway.

Linemode assumes single-character codes for input functions, but on common 
terminals (e.g. ANSI/VT100 style) a lot of navigation keys send 
multi-character sequences (cursor movement, etc.).

So I'm looking for suggestions on ways to approach this, that will allow as 
much functionality as possible to be handled by a local client.

Despite the fact that most people today have ready access to high speed 
broadband networking today, I think the motivation for local character 
processing is as great now as it was 10 years ago. I regularly use an ssh 
client on an Android phone to keep tabs on my servers when I'm away from my 
home base, and sometimes cellphone connectivity can be extremely lossy, 
networks can be heavily congested, etc... Waiting for character-at-a-time 
packet turnarounds in these conditions can be pretty aggravating. Also, if 
you're unfortunate enough to need to get access to a machine while you're 
roaming away from your home network, the per-byte roaming fees can be murder. 
Both of these pain points can be minimized by using local character processing 
and only sending complete lines to the remote server.

The telnet Linemode spec serves as a pretty good starting point for adapting 
to ssh, but these details still need to be addressed - can/should we add 
additional command characters to the tty driver? The telnet spec defines these 
commands that the tty driver is missing:
    Move cursor one character left, right
    Move cursor one word left, right
    Move cursor to beginning/end of line
    Enter insert/overstrike mode
    Erase character to the right
    Erase word to the right
    Erase to beginning/end of line

Also it would be nice to be able to define other forwarding characters, which 
don't necessarily have an edit function. E.g., <TAB> for word completion.

Another feature with readline is a command history buffer that can be reviewed 
using Cursor Up/Down. Can/should we define this in the tty driver too? Or 
perhaps rely on the client to implement its own command buffer, and never 
mention this aspect on the wire protocol. Again, given the purpose, it makes 
most sense to me to keep this feature on the client side. But some 
coordination with the server would still be useful. E.g., different programs 
can maintain their own persistent command history files. It might be nice to 
have a way for the app to signal to the client which command context to use 
for the current history buffer, and keep them all separate. (Or not, I can see 
other times where you'd just rather have it all as one stack.)

PS: if anyone knows where to send the patches for telnetd, please email me. 
Looks like the upstream source hasn't been touched since 2000.

ftp://ftp.uk.linux.org/pub/linux/Networking/netkit/

-- 
    -- Howard Chu
    CTO, Symas Corp.           http://www.symas.com
    Director, Highland Sun     http://highlandsun.com/hyc/
    Chief Architect, OpenLDAP  http://www.openldap.org/project/


--------------020709030009040802060405
Content-Type: text/plain;
 name="linemode.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="linemode.txt"

diff --git a/drivers/char/n_tty.c b/drivers/char/n_tty.c
index bdae832..bbc42e6 100644
--- a/drivers/char/n_tty.c
+++ b/drivers/char/n_tty.c
@@ -780,6 +780,8 @@ static void echo_erase_tab(unsigned int num_chars, int after_tab,
 
 static void echo_char_raw(unsigned char c, struct tty_struct *tty)
 {
+	if (L_EXTPROC(tty)) return;
+
 	mutex_lock(&tty->echo_lock);
 
 	if (c == ECHO_OP_START) {
@@ -808,6 +810,8 @@ static void echo_char_raw(unsigned char c, struct tty_struct *tty)
 
 static void echo_char(unsigned char c, struct tty_struct *tty)
 {
+	if (L_EXTPROC(tty)) return;
+
 	mutex_lock(&tty->echo_lock);
 
 	if (c == ECHO_OP_START) {
@@ -1767,6 +1771,13 @@ do_it_again:
 				break;
 			}
 			nr--;
+			if (cs & TIOCPKT_IOCTL) {
+				c = sizeof(struct termios);
+				if (c > nr) c = nr;
+				copy_to_user(b, tty->link->termios, c);
+				nr -= c;
+				b += c;
+			}
 			break;
 		}
 		/* This statement must be first before checking for input
diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index d83a431..7485efb 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -315,12 +315,21 @@ free_mem_out:
 	return -ENOMEM;
 }
 
+static int pty_signal(struct tty_struct *tty, int sig)
+{
+	if (tty->link && tty->link->pgrp > 0)
+		kill_pgrp(tty->link->pgrp, sig, 1);
+	return 0;
+}
+
 static int pty_bsd_ioctl(struct tty_struct *tty, struct file *file,
 			 unsigned int cmd, unsigned long arg)
 {
 	switch (cmd) {
 	case TIOCSPTLCK: /* Set PT Lock (disallow slave open) */
 		return pty_set_lock(tty, (int __user *) arg);
+	case TIOCSIG:    /* Send signal to other side of pty */
+		return pty_signal(tty, (int) arg);
 	}
 	return -ENOIOCTLCMD;
 }
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
diff --git a/include/asm-generic/ioctls.h b/include/asm-generic/ioctls.h
index a799e20..3ac6908 100644
--- a/include/asm-generic/ioctls.h
+++ b/include/asm-generic/ioctls.h
@@ -65,6 +65,7 @@
 #define TIOCSRS485	0x542F
 #define TIOCGPTN	_IOR('T', 0x30, unsigned int) /* Get Pty Number (of pty-mux device) */
 #define TIOCSPTLCK	_IOW('T', 0x31, int)  /* Lock/unlock Pty */
+#define TIOCSIG		_IO ('T', 0x32)  /* pty: generate signal */
 #define TCGETX		0x5432 /* SYS5 TCGETX compatibility */
 #define TCSETX		0x5433
 #define TCSETXF		0x5434
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


--------------020709030009040802060405--
