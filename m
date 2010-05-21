Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab0EUOKy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 10:10:54 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42065 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001Ab0EUOKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 10:10:53 -0400
X-Greylist: delayed 342 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 May 2010 10:10:53 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=Sjt6xW7m/TVqtOWTlIDYqBjJafhYz9dn3x8b/9RbYi7Q0+KVqSpND5fpTegfvgz7Z3
         gOoQ6OhVdZtf/NRDmLo1ltcpYZ8jvsctG/Afb1QtMaNiQC0R5s/drYdf8GmWAHqnDXLT
         PUULvqynqi16OdStILy1VDahmKCoKEb7gdXFM=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/4] perf: Add exclude_task perf event attribute
Date: Fri, 21 May 2010 16:05:13 +0200
Message-Id: <1274450715-23955-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1274450715-23955-1-git-send-regression-fweisbec@gmail.com>
References: <1274450715-23955-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excluding is useful when you want to trace only hard and softirqs.

For this we use a new generic perf_exclude_event() (the previous
one beeing turned into perf_exclude_swevent) to which you can pass
the preemption offset to which your events trigger.

Computing preempt_count() - offset gives us the preempt_count() of
the context that the event has interrupted, on top of which we
can filter the non-irq contexts.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
---
 include/linux/perf_event.h |    3 ++-
 kernel/perf_event.c        |   41 ++++++++++++++++++++++++++++++++++-------
 2 files changed, 36 insertions(+), 8 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index fe50347..d939fc7 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -214,8 +214,9 @@ struct perf_event_attr {
 				 *  See also PERF_RECORD_MISC_EXACT_IP
 				 */
 				precise_ip     :  2, /* skid constraint       */
+				exclude_task   :  1, /* don't count task context */
 
-				__reserved_1   : 47;
+				__reserved_1   : 46;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 45b7aec..ab96411 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -3907,10 +3907,33 @@ static int __perf_event_overflow(struct perf_event *event, int nmi,
 	return ret;
 }
 
+static bool
+perf_exclude_event(struct perf_event *event, int offset)
+{
+	if (!in_interrupt_offset(preempt_count() - offset)) {
+		if (event->attr.exclude_task)
+			return true;
+	}
+
+	return false;
+}
+
 int perf_event_overflow(struct perf_event *event, int nmi,
 			  struct perf_sample_data *data,
 			  struct pt_regs *regs)
 {
+	int offset = HARDIRQ_OFFSET;
+
+	if (nmi)
+		offset += NMI_OFFSET;
+	/*
+	 * Hardware events trigger on NMI or simple hardirq, which offset we
+	 * need to substract to get the preempt_count() of the interrupted
+	 * context.
+	 */
+	if (perf_exclude_event(event, offset))
+		return 0;
+
 	return __perf_event_overflow(event, nmi, 1, data, regs);
 }
 
@@ -4008,8 +4031,8 @@ static void perf_swevent_add(struct perf_event *event, u64 nr,
 static int perf_tp_event_match(struct perf_event *event,
 				struct perf_sample_data *data);
 
-static int perf_exclude_event(struct perf_event *event,
-			      struct pt_regs *regs)
+static int perf_exclude_swevent(struct perf_event *event,
+			      struct pt_regs *regs, int offset)
 {
 	if (regs) {
 		if (event->attr.exclude_user && user_mode(regs))
@@ -4019,7 +4042,7 @@ static int perf_exclude_event(struct perf_event *event,
 			return 1;
 	}
 
-	return 0;
+	return perf_exclude_event(event, offset);
 }
 
 static int perf_swevent_match(struct perf_event *event,
@@ -4034,7 +4057,7 @@ static int perf_swevent_match(struct perf_event *event,
 	if (event->attr.config != event_id)
 		return 0;
 
-	if (perf_exclude_event(event, regs))
+	if (perf_exclude_swevent(event, regs, 0))
 		return 0;
 
 	if (event->attr.type == PERF_TYPE_TRACEPOINT &&
@@ -4230,9 +4253,13 @@ static enum hrtimer_restart perf_swevent_hrtimer(struct hrtimer *hrtimer)
 	data.period = event->hw.last_period;
 	regs = get_irq_regs();
 
-	if (regs && !perf_exclude_event(event, regs)) {
+	/*
+	 * we are in hardirq, so we need to substract our preempt offset
+	 * to retrieve the interrupted one
+	 */
+	if (regs && !perf_exclude_swevent(event, regs, HARDIRQ_OFFSET)) {
 		if (!(event->attr.exclude_idle && current->pid == 0))
-			if (perf_event_overflow(event, 0, &data, regs))
+			if (__perf_event_overflow(event, 0, 1, &data, regs))
 				ret = HRTIMER_NORESTART;
 	}
 
@@ -4624,7 +4651,7 @@ void perf_bp_event(struct perf_event *bp, void *data)
 
 	perf_sample_data_init(&sample, bp->attr.bp_addr);
 
-	if (!perf_exclude_event(bp, regs))
+	if (!perf_exclude_swevent(bp, regs, 0))
 		perf_swevent_add(bp, 1, 1, &sample, regs);
 }
 #else
-- 
1.6.2.3

