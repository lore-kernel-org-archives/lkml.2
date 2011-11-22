Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758410Ab1KVU6E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 15:58:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421Ab1KVU6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 15:58:01 -0500
Date: Tue, 22 Nov 2011 21:53:14 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Masami Hiramatsu <mhiramat@redhat.com>,
        Seiji Aguchi <saguchi@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] tracing: send_sigqueue() needs trace_signal_generate()
	too
Message-ID: <20111122205314.GC20971@redhat.com>
References: <20111121191920.GA24883@redhat.com> <1321905799.20742.20.camel@frodo> <20111121202110.GA27966@redhat.com> <1321912356.20742.24.camel@frodo> <20111122205239.GA20971@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111122205239.GA20971@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add trace_signal_generate() into send_sigqueue().

send_sigqueue() is very similar to __send_signal(), just it uses
the preallocated info. It should do the same wrt tracing.

Reported-by: Seiji Aguchi <saguchi@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/signal.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 5f130f6..7366f68 100644
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


