Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab0LFUd7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 15:33:59 -0500
Received: from canuck.infradead.org ([134.117.69.58]:57346 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab0LFUdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 15:33:54 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Ian Munsie <imunsie@au1.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/5] perf hist: Better displaying of unresolved DSOs and symbols
Date: Mon,  6 Dec 2010 18:28:14 -0200
Message-Id: <1291667298-7238-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1291667298-7238-1-git-send-email-acme@infradead.org>
References: <1291667298-7238-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

In the event that a DSO has not been identified, just print out [unknown]
instead of the instruction pointer as we previously were doing, which is pretty
meaningless for a shared object (at least to the users perspective).

The IP we print out is fairly meaningless in general anyway - it's just one
(the first) of the many addresses that were lumped together as unidentified,
and could span many shared objects and symbols. In reality if we see this
[unknown] output then the report -D output is going to be more useful anyway as
we can see all the different address that it represents.

If we are printing the symbols we are still going to see this IP in that column
anyway since they shouldn't resolve either.

This patch also changes the symbol address printouts so that they print out 0x
before the address, are left aligned, and changes the %L format string (which
relies on a glibc bug) to %ll.

Before:
    74.11%    :3259               4a6c  [k]     4a6c
After:
    74.11%    :3259  [unknown]          [k] 0x4a6c

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <1291603026-11785-2-git-send-email-imunsie@au1.ibm.com>
Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/sort.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index b62a553..f44fa54 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -170,7 +170,7 @@ static int hist_entry__dso_snprintf(struct hist_entry *self, char *bf,
 		return repsep_snprintf(bf, size, "%-*s", width, dso_name);
 	}
 
-	return repsep_snprintf(bf, size, "%*Lx", width, self->ip);
+	return repsep_snprintf(bf, size, "%-*s", width, "[unknown]");
 }
 
 /* --sort symbol */
@@ -196,7 +196,7 @@ static int hist_entry__sym_snprintf(struct hist_entry *self, char *bf,
 
 	if (verbose) {
 		char o = self->ms.map ? dso__symtab_origin(self->ms.map->dso) : '!';
-		ret += repsep_snprintf(bf, size, "%*Lx %c ",
+		ret += repsep_snprintf(bf, size, "%-#*llx %c ",
 				       BITS_PER_LONG / 4, self->ip, o);
 	}
 
@@ -205,7 +205,7 @@ static int hist_entry__sym_snprintf(struct hist_entry *self, char *bf,
 		ret += repsep_snprintf(bf + ret, size - ret, "%s",
 				       self->ms.sym->name);
 	else
-		ret += repsep_snprintf(bf + ret, size - ret, "%*Lx",
+		ret += repsep_snprintf(bf + ret, size - ret, "%-#*llx",
 				       BITS_PER_LONG / 4, self->ip);
 
 	return ret;
-- 
1.6.2.5

