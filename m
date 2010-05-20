Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab0ETShL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 14:37:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40686 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751343Ab0ETShJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 14:37:09 -0400
Date: Thu, 20 May 2010 11:36:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [2.6.34 PATCH] kernel: fix exit message for dead process
Message-Id: <20100520113603.e8103ef1.akpm@linux-foundation.org>
In-Reply-To: <10672.1274379460@localhost>
References: <201005192341.o4JNf5Hv012931@imap1.linux-foundation.org>
	<4637.1274370470@localhost>
	<20100520085520.5176d13c.akpm@linux-foundation.org>
	<10672.1274379460@localhost>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 May 2010 14:17:40 -0400
Valdis.Kletnieks@vt.edu wrote:

> If a process is exiting with a non-zero preempt_count, it's in fact almost
> certainly going to fail to do so because it is exiting due to a BUG or OOPS
> while it held a lock, at which point it will never actually exit.  So change
> the message to say it attempted to do so, rather than implying it succeeded.
> Problem spotted when a process BUG'ed, the kernel reported the 'exited' status,
> and then proceeded to BUG twice more dealing with the now-zombied process:
> 
> > [   35.357018] note: keymap[2481] exited with preempt_count 1
> > [   35.360503] BUG: scheduling while atomic: keymap/2481/0x10000002
> 
> Yes, one line is 83 characters. It's still more readable than a split printk.
> 
> Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
> 
> --- linux-2.6.34-mmotm0519/kernel/exit.c.dist	2010-05-20 10:59:11.646870592 -0400
> +++ linux-2.6.34-mmotm0519/kernel/exit.c	2010-05-20 14:05:16.068800223 -0400
> @@ -936,7 +936,7 @@ NORET_TYPE void do_exit(long code)
>  	raw_spin_unlock_wait(&tsk->pi_lock);
>  
>  	if (unlikely(in_atomic()))
> -		printk(KERN_INFO "note: %s[%d] exited with preempt_count %d\n",
> +		printk(KERN_INFO "note: %s[%d] tried to exit with preempt_count %d\n",
>  				current->comm, task_pid_nr(current),
>  				preempt_count());

a) this message is kinda like __schedule_bug(), only
   __schedule_bug() does more stuff.  Perhaps some sharing is in order.

b) do_exit() eventually calls schedule() anyway, so if we have a bad
   preempt_count() here, schedule() should end up calling
   __schedule_bug(), so we don't need this message in do_exit(). 

   ah-hah, __schedule_bug() doesn't get called on the exit() path due to
   task->state==TASK_DEAD.  But we can surely change that. 
   schedule_debug() needs fixing anyway - what's it doing assuming that
   TASK_RUNNING==0?

c) it's pretty pointless printing anything at all if this task has
   oopsed.  This info is never interesting and will just cause the
   useful info to scroll into oblivion.

