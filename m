Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934229Ab1JaWRu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 18:17:50 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60144 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933934Ab1JaWRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 18:17:48 -0400
Date: Mon, 31 Oct 2011 15:17:43 -0700
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Layton <jlayton@redhat.com>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        linux-pm@vger.kernel.org, linux-cifs@vger.kernel.org,
        Steve French <sfrench@samba.org>,
        "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>
Subject: [RFC PATCH] freezer: revert 27920651fe "PM / Freezer: Make
 fake_signal_wake_up() wake TASK_KILLABLE tasks too"
Message-ID: <20111031221743.GA18855@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 27920651fe "PM / Freezer: Make fake_signal_wake_up() wake
TASK_KILLABLE tasks too" made freezer wake up tasks in TASK_KILLABLE
sleep too citing non-interruptible but killable sleeps in cifs and
nfs.

I don't think we can do this.  We should not send spurious unsolicited
non-interruptible wakeups.  Most synchornization constructs are built
to cope with spurious wakeups and any INTERRUPTIBLE sleep must be able
to handle spurious wakeups but that's not true for KILLABLE sleeps -
KILLABLE condition cannot be cancelled.

This is probably okay for most cases but circumventing fundamental
wakeup condition like this is asking for trouble.  Furthermore, I'm
not sure the behavior change brought on by this change - breaking
nfs/cifs uninterruptible operation guarantee - is correct.  If such
behavior is desirable, the right thing to do is using intr mount
option, not circumventing it from PM layer.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jeff Layton <jlayton@redhat.com>
---
Neil, Steve, do the network filesystems need a way to indicate "I can
either be killed or enter freezer"?

Thanks.

 kernel/freezer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/freezer.c b/kernel/freezer.c
index 66a594e..7b01de9 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -67,7 +67,7 @@ static void fake_signal_wake_up(struct task_struct *p)
 	unsigned long flags;
 
 	spin_lock_irqsave(&p->sighand->siglock, flags);
-	signal_wake_up(p, 1);
+	signal_wake_up(p, 0);
 	spin_unlock_irqrestore(&p->sighand->siglock, flags);
 }
 
