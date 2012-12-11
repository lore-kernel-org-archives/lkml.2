Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab2LKW4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 17:56:38 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43853 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200Ab2LKWsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 17:48:40 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 34/37] perf evsel: Decode read_format and sample_type in perf_evsel__fprintf
Date: Tue, 11 Dec 2012 19:48:20 -0300
Message-Id: <1355266103-17238-35-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1355266103-17238-1-git-send-email-acme@infradead.org>
References: <1355266103-17238-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Before those fields showed just a number, now it decodes each bit:

[root@sandy linux]# perf evlist -v
cycles: sample_freq=4000, size: 96, sample_type: IP|TID|TIME|CPU|PERIOD, read_format: TOTAL_TIME_ENABLED|TOTAL_TIME_RUNNING|ID, disabled: 1, inherit: 1, mmap: 1, comm: 1, freq: 1, sample_id_all: 1, exclude_guest: 1

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-64ezdtiijolgti08ae3phxyj@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c |   52 +++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 50 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 643df4b..7a2a3dc 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1257,6 +1257,53 @@ static int __if_fprintf(FILE *fp, bool *first, const char *field, u64 value)
 
 #define if_print(field) printed += __if_fprintf(fp, &first, #field, evsel->attr.field)
 
+struct bit_names {
+	int bit;
+	const char *name;
+};
+
+static int bits__fprintf(FILE *fp, const char *field, u64 value,
+			 struct bit_names *bits, bool *first)
+{
+	int i = 0, printed = comma_fprintf(fp, first, " %s: ", field);
+	bool first_bit = true;
+
+	do {
+		if (value & bits[i].bit) {
+			printed += fprintf(fp, "%s%s", first_bit ? "" : "|", bits[i].name);
+			first_bit = false;
+		}
+	} while (bits[++i].name != NULL);
+
+	return printed;
+}
+
+static int sample_type__fprintf(FILE *fp, bool *first, u64 value)
+{
+#define bit_name(n) { PERF_SAMPLE_##n, #n }
+	struct bit_names bits[] = {
+		bit_name(IP), bit_name(TID), bit_name(TIME), bit_name(ADDR),
+		bit_name(READ), bit_name(CALLCHAIN), bit_name(ID), bit_name(CPU),
+		bit_name(PERIOD), bit_name(STREAM_ID), bit_name(RAW),
+		bit_name(BRANCH_STACK), bit_name(REGS_USER), bit_name(STACK_USER),
+		{ .name = NULL, }
+	};
+#undef bit_name
+	return bits__fprintf(fp, "sample_type", value, bits, first);
+}
+
+static int read_format__fprintf(FILE *fp, bool *first, u64 value)
+{
+#define bit_name(n) { PERF_FORMAT_##n, #n }
+	struct bit_names bits[] = {
+		bit_name(TOTAL_TIME_ENABLED), bit_name(TOTAL_TIME_RUNNING),
+		bit_name(ID), bit_name(GROUP),
+		{ .name = NULL, }
+	};
+#undef bit_name
+	return bits__fprintf(fp, "read_format", value, bits, first);
+}
+
 int perf_evsel__fprintf(struct perf_evsel *evsel,
 			struct perf_attr_details *details, FILE *fp)
 {
@@ -1274,8 +1321,9 @@ int perf_evsel__fprintf(struct perf_evsel *evsel,
 		if_print(config1);
 		if_print(config2);
 		if_print(size);
-		if_print(sample_type);
-		if_print(read_format);
+		printed += sample_type__fprintf(fp, &first, evsel->attr.sample_type);
+		if (evsel->attr.read_format)
+			printed += read_format__fprintf(fp, &first, evsel->attr.read_format);
 		if_print(disabled);
 		if_print(inherit);
 		if_print(pinned);
-- 
1.7.9.2.358.g22243

