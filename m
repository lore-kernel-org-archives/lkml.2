Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab1ABHWt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:22:49 -0500
Received: from mail.windriver.com ([147.11.1.11]:35003 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298Ab1ABHWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:22:44 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Steven Rostedt <srostedt@redhat.com>,
        Chris Wright <chrisw@sous-sol.org>, Tavis Ormandy <taviso@google.com>,
        Eugene Teo <eugene@redhat.com>, vendor-sec@lst.de,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 063/260] tracing: Do not allow llseek to set_ftrace_filter
Date: Sun,  2 Jan 2011 02:15:59 -0500
Message-Id: <1293952756-15010-64-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:21:14.0867 (UTC) FILETIME=[A3DE9C30:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

commit 9c55cb12c1c172e2d51e85fbb5a4796ca86b77e7 upstream.

Reading the file set_ftrace_filter does three things.

1) shows whether or not filters are set for the function tracer
2) shows what functions are set for the function tracer
3) shows what triggers are set on any functions

3 is independent from 1 and 2.

The way this file currently works is that it is a state machine,
and as you read it, it may change state. But this assumption breaks
when you use lseek() on the file. The state machine gets out of sync
and the t_show() may use the wrong pointer and cause a kernel oops.

Luckily, this will only kill the app that does the lseek, but the app
dies while holding a mutex. This prevents anyone else from using the
set_ftrace_filter file (or any other function tracing file for that matter).

A real fix for this is to rewrite the code, but that is too much for
a -rc release or stable. This patch simply disables llseek on the
set_ftrace_filter() file for now, and we can do the proper fix for the
next major release.

Reported-by: Robert Swiecki <swiecki@google.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Tavis Ormandy <taviso@google.com>
Cc: Eugene Teo <eugene@redhat.com>
Cc: vendor-sec@lst.de
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/trace/ftrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index ed676ba..7d51cab 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2395,7 +2395,7 @@ static const struct file_operations ftrace_filter_fops = {
 	.open = ftrace_filter_open,
 	.read = seq_read,
 	.write = ftrace_filter_write,
-	.llseek = ftrace_regex_lseek,
+	.llseek = no_llseek,
 	.release = ftrace_filter_release,
 };
 
-- 
1.7.3.3

