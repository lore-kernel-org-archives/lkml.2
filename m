Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab1G0Qhs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 12:37:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754978Ab1G0Qhn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 12:37:43 -0400
Date: Wed, 27 Jul 2011 18:34:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>, Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Matt Fleming <matt.fleming@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 9/8] kill PF_STARTING
Message-ID: <20110727163441.GI23793@redhat.com>
References: <20110727163159.GA23785@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110727163159.GA23785@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously it was (ab)used by utrace. Then it was wrongly used by
the scheduler code.

Currently it is not used, kill it before it finds the new erroneous
user.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/sched.h |    1 -
 kernel/fork.c         |    9 ---------
 2 files changed, 10 deletions(-)

--- 3.1/include/linux/sched.h~9_kill_pf_starting	2011-07-27 17:48:36.000000000 +0200
+++ 3.1/include/linux/sched.h	2011-07-27 17:53:21.000000000 +0200
@@ -1756,7 +1756,6 @@ extern void thread_group_times(struct ta
 /*
  * Per process flags
  */
-#define PF_STARTING	0x00000002	/* being created */
 #define PF_EXITING	0x00000004	/* getting shut down */
 #define PF_EXITPIDONE	0x00000008	/* pi exit done on shut down */
 #define PF_VCPU		0x00000010	/* I'm a virtual CPU */
--- 3.1/kernel/fork.c~9_kill_pf_starting	2011-07-27 17:51:54.000000000 +0200
+++ 3.1/kernel/fork.c	2011-07-27 17:54:09.000000000 +0200
@@ -992,7 +992,6 @@ static void copy_flags(unsigned long clo
 
 	new_flags &= ~(PF_SUPERPRIV | PF_WQ_WORKER);
 	new_flags |= PF_FORKNOEXEC;
-	new_flags |= PF_STARTING;
 	p->flags = new_flags;
 	clear_freeze_flag(p);
 }
@@ -1600,14 +1599,6 @@ long do_fork(unsigned long clone_flags,
 
 		audit_finish_fork(p);
 
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

