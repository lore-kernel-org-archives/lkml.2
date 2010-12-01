Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab0LAAJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 19:09:55 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34015 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751366Ab0LAAJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 19:09:54 -0500
Date: Tue, 30 Nov 2010 16:09:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Nelson Elhage <nelhage@ksplice.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm_release: Do a set_fs(USER_DS) before handling
 clear_child_tid.
Message-Id: <20101130160950.96153286.akpm@linux-foundation.org>
In-Reply-To: <1291083556-5894-1-git-send-email-nelhage@ksplice.com>
References: <1291083556-5894-1-git-send-email-nelhage@ksplice.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Nov 2010 21:19:16 -0500
Nelson Elhage <nelhage@ksplice.com> wrote:

> If a user manages to trigger a kernel BUG() or page fault with fs set to
> KERNEL_DS, fs is not otherwise reset before do_exit(), allowing the user to
> write a 0 to an arbitrary address in kernel memory.
> 
> Signed-off-by: Nelson Elhage <nelhage@ksplice.com>
> ---
> AFAICT this is presently only triggerable in the presence of another bug, but
> this potentially turns a lot of DoS bugs into privilege escalation, so it's
> worth fixing. Among other things, sock_no_sendpage and the kernel_{read,write}v
> calls in splice.c make it easy to call an awful lot of the kernel under
> KERNEL_DS.
> 
> This isn't the only way we could fix this -- we could put the set_fs() at the
> start of do_exit, or in all the callers that might call potentially do_exit with
> KERNEL_DS set, or else we could do an access_ok inside fork(). I'm happy to put
> together one of those patches if someone thinks another approach makes more
> sense.
> 
>  kernel/fork.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 3b159c5..a68445e 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -636,7 +636,12 @@ void mm_release(struct task_struct *tsk, struct mm_struct *mm)
>  			/*
>  			 * We don't check the error code - if userspace has
>  			 * not set up a proper pointer then tough luck.
> +			 *
> +			 * We do set_fs() explicitly in case this task
> +			 * exited while inside set_fs(KERNEL_DS) for
> +			 * some reason (e.g. on a BUG()).
>  			 */
> +			set_fs(USER_DS);
>  			put_user(0, tsk->clear_child_tid);
>  			sys_futex(tsk->clear_child_tid, FUTEX_WAKE,
>  					1, NULL, NULL, 0);

Confused.  The user can only exploit the wrong addr_limit if control
returns to userspace for the user's code to execute.  But that won't be
happening, because this thread will unconditionally exit.


If/when you unconfuse me, I'd suggest this change only be done if the
thread is *known* to have oopsed - doing it for non-oopsed threads
seems unpleasant to my mind.  And I think it should be done nice and
clearly, right up inside do_exit() by some means.  Or perhaps in the
oops code, just before it calls do_exit().  Not hidden down in
mm_release().
