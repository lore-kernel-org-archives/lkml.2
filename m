Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176Ab0FAMRt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 08:17:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60826 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756144Ab0FAMRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 08:17:44 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Konstantin Stepanyuk <kostyas@cqg.com>,
       "David S. Miller" <davem@davemloft.net>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>,
       Konstantin Stepanyuk <konstantin.stepanyuk@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/2] perf hist: fix objdump output parsing
Date: Tue,  1 Jun 2010 09:17:27 -0300
Message-Id: <1275394648-13234-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1275394648-13234-1-git-send-email-acme@infradead.org>
References: <1275394648-13234-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Konstantin Stepanyuk <kostyas@cqg.com>

hist_entry__annotate() runs objdump with -S option so the output may contain
lines of any format. If a line starts with a colon strtoull() returns 0 and
calculated offset will be negative. This causes perf annotate segfaults.

Make sure that strtoull() has parsed at least one digit.

Cc: David S. Miller <davem@davemloft.net>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Konstantin Stepanyuk <konstantin.stepanyuk@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index cbf7eae..07f89b6 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -965,7 +965,7 @@ static int hist_entry__parse_objdump_line(struct hist_entry *self, FILE *file,
 		 * Parse hexa addresses followed by ':'
 		 */
 		line_ip = strtoull(tmp, &tmp2, 16);
-		if (*tmp2 != ':')
+		if (*tmp2 != ':' || tmp == tmp2)
 			line_ip = -1;
 	}
 
-- 
1.6.2.5

