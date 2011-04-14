Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933623Ab1DNSQH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:16:07 -0400
Received: from mail.windriver.com ([147.11.1.11]:41845 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964889Ab1DNR6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:58:10 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Kyle McMartin <kyle@mcmartin.ca>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 132/209] TTY: don't allow reopen when ldisc is changing
Date: Thu, 14 Apr 2011 13:54:50 -0400
Message-Id: <1302803767-9715-19-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit e2efafbf139d2bfdfe96f2901f03189fecd172e4 upstream

There are many WARNINGs like the following reported nowadays:
WARNING: at drivers/tty/tty_io.c:1331 tty_open+0x2a2/0x49a()
Hardware name: Latitude E6500
Modules linked in:
Pid: 1207, comm: plymouthd Not tainted 2.6.37-rc3-mmotm1123 #3
Call Trace:
 [<ffffffff8103b189>] warn_slowpath_common+0x80/0x98
 [<ffffffff8103b1b6>] warn_slowpath_null+0x15/0x17
 [<ffffffff8128a3ab>] tty_open+0x2a2/0x49a
 [<ffffffff810fd53f>] chrdev_open+0x11d/0x146
...

This means tty_reopen is called without TTY_LDISC set. For further
considerations, note tty_lock is held in tty_open. TTY_LDISC is cleared in:
1) __tty_hangup from tty_ldisc_hangup to tty_ldisc_enable. During this
section tty_lock is held. However tty_lock is temporarily dropped in
the middle of the function by tty_ldisc_hangup.

2) tty_release via tty_ldisc_release till the end of tty existence. If
tty->count <= 1, tty_lock is taken, TTY_CLOSING bit set and then
tty_ldisc_release called. tty_reopen checks TTY_CLOSING before checking
TTY_LDISC.

3) tty_set_ldisc from tty_ldisc_halt to tty_ldisc_enable. We:
   * take tty_lock, set TTY_LDISC_CHANGING, put tty_lock
   * call tty_ldisc_halt (clear TTY_LDISC), tty_lock is _not_ held
   * do some other work
   * take tty_lock, call tty_ldisc_enable (set TTY_LDISC), put
     tty_lock

I cannot see how 2) can be a problem, as there I see no race. OTOH, 1)
and 3) can happen without problems. This patch the case 3) by checking
TTY_LDISC_CHANGING along with TTY_CLOSING in tty_reopen. 1) will be
fixed in the following patch.

Nicely reproducible with two processes:
while (1) {
	fd = open("/dev/ttyS1", O_RDWR);
	if (fd < 0) {
		warn("open");
		continue;
	}
	close(fd);
}
--------
while (1) {
        fd = open("/dev/ttyS1", O_RDWR);
        ld1 = 0; ld2 = 2;
        while (1) {
                ioctl(fd, TIOCSETD, &ld1);
                ioctl(fd, TIOCSETD, &ld2);
        }
        close(fd);
}

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Reported-by: <Valdis.Kletnieks@vt.edu>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/char/tty_io.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index d71f0fc..bc4f45d 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1257,7 +1257,8 @@ static int tty_reopen(struct tty_struct *tty)
 {
 	struct tty_driver *driver = tty->driver;
 
-	if (test_bit(TTY_CLOSING, &tty->flags))
+	if (test_bit(TTY_CLOSING, &tty->flags) ||
+			test_bit(TTY_LDISC_CHANGING, &tty->flags))
 		return -EIO;
 
 	if (driver->type == TTY_DRIVER_TYPE_PTY &&
-- 
1.7.4.4

