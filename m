Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752433Ab1KPP10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 10:27:26 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:52988 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab1KPP1R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 10:27:17 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Alan Cox <alan@linux.intel.com>
Subject: [PATCH 5/5] TTY: pty, cleanup the pty counting
Date: Wed, 16 Nov 2011 16:27:11 +0100
Message-Id: <1321457231-9154-5-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1321457231-9154-1-git-send-email-jslaby@suse.cz>
References: <1321457231-9154-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of the hackish way of counting ptys, let's define a specific
->remove hook both from slave and master. And decrease the count only
for master.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>
---
 drivers/tty/pty.c |   26 +++++++++-----------------
 1 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index e18604b..d8653ab 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -446,19 +446,8 @@ static inline void legacy_pty_init(void) { }
 int pty_limit = NR_UNIX98_PTY_DEFAULT;
 static int pty_limit_min;
 static int pty_limit_max = NR_UNIX98_PTY_MAX;
-static int tty_count;
 static int pty_count;
 
-static inline void pty_inc_count(void)
-{
-	pty_count = (++tty_count) / 2;
-}
-
-static inline void pty_dec_count(void)
-{
-	pty_count = (--tty_count) / 2;
-}
-
 static struct cdev ptmx_cdev;
 
 static struct ctl_table pty_table[] = {
@@ -600,8 +589,7 @@ static int pty_unix98_install(struct tty_driver *driver, struct tty_struct *tty)
 	 */
 	tty_driver_kref_get(driver);
 	tty->count++;
-	pty_inc_count(); /* tty */
-	pty_inc_count(); /* tty->link */
+	pty_count++;
 	return 0;
 err_free_mem:
 	deinitialize_tty_struct(o_tty);
@@ -613,15 +601,19 @@ err_free_tty:
 	return -ENOMEM;
 }
 
-static void pty_unix98_remove(struct tty_driver *driver, struct tty_struct *tty)
+static void ptm_unix98_remove(struct tty_driver *driver, struct tty_struct *tty)
+{
+	pty_count--;
+}
+
+static void pts_unix98_remove(struct tty_driver *driver, struct tty_struct *tty)
 {
-	pty_dec_count();
 }
 
 static const struct tty_operations ptm_unix98_ops = {
 	.lookup = ptm_unix98_lookup,
 	.install = pty_unix98_install,
-	.remove = pty_unix98_remove,
+	.remove = ptm_unix98_remove,
 	.open = pty_open,
 	.close = pty_close,
 	.write = pty_write,
@@ -638,7 +630,7 @@ static const struct tty_operations ptm_unix98_ops = {
 static const struct tty_operations pty_unix98_ops = {
 	.lookup = pts_unix98_lookup,
 	.install = pty_unix98_install,
-	.remove = pty_unix98_remove,
+	.remove = pts_unix98_remove,
 	.open = pty_open,
 	.close = pty_close,
 	.write = pty_write,
-- 
1.7.7.3


