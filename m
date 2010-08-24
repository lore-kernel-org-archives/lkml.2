Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab0HXUG6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 16:06:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755431Ab0HXUG4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 16:06:56 -0400
Subject: Re: [PATCH] audit: speedup for syscalls when auditing is disabled
From: Eric Paris <eparis@redhat.com>
To: Michael Neuling <mikey@neuling.org>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, anton@samba.org, sgrubb@redhat.com
In-Reply-To: <6003.1282629368@neuling.org>
References: <29151.1282270393@neuling.org>
	 <1282586177.2681.43.camel@localhost.localdomain>
	 <20887.1282615880@neuling.org>
	 <1282621410.26616.406.camel@localhost.localdomain>
	 <6003.1282629368@neuling.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 24 Aug 2010 16:06:45 -0400
Message-ID: <1282680405.13142.139.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-24 at 15:56 +1000, Michael Neuling wrote:
> > > On reflection, we might have a bug in audit_alloc though.  Currently we
> > > have this:
> > > 
> > >   int audit_alloc(struct task_struct *tsk)
> > >   {
> > > 	  <snip>
> > > 	  state = audit_filter_task(tsk, &key);
> > > 	  if (likely(state == AUDIT_DISABLED))
> > > 		  return 0;
> > > 
> > > 	  <snip>
> > > 	  set_tsk_thread_flag(tsk, TIF_SYSCALL_AUDIT);
> > > 	  return 0;
> > >   }
> > > 
> > > This gets called on fork.  If we have "task,never" rule, we hit this
> > > state == AUDIT_DISABLED path, return immediately and the tasks
> > > TIF_SYSCALL_AUDIT flags doesn't get set.  On powerpc, we check
> > > TIF_SYSCALL_AUDIT in asm on syscall entry to fast path not calling the
> > > syscall audit code.
> > 
> > I'm guessing it actually bypasses audit if the flag is not set?  
> 
> Correct.
> 
> > So we might have a bug, but i'd be surprised since I think we tested
> > audit on powerpc....
> 
> So on powerpc we have this in entry_64.S
> 
> #define _TIF_SYSCALL_AUDIT	(1<<TIF_SYSCALL_AUDIT)
> #define _TIF_SYSCALL_T_OR_A (_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP)
> 
> 	andi.	r11,r10,_TIF_SYSCALL_T_OR_A
> 	bne-	syscall_dotrace
> 
> and there is similar code in x86 in entry_64.S
> 
> #ifdef CONFIG_AUDITSYSCALL
> 	bt $TIF_SYSCALL_AUDIT,%edx
> 	jc sysret_audit
> #endif
> 
> So I think other archs are broken too.
> 
> I think the bug is in the generic code though.  Shouldn't syscall
> auditing be enabled independent of task fork/exec auditing?
> 
> > > This seems wrong to me as a "never" _task_ audit rule shouldn't effect
> > > _syscall_ auditing?  Is there some interaction between task and syscall
> > > auditing that I'm missing?
> > 
> > There are 3 states for a given task, I don't remember the names off the
> > top of my head, so I'll guess with: on, off, build.  'Build' is the
> > state most processes usually live in.  In this state we collect audit
> > information about the task during the whole syscall and then we might
> > (likely) throw that information away at syscall exit.
> > 
> > Some types of audit rule, which alter this state, can be checked at
> > either 'entry' or 'exit' (first rule wins) At syscall entry we only have
> > enough information (questionable if we even have enough information at
> > all but that's a different question) to filter based on the task.  You
> > can create rules that will audit all tasks, or in your case will
> > explicitly disable auditing for all tasks.
> 
> So does this mean that an "auditctl -a task,never" _should_ disable
> syscall auding?  I'm not 100% clear on this still.

Yes.  We only have one kind of auditing.  It audits what happens during
a syscall.  We have lots of different types of rules that tell the
kernel if we should actually send that info to userspace or not.  If we
hit a rule that says 'do not send anything to userspace' (like your
rule) the we should not send anything to userspace.  It does not matter
if some later rule would have sent it.  So given two rules like:

auditctl -a task,never
auditctl -a exit,always -S open

We hit the task,never rule first, so it wins.  We won't alloc a context,
we wont set the thread flag, we won't go slowly.  You can't get a task
out of this state.  If that task,never rule was removed and you created
a task it would get set up as 'build' and would at syscall exit match
the exit,always rule and the collected information would get dumped.
exit,* rules are a LOT more flexible than task,* rules (as exit,* rules
can match on things collected by the syscall whereas task,* rules can
only match on what we know at the beginning, pid, selinux context, uid,
etc.....)

My suggestion was to more liberaly clear the thread audit flag so we get
the assembly fastpath.  But this also requires that we set the flag when
appropriate.

-Eric

