Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934715Ab2JYIB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 04:01:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38345 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307Ab2JYIBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 04:01:54 -0400
Date: Thu, 25 Oct 2012 01:01:29 -0700
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-2305c82fb35dd2c8c9533303bb1693f1636c66e4@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, robert.richter@amd.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, robert.richter@amd.com, peterz@infradead.org,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1347569955-54626-4-git-send-email-dsahern@gmail.com>
References: <1347569955-54626-4-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Give user better message if precise is not supported
Git-Commit-ID: 2305c82fb35dd2c8c9533303bb1693f1636c66e4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 25 Oct 2012 01:01:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2305c82fb35dd2c8c9533303bb1693f1636c66e4
Gitweb:     http://git.kernel.org/tip/2305c82fb35dd2c8c9533303bb1693f1636c66e4
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Thu, 13 Sep 2012 14:59:15 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 24 Oct 2012 14:20:11 -0200

perf tools: Give user better message if precise is not supported

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
 2 files changed, 9 insertions(+), 0 deletions(-)

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
