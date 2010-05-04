Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934491Ab0EDWf0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 18:35:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56711 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934482Ab0EDWfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 18:35:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <gregkh@suse.de>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 03/13] tty: make tty_port->mutex nest under tty_lock
Date: Wed,  5 May 2010 00:33:42 +0200
Message-Id: <1273012433-6125-4-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1273012433-6125-1-git-send-email-arnd@arndb.de>
References: <1273012433-6125-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/uw0qlQXVmaQKBOYMWx/I1lbFE1A7HI8qzcpd
 E7kFZJgVoNpOZ/+gMwBu4glyHZmFOhI9165u01Hv0Kcnih6zXT
 EuT0Q3JfVlgYGCFfqHhvQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

tty_port->mutex has a lock order problem with
tty_lock. By using mutex_lock_tty to drop tty_lock
while waiting for tty_port->mutex we can work
around this.

Make sure that we document for each mutex_lock(port->mutex)
whether we hold the BTM or not, in the hope that this
helps us eliminate the BTM eventually.

All users of tty_port_hangup call that with the BTM held,
except for stl_cleanup_panels. Take the BTM explicitly
there to make the locking more consistent.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/char/cyclades.c      |    2 +-
 drivers/char/isicom.c        |    4 ++--
 drivers/char/istallion.c     |    4 ++--
 drivers/char/moxa.c          |    6 +++---
 drivers/char/mxser.c         |   10 +++++-----
 drivers/char/riscom8.c       |    4 ++--
 drivers/char/rocket.c        |    6 +++---
 drivers/char/specialix.c     |    4 ++--
 drivers/char/stallion.c      |   10 ++++++----
 drivers/char/synclink.c      |    8 ++++----
 drivers/char/synclink_gt.c   |    8 ++++----
 drivers/char/synclinkmp.c    |   10 +++++-----
 drivers/char/tty_port.c      |    4 ++--
 drivers/mmc/card/sdio_uart.c |    2 +-
 drivers/serial/pmac_zilog.c  |    4 ++--
 drivers/serial/serial_core.c |   32 ++++++++++++++++----------------
 drivers/usb/serial/opticon.c |    2 +-
 17 files changed, 61 insertions(+), 59 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 51acfe3..5b3b419 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -2359,7 +2359,7 @@ cy_set_serial_info(struct cyclades_port *info, struct tty_struct *tty,
 	if (copy_from_user(&new_serial, new_info, sizeof(new_serial)))
 		return -EFAULT;
 
-	mutex_lock(&info->port.mutex);
+	mutex_lock_tty_off(&info->port.mutex);
 	if (!capable(CAP_SYS_ADMIN)) {
 		if (new_serial.close_delay != info->port.close_delay ||
 				new_serial.baud_base != info->baud ||
diff --git a/drivers/char/isicom.c b/drivers/char/isicom.c
index 078d69f..2c46fd6 100644
--- a/drivers/char/isicom.c
+++ b/drivers/char/isicom.c
@@ -1117,7 +1117,7 @@ static int isicom_set_serial_info(struct tty_struct *tty,
 	if (copy_from_user(&newinfo, info, sizeof(newinfo)))
 		return -EFAULT;
 
-	mutex_lock(&port->port.mutex);
+	mutex_lock_tty_off(&port->port.mutex);
 	reconfig_port = ((port->port.flags & ASYNC_SPD_MASK) !=
 		(newinfo.flags & ASYNC_SPD_MASK));
 
@@ -1152,7 +1152,7 @@ static int isicom_get_serial_info(struct isi_port *port,
 {
 	struct serial_struct out_info;
 
-	mutex_lock(&port->port.mutex);
+	mutex_lock_tty_off(&port->port.mutex);
 	memset(&out_info, 0, sizeof(out_info));
 /*	out_info.type = ? */
 	out_info.line = port - isi_ports;
diff --git a/drivers/char/istallion.c b/drivers/char/istallion.c
index 5e6fe7e..0618797 100644
--- a/drivers/char/istallion.c
+++ b/drivers/char/istallion.c
@@ -4080,7 +4080,7 @@ static int stli_portcmdstats(struct tty_struct *tty, struct stliport *portp)
 	if (brdp == NULL)
 		return -ENODEV;
 
-	mutex_lock(&portp->port.mutex);
+	mutex_lock_tty_off(&portp->port.mutex);
 	if (test_bit(BST_STARTED, &brdp->state)) {
 		if ((rc = stli_cmdwait(brdp, portp, A_GETSTATS,
 		    &stli_cdkstats, sizeof(asystats_t), 1)) < 0) {
@@ -4194,7 +4194,7 @@ static int stli_clrportstats(struct stliport *portp, comstats_t __user *cp)
 	if (!brdp)
 		return -ENODEV;
 
-	mutex_lock(&portp->port.mutex);
+	mutex_lock_tty_off(&portp->port.mutex);
 
 	if (test_bit(BST_STARTED, &brdp->state)) {
 		if ((rc = stli_cmdwait(brdp, portp, A_CLEARSTATS, NULL, 0, 0)) < 0) {
diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index 107b0bd..e3f943d 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -380,12 +380,12 @@ copy:
 		break;
 	}
 	case TIOCGSERIAL:
-	        mutex_lock(&ch->port.mutex);
+	        mutex_lock_tty_off(&ch->port.mutex);
 		ret = moxa_get_serial_info(ch, argp);
 		mutex_unlock(&ch->port.mutex);
 		break;
 	case TIOCSSERIAL:
-	        mutex_lock(&ch->port.mutex);
+	        mutex_lock_tty_off(&ch->port.mutex);
 		ret = moxa_set_serial_info(ch, argp);
 		mutex_unlock(&ch->port.mutex);
 		break;
@@ -1178,7 +1178,7 @@ static int moxa_open(struct tty_struct *tty, struct file *filp)
 	ch->port.count++;
 	tty->driver_data = ch;
 	tty_port_tty_set(&ch->port, tty);
-	mutex_lock(&ch->port.mutex);
+	mutex_lock_tty_on(&ch->port.mutex);
 	if (!(ch->port.flags & ASYNC_INITIALIZED)) {
 		ch->statusflags = 0;
 		moxa_set_tty_param(tty, tty->termios);
diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
index d2692d4..ff2db07 100644
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -1079,7 +1079,7 @@ static void mxser_close(struct tty_struct *tty, struct file *filp)
 		return;
 	if (tty_port_close_start(port, tty, filp) == 0)
 		return;
-	mutex_lock(&port->mutex);
+	mutex_lock_tty_on(&port->mutex);
 	mxser_close_port(port);
 	mxser_flush_buffer(tty);
 	mxser_shutdown_port(port);
@@ -1513,7 +1513,7 @@ static int mxser_ioctl_special(unsigned int cmd, void __user *argp)
 				port = &ip->port;
 				memset(&ms, 0, sizeof(ms));
 
-				mutex_lock(&port->mutex);
+				mutex_lock_tty_off(&port->mutex);
 				if (!ip->ioaddr)
 					goto copy;
 				
@@ -1559,7 +1559,7 @@ static int mxser_ioctl_special(unsigned int cmd, void __user *argp)
 				ip = &mxser_boards[i].ports[j];
 				port = &ip->port;
 
-				mutex_lock(&port->mutex);
+				mutex_lock_tty_off(&port->mutex);
 				if (!ip->ioaddr) {
 					mutex_unlock(&port->mutex);
 					continue;
@@ -1706,12 +1706,12 @@ static int mxser_ioctl(struct tty_struct *tty, struct file *file,
 
 	switch (cmd) {
 	case TIOCGSERIAL:
-		mutex_lock(&port->mutex);
+		mutex_lock_tty_off(&port->mutex);
 		retval = mxser_get_serial_info(tty, argp);
 		mutex_unlock(&port->mutex);
 		return retval;
 	case TIOCSSERIAL:
-		mutex_lock(&port->mutex);
+		mutex_lock_tty_off(&port->mutex);
 		retval = mxser_set_serial_info(tty, argp);
 		mutex_unlock(&port->mutex);
 		return retval;
diff --git a/drivers/char/riscom8.c b/drivers/char/riscom8.c
index af4de1f..8fc0956 100644
--- a/drivers/char/riscom8.c
+++ b/drivers/char/riscom8.c
@@ -1183,7 +1183,7 @@ static int rc_set_serial_info(struct tty_struct *tty, struct riscom_port *port,
 	if (copy_from_user(&tmp, newinfo, sizeof(tmp)))
 		return -EFAULT;
 
-	mutex_lock(&port->port.mutex);
+	mutex_lock_tty_off(&port->port.mutex);
 	change_speed = ((port->port.flags & ASYNC_SPD_MASK) !=
 			(tmp.flags & ASYNC_SPD_MASK));
 
@@ -1224,7 +1224,7 @@ static int rc_get_serial_info(struct riscom_port *port,
 	tmp.type = PORT_CIRRUS;
 	tmp.line = port - rc_port;
 
-	mutex_lock(&port->port.mutex);
+	mutex_lock_tty_off(&port->port.mutex);
 	tmp.port = bp->base;
 	tmp.irq  = bp->irq;
 	tmp.flags = port->port.flags;
diff --git a/drivers/char/rocket.c b/drivers/char/rocket.c
index 79c3bc6..b32147b 100644
--- a/drivers/char/rocket.c
+++ b/drivers/char/rocket.c
@@ -1016,7 +1016,7 @@ static void rp_close(struct tty_struct *tty, struct file *filp)
 	if (tty_port_close_start(port, tty, filp) == 0)
 		return;
 
-	mutex_lock(&port->mutex);
+	mutex_lock_tty_on(&port->mutex);
 	cp = &info->channel;
 	/*
 	 * Before we drop DTR, make sure the UART transmitter
@@ -1214,7 +1214,7 @@ static int get_config(struct r_port *info, struct rocket_config __user *retinfo)
 	if (!retinfo)
 		return -EFAULT;
 	memset(&tmp, 0, sizeof (tmp));
-	mutex_lock(&info->port.mutex);
+	mutex_lock_tty_off(&info->port.mutex);
 	tmp.line = info->line;
 	tmp.flags = info->flags;
 	tmp.close_delay = info->port.close_delay;
@@ -1235,7 +1235,7 @@ static int set_config(struct tty_struct *tty, struct r_port *info,
 	if (copy_from_user(&new_serial, new_info, sizeof (new_serial)))
 		return -EFAULT;
 
-	mutex_lock(&info->port.mutex);
+	mutex_lock_tty_off(&info->port.mutex);
 	if (!capable(CAP_SYS_ADMIN))
 	{
 		if ((new_serial.flags & ~ROCKET_USR_MASK) != (info->flags & ~ROCKET_USR_MASK)) {
diff --git a/drivers/char/specialix.c b/drivers/char/specialix.c
index 7be456f..234aefc 100644
--- a/drivers/char/specialix.c
+++ b/drivers/char/specialix.c
@@ -1863,7 +1863,7 @@ static int sx_set_serial_info(struct specialix_port *port,
 		return -EFAULT;
 	}
 
-	mutex_lock(&port->port.mutex);
+	mutex_lock_tty_off(&port->port.mutex);
 	change_speed = ((port->port.flags & ASYNC_SPD_MASK) !=
 			(tmp.flags & ASYNC_SPD_MASK));
 	change_speed |= (tmp.custom_divisor != port->custom_divisor);
@@ -1905,7 +1905,7 @@ static int sx_get_serial_info(struct specialix_port *port,
 	func_enter();
 
 	memset(&tmp, 0, sizeof(tmp));
-	mutex_lock(&port->port.mutex);
+	mutex_lock_tty_off(&port->port.mutex);
 	tmp.type = PORT_CIRRUS;
 	tmp.line = port - sx_port;
 	tmp.port = bp->base;
diff --git a/drivers/char/stallion.c b/drivers/char/stallion.c
index f2167f8..4053d19 100644
--- a/drivers/char/stallion.c
+++ b/drivers/char/stallion.c
@@ -1028,7 +1028,7 @@ static int stl_getserial(struct stlport *portp, struct serial_struct __user *sp)
 
 	memset(&sio, 0, sizeof(struct serial_struct));
 
-	mutex_lock(&portp->port.mutex);
+	mutex_lock_tty_off(&portp->port.mutex);
 	sio.line = portp->portnr;
 	sio.port = portp->ioaddr;
 	sio.flags = portp->port.flags;
@@ -1070,7 +1070,7 @@ static int stl_setserial(struct tty_struct *tty, struct serial_struct __user *sp
 
 	if (copy_from_user(&sio, sp, sizeof(struct serial_struct)))
 		return -EFAULT;
-	mutex_lock(&portp->port.mutex);
+	mutex_lock_tty_off(&portp->port.mutex);
 	if (!capable(CAP_SYS_ADMIN)) {
 		if ((sio.baud_base != portp->baud_base) ||
 		    (sio.close_delay != portp->close_delay) ||
@@ -1656,7 +1656,9 @@ static void stl_cleanup_panels(struct stlbrd *brdp)
 				continue;
 			tty = tty_port_tty_get(&portp->port);
 			if (tty != NULL) {
+				tty_lock(); /* call tty_port_hangup with BTM */
 				stl_hangup(tty);
+				tty_unlock();
 				tty_kref_put(tty);
 			}
 			kfree(portp->tx.buf);
@@ -2329,7 +2331,7 @@ static int stl_getportstats(struct tty_struct *tty, struct stlport *portp, comst
 			return -ENODEV;
 	}
 
-	mutex_lock(&portp->port.mutex);
+	mutex_lock_tty_off(&portp->port.mutex);
 	portp->stats.state = portp->istate;
 	portp->stats.flags = portp->port.flags;
 	portp->stats.hwid = portp->hwid;
@@ -2386,7 +2388,7 @@ static int stl_clrportstats(struct stlport *portp, comstats_t __user *cp)
 			return -ENODEV;
 	}
 
-	mutex_lock(&portp->port.mutex);
+	mutex_lock_tty_off(&portp->port.mutex);
 	memset(&portp->stats, 0, sizeof(comstats_t));
 	portp->stats.brd = portp->brdnr;
 	portp->stats.panel = portp->panelnr;
diff --git a/drivers/char/synclink.c b/drivers/char/synclink.c
index 4de1246..da64db8 100644
--- a/drivers/char/synclink.c
+++ b/drivers/char/synclink.c
@@ -2435,7 +2435,7 @@ static int mgsl_get_stats(struct mgsl_struct * info, struct mgsl_icount __user *
 	if (!user_icount) {
 		memset(&info->icount, 0, sizeof(info->icount));
 	} else {
-		mutex_lock(&info->port.mutex);
+		mutex_lock_tty_off(&info->port.mutex);
 		COPY_TO_USER(err, user_icount, &info->icount, sizeof(struct mgsl_icount));
 		mutex_unlock(&info->port.mutex);
 		if (err)
@@ -2462,7 +2462,7 @@ static int mgsl_get_params(struct mgsl_struct * info, MGSL_PARAMS __user *user_p
 		printk("%s(%d):mgsl_get_params(%s)\n",
 			 __FILE__,__LINE__, info->device_name);
 			
-	mutex_lock(&info->port.mutex);
+	mutex_lock_tty_off(&info->port.mutex);
 	COPY_TO_USER(err,user_params, &info->params, sizeof(MGSL_PARAMS));
 	mutex_unlock(&info->port.mutex);
 	if (err) {
@@ -2504,7 +2504,7 @@ static int mgsl_set_params(struct mgsl_struct * info, MGSL_PARAMS __user *new_pa
 		return -EFAULT;
 	}
 	
-	mutex_lock(&info->port.mutex);
+	mutex_lock_tty_off(&info->port.mutex);
 	spin_lock_irqsave(&info->irq_spinlock,flags);
 	memcpy(&info->params,&tmp_params,sizeof(MGSL_PARAMS));
 	spin_unlock_irqrestore(&info->irq_spinlock,flags);
@@ -3111,7 +3111,7 @@ static void mgsl_close(struct tty_struct *tty, struct file * filp)
 	if (tty_port_close_start(&info->port, tty, filp) == 0)			 
 		goto cleanup;
 
-	mutex_lock(&info->port.mutex);			
+	mutex_lock_tty_on(&info->port.mutex);			
  	if (info->port.flags & ASYNC_INITIALIZED)
  		mgsl_wait_until_sent(tty, info->timeout);
 	mgsl_flush_buffer(tty);
diff --git a/drivers/char/synclink_gt.c b/drivers/char/synclink_gt.c
index c56b70a..171ec04 100644
--- a/drivers/char/synclink_gt.c
+++ b/drivers/char/synclink_gt.c
@@ -675,7 +675,7 @@ static int open(struct tty_struct *tty, struct file *filp)
 		goto cleanup;
 	}
 
-	mutex_lock(&info->port.mutex);
+	mutex_lock_tty_on(&info->port.mutex);
 	info->port.tty->low_latency = (info->port.flags & ASYNC_LOW_LATENCY) ? 1 : 0;
 
 	spin_lock_irqsave(&info->netlock, flags);
@@ -726,7 +726,7 @@ static void close(struct tty_struct *tty, struct file *filp)
 	if (tty_port_close_start(&info->port, tty, filp) == 0)
 		goto cleanup;
 
-	mutex_lock(&info->port.mutex);
+	mutex_lock_tty_on(&info->port.mutex);
  	if (info->port.flags & ASYNC_INITIALIZED)
  		wait_until_sent(tty, info->timeout);
 	flush_buffer(tty);
@@ -752,7 +752,7 @@ static void hangup(struct tty_struct *tty)
 
 	flush_buffer(tty);
 
-	mutex_lock(&info->port.mutex);
+	mutex_lock_tty_on(&info->port.mutex);
 	shutdown(info);
 
 	spin_lock_irqsave(&info->port.lock, flags);
@@ -1076,7 +1076,7 @@ static int ioctl(struct tty_struct *tty, struct file *file,
 	case MGSL_IOCWAITGPIO:
 		return wait_gpio(info, argp);
 	}
-	mutex_lock(&info->port.mutex);
+	mutex_lock_tty_off(&info->port.mutex);
 	switch (cmd) {
 	case MGSL_IOCGPARAMS:
 		ret = get_params(info, argp);
diff --git a/drivers/char/synclinkmp.c b/drivers/char/synclinkmp.c
index cfa581e..10b07a6 100644
--- a/drivers/char/synclinkmp.c
+++ b/drivers/char/synclinkmp.c
@@ -813,7 +813,7 @@ static void close(struct tty_struct *tty, struct file *filp)
 	if (tty_port_close_start(&info->port, tty, filp) == 0)
 		goto cleanup;
 
-	mutex_lock(&info->port.mutex);		
+	mutex_lock_tty_on(&info->port.mutex);		
  	if (info->port.flags & ASYNC_INITIALIZED)
  		wait_until_sent(tty, info->timeout);
 
@@ -845,7 +845,7 @@ static void hangup(struct tty_struct *tty)
 	if (sanity_check(info, tty->name, "hangup"))
 		return;
 
-	mutex_lock(&info->port.mutex);		
+	mutex_lock_tty_on(&info->port.mutex);		
 	flush_buffer(tty);
 	shutdown(info);
 
@@ -2876,7 +2876,7 @@ static int get_stats(SLMP_INFO * info, struct mgsl_icount __user *user_icount)
 	if (!user_icount) {
 		memset(&info->icount, 0, sizeof(info->icount));
 	} else {
-		mutex_lock(&info->port.mutex);
+		mutex_lock_tty_off(&info->port.mutex);
 		COPY_TO_USER(err, user_icount, &info->icount, sizeof(struct mgsl_icount));
 		mutex_unlock(&info->port.mutex);
 		if (err)
@@ -2893,7 +2893,7 @@ static int get_params(SLMP_INFO * info, MGSL_PARAMS __user *user_params)
 		printk("%s(%d):%s get_params()\n",
 			 __FILE__,__LINE__, info->device_name);
 
-	mutex_lock(&info->port.mutex);
+	mutex_lock_tty_off(&info->port.mutex);
 	COPY_TO_USER(err,user_params, &info->params, sizeof(MGSL_PARAMS));
 	mutex_unlock(&info->port.mutex);
 	if (err) {
@@ -2923,7 +2923,7 @@ static int set_params(SLMP_INFO * info, MGSL_PARAMS __user *new_params)
 		return -EFAULT;
 	}
 
-	mutex_lock(&info->port.mutex);
+	mutex_lock_tty_off(&info->port.mutex);
 	spin_lock_irqsave(&info->lock,flags);
 	memcpy(&info->params,&tmp_params,sizeof(MGSL_PARAMS));
 	spin_unlock_irqrestore(&info->lock,flags);
diff --git a/drivers/char/tty_port.c b/drivers/char/tty_port.c
index a3bd1d0..dbcfc48 100644
--- a/drivers/char/tty_port.c
+++ b/drivers/char/tty_port.c
@@ -118,7 +118,7 @@ EXPORT_SYMBOL(tty_port_tty_set);
 
 static void tty_port_shutdown(struct tty_port *port)
 {
-	mutex_lock(&port->mutex);
+	mutex_lock_tty_on(&port->mutex);
 	if (port->ops->shutdown && !port->console &&
 		test_and_clear_bit(ASYNCB_INITIALIZED, &port->flags))
 			port->ops->shutdown(port);
@@ -424,7 +424,7 @@ int tty_port_open(struct tty_port *port, struct tty_struct *tty,
 	 * port mutex.
 	 */
 
-	mutex_lock(&port->mutex);
+	mutex_lock_tty_on(&port->mutex);
 
 	if (!test_bit(ASYNCB_INITIALIZED, &port->flags)) {
 		clear_bit(TTY_IO_ERROR, &tty->flags);
diff --git a/drivers/mmc/card/sdio_uart.c b/drivers/mmc/card/sdio_uart.c
index a071696..d9bb5bd 100644
--- a/drivers/mmc/card/sdio_uart.c
+++ b/drivers/mmc/card/sdio_uart.c
@@ -160,7 +160,7 @@ static void sdio_uart_port_remove(struct sdio_uart_port *port)
 	 * give up on that port ASAP.
 	 * Beware: the lock ordering is critical.
 	 */
-	mutex_lock(&port->port.mutex);
+	mutex_lock_tty_off(&port->port.mutex);
 	mutex_lock(&port->func_lock);
 	func = port->func;
 	sdio_claim_host(func);
diff --git a/drivers/serial/pmac_zilog.c b/drivers/serial/pmac_zilog.c
index 700e108..1f3757e 100644
--- a/drivers/serial/pmac_zilog.c
+++ b/drivers/serial/pmac_zilog.c
@@ -1668,7 +1668,7 @@ static int pmz_suspend(struct macio_dev *mdev, pm_message_t pm_state)
 	state = pmz_uart_reg.state + uap->port.line;
 
 	mutex_lock(&pmz_irq_mutex);
-	mutex_lock(&state->port.mutex);
+	mutex_lock_tty_off(&state->port.mutex);
 
 	spin_lock_irqsave(&uap->port.lock, flags);
 
@@ -1728,7 +1728,7 @@ static int pmz_resume(struct macio_dev *mdev)
 	state = pmz_uart_reg.state + uap->port.line;
 
 	mutex_lock(&pmz_irq_mutex);
-	mutex_lock(&state->port.mutex);
+	mutex_lock_tty_off(&state->port.mutex);
 
 	spin_lock_irqsave(&uap->port.lock, flags);
 	if (!ZS_IS_OPEN(uap) && !ZS_IS_CONS(uap)) {
diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 803332b..a9d51eb 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -645,7 +645,7 @@ static int uart_get_info(struct uart_state *state,
 
 	/* Ensure the state we copy is consistent and no hardware changes
 	   occur as we go */
-	mutex_lock(&port->mutex);
+	mutex_lock_tty_off(&port->mutex);
 
 	tmp.type	    = uport->type;
 	tmp.line	    = uport->line;
@@ -704,7 +704,7 @@ static int uart_set_info(struct tty_struct *tty, struct uart_state *state,
 	 * module insertion/removal doesn't change anything
 	 * under us.
 	 */
-	mutex_lock(&port->mutex);
+	mutex_lock_tty_off(&port->mutex);
 
 	change_irq  = !(uport->flags & UPF_FIXED_PORT)
 		&& new_serial.irq != uport->irq;
@@ -913,7 +913,7 @@ static int uart_tiocmget(struct tty_struct *tty, struct file *file)
 	struct uart_port *uport = state->uart_port;
 	int result = -EIO;
 
-	mutex_lock(&port->mutex);
+	mutex_lock_tty_off(&port->mutex);
 	if ((!file || !tty_hung_up_p(file)) &&
 	    !(tty->flags & (1 << TTY_IO_ERROR))) {
 		result = uport->mctrl;
@@ -936,7 +936,7 @@ uart_tiocmset(struct tty_struct *tty, struct file *file,
 	struct tty_port *port = &state->port;
 	int ret = -EIO;
 
-	mutex_lock(&port->mutex);
+	mutex_lock_tty_off(&port->mutex);
 	if ((!file || !tty_hung_up_p(file)) &&
 	    !(tty->flags & (1 << TTY_IO_ERROR))) {
 		uart_update_mctrl(uport, set, clear);
@@ -952,7 +952,7 @@ static int uart_break_ctl(struct tty_struct *tty, int break_state)
 	struct tty_port *port = &state->port;
 	struct uart_port *uport = state->uart_port;
 
-	mutex_lock(&port->mutex);
+	mutex_lock_tty_off(&port->mutex);
 
 	if (uport->type != PORT_UNKNOWN)
 		uport->ops->break_ctl(uport, break_state);
@@ -975,7 +975,7 @@ static int uart_do_autoconfig(struct tty_struct *tty,struct uart_state *state)
 	 * changing, and hence any extra opens of the port while
 	 * we're auto-configuring.
 	 */
-	if (mutex_lock_interruptible(&port->mutex))
+	if (mutex_lock_interruptible_tty(&port->mutex))
 		return -ERESTARTSYS;
 
 	ret = -EBUSY;
@@ -1159,7 +1159,7 @@ uart_ioctl(struct tty_struct *tty, struct file *filp, unsigned int cmd,
 	if (ret != -ENOIOCTLCMD)
 		goto out;
 
-	mutex_lock(&port->mutex);
+	mutex_lock_tty_off(&port->mutex);
 
 	if (tty_hung_up_p(filp)) {
 		ret = -EIO;
@@ -1283,7 +1283,7 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 
 	pr_debug("uart_close(%d) called\n", uport->line);
 
-	mutex_lock(&port->mutex);
+	mutex_lock_tty_on(&port->mutex);
 
 	if (tty_hung_up_p(filp))
 		goto done;
@@ -1433,7 +1433,7 @@ static void uart_hangup(struct tty_struct *tty)
 	BUG_ON(!tty_locked());
 	pr_debug("uart_hangup(%d)\n", state->uart_port->line);
 
-	mutex_lock(&port->mutex);
+	mutex_lock_tty_on(&port->mutex);
 	if (port->flags & ASYNC_NORMAL_ACTIVE) {
 		uart_flush_buffer(tty);
 		uart_shutdown(tty, state);
@@ -1551,7 +1551,7 @@ uart_block_til_ready(struct file *filp, struct uart_state *state)
 
 		mutex_unlock(&port->mutex);
 		schedule();
-		mutex_lock(&port->mutex);
+		mutex_lock_tty_on(&port->mutex);
 
 		if (signal_pending(current))
 			break;
@@ -1579,7 +1579,7 @@ static struct uart_state *uart_get(struct uart_driver *drv, int line)
 
 	state = drv->state + line;
 	port = &state->port;
-	if (mutex_lock_interruptible(&port->mutex)) {
+	if (mutex_lock_interruptible_tty(&port->mutex)) {
 		ret = -ERESTARTSYS;
 		goto err;
 	}
@@ -1736,7 +1736,7 @@ static void uart_line_info(struct seq_file *m, struct uart_driver *drv, int i)
 	}
 
 	if (capable(CAP_SYS_ADMIN)) {
-		mutex_lock(&port->mutex);
+		mutex_lock_tty_off(&port->mutex);
 		pm_state = state->pm_state;
 		if (pm_state)
 			uart_change_pm(state, 0);
@@ -2016,7 +2016,7 @@ int uart_suspend_port(struct uart_driver *drv, struct uart_port *uport)
 	struct uart_match match = {uport, drv};
 	struct tty_struct *tty;
 
-	mutex_lock(&port->mutex);
+	mutex_lock_tty_off(&port->mutex);
 
 	/* Must be inside the mutex lock until we convert to tty_port */
 	tty = port->tty;
@@ -2085,7 +2085,7 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *uport)
 	struct uart_match match = {uport, drv};
 	struct ktermios termios;
 
-	mutex_lock(&port->mutex);
+	mutex_lock_tty_off(&port->mutex);
 
 	tty_dev = device_find_child(uport->dev, &match, serial_match_port);
 	if (!uport->suspended && device_may_wakeup(tty_dev)) {
@@ -2447,7 +2447,7 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *uport)
 	port = &state->port;
 
 	mutex_lock(&port_mutex);
-	mutex_lock(&port->mutex);
+	mutex_lock_tty_off(&port->mutex);
 	if (state->uart_port) {
 		ret = -EINVAL;
 		goto out;
@@ -2520,7 +2520,7 @@ int uart_remove_one_port(struct uart_driver *drv, struct uart_port *uport)
 	 * Mark the port "dead" - this prevents any opens from
 	 * succeeding while we shut down the port.
 	 */
-	mutex_lock(&port->mutex);
+	mutex_lock_tty_off(&port->mutex);
 	uport->flags |= UPF_DEAD;
 	mutex_unlock(&port->mutex);
 
diff --git a/drivers/usb/serial/opticon.c b/drivers/usb/serial/opticon.c
index ed01f3b..ebc45e1 100644
--- a/drivers/usb/serial/opticon.c
+++ b/drivers/usb/serial/opticon.c
@@ -497,7 +497,7 @@ static int opticon_resume(struct usb_interface *intf)
 	struct usb_serial_port *port = serial->port[0];
 	int result;
 
-	mutex_lock(&port->port.mutex);
+	mutex_lock_tty_off(&port->port.mutex);
 	/* This is protected by the port mutex against close/open */
 	if (test_bit(ASYNCB_INITIALIZED, &port->port.flags))
 		result = usb_submit_urb(priv->bulk_read_urb, GFP_NOIO);
-- 
1.7.0.4

