Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab2LKWyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 17:54:21 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:53844
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755217Ab2LKWsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 17:48:42 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 29/37] perf evsel: No need to always ask for PERF_FORMAT_ID in read_format
Date: Tue, 11 Dec 2012 19:48:15 -0300
Message-Id: <1355266103-17238-30-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1355266103-17238-1-git-send-email-acme@infradead.org>
References: <1355266103-17238-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Instead make perf_evlist__confir_attrs use perf_evsel__set_sample_id()
when having more than one event, that way only if we have multiple
events we'll ask to have the event ids returned when we read its file
descriptors.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-xuho5hrrxy2ky0cjpr80hyfp@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/attr/base-record        |    2 +-
 tools/perf/tests/attr/test-record-group  |    2 ++
 tools/perf/tests/attr/test-record-group1 |    2 ++
 tools/perf/util/evlist.c                 |    2 +-
 tools/perf/util/evsel.c                  |    3 +--
 5 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/tools/perf/tests/attr/base-record b/tools/perf/tests/attr/base-record
index f1485d8..f9d0464 100644
--- a/tools/perf/tests/attr/base-record
+++ b/tools/perf/tests/attr/base-record
@@ -7,7 +7,7 @@ size=96
 config=0
 sample_period=4000
 sample_type=263
-read_format=7
+read_format=3
 disabled=1
 inherit=1
 pinned=0
diff --git a/tools/perf/tests/attr/test-record-group b/tools/perf/tests/attr/test-record-group
index a6599e9..0df34ca 100644
--- a/tools/perf/tests/attr/test-record-group
+++ b/tools/perf/tests/attr/test-record-group
@@ -6,12 +6,14 @@ args    = --group -e cycles,instructions kill >/dev/null 2>&1
 fd=1
 group_fd=-1
 sample_type=327
+read_format=7
 
 [event-2:base-record]
 fd=2
 group_fd=1
 config=1
 sample_type=327
+read_format=7
 mmap=0
 comm=0
 enable_on_exec=0
diff --git a/tools/perf/tests/attr/test-record-group1 b/tools/perf/tests/attr/test-record-group1
index 5a8359d..18bd926 100644
--- a/tools/perf/tests/attr/test-record-group1
+++ b/tools/perf/tests/attr/test-record-group1
@@ -6,6 +6,7 @@ args    = -e '{cycles,instructions}' kill >/tmp/krava 2>&1
 fd=1
 group_fd=-1
 sample_type=327
+read_format=7
 
 [event-2:base-record]
 fd=2
@@ -13,6 +14,7 @@ group_fd=1
 type=0
 config=1
 sample_type=327
+read_format=7
 mmap=0
 comm=0
 enable_on_exec=0
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 2655659..5a0878d 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -61,7 +61,7 @@ void perf_evlist__config_attrs(struct perf_evlist *evlist,
 		perf_evsel__config(evsel, opts);
 
 		if (evlist->nr_entries > 1)
-			perf_evsel__set_sample_bit(evsel, ID);
+			perf_evsel__set_sample_id(evsel);
 	}
 }
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 9dde7e9..e62d3ae 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -466,8 +466,7 @@ void perf_evsel__config(struct perf_evsel *evsel,
 	attr->sample_id_all = opts->sample_id_all_missing ? 0 : 1;
 	attr->inherit	    = !opts->no_inherit;
 	attr->read_format   = PERF_FORMAT_TOTAL_TIME_ENABLED |
-			      PERF_FORMAT_TOTAL_TIME_RUNNING |
-			      PERF_FORMAT_ID;
+			      PERF_FORMAT_TOTAL_TIME_RUNNING;
 
 	perf_evsel__set_sample_bit(evsel, IP);
 	perf_evsel__set_sample_bit(evsel, TID);
-- 
1.7.9.2.358.g22243

