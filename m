Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757315Ab2IXQF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:05:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:41445 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756680Ab2IXP77 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 11:59:59 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>, Dong Hao <haodong@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>
Subject: [PATCH 07/30] perf kvm: Use perf_evsel__intval
Date: Mon, 24 Sep 2012 12:59:21 -0300
Message-Id: <1348502384-14442-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1348502384-14442-1-git-send-email-acme@infradead.org>
References: <1348502384-14442-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Using plain raw_field_value(evsel->tp_format) will look at the common
fields as well, and since this tool doesn't need those, speed it up a
bit by looking at just the event specific fields.

Also in general use just evsel and sample, just like was done in 'perf
sched'.

v2: Fixed up test against evsel->name, that contains the subsys name
too, by David Ahern.

Cc: David Ahern <dsahern@gmail.com>
Cc: Dong Hao <haodong@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Runzhen Wang <runzhen@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/n/tip-v9x3q9rv4caxtox7wtjpchq5@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c |  130 ++++++++++++++++++++++++----------------------
 1 files changed, 67 insertions(+), 63 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 1878947..3eb53e3 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -33,46 +33,49 @@ struct event_key {
 };
 
 struct kvm_events_ops {
-	bool (*is_begin_event)(struct event_format *event, void *data,
-				struct event_key *key);
-	bool (*is_end_event)(struct event_format *event, void *data,
-				struct event_key *key);
+	bool (*is_begin_event)(struct perf_evsel *evsel,
+			       struct perf_sample *sample,
+			       struct event_key *key);
+	bool (*is_end_event)(struct perf_evsel *evsel,
+			     struct perf_sample *sample, struct event_key *key);
 	void (*decode_key)(struct event_key *key, char decode[20]);
 	const char *name;
 };
 
-static void exit_event_get_key(struct event_format *event, void *data,
-				struct event_key *key)
+static void exit_event_get_key(struct perf_evsel *evsel,
+			       struct perf_sample *sample,
+			       struct event_key *key)
 {
 	key->info = 0;
-	key->key = raw_field_value(event, "exit_reason", data);
+	key->key = perf_evsel__intval(evsel, sample, "exit_reason");
 }
 
-static bool kvm_exit_event(struct event_format *event)
+static bool kvm_exit_event(struct perf_evsel *evsel)
 {
-	return !strcmp(event->name, "kvm_exit");
+	return !strcmp(evsel->name, "kvm:kvm_exit");
 }
 
-static bool exit_event_begin(struct event_format *event, void *data,
-				struct event_key *key)
+static bool exit_event_begin(struct perf_evsel *evsel,
+			     struct perf_sample *sample, struct event_key *key)
 {
-	if (kvm_exit_event(event)) {
-		exit_event_get_key(event, data, key);
+	if (kvm_exit_event(evsel)) {
+		exit_event_get_key(evsel, sample, key);
 		return true;
 	}
 
 	return false;
 }
 
-static bool kvm_entry_event(struct event_format *event)
+static bool kvm_entry_event(struct perf_evsel *evsel)
 {
-	return !strcmp(event->name, "kvm_entry");
+	return !strcmp(evsel->name, "kvm:kvm_entry");
 }
 
-static bool exit_event_end(struct event_format *event, void *data __maybe_unused,
-				struct event_key *key __maybe_unused)
+static bool exit_event_end(struct perf_evsel *evsel,
+			   struct perf_sample *sample __maybe_unused,
+			   struct event_key *key __maybe_unused)
 {
-	return kvm_entry_event(event);
+	return kvm_entry_event(evsel);
 }
 
 struct exit_reasons_table {
@@ -130,45 +133,45 @@ static struct kvm_events_ops exit_events = {
      * the time of MMIO write: kvm_mmio(KVM_TRACE_MMIO_WRITE...) -> kvm_entry
      * the time of MMIO read: kvm_exit -> kvm_mmio(KVM_TRACE_MMIO_READ...).
      */
-static void mmio_event_get_key(struct event_format *event, void *data,
-				struct event_key *key)
+static void mmio_event_get_key(struct perf_evsel *evsel, struct perf_sample *sample,
+			       struct event_key *key)
 {
-	key->key = raw_field_value(event, "gpa", data);
-	key->info = raw_field_value(event, "type", data);
+	key->key  = perf_evsel__intval(evsel, sample, "gpa");
+	key->info = perf_evsel__intval(evsel, sample, "type");
 }
 
 #define KVM_TRACE_MMIO_READ_UNSATISFIED 0
 #define KVM_TRACE_MMIO_READ 1
 #define KVM_TRACE_MMIO_WRITE 2
 
-static bool mmio_event_begin(struct event_format *event, void *data,
-				struct event_key *key)
+static bool mmio_event_begin(struct perf_evsel *evsel,
+			     struct perf_sample *sample, struct event_key *key)
 {
 	/* MMIO read begin event in kernel. */
-	if (kvm_exit_event(event))
+	if (kvm_exit_event(evsel))
 		return true;
 
 	/* MMIO write begin event in kernel. */
-	if (!strcmp(event->name, "kvm_mmio") &&
-		raw_field_value(event, "type", data) == KVM_TRACE_MMIO_WRITE) {
-		mmio_event_get_key(event, data, key);
+	if (!strcmp(evsel->name, "kvm:kvm_mmio") &&
+	    perf_evsel__intval(evsel, sample, "type") == KVM_TRACE_MMIO_WRITE) {
+		mmio_event_get_key(evsel, sample, key);
 		return true;
 	}
 
 	return false;
 }
 
-static bool mmio_event_end(struct event_format *event,  void *data,
-			struct event_key *key)
+static bool mmio_event_end(struct perf_evsel *evsel, struct perf_sample *sample,
+			   struct event_key *key)
 {
 	/* MMIO write end event in kernel. */
-	if (kvm_entry_event(event))
+	if (kvm_entry_event(evsel))
 		return true;
 
 	/* MMIO read end event in kernel.*/
-	if (!strcmp(event->name, "kvm_mmio") &&
-		raw_field_value(event, "type", data) == KVM_TRACE_MMIO_READ) {
-		mmio_event_get_key(event, data, key);
+	if (!strcmp(evsel->name, "kvm:kvm_mmio") &&
+	    perf_evsel__intval(evsel, sample, "type") == KVM_TRACE_MMIO_READ) {
+		mmio_event_get_key(evsel, sample, key);
 		return true;
 	}
 
@@ -189,31 +192,31 @@ static struct kvm_events_ops mmio_events = {
 };
 
  /* The time of emulation pio access is from kvm_pio to kvm_entry. */
-static void ioport_event_get_key(struct event_format *event, void *data,
-			struct event_key *key)
+static void ioport_event_get_key(struct perf_evsel *evsel,
+				 struct perf_sample *sample,
+				 struct event_key *key)
 {
-	key->key = raw_field_value(event, "port", data);
-	key->info = raw_field_value(event, "rw", data);
+	key->key  = perf_evsel__intval(evsel, sample, "port");
+	key->info = perf_evsel__intval(evsel, sample, "rw");
 }
 
-static bool ioport_event_begin(struct event_format *event, void *data,
-			struct event_key *key)
+static bool ioport_event_begin(struct perf_evsel *evsel,
+			       struct perf_sample *sample,
+			       struct event_key *key)
 {
-	if (!strcmp(event->name, "kvm_pio")) {
-		ioport_event_get_key(event, data, key);
+	if (!strcmp(evsel->name, "kvm:kvm_pio")) {
+		ioport_event_get_key(evsel, sample, key);
 		return true;
 	}
 
 	return false;
 }
 
-static bool ioport_event_end(struct event_format *event, void *data __maybe_unused,
+static bool ioport_event_end(struct perf_evsel *evsel,
+			     struct perf_sample *sample __maybe_unused,
 			     struct event_key *key __maybe_unused)
 {
-	if (kvm_entry_event(event))
-		return true;
-
-	return false;
+	return kvm_entry_event(evsel);
 }
 
 static void ioport_event_decode_key(struct event_key *key, char decode[20])
@@ -430,41 +433,43 @@ static bool handle_end_event(struct vcpu_event_record *vcpu_record,
 	return update_kvm_event(event, vcpu_record->vcpu_id, time_diff);
 }
 
-static struct vcpu_event_record
-*per_vcpu_record(struct thread *thread, struct event_format *event, void *data)
+static
+struct vcpu_event_record *per_vcpu_record(struct thread *thread,
+					  struct perf_evsel *evsel,
+					  struct perf_sample *sample)
 {
 	/* Only kvm_entry records vcpu id. */
-	if (!thread->priv && kvm_entry_event(event)) {
+	if (!thread->priv && kvm_entry_event(evsel)) {
 		struct vcpu_event_record *vcpu_record;
 
-		vcpu_record = zalloc(sizeof(struct vcpu_event_record));
+		vcpu_record = zalloc(sizeof(*vcpu_record));
 		if (!vcpu_record) {
-			pr_err("Not enough memory\n");
+			pr_err("%s: Not enough memory\n", __func__);
 			return NULL;
 		}
 
-		vcpu_record->vcpu_id = raw_field_value(event, "vcpu_id", data);
+		vcpu_record->vcpu_id = perf_evsel__intval(evsel, sample, "vcpu_id");
 		thread->priv = vcpu_record;
 	}
 
-	return (struct vcpu_event_record *)thread->priv;
+	return thread->priv;
 }
 
-static bool handle_kvm_event(struct thread *thread, struct event_format *event,
-			     void *data, u64 timestamp)
+static bool handle_kvm_event(struct thread *thread, struct perf_evsel *evsel,
+			     struct perf_sample *sample)
 {
 	struct vcpu_event_record *vcpu_record;
 	struct event_key key = {.key = INVALID_KEY};
 
-	vcpu_record = per_vcpu_record(thread, event, data);
+	vcpu_record = per_vcpu_record(thread, evsel, sample);
 	if (!vcpu_record)
 		return true;
 
-	if (events_ops->is_begin_event(event, data, &key))
-		return handle_begin_event(vcpu_record, &key, timestamp);
+	if (events_ops->is_begin_event(evsel, sample, &key))
+		return handle_begin_event(vcpu_record, &key, sample->time);
 
-	if (events_ops->is_end_event(event, data, &key))
-		return handle_end_event(vcpu_record, &key, timestamp);
+	if (events_ops->is_end_event(evsel, sample, &key))
+		return handle_end_event(vcpu_record, &key, sample->time);
 
 	return true;
 }
@@ -645,8 +650,7 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 		return -1;
 	}
 
-	if (!handle_kvm_event(thread, evsel->tp_format, sample->raw_data,
-			 sample->time))
+	if (!handle_kvm_event(thread, evsel, sample))
 		return -1;
 
 	return 0;
-- 
1.7.1

