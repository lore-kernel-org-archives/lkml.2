Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934552Ab1JEMBu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 08:01:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934532Ab1JEMBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 08:01:48 -0400
From: Gleb Natapov <gleb@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: avi@redhat.com, kvm@vger.kernel.org, joerg.roedel@amd.com, mingo@elte.hu,
        a.p.zijlstra@chello.nl
Subject: [PATCH v2 5/9] perf, tools: Do guest-only counting in perf-kvm by default
Date: Wed,  5 Oct 2011 14:01:20 +0200
Message-Id: <1317816084-18026-6-git-send-email-gleb@redhat.com>
In-Reply-To: <1317816084-18026-1-git-send-email-gleb@redhat.com>
References: <1317816084-18026-1-git-send-email-gleb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>

Make use of exclude_guest and exlude_host in perf-kvm to do
only guest-only counting by default.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Gleb Natapov <gleb@redhat.com>
---
 tools/perf/builtin-kvm.c       |    3 ++-
 tools/perf/util/event.c        |    8 ++++++++
 tools/perf/util/event.h        |    2 ++
 tools/perf/util/evlist.c       |    5 ++++-
 tools/perf/util/parse-events.c |    1 +
 5 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 032324a..9b05afa 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -107,7 +107,8 @@ static int __cmd_buildid_list(int argc, const char **argv)
 
 int cmd_kvm(int argc, const char **argv, const char *prefix __used)
 {
-	perf_host = perf_guest = 0;
+	perf_host  = 0;
+	perf_guest = 1;
 
 	argc = parse_options(argc, argv, kvm_options, kvm_usage,
 			PARSE_OPT_STOP_AT_NON_OPTION);
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 437f8ca..31a6d7f 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -44,6 +44,14 @@ static struct perf_sample synth_sample = {
 	.period	   = 1,
 };
 
+void event_attr_init(struct perf_event_attr *attr)
+{
+	if (!perf_host)
+		attr->exclude_host  = 1;
+	if (!perf_guest)
+		attr->exclude_guest = 1;
+}
+
 static pid_t perf_event__synthesize_comm(union perf_event *event, pid_t pid,
 					 int full, perf_event__handler_t process,
 					 struct perf_session *session)
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 357a85b..e5f101e 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -150,6 +150,8 @@ typedef int (*perf_event__handler_t)(union perf_event *event,
 				     struct perf_sample *sample,
 				      struct perf_session *session);
 
+void event_attr_init(struct perf_event_attr *attr);
+
 int perf_event__synthesize_thread_map(struct thread_map *threads,
 				      perf_event__handler_t process,
 				      struct perf_session *session);
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 72e9f48..4773fbe 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -82,8 +82,11 @@ int perf_evlist__add_default(struct perf_evlist *evlist)
 		.type = PERF_TYPE_HARDWARE,
 		.config = PERF_COUNT_HW_CPU_CYCLES,
 	};
-	struct perf_evsel *evsel = perf_evsel__new(&attr, 0);
+	struct perf_evsel *evsel;
+
+	event_attr_init(&attr);
 
+	evsel = perf_evsel__new(&attr, 0);
 	if (evsel == NULL)
 		goto error;
 
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 3b00775..620ba98 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -848,6 +848,7 @@ int parse_events(struct perf_evlist *evlist , const char *str, int unset __used)
 	for (;;) {
 		ostr = str;
 		memset(&attr, 0, sizeof(attr));
+		event_attr_init(&attr);
 		ret = parse_event_symbols(evlist, &str, &attr);
 		if (ret == EVT_FAILED)
 			return -1;
-- 
1.7.5.3

