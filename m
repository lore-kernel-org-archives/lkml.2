Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933150Ab1DNRqd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:46:33 -0400
Received: from mail.windriver.com ([147.11.1.11]:38087 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933071Ab1DNRqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:46:24 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 055/209] TTY: ldisc, fix open flag handling
Date: Thu, 14 Apr 2011 13:41:25 -0400
Message-Id: <1302803039-9400-56-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/char/tty_ldisc.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index 7af1a15..236628f 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -452,6 +452,8 @@ static int tty_ldisc_open(struct tty_struct *tty, struct tty_ldisc *ld)
                 /* BKL here locks verus a hangup event */
 		lock_kernel();
 		ret = ld->ops->open(tty);
+		if (ret)
+			clear_bit(TTY_LDISC_OPEN, &tty->flags);
 		unlock_kernel();
 		return ret;
 	}
-- 
1.7.4.4

