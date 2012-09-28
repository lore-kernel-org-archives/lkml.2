Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543Ab2I1Q2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 12:28:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41853 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758342Ab2I1Q2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 12:28:47 -0400
Date: Fri, 28 Sep 2012 09:28:28 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-8tjuxk09mlsfmh7macgkxsip@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel: Handle endianity in intval method
Git-Commit-ID: e6b6f6795265ec19ff35572f527bb74c07ff9399
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 28 Sep 2012 09:28:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e6b6f6795265ec19ff35572f527bb74c07ff9399
Gitweb:     http://git.kernel.org/tip/e6b6f6795265ec19ff35572f527bb74c07ff9399
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 26 Sep 2012 13:13:04 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 26 Sep 2012 13:41:47 -0300

perf evsel: Handle endianity in intval method

We were relying on the info in pevent, but since we have it in
perf_evsel, set up by the perf_session routine if read from a perf.data
file or by whoever creates the evsels, use it.

New 'perf test' entries will use it to parse locally generated events,
in a non perf.data centered workflow.

As well as use byteswap.h to get per arch optimized swap routines, like
other parts of perf (header, perf_evsel__parse_sample, symbol, etc)
already do.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-8tjuxk09mlsfmh7macgkxsip@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c |   38 ++++++++++++++++++++++++++++++++++----
 1 files changed, 34 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index fe9581b..c78e42a 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1108,13 +1108,43 @@ u64 perf_evsel__intval(struct perf_evsel *evsel, struct perf_sample *sample,
 		       const char *name)
 {
 	struct format_field *field = perf_evsel__field(evsel, name);
-	u64 val;
+	void *ptr;
+	u64 value;
 
 	if (!field)
 		return 0;
 
-	val = pevent_read_number(evsel->tp_format->pevent,
-				 sample->raw_data + field->offset, field->size);
-	return val;
+	ptr = sample->raw_data + field->offset;
 
+	switch (field->size) {
+	case 1:
+		return *(u8 *)ptr;
+	case 2:
+		value = *(u16 *)ptr;
+		break;
+	case 4:
+		value = *(u32 *)ptr;
+		break;
+	case 8:
+		value = *(u64 *)ptr;
+		break;
+	default:
+		return 0;
+	}
+
+	if (!evsel->needs_swap)
+		return value;
+
+	switch (field->size) {
+	case 2:
+		return bswap_16(value);
+	case 4:
+		return bswap_32(value);
+	case 8:
+		return bswap_64(value);
+	default:
+		return 0;
+	}
+
+	return 0;
 }
