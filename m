Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281Ab2ENM6g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 08:58:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56066 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755855Ab2ENM6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 08:58:34 -0400
Date: Mon, 14 May 2012 05:58:08 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-m91tv004h2m1fkfgu6ovx3hb@git.kernel.org>
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
  Use raw form for register indirect call instructions
Git-Commit-ID: e8ea1561952b04276cf4c02500e363de76c142aa
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 14 May 2012 05:58:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e8ea1561952b04276cf4c02500e363de76c142aa
Gitweb:     http://git.kernel.org/tip/e8ea1561952b04276cf4c02500e363de76c142aa
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 11 May 2012 12:28:55 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 11 May 2012 12:28:55 -0300

perf annotate: Use raw form for register indirect call instructions

   callq  *0x10(%rax)

was being rendered in simplified mode as:

   callq  *10

I.e. hexa, but without the 0x and omitting the register. In such cases
just use the raw form.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-m91tv004h2m1fkfgu6ovx3hb@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/annotate.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 6b4146b..9a020d1 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -56,6 +56,12 @@ static int call__parse(struct ins_operands *ops)
 	return ops->target.name == NULL ? -1 : 0;
 
 indirect_call:
+	tok = strchr(endptr, '(');
+	if (tok != NULL) {
+		ops->target.addr = 0;
+		return 0;
+	}
+
 	tok = strchr(endptr, '*');
 	if (tok == NULL)
 		return -1;
@@ -70,6 +76,9 @@ static int call__scnprintf(struct ins *ins, char *bf, size_t size,
 	if (ops->target.name)
 		return scnprintf(bf, size, "%-6.6s %s", ins->name, ops->target.name);
 
+	if (ops->target.addr == 0)
+		return ins__raw_scnprintf(ins, bf, size, ops);
+
 	return scnprintf(bf, size, "%-6.6s *%" PRIx64, ins->name, ops->target.addr);
 }
 
