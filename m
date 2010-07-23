Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759515Ab0GWMLp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 08:11:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:43085 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753600Ab0GWMLn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 08:11:43 -0400
Date: Fri, 23 Jul 2010 12:11:20 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org, efault@gmx.de,
        gleb@redhat.com, fweisbec@gmail.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, efault@gmx.de, peterz@infradead.org,
        gleb@redhat.com, fweisbec@gmail.com, tglx@linutronix.de
In-Reply-To: <20100722170541.GF17631@ghostprotocols.net>
References: <20100722170541.GF17631@ghostprotocols.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf annotate: Fix handling of goto labels that are valid hex numbers
Message-ID: <tip-70a7cb3b39994ff366ff100b46f9dc97b1510c0f@git.kernel.org>
Git-Commit-ID: 70a7cb3b39994ff366ff100b46f9dc97b1510c0f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 23 Jul 2010 12:11:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  70a7cb3b39994ff366ff100b46f9dc97b1510c0f
Gitweb:     http://git.kernel.org/tip/70a7cb3b39994ff366ff100b46f9dc97b1510c0f
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 22 Jul 2010 14:04:13 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 22 Jul 2010 14:04:13 -0300

perf annotate: Fix handling of goto labels that are valid hex numbers

When parsing the objdump disassembly output we can have goto labels that
are valid hex numbers and thus get confused with lines with machine
code.

Handle the common case of a label that has nothing after it and other
cases where there is just source code by validating the resulting "ip".

It is still possible that we find goto labels that are in the function
address range, but only if they are located before the real address we
should be OK.

A change in the objdump output to have a clear marker separating
addresses from the disassembly would come handy, but we would still have
to deal with older versions.

Reported-by: Gleb Natapov <gleb@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Gleb Natapov <gleb@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <20100722170541.GF17631@ghostprotocols.net>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 699cf81..784ee0b 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -976,13 +976,17 @@ static int hist_entry__parse_objdump_line(struct hist_entry *self, FILE *file,
 		 * Parse hexa addresses followed by ':'
 		 */
 		line_ip = strtoull(tmp, &tmp2, 16);
-		if (*tmp2 != ':' || tmp == tmp2)
+		if (*tmp2 != ':' || tmp == tmp2 || tmp2[1] == '\0')
 			line_ip = -1;
 	}
 
 	if (line_ip != -1) {
-		u64 start = map__rip_2objdump(self->ms.map, sym->start);
+		u64 start = map__rip_2objdump(self->ms.map, sym->start),
+		    end = map__rip_2objdump(self->ms.map, sym->end);
+
 		offset = line_ip - start;
+		if (offset < 0 || (u64)line_ip > end)
+			offset = -1;
 	}
 
 	objdump_line = objdump_line__new(offset, line);
