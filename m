Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578Ab2ETCQt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 22:16:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:47678 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab2ETCQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 22:16:48 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6/6] perf evsel: Create events initially disabled -- again
Date: Sat, 19 May 2012 23:16:36 -0300
Message-Id: <1337480196-761-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1337480196-761-1-git-send-email-acme@infradead.org>
References: <1337480196-761-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

764e16a changed perf-record to create events disabled by default and
enable them once perf initializations are done. This setting was dropped
by 0f82ebc. Now perf events are once again generated during perf's
initialization phase (e.g., generating maps).

As an example, perf opens a lot of files at startup. Unpatched:

perf record -e syscalls:sys_enter_open -ga -fo /tmp/perf.data -- sleep 1
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.087 MB /tmp/perf.data (~3798 samples) ]

Using perf-script to look at the samples shows the perf command generating
563 of the 566 total events.

Patched:

perf record -e syscalls:sys_enter_open -ga -fo /tmp/perf.data -- sleep 1
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.028 MB /tmp/perf.data (~1206 samples) ]

Using perf-script to look at the samples does not show perf command.

Signed-off-by: David Ahern <dsahern@gmail.com>
Link: http://lkml.kernel.org/r/1336968088-11531-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index d7a2b4b..f4f427c 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -70,6 +70,7 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts,
 	struct perf_event_attr *attr = &evsel->attr;
 	int track = !evsel->idx; /* only the first counter needs these */
 
+	attr->disabled = 1;
 	attr->sample_id_all = opts->sample_id_all_missing ? 0 : 1;
 	attr->inherit	    = !opts->no_inherit;
 	attr->read_format   = PERF_FORMAT_TOTAL_TIME_ENABLED |
@@ -138,7 +139,6 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts,
 
 	if (perf_target__none(&opts->target) &&
 	    (!opts->group || evsel == first)) {
-		attr->disabled = 1;
 		attr->enable_on_exec = 1;
 	}
 }
-- 
1.7.9.2.358.g22243

