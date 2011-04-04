Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab1DDQEP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 12:04:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754763Ab1DDQEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 12:04:14 -0400
Date: Mon, 4 Apr 2011 18:03:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stas Sergeev <stsp@aknet.ru>
Cc: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [path][rfc] add PR_DETACH prctl command
Message-ID: <20110404160351.GA23655@redhat.com>
References: <4D6510A3.90905@aknet.ru> <20110223191442.GA717@redhat.com> <4D656F87.3090005@aknet.ru> <20110224132906.GA15733@redhat.com> <4D6675B0.2010700@aknet.ru> <20110224153221.GA22770@redhat.com> <4D94A788.1050806@aknet.ru> <20110331170244.GA13271@redhat.com> <4D99D6E6.4070008@aknet.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D99D6E6.4070008@aknet.ru>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stas,

On 04/04, Stas Sergeev wrote:
>
> Here's the patch that addresses your concerns
> about the late deleting from list.
> Also, the patch is shrunk twice.
> I think it is about to be trivial this time.

But it is very wrong at first glance...

> I still haven't solved the problems with checking
> parent and checking ptrace, so ignore them for
> now (or give me the hints:)

Not sure I understand your question...

But, once again. You should not use ptrace_reparented(). Reparanted or
not, the ptraced thread must not change its ->parent.

Sorry Stas, I have no time to read the patch, just one thing...

> +			me->detach_code = arg2 << 8;
> ...
> +			if (notif != DEATH_REAP)
> +				me->detaching = 1;
> +			else
> +				list_move_tail(&me->sibling,
> +					&me->real_parent->children);

This is simply wrong unless the caller is the group_leader. Probably
there was some confusion, I thought we already discussed this. But this
is minor...

> +			while_each_thread(me, p) {
> +				if (!ptrace_reparented(p))
> +					p->parent = pid_ns->child_reaper;
> +				p->real_parent = pid_ns->child_reaper;

Eek. Even ignoring ptrace, this is weird. We change parent/real_parent,
but we do not do list_move_tail(sibling) until wait_task_detached() !
No, I think we should not do this even if this was correct. I'll try
to nack this in any case, even if there were no immediate problems ;)
IMHO, this is insane.

But this is wrong. Well. Suppose that the caller of PR_DETACH exits
before the old parent does do_wait(). What /sbin/init (who is the new
parent) can do after it gets SIGCHLD? If can't see this zombie. Nor
the old parent can release this task due to ->detaching. Eventually
/sbin/init can reap it if it does, say, waitpid(-1), but still this
is wrong.

Or. Suppose that the old parent exits after its child does PR_DETACH.
You changed forget_original_parent() but this is not enough, note that
find_new_reaper() can pick the live sub-thread. In this case the child
will be moved to init's ->children list, and after that we are changing
->real_parent back.

Oleg.

