Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754723Ab1CWBcu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 21:32:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:35787 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981Ab1CWBct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 21:32:49 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=sTGVrInRmkoA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=Gcc7BpuGDT3rF0rM1vgA:9 a=vLBWBuQjLVex1o47Oy4A:7 a=63xYV0IL76Ez_SOxQuwU4nra_5gA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [PATCH][GIT PULL][v2.6.39] tracing: Fix set_ftrace_filter probe
 function display
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 22 Mar 2011 21:32:46 -0400
Message-ID: <1300843966.14261.126.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

This patch was buried away in my INBOX, and I recently discovered it. I
tested out the scenario that Jiri posted and sure enough it is broken.
This patch does indeed fix the issue.

As the merge window is still open and this is a simple patch that fixes
a long standing bug, could you pull it for 2.6.39.

Thanks!

-- Steve

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/urgent


Jiri Olsa (1):
      tracing: Fix set_ftrace_filter probe function display

----
 kernel/trace/ftrace.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)
---------------------------
commit 1106b6997df7d0c0487e21fd9c9dd2ce3d4a52db
Author: Jiri Olsa <jolsa@redhat.com>
Date:   Wed Feb 16 17:35:34 2011 +0100

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


