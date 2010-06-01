Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab0FAU6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 16:58:38 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57462 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757385Ab0FAUxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 16:53:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>, Alan Cox <alan@linux.intel.com>
Subject: [PATCH 01/31] stallion: prune lock_kernel calls
Date: Tue,  1 Jun 2010 22:52:41 +0200
Message-Id: <1275425591-8803-2-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275425591-8803-1-git-send-email-arnd@arndb.de>
References: <1275425591-8803-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19nZAsE2IxphpfwI2XTsMook0/XR6EbNyThoEM
 B09PIAw9637UU0qYl8p8lbEF1e3X1oU4bpwajDPgGQnG1obQLn
 k01uP95dLC6no/TmR5IhQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Remove unneeded tty layer lock kernel bits. Relock the needed bits using the
port mutex. The istallion still has brd state races but those are not new
or introduced by the removal of the lock_kernel logic.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 drivers/char/istallion.c |   22 +++++++++++++---------
 drivers/char/stallion.c  |   20 ++++++++++++--------
 2 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/drivers/char/istallion.c b/drivers/char/istallion.c
index 4e395c9..750650c 100644
--- a/drivers/char/istallion.c
+++ b/drivers/char/istallion.c
@@ -14,6 +14,7 @@
  *	the Free Software Foundation; either version 2 of the License, or
  *	(at your option) any later version.
  *
+ *	FIXME: brdp->state needs proper locking.
  */
 
 /*****************************************************************************/
@@ -4011,6 +4012,7 @@ static int stli_getbrdstats(combrd_t __user *bp)
 		return -ENODEV;
 
 	memset(&stli_brdstats, 0, sizeof(combrd_t));
+
 	stli_brdstats.brd = brdp->brdnr;
 	stli_brdstats.type = brdp->brdtype;
 	stli_brdstats.hwid = 0;
@@ -4076,10 +4078,13 @@ static int stli_portcmdstats(struct tty_struct *tty, struct stliport *portp)
 	if (brdp == NULL)
 		return -ENODEV;
 
+	mutex_lock(&portp->port.mutex);
 	if (brdp->state & BST_STARTED) {
 		if ((rc = stli_cmdwait(brdp, portp, A_GETSTATS,
-		    &stli_cdkstats, sizeof(asystats_t), 1)) < 0)
+		    &stli_cdkstats, sizeof(asystats_t), 1)) < 0) {
+			mutex_unlock(&portp->port.mutex);
 			return rc;
+		}
 	} else {
 		memset(&stli_cdkstats, 0, sizeof(asystats_t));
 	}
@@ -4124,6 +4129,7 @@ static int stli_portcmdstats(struct tty_struct *tty, struct stliport *portp)
 	stli_comstats.modem = stli_cdkstats.dcdcnt;
 	stli_comstats.hwid = stli_cdkstats.hwid;
 	stli_comstats.signals = stli_mktiocm(stli_cdkstats.signals);
+	mutex_unlock(&portp->port.mutex);
 
 	return 0;
 }
@@ -4186,15 +4192,20 @@ static int stli_clrportstats(struct stliport *portp, comstats_t __user *cp)
 	if (!brdp)
 		return -ENODEV;
 
+	mutex_lock(&portp->port.mutex);
+
 	if (brdp->state & BST_STARTED) {
-		if ((rc = stli_cmdwait(brdp, portp, A_CLEARSTATS, NULL, 0, 0)) < 0)
+		if ((rc = stli_cmdwait(brdp, portp, A_CLEARSTATS, NULL, 0, 0)) < 0) {
+			mutex_unlock(&portp->port.mutex);
 			return rc;
+		}
 	}
 
 	memset(&stli_comstats, 0, sizeof(comstats_t));
 	stli_comstats.brd = portp->brdnr;
 	stli_comstats.panel = portp->panelnr;
 	stli_comstats.port = portp->portnr;
+	mutex_unlock(&portp->port.mutex);
 
 	if (copy_to_user(cp, &stli_comstats, sizeof(comstats_t)))
 		return -EFAULT;
@@ -4266,8 +4277,6 @@ static long stli_memioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 	done = 0;
 	rc = 0;
 
-	lock_kernel();
-
 	switch (cmd) {
 	case COM_GETPORTSTATS:
 		rc = stli_getportstats(NULL, NULL, argp);
@@ -4290,8 +4299,6 @@ static long stli_memioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 		done++;
 		break;
 	}
-	unlock_kernel();
-
 	if (done)
 		return rc;
 
@@ -4308,8 +4315,6 @@ static long stli_memioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 	if (brdp->state == 0)
 		return -ENODEV;
 
-	lock_kernel();
-
 	switch (cmd) {
 	case STL_BINTR:
 		EBRDINTR(brdp);
@@ -4332,7 +4337,6 @@ static long stli_memioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 		rc = -ENOIOCTLCMD;
 		break;
 	}
-	unlock_kernel();
 	return rc;
 }
 
diff --git a/drivers/char/stallion.c b/drivers/char/stallion.c
index 6049fd7..f2167f8 100644
--- a/drivers/char/stallion.c
+++ b/drivers/char/stallion.c
@@ -807,7 +807,6 @@ static void stl_waituntilsent(struct tty_struct *tty, int timeout)
 		timeout = HZ;
 	tend = jiffies + timeout;
 
-	lock_kernel();
 	while (stl_datastate(portp)) {
 		if (signal_pending(current))
 			break;
@@ -815,7 +814,6 @@ static void stl_waituntilsent(struct tty_struct *tty, int timeout)
 		if (time_after_eq(jiffies, tend))
 			break;
 	}
-	unlock_kernel();
 }
 
 /*****************************************************************************/
@@ -1029,6 +1027,8 @@ static int stl_getserial(struct stlport *portp, struct serial_struct __user *sp)
 	pr_debug("stl_getserial(portp=%p,sp=%p)\n", portp, sp);
 
 	memset(&sio, 0, sizeof(struct serial_struct));
+
+	mutex_lock(&portp->port.mutex);
 	sio.line = portp->portnr;
 	sio.port = portp->ioaddr;
 	sio.flags = portp->port.flags;
@@ -1048,6 +1048,7 @@ static int stl_getserial(struct stlport *portp, struct serial_struct __user *sp)
 	brdp = stl_brds[portp->brdnr];
 	if (brdp != NULL)
 		sio.irq = brdp->irq;
+	mutex_unlock(&portp->port.mutex);
 
 	return copy_to_user(sp, &sio, sizeof(struct serial_struct)) ? -EFAULT : 0;
 }
@@ -1069,12 +1070,15 @@ static int stl_setserial(struct tty_struct *tty, struct serial_struct __user *sp
 
 	if (copy_from_user(&sio, sp, sizeof(struct serial_struct)))
 		return -EFAULT;
+	mutex_lock(&portp->port.mutex);
 	if (!capable(CAP_SYS_ADMIN)) {
 		if ((sio.baud_base != portp->baud_base) ||
 		    (sio.close_delay != portp->close_delay) ||
 		    ((sio.flags & ~ASYNC_USR_MASK) !=
-		    (portp->port.flags & ~ASYNC_USR_MASK)))
+		    (portp->port.flags & ~ASYNC_USR_MASK))) {
+			mutex_unlock(&portp->port.mutex);
 			return -EPERM;
+		}
 	} 
 
 	portp->port.flags = (portp->port.flags & ~ASYNC_USR_MASK) |
@@ -1083,6 +1087,7 @@ static int stl_setserial(struct tty_struct *tty, struct serial_struct __user *sp
 	portp->close_delay = sio.close_delay;
 	portp->closing_wait = sio.closing_wait;
 	portp->custom_divisor = sio.custom_divisor;
+	mutex_unlock(&portp->port.mutex);
 	stl_setport(portp, tty->termios);
 	return 0;
 }
@@ -1147,8 +1152,6 @@ static int stl_ioctl(struct tty_struct *tty, struct file *file, unsigned int cmd
 
 	rc = 0;
 
-	lock_kernel();
-
 	switch (cmd) {
 	case TIOCGSERIAL:
 		rc = stl_getserial(portp, argp);
@@ -1173,7 +1176,6 @@ static int stl_ioctl(struct tty_struct *tty, struct file *file, unsigned int cmd
 		rc = -ENOIOCTLCMD;
 		break;
 	}
-	unlock_kernel();
 	return rc;
 }
 
@@ -2327,6 +2329,7 @@ static int stl_getportstats(struct tty_struct *tty, struct stlport *portp, comst
 			return -ENODEV;
 	}
 
+	mutex_lock(&portp->port.mutex);
 	portp->stats.state = portp->istate;
 	portp->stats.flags = portp->port.flags;
 	portp->stats.hwid = portp->hwid;
@@ -2358,6 +2361,7 @@ static int stl_getportstats(struct tty_struct *tty, struct stlport *portp, comst
 		(STL_TXBUFSIZE - (tail - head));
 
 	portp->stats.signals = (unsigned long) stl_getsignals(portp);
+	mutex_unlock(&portp->port.mutex);
 
 	return copy_to_user(cp, &portp->stats,
 			    sizeof(comstats_t)) ? -EFAULT : 0;
@@ -2382,10 +2386,12 @@ static int stl_clrportstats(struct stlport *portp, comstats_t __user *cp)
 			return -ENODEV;
 	}
 
+	mutex_lock(&portp->port.mutex);
 	memset(&portp->stats, 0, sizeof(comstats_t));
 	portp->stats.brd = portp->brdnr;
 	portp->stats.panel = portp->panelnr;
 	portp->stats.port = portp->portnr;
+	mutex_unlock(&portp->port.mutex);
 	return copy_to_user(cp, &portp->stats,
 			    sizeof(comstats_t)) ? -EFAULT : 0;
 }
@@ -2451,7 +2457,6 @@ static long stl_memioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 		return -ENODEV;
 	rc = 0;
 
-	lock_kernel();
 	switch (cmd) {
 	case COM_GETPORTSTATS:
 		rc = stl_getportstats(NULL, NULL, argp);
@@ -2472,7 +2477,6 @@ static long stl_memioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 		rc = -ENOIOCTLCMD;
 		break;
 	}
-	unlock_kernel();
 	return rc;
 }
 
-- 
1.7.0.4

