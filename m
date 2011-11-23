Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570Ab1KWA5n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 19:57:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42386 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932506Ab1KWAfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 19:35:23 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Nov 22 16:25:55 2011
Message-Id: <20111123002555.262096594@clark.kroah.org>
User-Agent: quilt/0.48-20.1.2
Date: Tue, 22 Nov 2011 16:25:25 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jiri Slaby <jslaby@suse.cz>,
        Dave Young <hidave.darkstar@gmail.com>, Dave Jones <davej@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Dmitriy Matrosov <sgf.dma@gmail.com>
Subject: [25/53] TTY: ldisc, wait for ldisc infinitely in hangup
In-Reply-To: <20111123002601.GA14467@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

commit 0c73c08ec73dbe080b9ec56696ee21d32754d918 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/tty/tty_ldisc.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -36,6 +36,7 @@
 
 #include <linux/kmod.h>
 #include <linux/nsproxy.h>
+#include <linux/ratelimit.h>
 
 /*
  *	This guards the refcounted line discipline lists. The lock
@@ -838,7 +839,7 @@ void tty_ldisc_hangup(struct tty_struct
 	tty_unlock();
 	cancel_work_sync(&tty->buf.work);
 	mutex_unlock(&tty->ldisc_mutex);
-
+retry:
 	tty_lock();
 	mutex_lock(&tty->ldisc_mutex);
 
@@ -847,7 +848,21 @@ void tty_ldisc_hangup(struct tty_struct
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
 


