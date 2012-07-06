Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933469Ab2GFLMN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 07:12:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51941 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756895Ab2GFLML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 07:12:11 -0400
Date: Fri, 6 Jul 2012 04:11:49 -0700
From: tip-bot for Wolfgang Mauerer <wolfgang.mauerer@siemens.com>
Message-ID: <tip-c5b35b731965d16fa8c966e288489857097e0b25@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rostedt@goodmis.org, wolfgang.mauerer@siemens.com, tglx@linutronix.de,
        namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, wolfgang.mauerer@siemens.com, tglx@linutronix.de,
        namhyung@kernel.org
In-Reply-To: <1332411501-8059-3-git-send-email-wolfgang.mauerer@siemens.com>
References: <1332411501-8059-3-git-send-email-wolfgang.mauerer@siemens.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Fix trace_printk for long integers
Git-Commit-ID: c5b35b731965d16fa8c966e288489857097e0b25
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 06 Jul 2012 04:12:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c5b35b731965d16fa8c966e288489857097e0b25
Gitweb:     http://git.kernel.org/tip/c5b35b731965d16fa8c966e288489857097e0b25
Author:     Wolfgang Mauerer <wolfgang.mauerer@siemens.com>
AuthorDate: Thu, 22 Mar 2012 11:18:21 +0100
Committer:  Namhyung Kim <namhyung@kernel.org>
CommitDate: Wed, 4 Jul 2012 13:40:30 +0900

tools lib traceevent: Fix trace_printk for long integers

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
 1 files changed, 3 insertions(+), 2 deletions(-)

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
