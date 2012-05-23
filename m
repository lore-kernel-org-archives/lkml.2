Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965582Ab2EWTeE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 15:34:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14593 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965559Ab2EWTdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 15:33:50 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: eranian@google.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, robert.richter@amd.com, fche@redhat.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        drepper@gmail.com, asharma@fb.com, benjamin.redelings@nescent.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 12/16] perf, tool: Support user regs and stack in sample parsing
Date: Wed, 23 May 2012 21:32:11 +0200
Message-Id: <1337801535-12865-13-git-send-email-jolsa@redhat.com>
In-Reply-To: <1337801535-12865-1-git-send-email-jolsa@redhat.com>
References: <1337801535-12865-1-git-send-email-jolsa@redhat.com>
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
 tools/perf/builtin-test.c |    3 +-
 tools/perf/util/event.h   |   16 ++++++++++++-
 tools/perf/util/evlist.c  |   24 +++++++++++++++++++
 tools/perf/util/evlist.h  |    3 ++
 tools/perf/util/evsel.c   |   30 +++++++++++++++++++++++-
 tools/perf/util/python.c  |    3 +-
 tools/perf/util/session.c |   56 +++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/session.h |   12 ++++++++-
 8 files changed, 141 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 5a8727c..082d279 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -564,7 +564,7 @@ static int test__basic_mmap(void)
 		}
 
 		err = perf_event__parse_sample(event, attr.sample_type, sample_size,
-					       false, &sample, false);
+					       false, 0, 0, 0, &sample, false);
 		if (err) {
 			pr_err("Can't parse sample, err = %d\n", err);
 			goto out_munmap;
@@ -790,6 +790,7 @@ static int test__PERF_RECORD(void)
 
 				err = perf_event__parse_sample(event, sample_type,
 							       sample_size, true,
+							       0, 0, 0,
 							       &sample, false);
 				if (err < 0) {
 					if (verbose)
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 1b19728..4b03b68 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -69,6 +69,16 @@ struct sample_event {
 	u64 array[];
 };
 
+struct regs_dump {
+	u64 version;
+	u64 *regs;
+};
+
+struct stack_dump {
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
+	struct regs_dump  user_regs;
+	struct stack_dump user_stack;
 };
 
 #define BUILD_ID_SIZE 20
@@ -199,7 +211,9 @@ const char *perf_event__name(unsigned int id);
 
 int perf_event__parse_sample(const union perf_event *event, u64 type,
 			     int sample_size, bool sample_id_all,
-			     struct perf_sample *sample, bool swapped);
+			     u64 sample_regs_mode, u64 sample_regs_user,
+			     u64 sample_stack, struct perf_sample *data,
+			     bool swapped);
 int perf_event__synthesize_sample(union perf_event *event, u64 type,
 				  const struct perf_sample *sample,
 				  bool swapped);
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 4ac5f5a..548caa0 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -676,6 +676,30 @@ bool perf_evlist__valid_sample_type(const struct perf_evlist *evlist)
 	return true;
 }
 
+u64 perf_evlist__sample_regs(const struct perf_evlist *evlist)
+{
+	struct perf_evsel *first;
+
+	first = list_entry(evlist->entries.next, struct perf_evsel, node);
+	return first->attr.sample_regs;
+}
+
+u64 perf_evlist__sample_regs_user(const struct perf_evlist *evlist)
+{
+	struct perf_evsel *first;
+
+	first = list_entry(evlist->entries.next, struct perf_evsel, node);
+	return first->attr.sample_regs_user;
+}
+
+u64 perf_evlist__sample_stack(const struct perf_evlist *evlist)
+{
+	struct perf_evsel *first;
+
+	first = list_entry(evlist->entries.next, struct perf_evsel, node);
+	return first->attr.sample_stack;
+}
+
 u64 perf_evlist__sample_type(const struct perf_evlist *evlist)
 {
 	struct perf_evsel *first;
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 58abb63..206810c 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -117,6 +117,9 @@ u16 perf_evlist__id_hdr_size(const struct perf_evlist *evlist);
 
 bool perf_evlist__valid_sample_type(const struct perf_evlist *evlist);
 bool perf_evlist__valid_sample_id_all(const struct perf_evlist *evlist);
+u64 perf_evlist__sample_regs(const struct perf_evlist *evlist);
+u64 perf_evlist__sample_regs_user(const struct perf_evlist *evlist);
+u64 perf_evlist__sample_stack(const struct perf_evlist *evlist);
 
 void perf_evlist__splice_list_tail(struct perf_evlist *evlist,
 				   struct list_head *list,
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 57e4ce5..8d21d2c 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -8,6 +8,7 @@
  */
 
 #include <byteswap.h>
+#include <linux/bitops.h>
 #include "asm/bug.h"
 #include "evsel.h"
 #include "evlist.h"
@@ -454,7 +455,9 @@ static bool sample_overlap(const union perf_event *event,
 
 int perf_event__parse_sample(const union perf_event *event, u64 type,
 			     int sample_size, bool sample_id_all,
-			     struct perf_sample *data, bool swapped)
+			     u64 sample_regs, u64 sample_regs_user,
+			     u64 sample_stack, struct perf_sample *data,
+			     bool swapped)
 {
 	const u64 *array;
 
@@ -592,6 +595,31 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 		sz /= sizeof(u64);
 		array += sz;
 	}
+
+	if (type & PERF_SAMPLE_REGS) {
+		if (sample_regs & PERF_SAMPLE_REGS_USER) {
+			data->user_regs.version = *array++;
+			if (data->user_regs.version) {
+				data->user_regs.regs = (u64 *)array;
+				array += hweight_long(sample_regs_user);
+			}
+		}
+	}
+
+	if (type & PERF_SAMPLE_STACK) {
+		if (sample_stack & PERF_SAMPLE_STACK_USER) {
+			u64 size = *array++;
+
+			if (!size) {
+				data->user_stack.size = 0;
+			} else {
+				data->user_stack.data = (char *)array;
+				array += size / sizeof(*array);
+				data->user_stack.size = *array;
+			}
+		}
+	}
+
 	return 0;
 }
 
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index e03b58a..d91ff53 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -807,7 +807,8 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
 		first = list_entry(evlist->entries.next, struct perf_evsel, node);
 		err = perf_event__parse_sample(event, first->attr.sample_type,
 					       perf_evsel__sample_size(first),
-					       sample_id_all, &pevent->sample, false);
+					       sample_id_all, 0, 0, 0,
+					       &pevent->sample, false);
 		if (err)
 			return PyErr_Format(PyExc_OSError,
 					    "perf: can't parse sample, err=%d", err);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 83f5884..17688c6 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -15,6 +15,7 @@
 #include "util.h"
 #include "cpumap.h"
 #include "vdso.h"
+#include "perf_regs.h"
 
 static int perf_session__open(struct perf_session *self, bool force)
 {
@@ -87,6 +88,9 @@ void perf_session__update_sample_type(struct perf_session *self)
 	self->sample_id_all = perf_evlist__sample_id_all(self->evlist);
 	self->id_hdr_size = perf_evlist__id_hdr_size(self->evlist);
 	self->host_machine.id_hdr_size = self->id_hdr_size;
+	self->sample_regs = perf_evlist__sample_regs(self->evlist);
+	self->sample_regs_user = perf_evlist__sample_regs_user(self->evlist);
+	self->sample_stack = perf_evlist__sample_stack(self->evlist);
 }
 
 int perf_session__create_kernel_maps(struct perf_session *self)
@@ -804,6 +808,52 @@ static void branch_stack__printf(struct perf_sample *sample)
 			sample->branch_stack->entries[i].to);
 }
 
+static void regs_dump__printf(u64 mask, u64 *regs)
+{
+	int i = 0, rid = 0;
+
+	do {
+		u64 val;
+
+		if (mask & 1) {
+			val = regs[i++];
+			printf(".... %-5s 0x%" PRIx64 "\n",
+			       perf_reg_name(rid), val);
+		}
+
+		rid++;
+		mask >>= 1;
+
+	} while (mask);
+}
+
+static void regs_user__printf(struct perf_sample *sample, u64 mask)
+{
+	struct regs_dump *user_regs = &sample->user_regs;
+
+	if (!user_regs->version ||
+	    (user_regs->version != perf_reg_version()))
+		return;
+
+	printf("... user regs: mask 0x%" PRIx64 "\n", mask);
+
+	regs_dump__printf(mask, user_regs->regs);
+}
+
+static void regs__printf(struct perf_sample *sample,
+			struct perf_session *session)
+{
+	if ((session->sample_regs & PERF_SAMPLE_REGS_USER))
+		regs_user__printf(sample, session->sample_regs_user);
+}
+
+static void stack__printf(struct perf_sample *sample, u64 sample_stack)
+{
+	if ((sample_stack & PERF_SAMPLE_STACK_USER))
+		printf("... ustack: size %" PRIu64 "\n",
+		       sample->user_stack.size);
+}
+
 static void perf_session__print_tstamp(struct perf_session *session,
 				       union perf_event *event,
 				       struct perf_sample *sample)
@@ -854,6 +904,12 @@ static void dump_sample(struct perf_session *session, union perf_event *event,
 
 	if (session->sample_type & PERF_SAMPLE_BRANCH_STACK)
 		branch_stack__printf(sample);
+
+	if (session->sample_type & PERF_SAMPLE_REGS)
+		regs__printf(sample, session);
+
+	if (session->sample_type & PERF_SAMPLE_STACK)
+		stack__printf(sample, session->sample_stack);
 }
 
 static struct machine *
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 7a5434c..c32c3ec 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -42,6 +42,9 @@ struct perf_session {
 	struct hists		hists;
 	u64			sample_type;
 	int			sample_size;
+	u64			sample_regs;
+	u64			sample_regs_user;
+	u64			sample_stack;
 	int			fd;
 	bool			fd_pipe;
 	bool			repipe;
@@ -132,9 +135,14 @@ static inline int perf_session__parse_sample(struct perf_session *session,
 					     const union perf_event *event,
 					     struct perf_sample *sample)
 {
-	return perf_event__parse_sample(event, session->sample_type,
+	return perf_event__parse_sample(event,
+					session->sample_type,
 					session->sample_size,
-					session->sample_id_all, sample,
+					session->sample_id_all,
+					session->sample_regs,
+					session->sample_regs_user,
+					session->sample_stack,
+					sample,
 					session->header.needs_swap);
 }
 
-- 
1.7.7.6

