Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813Ab1GIFyZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 01:54:25 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:37828 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752339Ab1GIFyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 01:54:07 -0400
X-Sasl-enc: L5xyLNXA1FtrrspcbYg/E4O+X24H36Cm3VvnA/UW7OWg 1310190846
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Jul  8 15:51:19 2011
Message-Id: <20110708225119.318022925@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 08 Jul 2011 15:49:54 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Slaby <jslaby@suse.cz>
Subject: [05/35] TTY: ldisc, do not close until there are readers
In-Reply-To: <20110708225343.GA14402@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

commit 92f6fa09bd453ffe3351fa1f1377a1b7cfa911e6 upstream.

We restored tty_ldisc_wait_idle in 100eeae2c5c (TTY: restore
tty_ldisc_wait_idle). We used it in the ldisc changing path to fix the
case where there are tasks in n_tty_read waiting for data and somebody
tries to change ldisc.

Similar to the case above, there may be also tasks waiting in
n_tty_read while hangup is performed. As 65b770468e98 (tty-ldisc: turn
ldisc user count into a proper refcount) removed the wait-until-idle
from all paths, hangup path won't wait for them to disappear either
now. So add it back even to the hangup path.

There is a difference, we need uninterruptible sleep as there is
obviously HUP signal pending. So tty_ldisc_wait_idle now sleeps
without possibility to be interrupted. This is what original
tty_ldisc_wait_idle did. After the wait idle reintroduction
(100eeae2c5c), we have had interruptible sleeps for the ldisc changing
path. But as there is a 5s timeout anyway, we don't allow it to be
interrupted from now on. It's not worth the added complexity of
deciding what kind of sleep we want.

Before 65b770468e98 tty_ldisc_release was called also from
tty_ldisc_release. It is called from tty_release, so I don't think we
need to restore that one.

This is nicely reproducible after constifying the timing when
drivers/tty/n_tty.c is patched as follows ("TTY: ntty, add one more
sanity check" patch is needed to actually see it explode):
%% -1548,6 +1549,7 @@ static int n_tty_open(struct tty_struct *tty)

        /* These are ugly. Currently a malloc failure here can panic */
        if (!tty->read_buf) {
+               msleep(100);
                tty->read_buf = kzalloc(N_TTY_BUF_SIZE, GFP_KERNEL);
                if (!tty->read_buf)
                        return -ENOMEM;
%% -1785,6 +1788,7 @@ do_it_again:
                                break;
                        }
                        timeout = schedule_timeout(timeout);
+                       msleep(20);
                        continue;
                }
                __set_current_state(TASK_RUNNING);
===== With a process: =====
    while (1) {
        int fd = open(argv[1], O_RDWR);
        read(fd, buf, sizeof(buf));
        close(fd);
    }
===== and its child: =====
        setsid();
        while (1) {
                int fd = open(tty, O_RDWR|O_NOCTTY);
                ioctl(fd, TIOCSCTTY, 1);
                vhangup();
                close(fd);
                usleep(100 * (10 + random() % 1000));
        }
===== EOF =====

References: https://bugzilla.novell.com/show_bug.cgi?id=693374
References: https://bugzilla.novell.com/show_bug.cgi?id=694509
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/tty_ldisc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -539,7 +539,7 @@ static int tty_ldisc_halt(struct tty_str
 static int tty_ldisc_wait_idle(struct tty_struct *tty)
 {
 	int ret;
-	ret = wait_event_interruptible_timeout(tty_ldisc_idle,
+	ret = wait_event_timeout(tty_ldisc_idle,
 			atomic_read(&tty->ldisc->users) == 1, 5 * HZ);
 	if (ret < 0)
 		return ret;
@@ -735,6 +735,8 @@ static int tty_ldisc_reinit(struct tty_s
 	if (IS_ERR(ld))
 		return -1;
 
+	WARN_ON_ONCE(tty_ldisc_wait_idle(tty));
+
 	tty_ldisc_close(tty, tty->ldisc);
 	tty_ldisc_put(tty->ldisc);
 	tty->ldisc = NULL;


