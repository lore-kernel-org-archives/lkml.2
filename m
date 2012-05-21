Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642Ab2EUHl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 03:41:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37746 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab2EUHlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 03:41:55 -0400
Date: Mon, 21 May 2012 00:41:40 -0700
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-5e1c81d98a5621007824b49dde556fead5ff9c6c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1336968088-11531-1-git-send-email-dsahern@gmail.com>
References: <1336968088-11531-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf evsel:
  Create events initially disabled -- again
Git-Commit-ID: 5e1c81d98a5621007824b49dde556fead5ff9c6c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 21 May 2012 00:41:45 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5e1c81d98a5621007824b49dde556fead5ff9c6c
Gitweb:     http://git.kernel.org/tip/5e1c81d98a5621007824b49dde556fead5ff9c6c
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Sun, 13 May 2012 22:01:28 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 18 May 2012 16:02:42 -0300

perf evsel: Create events initially disabled -- again

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
 1 files changed, 1 insertions(+), 1 deletions(-)

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
