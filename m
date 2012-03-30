Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934597Ab2C3QKX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 12:10:23 -0400
Received: from casper.infradead.org ([85.118.1.10]:49269 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759684Ab2C3QJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 12:09:42 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/9] perf tools: Fix bug in raw sample parsing
Date: Fri, 30 Mar 2012 13:09:17 -0300
Message-Id: <1333123764-15662-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1333123764-15662-1-git-send-email-acme@infradead.org>
References: <1333123764-15662-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

In perf_event__parse_sample(), the array variable was not incremented
by the amount of data used by the raw_data.

That was okay until we added PERF_SAMPLE_BRANCH_STACK which depends on
the array variable pointing to the beginning of the branch stack data.

But that was not the case if branch stack was combined with raw mode
sampling. That led to bogus branch stack addresses and count.

The bug would show up with:
$ perf record -R -b foo

This patch fixes the problem by correctly moving the array pointer
forward for RAW samples.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/20120317222317.GA8803@quad
[ committer note: Fix also later submitted by Jiri Olsa ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index d9da62a..8c13dbc 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -580,6 +580,8 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 			return -EFAULT;
 
 		data->raw_data = (void *) pdata;
+
+		array = (void *)array + data->raw_size + sizeof(u32);
 	}
 
 	if (type & PERF_SAMPLE_BRANCH_STACK) {
-- 
1.7.9.2.358.g22243

