Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758163Ab0LBVI5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 16:08:57 -0500
Received: from kroah.org ([198.145.64.141]:54245 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932164Ab0LBVI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 16:08:28 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jiri Slaby <jslaby@suse.cz>, Kyle McMartin <kyle@mcmartin.ca>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, stable <stable@kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 4/6] TTY: don't allow reopen when ldisc is changing
Date: Thu,  2 Dec 2010 13:08:21 -0800
Message-Id: <1291324103-7054-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101202204827.GB5927@kroah.com>
References: <20101202204827.GB5927@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

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
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/tty/tty_io.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index c05c5af..878f6d6 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1310,7 +1310,8 @@ static int tty_reopen(struct tty_struct *tty)
 {
 	struct tty_driver *driver = tty->driver;
 
-	if (test_bit(TTY_CLOSING, &tty->flags))
+	if (test_bit(TTY_CLOSING, &tty->flags) ||
+			test_bit(TTY_LDISC_CHANGING, &tty->flags))
 		return -EIO;
 
 	if (driver->type == TTY_DRIVER_TYPE_PTY &&
-- 
1.7.1

