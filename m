Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932862Ab2AJRvi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 12:51:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932456Ab2AJRvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 12:51:37 -0500
Date: Tue, 10 Jan 2012 18:45:45 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] tracing: send_sigqueue() needs trace_signal_generate()
	too
Message-ID: <20120110174545.GB30810@redhat.com>
References: <20120110174509.GA30802@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120110174509.GA30802@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add trace_signal_generate() into send_sigqueue().

send_sigqueue() is very similar to __send_signal(), just it uses
the preallocated info. It should do the same wrt tracing.

Reported-by: Seiji Aguchi <saguchi@redhat.com>
Reviewed-by: Seiji Aguchi <seiji.aguchi@hds.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/signal.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 4515114..a6ff776 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1559,7 +1559,7 @@ int send_sigqueue(struct sigqueue *q, struct task_struct *t, int group)
 	int sig = q->info.si_signo;
 	struct sigpending *pending;
 	unsigned long flags;
-	int ret;
+	int ret, result;
 
 	BUG_ON(!(q->flags & SIGQUEUE_PREALLOC));
 
@@ -1568,6 +1568,7 @@ int send_sigqueue(struct sigqueue *q, struct task_struct *t, int group)
 		goto ret;
 
 	ret = 1; /* the signal is ignored */
+	result = TRACE_SIGNAL_IGNORED;
 	if (!prepare_signal(sig, t, 0))
 		goto out;
 
@@ -1579,6 +1580,7 @@ int send_sigqueue(struct sigqueue *q, struct task_struct *t, int group)
 		 */
 		BUG_ON(q->info.si_code != SI_TIMER);
 		q->info.si_overrun++;
+		result = TRACE_SIGNAL_ALREADY_PENDING;
 		goto out;
 	}
 	q->info.si_overrun = 0;
@@ -1588,7 +1590,9 @@ int send_sigqueue(struct sigqueue *q, struct task_struct *t, int group)
 	list_add_tail(&q->list, &pending->list);
 	sigaddset(&pending->signal, sig);
 	complete_signal(sig, t, group);
+	result = TRACE_SIGNAL_DELIVERED;
 out:
+	trace_signal_generate(sig, &q->info, t, group, result);
 	unlock_task_sighand(t, &flags);
 ret:
 	return ret;
-- 
1.5.5.1


