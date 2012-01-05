Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250Ab2AEJF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 04:05:27 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59964 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab2AEJFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 04:05:17 -0500
Subject: [PATCH for tty-next] tty: cleanup prohibition of direct opening for
 unix98 pty master
To: Greg Kroah-Hartman <gregkh@suse.de>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 05 Jan 2012 13:04:21 +0400
Message-ID: <20120105090421.27444.48117.stgit@zurg>
In-Reply-To: <20120105002336.GA30069@kroah.com>
References: <20120105002336.GA30069@kroah.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cleanup hack added in v2.6.27-3203-g15582d3

comment from that patch:

: pty: If the administrator creates a device for a ptmx slave we should not error
:
: The open path for ptmx slaves is via the ptmx device. Opening them any
: other way is not allowed. Vegard Nossum found that previously this was not
: the case and mknod foo c 128 42; cat foo would produce nasty diagnostics
:
: Signed-off-by: Alan Cox <alan@redhat.com>
: Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

devpts_get_tty() returns non-null only for inodes on devpts, but there is no
inodes for master-devices, /dev/ptmx (/dev/pts/ptmx) is the only way to open them.
Thus we can completely forbid lookup for master-devices and eliminate that hack in
tty_init_dev() because tty_open() will get EIO from tty_driver_lookup_tty().

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 drivers/tty/pty.c    |    8 +++-----
 drivers/tty/tty_io.c |   12 ++----------
 include/linux/tty.h  |    3 +--
 3 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index d8653ab..03147fa 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -515,10 +515,8 @@ static int pty_unix98_ioctl(struct tty_struct *tty,
 static struct tty_struct *ptm_unix98_lookup(struct tty_driver *driver,
 		struct inode *ptm_inode, int idx)
 {
-	struct tty_struct *tty = devpts_get_tty(ptm_inode, idx);
-	if (tty)
-		tty = tty->link;
-	return tty;
+	/* Master must be open via /dev/ptmx */
+	return ERR_PTR(-EIO);
 }
 
 /**
@@ -677,7 +675,7 @@ static int ptmx_open(struct inode *inode, struct file *filp)
 
 	mutex_lock(&tty_mutex);
 	tty_lock();
-	tty = tty_init_dev(ptm_driver, index, 1);
+	tty = tty_init_dev(ptm_driver, index);
 	mutex_unlock(&tty_mutex);
 
 	if (IS_ERR(tty)) {
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 57c3743..a4fd717 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1365,7 +1365,6 @@ static int tty_reopen(struct tty_struct *tty)
  *	@driver: tty driver we are opening a device on
  *	@idx: device index
  *	@ret_tty: returned tty structure
- *	@first_ok: ok to open a new device (used by ptmx)
  *
  *	Prepare a tty device. This may not be a "new" clean device but
  *	could also be an active device. The pty drivers require special
@@ -1385,18 +1384,11 @@ static int tty_reopen(struct tty_struct *tty)
  * relaxed for the (most common) case of reopening a tty.
  */
 
-struct tty_struct *tty_init_dev(struct tty_driver *driver, int idx,
-								int first_ok)
+struct tty_struct *tty_init_dev(struct tty_driver *driver, int idx)
 {
 	struct tty_struct *tty;
 	int retval;
 
-	/* Check if pty master is being opened multiple times */
-	if (driver->subtype == PTY_TYPE_MASTER &&
-		(driver->flags & TTY_DRIVER_DEVPTS_MEM) && !first_ok) {
-		return ERR_PTR(-EIO);
-	}
-
 	/*
 	 * First time open is complex, especially for PTY devices.
 	 * This code guarantees that either everything succeeds and the
@@ -1950,7 +1942,7 @@ retry_open:
 		if (retval)
 			tty = ERR_PTR(retval);
 	} else
-		tty = tty_init_dev(driver, index, 0);
+		tty = tty_init_dev(driver, index);
 
 	mutex_unlock(&tty_mutex);
 	if (driver)
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 5dbb3cb..d3ebd76 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -480,8 +480,7 @@ extern void free_tty_struct(struct tty_struct *tty);
 extern void initialize_tty_struct(struct tty_struct *tty,
 		struct tty_driver *driver, int idx);
 extern void deinitialize_tty_struct(struct tty_struct *tty);
-extern struct tty_struct *tty_init_dev(struct tty_driver *driver, int idx,
-								int first_ok);
+extern struct tty_struct *tty_init_dev(struct tty_driver *driver, int idx);
 extern int tty_release(struct inode *inode, struct file *filp);
 extern int tty_init_termios(struct tty_struct *tty);
 

