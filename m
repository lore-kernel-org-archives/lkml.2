Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755211Ab2IJWTU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 18:19:20 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:38584 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab2IJWTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 18:19:17 -0400
From: Irina Tirdea <irina.tirdea@gmail.com>
To: mingo@redhat.com, acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        rostedt@goodmis.org
Cc: paulus@samba.org, dsahern@gmail.com, namhyung.kim@lge.com,
        linux-kernel@vger.kernel.org, Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH v3 5/6] perf tools: fix no return in non-void function
Date: Tue, 11 Sep 2012 01:15:02 +0300
Message-Id: <1347315303-29906-6-git-send-email-irina.tirdea@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1347315303-29906-1-git-send-email-irina.tirdea@intel.com>
References: <1347315303-29906-1-git-send-email-irina.tirdea@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

thread_func in builtin-sched.c has an internal loop and never returns.
The only return from this thread are BUG_ON calls in case return values
are not 0.

The compiler on Android complains that the function needs to return a
non-void value. Adding the noreturn function attribute to fix this error.

Error in Android:
target C: perf <= builtin-sched.c
hardware/intel/linu/tools/perf/builtin-sched.c: In function 'thread_func':
hardware/intel/linux/tools/perf/builtin-sched.c:476: error: no return
statement in function returning non-void

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
---
 tools/perf/builtin-sched.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index a25a023..1fecc95 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -439,7 +439,7 @@ static u64 get_cpu_usage_nsec_self(int fd)
 	return runtime;
 }
 
-static void *thread_func(void *ctx)
+static __attribute__ ((noreturn)) void *thread_func(void *ctx)
 {
 	struct task_desc *this_task = ctx;
 	u64 cpu_usage_0, cpu_usage_1;
-- 
1.7.9.5

