Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757782Ab2JXGDz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 02:03:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53260 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757739Ab2JXGDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 02:03:53 -0400
Date: Tue, 23 Oct 2012 23:02:30 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-g1fmodl6ys4lq8honbj1igoi@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf trace:
  Check if sample raw_data field is set
Git-Commit-ID: fc551f8d4427150da1ee7cbb0f53525c49ef4bca
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 23 Oct 2012 23:02:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fc551f8d4427150da1ee7cbb0f53525c49ef4bca
Gitweb:     http://git.kernel.org/tip/fc551f8d4427150da1ee7cbb0f53525c49ef4bca
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Sat, 20 Oct 2012 13:08:46 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sun, 21 Oct 2012 23:07:36 -0200

perf trace: Check if sample raw_data field is set

Sometimes we're segfaulting because we were expecting that the
perf_sample.raw_data field was set as requested, but in some cases
that needs further investigation, that field can be NULL, leading
to segfaults.

Make the tool more robust by checking that before calling any per event
handlers that may try to use that field.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-g1fmodl6ys4lq8honbj1igoi@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 83c6515..7aaee39 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -268,6 +268,13 @@ again:
 			if (evlist->threads->map[0] == -1 || evlist->threads->nr > 1)
 				printf("%d ", sample.tid);
 
+			if (sample.raw_data == NULL) {
+				printf("%s sample with no payload for tid: %d, cpu %d, raw_size=%d, skipping...\n",
+				       perf_evsel__name(evsel), sample.tid,
+				       sample.cpu, sample.raw_size);
+				continue;
+			}
+
 			handler = evsel->handler.func;
 			handler(trace, evsel, &sample);
 		}
