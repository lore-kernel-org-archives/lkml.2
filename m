Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886Ab0CQTac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 15:30:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2756 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755748Ab0CQTaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 15:30:25 -0400
Date: Wed, 17 Mar 2010 20:29:01 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, Veaceslav Falico <vfalico@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] exit: avoid sig->count in __exit_signal() to detect
	the group-dead case
Message-ID: <20100317192901.GA2109@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change __exit_signal() to check thread_group_leader() instead of
atomic_dec_and_test(&sig->count). This must be equivalent, the
group leader must be released only after all other threads have
exited and passed __exit_signal().

>From now sig->count is not actually used, except in fs/proc for
get_nr_threads/etc.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---


--- 34-rc1/kernel/exit.c~4_EXIT_SIGNAL	2010-03-17 19:37:18.000000000 +0100
+++ 34-rc1/kernel/exit.c	2010-03-17 20:05:38.000000000 +0100
@@ -89,11 +89,12 @@ static void __exit_signal(struct task_st
 					rcu_read_lock_held() ||
 					lockdep_is_held(&tasklist_lock));
 	spin_lock(&sighand->siglock);
+	atomic_dec(&sig->count);
 
 	posix_cpu_timers_exit(tsk);
-	if (atomic_dec_and_test(&sig->count))
+	if (thread_group_leader(tsk)) {
 		posix_cpu_timers_exit_group(tsk);
-	else {
+	} else {
 		/*
 		 * If there is any task waiting for the group exit
 		 * then notify it:

