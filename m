Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab2KIVnd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 16:43:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:38566 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122Ab2KIVnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 16:43:25 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Irina Tirdea <irina.tirdea@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/21] perf tools: Don't try to lookup objdump for live mode
Date: Fri,  9 Nov 2012 18:42:56 -0300
Message-Id: <1352497390-17716-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1352497390-17716-1-git-send-email-acme@infradead.org>
References: <1352497390-17716-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Arnaldo reported that annotation during perf top resulted in a segfault.
It was because the env->arch was NULL and we don't set it for a live
session.  In fact, no need to look up objdump in this case since we can
use system's default (native) objdump.

Reported-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Irina Tirdea <irina.tirdea@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1352251815-12615-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/arch/common.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/perf/arch/common.c b/tools/perf/arch/common.c
index 5683529..3e975cb 100644
--- a/tools/perf/arch/common.c
+++ b/tools/perf/arch/common.c
@@ -199,6 +199,13 @@ out_error:
 
 int perf_session_env__lookup_objdump(struct perf_session_env *env)
 {
+	/*
+	 * For live mode, env->arch will be NULL and we can use
+	 * the native objdump tool.
+	 */
+	if (env->arch == NULL)
+		return 0;
+
 	return perf_session_env__lookup_binutils_path(env, "objdump",
 						      &objdump_path);
 }
-- 
1.7.9.2.358.g22243

