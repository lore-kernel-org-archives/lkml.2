Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab0LGG4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 01:56:49 -0500
Received: from hera.kernel.org ([140.211.167.34]:53449 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120Ab0LGG4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 01:56:48 -0500
Date: Tue, 7 Dec 2010 06:56:30 GMT
From: tip-bot for Ian Munsie <imunsie@au1.ibm.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, imunsie@au1.ibm.com,
        fweisbec@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        fweisbec@gmail.com, a.p.zijlstra@chello.nl, efault@gmx.de,
        tglx@linutronix.de, imunsie@au1.ibm.com
In-Reply-To: <1291603026-11785-2-git-send-email-imunsie@au1.ibm.com>
References: <1291603026-11785-2-git-send-email-imunsie@au1.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hist: Better displaying of unresolved DSOs and symbols
Message-ID: <tip-1437a30aae865d83c7d96e3401f503a73fffe14d@git.kernel.org>
Git-Commit-ID: 1437a30aae865d83c7d96e3401f503a73fffe14d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 07 Dec 2010 06:56:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1437a30aae865d83c7d96e3401f503a73fffe14d
Gitweb:     http://git.kernel.org/tip/1437a30aae865d83c7d96e3401f503a73fffe14d
Author:     Ian Munsie <imunsie@au1.ibm.com>
AuthorDate: Mon, 6 Dec 2010 13:37:04 +1100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 6 Dec 2010 15:12:34 -0200

perf hist: Better displaying of unresolved DSOs and symbols

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
