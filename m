Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193Ab2DQLTN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 07:19:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6782 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932181Ab2DQLTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 07:19:10 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: eranian@google.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, rostedt@goodmis.org, robert.richter@amd.com,
        fche@redhat.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, drepper@gmail.com,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 12/16] perf, tool: Support user regs and stack in sample parsing
Date: Tue, 17 Apr 2012 13:17:17 +0200
Message-Id: <1334661441-4420-13-git-send-email-jolsa@redhat.com>
In-Reply-To: <1334661441-4420-1-git-send-email-jolsa@redhat.com>
References: <1334661441-4420-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding following info to be parsed out of the event sample:
 - user register set
 - user stack dump

Both are global and specific to all events within the session.
This info will be used in the unwind patches comming in shortly.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/builtin-test.c |    3 ++-
 tools/perf/util/event.h   |   15 ++++++++++++++-
 tools/perf/util/evlist.c  |   16 ++++++++++++++++
 tools/perf/util/evlist.h  |    2 ++
 tools/perf/util/evsel.c   |   25 +++++++++++++++++++++++++
 tools/perf/util/python.c  |    3 ++-
 tools/perf/util/session.c |    2 ++
 tools/perf/util/session.h |    7 ++++++-
 8 files changed, 69 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 1c5b980..a434aaa 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -564,7 +564,7 @@ static int test__basic_mmap(void)
 		}
 
 		err = perf_event__parse_sample(event, attr.sample_type, sample_size,
-					       false, &sample, false);
+					       false, 0, false, &sample, false);
 		if (err) {
 			pr_err("Can't parse sample, err = %d\n", err);
 			goto out_munmap;
@@ -1307,6 +1307,7 @@ static int test__PERF_RECORD(void)
 
 				err = perf_event__parse_sample(event, sample_type,
 							       sample_size, true,
+							       0, false,
 							       &sample, false);
 				if (err < 0) {
 					if (verbose)
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 1b19728..31d3e8c 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -69,6 +69,16 @@ struct sample_event {
 	u64 array[];
 };
 
+struct user_regs {
+	u64 version;
+	u64 *regs;
+};
+
+struct user_stack_dump {
+	u64 size;
+	char *data;
+};
+
 struct perf_sample {
 	u64 ip;
 	u32 pid, tid;
@@ -82,6 +92,8 @@ struct perf_sample {
 	void *raw_data;
 	struct ip_callchain *callchain;
 	struct branch_stack *branch_stack;
+	struct user_regs uregs;
+	struct user_stack_dump stack;
 };
 
 #define BUILD_ID_SIZE 20
@@ -199,7 +211,8 @@ const char *perf_event__name(unsigned int id);
 
 int perf_event__parse_sample(const union perf_event *event, u64 type,
 			     int sample_size, bool sample_id_all,
-			     struct perf_sample *sample, bool swapped);
+			     u64 sample_uregs, bool sample_ustack,
+			     struct perf_sample *data, bool swapped);
 int perf_event__synthesize_sample(union perf_event *event, u64 type,
 				  const struct perf_sample *sample,
 				  bool swapped);
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 1986d80..11cc50e 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -672,6 +672,22 @@ bool perf_evlist__valid_sample_type(const struct perf_evlist *evlist)
 	return true;
 }
 
+u64 perf_evlist__sample_uregs(const struct perf_evlist *evlist)
+{
+	struct perf_evsel *first;
+
+	first = list_entry(evlist->entries.next, struct perf_evsel, node);
+	return first->attr.user_regs;
+}
+
+bool perf_evlist__sample_ustack(const struct perf_evlist *evlist)
+{
+	struct perf_evsel *first;
+
+	first = list_entry(evlist->entries.next, struct perf_evsel, node);
+	return (first->attr.ustack_dump_size != 0);
+}
+
 u64 perf_evlist__sample_type(const struct perf_evlist *evlist)
 {
 	struct perf_evsel *first;
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 21f1c9e..a90cf24 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -117,6 +117,8 @@ u16 perf_evlist__id_hdr_size(const struct perf_evlist *evlist);
 
 bool perf_evlist__valid_sample_type(const struct perf_evlist *evlist);
 bool perf_evlist__valid_sample_id_all(const struct perf_evlist *evlist);
+u64 perf_evlist__sample_uregs(const struct perf_evlist *evlist);
+bool perf_evlist__sample_ustack(const struct perf_evlist *evlist);
 
 void perf_evlist__splice_list_tail(struct perf_evlist *evlist,
 				   struct list_head *list,
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 8c13dbc..7ee47c1 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -8,6 +8,7 @@
  */
 
 #include <byteswap.h>
+#include <linux/bitops.h>
 #include "asm/bug.h"
 #include "evsel.h"
 #include "evlist.h"
@@ -453,8 +454,10 @@ static bool sample_overlap(const union perf_event *event,
 
 int perf_event__parse_sample(const union perf_event *event, u64 type,
 			     int sample_size, bool sample_id_all,
+			     u64 sample_uregs, bool sample_ustack,
 			     struct perf_sample *data, bool swapped)
 {
+	int sample_uregs_nr = hweight_long(sample_uregs);
 	const u64 *array;
 
 	/*
@@ -594,6 +597,28 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 		sz /= sizeof(u64);
 		array += sz;
 	}
+
+	if (sample_uregs_nr) {
+		data->uregs.version = *array++;
+
+		if (data->uregs.version) {
+			data->uregs.regs = (u64 *)array;
+			array += sample_uregs_nr;
+		}
+	}
+
+	if (sample_ustack) {
+		u64 size = *array++;
+
+		if (!size) {
+			data->stack.size = 0;
+		} else {
+			data->stack.data = (char *)array;
+			array += size / sizeof(*array);
+			data->stack.size = *array;
+		}
+	}
+
 	return 0;
 }
 
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index e03b58a..257efcd 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -807,7 +807,8 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
 		first = list_entry(evlist->entries.next, struct perf_evsel, node);
 		err = perf_event__parse_sample(event, first->attr.sample_type,
 					       perf_evsel__sample_size(first),
-					       sample_id_all, &pevent->sample, false);
+					       sample_id_all, 0, false,
+					       &pevent->sample, false);
 		if (err)
 			return PyErr_Format(PyExc_OSError,
 					    "perf: can't parse sample, err=%d", err);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index ae30ca5..a2e1c1b 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -87,6 +87,8 @@ void perf_session__update_sample_type(struct perf_session *self)
 	self->sample_id_all = perf_evlist__sample_id_all(self->evlist);
 	self->id_hdr_size = perf_evlist__id_hdr_size(self->evlist);
 	self->host_machine.id_hdr_size = self->id_hdr_size;
+	self->sample_uregs = perf_evlist__sample_uregs(self->evlist);
+	self->sample_ustack = perf_evlist__sample_ustack(self->evlist);
 }
 
 int perf_session__create_kernel_maps(struct perf_session *self)
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 7a5434c..182c0e5 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -42,6 +42,8 @@ struct perf_session {
 	struct hists		hists;
 	u64			sample_type;
 	int			sample_size;
+	u64			sample_uregs;
+	bool			sample_ustack;
 	int			fd;
 	bool			fd_pipe;
 	bool			repipe;
@@ -134,7 +136,10 @@ static inline int perf_session__parse_sample(struct perf_session *session,
 {
 	return perf_event__parse_sample(event, session->sample_type,
 					session->sample_size,
-					session->sample_id_all, sample,
+					session->sample_id_all,
+					session->sample_uregs,
+					session->sample_ustack,
+					sample,
 					session->header.needs_swap);
 }
 
-- 
1.7.7.6

