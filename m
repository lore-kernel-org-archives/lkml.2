Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384Ab0JQKQn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 06:16:43 -0400
Received: from canuck.infradead.org ([134.117.69.58]:33154 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932234Ab0JQKQm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 06:16:42 -0400
Subject: Re: [RFC][PATCH 6/7] perf: use jump_label to optimize the
 scheduler hooks
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Jason Baron <jbaron@redhat.com>,
        linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
        Mike Galbraith <efault@gmx.de>
In-Reply-To: <1287309159.1998.146.camel@laptop>
References: <20101014203404.222133139@chello.nl>
	 <20101014203625.552405859@chello.nl>  <1287309159.1998.146.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 17 Oct 2010 12:16:16 +0200
Message-ID: <1287310576.1998.151.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-10-17 at 11:52 +0200, Peter Zijlstra wrote:
> On Thu, 2010-10-14 at 22:34 +0200, Peter Zijlstra wrote:
> > +static inline void perf_event_task_sched_in(struct task_struct *task)
> > +{
> > +       JUMP_LABEL(&perf_task_events, have_events);
> > +       return;
> > +
> > +have_events:
> > +       __perf_event_task_sched_in(task);
> > +} 
> 
> OK, so I hate the JUMP_LABEL() interface for it means we have to keep
> writing these silly stubs.

The below seems to actually compile too, awesome! ;-)

---
Index: linux-2.6/include/linux/jump_label.h
===================================================================
--- linux-2.6.orig/include/linux/jump_label.h
+++ linux-2.6/include/linux/jump_label.h
@@ -61,4 +61,14 @@ static inline int jump_label_text_reserv
 
 #endif
 
+#define COND_STMT(key, stmt)					\
+do {								\
+	__label__ jl_enabled;					\
+	JUMP_LABEL(key, jl_enabled);				\
+	if (0) {						\
+jl_enabled:							\
+		stmt;						\
+	}							\
+} while (0)
+
 #endif
Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -901,21 +901,13 @@ extern atomic_t perf_task_events;
 
 static inline void perf_event_task_sched_in(struct task_struct *task)
 {
-	JUMP_LABEL(&perf_task_events, have_events);
-	return;
-
-have_events:
-	__perf_event_task_sched_in(task);
+	COND_STMT(&perf_task_events, __perf_event_task_sched_in(task));
 }
 
 static inline
 void perf_event_task_sched_out(struct task_struct *task, struct task_struct *next)
 {
-	JUMP_LABEL(&perf_task_events, have_events);
-	return;
-
-have_events:
-	__perf_event_task_sched_out(task, next);
+	COND_STMT(&perf_task_events, __perf_event_task_sched_out(task, next));
 }
 
 extern int perf_event_init_task(struct task_struct *child);

