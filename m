Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281Ab1I1WhI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:37:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53384 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754817Ab1I1WhF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:37:05 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:26 2011
Message-Id: <20110928220126.623341163@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 14:59:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [013/244] TTY: pty, fix pty counting
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

commit 24d406a6bf736f7aebdc8fa0f0ec86e0890c6d24 upstream.

tty_operations->remove is normally called like:
queue_release_one_tty
 ->tty_shutdown
   ->tty_driver_remove_tty
     ->tty_operations->remove

However tty_shutdown() is called from queue_release_one_tty() only if
tty_operations->shutdown is NULL. But for pty, it is not.
pty_unix98_shutdown() is used there as ->shutdown.

So tty_operations->remove of pty (i.e. pty_unix98_remove()) is never
called. This results in invalid pty_count. I.e. what can be seen in
/proc/sys/kernel/pty/nr.

I see this was already reported at:
  https://lkml.org/lkml/2009/11/5/370
But it was not fixed since then.

This patch is kind of a hackish way. The problem lies in ->install. We
allocate there another tty (so-called tty->link). So ->install is
called once, but ->remove twice, for both tty and tty->link. The fix
here is to count both tty and tty->link and divide the count by 2 for
user.

And to have ->remove called, let's make tty_driver_remove_tty() global
and call that from pty_unix98_shutdown() (tty_operations->shutdown).

While at it, let's document that when ->shutdown is defined,
tty_shutdown() is not called.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/tty/pty.c          |   17 +++++++++++++++--
 drivers/tty/tty_io.c       |    3 +--
 include/linux/tty.h        |    2 ++
 include/linux/tty_driver.h |    3 +++
 4 files changed, 21 insertions(+), 4 deletions(-)

--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -446,8 +446,19 @@ static inline void legacy_pty_init(void)
 int pty_limit = NR_UNIX98_PTY_DEFAULT;
 static int pty_limit_min;
 static int pty_limit_max = NR_UNIX98_PTY_MAX;
+static int tty_count;
 static int pty_count;
 
+static inline void pty_inc_count(void)
+{
+	pty_count = (++tty_count) / 2;
+}
+
+static inline void pty_dec_count(void)
+{
+	pty_count = (--tty_count) / 2;
+}
+
 static struct cdev ptmx_cdev;
 
 static struct ctl_table pty_table[] = {
@@ -542,6 +553,7 @@ static struct tty_struct *pts_unix98_loo
 
 static void pty_unix98_shutdown(struct tty_struct *tty)
 {
+	tty_driver_remove_tty(tty->driver, tty);
 	/* We have our own method as we don't use the tty index */
 	kfree(tty->termios);
 }
@@ -588,7 +600,8 @@ static int pty_unix98_install(struct tty
 	 */
 	tty_driver_kref_get(driver);
 	tty->count++;
-	pty_count++;
+	pty_inc_count(); /* tty */
+	pty_inc_count(); /* tty->link */
 	return 0;
 err_free_mem:
 	deinitialize_tty_struct(o_tty);
@@ -602,7 +615,7 @@ err_free_tty:
 
 static void pty_unix98_remove(struct tty_driver *driver, struct tty_struct *tty)
 {
-	pty_count--;
+	pty_dec_count();
 }
 
 static const struct tty_operations ptm_unix98_ops = {
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1294,8 +1294,7 @@ static int tty_driver_install_tty(struct
  *
  *	Locking: tty_mutex for now
  */
-static void tty_driver_remove_tty(struct tty_driver *driver,
-						struct tty_struct *tty)
+void tty_driver_remove_tty(struct tty_driver *driver, struct tty_struct *tty)
 {
 	if (driver->ops->remove)
 		driver->ops->remove(driver, tty);
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -420,6 +420,8 @@ extern void tty_driver_flush_buffer(stru
 extern void tty_throttle(struct tty_struct *tty);
 extern void tty_unthrottle(struct tty_struct *tty);
 extern int tty_do_resize(struct tty_struct *tty, struct winsize *ws);
+extern void tty_driver_remove_tty(struct tty_driver *driver,
+				  struct tty_struct *tty);
 extern void tty_shutdown(struct tty_struct *tty);
 extern void tty_free_termios(struct tty_struct *tty);
 extern int is_current_pgrp_orphaned(void);
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -47,6 +47,9 @@
  *
  * 	This routine is called synchronously when a particular tty device
  *	is closed for the last time freeing up the resources.
+ *	Note that tty_shutdown() is not called if ops->shutdown is defined.
+ *	This means one is responsible to take care of calling ops->remove (e.g.
+ *	via tty_driver_remove_tty) and releasing tty->termios.
  *
  *
  * void (*cleanup)(struct tty_struct * tty);


