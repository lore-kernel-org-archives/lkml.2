Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab2FKNVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 09:21:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21632 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825Ab2FKNVr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 09:21:47 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: eranian@google.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, robert.richter@amd.com, fche@redhat.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        drepper@gmail.com, asharma@fb.com, benjamin.redelings@nescent.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 15/19] perf, tool: Support user regs and stack in sample parsing
Date: Mon, 11 Jun 2012 15:20:10 +0200
Message-Id: <1339420814-7379-16-git-send-email-jolsa@redhat.com>
In-Reply-To: <1339420814-7379-1-git-send-email-jolsa@redhat.com>
References: <1339420814-7379-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding following info to be parsed out of the event sample:
 - user register set
 - user stack dump

Both are global and specific to all events within the session.
This info will be used in the unwind patches comming in shortly.

Adding simple output printout (report -D) for both register and
stack dumps.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/builtin-test.c |    3 ++-
 tools/perf/util/event.h   |   15 ++++++++++++++-
 tools/perf/util/evlist.c  |   16 ++++++++++++++++
 tools/perf/util/evlist.h  |    2 ++
 tools/perf/util/evsel.c   |   25 +++++++++++++++++++++++++
 tools/perf/util/python.c  |    3 ++-
 tools/perf/util/session.c |   43 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/session.h |   10 ++++++++--
 8 files changed, 112 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 5a8727c..8c2fcb0 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -564,7 +564,7 @@ static int test__basic_mmap(void)
 		}
 
 		err = perf_event__parse_sample(event, attr.sample_type, sample_size,
-					       false, &sample, false);
+					       false, 0, 0, &sample, false);
 		if (err) {
 			pr_err("Can't parse sample, err = %d\n", err);
 			goto out_munmap;
@@ -790,6 +790,7 @@ static int test__PERF_RECORD(void)
 
 				err = perf_event__parse_sample(event, sample_type,
 							       sample_size, true,
+							       0, 0,
 							       &sample, false);
 				if (err < 0) {
 					if (verbose)
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 1b19728..c2aa7ba 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -69,6 +69,15 @@ struct sample_event {
 	u64 array[];
 };
 
+struct regs_dump {
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
@@ -82,6 +91,8 @@ struct perf_sample {
 	void *raw_data;
 	struct ip_callchain *callchain;
 	struct branch_stack *branch_stack;
+	struct regs_dump  user_regs;
+	struct stack_dump user_stack;
 };
 
 #define BUILD_ID_SIZE 20
@@ -199,7 +210,9 @@ const char *perf_event__name(unsigned int id);
 
 int perf_event__parse_sample(const union perf_event *event, u64 type,
 			     int sample_size, bool sample_id_all,
-			     struct perf_sample *sample, bool swapped);
+			     u64 sample_regs_user, u64 sample_stack_user,
+			     struct perf_sample *data, bool swapped);
+
 int perf_event__synthesize_sample(union perf_event *event, u64 type,
 				  const struct perf_sample *sample,
 				  bool swapped);
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 7400fb3..b7c6ffa 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -689,6 +689,22 @@ bool perf_evlist__valid_sample_type(const struct perf_evlist *evlist)
 	return true;
 }
 
+u64 perf_evlist__sample_regs_user(const struct perf_evlist *evlist)
+{
+	struct perf_evsel *first;
+
+	first = list_entry(evlist->entries.next, struct perf_evsel, node);
+	return first->attr.sample_regs_user;
+}
+
+u64 perf_evlist__sample_stack_user(const struct perf_evlist *evlist)
+{
+	struct perf_evsel *first;
+
+	first = list_entry(evlist->entries.next, struct perf_evsel, node);
+	return first->attr.sample_stack_user;
+}
+
 u64 perf_evlist__sample_type(const struct perf_evlist *evlist)
 {
 	struct perf_evsel *first;
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 989bee9..0b2560f 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -121,6 +121,8 @@ u16 perf_evlist__id_hdr_size(const struct perf_evlist *evlist);
 
 bool perf_evlist__valid_sample_type(const struct perf_evlist *evlist);
 bool perf_evlist__valid_sample_id_all(const struct perf_evlist *evlist);
+u64 perf_evlist__sample_regs_user(const struct perf_evlist *evlist);
+u64 perf_evlist__sample_stack_user(const struct perf_evlist *evlist);
 
 void perf_evlist__splice_list_tail(struct perf_evlist *evlist,
 				   struct list_head *list,
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 9f6cebd..32ade1f 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -8,6 +8,7 @@
  */
 
 #include <byteswap.h>
+#include <linux/bitops.h>
 #include "asm/bug.h"
 #include "evsel.h"
 #include "evlist.h"
@@ -559,6 +560,7 @@ static bool sample_overlap(const union perf_event *event,
 
 int perf_event__parse_sample(const union perf_event *event, u64 type,
 			     int sample_size, bool sample_id_all,
+			     u64 sample_regs_user, u64 sample_stack_user,
 			     struct perf_sample *data, bool swapped)
 {
 	const u64 *array;
@@ -697,6 +699,29 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 		sz /= sizeof(u64);
 		array += sz;
 	}
+
+	if (sample_regs_user) {
+		/* First u64 tells us if we have any regs in sample. */
+		u64 avail = *array++;
+
+		if (avail) {
+			data->user_regs.regs = (u64 *)array;
+			array += hweight_long(sample_regs_user);
+		}
+	}
+
+	if (sample_stack_user) {
+		u64 size = *array++;
+
+		if (!size) {
+			data->user_stack.size = 0;
+		} else {
+			data->user_stack.data = (char *)array;
+			array += size / sizeof(*array);
+			data->user_stack.size = *array;
+		}
+	}
+
 	return 0;
 }
 
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index e03b58a..17eb1f9 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -807,7 +807,8 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
 		first = list_entry(evlist->entries.next, struct perf_evsel, node);
 		err = perf_event__parse_sample(event, first->attr.sample_type,
 					       perf_evsel__sample_size(first),
-					       sample_id_all, &pevent->sample, false);
+					       sample_id_all, 0, 0,
+					       &pevent->sample, false);
 		if (err)
 			return PyErr_Format(PyExc_OSError,
 					    "perf: can't parse sample, err=%d", err);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index f400612..8dd331d 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -15,6 +15,7 @@
 #include "util.h"
 #include "cpumap.h"
 #include "vdso.h"
+#include "perf_regs.h"
 
 static int perf_session__open(struct perf_session *self, bool force)
 {
@@ -87,6 +88,8 @@ void perf_session__update_sample_type(struct perf_session *self)
 	self->sample_id_all = perf_evlist__sample_id_all(self->evlist);
 	self->id_hdr_size = perf_evlist__id_hdr_size(self->evlist);
 	self->host_machine.id_hdr_size = self->id_hdr_size;
+	self->sample_regs_user = perf_evlist__sample_regs_user(self->evlist);
+	self->sample_stack_user = perf_evlist__sample_stack_user(self->evlist);
 }
 
 int perf_session__create_kernel_maps(struct perf_session *self)
@@ -851,6 +854,40 @@ static void branch_stack__printf(struct perf_sample *sample)
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
+	if (user_regs->regs) {
+		printf("... user regs: mask 0x%" PRIx64 "\n", mask);
+		regs_dump__printf(mask, user_regs->regs);
+	}
+}
+
+static void stack_user__printf(struct stack_dump *dump)
+{
+	printf("... ustack: size %" PRIu64 "\n", dump->size);
+}
+
 static void perf_session__print_tstamp(struct perf_session *session,
 				       union perf_event *event,
 				       struct perf_sample *sample)
@@ -901,6 +938,12 @@ static void dump_sample(struct perf_session *session, union perf_event *event,
 
 	if (session->sample_type & PERF_SAMPLE_BRANCH_STACK)
 		branch_stack__printf(sample);
+
+	if (session->sample_regs_user)
+		regs_user__printf(sample, session->sample_regs_user);
+
+	if (session->sample_stack_user)
+		stack_user__printf(&sample->user_stack);
 }
 
 static struct machine *
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 877d781..452d826 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -42,6 +42,8 @@ struct perf_session {
 	struct hists		hists;
 	u64			sample_type;
 	int			sample_size;
+	u64			sample_regs_user;
+	u64			sample_stack_user;
 	int			fd;
 	bool			fd_pipe;
 	bool			repipe;
@@ -132,9 +134,13 @@ static inline int perf_session__parse_sample(struct perf_session *session,
 					     const union perf_event *event,
 					     struct perf_sample *sample)
 {
-	return perf_event__parse_sample(event, session->sample_type,
+	return perf_event__parse_sample(event,
+					session->sample_type,
 					session->sample_size,
-					session->sample_id_all, sample,
+					session->sample_id_all,
+					session->sample_regs_user,
+					session->sample_stack_user,
+					sample,
 					session->header.needs_swap);
 }
 
-- 
1.7.7.6

