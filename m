Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757162Ab0FNWWc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 18:22:32 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46343 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756987Ab0FNWVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 18:21:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=rxXOgoF9uoSNUY9tjZ1KyVh3rXE1d9yrhNm4DwMAazs/cn8Tk8FrWgZWi9Ij2uwNqq
         VHB6BzkXjxxGPiqKoMTs0+o3KMbBwYkVuhtkYq8idGiGy/W/jWKRj/afnqJFjeUda4QT
         +5qMVS+zH2awAXr6JVgmWoKivVoGQPjDkGrQg=
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: lkml <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Clark Williams <williams@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 1/6] tracing: Update the comm field in the right variable in update_max_tr
Date: Tue, 15 Jun 2010 00:21:22 +0200
Message-Id: <1276554087-3632-2-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <1276554087-3632-1-git-send-email-jkacur@redhat.com>
References: <1276554087-3632-1-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The latency output showed:

 #    | task: -3 (uid:0 nice:0 policy:1 rt_prio:99)

The comm is missing in the "task:" and it looks like a minus 3 is
the output. The correct display should be:

 #    | task: migration/0-3 (uid:0 nice:0 policy:1 rt_prio:99)

The problem is that the comm is being stored in the wrong data
structure. The max_tr.data[cpu] is what stores the comm, not the
tr->data[cpu].

Before this patch the max_tr.data[cpu]->comm was zeroed and the /debug/trace
ended up showing just the '-' sign followed by the pid.

Also remove a needless initialization of max_data.

Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <1267824230-23861-1-git-send-email-acme@infradead.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Upstream commit: 1acaa1b2d9b5904c9cce06122990a2d71046ce16
Signed-off-by: John Kacur <jkacur@redhat.com>
---
 kernel/trace/trace.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 9b66ee1..a1cf0ad 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -520,7 +520,7 @@ static void
 __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 {
 	struct trace_array_cpu *data = tr->data[cpu];
-	struct trace_array_cpu *max_data = tr->data[cpu];
+	struct trace_array_cpu *max_data;
 
 	max_tr.cpu = cpu;
 	max_tr.time_start = data->preempt_timestamp;
@@ -530,7 +530,7 @@ __update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu)
 	max_data->critical_start = data->critical_start;
 	max_data->critical_end = data->critical_end;
 
-	memcpy(data->comm, tsk->comm, TASK_COMM_LEN);
+	memcpy(max_data->comm, tsk->comm, TASK_COMM_LEN);
 	max_data->pid = tsk->pid;
 	max_data->uid = task_uid(tsk);
 	max_data->nice = tsk->static_prio - 20 - MAX_RT_PRIO;
-- 
1.6.6.1

