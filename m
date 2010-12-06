Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab0LFChi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 21:37:38 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:34389 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab0LFCh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 21:37:28 -0500
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Ian Munsie <imunsie@au1.ibm.com>
Subject: [PATCH 1/3] perf tool: Better displaying of unresolved DSOs and symbols
Date: Mon,  6 Dec 2010 13:37:04 +1100
Message-Id: <1291603026-11785-2-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <alpine.LFD.2.00.1012051220450.2653@localhost6.localdomain6>
References: <alpine.LFD.2.00.1012051220450.2653@localhost6.localdomain6>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

In the event that a DSO has not been identified, just print out
[unknown] instead of the instruction pointer as we previously were
doing, which is pretty meaningless for a shared object (at least to the
users perspective).

The IP we print out is fairly meaningless in general anyway - it's just
one (the first) of the many addresses that were lumped together as
unidentified, and could span many shared objects and symbols. In reality
if we see this [unknown] output then the report -D output is going to be
more useful anyway as we can see all the different address that it
represents.

If we are printing the symbols we are still going to see this IP in that
column anyway since they shouldn't resolve either.

This patch also changes the symbol address printouts so that they print
out 0x before the address, are left aligned, and changes the %L format
string (which relies on a glibc bug) to %ll.

Before:
    74.11%    :3259               4a6c  [k]     4a6c
After:
    74.11%    :3259  [unknown]          [k] 0x4a6c

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
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
1.7.2.3

