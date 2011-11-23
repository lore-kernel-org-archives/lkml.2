Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310Ab1KWBCB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 20:02:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42188 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932288Ab1KWAeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:34:00 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:22:09 2011
Message-Id: <20111123002209.318741045@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:21:15 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable@vger.kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Greg Kroah-Hartman <greg@kroah.com>, Alan Cox <alan@linux.intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [25/25] tty: icount changeover for other main devices
In-Reply-To: <20111123002222.GA2376@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 29486
Lines: 956

From: Alan Cox <alan@linux.intel.com>

commit 0587102cf9f427c185bfdeb2cef41e13ee0264b1 upstream

Again basically cut and paste

Convert the main driver set to use the hooks for GICOUNT

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>


---
 arch/ia64/hp/sim/simserial.c      |   12 ------
 drivers/char/amiserial.c          |   56 ++++++++++++++++-------------
 drivers/char/cyclades.c           |   49 +++++++++++++------------
 drivers/char/ip2/ip2main.c        |   72 ++++++++++++++++++++++---------------
 drivers/char/mxser.c              |   62 ++++++++++++++++++--------------
 drivers/char/nozomi.c             |   35 ++++++++----------
 drivers/char/pcmcia/synclink_cs.c |   60 ++++++++++++++-----------------
 drivers/char/synclink.c           |   73 +++++++++++++++++---------------------
 drivers/char/synclink_gt.c        |   56 +++++++++++++++--------------
 drivers/char/synclinkmp.c         |   61 ++++++++++++++-----------------
 drivers/serial/68360serial.c      |   51 +++++++++++++-------------
 net/bluetooth/rfcomm/tty.c        |    4 --
 12 files changed, 296 insertions(+), 295 deletions(-)

--- a/arch/ia64/hp/sim/simserial.c
+++ b/arch/ia64/hp/sim/simserial.c
@@ -395,7 +395,7 @@ static int rs_ioctl(struct tty_struct *t
 {
 	if ((cmd != TIOCGSERIAL) && (cmd != TIOCSSERIAL) &&
 	    (cmd != TIOCSERCONFIG) && (cmd != TIOCSERGSTRUCT) &&
-	    (cmd != TIOCMIWAIT) && (cmd != TIOCGICOUNT)) {
+	    (cmd != TIOCMIWAIT)) {
 		if (tty->flags & (1 << TTY_IO_ERROR))
 		    return -EIO;
 	}
@@ -433,16 +433,6 @@ static int rs_ioctl(struct tty_struct *t
 		case TIOCMIWAIT:
 			printk(KERN_INFO "rs_ioctl: TIOCMIWAIT: called\n");
 			return 0;
-		/*
-		 * Get counter of input serial line interrupts (DCD,RI,DSR,CTS)
-		 * Return: write counters to the user passed counter struct
-		 * NB: both 1->0 and 0->1 transitions are counted except for
-		 *     RI where only 0->1 is counted.
-		 */
-		case TIOCGICOUNT:
-			printk(KERN_INFO "rs_ioctl: TIOCGICOUNT called\n");
-			return 0;
-
 		case TIOCSERGWILD:
 		case TIOCSERSWILD:
 			/* "setserial -W" is called in Debian boot */
--- a/drivers/char/amiserial.c
+++ b/drivers/char/amiserial.c
@@ -1262,6 +1262,36 @@ static int rs_break(struct tty_struct *t
 	return 0;
 }
 
+/*
+ * Get counter of input serial line interrupts (DCD,RI,DSR,CTS)
+ * Return: write counters to the user passed counter struct
+ * NB: both 1->0 and 0->1 transitions are counted except for
+ *     RI where only 0->1 is counted.
+ */
+static int rs_get_icount(struct tty_struct *tty,
+				struct serial_icounter_struct *icount)
+{
+	struct async_struct *info = tty->driver_data;
+	struct async_icount cnow;
+	unsigned long flags;
+
+	local_irq_save(flags);
+	cnow = info->state->icount;
+	local_irq_restore(flags);
+	icount->cts = cnow.cts;
+	icount->dsr = cnow.dsr;
+	icount->rng = cnow.rng;
+	icount->dcd = cnow.dcd;
+	icount->rx = cnow.rx;
+	icount->tx = cnow.tx;
+	icount->frame = cnow.frame;
+	icount->overrun = cnow.overrun;
+	icount->parity = cnow.parity;
+	icount->brk = cnow.brk;
+	icount->buf_overrun = cnow.buf_overrun;
+
+	return 0;
+}
 
 static int rs_ioctl(struct tty_struct *tty, struct file * file,
 		    unsigned int cmd, unsigned long arg)
@@ -1331,31 +1361,6 @@ static int rs_ioctl(struct tty_struct *t
 			}
 			/* NOTREACHED */
 
-		/* 
-		 * Get counter of input serial line interrupts (DCD,RI,DSR,CTS)
-		 * Return: write counters to the user passed counter struct
-		 * NB: both 1->0 and 0->1 transitions are counted except for
-		 *     RI where only 0->1 is counted.
-		 */
-		case TIOCGICOUNT:
-			local_irq_save(flags);
-			cnow = info->state->icount;
-			local_irq_restore(flags);
-			icount.cts = cnow.cts;
-			icount.dsr = cnow.dsr;
-			icount.rng = cnow.rng;
-			icount.dcd = cnow.dcd;
-			icount.rx = cnow.rx;
-			icount.tx = cnow.tx;
-			icount.frame = cnow.frame;
-			icount.overrun = cnow.overrun;
-			icount.parity = cnow.parity;
-			icount.brk = cnow.brk;
-			icount.buf_overrun = cnow.buf_overrun;
-
-			if (copy_to_user(argp, &icount, sizeof(icount)))
-				return -EFAULT;
-			return 0;
 		case TIOCSERGWILD:
 		case TIOCSERSWILD:
 			/* "setserial -W" is called in Debian boot */
@@ -1948,6 +1953,7 @@ static const struct tty_operations seria
 	.wait_until_sent = rs_wait_until_sent,
 	.tiocmget = rs_tiocmget,
 	.tiocmset = rs_tiocmset,
+	.get_icount = rs_get_icount,
 	.proc_fops = &rs_proc_fops,
 };
 
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -2798,29 +2798,6 @@ cy_ioctl(struct tty_struct *tty, struct
 		 * NB: both 1->0 and 0->1 transitions are counted except for
 		 *     RI where only 0->1 is counted.
 		 */
-	case TIOCGICOUNT: {
-		struct serial_icounter_struct sic = { };
-
-		spin_lock_irqsave(&info->card->card_lock, flags);
-		cnow = info->icount;
-		spin_unlock_irqrestore(&info->card->card_lock, flags);
-
-		sic.cts = cnow.cts;
-		sic.dsr = cnow.dsr;
-		sic.rng = cnow.rng;
-		sic.dcd = cnow.dcd;
-		sic.rx = cnow.rx;
-		sic.tx = cnow.tx;
-		sic.frame = cnow.frame;
-		sic.overrun = cnow.overrun;
-		sic.parity = cnow.parity;
-		sic.brk = cnow.brk;
-		sic.buf_overrun = cnow.buf_overrun;
-
-		if (copy_to_user(argp, &sic, sizeof(sic)))
-			ret_val = -EFAULT;
-		break;
-	}
 	default:
 		ret_val = -ENOIOCTLCMD;
 	}
@@ -2832,6 +2809,31 @@ cy_ioctl(struct tty_struct *tty, struct
 	return ret_val;
 }				/* cy_ioctl */
 
+static int cy_get_icount(struct tty_struct *tty,
+				struct serial_icounter_struct *sic)
+{
+	struct cyclades_port *info = tty->driver_data;
+	struct cyclades_icount cnow;	/* Used to snapshot */
+	unsigned long flags;
+
+	spin_lock_irqsave(&info->card->card_lock, flags);
+	cnow = info->icount;
+	spin_unlock_irqrestore(&info->card->card_lock, flags);
+
+	sic->cts = cnow.cts;
+	sic->dsr = cnow.dsr;
+	sic->rng = cnow.rng;
+	sic->dcd = cnow.dcd;
+	sic->rx = cnow.rx;
+	sic->tx = cnow.tx;
+	sic->frame = cnow.frame;
+	sic->overrun = cnow.overrun;
+	sic->parity = cnow.parity;
+	sic->brk = cnow.brk;
+	sic->buf_overrun = cnow.buf_overrun;
+	return 0;
+}
+
 /*
  * This routine allows the tty driver to be notified when
  * device's termios settings have changed.  Note that a
@@ -4098,6 +4100,7 @@ static const struct tty_operations cy_op
 	.wait_until_sent = cy_wait_until_sent,
 	.tiocmget = cy_tiocmget,
 	.tiocmset = cy_tiocmset,
+	.get_icount = cy_get_icount,
 	.proc_fops = &cyclades_proc_fops,
 };
 
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -183,6 +183,8 @@ static void ip2_hangup(PTTY);
 static int  ip2_tiocmget(struct tty_struct *tty, struct file *file);
 static int  ip2_tiocmset(struct tty_struct *tty, struct file *file,
 			 unsigned int set, unsigned int clear);
+static int ip2_get_icount(struct tty_struct *tty,
+		struct serial_icounter_struct *icount);
 
 static void set_irq(int, int);
 static void ip2_interrupt_bh(struct work_struct *work);
@@ -448,6 +450,7 @@ static const struct tty_operations ip2_o
 	.hangup          = ip2_hangup,
 	.tiocmget	 = ip2_tiocmget,
 	.tiocmset	 = ip2_tiocmset,
+	.get_icount	 = ip2_get_icount,
 	.proc_fops	 = &ip2_proc_fops,
 };
 
@@ -2112,7 +2115,6 @@ ip2_ioctl ( PTTY tty, struct file *pFile
 	i2ChanStrPtr pCh = DevTable[tty->index];
 	i2eBordStrPtr pB;
 	struct async_icount cprev, cnow;	/* kernel counter temps */
-	struct serial_icounter_struct __user *p_cuser;
 	int rc = 0;
 	unsigned long flags;
 	void __user *argp = (void __user *)arg;
@@ -2281,34 +2283,6 @@ ip2_ioctl ( PTTY tty, struct file *pFile
 		break;
 
 	/*
-	 * Get counter of input serial line interrupts (DCD,RI,DSR,CTS)
-	 * Return: write counters to the user passed counter struct
-	 * NB: both 1->0 and 0->1 transitions are counted except for RI where
-	 * only 0->1 is counted. The controller is quite capable of counting
-	 * both, but this done to preserve compatibility with the standard
-	 * serial driver.
-	 */
-	case TIOCGICOUNT:
-		ip2trace (CHANN, ITRC_IOCTL, 11, 1, rc );
-
-		write_lock_irqsave(&pB->read_fifo_spinlock, flags);
-		cnow = pCh->icount;
-		write_unlock_irqrestore(&pB->read_fifo_spinlock, flags);
-		p_cuser = argp;
-		rc = put_user(cnow.cts, &p_cuser->cts);
-		rc = put_user(cnow.dsr, &p_cuser->dsr);
-		rc = put_user(cnow.rng, &p_cuser->rng);
-		rc = put_user(cnow.dcd, &p_cuser->dcd);
-		rc = put_user(cnow.rx, &p_cuser->rx);
-		rc = put_user(cnow.tx, &p_cuser->tx);
-		rc = put_user(cnow.frame, &p_cuser->frame);
-		rc = put_user(cnow.overrun, &p_cuser->overrun);
-		rc = put_user(cnow.parity, &p_cuser->parity);
-		rc = put_user(cnow.brk, &p_cuser->brk);
-		rc = put_user(cnow.buf_overrun, &p_cuser->buf_overrun);
-		break;
-
-	/*
 	 * The rest are not supported by this driver. By returning -ENOIOCTLCMD they
 	 * will be passed to the line discipline for it to handle.
 	 */
@@ -2332,6 +2306,46 @@ ip2_ioctl ( PTTY tty, struct file *pFile
 	return rc;
 }
 
+static int ip2_get_icount(struct tty_struct *tty,
+		struct serial_icounter_struct *icount)
+{
+	i2ChanStrPtr pCh = DevTable[tty->index];
+	i2eBordStrPtr pB;
+	struct async_icount cnow;	/* kernel counter temp */
+	unsigned long flags;
+
+	if ( pCh == NULL )
+		return -ENODEV;
+
+	pB = pCh->pMyBord;
+
+	/*
+	 * Get counter of input serial line interrupts (DCD,RI,DSR,CTS)
+	 * Return: write counters to the user passed counter struct
+	 * NB: both 1->0 and 0->1 transitions are counted except for RI where
+	 * only 0->1 is counted. The controller is quite capable of counting
+	 * both, but this done to preserve compatibility with the standard
+	 * serial driver.
+	 */
+
+	write_lock_irqsave(&pB->read_fifo_spinlock, flags);
+	cnow = pCh->icount;
+	write_unlock_irqrestore(&pB->read_fifo_spinlock, flags);
+
+	icount->cts = cnow.cts;
+	icount->dsr = cnow.dsr;
+	icount->rng = cnow.rng;
+	icount->dcd = cnow.dcd;
+	icount->rx = cnow.rx;
+	icount->tx = cnow.tx;
+	icount->frame = cnow.frame;
+	icount->overrun = cnow.overrun;
+	icount->parity = cnow.parity;
+	icount->brk = cnow.brk;
+	icount->buf_overrun = cnow.buf_overrun;
+	return 0;
+}
+
 /******************************************************************************/
 /* Function:   GetSerialInfo()                                                */
 /* Parameters: Pointer to channel structure                                   */
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -1736,7 +1736,7 @@ static int mxser_ioctl(struct tty_struct
 		return 0;
 	}
 
-	if (cmd != TIOCGSERIAL && cmd != TIOCMIWAIT && cmd != TIOCGICOUNT &&
+	if (cmd != TIOCGSERIAL && cmd != TIOCMIWAIT &&
 			test_bit(TTY_IO_ERROR, &tty->flags))
 		return -EIO;
 
@@ -1766,32 +1766,6 @@ static int mxser_ioctl(struct tty_struct
 
 		return wait_event_interruptible(info->port.delta_msr_wait,
 				mxser_cflags_changed(info, arg, &cnow));
-	/*
-	 * Get counter of input serial line interrupts (DCD,RI,DSR,CTS)
-	 * Return: write counters to the user passed counter struct
-	 * NB: both 1->0 and 0->1 transitions are counted except for
-	 *     RI where only 0->1 is counted.
-	 */
-	case TIOCGICOUNT: {
-		struct serial_icounter_struct icnt = { 0 };
-		spin_lock_irqsave(&info->slock, flags);
-		cnow = info->icount;
-		spin_unlock_irqrestore(&info->slock, flags);
-
-		icnt.frame = cnow.frame;
-		icnt.brk = cnow.brk;
-		icnt.overrun = cnow.overrun;
-		icnt.buf_overrun = cnow.buf_overrun;
-		icnt.parity = cnow.parity;
-		icnt.rx = cnow.rx;
-		icnt.tx = cnow.tx;
-		icnt.cts = cnow.cts;
-		icnt.dsr = cnow.dsr;
-		icnt.rng = cnow.rng;
-		icnt.dcd = cnow.dcd;
-
-		return copy_to_user(argp, &icnt, sizeof(icnt)) ? -EFAULT : 0;
-	}
 	case MOXA_HighSpeedOn:
 		return put_user(info->baud_base != 115200 ? 1 : 0, (int __user *)argp);
 	case MOXA_SDS_RSTICOUNTER:
@@ -1862,6 +1836,39 @@ static int mxser_ioctl(struct tty_struct
 	return 0;
 }
 
+	/*
+	 * Get counter of input serial line interrupts (DCD,RI,DSR,CTS)
+	 * Return: write counters to the user passed counter struct
+	 * NB: both 1->0 and 0->1 transitions are counted except for
+	 *     RI where only 0->1 is counted.
+	 */
+
+static int mxser_get_icount(struct tty_struct *tty,
+		struct serial_icounter_struct *icount)
+
+{
+	struct mxser_port *info = tty->driver_data;
+	struct async_icount cnow;
+	unsigned long flags;
+
+	spin_lock_irqsave(&info->slock, flags);
+	cnow = info->icount;
+	spin_unlock_irqrestore(&info->slock, flags);
+
+	icount->frame = cnow.frame;
+	icount->brk = cnow.brk;
+	icount->overrun = cnow.overrun;
+	icount->buf_overrun = cnow.buf_overrun;
+	icount->parity = cnow.parity;
+	icount->rx = cnow.rx;
+	icount->tx = cnow.tx;
+	icount->cts = cnow.cts;
+	icount->dsr = cnow.dsr;
+	icount->rng = cnow.rng;
+	icount->dcd = cnow.dcd;
+	return 0;
+}
+
 static void mxser_stoprx(struct tty_struct *tty)
 {
 	struct mxser_port *info = tty->driver_data;
@@ -2358,6 +2365,7 @@ static const struct tty_operations mxser
 	.wait_until_sent = mxser_wait_until_sent,
 	.tiocmget = mxser_tiocmget,
 	.tiocmset = mxser_tiocmset,
+	.get_icount = mxser_get_icount,
 };
 
 struct tty_port_operations mxser_port_ops = {
--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -1783,24 +1783,24 @@ static int ntty_cflags_changed(struct po
 	return ret;
 }
 
-static int ntty_ioctl_tiocgicount(struct port *port, void __user *argp)
+static int ntty_tiocgicount(struct tty_struct *tty,
+				struct serial_icounter_struct *icount)
 {
+	struct port *port = tty->driver_data;
 	const struct async_icount cnow = port->tty_icount;
-	struct serial_icounter_struct icount;
-
-	icount.cts = cnow.cts;
-	icount.dsr = cnow.dsr;
-	icount.rng = cnow.rng;
-	icount.dcd = cnow.dcd;
-	icount.rx = cnow.rx;
-	icount.tx = cnow.tx;
-	icount.frame = cnow.frame;
-	icount.overrun = cnow.overrun;
-	icount.parity = cnow.parity;
-	icount.brk = cnow.brk;
-	icount.buf_overrun = cnow.buf_overrun;
 
-	return copy_to_user(argp, &icount, sizeof(icount)) ? -EFAULT : 0;
+	icount->cts = cnow.cts;
+	icount->dsr = cnow.dsr;
+	icount->rng = cnow.rng;
+	icount->dcd = cnow.dcd;
+	icount->rx = cnow.rx;
+	icount->tx = cnow.tx;
+	icount->frame = cnow.frame;
+	icount->overrun = cnow.overrun;
+	icount->parity = cnow.parity;
+	icount->brk = cnow.brk;
+	icount->buf_overrun = cnow.buf_overrun;
+	return 0;
 }
 
 static int ntty_ioctl(struct tty_struct *tty, struct file *file,
@@ -1819,9 +1819,7 @@ static int ntty_ioctl(struct tty_struct
 		rval = wait_event_interruptible(port->tty_wait,
 				ntty_cflags_changed(port, arg, &cprev));
 		break;
-	} case TIOCGICOUNT:
-		rval = ntty_ioctl_tiocgicount(port, argp);
-		break;
+	}
 	default:
 		DBG1("ERR: 0x%08X, %d", cmd, cmd);
 		break;
@@ -1895,6 +1893,7 @@ static const struct tty_operations tty_o
 	.chars_in_buffer = ntty_chars_in_buffer,
 	.tiocmget = ntty_tiocmget,
 	.tiocmset = ntty_tiocmset,
+	.get_icount = ntty_tiocgicount,
 };
 
 /* Module initialization */
--- a/drivers/char/pcmcia/synclink_cs.c
+++ b/drivers/char/pcmcia/synclink_cs.c
@@ -2252,6 +2252,32 @@ static int mgslpc_break(struct tty_struc
 	return 0;
 }
 
+static int mgslpc_get_icount(struct tty_struct *tty,
+				struct serial_icounter_struct *icount)
+{
+	MGSLPC_INFO * info = (MGSLPC_INFO *)tty->driver_data;
+	struct mgsl_icount cnow;	/* kernel counter temps */
+	unsigned long flags;
+
+	spin_lock_irqsave(&info->lock,flags);
+	cnow = info->icount;
+	spin_unlock_irqrestore(&info->lock,flags);
+
+	icount->cts = cnow.cts;
+	icount->dsr = cnow.dsr;
+	icount->rng = cnow.rng;
+	icount->dcd = cnow.dcd;
+	icount->rx = cnow.rx;
+	icount->tx = cnow.tx;
+	icount->frame = cnow.frame;
+	icount->overrun = cnow.overrun;
+	icount->parity = cnow.parity;
+	icount->brk = cnow.brk;
+	icount->buf_overrun = cnow.buf_overrun;
+
+	return 0;
+}
+
 /* Service an IOCTL request
  *
  * Arguments:
@@ -2267,11 +2293,7 @@ static int mgslpc_ioctl(struct tty_struc
 			unsigned int cmd, unsigned long arg)
 {
 	MGSLPC_INFO * info = (MGSLPC_INFO *)tty->driver_data;
-	int error;
-	struct mgsl_icount cnow;	/* kernel counter temps */
-	struct serial_icounter_struct __user *p_cuser;	/* user space */
 	void __user *argp = (void __user *)arg;
-	unsigned long flags;
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgslpc_ioctl %s cmd=%08X\n", __FILE__,__LINE__,
@@ -2281,7 +2303,7 @@ static int mgslpc_ioctl(struct tty_struc
 		return -ENODEV;
 
 	if ((cmd != TIOCGSERIAL) && (cmd != TIOCSSERIAL) &&
-	    (cmd != TIOCMIWAIT) && (cmd != TIOCGICOUNT)) {
+	    (cmd != TIOCMIWAIT)) {
 		if (tty->flags & (1 << TTY_IO_ERROR))
 		    return -EIO;
 	}
@@ -2311,34 +2333,6 @@ static int mgslpc_ioctl(struct tty_struc
 		return wait_events(info, argp);
 	case TIOCMIWAIT:
 		return modem_input_wait(info,(int)arg);
-	case TIOCGICOUNT:
-		spin_lock_irqsave(&info->lock,flags);
-		cnow = info->icount;
-		spin_unlock_irqrestore(&info->lock,flags);
-		p_cuser = argp;
-		PUT_USER(error,cnow.cts, &p_cuser->cts);
-		if (error) return error;
-		PUT_USER(error,cnow.dsr, &p_cuser->dsr);
-		if (error) return error;
-		PUT_USER(error,cnow.rng, &p_cuser->rng);
-		if (error) return error;
-		PUT_USER(error,cnow.dcd, &p_cuser->dcd);
-		if (error) return error;
-		PUT_USER(error,cnow.rx, &p_cuser->rx);
-		if (error) return error;
-		PUT_USER(error,cnow.tx, &p_cuser->tx);
-		if (error) return error;
-		PUT_USER(error,cnow.frame, &p_cuser->frame);
-		if (error) return error;
-		PUT_USER(error,cnow.overrun, &p_cuser->overrun);
-		if (error) return error;
-		PUT_USER(error,cnow.parity, &p_cuser->parity);
-		if (error) return error;
-		PUT_USER(error,cnow.brk, &p_cuser->brk);
-		if (error) return error;
-		PUT_USER(error,cnow.buf_overrun, &p_cuser->buf_overrun);
-		if (error) return error;
-		return 0;
 	default:
 		return -ENOIOCTLCMD;
 	}
--- a/drivers/char/synclink.c
+++ b/drivers/char/synclink.c
@@ -2920,6 +2920,38 @@ static int mgsl_break(struct tty_struct
 	
 }	/* end of mgsl_break() */
 
+/*
+ * Get counter of input serial line interrupts (DCD,RI,DSR,CTS)
+ * Return: write counters to the user passed counter struct
+ * NB: both 1->0 and 0->1 transitions are counted except for
+ *     RI where only 0->1 is counted.
+ */
+static int msgl_get_icount(struct tty_struct *tty,
+				struct serial_icounter_struct *icount)
+
+{
+	struct mgsl_struct * info = tty->driver_data;
+	struct mgsl_icount cnow;	/* kernel counter temps */
+	unsigned long flags;
+
+	spin_lock_irqsave(&info->irq_spinlock,flags);
+	cnow = info->icount;
+	spin_unlock_irqrestore(&info->irq_spinlock,flags);
+
+	icount->cts = cnow.cts;
+	icount->dsr = cnow.dsr;
+	icount->rng = cnow.rng;
+	icount->dcd = cnow.dcd;
+	icount->rx = cnow.rx;
+	icount->tx = cnow.tx;
+	icount->frame = cnow.frame;
+	icount->overrun = cnow.overrun;
+	icount->parity = cnow.parity;
+	icount->brk = cnow.brk;
+	icount->buf_overrun = cnow.buf_overrun;
+	return 0;
+}
+
 /* mgsl_ioctl()	Service an IOCTL request
  * 	
  * Arguments:
@@ -2945,7 +2977,7 @@ static int mgsl_ioctl(struct tty_struct
 		return -ENODEV;
 
 	if ((cmd != TIOCGSERIAL) && (cmd != TIOCSSERIAL) &&
-	    (cmd != TIOCMIWAIT) && (cmd != TIOCGICOUNT)) {
+	    (cmd != TIOCMIWAIT)) {
 		if (tty->flags & (1 << TTY_IO_ERROR))
 		    return -EIO;
 	}
@@ -2958,11 +2990,7 @@ static int mgsl_ioctl(struct tty_struct
 
 static int mgsl_ioctl_common(struct mgsl_struct *info, unsigned int cmd, unsigned long arg)
 {
-	int error;
-	struct mgsl_icount cnow;	/* kernel counter temps */
 	void __user *argp = (void __user *)arg;
-	struct serial_icounter_struct __user *p_cuser;	/* user space */
-	unsigned long flags;
 	
 	switch (cmd) {
 		case MGSL_IOCGPARAMS:
@@ -2991,40 +3019,6 @@ static int mgsl_ioctl_common(struct mgsl
 		case TIOCMIWAIT:
 			return modem_input_wait(info,(int)arg);
 
-		/* 
-		 * Get counter of input serial line interrupts (DCD,RI,DSR,CTS)
-		 * Return: write counters to the user passed counter struct
-		 * NB: both 1->0 and 0->1 transitions are counted except for
-		 *     RI where only 0->1 is counted.
-		 */
-		case TIOCGICOUNT:
-			spin_lock_irqsave(&info->irq_spinlock,flags);
-			cnow = info->icount;
-			spin_unlock_irqrestore(&info->irq_spinlock,flags);
-			p_cuser = argp;
-			PUT_USER(error,cnow.cts, &p_cuser->cts);
-			if (error) return error;
-			PUT_USER(error,cnow.dsr, &p_cuser->dsr);
-			if (error) return error;
-			PUT_USER(error,cnow.rng, &p_cuser->rng);
-			if (error) return error;
-			PUT_USER(error,cnow.dcd, &p_cuser->dcd);
-			if (error) return error;
-			PUT_USER(error,cnow.rx, &p_cuser->rx);
-			if (error) return error;
-			PUT_USER(error,cnow.tx, &p_cuser->tx);
-			if (error) return error;
-			PUT_USER(error,cnow.frame, &p_cuser->frame);
-			if (error) return error;
-			PUT_USER(error,cnow.overrun, &p_cuser->overrun);
-			if (error) return error;
-			PUT_USER(error,cnow.parity, &p_cuser->parity);
-			if (error) return error;
-			PUT_USER(error,cnow.brk, &p_cuser->brk);
-			if (error) return error;
-			PUT_USER(error,cnow.buf_overrun, &p_cuser->buf_overrun);
-			if (error) return error;
-			return 0;
 		default:
 			return -ENOIOCTLCMD;
 	}
@@ -4325,6 +4319,7 @@ static const struct tty_operations mgsl_
 	.hangup = mgsl_hangup,
 	.tiocmget = tiocmget,
 	.tiocmset = tiocmset,
+	.get_icount = msgl_get_icount,
 	.proc_fops = &mgsl_proc_fops,
 };
 
--- a/drivers/char/synclink_gt.c
+++ b/drivers/char/synclink_gt.c
@@ -1057,9 +1057,6 @@ static int ioctl(struct tty_struct *tty,
 		 unsigned int cmd, unsigned long arg)
 {
 	struct slgt_info *info = tty->driver_data;
-	struct mgsl_icount cnow;	/* kernel counter temps */
-	struct serial_icounter_struct __user *p_cuser;	/* user space */
-	unsigned long flags;
 	void __user *argp = (void __user *)arg;
 	int ret;
 
@@ -1068,7 +1065,7 @@ static int ioctl(struct tty_struct *tty,
 	DBGINFO(("%s ioctl() cmd=%08X\n", info->device_name, cmd));
 
 	if ((cmd != TIOCGSERIAL) && (cmd != TIOCSSERIAL) &&
-	    (cmd != TIOCMIWAIT) && (cmd != TIOCGICOUNT)) {
+	    (cmd != TIOCMIWAIT)) {
 		if (tty->flags & (1 << TTY_IO_ERROR))
 		    return -EIO;
 	}
@@ -1121,25 +1118,6 @@ static int ioctl(struct tty_struct *tty,
 	case MGSL_IOCWAITGPIO:
 		ret = wait_gpio(info, argp);
 		break;
-	case TIOCGICOUNT:
-		spin_lock_irqsave(&info->lock,flags);
-		cnow = info->icount;
-		spin_unlock_irqrestore(&info->lock,flags);
-		p_cuser = argp;
-		if (put_user(cnow.cts, &p_cuser->cts) ||
-		    put_user(cnow.dsr, &p_cuser->dsr) ||
-		    put_user(cnow.rng, &p_cuser->rng) ||
-		    put_user(cnow.dcd, &p_cuser->dcd) ||
-		    put_user(cnow.rx, &p_cuser->rx) ||
-		    put_user(cnow.tx, &p_cuser->tx) ||
-		    put_user(cnow.frame, &p_cuser->frame) ||
-		    put_user(cnow.overrun, &p_cuser->overrun) ||
-		    put_user(cnow.parity, &p_cuser->parity) ||
-		    put_user(cnow.brk, &p_cuser->brk) ||
-		    put_user(cnow.buf_overrun, &p_cuser->buf_overrun))
-			ret = -EFAULT;
-		ret = 0;
-		break;
 	default:
 		ret = -ENOIOCTLCMD;
 	}
@@ -1147,6 +1125,33 @@ static int ioctl(struct tty_struct *tty,
 	return ret;
 }
 
+static int get_icount(struct tty_struct *tty,
+				struct serial_icounter_struct *icount)
+
+{
+	struct slgt_info *info = tty->driver_data;
+	struct mgsl_icount cnow;	/* kernel counter temps */
+	unsigned long flags;
+
+	spin_lock_irqsave(&info->lock,flags);
+	cnow = info->icount;
+	spin_unlock_irqrestore(&info->lock,flags);
+
+	icount->cts = cnow.cts;
+	icount->dsr = cnow.dsr;
+	icount->rng = cnow.rng;
+	icount->dcd = cnow.dcd;
+	icount->rx = cnow.rx;
+	icount->tx = cnow.tx;
+	icount->frame = cnow.frame;
+	icount->overrun = cnow.overrun;
+	icount->parity = cnow.parity;
+	icount->brk = cnow.brk;
+	icount->buf_overrun = cnow.buf_overrun;
+
+	return 0;
+}
+
 /*
  * support for 32 bit ioctl calls on 64 bit systems
  */
@@ -1236,10 +1241,6 @@ static long slgt_compat_ioctl(struct tty
 	case MGSL_IOCSGPIO:
 	case MGSL_IOCGGPIO:
 	case MGSL_IOCWAITGPIO:
-	case TIOCGICOUNT:
-		rc = ioctl(tty, file, cmd, (unsigned long)(compat_ptr(arg)));
-		break;
-
 	case MGSL_IOCSTXIDLE:
 	case MGSL_IOCTXENABLE:
 	case MGSL_IOCRXENABLE:
@@ -3639,6 +3640,7 @@ static const struct tty_operations ops =
 	.hangup = hangup,
 	.tiocmget = tiocmget,
 	.tiocmset = tiocmset,
+	.get_icount = get_icount,
 	.proc_fops = &synclink_gt_proc_fops,
 };
 
--- a/drivers/char/synclinkmp.c
+++ b/drivers/char/synclinkmp.c
@@ -1255,10 +1255,6 @@ static int do_ioctl(struct tty_struct *t
 		 unsigned int cmd, unsigned long arg)
 {
 	SLMP_INFO *info = tty->driver_data;
-	int error;
-	struct mgsl_icount cnow;	/* kernel counter temps */
-	struct serial_icounter_struct __user *p_cuser;	/* user space */
-	unsigned long flags;
 	void __user *argp = (void __user *)arg;
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
@@ -1269,7 +1265,7 @@ static int do_ioctl(struct tty_struct *t
 		return -ENODEV;
 
 	if ((cmd != TIOCGSERIAL) && (cmd != TIOCSSERIAL) &&
-	    (cmd != TIOCMIWAIT) && (cmd != TIOCGICOUNT)) {
+	    (cmd != TIOCMIWAIT)) {
 		if (tty->flags & (1 << TTY_IO_ERROR))
 		    return -EIO;
 	}
@@ -1307,40 +1303,38 @@ static int do_ioctl(struct tty_struct *t
 		 * NB: both 1->0 and 0->1 transitions are counted except for
 		 *     RI where only 0->1 is counted.
 		 */
-	case TIOCGICOUNT:
-		spin_lock_irqsave(&info->lock,flags);
-		cnow = info->icount;
-		spin_unlock_irqrestore(&info->lock,flags);
-		p_cuser = argp;
-		PUT_USER(error,cnow.cts, &p_cuser->cts);
-		if (error) return error;
-		PUT_USER(error,cnow.dsr, &p_cuser->dsr);
-		if (error) return error;
-		PUT_USER(error,cnow.rng, &p_cuser->rng);
-		if (error) return error;
-		PUT_USER(error,cnow.dcd, &p_cuser->dcd);
-		if (error) return error;
-		PUT_USER(error,cnow.rx, &p_cuser->rx);
-		if (error) return error;
-		PUT_USER(error,cnow.tx, &p_cuser->tx);
-		if (error) return error;
-		PUT_USER(error,cnow.frame, &p_cuser->frame);
-		if (error) return error;
-		PUT_USER(error,cnow.overrun, &p_cuser->overrun);
-		if (error) return error;
-		PUT_USER(error,cnow.parity, &p_cuser->parity);
-		if (error) return error;
-		PUT_USER(error,cnow.brk, &p_cuser->brk);
-		if (error) return error;
-		PUT_USER(error,cnow.buf_overrun, &p_cuser->buf_overrun);
-		if (error) return error;
-		return 0;
 	default:
 		return -ENOIOCTLCMD;
 	}
 	return 0;
 }
 
+static int get_icount(struct tty_struct *tty,
+				struct serial_icounter_struct *icount)
+{
+	SLMP_INFO *info = tty->driver_data;
+	struct mgsl_icount cnow;	/* kernel counter temps */
+	unsigned long flags;
+
+	spin_lock_irqsave(&info->lock,flags);
+	cnow = info->icount;
+	spin_unlock_irqrestore(&info->lock,flags);
+
+	icount->cts = cnow.cts;
+	icount->dsr = cnow.dsr;
+	icount->rng = cnow.rng;
+	icount->dcd = cnow.dcd;
+	icount->rx = cnow.rx;
+	icount->tx = cnow.tx;
+	icount->frame = cnow.frame;
+	icount->overrun = cnow.overrun;
+	icount->parity = cnow.parity;
+	icount->brk = cnow.brk;
+	icount->buf_overrun = cnow.buf_overrun;
+
+	return 0;
+}
+
 static int ioctl(struct tty_struct *tty, struct file *file,
 		 unsigned int cmd, unsigned long arg)
 {
@@ -3908,6 +3902,7 @@ static const struct tty_operations ops =
 	.hangup = hangup,
 	.tiocmget = tiocmget,
 	.tiocmset = tiocmset,
+	.get_icount = get_icount,
 	.proc_fops = &synclinkmp_proc_fops,
 };
 
--- a/drivers/serial/68360serial.c
+++ b/drivers/serial/68360serial.c
@@ -1381,6 +1381,30 @@ static void send_break(ser_info_t *info,
 }
 
 
+/*
+ * Get counter of input serial line interrupts (DCD,RI,DSR,CTS)
+ * Return: write counters to the user passed counter struct
+ * NB: both 1->0 and 0->1 transitions are counted except for
+ *     RI where only 0->1 is counted.
+ */
+static int rs_360_get_icount(struct tty_struct *tty,
+				struct serial_icounter_struct *icount)
+{
+	ser_info_t *info = (ser_info_t *)tty->driver_data;
+	struct async_icount cnow;
+
+	local_irq_disable();
+	cnow = info->state->icount;
+	local_irq_enable();
+
+	icount->cts = cnow.cts;
+	icount->dsr = cnow.dsr;
+	icount->rng = cnow.rng;
+	icount->dcd = cnow.dcd;
+
+	return 0;
+}
+
 static int rs_360_ioctl(struct tty_struct *tty, struct file * file,
 		    unsigned int cmd, unsigned long arg)
 {
@@ -1394,7 +1418,7 @@ static int rs_360_ioctl(struct tty_struc
 	if (serial_paranoia_check(info, tty->name, "rs_ioctl"))
 		return -ENODEV;
 
-	if ((cmd != TIOCMIWAIT) && (cmd != TIOCGICOUNT)) {
+	if (cmd != TIOCMIWAIT) {
 		if (tty->flags & (1 << TTY_IO_ERROR))
 		    return -EIO;
 	}
@@ -1477,31 +1501,6 @@ static int rs_360_ioctl(struct tty_struc
 			return 0;
 #endif
 
-		/* 
-		 * Get counter of input serial line interrupts (DCD,RI,DSR,CTS)
-		 * Return: write counters to the user passed counter struct
-		 * NB: both 1->0 and 0->1 transitions are counted except for
-		 *     RI where only 0->1 is counted.
-		 */
-		case TIOCGICOUNT:
-			local_irq_disable();
-			cnow = info->state->icount;
-			local_irq_enable();
-			p_cuser = (struct serial_icounter_struct *) arg;
-/* 			error = put_user(cnow.cts, &p_cuser->cts); */
-/* 			if (error) return error; */
-/* 			error = put_user(cnow.dsr, &p_cuser->dsr); */
-/* 			if (error) return error; */
-/* 			error = put_user(cnow.rng, &p_cuser->rng); */
-/* 			if (error) return error; */
-/* 			error = put_user(cnow.dcd, &p_cuser->dcd); */
-/* 			if (error) return error; */
-
-			put_user(cnow.cts, &p_cuser->cts);
-			put_user(cnow.dsr, &p_cuser->dsr);
-			put_user(cnow.rng, &p_cuser->rng);
-			put_user(cnow.dcd, &p_cuser->dcd);
-			return 0;
 
 		default:
 			return -ENOIOCTLCMD;
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -844,10 +844,6 @@ static int rfcomm_tty_ioctl(struct tty_s
 		BT_DBG("TIOCMIWAIT");
 		break;
 
-	case TIOCGICOUNT:
-		BT_DBG("TIOCGICOUNT");
-		break;
-
 	case TIOCGSERIAL:
 		BT_ERR("TIOCGSERIAL is not supported");
 		return -ENOIOCTLCMD;


