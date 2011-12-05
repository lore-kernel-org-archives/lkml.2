Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489Ab1LESUS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 13:20:18 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:65194 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab1LESUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 13:20:16 -0500
Date: Mon, 5 Dec 2011 22:20:11 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Kees Cook <keescook@chromium.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Alexey Dobriyan <adobriyan@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] fs, proc: Add start_data, end_data, start_brk members to
 /proc/$pid/stat v2
Message-ID: <20111205182010.GV14515@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It helps to dump and restore this mm_struct members.

v2:
 - Kees and Alexey pointed out that "1" hack is unnecessary,
   so make it to have plain (mm && permitted) ? mm->member : 0
   form.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>
---
 fs/proc/array.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux-2.6.git/fs/proc/array.c
===================================================================
--- linux-2.6.git.orig/fs/proc/array.c
+++ linux-2.6.git/fs/proc/array.c
@@ -464,7 +464,7 @@ static int do_task_stat(struct seq_file
 
 	seq_printf(m, "%d (%s) %c %d %d %d %d %d %u %lu \
 %lu %lu %lu %lu %lu %ld %ld %ld %ld %d 0 %llu %lu %ld %lu %lu %lu %lu %lu \
-%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %lu %ld\n",
+%lu %lu %lu %lu %lu %lu %lu %lu %d %d %u %u %llu %lu %ld %lu %lu %lu\n",
 		pid_nr_ns(pid, ns),
 		tcomm,
 		state,
@@ -511,7 +511,10 @@ static int do_task_stat(struct seq_file
 		task->policy,
 		(unsigned long long)delayacct_blkio_ticks(task),
 		cputime_to_clock_t(gtime),
-		cputime_to_clock_t(cgtime));
+		cputime_to_clock_t(cgtime),
+		(mm && permitted) ? mm->start_data : 0,
+		(mm && permitted) ? mm->end_data : 0,
+		(mm && permitted) ? mm->start_brk : 0);
 	if (mm)
 		mmput(mm);
 	return 0;
