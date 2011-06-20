Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab1FTTl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 15:41:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352Ab1FTTlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 15:41:24 -0400
Date: Mon, 20 Jun 2011 21:39:29 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, hch@infradead.org
Subject: Re: [PATCH 6/7] ptrace: kill detah tracehooks
Message-ID: <20110620193929.GA15228@redhat.com>
References: <1308322240-8247-1-git-send-email-tj@kernel.org> <1308322240-8247-7-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308322240-8247-7-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17, Tejun Heo wrote:
>
> This patch kills tracehook_notify_death() by reimplementing the logic
> in its caller - exit_notify().  I opted for re-implementation as the
> existing code was a bit difficult to wrap one's head around.

I always hated this particular tracehook much more than others ;)

But the patch doesn't look right, please see below.

> -	signal = tracehook_notify_death(tsk, &cookie, group_dead);
> -	if (signal >= 0)
> -		signal = do_notify_parent(tsk, signal);
> +	/*
> +	 * Notify interested parent if the whole group is dead.  Ptracer
> +	 * should always be notified.  If something other than our normal
> +	 * parent is ptracing us, then send it a SIGCHLD instead of
> +	 * honoring exit_signal.  exit_signal only has special meaning to
> +	 * our real parent.
> +	 */
> +	if (!task_detached(tsk) && thread_group_empty(tsk)) {
> +		if (!ptrace_reparented(tsk))
> +			do_notify_parent(tsk, tsk->exit_signal);
> +		else
> +			do_notify_parent(tsk, SIGCHLD);

Forget about ptrace, suppose a single threaded child exits and its
parent ignores SIGCHLD. In this case do_notify_parent() sets
exit_signal = -1 to mark it dead, we should set exit_state = EXIT_DEAD
and release it.


Note! This looks very ugly, I wanted to cleanup this a long ago.
I think we should never change ->exit_signal, and do_notify_parent()
should return a boolean. I'll try to make the patches tomorrow.
Then _perhaps_ this patch will become simpler.

Oleg.

