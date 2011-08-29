Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab1H2SGR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 14:06:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754526Ab1H2SGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 14:06:14 -0400
Date: Mon, 29 Aug 2011 20:02:48 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Paul Menage <paul@paulmenage.org>,
        containers@lists.linux-foundation.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH pm-freezer 2/4] freezer: set PF_NOFREEZE on a dying
	task right before TASK_DEAD
Message-ID: <20110829180248.GA13346@redhat.com>
References: <20110829140418.GB18871@mtj.dyndns.org> <20110829140509.GC18871@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110829140509.GC18871@mtj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/29, Tejun Heo wrote:
>
> There's no try_to_freeze() call in the exit path and the only
> necessary guarantee is that freezer doesn't hang waiting for zombies.
> Set PF_NOFREEZE right before setting tsk->state to TASK_DEAD instead.

Agreed.

But I'd like to repeat, this looks "asymmetrical". do_each_thread()
can't see the (auto)reaped tasks after they do exit_notify(). So we
can only see this PF_NOFREEZE if the thread becomes a zombie.

> @@ -1044,6 +1038,10 @@ NORET_TYPE void do_exit(long code)
>
>  	preempt_disable();
>  	exit_rcu();
> +
> +	/* this task is now dead and freezer should ignore it */
> +	current->flags |= PF_NOFREEZE;
> +
>  	/* causes final put_task_struct in finish_task_switch(). */
>  	tsk->state = TASK_DEAD;

May be freezing_slow_path() can check TASK_DEAD along with PF_NOFREEZE
instead? (or tsk->exit_state != 0 to avoid the asymmetry above). Just
to keep this logic in the freezer code. I dunno.

But this all is up to you and Rafael, I am not arguing. Just random
thoughts.

Oleg.

