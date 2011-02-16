Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab1BPQfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 11:35:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52007 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751518Ab1BPQfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 11:35:39 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] trace: fix set_ftrace_filter probe function display
Date: Wed, 16 Feb 2011 17:35:34 +0100
Message-Id: <1297874134-7008-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

there's and issue in the display of the probe functions,
explained in the attached patch.

hopefully I'm not breaking anything else ;)

thanks,
jirka

---
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

wbr,
jirka


Signed-off-by: Jiri Olsa <jolsa@redhat.com>
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
-- 
1.7.1
