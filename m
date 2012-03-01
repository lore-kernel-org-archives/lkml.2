Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993Ab2CAThG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 14:37:06 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:46310 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756867Ab2CAThC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 14:37:02 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 3/6] vt: push down tioclinux cases
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Date: Thu, 01 Mar 2012 19:51:17 +0000
Message-ID: <20120301195027.11322.66375.stgit@bob.linux.org.uk>
In-Reply-To: <20120301194831.11322.38295.stgit@bob.linux.org.uk>
References: <20120301194831.11322.38295.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Some of this ventures into selection which is still a complete lost cause. We
are not making it any worse. It's completely busted anyway.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/tty/vt/selection.c |   12 ++++++------
 drivers/tty/vt/vt.c        |   12 ++++++++++++
 drivers/tty/vt/vt_ioctl.c  |    2 --
 3 files changed, 18 insertions(+), 8 deletions(-)


diff --git a/drivers/tty/vt/selection.c b/drivers/tty/vt/selection.c
index 738e45a..2a50916 100644
--- a/drivers/tty/vt/selection.c
+++ b/drivers/tty/vt/selection.c
@@ -75,7 +75,7 @@ clear_selection(void) {
 
 /*
  * User settable table: what characters are to be considered alphabetic?
- * 256 bits
+ * 256 bits. FIXME: Needs a locking model.
  */
 static u32 inwordLut[8]={
   0x00000000, /* control chars     */
@@ -307,7 +307,8 @@ int set_selection(const struct tiocl_selection __user *sel, struct tty_struct *t
  * queue of the tty associated with the current console.
  * Invoked by ioctl().
  *
- * Locking: always called with BTM from vt_ioctl
+ * Locking: called without locks. Calls the ldisc wrongly with
+ * unsafe methods,
  */
 int paste_selection(struct tty_struct *tty)
 {
@@ -322,13 +323,12 @@ int paste_selection(struct tty_struct *tty)
 	poke_blanked_console();
 	console_unlock();
 
+	/* FIXME: wtf is this supposed to achieve ? */
 	ld = tty_ldisc_ref(tty);
-	if (!ld) {
-		tty_unlock();
+	if (!ld)
 		ld = tty_ldisc_ref_wait(tty);
-		tty_lock();
-	}
 
+	/* FIXME: this is completely unsafe */
 	add_wait_queue(&vc->paste_wait, &wait);
 	while (sel_buffer && sel_buffer_lth > pasted) {
 		set_current_state(TASK_INTERRUPTIBLE);
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 8439303..280a4c4 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -2637,11 +2637,15 @@ int tioclinux(struct tty_struct *tty, unsigned long arg)
 			ret = __put_user(data, p);
 			break;
 		case TIOCL_GETMOUSEREPORTING:
+			console_lock();	/* May be overkill */
 			data = mouse_reporting();
+			console_unlock();
 			ret = __put_user(data, p);
 			break;
 		case TIOCL_SETVESABLANK:
+			console_lock();
 			ret = set_vesa_blanking(p);
+			console_unlock();
 			break;
 		case TIOCL_GETKMSGREDIRECT:
 			data = vt_get_kmsg_redirect();
@@ -2658,13 +2662,21 @@ int tioclinux(struct tty_struct *tty, unsigned long arg)
 			}
 			break;
 		case TIOCL_GETFGCONSOLE:
+			/* No locking needed as this is a transiently
+			   correct return anyway if the caller hasn't
+			   disabled switching */
 			ret = fg_console;
 			break;
 		case TIOCL_SCROLLCONSOLE:
 			if (get_user(lines, (s32 __user *)(p+4))) {
 				ret = -EFAULT;
 			} else {
+				/* Need the console lock here. Note that lots
+				   of other calls need fixing before the lock
+				   is actually useful ! */
+				console_lock();
 				scrollfront(vc_cons[fg_console].d, lines);
+				console_unlock();
 				ret = 0;
 			}
 			break;
diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index 16ad235..f0b5143 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -298,9 +298,7 @@ int vt_ioctl(struct tty_struct *tty,
  
 	switch (cmd) {
 	case TIOCLINUX:
-		tty_lock();
 		ret = tioclinux(tty, arg);
-		tty_unlock();
 		break;
 	case KIOCSOUND:
 		if (!perm)

