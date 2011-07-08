Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab1GHRQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 13:16:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61605 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754133Ab1GHRQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 13:16:43 -0400
Date: Fri, 8 Jul 2011 19:13:39 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: vda.linux@googlemail.com, jan.kratochvil@redhat.com,
        pedro@codesourcery.com, indan@nul.nu, bdonlan@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] ptrace_init_task: initialize child->jobctl explicitly
Message-ID: <20110708171339.GB26943@redhat.com>
References: <20110708171320.GA26943@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110708171320.GA26943@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

new_child->jobctl is not initialized during the fork, it is copied
from parent->jobctl. Currently this is harmless, the forking task
is running and copy_process() can't succeed if signal_pending() is
true, so only JOBCTL_STOP_DEQUEUED can be copied. Still this is a
bit fragile, it would be more clean to set ->jobctl = 0 explicitly.

Also, check ->ptrace != 0 instead of PT_PTRACED, move the
CONFIG_HAVE_HW_BREAKPOINT code up.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/ptrace.h |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- ptrace/include/linux/ptrace.h~3_init_jobctl	2011-07-07 18:34:44.000000000 +0200
+++ ptrace/include/linux/ptrace.h	2011-07-08 17:15:20.000000000 +0200
@@ -217,16 +217,17 @@ static inline void ptrace_init_task(stru
 {
 	INIT_LIST_HEAD(&child->ptrace_entry);
 	INIT_LIST_HEAD(&child->ptraced);
-	child->parent = child->real_parent;
+#ifdef CONFIG_HAVE_HW_BREAKPOINT
+	atomic_set(&child->ptrace_bp_refcnt, 1);
+#endif
+	child->jobctl = 0;
 	child->ptrace = 0;
-	if (unlikely(ptrace) && (current->ptrace & PT_PTRACED)) {
+	child->parent = child->real_parent;
+
+	if (unlikely(ptrace) && current->ptrace) {
 		child->ptrace = current->ptrace;
 		__ptrace_link(child, current->parent);
 	}
-
-#ifdef CONFIG_HAVE_HW_BREAKPOINT
-	atomic_set(&child->ptrace_bp_refcnt, 1);
-#endif
 }
 
 /**

