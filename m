Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab2ACTST (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 14:18:19 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:48027 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754725Ab2ACTSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 14:18:14 -0500
Date: Tue, 3 Jan 2012 11:18:08 -0800
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
        Denys Vlasenko <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org,
        =?utf-8?Q?=C5=81ukasz?= Michalik <lmi@ift.uni.wroc.pl>,
        "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: ptrace fixes for 3.2
Message-ID: <20120103191808.GF31746@google.com>
References: <201112281955.55200.vda.linux@googlemail.com>
 <20111229113245.GA18062@redhat.com>
 <20111229120506.GA23653@redhat.com>
 <20120103142941.GA25488@redhat.com>
 <20120103154404.GA28930@redhat.com>
 <20120103163023.GA31746@google.com>
 <20120103170927.GA31795@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120103170927.GA31795@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jan 03, 2012 at 06:09:27PM +0100, Oleg Nesterov wrote:
> > > The offending commit is 823b018e which moved the EXIT_DEAD check,
> > > but in fact we should not blame it. The original code was not
> > > correct as well because it didn't take ptrace_reparented() into
> > > account and because we can't really trust ->ptrace.
> > >
> > > This patch adds the additional check to close this particular
> > > race but it doesn't solve the whole problem. We simply can't
> > > rely on ->ptrace in this case, it can be cleared if the tracer
> > > is multithreaded by the exiting ->parent.
> >
> > I'm not following this part.  Can you please explain it in a bit more
> > detail?
> 
> Before 823b018e the code was:
> 
> 	if (!ptrace && p->ptrace) {
> 		wo->notask_error = 0;
> 		return 0;
> 	}
> 
> 	if (p->exit_state == EXIT_DEAD)
> 		return 0;
> 
> There are 2 problems:
> 
> 	1. it is not correct to clear ->notask_error unless
> 	   this child is ptrace_reparented(). Nobody will
> 	   wakeup us if EXIT_DEAD was set by our sub-thread.

Yeah, if that happens between normal and ptrace wait_consider_task()
calls.

> 	2. We can not rely on ->ptrace to detect this case.
> 
> 	   Suppose that the tracer is multithreaded, it has
> 	   two threads T1 and T2, T1 traces our child.
> 
> 	   - T2 does do_wait(WEXITED), sets EXIT_DEAD, drops
> 	     tasklist_lock.
> 
> 	   - T1 exits and does __ptrace_detach(), this means
> 	     __ptrace_unlink() and nothing more.
> 
> 	   - Now, real_parent does do_wait() and sees the
> 	     EXIT_DEAD child but ->ptrace = 0.
> 
> 	   - finally T2 sets EXIT_DEAD but it is too late,

You mean EXIT_ZOMBIE here, right?  So, to rephrase, ZOMBIE -> DEAD ->
ZOMBIE dancing may race against tracer detaching.  Urgh... why do we
even allow tasks which aren't the direct tracer to wait for ptraced
children anyway when ptrace ops are restricted to the ptracing task?

> > > Also, I think wait_consider_task() needs more fixes. I do not
> > > think we should clear ->notask_error without WEXITED in this
> > > case, but this is what we do in the EXIT_ZOMBIE case.
> >
> > Hmmm... I'm not sure about that.  Why do you think so?
> 
> I am not sure too. But why do_wait() should sleep if it is called
> without WEXITED (lets ignore WCONTINUED) and the child is ZOMBIE?
> I think it should return -ECHILD, like it does if the child is not
> traced.
> 
> IOW. Suppose we have a single EXIT_ZOMBIE child. If it is not traced,
> do_wait(WSTOPPED) returns -ECHILD. If the child is traced (by another
> process) do_wait() sleeps until detach just to return the same error.
> This looks a bit strange.

I don't think it really matter either way.  To me, both behaviors seem
understandable and I don't think the current behavior would cause any
real problem.

Thanks a lot for the explanation.

-- 
tejun
