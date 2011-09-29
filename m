Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546Ab1I2LwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 07:52:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076Ab1I2LwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 07:52:08 -0400
Date: Thu, 29 Sep 2011 13:48:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stephen Wilson <wilsons@start.ca>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Johannes Weiner <jweiner@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Q: proc: hold cred_guard_mutex in check_mem_permission()
Message-ID: <20110929114827.GA9279@redhat.com>
References: <20110928202020.GA3164@redhat.com> <20110929071314.GA7734@wicker.gateway.2wire.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110929071314.GA7734@wicker.gateway.2wire.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29, Stephen Wilson wrote:
>
> On Wed, Sep 28, 2011 at 10:20:20PM +0200, Oleg Nesterov wrote:
> > Another change we probably need to backport, 18f661bc
> > "proc: hold cred_guard_mutex in check_mem_permission()".
> >
> > From the changelog:
> >
> >     Avoid a potential race when task exec's and we get a new ->mm but
> >     check against the old credentials in ptrace_may_access().
> >
> > Could you please explain? How can we race with exec?
>
> My understanding of the race is this:
>
> sequence during execve():
>
> 	1) cred_guard_mutex is taken in prepare_bprm_creds()
> 	2) new mm is installed via exec_mmap()
> 	3) new creds are pushed via install_exec_creds() which releases
> 	   cred_guard_mutex
>
> so if we get_task_mm() and ptrace_may_access() between 2 and 3 we
> obtain a reference to the new mm validated against old creds.
>
> Perhaps (the fairly old) commit 704b836c helps?

Yes, and that is why I sent 704b836c ;)

But, check_mem_permission() can't race with exec, that was my point.
The task is stopped (it is TASK_TRACED), it can't run unless SIGKILL'ed.
It can not change its mm/creds.

> > This task is either current, or it is TASK_TRACED and we are the
> > tracer. In the latter case nobody can resume it except SIGKILL.
> > And the killed task obviously can't exec.
> >
> > Afaics, all we need is: we should read task->mm after the
> > task_is_traced() check, we do not need the mutex.
>
> Checking ptrace_parent() against current was introduced in 0d094efeb,

not actually, this is very old check, probably since 2.4.0 at least.
That patch only renames the helper we use.

> but the
> commit message gives no clue as to why the check was added.

Only debugger can read/write the task's memory. May be we can relax
this, perhaps we can only check ptrace_may_access(PTRACE_MODE_ATTACH).

But currently we require the caller should trace the target.

> > IOW, what do you think about the patch below? I have no idea how
> > can I test it (and it wasn't even applied/compiled).
> >
> > Also, I'd appreciate if you can explain the PTRACE_MODE_ATTACH
> > check. Again, we are already the tracer.
>
> If we are the tracer then that ptrace_may_access() check is redundant and the
> whole race thing is a non-issue, right?

Yes.

> But perhaps the correct move is to
> relax the restriction that current be the tracer.

Yes, I thought about this too. And in this case we do need the mutex.
Although I don't think this really makes sense, I _think_ this all was
created for debuggers. And, without ptrace_parent(), why do we need
task_is_stopped_or_traced() check?

So I think we should simply remove ->cred_guard_mutex.

Oleg.

