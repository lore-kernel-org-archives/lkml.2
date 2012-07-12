Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964847Ab2GLWG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:06:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44664 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab2GLWGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:06:25 -0400
Date: Thu, 12 Jul 2012 15:06:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        linux-am33-list@redhat.com, Paul Mundt <lethal@linux-sh.org>,
        linux-sh@vger.kernel.org, Chris Metcalf <cmetcalf@tilera.com>,
        Salman Qazi <sqazi@google.com>
Subject: Re: [PATCH] fork: fix error handling in dup_task()
Message-Id: <20120712150623.06b2f71e.akpm@linux-foundation.org>
In-Reply-To: <1342091093-1909-1-git-send-email-akinobu.mita@gmail.com>
References: <1342091093-1909-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2012 20:04:53 +0900
Akinobu Mita <akinobu.mita@gmail.com> wrote:

> The function dup_task() may fail at the following function calls in
> the following order.
> 
> 0) alloc_task_struct_node()
> 1) alloc_thread_info_node()
> 2) arch_dup_task_struct()
> 
> Error by 0) is not a matter, it can just return.  But error by 1)
> requires releasing task_struct allocated by 0) before it returns.
> Likewise, error by 2) requires releasing task_struct and thread_info
> allocated by 0) and 1).
> 
> The existing error handling calls free_task_struct() and
> free_thread_info() which do not only release task_struct and
> thread_info, but also call architecture specific
> arch_release_task_struct() and arch_release_thread_info().
> 
> The problem is that task_struct and thread_info are not fully
> initialized yet at this point, but arch_release_task_struct() and
> arch_release_thread_info() are called with them.
> 
> For example, x86 defines its own arch_release_task_struct() that
> releases a task_xstate.  If alloc_thread_info_node() fails in
> dup_task(), arch_release_task_struct() is called with task_struct
> which is just allocated and filled with garbage in this error handling.
> 
> This actually happened with tools/testing/fault-injection/failcmd.sh
> 
> 	# env FAILCMD_TYPE=fail_page_alloc \
> 		./tools/testing/fault-injection/failcmd.sh --times=100 \
> 		--min-order=0 --ignore-gfp-wait=0 \
> 		-- make -C tools/testing/selftests/ run_tests
> 
> In order to fix this issue, make free_{task_struct,thread_info}() not
> to call arch_release_{task_struct,thread_info}() and call
> arch_release_{task_struct,thread_info}() implicitly where needed.
> 
> Default arch_release_task_struct() and arch_release_thread_info() are
> defined as empty by default.  So this change only affects the
> architectures which implement their own arch_release_task_struct() or
> arch_release_thread_info() as listed below.

This conflicts with Salman's fix (below) which is in linux-next via
Ingo's tree.

It appears that we should drop Salman's patch altogether and use yours?


commit 164c33c6adee609b8b9062cce4c10f764d0dce13
Author:     Salman Qazi <sqazi@google.com>
AuthorDate: Mon Jun 25 18:18:15 2012 -0700
Commit:     Ingo Molnar <mingo@kernel.org>
CommitDate: Thu Jul 5 20:57:32 2012 +0200

    sched: Fix fork() error path to not crash
    
    In dup_task_struct(), if arch_dup_task_struct() fails, the clean up
    code fails to clean up correctly.  That's because the clean up
    code depends on unininitalized ti->task pointer.  We fix this
    by making sure that the task and thread_info know about each other
    before we attempt to take the error path.
    
    Signed-off-by: Salman Qazi <sqazi@google.com>
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Link: http://lkml.kernel.org/r/20120626011815.11323.5533.stgit@dungbeetle.mtv.corp.google.com
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

diff --git a/kernel/fork.c b/kernel/fork.c
index ab5211b..f00e319 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -304,12 +304,17 @@ static struct task_struct *dup_task_struct(struct task_struct *orig)
 	}
 
 	err = arch_dup_task_struct(tsk, orig);
-	if (err)
-		goto out;
 
+	/*
+	 * We defer looking at err, because we will need this setup
+	 * for the clean up path to work correctly.
+	 */
 	tsk->stack = ti;
-
 	setup_thread_stack(tsk, orig);
+
+	if (err)
+		goto out;
+
 	clear_user_return_notifier(tsk);
 	clear_tsk_need_resched(tsk);
 	stackend = end_of_stack(tsk);

