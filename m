Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273Ab0KXX2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 18:28:09 -0500
Received: from mail.pripojeni.net ([217.66.174.14]:57417 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753053Ab0KXX2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 18:28:05 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@suse.de
Cc: slapin@ossfans.org, linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Alan Cox <alan@linux.intel.com>
Subject: [PATCH 1/2] TTY: ldisc, fix open flag handling
Date: Thu, 25 Nov 2010 00:27:54 +0100
Message-Id: <1290641275-21726-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <4CED9498.9080900@suse.cz>
References: <4CED9498.9080900@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
1.7.3.1


