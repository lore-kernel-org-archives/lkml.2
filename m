Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933332Ab2GDFjq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 01:39:46 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:63523 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933090Ab2GDFjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 01:39:43 -0400
X-AuditID: 9c930179-b7cceae000004195-4a-4ff3d71bb106
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Wolfgang Mauerer <wolfgang.mauerer@siemens.com>
Subject: [PATCH 05/16] tools lib traceevent: Fix trace_printk for long integers
Date: Wed,  4 Jul 2012 14:35:19 +0900
Message-Id: <1341380130-23863-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1341380130-23863-1-git-send-email-namhyung@kernel.org>
References: <1341380068-23806-1-git-send-email-namhyung@kernel.org>
 <1341380130-23863-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
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
index da06c33dcf41..ddee5a8cf135 100644
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
1.7.10.4

