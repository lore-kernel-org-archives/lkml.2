Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab1D3HQx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 03:16:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:53423 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575Ab1D3HQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 03:16:52 -0400
Date: Sat, 30 Apr 2011 07:16:24 GMT
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-c63ca0c01d73563d4e2ab174bb3dd1e5efb907e6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, dsahern@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1304114655-10600-1-git-send-email-dsahern@gmail.com>
References: <1304114655-10600-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/stat] perf stat: Tell user about unsupported events in the list
Git-Commit-ID: c63ca0c01d73563d4e2ab174bb3dd1e5efb907e6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 30 Apr 2011 07:16:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c63ca0c01d73563d4e2ab174bb3dd1e5efb907e6
Gitweb:     http://git.kernel.org/tip/c63ca0c01d73563d4e2ab174bb3dd1e5efb907e6
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Fri, 29 Apr 2011 16:04:15 -0600
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 30 Apr 2011 00:18:14 +0200

perf stat: Tell user about unsupported events in the list

Similar to perf-record, tell user about unsupported events
that will not be counted if invoked in verbose mode.

e.g.,

 $ perf stat -e dTLB-prefetch-misses -v -- sleep 1
 dTLB-prefetch-misses event is not supported by the kernel.
 dTLB-prefetch-misses: 0 0 0

 Performance counter stats for 'sleep 1':

     <not counted> dTLB-prefetch-misses

        1.001884783  seconds time elapsed

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1304114655-10600-1-git-send-email-dsahern@gmail.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-stat.c |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index c8b535b..602c3c9 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -377,8 +377,12 @@ static int run_perf_stat(int argc __used, const char **argv)
 
 	list_for_each_entry(counter, &evsel_list->entries, node) {
 		if (create_perf_stat_counter(counter) < 0) {
-			if (errno == EINVAL || errno == ENOSYS || errno == ENOENT)
+			if (errno == EINVAL || errno == ENOSYS || errno == ENOENT) {
+				if (verbose)
+					ui__warning("%s event is not supported by the kernel.\n",
+						    event_name(counter));
 				continue;
+			}
 
 			if (errno == EPERM || errno == EACCES) {
 				error("You may not have permission to collect %sstats.\n"
