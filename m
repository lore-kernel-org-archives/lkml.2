Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056Ab0JNUMD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 16:12:03 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33707 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208Ab0JNUMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 16:12:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references:mime-version:content-type
         :content-transfer-encoding;
        b=H4k/2js9x+dJyvzKGavRSEXUc8hqFf9IXL1OzrUZvUXmi5nBud5Du7NbB3iuYfqqdv
         euZdMrjkhtB+YffYRyhaoweZNNu/ksXgmD6PTZZTY9mwGpV4wmnrJJsb1GADcqWcqwBb
         8qLDP9I6HGEItsXRcCOn4gfLWMh+pbOq1uGxA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@alien8.de>,
        Chase Douglas <chase.douglas@canonical.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/2] tracing: Fix function-graph build warning on 32-bit
Date: Thu, 14 Oct 2010 21:42:50 +0200
Message-Id: <1287085371-29177-2-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1287085371-29177-1-git-send-regression-fweisbec@gmail.com>
References: <1287085371-29177-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@alien8.de>

Fix

kernel/trace/trace_functions_graph.c: In function ‘trace_print_graph_duration’:
kernel/trace/trace_functions_graph.c:652: warning: comparison of distinct pointer types lacks a cast

when building 36-rc6 on a 32-bit due to the strict type check failing
in the min() macro.

Signed-off-by: Borislav Petkov <bp@alien8.de>
Cc: Chase Douglas <chase.douglas@canonical.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <20100929080823.GA13595@liondog.tnic>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/trace/trace_functions_graph.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 02c708a..ef49e93 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -665,8 +665,9 @@ trace_print_graph_duration(unsigned long long duration, struct trace_seq *s)
 
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
1.6.2.3

