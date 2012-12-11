Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455Ab2LKWyZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 17:54:25 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:53838
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755211Ab2LKWsm (ORCPT
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
Subject: [PATCH 30/37] perf evsel: No need to always ask for PERF_FORMAT_TOTAL_TIME_{ENABLED,RUNNING}
Date: Tue, 11 Dec 2012 19:48:16 -0300
Message-Id: <1355266103-17238-31-git-send-email-acme@infradead.org>
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

This is needed, so far, just in 'perf stat', to scale counters, so don't
unconditionally ask for them in the perf_evsel__config() method.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-ujpujgscq2f2oodxuso5nobc@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/attr/base-record        |    2 +-
 tools/perf/tests/attr/test-record-group  |    4 ++--
 tools/perf/tests/attr/test-record-group1 |    4 ++--
 tools/perf/util/evsel.c                  |    2 --
 4 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/tools/perf/tests/attr/base-record b/tools/perf/tests/attr/base-record
index f9d0464..5bc3880 100644
--- a/tools/perf/tests/attr/base-record
+++ b/tools/perf/tests/attr/base-record
@@ -7,7 +7,7 @@ size=96
 config=0
 sample_period=4000
 sample_type=263
-read_format=3
+read_format=0
 disabled=1
 inherit=1
 pinned=0
diff --git a/tools/perf/tests/attr/test-record-group b/tools/perf/tests/attr/test-record-group
index 0df34ca..57739ca 100644
--- a/tools/perf/tests/attr/test-record-group
+++ b/tools/perf/tests/attr/test-record-group
@@ -6,14 +6,14 @@ args    = --group -e cycles,instructions kill >/dev/null 2>&1
 fd=1
 group_fd=-1
 sample_type=327
-read_format=7
+read_format=4
 
 [event-2:base-record]
 fd=2
 group_fd=1
 config=1
 sample_type=327
-read_format=7
+read_format=4
 mmap=0
 comm=0
 enable_on_exec=0
diff --git a/tools/perf/tests/attr/test-record-group1 b/tools/perf/tests/attr/test-record-group1
index 18bd926..4d688a1 100644
--- a/tools/perf/tests/attr/test-record-group1
+++ b/tools/perf/tests/attr/test-record-group1
@@ -6,7 +6,7 @@ args    = -e '{cycles,instructions}' kill >/tmp/krava 2>&1
 fd=1
 group_fd=-1
 sample_type=327
-read_format=7
+read_format=4
 
 [event-2:base-record]
 fd=2
@@ -14,7 +14,7 @@ group_fd=1
 type=0
 config=1
 sample_type=327
-read_format=7
+read_format=4
 mmap=0
 comm=0
 enable_on_exec=0
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index e62d3ae..2492d32 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -465,8 +465,6 @@ void perf_evsel__config(struct perf_evsel *evsel,
 
 	attr->sample_id_all = opts->sample_id_all_missing ? 0 : 1;
 	attr->inherit	    = !opts->no_inherit;
-	attr->read_format   = PERF_FORMAT_TOTAL_TIME_ENABLED |
-			      PERF_FORMAT_TOTAL_TIME_RUNNING;
 
 	perf_evsel__set_sample_bit(evsel, IP);
 	perf_evsel__set_sample_bit(evsel, TID);
-- 
1.7.9.2.358.g22243

