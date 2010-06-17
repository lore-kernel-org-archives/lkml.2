Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933346Ab0FQUkN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 16:40:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49307 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab0FQUkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 16:40:11 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Andy Isaacson <adi@hexapodia.org>,
       Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6/7] perf debug: fix hex dump partial final line
Date: Thu, 17 Jun 2010 17:40:03 -0300
Message-Id: <1276807204-22512-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1276807204-22512-1-git-send-email-acme@infradead.org>
References: <1276807204-22512-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Isaacson <adi@hexapodia.org>

The loop counter math in trace_event was much more complicated than
necessary, resulting in incorrectly decoding the human-readable
portion of the partial last line of hexdump in "perf trace -D" output:

.  0020:  00 00 00 00 00 00 00 00 2f 73 62 69 6e 2f 69 6e  ......../sbin/i
.  0030:  69 74 00 00 00 00 00 00                          /sbin/i

With this fixed (and simpler!) code, we get the correct output:

.  0020:  00 00 00 00 00 00 00 00 2f 73 62 69 6e 2f 69 6e  ......../sbin/in
.  0030:  69 74 00 00 00 00 00 00                          it......

Cc: Ingo Molnar <mingo@elte.hu>
LPU-Reference: <20100612024404.GA24469@hexapodia.org>
Signed-off-by: Andy Isaacson <adi@hexapodia.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/debug.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 6cddff2..318dab1 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -86,12 +86,10 @@ void trace_event(event_t *event)
 			dump_printf_color("  ", color);
 			for (j = 0; j < 15-(i & 15); j++)
 				dump_printf_color("   ", color);
-			for (j = 0; j < (i & 15); j++) {
-				if (isprint(raw_event[i-15+j]))
-					dump_printf_color("%c", color,
-							  raw_event[i-15+j]);
-				else
-					dump_printf_color(".", color);
+			for (j = i & ~15; j <= i; j++) {
+				dump_printf_color("%c", color,
+						isprint(raw_event[j]) ?
+						raw_event[j] : '.');
 			}
 			dump_printf_color("\n", color);
 		}
-- 
1.6.2.5

