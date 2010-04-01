Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181Ab0DAQed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 12:34:33 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44889 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758000Ab0DAQeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 12:34:09 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 05/14] stallion: prune lock_kernel calls
To: linux-kernel@vger.kernel.org
Date: Thu, 01 Apr 2010 17:05:19 +0100
Message-ID: <20100401160504.8882.37742.stgit@localhost.localdomain>
In-Reply-To: <20100401155513.8882.54006.stgit@localhost.localdomain>
References: <20100401155513.8882.54006.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unneeded tty layer lock kernel bits. Relock the needed bits using the
port mutex. The istallion still has brd state races but those are not new
or introduced by the removal of the lock_kernel logic.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/istallion.c |   24 +++++++++++++++---------
 drivers/char/stallion.c  |   20 ++++++++++++--------
 2 files changed, 27 insertions(+), 17 deletions(-)


diff --git a/drivers/char/istallion.c b/drivers/char/istallion.c
index 4cd6c52..3699e30 100644
--- a/drivers/char/istallion.c
+++ b/drivers/char/istallion.c
@@ -14,6 +14,7 @@
  *	the Free Software Foundation; either version 2 of the License, or
  *	(at your option) any later version.
  *
+ *	FIXME: brdp->state needs proper locking.
  */
 
 /*****************************************************************************/
@@ -4009,6 +4010,8 @@ static int stli_getbrdstats(combrd_t __user *bp)
 		return -ENODEV;
 
 	memset(&stli_brdstats, 0, sizeof(combrd_t));
+
+	mutex_lock(&portp->port.mutex);
 	stli_brdstats.brd = brdp->brdnr;
 	stli_brdstats.type = brdp->brdtype;
 	stli_brdstats.hwid = 0;
@@ -4022,6 +4025,7 @@ static int stli_getbrdstats(combrd_t __user *bp)
 		stli_brdstats.panels[i].hwid = brdp->panelids[i];
 		stli_brdstats.panels[i].nrports = brdp->panels[i];
 	}
+	mutex_unlock(&portp->port.mutex);
 
 	if (copy_to_user(bp, &stli_brdstats, sizeof(combrd_t)))
 		return -EFAULT;
@@ -4074,10 +4078,13 @@ static int stli_portcmdstats(struct tty_struct *tty, struct stliport *portp)
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
@@ -4122,6 +4129,7 @@ static int stli_portcmdstats(struct tty_struct *tty, struct stliport *portp)
 	stli_comstats.modem = stli_cdkstats.dcdcnt;
 	stli_comstats.hwid = stli_cdkstats.hwid;
 	stli_comstats.signals = stli_mktiocm(stli_cdkstats.signals);
+	mutex_unlock(&portp->port.mutex);
 
 	return 0;
 }
@@ -4184,15 +4192,20 @@ static int stli_clrportstats(struct stliport *portp, comstats_t __user *cp)
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
@@ -4264,8 +4277,6 @@ static long stli_memioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 	done = 0;
 	rc = 0;
 
-	lock_kernel();
-
 	switch (cmd) {
 	case COM_GETPORTSTATS:
 		rc = stli_getportstats(NULL, NULL, argp);
@@ -4288,8 +4299,6 @@ static long stli_memioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 		done++;
 		break;
 	}
-	unlock_kernel();
-
 	if (done)
 		return rc;
 
@@ -4306,8 +4315,6 @@ static long stli_memioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 	if (brdp->state == 0)
 		return -ENODEV;
 
-	lock_kernel();
-
 	switch (cmd) {
 	case STL_BINTR:
 		EBRDINTR(brdp);
@@ -4330,7 +4337,6 @@ static long stli_memioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 		rc = -ENOIOCTLCMD;
 		break;
 	}
-	unlock_kernel();
 	return rc;
 }
 
diff --git a/drivers/char/stallion.c b/drivers/char/stallion.c
index 0e511d6..db5c418 100644
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
@@ -1028,6 +1026,8 @@ static int stl_getserial(struct stlport *portp, struct serial_struct __user *sp)
 	pr_debug("stl_getserial(portp=%p,sp=%p)\n", portp, sp);
 
 	memset(&sio, 0, sizeof(struct serial_struct));
+
+	mutex_lock(&portp->port.mutex);
 	sio.line = portp->portnr;
 	sio.port = portp->ioaddr;
 	sio.flags = portp->port.flags;
@@ -1047,6 +1047,7 @@ static int stl_getserial(struct stlport *portp, struct serial_struct __user *sp)
 	brdp = stl_brds[portp->brdnr];
 	if (brdp != NULL)
 		sio.irq = brdp->irq;
+	mutex_unlock(&portp->port.mutex);
 
 	return copy_to_user(sp, &sio, sizeof(struct serial_struct)) ? -EFAULT : 0;
 }
@@ -1068,12 +1069,15 @@ static int stl_setserial(struct tty_struct *tty, struct serial_struct __user *sp
 
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
@@ -1082,6 +1086,7 @@ static int stl_setserial(struct tty_struct *tty, struct serial_struct __user *sp
 	portp->close_delay = sio.close_delay;
 	portp->closing_wait = sio.closing_wait;
 	portp->custom_divisor = sio.custom_divisor;
+	mutex_unlock(&portp->port.mutex);
 	stl_setport(portp, tty->termios);
 	return 0;
 }
@@ -1146,8 +1151,6 @@ static int stl_ioctl(struct tty_struct *tty, struct file *file, unsigned int cmd
 
 	rc = 0;
 
-	lock_kernel();
-
 	switch (cmd) {
 	case TIOCGSERIAL:
 		rc = stl_getserial(portp, argp);
@@ -1172,7 +1175,6 @@ static int stl_ioctl(struct tty_struct *tty, struct file *file, unsigned int cmd
 		rc = -ENOIOCTLCMD;
 		break;
 	}
-	unlock_kernel();
 	return rc;
 }
 
@@ -2326,6 +2328,7 @@ static int stl_getportstats(struct tty_struct *tty, struct stlport *portp, comst
 			return -ENODEV;
 	}
 
+	mutex_lock(&portp->port.mutex);
 	portp->stats.state = portp->istate;
 	portp->stats.flags = portp->port.flags;
 	portp->stats.hwid = portp->hwid;
@@ -2357,6 +2360,7 @@ static int stl_getportstats(struct tty_struct *tty, struct stlport *portp, comst
 		(STL_TXBUFSIZE - (tail - head));
 
 	portp->stats.signals = (unsigned long) stl_getsignals(portp);
+	mutex_unlock(&portp->port.mutex);
 
 	return copy_to_user(cp, &portp->stats,
 			    sizeof(comstats_t)) ? -EFAULT : 0;
@@ -2381,10 +2385,12 @@ static int stl_clrportstats(struct stlport *portp, comstats_t __user *cp)
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
@@ -2450,7 +2456,6 @@ static long stl_memioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 		return -ENODEV;
 	rc = 0;
 
-	lock_kernel();
 	switch (cmd) {
 	case COM_GETPORTSTATS:
 		rc = stl_getportstats(NULL, NULL, argp);
@@ -2471,7 +2476,6 @@ static long stl_memioctl(struct file *fp, unsigned int cmd, unsigned long arg)
 		rc = -ENOIOCTLCMD;
 		break;
 	}
-	unlock_kernel();
 	return rc;
 }
 

