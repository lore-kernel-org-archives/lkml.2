Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318Ab2FORKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 13:10:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55158 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab2FORKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 13:10:41 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>,
        Shuah Khan <shuahkhan@gmail.com>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 1/6] tracing: Fix initialization failure path in tracing_set_tracer()
Date: Fri, 15 Jun 2012 10:08:26 -0700
Message-Id: <1339780111-12075-1-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20120615170659.GA4060@lizard>
References: <20120615170659.GA4060@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If tracer->init() fails, current code will leave current_tracer pointing
to an unusable tracer, which at best makes 'current_tracer' report
inaccurate value.

Fix the issue by pointing current_tracer to nop tracer, and only update
current_tracer with the new one after all the initialization succeeds.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 kernel/trace/trace.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index a7fa070..7647d33 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3172,10 +3172,10 @@ static int tracing_set_tracer(const char *buf)
 	}
 	destroy_trace_option_files(topts);
 
-	current_trace = t;
+	current_trace = &nop_trace;
 
-	topts = create_trace_option_files(current_trace);
-	if (current_trace->use_max_tr) {
+	topts = create_trace_option_files(t);
+	if (t->use_max_tr) {
 		int cpu;
 		/* we need to make per cpu buffer sizes equivalent */
 		for_each_tracing_cpu(cpu) {
@@ -3195,6 +3195,7 @@ static int tracing_set_tracer(const char *buf)
 			goto out;
 	}
 
+	current_trace = t;
 	trace_branch_enable(tr);
  out:
 	mutex_unlock(&trace_types_lock);
-- 
1.7.10.4

