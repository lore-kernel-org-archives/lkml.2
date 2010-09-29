Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab0I2IIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 04:08:30 -0400
Received: from mail.skyhub.de ([78.46.96.112]:35567 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752114Ab0I2II2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 04:08:28 -0400
Date: Wed, 29 Sep 2010 10:08:23 +0200
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Chase Douglas <chase.douglas@canonical.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH -v1.2] trace/function-graph: Fix build warning on 32-bit
Message-ID: <20100929080823.GA13595@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Chase Douglas <chase.douglas@canonical.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	lkml <linux-kernel@vger.kernel.org>
References: <20100929073853.GA13264@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100929073853.GA13264@liondog.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Fix
> 
> kernel/trace/trace_functions_graph.c: In function ‘trace_print_graph_duration’:
> kernel/trace/trace_functions_graph.c:652: warning: comparison of distinct pointer types lacks a cast

sh*t, I got completely carried away with all that typechecking, take
this one instead:

--
From: Borislav Petkov <bp@alien8.de>
Date: Wed, 29 Sep 2010 08:39:43 +0200
Subject: [PATCH] trace/function-graph: Fix build warning on 32-bit
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Fix

kernel/trace/trace_functions_graph.c: In function ‘trace_print_graph_duration’:
kernel/trace/trace_functions_graph.c:652: warning: comparison of distinct pointer types lacks a cast

when building 36-rc6 on a 32-bit due to the strict type check failing in
the min() macro.

Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 kernel/trace/trace_functions_graph.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 6f23369..82306cc 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -649,8 +649,9 @@ trace_print_graph_duration(unsigned long long duration, struct trace_seq *s)
 
 	/* Print nsecs (we don't want to exceed 7 numbers) */
 	if (len < 7) {
-		snprintf(nsecs_str, min(sizeof(nsecs_str), 8UL - len), "%03lu",
-			 nsecs_rem);
+		size_t slen = min_t(size_t, sizeof(nsecs_str), 8UL - len);
+
+		snprintf(nsecs_str, slen, "%03lu", nsecs_rem);
 		ret = trace_seq_printf(s, ".%s", nsecs_str);
 		if (!ret)
 			return TRACE_TYPE_PARTIAL_LINE;
-- 
1.7.2.3

-- 
Regards/Gruss,
    Boris.
