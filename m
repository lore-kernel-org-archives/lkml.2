Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab1G0Qfp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 12:35:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754725Ab1G0Qfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 12:35:42 -0400
Date: Wed, 27 Jul 2011 18:32:39 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>, Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Matt Fleming <matt.fleming@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] vfork: introduce clone_vfork_finish()
Message-ID: <20110727163239.GB23793@redhat.com>
References: <20110727163159.GA23785@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110727163159.GA23785@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes.

Move the wait-for-vfork_done code from do_wait() into the new
helper, clone_vfork_finish().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 kernel/fork.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- 3.1/kernel/fork.c~2_wait_for_vfork_done	2011-07-26 17:52:25.000000000 +0200
+++ 3.1/kernel/fork.c	2011-07-26 17:52:59.000000000 +0200
@@ -1449,6 +1449,17 @@ void complete_vfork_done(struct task_str
 	complete(vfork_done);
 }
 
+static long clone_vfork_finish(struct task_struct *child,
+				struct completion *vfork_done, long pid)
+{
+	freezer_do_not_count();
+	wait_for_completion(vfork_done);
+	freezer_count();
+
+	ptrace_event(PTRACE_EVENT_VFORK_DONE, pid);
+	return pid;
+}
+
 /*
  *  Ok, this is the main fork-routine.
  *
@@ -1536,12 +1547,8 @@ long do_fork(unsigned long clone_flags,
 		if (unlikely(trace))
 			ptrace_event(trace, nr);
 
-		if (clone_flags & CLONE_VFORK) {
-			freezer_do_not_count();
-			wait_for_completion(&vfork);
-			freezer_count();
-			ptrace_event(PTRACE_EVENT_VFORK_DONE, nr);
-		}
+		if (clone_flags & CLONE_VFORK)
+			nr = clone_vfork_finish(p, &vfork, nr);
 	} else {
 		nr = PTR_ERR(p);
 	}

