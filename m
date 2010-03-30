Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756149Ab0C3U5g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 16:57:36 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51636 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032Ab0C3U5b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 16:57:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>, Arnd Bergmann <arnd@relay.de.ibm.com>,
       Arnd Bergmann <arnd@arndb.de>
Subject: [RFC 1/9] tty: replace BKL with a new tty_lock
Date: Tue, 30 Mar 2010 22:56:12 +0200
Message-Id: <1269982580-9361-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1269982580-9361-1-git-send-email-arnd@arndb.de>
References: <1269982580-9361-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+MCAiEy6sW5hqCHLIpF6o5OnRt4P8O+h2WGme
 cxYL9o6wpLnVp+hUElUWj+X1MvfWnn/2e42dGvRyHxyG29V780
 Xuw+eTs9S65NM9vouUyjw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@relay.de.ibm.com>

As a preparation for replacing the big kernel lock
in the TTY layer, wrap all the callers in new
macros tty_lock, tty_lock_nested and tty_unlock.

Code that has been verified to never be called with
the tty_lock held should use tty_lock, other code
should use tty_lock_nested.

We also need to deal with lock order problems that
are currently solved by the BKL autorelease semantics.
For this, we get new macros that can be used to
replace sleeping calls like mutex_lock() or wait_event().

We start using these in the next patches.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/char/amiserial.c        |   16 ++--
 drivers/char/briq_panel.c       |    6 +-
 drivers/char/cyclades.c         |   16 ++--
 drivers/char/epca.c             |    4 +-
 drivers/char/isicom.c           |   10 +-
 drivers/char/istallion.c        |    8 +-
 drivers/char/n_hdlc.c           |   16 ++--
 drivers/char/n_r3964.c          |    8 +-
 drivers/char/pty.c              |    4 +-
 drivers/char/riscom8.c          |    8 +-
 drivers/char/rocket.c           |    8 +-
 drivers/char/serial167.c        |    4 +-
 drivers/char/specialix.c        |   10 +-
 drivers/char/stallion.c         |   12 ++--
 drivers/char/sx.c               |   12 ++--
 drivers/char/synclink.c         |    8 +-
 drivers/char/synclink_gt.c      |    8 +-
 drivers/char/synclinkmp.c       |   12 ++--
 drivers/char/tty_io.c           |  113 +++++++++++++++------------
 drivers/char/tty_ldisc.c        |   22 +++---
 drivers/char/vc_screen.c        |    4 +-
 drivers/char/vt.c               |    4 +-
 drivers/char/vt_ioctl.c         |   10 +-
 drivers/isdn/i4l/isdn_common.c  |   20 +++---
 drivers/isdn/i4l/isdn_tty.c     |    8 +-
 drivers/serial/68360serial.c    |    4 +-
 drivers/serial/crisv10.c        |    4 +-
 drivers/serial/serial_core.c    |   10 +-
 drivers/usb/serial/usb-serial.c |   18 ++--
 drivers/video/console/vgacon.c  |    4 +-
 include/linux/tty.h             |  169 +++++++++++++++++++++++++++++++++++++++
 31 files changed, 371 insertions(+), 189 deletions(-)

diff --git a/drivers/char/amiserial.c b/drivers/char/amiserial.c
index 6c32fbf..d3bee1f 100644
--- a/drivers/char/amiserial.c
+++ b/drivers/char/amiserial.c
@@ -1071,7 +1071,7 @@ static int get_serial_info(struct async_struct * info,
 	if (!retinfo)
 		return -EFAULT;
 	memset(&tmp, 0, sizeof(tmp));
-	lock_kernel();
+	tty_lock();
 	tmp.type = state->type;
 	tmp.line = state->line;
 	tmp.port = state->port;
@@ -1082,7 +1082,7 @@ static int get_serial_info(struct async_struct * info,
 	tmp.close_delay = state->close_delay;
 	tmp.closing_wait = state->closing_wait;
 	tmp.custom_divisor = state->custom_divisor;
-	unlock_kernel();
+	tty_unlock();
 	if (copy_to_user(retinfo,&tmp,sizeof(*retinfo)))
 		return -EFAULT;
 	return 0;
@@ -1099,14 +1099,14 @@ static int set_serial_info(struct async_struct * info,
 	if (copy_from_user(&new_serial,new_info,sizeof(new_serial)))
 		return -EFAULT;
 
-	lock_kernel();
+	tty_lock();
 	state = info->state;
 	old_state = *state;
   
 	change_irq = new_serial.irq != state->irq;
 	change_port = (new_serial.port != state->port);
 	if(change_irq || change_port || (new_serial.xmit_fifo_size != state->xmit_fifo_size)) {
-	  unlock_kernel();
+	  tty_unlock();
 	  return -EINVAL;
 	}
   
@@ -1126,7 +1126,7 @@ static int set_serial_info(struct async_struct * info,
 	}
 
 	if (new_serial.baud_base < 9600) {
-		unlock_kernel();
+		tty_unlock();
 		return -EINVAL;
 	}
 
@@ -1162,7 +1162,7 @@ check_and_exit:
 		}
 	} else
 		retval = startup(info);
-	unlock_kernel();
+	tty_unlock();
 	return retval;
 }
 
@@ -1537,7 +1537,7 @@ static void rs_wait_until_sent(struct tty_struct *tty, int timeout)
 
 	orig_jiffies = jiffies;
 
-	lock_kernel();
+	tty_lock_nested();
 	/*
 	 * Set the check interval to be 1/5 of the estimated time to
 	 * send a single character, and make it at least 1.  The check
@@ -1578,7 +1578,7 @@ static void rs_wait_until_sent(struct tty_struct *tty, int timeout)
 			break;
 	}
 	__set_current_state(TASK_RUNNING);
-	unlock_kernel();
+	tty_unlock();
 #ifdef SERIAL_DEBUG_RS_WAIT_UNTIL_SENT
 	printk("lsr = %d (jiff=%lu)...done\n", lsr, jiffies);
 #endif
diff --git a/drivers/char/briq_panel.c b/drivers/char/briq_panel.c
index d8cff90..bf19527 100644
--- a/drivers/char/briq_panel.c
+++ b/drivers/char/briq_panel.c
@@ -68,15 +68,15 @@ static void set_led(char state)
 
 static int briq_panel_open(struct inode *ino, struct file *filep)
 {
-	lock_kernel();
+	tty_lock();
 	/* enforce single access, vfd_is_open is protected by BKL */
 	if (vfd_is_open) {
-		unlock_kernel();
+		tty_unlock();
 		return -EBUSY;
 	}
 	vfd_is_open = 1;
 
-	unlock_kernel();
+	tty_unlock();
 	return 0;
 }
 
diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index b861c08..350595e 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -1654,7 +1654,7 @@ static void cy_wait_until_sent(struct tty_struct *tty, int timeout)
 		return;		/* Just in case.... */
 
 	orig_jiffies = jiffies;
-	lock_kernel();
+	tty_lock_nested();
 	/*
 	 * Set the check interval to be 1/5 of the estimated time to
 	 * send a single character, and make it at least 1.  The check
@@ -1701,7 +1701,7 @@ static void cy_wait_until_sent(struct tty_struct *tty, int timeout)
 	}
 	/* Run one more char cycle */
 	msleep_interruptible(jiffies_to_msecs(char_time * 5));
-	unlock_kernel();
+	tty_unlock();
 #ifdef CY_DEBUG_WAIT_UNTIL_SENT
 	printk(KERN_DEBUG "Clean (jiff=%lu)...done\n", jiffies);
 #endif
@@ -1958,7 +1958,7 @@ static int cy_chars_in_buffer(struct tty_struct *tty)
 		int char_count;
 		__u32 tx_put, tx_get, tx_bufsize;
 
-		lock_kernel();
+		tty_lock_nested();
 		tx_get = readl(&buf_ctrl->tx_get);
 		tx_put = readl(&buf_ctrl->tx_put);
 		tx_bufsize = readl(&buf_ctrl->tx_bufsize);
@@ -1970,7 +1970,7 @@ static int cy_chars_in_buffer(struct tty_struct *tty)
 		printk(KERN_DEBUG "cyc:cy_chars_in_buffer ttyC%d %d\n",
 			info->line, info->xmit_cnt + char_count);
 #endif
-		unlock_kernel();
+		tty_unlock();
 		return info->xmit_cnt + char_count;
 	}
 #endif				/* Z_EXT_CHARS_IN_BUFFER */
@@ -2437,7 +2437,7 @@ static int cy_tiocmget(struct tty_struct *tty, struct file *file)
 
 	card = info->card;
 
-	lock_kernel();
+	tty_lock();
 	if (!cy_is_Z(card)) {
 		unsigned long flags;
 		int channel = info->line - card->first_line;
@@ -2477,7 +2477,7 @@ static int cy_tiocmget(struct tty_struct *tty, struct file *file)
 			((lstatus & C_RS_CTS) ? TIOCM_CTS : 0);
 	}
 end:
-	unlock_kernel();
+	tty_unlock();
 	return result;
 }				/* cy_tiomget */
 
@@ -2695,7 +2695,7 @@ cy_ioctl(struct tty_struct *tty, struct file *file,
 	printk(KERN_DEBUG "cyc:cy_ioctl ttyC%d, cmd = %x arg = %lx\n",
 		info->line, cmd, arg);
 #endif
-	lock_kernel();
+	tty_lock();
 
 	switch (cmd) {
 	case CYGETMON:
@@ -2816,7 +2816,7 @@ cy_ioctl(struct tty_struct *tty, struct file *file,
 	default:
 		ret_val = -ENOIOCTLCMD;
 	}
-	unlock_kernel();
+	tty_unlock();
 
 #ifdef CY_DEBUG_OTHER
 	printk(KERN_DEBUG "cyc:cy_ioctl done\n");
diff --git a/drivers/char/epca.c b/drivers/char/epca.c
index 17b044a..50699df 100644
--- a/drivers/char/epca.c
+++ b/drivers/char/epca.c
@@ -2106,7 +2106,7 @@ static int pc_ioctl(struct tty_struct *tty, struct file *file,
 		break;
 	case DIGI_SETAW:
 	case DIGI_SETAF:
-		lock_kernel();
+		tty_lock();
 		if (cmd == DIGI_SETAW) {
 			/* Setup an event to indicate when the transmit
 			   buffer empties */
@@ -2119,7 +2119,7 @@ static int pc_ioctl(struct tty_struct *tty, struct file *file,
 			if (tty->ldisc->ops->flush_buffer)
 				tty->ldisc->ops->flush_buffer(tty);
 		}
-		unlock_kernel();
+		tty_unlock();
 		/* Fall Thru */
 	case DIGI_SETA:
 		if (copy_from_user(&ch->digiext, argp, sizeof(digi_t)))
diff --git a/drivers/char/isicom.c b/drivers/char/isicom.c
index be2e8f9..04b6fe0 100644
--- a/drivers/char/isicom.c
+++ b/drivers/char/isicom.c
@@ -1112,7 +1112,7 @@ static int isicom_set_serial_info(struct tty_struct *tty,
 	if (copy_from_user(&newinfo, info, sizeof(newinfo)))
 		return -EFAULT;
 
-	lock_kernel();
+	tty_lock();
 
 	reconfig_port = ((port->port.flags & ASYNC_SPD_MASK) !=
 		(newinfo.flags & ASYNC_SPD_MASK));
@@ -1122,7 +1122,7 @@ static int isicom_set_serial_info(struct tty_struct *tty,
 				(newinfo.closing_wait != port->port.closing_wait) ||
 				((newinfo.flags & ~ASYNC_USR_MASK) !=
 				(port->port.flags & ~ASYNC_USR_MASK))) {
-			unlock_kernel();
+			tty_unlock();
 			return -EPERM;
 		}
 		port->port.flags = ((port->port.flags & ~ASYNC_USR_MASK) |
@@ -1139,7 +1139,7 @@ static int isicom_set_serial_info(struct tty_struct *tty,
 		isicom_config_port(tty);
 		spin_unlock_irqrestore(&port->card->card_lock, flags);
 	}
-	unlock_kernel();
+	tty_unlock();
 	return 0;
 }
 
@@ -1148,7 +1148,7 @@ static int isicom_get_serial_info(struct isi_port *port,
 {
 	struct serial_struct out_info;
 
-	lock_kernel();
+	tty_lock();
 	memset(&out_info, 0, sizeof(out_info));
 /*	out_info.type = ? */
 	out_info.line = port - isi_ports;
@@ -1158,7 +1158,7 @@ static int isicom_get_serial_info(struct isi_port *port,
 /*	out_info.baud_base = ? */
 	out_info.close_delay = port->port.close_delay;
 	out_info.closing_wait = port->port.closing_wait;
-	unlock_kernel();
+	tty_unlock();
 	if (copy_to_user(info, &out_info, sizeof(out_info)))
 		return -EFAULT;
 	return 0;
diff --git a/drivers/char/istallion.c b/drivers/char/istallion.c
index 4cd6c52..39853b4 100644
--- a/drivers/char/istallion.c
+++ b/drivers/char/istallion.c
@@ -4264,7 +4264,7 @@ static long stli_memioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 	done = 0;
 	rc = 0;
 
-	lock_kernel();
+	tty_lock();
 
 	switch (cmd) {
 	case COM_GETPORTSTATS:
@@ -4288,7 +4288,7 @@ static long stli_memioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 		done++;
 		break;
 	}
-	unlock_kernel();
+	tty_unlock();
 
 	if (done)
 		return rc;
@@ -4306,7 +4306,7 @@ static long stli_memioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 	if (brdp->state == 0)
 		return -ENODEV;
 
-	lock_kernel();
+	tty_lock();
 
 	switch (cmd) {
 	case STL_BINTR:
@@ -4330,7 +4330,7 @@ static long stli_memioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 		rc = -ENOIOCTLCMD;
 		break;
 	}
-	unlock_kernel();
+	tty_unlock();
 	return rc;
 }
 
diff --git a/drivers/char/n_hdlc.c b/drivers/char/n_hdlc.c
index c68118e..fed2ef1 100644
--- a/drivers/char/n_hdlc.c
+++ b/drivers/char/n_hdlc.c
@@ -598,18 +598,18 @@ static ssize_t n_hdlc_tty_read(struct tty_struct *tty, struct file *file,
 		return -EFAULT;
 	}
 
-	lock_kernel();
+	tty_lock_nested();
 
 	for (;;) {
 		if (test_bit(TTY_OTHER_CLOSED, &tty->flags)) {
-			unlock_kernel();
+			tty_unlock();
 			return -EIO;
 		}
 
 		n_hdlc = tty2n_hdlc (tty);
 		if (!n_hdlc || n_hdlc->magic != HDLC_MAGIC ||
 			 tty != n_hdlc->tty) {
-			unlock_kernel();
+			tty_unlock();
 			return 0;
 		}
 
@@ -619,13 +619,13 @@ static ssize_t n_hdlc_tty_read(struct tty_struct *tty, struct file *file,
 			
 		/* no data */
 		if (file->f_flags & O_NONBLOCK) {
-			unlock_kernel();
+			tty_unlock();
 			return -EAGAIN;
 		}
 			
 		interruptible_sleep_on (&tty->read_wait);
 		if (signal_pending(current)) {
-			unlock_kernel();
+			tty_unlock();
 			return -EINTR;
 		}
 	}
@@ -648,7 +648,7 @@ static ssize_t n_hdlc_tty_read(struct tty_struct *tty, struct file *file,
 		kfree(rbuf);
 	else	
 		n_hdlc_buf_put(&n_hdlc->rx_free_buf_list,rbuf);
-	unlock_kernel();
+	tty_unlock();
 	return ret;
 	
 }	/* end of n_hdlc_tty_read() */
@@ -691,7 +691,7 @@ static ssize_t n_hdlc_tty_write(struct tty_struct *tty, struct file *file,
 		count = maxframe;
 	}
 	
-	lock_kernel();
+	tty_lock_nested();
 
 	add_wait_queue(&tty->write_wait, &wait);
 	set_current_state(TASK_INTERRUPTIBLE);
@@ -731,7 +731,7 @@ static ssize_t n_hdlc_tty_write(struct tty_struct *tty, struct file *file,
 		n_hdlc_buf_put(&n_hdlc->tx_buf_list,tbuf);
 		n_hdlc_send_frames(n_hdlc,tty);
 	}
-	unlock_kernel();
+	tty_unlock();
 	return error;
 	
 }	/* end of n_hdlc_tty_write() */
diff --git a/drivers/char/n_r3964.c b/drivers/char/n_r3964.c
index c1d8b54..2bd0e22 100644
--- a/drivers/char/n_r3964.c
+++ b/drivers/char/n_r3964.c
@@ -1067,7 +1067,7 @@ static ssize_t r3964_read(struct tty_struct *tty, struct file *file,
 
 	TRACE_L("read()");
 
-	lock_kernel();
+	tty_lock_nested();
 
 	pClient = findClient(pInfo, task_pid(current));
 	if (pClient) {
@@ -1109,7 +1109,7 @@ static ssize_t r3964_read(struct tty_struct *tty, struct file *file,
 	}
 	ret = -EPERM;
 unlock:
-	unlock_kernel();
+	tty_unlock();
 	return ret;
 }
 
@@ -1158,7 +1158,7 @@ static ssize_t r3964_write(struct tty_struct *tty, struct file *file,
 	pHeader->locks = 0;
 	pHeader->owner = NULL;
 
-	lock_kernel();
+	tty_lock_nested();
 
 	pClient = findClient(pInfo, task_pid(current));
 	if (pClient) {
@@ -1177,7 +1177,7 @@ static ssize_t r3964_write(struct tty_struct *tty, struct file *file,
 	add_tx_queue(pInfo, pHeader);
 	trigger_transmit(pInfo);
 
-	unlock_kernel();
+	tty_unlock();
 
 	return 0;
 }
diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index 5ee4248..f02ff21 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -670,9 +670,9 @@ static int ptmx_open(struct inode *inode, struct file *filp)
 {
 	int ret;
 
-	lock_kernel();
+	tty_lock();
 	ret = __ptmx_open(inode, filp);
-	unlock_kernel();
+	tty_unlock();
 	return ret;
 }
 
diff --git a/drivers/char/riscom8.c b/drivers/char/riscom8.c
index 0a8d1e5..9c94103 100644
--- a/drivers/char/riscom8.c
+++ b/drivers/char/riscom8.c
@@ -1241,14 +1241,14 @@ static int rc_ioctl(struct tty_struct *tty, struct file *filp,
 
 	switch (cmd) {
 	case TIOCGSERIAL:
-		lock_kernel();
+		tty_lock();
 		retval = rc_get_serial_info(port, argp);
-		unlock_kernel();
+		tty_unlock();
 		break;
 	case TIOCSSERIAL:
-		lock_kernel();
+		tty_lock();
 		retval = rc_set_serial_info(tty, port, argp);
-		unlock_kernel();
+		tty_unlock();
 		break;
 	default:
 		retval = -ENOIOCTLCMD;
diff --git a/drivers/char/rocket.c b/drivers/char/rocket.c
index 0e29a23..0992a50 100644
--- a/drivers/char/rocket.c
+++ b/drivers/char/rocket.c
@@ -1325,7 +1325,7 @@ static int rp_ioctl(struct tty_struct *tty, struct file *file,
 	if (cmd != RCKP_GET_PORTS && rocket_paranoia_check(info, "rp_ioctl"))
 		return -ENXIO;
 
-	lock_kernel();
+	tty_lock();
 
 	switch (cmd) {
 	case RCKP_GET_STRUCT:
@@ -1350,7 +1350,7 @@ static int rp_ioctl(struct tty_struct *tty, struct file *file,
 	default:
 		ret = -ENOIOCTLCMD;
 	}
-	unlock_kernel();
+	tty_unlock();
 	return ret;
 }
 
@@ -1471,7 +1471,7 @@ static void rp_wait_until_sent(struct tty_struct *tty, int timeout)
 	       jiffies);
 	printk(KERN_INFO "cps=%d...\n", info->cps);
 #endif
-	lock_kernel();
+	tty_lock_nested();
 	while (1) {
 		txcnt = sGetTxCnt(cp);
 		if (!txcnt) {
@@ -1499,7 +1499,7 @@ static void rp_wait_until_sent(struct tty_struct *tty, int timeout)
 			break;
 	}
 	__set_current_state(TASK_RUNNING);
-	unlock_kernel();
+	tty_unlock();
 #ifdef ROCKET_DEBUG_WAIT_UNTIL_SENT
 	printk(KERN_INFO "txcnt = %d (jiff=%lu)...done\n", txcnt, jiffies);
 #endif
diff --git a/drivers/char/serial167.c b/drivers/char/serial167.c
index 1ec3d5c..809cf86 100644
--- a/drivers/char/serial167.c
+++ b/drivers/char/serial167.c
@@ -1536,7 +1536,7 @@ cy_ioctl(struct tty_struct *tty, struct file *file,
 	printk("cy_ioctl %s, cmd = %x arg = %lx\n", tty->name, cmd, arg);	/* */
 #endif
 
-	lock_kernel();
+	tty_lock();
 
 	switch (cmd) {
 	case CYGETMON:
@@ -1592,7 +1592,7 @@ cy_ioctl(struct tty_struct *tty, struct file *file,
 	default:
 		ret_val = -ENOIOCTLCMD;
 	}
-	unlock_kernel();
+	tty_unlock();
 
 #ifdef SERIAL_DEBUG_OTHER
 	printk("cy_ioctl done\n");
diff --git a/drivers/char/specialix.c b/drivers/char/specialix.c
index 07ac14d..35a739c 100644
--- a/drivers/char/specialix.c
+++ b/drivers/char/specialix.c
@@ -1862,7 +1862,7 @@ static int sx_set_serial_info(struct specialix_port *port,
 		return -EFAULT;
 	}
 
-	lock_kernel();
+	tty_lock();
 
 	change_speed = ((port->port.flags & ASYNC_SPD_MASK) !=
 			(tmp.flags & ASYNC_SPD_MASK));
@@ -1874,7 +1874,7 @@ static int sx_set_serial_info(struct specialix_port *port,
 		    ((tmp.flags & ~ASYNC_USR_MASK) !=
 		     (port->port.flags & ~ASYNC_USR_MASK))) {
 			func_exit();
-			unlock_kernel();
+			tty_unlock();
 			return -EPERM;
 		}
 		port->port.flags = ((port->port.flags & ~ASYNC_USR_MASK) |
@@ -1891,7 +1891,7 @@ static int sx_set_serial_info(struct specialix_port *port,
 		sx_change_speed(bp, port);
 
 	func_exit();
-	unlock_kernel();
+	tty_unlock();
 	return 0;
 }
 
@@ -1905,7 +1905,7 @@ static int sx_get_serial_info(struct specialix_port *port,
 	func_enter();
 
 	memset(&tmp, 0, sizeof(tmp));
-	lock_kernel();
+	tty_lock();
 	tmp.type = PORT_CIRRUS;
 	tmp.line = port - sx_port;
 	tmp.port = bp->base;
@@ -1916,7 +1916,7 @@ static int sx_get_serial_info(struct specialix_port *port,
 	tmp.closing_wait = port->port.closing_wait * HZ/100;
 	tmp.custom_divisor =  port->custom_divisor;
 	tmp.xmit_fifo_size = CD186x_NFIFO;
-	unlock_kernel();
+	tty_unlock();
 	if (copy_to_user(retinfo, &tmp, sizeof(tmp))) {
 		func_exit();
 		return -EFAULT;
diff --git a/drivers/char/stallion.c b/drivers/char/stallion.c
index 0e511d6..0637b79 100644
--- a/drivers/char/stallion.c
+++ b/drivers/char/stallion.c
@@ -807,7 +807,7 @@ static void stl_waituntilsent(struct tty_struct *tty, int timeout)
 		timeout = HZ;
 	tend = jiffies + timeout;
 
-	lock_kernel();
+	tty_lock_nested();
 	while (stl_datastate(portp)) {
 		if (signal_pending(current))
 			break;
@@ -815,7 +815,7 @@ static void stl_waituntilsent(struct tty_struct *tty, int timeout)
 		if (time_after_eq(jiffies, tend))
 			break;
 	}
-	unlock_kernel();
+	tty_unlock();
 }
 
 /*****************************************************************************/
@@ -1146,7 +1146,7 @@ static int stl_ioctl(struct tty_struct *tty, struct file *file, unsigned int cmd
 
 	rc = 0;
 
-	lock_kernel();
+	tty_lock();
 
 	switch (cmd) {
 	case TIOCGSERIAL:
@@ -1172,7 +1172,7 @@ static int stl_ioctl(struct tty_struct *tty, struct file *file, unsigned int cmd
 		rc = -ENOIOCTLCMD;
 		break;
 	}
-	unlock_kernel();
+	tty_unlock();
 	return rc;
 }
 
@@ -2450,7 +2450,7 @@ static long stl_memioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 		return -ENODEV;
 	rc = 0;
 
-	lock_kernel();
+	tty_lock();
 	switch (cmd) {
 	case COM_GETPORTSTATS:
 		rc = stl_getportstats(NULL, NULL, argp);
@@ -2471,7 +2471,7 @@ static long stl_memioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 		rc = -ENOIOCTLCMD;
 		break;
 	}
-	unlock_kernel();
+	tty_unlock();
 	return rc;
 }
 
diff --git a/drivers/char/sx.c b/drivers/char/sx.c
index a81ec4f..5b24db4 100644
--- a/drivers/char/sx.c
+++ b/drivers/char/sx.c
@@ -1699,7 +1699,7 @@ static long sx_fw_ioctl(struct file *filp, unsigned int cmd,
 	if (!capable(CAP_SYS_RAWIO))
 		return -EPERM;
 
-	lock_kernel();
+	tty_lock();
 
 	sx_dprintk(SX_DEBUG_FIRMWARE, "IOCTL %x: %lx\n", cmd, arg);
 
@@ -1848,7 +1848,7 @@ static long sx_fw_ioctl(struct file *filp, unsigned int cmd,
 		break;
 	}
 out:
-	unlock_kernel();
+	tty_unlock();
 	func_exit();
 	return rc;
 }
@@ -1859,7 +1859,7 @@ static int sx_break(struct tty_struct *tty, int flag)
 	int rv;
 
 	func_enter();
-	lock_kernel();
+	tty_lock();
 
 	if (flag)
 		rv = sx_send_command(port, HS_START, -1, HS_IDLE_BREAK);
@@ -1868,7 +1868,7 @@ static int sx_break(struct tty_struct *tty, int flag)
 	if (rv != 1)
 		printk(KERN_ERR "sx: couldn't send break (%x).\n",
 			read_sx_byte(port->board, CHAN_OFFSET(port, hi_hstat)));
-	unlock_kernel();
+	tty_unlock();
 	func_exit();
 	return 0;
 }
@@ -1909,7 +1909,7 @@ static int sx_ioctl(struct tty_struct *tty, struct file *filp,
 	/* func_enter2(); */
 
 	rc = 0;
-	lock_kernel();
+	tty_lock();
 	switch (cmd) {
 	case TIOCGSERIAL:
 		rc = gs_getserial(&port->gs, argp);
@@ -1921,7 +1921,7 @@ static int sx_ioctl(struct tty_struct *tty, struct file *filp,
 		rc = -ENOIOCTLCMD;
 		break;
 	}
-	unlock_kernel();
+	tty_unlock();
 
 	/* func_exit(); */
 	return rc;
diff --git a/drivers/char/synclink.c b/drivers/char/synclink.c
index 0658fc5..c7af06b 100644
--- a/drivers/char/synclink.c
+++ b/drivers/char/synclink.c
@@ -2950,9 +2950,9 @@ static int mgsl_ioctl(struct tty_struct *tty, struct file * file,
 		    return -EIO;
 	}
 
-	lock_kernel();
+	tty_lock();
 	ret = mgsl_ioctl_common(info, cmd, arg);
-	unlock_kernel();
+	tty_unlock();
 	return ret;
 }
 
@@ -3162,7 +3162,7 @@ static void mgsl_wait_until_sent(struct tty_struct *tty, int timeout)
 	 * Note: use tight timings here to satisfy the NIST-PCTS.
 	 */ 
 
-	lock_kernel();
+	tty_lock_nested();
 	if ( info->params.data_rate ) {
 	       	char_time = info->timeout/(32 * 5);
 		if (!char_time)
@@ -3192,7 +3192,7 @@ static void mgsl_wait_until_sent(struct tty_struct *tty, int timeout)
 				break;
 		}
 	}
-	unlock_kernel();
+	tty_unlock();
       
 exit:
 	if (debug_level >= DEBUG_LEVEL_INFO)
diff --git a/drivers/char/synclink_gt.c b/drivers/char/synclink_gt.c
index 4561ce2..d75de68 100644
--- a/drivers/char/synclink_gt.c
+++ b/drivers/char/synclink_gt.c
@@ -901,7 +901,7 @@ static void wait_until_sent(struct tty_struct *tty, int timeout)
 	 * Note: use tight timings here to satisfy the NIST-PCTS.
 	 */
 
-	lock_kernel();
+	tty_lock_nested();
 
 	if (info->params.data_rate) {
 	       	char_time = info->timeout/(32 * 5);
@@ -920,7 +920,7 @@ static void wait_until_sent(struct tty_struct *tty, int timeout)
 		if (timeout && time_after(jiffies, orig_jiffies + timeout))
 			break;
 	}
-	unlock_kernel();
+	tty_unlock();
 
 exit:
 	DBGINFO(("%s wait_until_sent exit\n", info->device_name));
@@ -1041,7 +1041,7 @@ static int ioctl(struct tty_struct *tty, struct file *file,
 		    return -EIO;
 	}
 
-	lock_kernel();
+	tty_lock();
 
 	switch (cmd) {
 	case MGSL_IOCGPARAMS:
@@ -1111,7 +1111,7 @@ static int ioctl(struct tty_struct *tty, struct file *file,
 	default:
 		ret = -ENOIOCTLCMD;
 	}
-	unlock_kernel();
+	tty_unlock();
 	return ret;
 }
 
diff --git a/drivers/char/synclinkmp.c b/drivers/char/synclinkmp.c
index 2b18adc..7b7c108 100644
--- a/drivers/char/synclinkmp.c
+++ b/drivers/char/synclinkmp.c
@@ -1062,7 +1062,7 @@ static void wait_until_sent(struct tty_struct *tty, int timeout)
 	if (sanity_check(info, tty->name, "wait_until_sent"))
 		return;
 
-	lock_kernel();
+	tty_lock_nested();
 
 	if (!(info->port.flags & ASYNC_INITIALIZED))
 		goto exit;
@@ -1106,7 +1106,7 @@ static void wait_until_sent(struct tty_struct *tty, int timeout)
 	}
 
 exit:
-	unlock_kernel();
+	tty_unlock();
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):%s wait_until_sent() exit\n",
 			 __FILE__,__LINE__, info->device_name );
@@ -1122,7 +1122,7 @@ static int write_room(struct tty_struct *tty)
 	if (sanity_check(info, tty->name, "write_room"))
 		return 0;
 
-	lock_kernel();
+	tty_lock_nested();
 	if (info->params.mode == MGSL_MODE_HDLC) {
 		ret = (info->tx_active) ? 0 : HDLC_MAX_FRAME_SIZE;
 	} else {
@@ -1130,7 +1130,7 @@ static int write_room(struct tty_struct *tty)
 		if (ret < 0)
 			ret = 0;
 	}
-	unlock_kernel();
+	tty_unlock();
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):%s write_room()=%d\n",
@@ -1345,9 +1345,9 @@ static int ioctl(struct tty_struct *tty, struct file *file,
 		 unsigned int cmd, unsigned long arg)
 {
 	int ret;
-	lock_kernel();
+	tty_lock();
 	ret = do_ioctl(tty, file, cmd, arg);
-	unlock_kernel();
+	tty_unlock();
 	return ret;
 }
 
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index a42c466..25b82eb 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -149,6 +149,7 @@ static long tty_compat_ioctl(struct file *file, unsigned int cmd,
 #else
 #define tty_compat_ioctl NULL
 #endif
+static int __tty_fasync(int fd, struct file *filp, int on);
 static int tty_fasync(int fd, struct file *filp, int on);
 static void release_tty(struct tty_struct *tty, int idx);
 static void __proc_set_tty(struct task_struct *tsk, struct tty_struct *tty);
@@ -483,7 +484,7 @@ EXPORT_SYMBOL_GPL(tty_wakeup);
  *	remains intact.
  *
  *	Locking:
- *		BKL
+ *		BTM
  *		  redirect lock for undoing redirection
  *		  file list lock for manipulating list of ttys
  *		  tty_ldisc_lock from called functions
@@ -513,8 +514,11 @@ static void do_tty_hangup(struct work_struct *work)
 	}
 	spin_unlock(&redirect_lock);
 
-	/* inuse_filps is protected by the single kernel lock */
-	lock_kernel();
+	/* inuse_filps is protected by the single tty lock,
+	   this really needs to change if we want to flush the
+	   workqueue with the lock held */
+	tty_lock_nested(); /* called with BTM held from pty_close and
+				others */
 	check_tty_count(tty, "do_tty_hangup");
 
 	file_list_lock();
@@ -525,7 +529,7 @@ static void do_tty_hangup(struct work_struct *work)
 		if (filp->f_op->write != tty_write)
 			continue;
 		closecount++;
-		tty_fasync(-1, filp, 0);	/* can't block */
+		__tty_fasync(-1, filp, 0);	/* can't block */
 		filp->f_op = &hung_up_tty_fops;
 	}
 	file_list_unlock();
@@ -594,7 +598,7 @@ static void do_tty_hangup(struct work_struct *work)
 	 */
 	set_bit(TTY_HUPPED, &tty->flags);
 	tty_ldisc_enable(tty);
-	unlock_kernel();
+	tty_unlock();
 	if (f)
 		fput(f);
 }
@@ -696,7 +700,8 @@ static void session_clear_tty(struct pid *session)
  *	exiting; it is 0 if called by the ioctl TIOCNOTTY.
  *
  *	Locking:
- *		BKL is taken for hysterical raisins
+ *		BTM is taken for hysterical raisins, and held when
+ *		  called from no_tty().
  *		  tty_mutex is taken to protect tty
  *		  ->siglock is taken to protect ->signal/->sighand
  *		  tasklist_lock is taken to walk process list for sessions
@@ -714,10 +719,10 @@ void disassociate_ctty(int on_exit)
 	tty = get_current_tty();
 	if (tty) {
 		tty_pgrp = get_pid(tty->pgrp);
-		lock_kernel();
+		tty_lock_nested();
 		if (on_exit && tty->driver->type != TTY_DRIVER_TYPE_PTY)
 			tty_vhangup(tty);
-		unlock_kernel();
+		tty_unlock();
 		tty_kref_put(tty);
 	} else if (on_exit) {
 		struct pid *old_pgrp;
@@ -774,9 +779,9 @@ void disassociate_ctty(int on_exit)
 void no_tty(void)
 {
 	struct task_struct *tsk = current;
-	lock_kernel();
+	tty_lock();
 	disassociate_ctty(0);
-	unlock_kernel();
+	tty_unlock();
 	proc_clear_tty(tsk);
 }
 
@@ -1013,19 +1018,19 @@ out:
  * We don't put it into the syslog queue right now maybe in the future if
  * really needed.
  *
- * We must still hold the BKL and test the CLOSING flag for the moment.
+ * We must still hold the BTM and test the CLOSING flag for the moment.
  */
 
 void tty_write_message(struct tty_struct *tty, char *msg)
 {
 	if (tty) {
 		mutex_lock(&tty->atomic_write_lock);
-		lock_kernel();
+		tty_lock();
 		if (tty->ops->write && !test_bit(TTY_CLOSING, &tty->flags)) {
-			unlock_kernel();
+			tty_unlock();
 			tty->ops->write(tty, msg, strlen(msg));
 		} else
-			unlock_kernel();
+			tty_unlock();
 		tty_write_unlock(tty);
 	}
 	return;
@@ -1208,18 +1213,18 @@ static int tty_driver_install_tty(struct tty_driver *driver,
 	int ret;
 
 	if (driver->ops->install) {
-		lock_kernel();
+		tty_lock_nested(); /* already called with BTM held */
 		ret = driver->ops->install(driver, tty);
-		unlock_kernel();
+		tty_unlock();
 		return ret;
 	}
 
 	if (tty_init_termios(tty) == 0) {
-		lock_kernel();
+		tty_lock_nested();
 		tty_driver_kref_get(driver);
 		tty->count++;
 		driver->ttys[idx] = tty;
-		unlock_kernel();
+		tty_unlock();
 		return 0;
 	}
 	return -ENOMEM;
@@ -1312,14 +1317,15 @@ struct tty_struct *tty_init_dev(struct tty_driver *driver, int idx,
 	struct tty_struct *tty;
 	int retval;
 
-	lock_kernel();
+	tty_lock_nested(); /* always called with tty lock held already */
+
 	/* Check if pty master is being opened multiple times */
 	if (driver->subtype == PTY_TYPE_MASTER &&
 		(driver->flags & TTY_DRIVER_DEVPTS_MEM) && !first_ok) {
-		unlock_kernel();
+		tty_unlock();
 		return ERR_PTR(-EIO);
 	}
-	unlock_kernel();
+	tty_unlock();
 
 	/*
 	 * First time open is complex, especially for PTY devices.
@@ -1363,9 +1369,9 @@ release_mem_out:
 	if (printk_ratelimit())
 		printk(KERN_INFO "tty_init_dev: ldisc open failed, "
 				 "clearing slot %d\n", idx);
-	lock_kernel();
+	tty_lock_nested();
 	release_tty(tty, idx);
-	unlock_kernel();
+	tty_unlock();
 	return ERR_PTR(retval);
 }
 
@@ -1510,10 +1516,10 @@ int tty_release(struct inode *inode, struct file *filp)
 	if (tty_paranoia_check(tty, inode, "tty_release_dev"))
 		return 0;
 
-	lock_kernel();
+	tty_lock();
 	check_tty_count(tty, "tty_release_dev");
 
-	tty_fasync(-1, filp, 0);
+	__tty_fasync(-1, filp, 0);
 
 	idx = tty->index;
 	pty_master = (tty->driver->type == TTY_DRIVER_TYPE_PTY &&
@@ -1525,18 +1531,18 @@ int tty_release(struct inode *inode, struct file *filp)
 	if (idx < 0 || idx >= tty->driver->num) {
 		printk(KERN_DEBUG "tty_release_dev: bad idx when trying to "
 				  "free (%s)\n", tty->name);
-		unlock_kernel();
+		tty_unlock();
 		return 0;
 	}
 	if (!devpts) {
 		if (tty != tty->driver->ttys[idx]) {
-			unlock_kernel();
+			tty_unlock();
 			printk(KERN_DEBUG "tty_release_dev: driver.table[%d] not tty "
 			       "for (%s)\n", idx, tty->name);
 			return 0;
 		}
 		if (tty->termios != tty->driver->termios[idx]) {
-			unlock_kernel();
+			tty_unlock();
 			printk(KERN_DEBUG "tty_release_dev: driver.termios[%d] not termios "
 			       "for (%s)\n",
 			       idx, tty->name);
@@ -1554,21 +1560,21 @@ int tty_release(struct inode *inode, struct file *filp)
 	if (tty->driver->other &&
 	     !(tty->driver->flags & TTY_DRIVER_DEVPTS_MEM)) {
 		if (o_tty != tty->driver->other->ttys[idx]) {
-			unlock_kernel();
+			tty_unlock();
 			printk(KERN_DEBUG "tty_release_dev: other->table[%d] "
 					  "not o_tty for (%s)\n",
 			       idx, tty->name);
 			return 0 ;
 		}
 		if (o_tty->termios != tty->driver->other->termios[idx]) {
-			unlock_kernel();
+			tty_unlock();
 			printk(KERN_DEBUG "tty_release_dev: other->termios[%d] "
 					  "not o_termios for (%s)\n",
 			       idx, tty->name);
 			return 0;
 		}
 		if (o_tty->link != tty) {
-			unlock_kernel();
+			tty_unlock();
 			printk(KERN_DEBUG "tty_release_dev: bad pty pointers\n");
 			return 0;
 		}
@@ -1577,7 +1583,7 @@ int tty_release(struct inode *inode, struct file *filp)
 	if (tty->ops->close)
 		tty->ops->close(tty, filp);
 
-	unlock_kernel();
+	tty_unlock();
 	/*
 	 * Sanity check: if tty->count is going to zero, there shouldn't be
 	 * any waiters on tty->read_wait or tty->write_wait.  We test the
@@ -1600,7 +1606,7 @@ int tty_release(struct inode *inode, struct file *filp)
 		   opens on /dev/tty */
 
 		mutex_lock(&tty_mutex);
-		lock_kernel();
+		tty_lock();
 		tty_closing = tty->count <= 1;
 		o_tty_closing = o_tty &&
 			(o_tty->count <= (pty_master ? 1 : 0));
@@ -1631,7 +1637,7 @@ int tty_release(struct inode *inode, struct file *filp)
 
 		printk(KERN_WARNING "tty_release_dev: %s: read/write wait queue "
 				    "active!\n", tty_name(tty, buf));
-		unlock_kernel();
+		tty_unlock();
 		mutex_unlock(&tty_mutex);
 		schedule();
 	}
@@ -1696,7 +1702,7 @@ int tty_release(struct inode *inode, struct file *filp)
 
 	/* check whether both sides are closing ... */
 	if (!tty_closing || (o_tty && !o_tty_closing)) {
-		unlock_kernel();
+		tty_unlock();
 		return 0;
 	}
 
@@ -1716,7 +1722,7 @@ int tty_release(struct inode *inode, struct file *filp)
 	/* Make this pty number available for reallocation */
 	if (devpts)
 		devpts_kill_index(inode, idx);
-	unlock_kernel();
+	tty_unlock();
 	return 0;
 }
 
@@ -1758,12 +1764,12 @@ retry_open:
 	retval = 0;
 
 	mutex_lock(&tty_mutex);
-	lock_kernel();
+	tty_lock();
 
 	if (device == MKDEV(TTYAUX_MAJOR, 0)) {
 		tty = get_current_tty();
 		if (!tty) {
-			unlock_kernel();
+			tty_unlock();
 			mutex_unlock(&tty_mutex);
 			return -ENXIO;
 		}
@@ -1795,14 +1801,14 @@ retry_open:
 				goto got_driver;
 			}
 		}
-		unlock_kernel();
+		tty_unlock();
 		mutex_unlock(&tty_mutex);
 		return -ENODEV;
 	}
 
 	driver = get_tty_driver(device, &index);
 	if (!driver) {
-		unlock_kernel();
+		tty_unlock();
 		mutex_unlock(&tty_mutex);
 		return -ENODEV;
 	}
@@ -1812,7 +1818,7 @@ got_driver:
 		tty = tty_driver_lookup_tty(driver, inode, index);
 
 		if (IS_ERR(tty)) {
-			unlock_kernel();
+			tty_unlock();
 			mutex_unlock(&tty_mutex);
 			return PTR_ERR(tty);
 		}
@@ -1828,7 +1834,7 @@ got_driver:
 	mutex_unlock(&tty_mutex);
 	tty_driver_kref_put(driver);
 	if (IS_ERR(tty)) {
-		unlock_kernel();
+		tty_unlock();
 		return PTR_ERR(tty);
 	}
 
@@ -1860,11 +1866,11 @@ got_driver:
 #endif
 		tty_release(inode, filp);
 		if (retval != -ERESTARTSYS) {
-			unlock_kernel();
+			tty_unlock();
 			return retval;
 		}
 		if (signal_pending(current)) {
-			unlock_kernel();
+			tty_unlock();
 			return retval;
 		}
 		schedule();
@@ -1875,11 +1881,11 @@ got_driver:
 			filp->f_op = &tty_fops;
 		goto retry_open;
 	}
-	unlock_kernel();
+	tty_unlock();
 
 
 	mutex_lock(&tty_mutex);
-	lock_kernel();
+	tty_lock();
 	spin_lock_irq(&current->sighand->siglock);
 	if (!noctty &&
 	    current->signal->leader &&
@@ -1887,7 +1893,7 @@ got_driver:
 	    tty->session == NULL)
 		__proc_set_tty(current, tty);
 	spin_unlock_irq(&current->sighand->siglock);
-	unlock_kernel();
+	tty_unlock();
 	mutex_unlock(&tty_mutex);
 	return 0;
 }
@@ -1923,13 +1929,12 @@ static unsigned int tty_poll(struct file *filp, poll_table *wait)
 	return ret;
 }
 
-static int tty_fasync(int fd, struct file *filp, int on)
+static int __tty_fasync(int fd, struct file *filp, int on)
 {
 	struct tty_struct *tty;
 	unsigned long flags;
 	int retval = 0;
 
-	lock_kernel();
 	tty = (struct tty_struct *)filp->private_data;
 	if (tty_paranoia_check(tty, filp->f_path.dentry->d_inode, "tty_fasync"))
 		goto out;
@@ -1963,7 +1968,15 @@ static int tty_fasync(int fd, struct file *filp, int on)
 	}
 	retval = 0;
 out:
-	unlock_kernel();
+	return retval;
+}
+
+static int tty_fasync(int fd, struct file *filp, int on)
+{
+	int retval;
+	tty_lock();
+	retval = __tty_fasync(fd, filp, on);
+	tty_unlock();
 	return retval;
 }
 
diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index 500e740..bddbe62 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -447,10 +447,10 @@ static int tty_ldisc_open(struct tty_struct *tty, struct tty_ldisc *ld)
 	WARN_ON(test_and_set_bit(TTY_LDISC_OPEN, &tty->flags));
 	if (ld->ops->open) {
 		int ret;
-                /* BKL here locks verus a hangup event */
-		lock_kernel();
+                /* BTM here locks versus a hangup event */
+		tty_lock_nested();
 		ret = ld->ops->open(tty);
-		unlock_kernel();
+		tty_unlock();
 		return ret;
 	}
 	return 0;
@@ -553,7 +553,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 	if (IS_ERR(new_ldisc))
 		return PTR_ERR(new_ldisc);
 
-	lock_kernel();
+	tty_lock();
 	/*
 	 *	We need to look at the tty locking here for pty/tty pairs
 	 *	when both sides try to change in parallel.
@@ -567,12 +567,12 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 	 */
 
 	if (tty->ldisc->ops->num == ldisc) {
-		unlock_kernel();
+		tty_unlock();
 		tty_ldisc_put(new_ldisc);
 		return 0;
 	}
 
-	unlock_kernel();
+	tty_unlock();
 	/*
 	 *	Problem: What do we do if this blocks ?
 	 *	We could deadlock here
@@ -594,7 +594,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 		mutex_lock(&tty->ldisc_mutex);
 	}
 
-	lock_kernel();
+	tty_lock();
 
 	set_bit(TTY_LDISC_CHANGING, &tty->flags);
 
@@ -607,7 +607,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 
 	o_ldisc = tty->ldisc;
 
-	unlock_kernel();
+	tty_unlock();
 	/*
 	 *	Make sure we don't change while someone holds a
 	 *	reference to the line discipline. The TTY_LDISC bit
@@ -633,14 +633,14 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 	flush_scheduled_work();
 
 	mutex_lock(&tty->ldisc_mutex);
-	lock_kernel();
+	tty_lock();
 	if (test_bit(TTY_HUPPED, &tty->flags)) {
 		/* We were raced by the hangup method. It will have stomped
 		   the ldisc data and closed the ldisc down */
 		clear_bit(TTY_LDISC_CHANGING, &tty->flags);
 		mutex_unlock(&tty->ldisc_mutex);
 		tty_ldisc_put(new_ldisc);
-		unlock_kernel();
+		tty_unlock();
 		return -EIO;
 	}
 
@@ -682,7 +682,7 @@ int tty_set_ldisc(struct tty_struct *tty, int ldisc)
 	if (o_work)
 		schedule_delayed_work(&o_tty->buf.work, 1);
 	mutex_unlock(&tty->ldisc_mutex);
-	unlock_kernel();
+	tty_unlock();
 	return retval;
 }
 
diff --git a/drivers/char/vc_screen.c b/drivers/char/vc_screen.c
index c1791a6..bcce46c 100644
--- a/drivers/char/vc_screen.c
+++ b/drivers/char/vc_screen.c
@@ -463,10 +463,10 @@ vcs_open(struct inode *inode, struct file *filp)
 	unsigned int currcons = iminor(inode) & 127;
 	int ret = 0;
 	
-	lock_kernel();
+	tty_lock();
 	if(currcons && !vc_cons_allocated(currcons-1))
 		ret = -ENXIO;
-	unlock_kernel();
+	tty_unlock();
 	return ret;
 }
 
diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index bd1d116..47e029c 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -2604,7 +2604,7 @@ int tioclinux(struct tty_struct *tty, unsigned long arg)
 		return -EFAULT;
 	ret = 0;
 
-	lock_kernel();
+	tty_lock_nested(); /* already held, always */
 
 	switch (type)
 	{
@@ -2680,7 +2680,7 @@ int tioclinux(struct tty_struct *tty, unsigned long arg)
 			ret = -EINVAL;
 			break;
 	}
-	unlock_kernel();
+	tty_unlock();
 	return ret;
 }
 
diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
index 6aa1028..0ebda0e 100644
--- a/drivers/char/vt_ioctl.c
+++ b/drivers/char/vt_ioctl.c
@@ -509,7 +509,7 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
 
 	console = vc->vc_num;
 
-	lock_kernel();
+	tty_lock();
 
 	if (!vc_cons_allocated(console)) { 	/* impossible? */
 		ret = -ENOIOCTLCMD;
@@ -1334,7 +1334,7 @@ int vt_ioctl(struct tty_struct *tty, struct file * file,
 		ret = -ENOIOCTLCMD;
 	}
 out:
-	unlock_kernel();
+	tty_unlock();
 	return ret;
 eperm:
 	ret = -EPERM;
@@ -1501,7 +1501,7 @@ long vt_compat_ioctl(struct tty_struct *tty, struct file * file,
 
 	console = vc->vc_num;
 
-	lock_kernel();
+	tty_lock();
 
 	if (!vc_cons_allocated(console)) { 	/* impossible? */
 		ret = -ENOIOCTLCMD;
@@ -1569,11 +1569,11 @@ long vt_compat_ioctl(struct tty_struct *tty, struct file * file,
 		goto fallback;
 	}
 out:
-	unlock_kernel();
+	tty_unlock();
 	return ret;
 
 fallback:
-	unlock_kernel();
+	tty_unlock();
 	return vt_ioctl(tty, file, cmd, arg);
 }
 
diff --git a/drivers/isdn/i4l/isdn_common.c b/drivers/isdn/i4l/isdn_common.c
index 00c60e2..94f7727 100644
--- a/drivers/isdn/i4l/isdn_common.c
+++ b/drivers/isdn/i4l/isdn_common.c
@@ -1069,7 +1069,7 @@ isdn_read(struct file *file, char __user *buf, size_t count, loff_t * off)
 	int retval;
 	char *p;
 
-	lock_kernel();
+	tty_lock();
 	if (minor == ISDN_MINOR_STATUS) {
 		if (!file->private_data) {
 			if (file->f_flags & O_NONBLOCK) {
@@ -1162,7 +1162,7 @@ isdn_read(struct file *file, char __user *buf, size_t count, loff_t * off)
 #endif
 	retval = -ENODEV;
  out:
-	unlock_kernel();
+	tty_unlock();
 	return retval;
 }
 
@@ -1179,7 +1179,7 @@ isdn_write(struct file *file, const char __user *buf, size_t count, loff_t * off
 	if (!dev->drivers)
 		return -ENODEV;
 
-	lock_kernel();
+	tty_lock();
 	if (minor <= ISDN_MINOR_BMAX) {
 		printk(KERN_WARNING "isdn_write minor %d obsolete!\n", minor);
 		drvidx = isdn_minor2drv(minor);
@@ -1224,7 +1224,7 @@ isdn_write(struct file *file, const char __user *buf, size_t count, loff_t * off
 #endif
 	retval = -ENODEV;
  out:
-	unlock_kernel();
+	tty_unlock();
 	return retval;
 }
 
@@ -1235,7 +1235,7 @@ isdn_poll(struct file *file, poll_table * wait)
 	unsigned int minor = iminor(file->f_path.dentry->d_inode);
 	int drvidx = isdn_minor2drv(minor - ISDN_MINOR_CTRL);
 
-	lock_kernel();
+	tty_lock();
 	if (minor == ISDN_MINOR_STATUS) {
 		poll_wait(file, &(dev->info_waitq), wait);
 		/* mask = POLLOUT | POLLWRNORM; */
@@ -1265,7 +1265,7 @@ isdn_poll(struct file *file, poll_table * wait)
 #endif
 	mask = POLLERR;
  out:
-	unlock_kernel();
+	tty_unlock();
 	return mask;
 }
 
@@ -1732,7 +1732,7 @@ isdn_open(struct inode *ino, struct file *filep)
 	int chidx;
 	int retval = -ENODEV;
 
-	lock_kernel();
+	tty_lock();
 	if (minor == ISDN_MINOR_STATUS) {
 		infostruct *p;
 
@@ -1783,7 +1783,7 @@ isdn_open(struct inode *ino, struct file *filep)
 #endif
  out:
 	nonseekable_open(ino, filep);
-	unlock_kernel();
+	tty_unlock();
 	return retval;
 }
 
@@ -1792,7 +1792,7 @@ isdn_close(struct inode *ino, struct file *filep)
 {
 	uint minor = iminor(ino);
 
-	lock_kernel();
+	tty_lock();
 	if (minor == ISDN_MINOR_STATUS) {
 		infostruct *p = dev->infochain;
 		infostruct *q = NULL;
@@ -1826,7 +1826,7 @@ isdn_close(struct inode *ino, struct file *filep)
 #endif
 
  out:
-	unlock_kernel();
+	tty_unlock();
 	return 0;
 }
 
diff --git a/drivers/isdn/i4l/isdn_tty.c b/drivers/isdn/i4l/isdn_tty.c
index 2881a66..279277e 100644
--- a/drivers/isdn/i4l/isdn_tty.c
+++ b/drivers/isdn/i4l/isdn_tty.c
@@ -1353,14 +1353,14 @@ isdn_tty_tiocmget(struct tty_struct *tty, struct file *file)
 	if (tty->flags & (1 << TTY_IO_ERROR))
 		return -EIO;
 
-	lock_kernel();
+	tty_lock();
 #ifdef ISDN_DEBUG_MODEM_IOCTL
 	printk(KERN_DEBUG "ttyI%d ioctl TIOCMGET\n", info->line);
 #endif
 
 	control = info->mcr;
 	status = info->msr;
-	unlock_kernel();
+	tty_unlock();
 	return ((control & UART_MCR_RTS) ? TIOCM_RTS : 0)
 	    | ((control & UART_MCR_DTR) ? TIOCM_DTR : 0)
 	    | ((status & UART_MSR_DCD) ? TIOCM_CAR : 0)
@@ -1384,7 +1384,7 @@ isdn_tty_tiocmset(struct tty_struct *tty, struct file *file,
 	printk(KERN_DEBUG "ttyI%d ioctl TIOCMxxx: %x %x\n", info->line, set, clear);
 #endif
 
-	lock_kernel();
+	tty_lock();
 	if (set & TIOCM_RTS)
 		info->mcr |= UART_MCR_RTS;
 	if (set & TIOCM_DTR) {
@@ -1406,7 +1406,7 @@ isdn_tty_tiocmset(struct tty_struct *tty, struct file *file,
 			isdn_tty_modem_hup(info, 1);
 		}
 	}
-	unlock_kernel();
+	tty_unlock();
 	return 0;
 }
 
diff --git a/drivers/serial/68360serial.c b/drivers/serial/68360serial.c
index 24661cd..5a2fc1b 100644
--- a/drivers/serial/68360serial.c
+++ b/drivers/serial/68360serial.c
@@ -1705,7 +1705,7 @@ static void rs_360_wait_until_sent(struct tty_struct *tty, int timeout)
 	printk("jiff=%lu...", jiffies);
 #endif
 
-	lock_kernel();
+	tty_lock_nested();
 	/* We go through the loop at least once because we can't tell
 	 * exactly when the last character exits the shifter.  There can
 	 * be at least two characters waiting to be sent after the buffers
@@ -1734,7 +1734,7 @@ static void rs_360_wait_until_sent(struct tty_struct *tty, int timeout)
 			bdp--;
 	} while (bdp->status & BD_SC_READY);
 	current->state = TASK_RUNNING;
-	unlock_kernel();
+	tty_unlock();
 #ifdef SERIAL_DEBUG_RS_WAIT_UNTIL_SENT
 	printk("lsr = %d (jiff=%lu)...done\n", lsr, jiffies);
 #endif
diff --git a/drivers/serial/crisv10.c b/drivers/serial/crisv10.c
index 31f1723..0facf63 100644
--- a/drivers/serial/crisv10.c
+++ b/drivers/serial/crisv10.c
@@ -3924,7 +3924,7 @@ static void rs_wait_until_sent(struct tty_struct *tty, int timeout)
 	 * Check R_DMA_CHx_STATUS bit 0-6=number of available bytes in FIFO
 	 * R_DMA_CHx_HWSW bit 31-16=nbr of bytes left in DMA buffer (0=64k)
 	 */
-	lock_kernel();
+	tty_lock_nested();
 	orig_jiffies = jiffies;
 	while (info->xmit.head != info->xmit.tail || /* More in send queue */
 	       (*info->ostatusadr & 0x007f) ||  /* more in FIFO */
@@ -3941,7 +3941,7 @@ static void rs_wait_until_sent(struct tty_struct *tty, int timeout)
 			curr_time_usec - info->last_tx_active_usec;
 	}
 	set_current_state(TASK_RUNNING);
-	unlock_kernel();
+	tty_unlock();
 }
 
 /*
diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 7f28307..1bc580b 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -1273,7 +1273,7 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 	struct tty_port *port;
 	struct uart_port *uport;
 
-	BUG_ON(!kernel_locked());
+	BUG_ON(!tty_locked());
 
 	if (!state)
 		return;
@@ -1369,7 +1369,7 @@ static void uart_wait_until_sent(struct tty_struct *tty, int timeout)
 	if (port->type == PORT_UNKNOWN || port->fifosize == 0)
 		return;
 
-	lock_kernel();
+	tty_lock_nested();
 
 	/*
 	 * Set the check interval to be 1/5 of the estimated time to
@@ -1416,7 +1416,7 @@ static void uart_wait_until_sent(struct tty_struct *tty, int timeout)
 			break;
 	}
 	set_current_state(TASK_RUNNING); /* might not be needed */
-	unlock_kernel();
+	tty_unlock();
 }
 
 /*
@@ -1430,7 +1430,7 @@ static void uart_hangup(struct tty_struct *tty)
 	struct uart_state *state = tty->driver_data;
 	struct tty_port *port = &state->port;
 
-	BUG_ON(!kernel_locked());
+	BUG_ON(!tty_locked());
 	pr_debug("uart_hangup(%d)\n", state->uart_port->line);
 
 	mutex_lock(&port->mutex);
@@ -1611,7 +1611,7 @@ static int uart_open(struct tty_struct *tty, struct file *filp)
 	struct tty_port *port;
 	int retval, line = tty->index;
 
-	BUG_ON(!kernel_locked());
+	BUG_ON(!tty_locked());
 	pr_debug("uart_open(%d) called\n", line);
 
 	/*
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 3873660..3138a29 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -709,17 +709,17 @@ int usb_serial_probe(struct usb_interface *interface,
 	int num_ports = 0;
 	int max_endpoints;
 
-	lock_kernel(); /* guard against unloading a serial driver module */
+	tty_lock(); /* guard against unloading a serial driver module */
 	type = search_serial_device(interface);
 	if (!type) {
-		unlock_kernel();
+		tty_unlock();
 		dbg("none matched");
 		return -ENODEV;
 	}
 
 	serial = create_serial(dev, interface, type);
 	if (!serial) {
-		unlock_kernel();
+		tty_unlock();
 		dev_err(&interface->dev, "%s - out of memory\n", __func__);
 		return -ENOMEM;
 	}
@@ -729,7 +729,7 @@ int usb_serial_probe(struct usb_interface *interface,
 		const struct usb_device_id *id;
 
 		if (!try_module_get(type->driver.owner)) {
-			unlock_kernel();
+			tty_unlock();
 			dev_err(&interface->dev,
 				"module get failed, exiting\n");
 			kfree(serial);
@@ -741,7 +741,7 @@ int usb_serial_probe(struct usb_interface *interface,
 		module_put(type->driver.owner);
 
 		if (retval) {
-			unlock_kernel();
+			tty_unlock();
 			dbg("sub driver rejected device");
 			kfree(serial);
 			return retval;
@@ -813,7 +813,7 @@ int usb_serial_probe(struct usb_interface *interface,
 		 * properly during a later invocation of usb_serial_probe
 		 */
 		if (num_bulk_in == 0 || num_bulk_out == 0) {
-			unlock_kernel();
+			tty_unlock();
 			dev_info(&interface->dev, "PL-2303 hack: descriptors matched but endpoints did not\n");
 			kfree(serial);
 			return -ENODEV;
@@ -826,7 +826,7 @@ int usb_serial_probe(struct usb_interface *interface,
 	if (type == &usb_serial_generic_device) {
 		num_ports = num_bulk_out;
 		if (num_ports == 0) {
-			unlock_kernel();
+			tty_unlock();
 			dev_err(&interface->dev,
 			    "Generic device with no bulk out, not allowed.\n");
 			kfree(serial);
@@ -838,7 +838,7 @@ int usb_serial_probe(struct usb_interface *interface,
 		/* if this device type has a calc_num_ports function, call it */
 		if (type->calc_num_ports) {
 			if (!try_module_get(type->driver.owner)) {
-				unlock_kernel();
+				tty_unlock();
 				dev_err(&interface->dev,
 					"module get failed, exiting\n");
 				kfree(serial);
@@ -869,7 +869,7 @@ int usb_serial_probe(struct usb_interface *interface,
 	max_endpoints = max(max_endpoints, num_interrupt_out);
 	max_endpoints = max(max_endpoints, (int)serial->num_ports);
 	serial->num_port_pointers = max_endpoints;
-	unlock_kernel();
+	tty_unlock();
 
 	dbg("%s - setting up %d port structures for this device",
 						__func__, max_endpoints);
diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
index 182dd6f..6eef126 100644
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -1108,7 +1108,7 @@ static int vgacon_do_font_op(struct vgastate *state,char *arg,int set,int ch512)
 		charmap += 4 * cmapsz;
 #endif
 
-	unlock_kernel();
+	tty_unlock();
 	spin_lock_irq(&vga_lock);
 	/* First, the Sequencer */
 	vga_wseq(state->vgabase, VGA_SEQ_RESET, 0x1);
@@ -1192,7 +1192,7 @@ static int vgacon_do_font_op(struct vgastate *state,char *arg,int set,int ch512)
 		vga_wattr(state->vgabase, VGA_AR_ENABLE_DISPLAY, 0);	
 	}
 	spin_unlock_irq(&vga_lock);
-	lock_kernel();
+	tty_lock_nested();
 	return 0;
 }
 
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 4409967..60b3d69 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -13,6 +13,7 @@
 #include <linux/tty_driver.h>
 #include <linux/tty_ldisc.h>
 #include <linux/mutex.h>
+#include <linux/smp_lock.h>
 
 #include <asm/system.h>
 
@@ -571,5 +572,173 @@ extern int vt_ioctl(struct tty_struct *tty, struct file *file,
 extern long vt_compat_ioctl(struct tty_struct *tty, struct file * file,
 		     unsigned int cmd, unsigned long arg);
 
+/* functions for preparation of BKL removal */
+
+/*
+ * tty_lock_nested get the tty_lock while potentially holding it
+ *
+ * The Big TTY Mutex is a recursive lock, meaning you can take it
+ * from a thread that is already holding it.
+ * This is bad for a number of reasons, so tty_lock_nested should
+ * really be used as rarely as possible. If a code location can
+ * be shown to never get called with this held already, it should
+ * use tty_lock() instead.
+ */ 
+static inline void __lockfunc tty_lock_nested(void) __acquires(kernel_lock)
+{
+	lock_kernel();
+}
+static inline void tty_lock(void) __acquires(kernel_lock)
+{
+	WARN_ON(kernel_locked());
+	lock_kernel();
+}
+static inline void tty_unlock(void) __releases(kernel_lock)
+{
+	unlock_kernel();
+}
+#define tty_locked()		(kernel_locked())
+static inline int __reacquire_tty_lock(void)
+{
+	return 0;
+}
+static inline void __release_tty_lock(void)
+{
+}
+
+#define release_tty_lock(tsk) do { } while (0)
+#define reacquire_tty_lock(tsk) do { } while (0)
+
+/*
+ * mutex_lock_tty - lock a mutex without holding the BTM
+ *
+ * These three functions replace calls to mutex_lock
+ * in the tty layer, when locking on of the following
+ * mutexes:
+ *   tty->ldisc_mutex
+ *   tty->termios_mutex
+ *   tty->atomic_write_lock
+ *   port->mutex
+ *   pn->all_ppp_mutex
+ *
+ * The reason we need these is to avoid an AB-BA deadlock
+ * with tty_lock(). When it can be shown that one of the
+ * above mutexes is either never acquired with the tty_lock()
+ * held, or is never held when tty_lock() is acquired, that
+ * mutex should be converted back to the regular mutex_lock
+ * function.
+ *
+ * In order to annotate the lock order, the mutex_lock_tty_on
+ * and mutex_lock_tty_off versions should be used whereever
+ * possible, to show if the mutex is used with or without
+ * tty_lock already held.
+ */
+#define mutex_lock_tty(mutex)			\
+({						\
+	if (!mutex_trylock(mutex)) {		\
+		if (tty_locked()) {		\
+			__release_tty_lock();	\
+			mutex_lock(mutex);	\
+			__reacquire_tty_lock();	\
+		} else				\
+			mutex_lock(mutex);	\
+	}					\
+})
+
+#define mutex_lock_tty_on(mutex)		\
+({						\
+	if (!mutex_trylock(mutex)) {		\
+		if (!WARN_ON(!tty_locked())) {	\
+			__release_tty_lock();	\
+			mutex_lock(mutex);	\
+			__reacquire_tty_lock();	\
+		} else				\
+			mutex_lock(mutex);	\
+	}					\
+})
+
+#define mutex_lock_tty_off(mutex)		\
+({						\
+	if (!mutex_trylock(mutex)) {		\
+		if (WARN_ON(tty_locked())) {	\
+			__release_tty_lock();	\
+			mutex_lock(mutex);	\
+			__reacquire_tty_lock();	\
+		} else				\
+			mutex_lock(mutex);	\
+	}					\
+})
+
+#define mutex_lock_interruptible_tty(mutex)	\
+({						\
+	int __ret = 0;				\
+	if (!mutex_trylock(mutex)) {		\
+		if (tty_locked()) {		\
+			__release_tty_lock();	\
+			__ret = mutex_lock_interruptible(mutex); \
+			__reacquire_tty_lock();	\
+		} else				\
+			__ret = mutex_lock_interruptible(mutex); \
+	}					\
+	__ret;					\
+})
+
+/*
+ * wait_event*_tty -- wait for a condition with the tty lock held
+ *
+ * similar to the mutex_lock_tty family, these should be used when
+ * waiting for an event in a code location that may get called
+ * while tty_lock is held.
+ *
+ * The problem is that the condition we are waiting for might
+ * only become true if another thread runs that needs the tty_lock
+ * in order to get there.
+ *
+ * None of these should be needed and all callers should be removed
+ * when either the caller or the condition it waits for can be show
+ * to not rely on the tty_lock.
+ */
+#define wait_event_tty(wq, condition) 					\
+do {									\
+	if (condition)	 						\
+		break;							\
+	release_tty_lock(current);					\
+	__wait_event(wq, condition);					\
+	reacquire_tty_lock(current);					\
+} while (0)
+
+#define wait_event_timeout_tty(wq, condition, timeout)			\
+({									\
+	long __ret = timeout;						\
+	if (!(condition)) {						\
+		release_tty_lock(current);				\
+		__wait_event_timeout(wq, condition, __ret);		\
+		reacquire_tty_lock(current);				\
+	}								\
+	__ret;								\
+})
+
+#define wait_event_interruptible_tty(wq, condition)			\
+({									\
+	int __ret = 0;							\
+	if (!(condition)) {						\
+		release_tty_lock(current);				\
+		__wait_event_interruptible(wq, condition, __ret);	\
+		reacquire_tty_lock(current);				\
+	}								\
+	__ret;								\
+})
+
+#define wait_event_interruptible_timeout_tty(wq, condition, timeout)	\
+({									\
+	long __ret = timeout;						\
+	if (!(condition)) {						\
+		release_tty_lock(current);				\
+		__wait_event_interruptible_timeout(wq, condition, __ret); \
+		reacquire_tty_lock(current);				\
+	}								\
+	__ret;								\
+})
+
 #endif /* __KERNEL__ */
 #endif
-- 
1.7.0

