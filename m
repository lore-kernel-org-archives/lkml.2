Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175Ab2CBOpG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 09:45:06 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:56934 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756139Ab2CBOpC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 09:45:02 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/6] vt: push down the tty lock so we can see what is left to
 tackle
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Date: Fri, 02 Mar 2012 14:59:20 +0000
Message-ID: <20120302145919.32320.99758.stgit@bob.linux.org.uk>
In-Reply-To: <20120302145628.32320.53944.stgit@bob.linux.org.uk>
References: <20120302145628.32320.53944.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

At this point we have the tty_lock guarding a couple of oddities, plus the
translation and unimap still.

We also extend the console_lock in a couple of spots where coverage is wrong
and switch vcs_open to use the right lock !

[Fixed the locking issue Jiri reported]

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/tty/vt/vc_screen.c |    4 +-
 drivers/tty/vt/vt_ioctl.c  |   92 +++++++++++++++++++++++++++-----------------
 2 files changed, 59 insertions(+), 37 deletions(-)


diff --git a/drivers/tty/vt/vc_screen.c b/drivers/tty/vt/vc_screen.c
index 7a367ff..fa7268a 100644
--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -608,10 +608,10 @@ vcs_open(struct inode *inode, struct file *filp)
 	unsigned int currcons = iminor(inode) & 127;
 	int ret = 0;
 	
-	tty_lock();
+	console_lock();
 	if(currcons && !vc_cons_allocated(currcons-1))
 		ret = -ENXIO;
-	tty_unlock();
+	console_unlock();
 	return ret;
 }
 
diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index 28ca0aa..e05094d 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -281,7 +281,6 @@ int vt_ioctl(struct tty_struct *tty,
 
 	console = vc->vc_num;
 
-	tty_lock();
 
 	if (!vc_cons_allocated(console)) { 	/* impossible? */
 		ret = -ENOIOCTLCMD;
@@ -299,16 +298,18 @@ int vt_ioctl(struct tty_struct *tty,
  
 	switch (cmd) {
 	case TIOCLINUX:
+		tty_lock();
 		ret = tioclinux(tty, arg);
+		tty_unlock();
 		break;
 	case KIOCSOUND:
 		if (!perm)
-			goto eperm;
+			return -EPERM;
 		/*
 		 * The use of PIT_TICK_RATE is historic, it used to be
 		 * the platform-dependent CLOCK_TICK_RATE between 2.6.12
 		 * and 2.6.36, which was a minor but unfortunate ABI
-		 * change.
+		 * change. kd_mksound is locked by the input layer.
 		 */
 		if (arg)
 			arg = PIT_TICK_RATE / arg;
@@ -317,7 +318,7 @@ int vt_ioctl(struct tty_struct *tty,
 
 	case KDMKTONE:
 		if (!perm)
-			goto eperm;
+			return -EPERM;
 	{
 		unsigned int ticks, count;
 		
@@ -335,7 +336,7 @@ int vt_ioctl(struct tty_struct *tty,
 
 	case KDGKBTYPE:
 		/*
-		 * this is naive.
+		 * this is naïve.
 		 */
 		ucval = KB_101;
 		ret = put_user(ucval, (char __user *)arg);
@@ -353,6 +354,8 @@ int vt_ioctl(struct tty_struct *tty,
 		/*
 		 * KDADDIO and KDDELIO may be able to add ports beyond what
 		 * we reject here, but to be safe...
+		 *
+		 * These are locked internally via sys_ioperm
 		 */
 		if (arg < GPFIRST || arg > GPLAST) {
 			ret = -EINVAL;
@@ -375,7 +378,7 @@ int vt_ioctl(struct tty_struct *tty,
 		struct kbd_repeat kbrep;
 		
 		if (!capable(CAP_SYS_TTY_CONFIG))
-			goto eperm;
+			return -EPERM;
 
 		if (copy_from_user(&kbrep, up, sizeof(struct kbd_repeat))) {
 			ret =  -EFAULT;
@@ -399,7 +402,7 @@ int vt_ioctl(struct tty_struct *tty,
 		 * need to restore their engine state. --BenH
 		 */
 		if (!perm)
-			goto eperm;
+			return -EPERM;
 		switch (arg) {
 		case KD_GRAPHICS:
 			break;
@@ -412,6 +415,7 @@ int vt_ioctl(struct tty_struct *tty,
 			ret = -EINVAL;
 			goto out;
 		}
+		/* FIXME: this needs the console lock extending */
 		if (vc->vc_mode == (unsigned char) arg)
 			break;
 		vc->vc_mode = (unsigned char) arg;
@@ -443,7 +447,7 @@ int vt_ioctl(struct tty_struct *tty,
 
 	case KDSKBMODE:
 		if (!perm)
-			goto eperm;
+			return -EPERM;
 		ret = vt_do_kdskbmode(console, arg);
 		if (ret == 0)
 			tty_ldisc_flush(tty);
@@ -512,7 +516,7 @@ int vt_ioctl(struct tty_struct *tty,
 	case KDSIGACCEPT:
 	{
 		if (!perm || !capable(CAP_KILL))
-			goto eperm;
+			return -EPERM;
 		if (!valid_signal(arg) || arg < 1 || arg == SIGKILL)
 			ret = -EINVAL;
 		else {
@@ -530,7 +534,7 @@ int vt_ioctl(struct tty_struct *tty,
 		struct vt_mode tmp;
 
 		if (!perm)
-			goto eperm;
+			return -EPERM;
 		if (copy_from_user(&tmp, up, sizeof(struct vt_mode))) {
 			ret = -EFAULT;
 			goto out;
@@ -576,6 +580,7 @@ int vt_ioctl(struct tty_struct *tty,
 		struct vt_stat __user *vtstat = up;
 		unsigned short state, mask;
 
+		/* Review: FIXME: Console lock ? */
 		if (put_user(fg_console + 1, &vtstat->v_active))
 			ret = -EFAULT;
 		else {
@@ -593,6 +598,7 @@ int vt_ioctl(struct tty_struct *tty,
 	 * Returns the first available (non-opened) console.
 	 */
 	case VT_OPENQRY:
+		/* FIXME: locking ? - but then this is a stupid API */
 		for (i = 0; i < MAX_NR_CONSOLES; ++i)
 			if (! VT_IS_IN_USE(i))
 				break;
@@ -606,7 +612,7 @@ int vt_ioctl(struct tty_struct *tty,
 	 */
 	case VT_ACTIVATE:
 		if (!perm)
-			goto eperm;
+			return -EPERM;
 		if (arg == 0 || arg > MAX_NR_CONSOLES)
 			ret =  -ENXIO;
 		else {
@@ -625,7 +631,7 @@ int vt_ioctl(struct tty_struct *tty,
 		struct vt_setactivate vsa;
 
 		if (!perm)
-			goto eperm;
+			return -EPERM;
 
 		if (copy_from_user(&vsa, (struct vt_setactivate __user *)arg,
 					sizeof(struct vt_setactivate))) {
@@ -653,6 +659,7 @@ int vt_ioctl(struct tty_struct *tty,
 			if (ret)
 				break;
 			/* Commence switch and lock */
+			/* Review set_console locks */
 			set_console(vsa.console);
 		}
 		break;
@@ -663,11 +670,14 @@ int vt_ioctl(struct tty_struct *tty,
 	 */
 	case VT_WAITACTIVE:
 		if (!perm)
-			goto eperm;
+			return -EPERM;
 		if (arg == 0 || arg > MAX_NR_CONSOLES)
 			ret = -ENXIO;
-		else
+		else {
+			tty_lock();
 			ret = vt_waitactive(arg);
+			tty_unlock();
+		}
 		break;
 
 	/*
@@ -682,16 +692,17 @@ int vt_ioctl(struct tty_struct *tty,
 	 */
 	case VT_RELDISP:
 		if (!perm)
-			goto eperm;
+			return -EPERM;
 
+		console_lock();
 		if (vc->vt_mode.mode != VT_PROCESS) {
+			console_unlock();
 			ret = -EINVAL;
 			break;
 		}
 		/*
 		 * Switching-from response
 		 */
-		console_lock();
 		if (vc->vt_newvt >= 0) {
 			if (arg == 0)
 				/*
@@ -768,7 +779,7 @@ int vt_ioctl(struct tty_struct *tty,
 
 		ushort ll,cc;
 		if (!perm)
-			goto eperm;
+			return -EPERM;
 		if (get_user(ll, &vtsizes->v_rows) ||
 		    get_user(cc, &vtsizes->v_cols))
 			ret = -EFAULT;
@@ -779,6 +790,7 @@ int vt_ioctl(struct tty_struct *tty,
 
 				if (vc) {
 					vc->vc_resize_user = 1;
+					/* FIXME: review v tty lock */
 					vc_resize(vc_cons[i].d, cc, ll);
 				}
 			}
@@ -792,7 +804,7 @@ int vt_ioctl(struct tty_struct *tty,
 		struct vt_consize __user *vtconsize = up;
 		ushort ll,cc,vlin,clin,vcol,ccol;
 		if (!perm)
-			goto eperm;
+			return -EPERM;
 		if (!access_ok(VERIFY_READ, vtconsize,
 				sizeof(struct vt_consize))) {
 			ret = -EFAULT;
@@ -848,7 +860,7 @@ int vt_ioctl(struct tty_struct *tty,
 
 	case PIO_FONT: {
 		if (!perm)
-			goto eperm;
+			return -EPERM;
 		op.op = KD_FONT_OP_SET;
 		op.flags = KD_FONT_FLAG_OLD | KD_FONT_FLAG_DONT_RECALC;	/* Compatibility */
 		op.width = 8;
@@ -889,7 +901,7 @@ int vt_ioctl(struct tty_struct *tty,
 	case PIO_FONTRESET:
 	{
 		if (!perm)
-			goto eperm;
+			return -EPERM;
 
 #ifdef BROKEN_GRAPHICS_PROGRAMS
 		/* With BROKEN_GRAPHICS_PROGRAMS defined, the default
@@ -915,7 +927,7 @@ int vt_ioctl(struct tty_struct *tty,
 			break;
 		}
 		if (!perm && op.op != KD_FONT_OP_GET)
-			goto eperm;
+			return -EPERM;
 		ret = con_font_op(vc, &op);
 		if (ret)
 			break;
@@ -927,50 +939,65 @@ int vt_ioctl(struct tty_struct *tty,
 	case PIO_SCRNMAP:
 		if (!perm)
 			ret = -EPERM;
-		else
+		else {
+			tty_lock();
 			ret = con_set_trans_old(up);
+			tty_unlock();
+		}
 		break;
 
 	case GIO_SCRNMAP:
+		tty_lock();
 		ret = con_get_trans_old(up);
+		tty_unlock();
 		break;
 
 	case PIO_UNISCRNMAP:
 		if (!perm)
 			ret = -EPERM;
-		else
+		else {
+			tty_lock();
 			ret = con_set_trans_new(up);
+			tty_unlock();
+		}
 		break;
 
 	case GIO_UNISCRNMAP:
+		tty_lock();
 		ret = con_get_trans_new(up);
+		tty_unlock();
 		break;
 
 	case PIO_UNIMAPCLR:
 	      { struct unimapinit ui;
 		if (!perm)
-			goto eperm;
+			return -EPERM;
 		ret = copy_from_user(&ui, up, sizeof(struct unimapinit));
 		if (ret)
 			ret = -EFAULT;
-		else
+		else {
+			tty_lock();
 			con_clear_unimap(vc, &ui);
+			tty_unlock();
+		}
 		break;
 	      }
 
 	case PIO_UNIMAP:
 	case GIO_UNIMAP:
+		tty_lock();
 		ret = do_unimap_ioctl(cmd, up, perm, vc);
+		tty_unlock();
 		break;
 
 	case VT_LOCKSWITCH:
 		if (!capable(CAP_SYS_TTY_CONFIG))
-			goto eperm;
+			return -EPERM;
 		vt_dont_switch = 1;
 		break;
 	case VT_UNLOCKSWITCH:
 		if (!capable(CAP_SYS_TTY_CONFIG))
-			goto eperm;
+			return -EPERM;
 		vt_dont_switch = 0;
 		break;
 	case VT_GETHIFONTMASK:
@@ -984,11 +1011,7 @@ int vt_ioctl(struct tty_struct *tty,
 		ret = -ENOIOCTLCMD;
 	}
 out:
-	tty_unlock();
 	return ret;
-eperm:
-	ret = -EPERM;
-	goto out;
 }
 
 void reset_vc(struct vc_data *vc)
@@ -1150,8 +1173,6 @@ long vt_compat_ioctl(struct tty_struct *tty,
 
 	console = vc->vc_num;
 
-	tty_lock();
-
 	if (!vc_cons_allocated(console)) { 	/* impossible? */
 		ret = -ENOIOCTLCMD;
 		goto out;
@@ -1180,7 +1201,9 @@ long vt_compat_ioctl(struct tty_struct *tty,
 
 	case PIO_UNIMAP:
 	case GIO_UNIMAP:
+		tty_lock();
 		ret = compat_unimap_ioctl(cmd, up, perm, vc);
+		tty_unlock();
 		break;
 
 	/*
@@ -1217,11 +1240,9 @@ long vt_compat_ioctl(struct tty_struct *tty,
 		goto fallback;
 	}
 out:
-	tty_unlock();
 	return ret;
 
 fallback:
-	tty_unlock();
 	return vt_ioctl(tty, cmd, arg);
 }
 
@@ -1407,6 +1428,7 @@ int vt_move_to_console(unsigned int vt, int alloc)
 		return -EIO;
 	}
 	console_unlock();
+	/* Review: I don't see why we need tty_lock here FIXME */
 	tty_lock();
 	if (vt_waitactive(vt + 1)) {
 		pr_debug("Suspend: Can't switch VCs.");

