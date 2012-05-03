Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741Ab2ECVG4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 17:06:56 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58116 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758719Ab2ECVGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 17:06:54 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/3] pty: Lock the devpts bits privately
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Date: Thu, 03 May 2012 22:22:09 +0100
Message-ID: <20120503212205.568.25804.stgit@bob.linux.org.uk>
In-Reply-To: <20120503212151.568.91854.stgit@bob.linux.org.uk>
References: <20120503212151.568.91854.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

This is a private pty affair, we don't want to tangle it with the tty_lock
any more as we know all the other non tty locking is now handled by the vfs
so we too can move.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/tty/pty.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)


diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index eeae7fa..5505ffc 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -26,11 +26,13 @@
 #include <linux/bitops.h>
 #include <linux/devpts_fs.h>
 #include <linux/slab.h>
+#include <linux/mutex.h>
 
 
 #ifdef CONFIG_UNIX98_PTYS
 static struct tty_driver *ptm_driver;
 static struct tty_driver *pts_driver;
+static DEFINE_MUTEX(devpts_mutex);
 #endif
 
 static void pty_close(struct tty_struct *tty, struct file *filp)
@@ -54,8 +56,11 @@ static void pty_close(struct tty_struct *tty, struct file *filp)
 	if (tty->driver->subtype == PTY_TYPE_MASTER) {
 		set_bit(TTY_OTHER_CLOSED, &tty->flags);
 #ifdef CONFIG_UNIX98_PTYS
-		if (tty->driver == ptm_driver)
+		if (tty->driver == ptm_driver) {
+		        mutex_lock(&devpts_mutex);
 			devpts_pty_kill(tty->link);
+		        mutex_unlock(&devpts_mutex);
+		}
 #endif
 		tty_unlock();
 		tty_vhangup(tty->link);
@@ -475,13 +480,17 @@ static struct tty_struct *ptm_unix98_lookup(struct tty_driver *driver,
  *	@idx: tty index
  *
  *	Look up a pty master device. Called under the tty_mutex for now.
- *	This provides our locking.
+ *	This provides our locking for the tty pointer.
  */
 
 static struct tty_struct *pts_unix98_lookup(struct tty_driver *driver,
 		struct inode *pts_inode, int idx)
 {
-	struct tty_struct *tty = devpts_get_tty(pts_inode, idx);
+	struct tty_struct *tty;
+
+	mutex_lock(&devpts_mutex);
+	tty = devpts_get_tty(pts_inode, idx);
+	mutex_unlock(&devpts_mutex);
 	/* Master must be open before slave */
 	if (!tty)
 		return ERR_PTR(-EIO);
@@ -622,8 +631,10 @@ static int ptmx_open(struct inode *inode, struct file *filp)
 	}
 
 	mutex_lock(&tty_mutex);
-	tty_lock();
+	mutex_lock(&devpts_mutex);
 	tty = tty_init_dev(ptm_driver, index);
+	mutex_unlock(&devpts_mutex);
+	tty_lock();
 	mutex_unlock(&tty_mutex);
 
 	if (IS_ERR(tty)) {

