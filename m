Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751662Ab1AISVR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 13:21:17 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:30745 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab1AISVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 13:21:15 -0500
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
From: David Ahern <daahern@cisco.com>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
        acme@ghostprotocols.net
Cc: linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        David Ahern <daahern@cisco.com>
Subject: [PATCH] perf stat: better error message for unsupported events
Date: Sun,  9 Jan 2011 11:21:12 -0700
Message-Id: <1294597272-17335-1-git-send-email-daahern@cisco.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For unsupported events (e.g., H/W events when running in a VM)
perf stat currently fails with the error message:

      Error: open_counter returned with 2 (No such file or directory).
    /bin/dmesg may provide additional information.

      Fatal: Not all events could be opened.

dmesg is of no help and it is not clear as to why it fails to
open the counter. This patch changes the error message to

      Error: cache-misses event is not supported.
      Fatal: Not all events could be opened.

Signed-off-by: David Ahern <daahern@cisco.com>
---
 tools/perf/builtin-stat.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 42dfeec..a1e3a04 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -316,6 +316,8 @@ static int run_perf_stat(int argc __used, const char **argv)
 				      "\t Consider tweaking"
 				      " /proc/sys/kernel/perf_event_paranoid or running as root.",
 				      system_wide ? "system-wide " : "");
+			} else if (errno == ENOENT) {
+				error("%s event is not supported. ", event_name(counter));
 			} else {
 				error("open_counter returned with %d (%s). "
 				      "/bin/dmesg may provide additional information.\n",
-- 
1.7.3.4

