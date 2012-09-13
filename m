Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758873Ab2IMU7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 16:59:31 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48790 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754999Ab2IMU72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 16:59:28 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org,
        peterz@infradead.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Robert Richter <robert.richter@amd.com>
Subject: [PATCH 3/3 v2] perf tool: give user better message if precise is not supported
Date: Thu, 13 Sep 2012 14:59:15 -0600
Message-Id: <1347569955-54626-4-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1347569955-54626-1-git-send-email-dsahern@gmail.com>
References: <1347569955-54626-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Platforms (e.g., VM's) without support for precise mode get a confusing
error message. e.g.,
$ perf record -e cycles:p -a -- sleep 1

  Error: sys_perf_event_open() syscall returned with 95 (Operation not
  supported).  /bin/dmesg may provide additional information.

  No hardware sampling interrupt available. No APIC? If so then you can
  boot the kernel with the "lapic" boot parameter to force-enable it.
  sleep: Terminated

which is not clear that precise mode might be the root problem. With this
patch:

$ perf record -e cycles:p -fo /tmp/perf.data -- sleep 1
  Error:
  'precise' request may not be supported. Try removing 'p' modifier
  sleep: Terminated

v2: softened message to 'may not be' supported per Robert's suggestion

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>
---
 tools/perf/builtin-record.c |    5 +++++
 tools/perf/builtin-top.c    |    4 ++++
 2 files changed, 9 insertions(+)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index c643ed6..385e272 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -294,6 +294,11 @@ try_again:
 					  perf_evsel__name(pos));
 				rc = -err;
 				goto out;
+			} else if ((err == EOPNOTSUPP) && (attr->precise_ip)) {
+				ui__error("\'precise\' request may not be supported. "
+					  "Try removing 'p' modifier\n");
+				rc = -err;
+				goto out;
 			}
 
 			printf("\n");
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 5550754..1d1c98c 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -976,6 +976,10 @@ try_again:
 				ui__error("Too many events are opened.\n"
 					    "Try again after reducing the number of events\n");
 				goto out_err;
+			} else if ((err == EOPNOTSUPP) && (attr->precise_ip)) {
+				ui__error("\'precise\' request may not be supported. "
+					  "Try removing 'p' modifier\n");
+				goto out_err;
 			}
 
 			ui__error("The sys_perf_event_open() syscall "
-- 
1.7.10.1

