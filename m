Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab0I2Hi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 03:38:59 -0400
Received: from mail.skyhub.de ([78.46.96.112]:58641 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995Ab0I2Hi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 03:38:57 -0400
Date: Wed, 29 Sep 2010 09:38:53 +0200
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Chase Douglas <chase.douglas@canonical.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] trace/function-graph: Fix build warning on 32-bit
Message-ID: <20100929073853.GA13264@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Steven Rostedt <rostedt@goodmis.org>,
	Chase Douglas <chase.douglas@canonical.com>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix

kernel/trace/trace_functions_graph.c: In function ‘trace_print_graph_duration’:
kernel/trace/trace_functions_graph.c:652: warning: comparison of distinct pointer types lacks a cast

when building 36-rc6 on a 32-bit due to the strict type check failing in
the min() macro.

Signed-off-by: Borislav Petkov <bp@alien8.de>
---
 kernel/trace/trace_functions_graph.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 6f23369..4eab958 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -649,8 +649,10 @@ trace_print_graph_duration(unsigned long long duration, struct trace_seq *s)
 
 	/* Print nsecs (we don't want to exceed 7 numbers) */
 	if (len < 7) {
-		snprintf(nsecs_str, min(sizeof(nsecs_str), 8UL - len), "%03lu",
-			 nsecs_rem);
+		unsigned long slen = min_t(unsigned long, sizeof(nsecs_str),
+							  8UL - len);
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
