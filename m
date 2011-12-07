Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab1LGPrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 10:47:43 -0500
Received: from casper.infradead.org ([85.118.1.10]:40966 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756152Ab1LGPrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 10:47:42 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/2] perf stat: Failure with "Operation not supported"
Date: Wed,  7 Dec 2011 13:47:28 -0200
Message-Id: <1323272849-15077-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.8.rc0.35.gee6df
In-Reply-To: <1323272849-15077-1-git-send-email-acme@infradead.org>
References: <1323272849-15077-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@samba.org>

perf stat is failing on PowerPC:

  Error: open_counter returned with 95 (Operation not supported). /bin/dmesg may provide additional information.

  Fatal: Not all events could be opened.

commit 370faf1dd046 (perf stat: Fail softly on unsupported events)
added a check for failure returning ENOENT, but the POWER backend
returns EOPNOTSUPP. It looks like alpha, blackfin and mips do the
same.

With the patch applied, things work as expected:

 Performance counter stats for '/bin/true':

          0.362176 task-clock                #    0.623 CPUs utilized
                 0 context-switches          #    0.000 M/sec
                 0 CPU-migrations            #    0.000 M/sec
                28 page-faults               #    0.077 M/sec
         1,677,020 cycles                    #    4.630 GHz
   <not supported> stalled-cycles-frontend
   <not supported> stalled-cycles-backend
           431,220 instructions              #    0.26  insns per cycle
           101,889 branches                  #  281.325 M/sec
             4,145 branch-misses             #    4.07% of all branches

       0.000581361 seconds time elapsed

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/20111202093833.5fef7226@kryten
Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 7d98676..955930e 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -463,7 +463,8 @@ static int run_perf_stat(int argc __used, const char **argv)
 
 	list_for_each_entry(counter, &evsel_list->entries, node) {
 		if (create_perf_stat_counter(counter, first) < 0) {
-			if (errno == EINVAL || errno == ENOSYS || errno == ENOENT) {
+			if (errno == EINVAL || errno == ENOSYS ||
+			    errno == ENOENT || errno == EOPNOTSUPP) {
 				if (verbose)
 					ui__warning("%s event is not supported by the kernel.\n",
 						    event_name(counter));
-- 
1.7.8.rc0.35.gee6df

