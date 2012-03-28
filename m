Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab2C1Mgd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 08:36:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753601Ab2C1Mgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 08:36:32 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: eranian@google.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, rostedt@goodmis.org, robert.richter@amd.com,
        fche@redhat.com, linux-kernel@vger.kernel.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 01/15] perf, tool: Fix the array pointer to follow event data properly
Date: Wed, 28 Mar 2012 14:35:44 +0200
Message-Id: <1332938158-5244-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1332938158-5244-1-git-send-email-jolsa@redhat.com>
References: <1332938158-5244-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we dont update the 'array' pointer properly after
processing the RAW data. This way perf might report wrong data
for branch stack if it is used along with tracepoint sample.

I'm not sure tracepoint could be connected with branch stack,
but I think the array pointer should have correct value after
each sample processing.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/evsel.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index d9da62a..56a9689 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -580,6 +580,7 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 			return -EFAULT;
 
 		data->raw_data = (void *) pdata;
+		array = (u64 *)(((char *)array) + data->raw_size + sizeof(u32));
 	}
 
 	if (type & PERF_SAMPLE_BRANCH_STACK) {
-- 
1.7.1

