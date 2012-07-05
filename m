Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964784Ab2GEPpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 11:45:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:59090 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964781Ab2GEPp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 11:45:29 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Wolfgang Mauerer <wolfgang.mauerer@siemens.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 05/20] tools lib traceevent: Fix trace_printk for long integers
Date: Thu,  5 Jul 2012 12:45:03 -0300
Message-Id: <1341503118-13198-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1341503118-13198-1-git-send-email-acme@infradead.org>
References: <1341503118-13198-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfgang Mauerer <wolfgang.mauerer@siemens.com>

On 32 bit systems, a conversion of the trace_printk format string
"%lu" -> "%llu" is intended (similar for %lx etc.) when a trace was
taken on a machine with 64 bit long integers. However, the current
code computes the bogus transformation "%lu" -> "%u".  Fix this.

Besides that, the transformation is only required on systems that don't
use 64 bits for long integers natively.

Signed-off-by: Wolfgang Mauerer <wolfgang.mauerer@siemens.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1332411501-8059-3-git-send-email-wolfgang.mauerer@siemens.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index da06c33..ddee5a8 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -3895,14 +3895,15 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct event
 						break;
 					}
 				}
-				if (pevent->long_size == 8 && ls) {
+				if (pevent->long_size == 8 && ls &&
+				    sizeof(long) != 8) {
 					char *p;
 
 					ls = 2;
 					/* make %l into %ll */
 					p = strchr(format, 'l');
 					if (p)
-						memmove(p, p+1, strlen(p)+1);
+						memmove(p+1, p, strlen(p)+1);
 					else if (strcmp(format, "%p") == 0)
 						strcpy(format, "0x%llx");
 				}
-- 
1.7.9.2.358.g22243

