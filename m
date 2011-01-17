Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab1AQX6g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 18:58:36 -0500
Received: from mail-fx0-f66.google.com ([209.85.161.66]:36161 "EHLO
	mail-fx0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215Ab1AQX6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 18:58:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=HzZ3Bkm/U6IpFANnFA9GMTvZfslZppMu6LadUBBAyp0BRH/Ec9GBVQhejBJBh4RY8i
         2APgmPoa65+D21hC1P+vwosXH02bEeCCTa9dyj0r6G04ExLu5t1nGoqk+167cG5Y96g1
         p6CDQ9iAC08YD2CFuZaPKNKpWkPvZy7VyA42g=
Date: Tue, 18 Jan 2011 00:58:30 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Prasad <prasad@linux.vnet.ibm.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Q: perf_event && task->ptrace_bps[]
Message-ID: <20110117235828.GE16856@nowhere>
References: <20101108145647.GA3426@redhat.com>
 <20101108184057.GB5375@nowhere>
 <20101108191813.GA15223@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101108191813.GA15223@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 08:18:13PM +0100, Oleg Nesterov wrote:
> On 11/08, Frederic Weisbecker wrote:
> >
> > On Mon, Nov 08, 2010 at 03:56:47PM +0100, Oleg Nesterov wrote:
> > > Hello.
> > >
> > > I am trying to understand the usage of hw-breakpoints in arch_ptrace().
> > > ptrace_set_debugreg() and related code looks obviously racy. Nothing
> > > protects us against flush_ptrace_hw_breakpoint() called by the dying
> > > tracee. Afaics we can leak perf_event or use the already freed memory
> > > or both.
> > >
> > > Am I missed something?
> > >
> > > Looking into the git history, I don't even know which patch should be
> > > blamed (if I am right), there were too many changes. I noticed that
> > > 2ebd4ffb6d0cb877787b1e42be8485820158857e "perf events: Split out task
> > > search into helper" moved the PF_EXITING check from find_get_context().
> > > This check coould help if sys_ptrace() races with SIGKILL, but it was
> > > racy anyway.
> > >
> > > It is not clear to me what should be done. Looking more, I do not
> > > understand the scope of perf_event/ctx at all, sys_perf_event_open()
> > > looks wrong too, see the next email I am going to send.
> > >
> > > Oleg.
> >
> > But I don't understand how ptrace_set_debugreg() and flush_old_exec() can
> > happen at the same time.
> 
> This can't happen. But I meant do_exit()->flush_ptrace_hw_breakpoint()
> 
> > The parent can only do the ptrace request when
> > the child is stopped, right?
> 
> Yes. But nothing can "pin" TASK_TRACED.
> 
> We know that a) the tracee was stopped() when sys_ptrace() was called
> and b) its task_struct can't go away. That is all. The tracee can be
> killed at any moment, and sys_ptrace() can race with with
> flush_ptrace_hw_breakpoint().

Aah, so we check if the task is stopped when sys_ptrace() is called,
but right after we do this check, the tracee can be resumed at any time?
(with either SIGCONT or SIGKILL), even if we are servicing the ptrace
request at the same time?

Seems to be so as I look at the code.
