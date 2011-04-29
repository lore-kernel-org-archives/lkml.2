Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761005Ab1D2WEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 18:04:23 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41619 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757844Ab1D2WEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 18:04:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=PbC7dAak4OLV7CB490zlyK45s9uLxVwUMgXtHq10l9fWzUrhpRP/SlsIbNwV4ohgWB
         p1mPNPbYf1TZ5K92+MVXbQdqi31oDkiltK4vt99OJ1BDjzzEVYh2tIq7U3aE/6jtcdsF
         PbEyXVb5hhPo63xk5oXnc+c5j/b3aLwG6J710=
From: David Ahern <dsahern@gmail.com>
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: acme@ghostprotocols.net, mingo@elte.hu, David Ahern <dsahern@gmail.com>
Subject: [PATCH] perf stat: tell user about unsupported events in the list
Date: Fri, 29 Apr 2011 16:04:15 -0600
Message-Id: <1304114655-10600-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Similar to perf-record, tell user about unsupported events
that will not be counted if invoked in verbose mode.

e.g.,
perf stat -e dTLB-prefetch-misses -v -- sleep 1
dTLB-prefetch-misses event is not supported by the kernel.
dTLB-prefetch-misses: 0 0 0

 Performance counter stats for 'sleep 1':

     <not counted> dTLB-prefetch-misses

        1.001884783  seconds time elapsed

Signed-off-by: David Ahern <dsahern@gmail.com>
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
-- 
1.7.4.4

