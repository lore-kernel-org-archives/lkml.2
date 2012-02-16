Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155Ab2BPTKk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 14:10:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754981Ab2BPTKh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 14:10:37 -0500
Date: Thu, 16 Feb 2012 18:27:41 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: apw@canonical.com, arjan@linux.intel.com, fhrbata@redhat.com,
        john.johansen@canonical.com, penguin-kernel@I-love.SAKURA.ne.jp,
        rientjes@google.com, rusty@rustcorp.com.au, tj@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] kill PF_STARTING
Message-ID: <20120216172741.GE30393@redhat.com>
References: <20120214164709.GA21178@redhat.com> <20120214164914.GF21185@redhat.com> <20120215123049.6e938eed.akpm@linux-foundation.org> <20120216150429.GB11953@redhat.com> <20120216172626.GA30393@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120216172626.GA30393@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously it was (ab)used by utrace. Then it was wrongly used by
the scheduler code.

Currently it is not used, kill it before it finds the new erroneous
user.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>
---
 include/linux/sched.h |    1 -
 kernel/fork.c         |    9 ---------
 2 files changed, 0 insertions(+), 10 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 11fcafa..0657368 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1777,7 +1777,6 @@ extern void thread_group_times(struct task_struct *p, cputime_t *ut, cputime_t *
 /*
  * Per process flags
  */
-#define PF_STARTING	0x00000002	/* being created */
 #define PF_EXITING	0x00000004	/* getting shut down */
 #define PF_EXITPIDONE	0x00000008	/* pi exit done on shut down */
 #define PF_VCPU		0x00000010	/* I'm a virtual CPU */
diff --git a/kernel/fork.c b/kernel/fork.c
index 57ebebb..3aa9153 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1043,7 +1043,6 @@ static void copy_flags(unsigned long clone_flags, struct task_struct *p)
 
 	new_flags &= ~(PF_SUPERPRIV | PF_WQ_WORKER);
 	new_flags |= PF_FORKNOEXEC;
-	new_flags |= PF_STARTING;
 	p->flags = new_flags;
 }
 
@@ -1576,14 +1575,6 @@ long do_fork(unsigned long clone_flags,
 			get_task_struct(p);
 		}
 
-		/*
-		 * We set PF_STARTING at creation in case tracing wants to
-		 * use this to distinguish a fully live task from one that
-		 * hasn't finished SIGSTOP raising yet.  Now we clear it
-		 * and set the child going.
-		 */
-		p->flags &= ~PF_STARTING;
-
 		wake_up_new_task(p);
 
 		/* forking complete and child started to run, tell ptracer */
-- 
1.5.5.1


