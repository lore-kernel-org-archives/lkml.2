Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab2HZTKU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2012 15:10:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228Ab2HZTJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2012 15:09:49 -0400
Date: Sun, 26 Aug 2012 21:12:14 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt <rostedt@goodmis.org>,
        dhowells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3/4] task_work: revert d35abdb2 "hold task_lock around
	checks in keyctl"
Message-ID: <20120826191214.GA4231@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120826191132.GA3743@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit d35abdb28824cf74f0a106a0f9c6f3ff700a35bf.

task_lock() was added to ensure exit_mm() and thus exit_task_work() is
not possible before task_work_add().

This is wrong, task_lock() must not be nested with write_lock(tasklist).
And this is no longer needed, task_work_add() fails if it is called
after exit_task_work().

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 security/keys/keyctl.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 3364fbf..6cfc647 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -1486,7 +1486,6 @@ long keyctl_session_to_parent(void)
 	oldwork = NULL;
 	parent = me->real_parent;
 
-	task_lock(parent);
 	/* the parent mustn't be init and mustn't be a kernel thread */
 	if (parent->pid <= 1 || !parent->mm)
 		goto unlock;
@@ -1530,7 +1529,6 @@ long keyctl_session_to_parent(void)
 	if (!ret)
 		newwork = NULL;
 unlock:
-	task_unlock(parent);
 	write_unlock_irq(&tasklist_lock);
 	rcu_read_unlock();
 	if (oldwork)
-- 
1.5.5.1

