Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab2F0Sk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 14:40:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21278 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581Ab2F0Sk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 14:40:26 -0400
Date: Wed, 27 Jun 2012 20:38:13 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        ". James Morris" <jmorris@namei.org>,
        linux-security-module@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH 3/4] task_work: deal with task_work callbacks adding more
	work
Message-ID: <20120627183813.GD23086@redhat.com>
References: <1340369098.2464.20.camel@falcor> <20120623092049.GH14083@ZenIV.linux.org.uk> <20120623194505.GI14083@ZenIV.linux.org.uk> <20120623203800.GA10306@redhat.com> <20120623210141.GK14083@ZenIV.linux.org.uk> <20120624041652.GN14083@ZenIV.linux.org.uk> <20120624153310.GB24596@redhat.com> <20120625060357.GT14083@ZenIV.linux.org.uk> <20120625151812.GA16062@redhat.com> <20120627183721.GA23086@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120627183721.GA23086@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shamelessly stolen Al Viro's patch and the changelog, just I didn't
dare to add the proper From tag.

It doesn't matter on normal return to userland path (we'll recheck
the NOTIFY_RESUME flag anyway), but in case of exit_task_work() we'll
need that as soon as we get callbacks capable of triggering more
task_work_add().

Suggested-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/task_work.c |   33 +++++++++++++++++++++------------
 1 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/kernel/task_work.c b/kernel/task_work.c
index b2ff3b7..8dfc48c 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -76,18 +76,27 @@ void task_work_run(void)
 	struct task_struct *task = current;
 	struct task_work *last, *next, *twork;
 
-	raw_spin_lock_irq(&task->pi_lock);
-	last = task->last_twork;
-	task->last_twork = (task->flags & PF_EXITING) ? TWORK_EXITED : NULL;
-	raw_spin_unlock_irq(&task->pi_lock);
+	for (;;) {
+		/*
+		 * twork->func() can do task_work_add(), do not
+		 * set TWORK_EXITED until the list becomes empty.
+		 */
+		raw_spin_lock_irq(&task->pi_lock);
+		last = task->last_twork;
+		if (last)
+			task->last_twork = NULL;
+		else if (task->flags & PF_EXITING)
+			task->last_twork = TWORK_EXITED;
+		raw_spin_unlock_irq(&task->pi_lock);
 
-	if (!last)
-		return;
+		if (!last)
+			return;
 
-	next = last->next;
-	do {
-		twork = next;
-		next = twork->next;
-		twork->func(twork);
-	} while (twork != last);
+		next = last->next;
+		do {
+			twork = next;
+			next = twork->next;
+			twork->func(twork);
+		} while (twork != last);
+	}
 }
-- 
1.5.5.1


