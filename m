Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756000Ab0FXVlI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 17:41:08 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58589 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931Ab0FXVlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 17:41:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=xS+/TemROMBLYSPW+r1znvVlYFTJxJM6VMWWnMg33bfQ9MHjwIATiaz3eu9NOUwTvA
         RfiALrO7FauKZiJgcXr9fX59XY+7b4zILrCVnuT7ydDXhFlmkmB71+3NW57HfOb244Dj
         bQ4p7xnpeQ+r/GXWB137+T8GSbBPY6U2keFSI=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Will Deacon <will.deacon@arm.com>, Prasad <prasad@linux.vnet.ibm.com>,
       Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 5/7] perf: Don't use 4 bytes as a default instruction breakpoint length
Date: Thu, 24 Jun 2010 23:40:56 +0200
Message-Id: <1277415658-10036-6-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1277415658-10036-1-git-send-regression-fweisbec@gmail.com>
References: <1277415658-10036-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

4 bytes is fine as a default access for data breakpoints. But
instruction breakpoints should take the native pointer length,
otherwise we get a -EINVAL in x86-64.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Jason Wessel <jason.wessel@windriver.com>
---
 tools/perf/util/parse-events.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 9bf0f40..4af5bd5 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -602,8 +602,15 @@ parse_breakpoint_event(const char **strp, struct perf_event_attr *attr)
 			return EVT_FAILED;
 	}
 
-	/* We should find a nice way to override the access type */
-	attr->bp_len = HW_BREAKPOINT_LEN_4;
+	/*
+	 * We should find a nice way to override the access length
+	 * Provide some defaults for now
+	 */
+	if (attr->bp_type == HW_BREAKPOINT_X)
+		attr->bp_len = sizeof(long);
+	else
+		attr->bp_len = HW_BREAKPOINT_LEN_4;
+
 	attr->type = PERF_TYPE_BREAKPOINT;
 
 	return EVT_HANDLED;
-- 
1.6.2.3

