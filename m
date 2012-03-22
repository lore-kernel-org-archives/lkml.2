Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466Ab2CVKiP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 06:38:15 -0400
Received: from lizzard.sbs.de ([194.138.37.39]:27729 "EHLO lizzard.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757349Ab2CVKiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 06:38:10 -0400
From: Wolfgang Mauerer <wolfgang.mauerer@siemens.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2, trace-cmd] Fix trace_printk for long integers
Date: Thu, 22 Mar 2012 11:18:21 +0100
Message-Id: <1332411501-8059-3-git-send-email-wolfgang.mauerer@siemens.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1332411501-8059-1-git-send-email-wolfgang.mauerer@siemens.com>
References: <1332411501-8059-1-git-send-email-wolfgang.mauerer@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 32 bit systems, a conversion of the trace_printk format string
"%lu" -> "%llu" is intended (similar for %lx etc.) when a
trace was taken on a machine with 64 bit long integers. However,
the current code computes the bogus transformation "%lu" -> "%u".
Fix this.

Besides that, the transformation is only required on systems
that don't use 64 bits for long integers natively.

Signed-off-by: Wolfgang Mauerer <wolfgang.mauerer@siemens.com>
---
 parse-events.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/parse-events.c b/parse-events.c
index f8ba6a5..5214771 100644
--- a/parse-events.c
+++ b/parse-events.c
@@ -3789,14 +3789,15 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct event
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
1.7.6.4

