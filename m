Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353Ab0LMANg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:13:36 -0500
Received: from one.firstfloor.org ([213.235.205.2]:36094 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985Ab0LLXqh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:37 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: jslaby@suse.cz, alan@linux.intel.com, slapin@ossfans.org, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [96/223] TTY: ldisc, fix open flag handling
Message-Id: <20101212234636.46F51B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:36 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 drivers/char/tty_ldisc.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/drivers/char/tty_ldisc.c
===================================================================
--- linux.orig/drivers/char/tty_ldisc.c
+++ linux/drivers/char/tty_ldisc.c
@@ -452,6 +452,8 @@ static int tty_ldisc_open(struct tty_str
                 /* BKL here locks verus a hangup event */
 		lock_kernel();
 		ret = ld->ops->open(tty);
+		if (ret)
+			clear_bit(TTY_LDISC_OPEN, &tty->flags);
 		unlock_kernel();
 		return ret;
 	}
