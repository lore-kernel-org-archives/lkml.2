Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030Ab1CVTRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 15:17:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520Ab1CVTRU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 15:17:20 -0400
Date: Tue, 22 Mar 2011 20:08:12 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 3/8] job control: Fix ptracer wait(2) hang and explain
	notask_error clearing
Message-ID: <20110322190812.GB28038@redhat.com>
References: <1299614199-25142-1-git-send-email-tj@kernel.org> <1299614199-25142-4-git-send-email-tj@kernel.org> <20110321151941.GA20917@redhat.com> <20110321161236.GF12003@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110321161236.GF12003@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21, Tejun Heo wrote:
>
> On Mon, Mar 21, 2011 at 04:19:41PM +0100, Oleg Nesterov wrote:
> > But the main problem is, I do not think do_wait() should block in this
> > case, and thus I am starting to think this patch is not "complete".

Just in case... But of course I didn't mean this patch should be
updated to handle the EXIT_ZOMBIE case.

> > Your test-case could use waitid(WEXITED) instead WSTOPPED with the same
> > result, it should hang. Why it hangs? The tracee is dead, we can't do
> > ptrace(PTRACE_DETACH), and we can do nothing until other threads exit.
> > This looks equally strange.
> >
> > IOW. Assuming that ptrace == T and WEXITED is set, perhaps we should
> > do something like this pseudo-code
> >
> > 	if (p->exit_state == EXIT_ZOMBIE) {
> > 		if (!delay_group_leader(p))
> > 			return wait_task_zombie(wo, p);
> >
> > 		ptrace_unlink();
> > 		wait_task_zombie(WNOWAIT);
> > 	}
> >
> > However. This is another user-visible change, we need another discussion
> > even if I am right. In particular, it is not clear what should we do
> > if parent == real_parent. And probably this can confuse gdb, but iirc
> > gdb already have the problems with the dead leader anyway.
>
> Interesting point.  Yeah, I agree.  wait(WEXITED) from the ptracer
> should only wait for the tracee itself, not the group.  When they are
> one and the same, I don't think we need to do anything differently
> from now.
>
> If we change the behavior that way, it would also fit better with the
> rest of the new behavior where the real parent and ptracer have
> separate roles when wait(2)ing for stopped states.
>
> The question is how the change would affect the existing users.

Yes, of course. Perhaps we can never do this.

> When
> the debugee is a direct child, nothing will change.

Actually, I think this is the most problematic case... Perhaps
it would be safer to add WEXITED_THREAD for ptrace. I dunno.

> When attaching to
> a separate group, I don't think it even matters.  Does gdb handle
> group leader any differently from the rest when attached to an
> unrelated group?

gdb certainly has some problems with the dead leaders. But I can't
recall what exactly. Will try to check later...

In any case, I only tried to discuss what else we can do with the
current strange semantics. When it comes to ptrace, group_leader
should not represent the whole process.

Oleg.

