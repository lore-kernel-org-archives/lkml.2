Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219Ab0LHBBg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:01:36 -0500
Received: from kroah.org ([198.145.64.141]:49023 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757362Ab0LHBBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:01:32 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:35 2010
Message-Id: <20101208005735.299793812@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:58:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Slaby <jslaby@suse.cz>, Kyle McMartin <kyle@mcmartin.ca>
Subject: [139/289] TTY: dont allow reopen when ldisc is changing
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -1304,7 +1304,8 @@ static int tty_reopen(struct tty_struct
 {
 	struct tty_driver *driver = tty->driver;
 
-	if (test_bit(TTY_CLOSING, &tty->flags))
+	if (test_bit(TTY_CLOSING, &tty->flags) ||
+			test_bit(TTY_LDISC_CHANGING, &tty->flags))
 		return -EIO;
 
 	if (driver->type == TTY_DRIVER_TYPE_PTY &&


