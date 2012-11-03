Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab2KCID3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 04:03:29 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:63419 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab2KCIDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 04:03:23 -0400
MIME-Version: 1.0
Date: Sat, 3 Nov 2012 16:03:21 +0800
Message-ID: <CADCVGbSC-T=W08xcf9rDynS8Uf9yq=KKTNUn33g-O_FqyQkU_A@mail.gmail.com>
Subject: Is this a kernel bug?
From: Cyberman Wu <cypher.w@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recent days we got a exception in kernel thread [kworker/n:m], but
exception handler
call do_group_exit() -> do_exit() -> schedule() and got another
exception in schedule():
			/*
			 * If a worker is going to sleep, notify and
			 * ask workqueue whether it wants to wake up a
			 * task to maintain concurrency.  If so, wake
			 * up the task.
			 */
			if (prev->flags & PF_WQ_WORKER) {
				struct task_struct *to_wakeup;

				to_wakeup = wq_worker_sleeping(prev, cpu);
				if (to_wakeup)
					try_to_wake_up_local(to_wakeup);
			}

Exception occurred while wq_worker_sleeping() -> kthread_data().

It's because do_exit() -> exit_mm() -> mm_release():
	/* notify parent sleeping on vfork() */
	if (vfork_done) {
		tsk->vfork_done = NULL;
		complete(vfork_done);
	}

I'm using a patched version of kernel 2.6.38.8. But I've checked code
of kernel version 3.6.5,
it seems have the same process, only with files and functions split.



-- 
Cyberman Wu
