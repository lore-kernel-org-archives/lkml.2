Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756241Ab2EHPMO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:12:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57042 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756132Ab2EHPMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:12:12 -0400
Date: Tue, 8 May 2012 08:11:54 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-qddbeglfzqdlal8vj2yaj67y@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, efault@gmx.de,
        namhyung@gmail.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, efault@gmx.de, peterz@infradead.org,
        namhyung@gmail.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate browser: Compact 'nop' output
Git-Commit-ID: b9818e93759c30c8942391f4f5fadaa36659ee33
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 08 May 2012 08:12:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b9818e93759c30c8942391f4f5fadaa36659ee33
Gitweb:     http://git.kernel.org/tip/b9818e93759c30c8942391f4f5fadaa36659ee33
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 7 May 2012 18:57:02 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 7 May 2012 19:00:42 -0300

perf annotate browser: Compact 'nop' output

Just suppress the nop operands, future infrastructure that will record
the instruction lenght (and its contents) in struct ins will allow
rendering them as nopN, i.e. nop5 for a 5-byte nop.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-qddbeglfzqdlal8vj2yaj67y@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 0905db4..6b4146b 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -113,6 +113,16 @@ bool ins__is_jump(const struct ins *ins)
 	return ins->ops == &jump_ops;
 }
 
+static int nop__scnprintf(struct ins *ins __used, char *bf, size_t size,
+			  struct ins_operands *ops __used)
+{
+	return scnprintf(bf, size, "%-6.6s", "nop");
+}
+
+static struct ins_ops nop_ops = {
+	.scnprintf = nop__scnprintf,
+};
+
 /*
  * Must be sorted by name!
  */
@@ -154,6 +164,9 @@ static struct ins instructions[] = {
 	{ .name = "jrcxz", .ops  = &jump_ops, },
 	{ .name = "js",	   .ops  = &jump_ops, },
 	{ .name = "jz",	   .ops  = &jump_ops, },
+	{ .name = "nop",   .ops  = &nop_ops, },
+	{ .name = "nopl",  .ops  = &nop_ops, },
+	{ .name = "nopw",  .ops  = &nop_ops, },
 };
 
 static int ins__cmp(const void *name, const void *insp)
