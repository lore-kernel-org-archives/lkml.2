Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156Ab2CVSdu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 14:33:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46317 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754277Ab2CVSdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 14:33:46 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/4] perf tools: Fix various casting issues for 32 bits
Date: Thu, 22 Mar 2012 15:33:01 -0300
Message-Id: <1332441183-9514-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1332441183-9514-1-git-send-email-acme@infradead.org>
References: <1332441183-9514-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

- util/parse-events.c(parse_events_add_breakpoint)
  need to use unsigned long instead of u64, otherwise
  we get following gcc error on 32 bits:
     error: cast from pointer to integer of different size

- util/header.c(print_event_desc)
  cannot retype to signed type, otherwise we get following
  gcc error on 32 bits:
     error: comparison between signed and unsigned integer expressions

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1332267341-26338-2-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c       |    2 +-
 tools/perf/util/parse-events.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index fcd9cf3..4c7c2d7 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1177,7 +1177,7 @@ static void print_event_desc(struct perf_header *ph, int fd, FILE *fp)
 		goto error;
 
 	msz = sizeof(attr);
-	if (sz < (ssize_t)msz)
+	if (sz < msz)
 		msz = sz;
 
 	for (i = 0 ; i < nre; i++) {
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 201b40f..f542a63 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -569,7 +569,7 @@ int parse_events_add_breakpoint(struct list_head *list, int *idx,
 	char name[MAX_NAME_LEN];
 
 	memset(&attr, 0, sizeof(attr));
-	attr.bp_addr = (u64) ptr;
+	attr.bp_addr = (unsigned long) ptr;
 
 	if (parse_breakpoint_type(type, &attr))
 		return -EINVAL;
-- 
1.7.9.2.358.g22243

