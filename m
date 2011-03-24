Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933299Ab1CXJCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 05:02:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:38304 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932438Ab1CXJCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 05:02:10 -0400
Date: Thu, 24 Mar 2011 09:01:32 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        dave.martin@linaro.org, acme@redhat.com, hpa@zytor.com,
        mingo@redhat.com, tzanussi@gmail.com, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, srikar@linux.vnet.ibm.com,
        tglx@linutronix.de, asharma@fb.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        dave.martin@linaro.org, paulus@samba.org, eranian@google.com,
        linux-kernel@vger.kernel.org, tzanussi@gmail.com, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, srikar@linux.vnet.ibm.com,
        tglx@linutronix.de, mingo@elte.hu, asharma@fb.com
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf symbols: Look at .dynsym again if .symtab not found
Message-ID: <tip-60e4b10c5a27182bc8ce7435050a17cb61c94d00@git.kernel.org>
Git-Commit-ID: 60e4b10c5a27182bc8ce7435050a17cb61c94d00
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 24 Mar 2011 09:01:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  60e4b10c5a27182bc8ce7435050a17cb61c94d00
Gitweb:     http://git.kernel.org/tip/60e4b10c5a27182bc8ce7435050a17cb61c94d00
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 22 Mar 2011 15:42:14 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 23 Mar 2011 19:29:46 -0300

perf symbols: Look at .dynsym again if .symtab not found

The original intent of the code was to repeat the search with
want_symtab = 0. But as the code stands now, we never hit the "default"
case of the switch statement. Which means we never repeat the search.

Tested-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Reported-by: Arun Sharma <asharma@fb.com>
Reported-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Dave Martin <dave.martin@linaro.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |   25 +++++++++++++------------
 1 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 651dbfe..17df793 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1486,7 +1486,9 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 	 * On the first pass, only load images if they have a full symtab.
 	 * Failing that, do a second pass where we accept .dynsym also
 	 */
-	for (self->symtab_type = SYMTAB__BUILD_ID_CACHE, want_symtab = 1;
+	want_symtab = 1;
+restart:
+	for (self->symtab_type = SYMTAB__BUILD_ID_CACHE;
 	     self->symtab_type != SYMTAB__NOT_FOUND;
 	     self->symtab_type++) {
 		switch (self->symtab_type) {
@@ -1536,17 +1538,7 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 			snprintf(name, size, "%s%s", symbol_conf.symfs,
 				 self->long_name);
 			break;
-
-		default:
-			/*
-			 * If we wanted a full symtab but no image had one,
-			 * relax our requirements and repeat the search.
-			 */
-			if (want_symtab) {
-				want_symtab = 0;
-				self->symtab_type = SYMTAB__BUILD_ID_CACHE;
-			} else
-				continue;
+		default:;
 		}
 
 		/* Name is now the name of the next image to try */
@@ -1573,6 +1565,15 @@ int dso__load(struct dso *self, struct map *map, symbol_filter_t filter)
 		}
 	}
 
+	/*
+	 * If we wanted a full symtab but no image had one,
+	 * relax our requirements and repeat the search.
+	 */
+	if (ret <= 0 && want_symtab) {
+		want_symtab = 0;
+		goto restart;
+	}
+
 	free(name);
 	if (ret < 0 && strstr(self->name, " (deleted)") != NULL)
 		return 0;
