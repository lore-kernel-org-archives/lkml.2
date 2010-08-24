Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040Ab0HXF4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 01:56:13 -0400
Received: from ozlabs.org ([203.10.76.45]:46374 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753935Ab0HXF4J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 01:56:09 -0400
From: Michael Neuling <mikey@neuling.org>
To: Eric Paris <eparis@redhat.com>
cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, anton@samba.org, sgrubb@redhat.com
Subject: Re: [PATCH] audit: speedup for syscalls when auditing is disabled
In-reply-to: <1282621410.26616.406.camel@localhost.localdomain>
References: <29151.1282270393@neuling.org> <1282586177.2681.43.camel@localhost.localdomain> <20887.1282615880@neuling.org> <1282621410.26616.406.camel@localhost.localdomain>
Comments: In-reply-to Eric Paris <eparis@redhat.com>
   message dated "Mon, 23 Aug 2010 23:43:30 -0400."
X-Mailer: MH-E 8.2; nmh 1.3; GNU Emacs 23.1.1
Date: Tue, 24 Aug 2010 15:56:08 +1000
Message-ID: <6003.1282629368@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > On reflection, we might have a bug in audit_alloc though.  Currently we
> > have this:
> > 
> >   int audit_alloc(struct task_struct *tsk)
> >   {
> > 	  <snip>
> > 	  state = audit_filter_task(tsk, &key);
> > 	  if (likely(state == AUDIT_DISABLED))
> > 		  return 0;
> > 
> > 	  <snip>
> > 	  set_tsk_thread_flag(tsk, TIF_SYSCALL_AUDIT);
> > 	  return 0;
> >   }
> > 
> > This gets called on fork.  If we have "task,never" rule, we hit this
> > state == AUDIT_DISABLED path, return immediately and the tasks
> > TIF_SYSCALL_AUDIT flags doesn't get set.  On powerpc, we check
> > TIF_SYSCALL_AUDIT in asm on syscall entry to fast path not calling the
> > syscall audit code.
> 
> I'm guessing it actually bypasses audit if the flag is not set?  

Correct.

> So we might have a bug, but i'd be surprised since I think we tested
> audit on powerpc....

So on powerpc we have this in entry_64.S

#define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
#define _TIF_SYSCALL_T_OR_A (_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP)

	andi.	r11,r10,_TIF_SYSCALL_T_OR_A
	bne-	syscall_dotrace

and there is similar code in x86 in entry_64.S

#ifdef CONFIG_AUDITSYSCALL
	bt $TIF_SYSCALL_AUDIT,%edx
	jc sysret_audit
#endif

So I think other archs are broken too.

I think the bug is in the generic code though.  Shouldn't syscall
auditing be enabled independent of task fork/exec auditing?

> > This seems wrong to me as a "never" _task_ audit rule shouldn't effect
> > _syscall_ auditing?  Is there some interaction between task and syscall
> > auditing that I'm missing?
> 
> There are 3 states for a given task, I don't remember the names off the
> top of my head, so I'll guess with: on, off, build.  'Build' is the
> state most processes usually live in.  In this state we collect audit
> information about the task during the whole syscall and then we might
> (likely) throw that information away at syscall exit.
> 
> Some types of audit rule, which alter this state, can be checked at
> either 'entry' or 'exit' (first rule wins) At syscall entry we only have
> enough information (questionable if we even have enough information at
> all but that's a different question) to filter based on the task.  You
> can create rules that will audit all tasks, or in your case will
> explicitly disable auditing for all tasks.

So does this mean that an "auditctl -a task,never" _should_ disable
syscall auding?  I'm not 100% clear on this still.  

> Normally a process would be in the default 'build' state after syscall
> entry, we will collect information about the syscall, and then we will
> check syscall rules at exit.  Once you explicitly say 'I do not want any
> audit messages for this task' you are in 'off' instead of 'build.'

Ok

> > > I wonder if you could get much back, in terms of performance, by moving
> > > the
> > >          context->dummy = !audit_n_rules;
> > > line to the top and just returning if context->dummy == 1;
> > 
> > We get 668.09 cycles with this optimisation, so it comes down a bit, but
> > no where near if the auditing is disabled altogether.
> 
> Clean that patch up and send it.  Sounds like a win no matter what else
> we do.

Ok, sending in separate email.

> > Like I said above, powerpc has a fast path in asm on system call entry
> > to check the thread_info flags for if syscall auditing is disabled.  If
> > it's disabled, we don't call the audit code, hence why it's very fast in
> > this case.
> 
> Here's a new idea to think about with obvious tradeoffs.  What do you
> think about doing a little bit of assembly rejiggering?
> 
> Add a new spot in the assembly which will call a function which will
> check if audit_n_rules > 0 and if so will set TIF_SYSCALL_AUDIT and if
> not will clear TIF_SYSCALL_AUDIT?  It might make things slightly worse
> on systems which explictly disable audit and the flag would always be
> clear on every task (like you did with the explicit rule) but I'm
> guessing might be a win on systems with no rules which are wasting time
> on the audit slow path.....

This sounds good to me except for one thing...

If we set TIF_SYSCALL_AUDIT when audit_n_rules > 0, it'll change the
functionality from what we have now in the "auditctl -a task,never"
case.  Currently in this case, TIF_SYSCALL_AUDIT will not be set and
syscalls won't be audited.  I think this is a bug (as discussed above),
but I wanted to point it out anyway.

Anyway, I'll take a stab at this in a bit.

Regards,
Mikey
	
