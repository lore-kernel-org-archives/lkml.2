Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754757Ab1IFPAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 11:00:42 -0400
Received: from smtp-out.google.com ([74.125.121.67]:25527 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257Ab1IFPAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 11:00:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:to:cc:subject:message-id:
	mime-version:content-type:content-disposition:user-agent:x-system-of-record;
	b=pvR40F4LSFeqFlZewoYquEnT4AmXy884CjSyeuWfFBvcY60K7q5T99KNx+0evPy1z
	7WByB7qvV/gnxDUawcQ/Q==
Date: Tue, 6 Sep 2011 17:00:24 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, peterz@infradead.org, mingo@elte.hu, dsahern@gmail.com
Subject: [PATCH] perf: fix uninitialized variable in thread__set_comm()
Message-ID: <20110906150024.GA18192@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In thread__set_comm(), a command string could be freed and then
reused to point to a new command. Yet, the length was never reset
nor recomputed. This could lead to bogus column formatting.

This patch below fixes the problem by having thread__set_comm()
immediately compute the string length in thread->comm_len. It
gets rid of thread__comm_len() which is not needed anymore.
It was doing the lazy eval of strlen() which could cause the
issue.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 677e1da..b883821 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -61,7 +61,7 @@ static void hists__calc_col_len(struct hists *self, struct hist_entry *h)
 					   unresolved_col_width);
 	}
 
-	len = thread__comm_len(h->thread);
+	len = h->thread->comm_len;
 	if (hists__new_col_len(self, HISTC_COMM, len))
 		hists__set_col_len(self, HISTC_THREAD, len + 6);
 
@@ -731,7 +731,7 @@ static size_t hist_entry__fprintf_callchain(struct hist_entry *self,
 		struct sort_entry *se = list_first_entry(&hist_entry__sort_list,
 							 typeof(*se), list);
 		left_margin = hists__col_len(hists, se->se_width_idx);
-		left_margin -= thread__comm_len(self->thread);
+		left_margin -= self->thread->comm_len;
 	}
 
 	return hist_entry_callchain__fprintf(fp, self, session_total,
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index d5d3b22..3ce2a80 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -35,26 +35,18 @@ int thread__set_comm(struct thread *self, const char *comm)
 
 	if (self->comm)
 		free(self->comm);
+
 	self->comm = strdup(comm);
+
 	err = self->comm == NULL ? -ENOMEM : 0;
 	if (!err) {
 		self->comm_set = true;
+		self->comm_len = strlen(self->comm);
 		map_groups__flush(&self->mg);
 	}
 	return err;
 }
 
-int thread__comm_len(struct thread *self)
-{
-	if (!self->comm_len) {
-		if (!self->comm)
-			return 0;
-		self->comm_len = strlen(self->comm);
-	}
-
-	return self->comm_len;
-}
-
 static size_t thread__fprintf(struct thread *self, FILE *fp)
 {
 	return fprintf(fp, "Thread %d %s\n", self->pid, self->comm) +
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index e5f2401..701ea09 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -23,7 +23,6 @@ struct perf_session;
 void thread__delete(struct thread *self);
 
 int thread__set_comm(struct thread *self, const char *comm);
-int thread__comm_len(struct thread *self);
 struct thread *perf_session__findnew(struct perf_session *self, pid_t pid);
 void thread__insert_map(struct thread *self, struct map *map);
 int thread__fork(struct thread *self, struct thread *parent);
