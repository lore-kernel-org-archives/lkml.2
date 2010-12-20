Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932980Ab0LTRlm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 12:41:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32112 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932922Ab0LTRll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 12:41:41 -0500
Date: Mon, 20 Dec 2010 18:34:25 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 12/16] ptrace: make group stop notification reliable
	against ptrace
Message-ID: <20101220173425.GA18070@redhat.com>
References: <1291654624-6230-1-git-send-email-tj@kernel.org> <1291654624-6230-13-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291654624-6230-13-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06, Tejun Heo wrote:
>
> This patch adds a new signal flag SIGNAL_NOTIFY_STOP which is set on
> group stop completion and cleared on notification to the real parent
> or together with other stopped flags on SIGCONT/KILL.  This guarantees
> that the real parent is notified correctly regardless of ptrace.

OK, I am a bit confused. I do not understand exactly what this
"correctly" actually means.

> If a
> ptraced task is the last task to stop, the notification is postponed
> till ptrace detach or canceled if SIGCONT/KILL is received inbetween.

OK. But what if the last task to stop is not ptraced? In this case
->real_parent gets the notification.

Of course, the current behaviour is not better, it is obviously wrong.
But if we want to fix things, perhaps we should invite the new and
clear rules. Isn't it better to always notify ->real_parent when the
last thread stops in STOPPED/TRACED state? Otherwise the behaviour is
not predictable, it depends on task_ptrace() state of the last thead
which sees SIGNAL_NOTIFY_STOP.

Actually, I think it would be even better to never notify ->real_parent
until debugger detaches all threads, but this is not simple to implement.

> @@ -1901,21 +1925,12 @@ retry:
>  	__set_current_state(TASK_STOPPED);
>
>  	if (likely(!task_ptrace(current))) {
> -		int notify = 0;
> -
> -		/*
> -		 * If there are no other threads in the group, or if there
> -		 * is a group stop in progress and we are the last to stop,
> -		 * report to the parent.
> -		 */
> -		if (task_participate_group_stop(current))
> -			notify = CLD_STOPPED;
> -
> +		task_participate_group_stop(current);
>  		spin_unlock_irq(&current->sighand->siglock);
>
> -		if (notify) {
> +		if (sig->flags & SIGNAL_NOTIFY_STOP) {
>  			read_lock(&tasklist_lock);
> -			do_notify_parent_cldstop(current, notify);
> +			do_notify_parent_cldstop(current, CLD_STOPPED);

Suppose that debugger attaches right after spin_unlock(->siglock).

Nothing really bad can happen afaics, but in this case the debugger
will be notified twice. Hmm. If the debugger does do_wait() immediately
after the first notification, it has all rights to see the stopped
tracee but wait_task_stopped() fails, not good.

Oleg.

