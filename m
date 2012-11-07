Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab2KGBa3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 20:30:29 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:42135 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619Ab2KGBa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 20:30:28 -0500
X-AuditID: 9c930179-b7c8bae000003559-83-5099b9b068e3
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, David Ahern <dsahern@gmail.com>,
        Irina Tirdea <irina.tirdea@gmail.com>
Subject: [PATCH] perf tools: Don't try to lookup objdump for live mode
Date: Wed,  7 Nov 2012 10:30:15 +0900
Message-Id: <1352251815-12615-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Arnaldo reported that annotation during perf top resulted in a
segfault.  It was because the env->arch was NULL and we don't set it
for a live session.  In fact, no need to look up objdump in this case
since we can use system's default (native) objdump.

Reported-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: David Ahern <dsahern@gmail.com>
Cc: Irina Tirdea <irina.tirdea@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/arch/common.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/perf/arch/common.c b/tools/perf/arch/common.c
index 5683529135b1..3e975cb6232e 100644
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
1.7.11.7

