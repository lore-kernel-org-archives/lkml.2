Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032Ab2CTSQm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 14:16:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13329 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754923Ab2CTSQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 14:16:39 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 1/3] perf, tool: Fix various casting issues for 32 bits
Date: Tue, 20 Mar 2012 19:15:39 +0100
Message-Id: <1332267341-26338-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1332267341-26338-1-git-send-email-jolsa@redhat.com>
References: <1332267341-26338-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- util/parse-events.c(parse_events_add_breakpoint)
  need to use unsigned long instead of u64, otherwise
  we get following gcc error on 32 bits:
     error: cast from pointer to integer of different size

- util/header.c(print_event_desc)
  cannot retype to signed type, otherwise we get following
  gcc error on 32 bits:
     error: comparison between signed and unsigned integer expressions

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
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
1.7.7.6

