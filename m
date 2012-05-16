Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760306Ab2EPSlB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 14:41:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22040 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754240Ab2EPSk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 14:40:59 -0400
Date: Wed, 16 May 2012 20:39:20 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 2/3] pidns: Guarantee that the pidns init will be the
	last pidns process reaped.
Message-ID: <20120516183920.GA19975@redhat.com>
References: <1335604790.5995.22.camel@marge.simpson.net> <20120428142605.GA20248@redhat.com> <m14ns355ru.fsf@fess.ebiederm.org> <20120429165846.GA19054@redhat.com> <1335754867.17899.4.camel@marge.simpson.net> <m1zk9rmyh4.fsf@fess.ebiederm.org> <20120501134214.f6b44f4a.akpm@linux-foundation.org> <87havs7rvv.fsf_-_@xmission.com> <8762c87rrd.fsf_-_@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8762c87rrd.fsf_-_@xmission.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric, sorry for the huge delay, I was on vacation when you sent this patch...

On 05/06, Eric W. Biederman wrote:
>
> @@ -798,6 +815,12 @@ static void forget_original_parent(struct task_struct *father)
>  	exit_ptrace(father);
>  	reaper = find_new_reaper(father);
>
> +	/* Return immediately if we aren't going to reparent anything */
> +	if (unlikely(reaper == father)) {
> +		write_unlock_irq(&tasklist_lock);
> +		return;
> +	}

I was confused by the comment. Afaics, it is not that "we aren't
going to reparent", we need this change because we can't "reparent"
to the same thread, list_for_each_entry_safe() below can never stop.
But this is off-topic...

Hmm. I don't think the patch is 100% correct. Afaics, this needs more
delay_pidns_leader() checks.

For example. Suppose we have a CLONE_NEWPID zombie I, it has an
EXIT_DEAD child D so delay_pidns_leader(I) == T.

Now suppose that I->real_parent exits, lets denote this task as P.

Suppose that P->real_parent ignores SIGCHLD.

In this case P will do release_task(I) prematurely. And worse, when
D finally does realease_task(D) it will do realease_task(I) again.

Oleg.

