Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab0JMPWa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 11:22:30 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52168 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754027Ab0JMPW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 11:22:29 -0400
Date: Wed, 13 Oct 2010 17:21:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20101013152159.GA18858@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

 Thanks,

	Ingo

------------------>
Deng-Cheng Zhu (1):
      perf, MIPS: Support cross compiling of tools/perf for MIPS

John Blackwood (1):
      perf: Fix incorrect copy_from_user() usage

Steven Rostedt (1):
      ring-buffer: Fix typo of time extends per page


 kernel/perf_event.c        |    4 +---
 kernel/trace/ring_buffer.c |    2 +-
 tools/perf/perf.h          |   12 ++++++++++++
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index db5b560..b98bed3 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2202,15 +2202,13 @@ static void perf_event_for_each(struct perf_event *event,
 static int perf_event_period(struct perf_event *event, u64 __user *arg)
 {
 	struct perf_event_context *ctx = event->ctx;
-	unsigned long size;
 	int ret = 0;
 	u64 value;
 
 	if (!event->attr.sample_period)
 		return -EINVAL;
 
-	size = copy_from_user(&value, arg, sizeof(value));
-	if (size != sizeof(value))
+	if (copy_from_user(&value, arg, sizeof(value)))
 		return -EFAULT;
 
 	if (!value)
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 492197e..bca9637 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -405,7 +405,7 @@ static inline int test_time_stamp(u64 delta)
 #define BUF_MAX_DATA_SIZE (BUF_PAGE_SIZE - (sizeof(u32) * 2))
 
 /* Max number of timestamps that can fit on a page */
-#define RB_TIMESTAMPS_PER_PAGE	(BUF_PAGE_SIZE / RB_LEN_TIME_STAMP)
+#define RB_TIMESTAMPS_PER_PAGE	(BUF_PAGE_SIZE / RB_LEN_TIME_EXTEND)
 
 int ring_buffer_print_page_header(struct trace_seq *s)
 {
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index ef7aa0a..95aaf56 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -73,6 +73,18 @@ void get_term_dimensions(struct winsize *ws);
 #define cpu_relax()	asm volatile("":::"memory")
 #endif
 
+#ifdef __mips__
+#include "../../arch/mips/include/asm/unistd.h"
+#define rmb()		asm volatile(					\
+				".set	mips2\n\t"			\
+				"sync\n\t"				\
+				".set	mips0"				\
+				: /* no output */			\
+				: /* no input */			\
+				: "memory")
+#define cpu_relax()	asm volatile("" ::: "memory")
+#endif
+
 #include <time.h>
 #include <unistd.h>
 #include <sys/types.h>
