Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760113Ab2BJUH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 15:07:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45310 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760037Ab2BJUHY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 15:07:24 -0500
Date: Fri, 10 Feb 2012 21:00:51 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] signal: oom_kill_task: use SEND_SIG_FORCED instead of
	force_sig()
Message-ID: <20120210200051.GC20898@redhat.com>
References: <20120210200004.GA20890@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120210200004.GA20890@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change oom_kill_task() to use do_send_sig_info(SEND_SIG_FORCED)
instead of force_sig(SIGKILL). With the recent changes we do not
need force_ to kill the CLONE_NEWPID tasks.

And this is more correct. force_sig() can race with the exiting
thread even if oom_kill_task() checks p->mm != NULL, while
do_send_sig_info(group => true) kille the whole process.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 mm/oom_kill.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 2958fd8..b1e9643 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -472,11 +472,11 @@ static int oom_kill_task(struct task_struct *p)
 			pr_err("Kill process %d (%s) sharing same memory\n",
 				task_pid_nr(q), q->comm);
 			task_unlock(q);
-			force_sig(SIGKILL, q);
+			do_send_sig_info(SIGKILL, SEND_SIG_FORCED, q, true);
 		}
 
 	set_tsk_thread_flag(p, TIF_MEMDIE);
-	force_sig(SIGKILL, p);
+	do_send_sig_info(SIGKILL, SEND_SIG_FORCED, p, true);
 
 	return 0;
 }
-- 
1.5.5.1


