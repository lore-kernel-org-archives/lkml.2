Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143Ab0LMANS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:13:18 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36102 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754996Ab0LLXqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:38 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: jslaby@suse.cz, ak@linux.intel.com, kyle@mcmartin.ca,
        alan@lxorguk.ukuu.org.uk, gregkh@suse.de, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [97/223] TTY: don't allow reopen when ldisc is changing
Message-Id: <20101212234637.5476BB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:37 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Jiri Slaby <jslaby@suse.cz>

commit e2efafbf139d2bfdfe96f2901f03189fecd172e4 upstream.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

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

---
 drivers/char/tty_io.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux/drivers/char/tty_io.c
===================================================================
--- linux.orig/drivers/char/tty_io.c
+++ linux/drivers/char/tty_io.c
@@ -1257,7 +1257,8 @@ static int tty_reopen(struct tty_struct
 {
 	struct tty_driver *driver = tty->driver;
 
-	if (test_bit(TTY_CLOSING, &tty->flags))
+	if (test_bit(TTY_CLOSING, &tty->flags) ||
+			test_bit(TTY_LDISC_CHANGING, &tty->flags))
 		return -EIO;
 
 	if (driver->type == TTY_DRIVER_TYPE_PTY &&
