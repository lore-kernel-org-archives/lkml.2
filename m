Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab2CXLBi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 07:01:38 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46287 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277Ab2CXLBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 07:01:37 -0400
Date: Sat, 24 Mar 2012 15:00:24 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] sysrq: Use SEND_SIG_FORCED instead of force_sig()
Message-ID: <20120324110024.GA14067@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change send_sig_all() to use do_send_sig_info(SEND_SIG_FORCED)
instead of force_sig(SIGKILL). With the recent changes we do not
need force_ to kill the CLONE_NEWPID tasks.

And this is more correct. force_sig() can race with the exiting
thread, while do_send_sig_info(group => true) kill the whole
process.

Some more notes from Oleg Nesterov:

> Just one note. This change makes no difference for sysrq_handle_kill().
> But it obviously changes the behaviour sysrq_handle_term(). I think
> this is fine, if you want to really kill the task which blocks/ignores
> SIGTERM you can use sysrq_handle_kill().
>
> Even ignoring the reasons why force_sig() is simply wrong here,
> force_sig(SIGTERM) looks strange. The task won't be killed if it has
> a handler, but SIG_IGN can't help. However if it has the handler
> but blocks SIGTERM temporary (this is very common) it will be killed.

Also,

> force_sig() can't kill the process if the main thread has already
> exited. IOW, it is trivial to create the process which can't be
> killed by sysrq.

So, this patch fixes the issue.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---

The patch depends on a few Oleg's patches in -mm, so I believe
this should be -mm material as well.

 drivers/tty/sysrq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
index 8db9125..5ab8039 100644
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -329,7 +329,7 @@ static void send_sig_all(int sig)
 		if (is_global_init(p))
 			continue;
 
-		force_sig(sig, p);
+		do_send_sig_info(sig, SEND_SIG_FORCED, p, true);
 	}
 	read_unlock(&tasklist_lock);
 }
-- 
1.7.9.2
