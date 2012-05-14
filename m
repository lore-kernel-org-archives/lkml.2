Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab2ENEBg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 00:01:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60725 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab2ENEBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 00:01:35 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf-record: Create events initially disabled -- again
Date: Sun, 13 May 2012 22:01:28 -0600
Message-Id: <1336968088-11531-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 tools/perf/util/evsel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 21eaab2..6710cfe 100644
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
1.7.10.1

