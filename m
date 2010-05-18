Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758450Ab0ERRRL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 13:17:11 -0400
Received: from hera.kernel.org ([140.211.167.34]:60706 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350Ab0ERRRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 13:17:06 -0400
Date: Tue, 18 May 2010 17:16:38 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Disallow mmap() on per-task inherited events
Message-ID: <tip-c7920614cebbf269a7c8397ff959a8dcf727465c@git.kernel.org>
Git-Commit-ID: c7920614cebbf269a7c8397ff959a8dcf727465c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 18 May 2010 17:16:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c7920614cebbf269a7c8397ff959a8dcf727465c
Gitweb:     http://git.kernel.org/tip/c7920614cebbf269a7c8397ff959a8dcf727465c
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 18 May 2010 10:33:24 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 18 May 2010 18:35:48 +0200

perf: Disallow mmap() on per-task inherited events

Since we now have working per-task-per-cpu events for
a while, disallow mmap() on per-task inherited
events. Those things were a performance problem
anyway, and doing away with it allows us to optimize
the buffer somewhat by assuming there is only a
single writer.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 6ae6218..ff5d430 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -2593,6 +2593,14 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	long user_extra, extra;
 	int ret = 0;
 
+	/*
+	 * Don't allow mmap() of inherited per-task counters. This would
+	 * create a performance issue due to all children writing to the
+	 * same buffer.
+	 */
+	if (event->cpu == -1 && event->attr.inherit)
+		return -EINVAL;
+
 	if (!(vma->vm_flags & VM_SHARED))
 		return -EINVAL;
 
