Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760291Ab2CNUBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 16:01:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49776 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758348Ab2CNUBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 16:01:10 -0400
Date: Wed, 14 Mar 2012 12:59:19 -0700
From: tip-bot for Anton Blanchard <anton@samba.org>
Message-ID: <tip-b832796caa1fda8516464a003c8c7cc547bc20c2@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        anton@samba.org, hpa@zytor.com, mingo@redhat.com,
        yanmin_zhang@linux.intel.com, peterz@infradead.org, emunson@mgebm.net,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        yanmin_zhang@linux.intel.com, emunson@mgebm.net, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20120307114249.44275ca3@kryten>
References: <20120307114249.44275ca3@kryten>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Incorrect use of snprintf results in SEGV
Git-Commit-ID: b832796caa1fda8516464a003c8c7cc547bc20c2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 14 Mar 2012 12:59:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b832796caa1fda8516464a003c8c7cc547bc20c2
Gitweb:     http://git.kernel.org/tip/b832796caa1fda8516464a003c8c7cc547bc20c2
Author:     Anton Blanchard <anton@samba.org>
AuthorDate: Wed, 7 Mar 2012 11:42:49 +1100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 14 Mar 2012 12:36:19 -0300

perf tools: Incorrect use of snprintf results in SEGV

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
 1 files changed, 3 insertions(+), 0 deletions(-)

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
 
