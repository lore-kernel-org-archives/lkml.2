Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759974Ab2EJRVn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:21:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:60482 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756806Ab2EJRRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:17:55 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 12/16] perf stat: handle ENXIO error for perf_event_open
Date: Thu, 10 May 2012 14:17:41 -0300
Message-Id: <1336670265-20401-13-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1336670265-20401-1-git-send-email-acme@infradead.org>
References: <1336670265-20401-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

perf stat on PPC currently fails to run:

$ perf stat -- sleep 1
  Error: open_counter returned with 6 (No such device or address). /bin/dmesg may provide additional information.

  Fatal: Not all events could be opened.

The problem is that until 2.6.37 (behavior changed with commit b0a873e)
perf on PPC returns ENXIO when hw_perf_event_init() fails. With this
patch we get the expected behavior:

$ perf stat -v -- sleep 1
cycles event is not supported by the kernel.
stalled-cycles-frontend event is not supported by the kernel.
stalled-cycles-backend event is not supported by the kernel.
instructions event is not supported by the kernel.
branches event is not supported by the kernel.
branch-misses event is not supported by the kernel.

...

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1336490956-57145-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index e720ba7..d060568 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -462,8 +462,13 @@ static int run_perf_stat(int argc __used, const char **argv)
 
 	list_for_each_entry(counter, &evsel_list->entries, node) {
 		if (create_perf_stat_counter(counter, first) < 0) {
+			/*
+			 * PPC returns ENXIO for HW counters until 2.6.37
+			 * (behavior changed with commit b0a873e).
+			 */
 			if (errno == EINVAL || errno == ENOSYS ||
-			    errno == ENOENT || errno == EOPNOTSUPP) {
+			    errno == ENOENT || errno == EOPNOTSUPP ||
+			    errno == ENXIO) {
 				if (verbose)
 					ui__warning("%s event is not supported by the kernel.\n",
 						    event_name(counter));
-- 
1.7.9.2.358.g22243

