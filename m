Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab1KPP15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 10:27:57 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:52987 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab1KPP1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 10:27:16 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Dave Young <hidave.darkstar@gmail.com>, Dave Jones <davej@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Dmitriy Matrosov <sgf.dma@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, stable <stable@kernel.org>
Subject: [PATCH 3/5] TTY: ldisc, wait for ldisc infinitely in hangup
Date: Wed, 16 Nov 2011 16:27:09 +0100
Message-Id: <1321457231-9154-3-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1321457231-9154-1-git-send-email-jslaby@suse.cz>
References: <1321457231-9154-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For /dev/console case, we do not kill all ldisc users. It's due to
redirected_tty_write test in __tty_hangup. In that case there still
might be a process waiting e.g. in n_tty_read for input.

We wait for such processes to disappear. The problem is that we use a
timeout. After this timeout, we continue closing the ldisc and start
freeing tty resources. It obviously leads to crashes when the other
process is woken.

So to fix this, we wait infinitely before reiniting the ldisc. (The
tiocsetd remains untouched -- times out after 5s.)

This is nicely reproducible with this run from shell:
  exec 0<>/dev/console 1<>/dev/console 2<>/dev/console
and stopping a getty like:
  systemctl stop serial-getty@ttyS0.service

The crash proper may be produced only under load or with constified
timing the same as for 92f6fa09b.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Dave Young <hidave.darkstar@gmail.com>
Cc: Dave Jones <davej@redhat.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Cc: Dmitriy Matrosov <sgf.dma@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: stable <stable@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/tty/tty_ldisc.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index a69a755..8e0924f 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -36,6 +36,7 @@
 
 #include <linux/kmod.h>
 #include <linux/nsproxy.h>
+#include <linux/ratelimit.h>
 
 /*
  *	This guards the refcounted line discipline lists. The lock
@@ -837,7 +838,7 @@ void tty_ldisc_hangup(struct tty_struct *tty)
 	tty_unlock();
 	cancel_work_sync(&tty->buf.work);
 	mutex_unlock(&tty->ldisc_mutex);
-
+retry:
 	tty_lock();
 	mutex_lock(&tty->ldisc_mutex);
 
@@ -846,7 +847,21 @@ void tty_ldisc_hangup(struct tty_struct *tty)
 	   it means auditing a lot of other paths so this is
 	   a FIXME */
 	if (tty->ldisc) {	/* Not yet closed */
-		WARN_ON_ONCE(tty_ldisc_wait_idle(tty, 5 * HZ));
+		if (atomic_read(&tty->ldisc->users) != 1) {
+			char cur_n[TASK_COMM_LEN], tty_n[64];
+			long timeout = 3 * HZ;
+			tty_unlock();
+
+			while (tty_ldisc_wait_idle(tty, timeout) == -EBUSY) {
+				timeout = MAX_SCHEDULE_TIMEOUT;
+				printk_ratelimited(KERN_WARNING
+					"%s: waiting (%s) for %s took too long, but we keep waiting...\n",
+					__func__, get_task_comm(cur_n, current),
+					tty_name(tty, tty_n));
+			}
+			mutex_unlock(&tty->ldisc_mutex);
+			goto retry;
+		}
 
 		if (reset == 0) {
 
-- 
1.7.7.3


