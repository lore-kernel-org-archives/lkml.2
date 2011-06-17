Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847Ab1FQNhK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 09:37:10 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:57858
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753254Ab1FQNhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 09:37:07 -0400
X-SpamScore: 1
X-BigFish: VPS1(zzzz1202hzz8275bhz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LMXSHQ-02-52T-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 5/5] perf, tools: Do guest-only counting in perf-kvm by default
Date: Fri, 17 Jun 2011 15:37:34 +0200
Message-ID: <1308317854-27398-6-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1308317854-27398-1-git-send-email-joerg.roedel@amd.com>
References: <1308317854-27398-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of exclude_guest and exlude_host in perf-kvm to do
only guest-only counting by default.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
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
index 3c1b8a6..8262819 100644
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
index 1d7f664..376f67e 100644
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
index b021ea9..46d4ca7 100644
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
 		return -ENOMEM;
 
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 8bfb8de..1c97b4b 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -842,6 +842,7 @@ int parse_events(const struct option *opt, const char *str, int unset __used)
 	for (;;) {
 		ostr = str;
 		memset(&attr, 0, sizeof(attr));
+		event_attr_init(&attr);
 		ret = parse_event_symbols(opt, &str, &attr);
 		if (ret == EVT_FAILED)
 			return -1;
-- 
1.7.4.1


