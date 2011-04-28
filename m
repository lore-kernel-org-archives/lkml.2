Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab1D1G4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 02:56:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:55664 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752623Ab1D1G4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 02:56:32 -0400
Date: Thu, 28 Apr 2011 06:55:54 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Message-ID: <tip-7y40wib8n1eqio5hjpn3dsrm@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/stat] perf stat: Fix compatibility behavior
Git-Commit-ID: ede70290046043b2638204cab55e26ea1d0c6cd9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 28 Apr 2011 06:55:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ede70290046043b2638204cab55e26ea1d0c6cd9
Gitweb:     http://git.kernel.org/tip/ede70290046043b2638204cab55e26ea1d0c6cd9
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Thu, 28 Apr 2011 08:48:42 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 28 Apr 2011 08:48:42 +0200

perf stat: Fix compatibility behavior

Instead of failing on an unknown event, when new perf stat is run on
older kernels:

  $ ./perf stat true
  Error: open_counter returned with 22 (Invalid argument). /bin/dmesg
  may provide additional information.

  Fatal: Not all events could be opened.

Just ignore EINVAL and ENOSYS, we'll print the results as not counted:

 Performance counter stats for 'true':

          0.239483 task-clock               #    0.493 CPUs utilized
                 0 context-switches         #    0.000 M/sec
                 0 CPU-migrations           #    0.000 M/sec
                86 page-faults              #    0.359 M/sec
           704,766 cycles                   #    2.943 GHz
     <not counted> stalled-cycles
           381,961 instructions             #    0.54  insns per cycle
            69,626 branches                 #  290.735 M/sec
             4,594 branch-misses            #    6.60% of all branches

        0.000485883  seconds time elapsed

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/n/tip-7y40wib8n1eqio5hjpn3dsrm@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-stat.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 5658a77..da77077 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -372,7 +372,10 @@ static int run_perf_stat(int argc __used, const char **argv)
 
 	list_for_each_entry(counter, &evsel_list->entries, node) {
 		if (create_perf_stat_counter(counter) < 0) {
-			if (errno == -EPERM || errno == -EACCES) {
+			if (errno == EINVAL || errno == ENOSYS)
+				continue;
+
+			if (errno == EPERM || errno == EACCES) {
 				error("You may not have permission to collect %sstats.\n"
 				      "\t Consider tweaking"
 				      " /proc/sys/kernel/perf_event_paranoid or running as root.",
