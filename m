Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761169Ab2CNQ7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 12:59:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:59647 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761107Ab2CNQ67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 12:58:59 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
        David Ahern <dsahern@gmail.com>, Eric B Munson <emunson@mgebm.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>, stable@kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/3] perf tools: Incorrect use of snprintf results in SEGV
Date: Wed, 14 Mar 2012 13:58:40 -0300
Message-Id: <1331744322-18917-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1331744322-18917-1-git-send-email-acme@infradead.org>
References: <1331744322-18917-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anton Blanchard <anton@samba.org>

I have a workload where perf top scribbles over the stack and we SEGV.
What makes it interesting is that an snprintf is causing this.

The workload is a c++ gem that has method names over 3000 characters
long, but snprintf is designed to avoid overrunning buffers. So what
went wrong?

The problem is we assume snprintf returns the number of characters
written:

    ret += repsep_snprintf(bf + ret, size - ret, "[%c] ", self->level);
...
    ret += repsep_snprintf(bf + ret, size - ret, "%s", self->ms.sym->name);

Unfortunately this is not how snprintf works. snprintf returns the
number of characters that would have been written if there was enough
space. In the above case, if the first snprintf returns a value larger
than size, we pass a negative size into the second snprintf and happily
scribble over the stack. If you have 3000 character c++ methods thats a
lot of stack to trample.

This patch fixes repsep_snprintf by clamping the value at size - 1 which
is the maximum snprintf can write before adding the NULL terminator.

I get the sinking feeling that there are a lot of other uses of snprintf
that have this same bug, we should audit them all.

Cc: David Ahern <dsahern@gmail.com>
Cc: Eric B Munson <emunson@mgebm.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Cc: stable@kernel.org
Link: http://lkml.kernel.org/r/20120307114249.44275ca3@kryten
Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 16da30d..076c9d4 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -33,6 +33,9 @@ static int repsep_snprintf(char *bf, size_t size, const char *fmt, ...)
 		}
 	}
 	va_end(ap);
+
+	if (n >= (int)size)
+		return size - 1;
 	return n;
 }
 
-- 
1.7.9.2.358.g22243

