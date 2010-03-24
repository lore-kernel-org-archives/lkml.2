Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351Ab0CXOnd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 10:43:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59664 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755686Ab0CXOnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 10:43:32 -0400
Date: Wed, 24 Mar 2010 07:41:49 -0400
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm]
 signals-clear-signal-tty-when-the-last-thread-exits.fix
Message-Id: <20100324074149.8d4e96e6.akpm@linux-foundation.org>
In-Reply-To: <20100324142348.GA8117@redhat.com>
References: <20100319184020.GA519@redhat.com>
	<20100324142348.GA8117@redhat.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Mar 2010 15:23:48 +0100 Oleg Nesterov <oleg@redhat.com> wrote:

> (fixup for signals-clear-signal-tty-when-the-last-thread-exits.patch)
> 
> I didn't get this warning, but the old gcc complains
> 
> 	kernel/exit.c: In function 'release_task':
> 	kernel/exit.c:85: warning: 'tty' may be used uninitialized in this function
> 
> This clearly wrong, to the point it blames release_task() instead of
> __exit_signal(). But let's make compiler happy anyway, hopefully this
> is what it wants.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
> 
>  kernel/exit.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- 34-rc1/kernel/exit.c~FIX_EXIT_SIGNAL_TTY_WARNING	2010-03-21 18:36:44.000000000 +0100
> +++ 34-rc1/kernel/exit.c	2010-03-24 14:59:55.000000000 +0100
> @@ -82,7 +82,7 @@ static void __exit_signal(struct task_st
>  	struct signal_struct *sig = tsk->signal;
>  	bool group_dead = thread_group_leader(tsk);
>  	struct sighand_struct *sighand;
> -	struct tty_struct *tty;
> +	struct tty_struct *tty = NULL;	/* supress gcc warning */

uninitialized_var() is a neater way.

(uninitialized_var() will save a teeny bit of .text on old gcc.  One
suspects that a newer gcc which is capable of working out that this
variable _isn't_ uninitialized would also be capable of eliding the `= 0').

