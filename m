Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161323Ab2JXVul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 17:50:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:40910 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161298Ab2JXVuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 17:50:39 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 05/12] perf tools: Give user better message if precise is not supported
Date: Wed, 24 Oct 2012 19:50:16 -0200
Message-Id: <1351115423-9025-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1351115423-9025-1-git-send-email-acme@infradead.org>
References: <1351115423-9025-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

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
Link: http://lkml.kernel.org/r/1347569955-54626-4-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    5 +++++
 tools/perf/builtin-top.c    |    4 ++++
 2 files changed, 9 insertions(+)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 73b5d7f..53c9892 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -317,6 +317,11 @@ try_again:
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
index fb9da71..f2ecd49 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -977,6 +977,10 @@ try_again:
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
1.7.9.2.358.g22243

