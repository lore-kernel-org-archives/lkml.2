Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744Ab1CUQNO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 12:13:14 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34694 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab1CUQNL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 12:13:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PruLm6rxjUk++HXwx1MqkBSJk7u5nlWAjfWvw4DSmJErBfx3SJAAUIQNdkIiBe3x8J
         ZTddZrvoO46DAtK40v5t8v+/aHnsm97JVhuc/aANdK4zEaNSr8ywkZTOVoA8J/IjYcwM
         56UyHTRVzzLZmOQZmVbMYbBJsS0CZhfrpsq/E=
Date: Mon, 21 Mar 2011 17:12:36 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: roland@redhat.com, jan.kratochvil@redhat.com, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: [PATCH 3/8] job control: Fix ptracer wait(2) hang and explain
 notask_error clearing
Message-ID: <20110321161236.GF12003@htj.dyndns.org>
References: <1299614199-25142-1-git-send-email-tj@kernel.org>
 <1299614199-25142-4-git-send-email-tj@kernel.org>
 <20110321151941.GA20917@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110321151941.GA20917@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 21, 2011 at 04:19:41PM +0100, Oleg Nesterov wrote:
> > +		/*
> > +		 * Allow access to stopped/continued state via zombie by
> > +		 * falling through.  Clearing of notask_error is complex.
> > +		 *
> > +		 * When !@ptrace:
> > +		 *
> > +		 * If WEXITED is set, notask_error should naturally be
> > +		 * cleared.  If not, subset of WSTOPPED|WCONTINUED is set,
> > +		 * so, if there are live subthreads, there are events to
> > +		 * wait for.  If all subthreads are dead, it's still safe
> > +		 * to clear - this function will be called again in finite
> > +		 * amount time once all the subthreads are released and
> > +		 * will then return without clearing.
> > +		 *
> > +		 * When @ptrace:
> > +		 *
> > +		 * Stopped state is per-task and thus can't change once the
> > +		 * target task dies, so notask_error should be cleared only
> > +		 * if WCONTINUED is set.
> > +		 */
> > +		if (likely(!ptrace) || (wo->wo_flags & WCONTINUED))
> > +			wo->notask_error = 0;
> 
> I don't understand this part. Suppose that this task is not traced and
> its real parent does do_wait(WEXITED). We shouldn't return -ECHLD in
> this case (EXIT_ZOMBIE && delay_group_leader()).
> 
> If the task is traced and debugger does do_wait(WEXITED) we should not
> return -ECHLD too.
> 
> So I think this patch is wrong in its current state. Hmm, I just noticed
> the comment says "If WEXITED is set, notask_error should ...", but this
> is not what the code does?

That comment is for !@ptrace, so the code and comment are in sync, but
yes, if WEXITED is set, notask_error better be cleared regardless of
@ptrace.

> But the main problem is, I do not think do_wait() should block in this
> case, and thus I am starting to think this patch is not "complete".
> 
> I mean, we are going to add the user-visible change, and I agree the
> current behaviour looks strange. But if we change this code, perhaps
> the tracer should ignore delay_group_leader() at all (unless we are
> going to do wait_task_zombie) ?
> 
> Your test-case could use waitid(WEXITED) instead WSTOPPED with the same
> result, it should hang. Why it hangs? The tracee is dead, we can't do
> ptrace(PTRACE_DETACH), and we can do nothing until other threads exit.
> This looks equally strange.
> 
> IOW. Assuming that ptrace == T and WEXITED is set, perhaps we should
> do something like this pseudo-code
> 
> 	if (p->exit_state == EXIT_ZOMBIE) {
> 		if (!delay_group_leader(p))
> 			return wait_task_zombie(wo, p);
> 
> 		ptrace_unlink();
> 		wait_task_zombie(WNOWAIT);
> 	}
> 
> However. This is another user-visible change, we need another discussion
> even if I am right. In particular, it is not clear what should we do
> if parent == real_parent. And probably this can confuse gdb, but iirc
> gdb already have the problems with the dead leader anyway.

Interesting point.  Yeah, I agree.  wait(WEXITED) from the ptracer
should only wait for the tracee itself, not the group.  When they are
one and the same, I don't think we need to do anything differently
from now.

If we change the behavior that way, it would also fit better with the
rest of the new behavior where the real parent and ptracer have
separate roles when wait(2)ing for stopped states.

The question is how the change would affect the existing users.  When
the debugee is a direct child, nothing will change.  When attaching to
a separate group, I don't think it even matters.  Does gdb handle
group leader any differently from the rest when attached to an
unrelated group?

Thanks.

-- 
tejun
