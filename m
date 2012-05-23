Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964998Ab2EWCnf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 22:43:35 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:43911 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932978Ab2EWCjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 22:39:05 -0400
X-AuditID: 9c93016f-b7c3cae000001954-84-4fbc4dc54200
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Wolfgang Mauerer <wolfgang.mauerer@siemens.com>
Subject: [PATCH 06/22] lib/traceevent: Fix trace_printk for long integers
Date: Wed, 23 May 2012 11:36:43 +0900
Message-Id: <1337740619-27925-7-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1337740619-27925-1-git-send-email-namhyung.kim@lge.com>
References: <1337740619-27925-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfgang Mauerer <wolfgang.mauerer@siemens.com>

On 32 bit systems, a conversion of the trace_printk format string
"%lu" -> "%llu" is intended (similar for %lx etc.) when a
trace was taken on a machine with 64 bit long integers. However,
the current code computes the bogus transformation "%lu" -> "%u".
Fix this.

Besides that, the transformation is only required on systems
that don't use 64 bits for long integers natively.

Link: http://lkml.kernel.org/r/1332411501-8059-3-git-send-email-wolfgang.mauerer@siemens.com

Signed-off-by: Wolfgang Mauerer <wolfgang.mauerer@siemens.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/lib/traceevent/event-parse.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 59534e299590..8282523f489d 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -3805,14 +3805,15 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct event
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
1.7.10.1

