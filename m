Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760119Ab2BJUHo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 15:07:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539Ab2BJUHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 15:07:41 -0500
Date: Fri, 10 Feb 2012 21:01:08 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] signal: zap_pid_ns_processes:
	s/SEND_SIG_NOINFO/SEND_SIG_FORCED/
Message-ID: <20120210200108.GD20898@redhat.com>
References: <20120210200004.GA20890@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120210200004.GA20890@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change zap_pid_ns_processes() to use SEND_SIG_FORCED, it looks more
clear compared to SEND_SIG_NOINFO which relies on from_ancestor_ns
logic send_signal().

It is also more effecient if we need to kill a lot of tasks because
it doesn't alloc sigqueue.

While at it, add the __fatal_signal_pending(task) check as a minor
optimization.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/pid_namespace.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index a896839..17b2328 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -168,13 +168,9 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
 	while (nr > 0) {
 		rcu_read_lock();
 
-		/*
-		 * Any nested-container's init processes won't ignore the
-		 * SEND_SIG_NOINFO signal, see send_signal()->si_fromuser().
-		 */
 		task = pid_task(find_vpid(nr), PIDTYPE_PID);
-		if (task)
-			send_sig_info(SIGKILL, SEND_SIG_NOINFO, task);
+		if (task && !__fatal_signal_pending(task))
+			send_sig_info(SIGKILL, SEND_SIG_FORCED, task);
 
 		rcu_read_unlock();
 
-- 
1.5.5.1


