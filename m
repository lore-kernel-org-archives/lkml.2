Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758278Ab2EJRUe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:20:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:60493 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757176Ab2EJRR6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:17:58 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 03/16] perf evlist: Fix creation of cpu map
Date: Thu, 10 May 2012 14:17:32 -0300
Message-Id: <1336670265-20401-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1336670265-20401-1-git-send-email-acme@infradead.org>
References: <1336670265-20401-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Currently, 'perf record -- sleep 1' creates a cpu map for all online
cpus since it turns out calling cpu_map__new(NULL). Fix it.

Also it is guaranteed that cpu_list is NULL if PID/TID is given by
calling perf_target__validate(), so we can make the conditional bit
simpler.

This also fixes perf test 7 (Validate) failure on my 6 core machine:

  $ cat /sys/devices/system/cpu/online
  0-11
  $ ./perf test -v 7
   7: Validate PERF_RECORD_* events & perf_sample fields:
  --- start ---
  perf_evlist__mmap: Operation not permitted
  ---- end ----
  Validate PERF_RECORD_* events & perf_sample fields: FAILED!

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1336367344-28071-3-git-send-email-namhyung.kim@lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 3032862..183b199 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -609,8 +609,9 @@ int perf_evlist__create_maps(struct perf_evlist *evlist,
 	if (evlist->threads == NULL)
 		return -1;
 
-	if (target->uid != UINT_MAX ||
-	    (target->cpu_list == NULL && target->tid))
+	if (target->uid != UINT_MAX || target->tid)
+		evlist->cpus = cpu_map__dummy_new();
+	else if (!target->system_wide && target->cpu_list == NULL)
 		evlist->cpus = cpu_map__dummy_new();
 	else
 		evlist->cpus = cpu_map__new(target->cpu_list);
-- 
1.7.9.2.358.g22243

