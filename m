Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777Ab2EHP3X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:29:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42063 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755460Ab2EHP3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:29:21 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, David Ahern <dsahern@gmail.com>
Subject: [PATCH 2/2] perf stat: handle ENXIO error for perf_event_open
Date: Tue,  8 May 2012 09:29:16 -0600
Message-Id: <1336490956-57145-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 tools/perf/builtin-stat.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index e720ba7..bd42189 100644
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
1.7.5.4

