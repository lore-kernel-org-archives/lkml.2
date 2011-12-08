Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751219Ab1LHEes (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 23:34:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55112 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab1LHEer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 23:34:47 -0500
Date: Wed, 7 Dec 2011 20:34:10 -0800
From: tip-bot for Anton Blanchard <anton@samba.org>
Message-ID: <tip-38f6ae1e1b0d5e8b0a95f88c1eee2c5e8b001631@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        anton@samba.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, dsahern@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20111202093833.5fef7226@kryten>
References: <20111202093833.5fef7226@kryten>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf stat: Failure with "Operation not supported"
Git-Commit-ID: 38f6ae1e1b0d5e8b0a95f88c1eee2c5e8b001631
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 07 Dec 2011 20:34:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  38f6ae1e1b0d5e8b0a95f88c1eee2c5e8b001631
Gitweb:     http://git.kernel.org/tip/38f6ae1e1b0d5e8b0a95f88c1eee2c5e8b001631
Author:     Anton Blanchard <anton@samba.org>
AuthorDate: Fri, 2 Dec 2011 09:38:33 +1100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 5 Dec 2011 14:32:40 -0200

perf stat: Failure with "Operation not supported"

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

Cc: <stable@kernel.org> # 3.0+
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
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
