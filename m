Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754410Ab1CWJnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 05:43:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:57217 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753848Ab1CWJnG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 05:43:06 -0400
Date: Wed, 23 Mar 2011 09:42:53 GMT
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        rostedt@goodmis.org, tglx@linutronix.de, jolsa@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, tglx@linutronix.de, jolsa@redhat.com
In-Reply-To: <1297874134-7008-1-git-send-email-jolsa@redhat.com>
References: <1297874134-7008-1-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tracing: Fix set_ftrace_filter probe function display
Message-ID: <tip-1106b6997df7d0c0487e21fd9c9dd2ce3d4a52db@git.kernel.org>
Git-Commit-ID: 1106b6997df7d0c0487e21fd9c9dd2ce3d4a52db
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 23 Mar 2011 09:42:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1106b6997df7d0c0487e21fd9c9dd2ce3d4a52db
Gitweb:     http://git.kernel.org/tip/1106b6997df7d0c0487e21fd9c9dd2ce3d4a52db
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Wed, 16 Feb 2011 17:35:34 +0100
Committer:  Steven Rostedt <rostedt@goodmis.org>
CommitDate: Tue, 22 Mar 2011 12:52:03 -0400

tracing: Fix set_ftrace_filter probe function display

If one or more function probes (like traceon) are enabled,
and there's no other function filter, the first probe
func is skipped (which one depends on the position in the hash).

$ echo sys_open:traceon sys_close:traceon > ./set_ftrace_filter
$ cat set_ftrace_filter
#### all functions enabled ####
sys_close:traceon:unlimited
$

The reason was, that in the case of no other function filter,
the func_pos was not properly updated before calling t_hash_start.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
LKML-Reference: <1297874134-7008-1-git-send-email-jolsa@redhat.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/ftrace.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 888b611..c075f4e 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1467,7 +1467,7 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 		return t_hash_next(m, pos);
 
 	(*pos)++;
-	iter->pos = *pos;
+	iter->pos = iter->func_pos = *pos;
 
 	if (iter->flags & FTRACE_ITER_PRINTALL)
 		return t_hash_start(m, pos);
@@ -1502,7 +1502,6 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
 	if (!rec)
 		return t_hash_start(m, pos);
 
-	iter->func_pos = *pos;
 	iter->func = rec;
 
 	return iter;
