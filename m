Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab0LBVJW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 16:09:22 -0500
Received: from kroah.org ([198.145.64.141]:54235 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758114Ab0LBVI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 16:08:26 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jiri Slaby <jslaby@suse.cz>, Alan Cox <alan@linux.intel.com>,
        stable <stable@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 2/6] TTY: ldisc, fix open flag handling
Date: Thu,  2 Dec 2010 13:08:19 -0800
Message-Id: <1291324103-7054-2-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101202204827.GB5927@kroah.com>
References: <20101202204827.GB5927@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

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
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/tty/tty_ldisc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index d8e96b0..4214d58 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -454,6 +454,8 @@ static int tty_ldisc_open(struct tty_struct *tty, struct tty_ldisc *ld)
                 /* BTM here locks versus a hangup event */
 		WARN_ON(!tty_locked());
 		ret = ld->ops->open(tty);
+		if (ret)
+			clear_bit(TTY_LDISC_OPEN, &tty->flags);
 		return ret;
 	}
 	return 0;
-- 
1.7.1

