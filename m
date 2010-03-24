Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932956Ab0CXUsL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 16:48:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36759 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932946Ab0CXUsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 16:48:07 -0400
Date: Wed, 24 Mar 2010 21:45:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Americo Wang <xiyou.wangcong@gmail.com>,
       Balbir Singh <balbir@in.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Spencer Candland <spencer@bluehost.com>,
       Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC,PATCH 1/2] cputimers/proc: do_task_stat()->task_times() can
	race with getrusage()
Message-ID: <20100324204550.GA31777@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_task_stat()->task_times() can race with getrusage(), they both can
try to update task->prev_Xtime at the same time.

Remove this bit of d180c5bc "sched: Introduce task_times() to replace
task_{u,s}time()".

See also the next patch.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 fs/proc/array.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- 34-rc1/fs/proc/array.c~PROC_4_DTS_TASK_TIMES_IS_RACY	2010-03-24 19:53:23.000000000 +0100
+++ 34-rc1/fs/proc/array.c	2010-03-24 19:57:37.000000000 +0100
@@ -449,7 +449,8 @@ static int do_task_stat(struct seq_file 
 	if (!whole) {
 		min_flt = task->min_flt;
 		maj_flt = task->maj_flt;
-		task_times(task, &utime, &stime);
+		utime = task->utime;
+		stime = task->stime;
 		gtime = task->gtime;
 	}
 

