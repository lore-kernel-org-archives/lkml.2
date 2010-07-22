Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757078Ab0GVUhW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 16:37:22 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36973 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756583Ab0GVUhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 16:37:06 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/2] perf annotate: Fix handling of goto labels that are valid hex numbers
Date: Thu, 22 Jul 2010 17:36:56 -0300
Message-Id: <1279831017-26967-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1279831017-26967-1-git-send-email-acme@infradead.org>
References: <1279831017-26967-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
-- 
1.6.2.5

