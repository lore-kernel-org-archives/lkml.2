Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab1HLSAU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 14:00:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab1HLSAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 14:00:16 -0400
Date: Fri, 12 Aug 2011 19:57:01 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roland McGrath <roland@hack.frob.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Matt Fleming <matt.fleming@linux.intel.com>,
        linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
Subject: [PATCH 4/3] kill PF_STARTING
Message-ID: <20110812175701.GE7484@redhat.com>
References: <20110727163159.GA23785@redhat.com> <20110729192358.GB31717@mtj.dyndns.org> <20110812175550.GA7484@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110812175550.GA7484@redhat.com>
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
 1 file changed, 1 deletion(-)

--- 3.1/include/linux/sched.h~4_kill_PF_STARTING	2011-08-12 18:51:13.000000000 +0200
+++ 3.1/include/linux/sched.h	2011-08-12 18:52:58.000000000 +0200
@@ -1756,7 +1756,6 @@ extern void thread_group_times(struct ta
 /*
  * Per process flags
  */
-#define PF_STARTING	0x00000002	/* being created */
 #define PF_EXITING	0x00000004	/* getting shut down */
 #define PF_EXITPIDONE	0x00000008	/* pi exit done on shut down */
 #define PF_VCPU		0x00000010	/* I'm a virtual CPU */
--- 3.1/kernel/fork.c~4_kill_PF_STARTING	2011-08-12 18:51:13.000000000 +0200
+++ 3.1/kernel/fork.c	2011-08-12 18:52:58.000000000 +0200
@@ -1026,7 +1026,6 @@ static void copy_flags(unsigned long clo
 
 	new_flags &= ~(PF_SUPERPRIV | PF_WQ_WORKER);
 	new_flags |= PF_FORKNOEXEC;
-	new_flags |= PF_STARTING;
 	p->flags = new_flags;
 	clear_freeze_flag(p);
 }
@@ -1563,15 +1562,6 @@ long do_fork(unsigned long clone_flags,
 		}
 
 		audit_finish_fork(p);
-
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

