Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668Ab2CWIah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 04:30:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45787 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab2CWIac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 04:30:32 -0400
Date: Fri, 23 Mar 2012 01:29:44 -0700
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-9fafd98f1bf14276f95b69f0186ad5675f1e1a18@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1332267341-26338-2-git-send-email-jolsa@redhat.com>
References: <1332267341-26338-2-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Fix various casting issues for 32 bits
Git-Commit-ID: 9fafd98f1bf14276f95b69f0186ad5675f1e1a18
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 23 Mar 2012 01:29:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9fafd98f1bf14276f95b69f0186ad5675f1e1a18
Gitweb:     http://git.kernel.org/tip/9fafd98f1bf14276f95b69f0186ad5675f1e1a18
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 20 Mar 2012 19:15:39 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 22 Mar 2012 15:11:18 -0300

perf tools: Fix various casting issues for 32 bits

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
