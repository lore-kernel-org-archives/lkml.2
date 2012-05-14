Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368Ab2ENNAJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 09:00:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56111 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064Ab2ENNAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 09:00:07 -0400
Date: Mon, 14 May 2012 05:59:48 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-jvh0jspefr5jyn0l7qko12st@git.kernel.org>
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
Subject: [tip:perf/core] perf annotate:
  Resolve symbols using objdump comment for single op ins
Git-Commit-ID: a43712c4720c8df4bad7d3760c67086168553b05
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 14 May 2012 05:59:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a43712c4720c8df4bad7d3760c67086168553b05
Gitweb:     http://git.kernel.org/tip/a43712c4720c8df4bad7d3760c67086168553b05
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 11 May 2012 17:21:09 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 11 May 2012 17:21:09 -0300

perf annotate: Resolve symbols using objdump comment for single op ins

Starting with inc, incl, dec, decl.

Requested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-jvh0jspefr5jyn0l7qko12st@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c |   45 ++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 45 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 82c7f63..a6109dc 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -205,6 +205,47 @@ static struct ins_ops mov_ops = {
 	.scnprintf = mov__scnprintf,
 };
 
+static int dec__parse(struct ins_operands *ops)
+{
+	char *target, *comment, *s, prev;
+
+	target = s = ops->raw;
+
+	while (s[0] != '\0' && !isspace(s[0]))
+		++s;
+	prev = *s;
+	*s = '\0';
+
+	ops->target.raw = strdup(target);
+	*s = prev;
+
+	if (ops->target.raw == NULL)
+		return -1;
+
+	comment = strchr(s, '#');
+	if (comment == NULL)
+		return 0;
+
+	while (comment[0] != '\0' && isspace(comment[0]))
+		++comment;
+
+	comment__symbol(ops->target.raw, comment, &ops->target.addr, &ops->target.name);
+
+	return 0;
+}
+
+static int dec__scnprintf(struct ins *ins, char *bf, size_t size,
+			   struct ins_operands *ops)
+{
+	return scnprintf(bf, size, "%-6.6s %s", ins->name,
+			 ops->target.name ?: ops->target.raw);
+}
+
+static struct ins_ops dec_ops = {
+	.parse	   = dec__parse,
+	.scnprintf = dec__scnprintf,
+};
+
 static int nop__scnprintf(struct ins *ins __used, char *bf, size_t size,
 			  struct ins_operands *ops __used)
 {
@@ -232,7 +273,11 @@ static struct ins instructions[] = {
 	{ .name = "cmpq",  .ops  = &mov_ops, },
 	{ .name = "cmpw",  .ops  = &mov_ops, },
 	{ .name = "cmpxch", .ops  = &mov_ops, },
+	{ .name = "dec",   .ops  = &dec_ops, },
+	{ .name = "decl",  .ops  = &dec_ops, },
 	{ .name = "imul",  .ops  = &mov_ops, },
+	{ .name = "inc",   .ops  = &dec_ops, },
+	{ .name = "incl",  .ops  = &dec_ops, },
 	{ .name = "ja",	   .ops  = &jump_ops, },
 	{ .name = "jae",   .ops  = &jump_ops, },
 	{ .name = "jb",	   .ops  = &jump_ops, },
