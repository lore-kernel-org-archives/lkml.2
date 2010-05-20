Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab0ETJof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 05:44:35 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:33374 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169Ab0ETJoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 05:44:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version
         :in-reply-to:references;
        b=fp7MnOS5HJdrkivhH9L9P0h79fD0Hixxb3WsSWVdQ547e5KjmFqERVQA/4bOaPi3s9
         MArlfamP/IfbBcfYIkuoVJ2AOoUGNryvbimuKorTTEWGYgIpQzwhyNbMRJA+QI84Qaw/
         5k1OToOWHqI2Wy8EwagcC11dAl9ZZ7xVqBKTk=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Steven Rostedt <rostedt@goodmis.org>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       David Miller <davem@davemloft.net>
Subject: [PATCH 3/3] perf: Fix unaligned accesses while fetching trace values
Date: Thu, 20 May 2010 11:44:19 +0200
Message-Id: <1274348659-15417-4-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
In-Reply-To: <1274348659-15417-1-git-send-regression-fweisbec@gmail.com>
References: <1274348659-15417-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Accessing trace values of an 8 size may end up in a segfault
on archs that can't deal with misaligned access, which is the
case for sparc 64. This is because PERF_SAMPLE_RAW are aligned
to 4 and not to 8.

Fix this on the macros that get the values of 8 size.

This fixes segfaults on perf tools in sparc 64.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Tom Zanussi <tzanussi@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
Cc: David Miller <davem@davemloft.net>
---
 tools/perf/util/trace-event.h |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index 406d452..b3e86b1 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -233,7 +233,12 @@ static inline unsigned long long __data2host8(unsigned long long data)
 
 #define data2host2(ptr)		__data2host2(*(unsigned short *)ptr)
 #define data2host4(ptr)		__data2host4(*(unsigned int *)ptr)
-#define data2host8(ptr)		__data2host8(*(unsigned long long *)ptr)
+#define data2host8(ptr)		({				\
+	unsigned long long __val;				\
+								\
+	memcpy(&__val, (ptr), sizeof(unsigned long long));	\
+	__data2host8(__val);					\
+})
 
 extern int header_page_ts_offset;
 extern int header_page_ts_size;
-- 
1.6.2.3

