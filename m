Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029Ab0LHCNI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 21:13:08 -0500
Received: from kroah.org ([198.145.64.141]:46068 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756039Ab0LHArI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:47:08 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:28 2010
Message-Id: <20101208004428.612566004@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:43:49 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@linux.intel.com>
Subject: [043/127] TTY: ldisc, fix open flag handling
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Slaby <jslaby@suse.cz>

commit 7f90cfc505d613f4faf096e0d84ffe99208057d9 upstream.

When a concrete ldisc open fails in tty_ldisc_open, we forget to clear
TTY_LDISC_OPEN. This causes a false warning on the next ldisc open:
WARNING: at drivers/char/tty_ldisc.c:445 tty_ldisc_open+0x26/0x38()
Hardware name: System Product Name
Modules linked in: ...
Pid: 5251, comm: a.out Tainted: G        W  2.6.32-5-686 #1
Call Trace:
 [<c1030321>] ? warn_slowpath_common+0x5e/0x8a
 [<c1030357>] ? warn_slowpath_null+0xa/0xc
 [<c119311c>] ? tty_ldisc_open+0x26/0x38
 [<c11936c5>] ? tty_set_ldisc+0x218/0x304
...

So clear the bit when failing...

Introduced in c65c9bc3efa (tty: rewrite the ldisc locking) back in
2.6.31-rc1.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@linux.intel.com>
Reported-by: Sergey Lapin <slapin@ossfans.org>
Tested-by: Sergey Lapin <slapin@ossfans.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/tty_ldisc.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -444,9 +444,14 @@ static void tty_set_termios_ldisc(struct
 
 static int tty_ldisc_open(struct tty_struct *tty, struct tty_ldisc *ld)
 {
+	int ret;
+
 	WARN_ON(test_and_set_bit(TTY_LDISC_OPEN, &tty->flags));
-	if (ld->ops->open)
-		return ld->ops->open(tty);
+	if (ld->ops->open) {
+		ret = ld->ops->open(tty);
+		if (ret)
+			clear_bit(TTY_LDISC_OPEN, &tty->flags);
+	}
 	return 0;
 }
 


