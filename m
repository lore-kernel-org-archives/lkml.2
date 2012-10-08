Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab2JHQOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 12:14:49 -0400
Received: from ns2.allidaho.com ([66.232.90.194]:43661 "EHLO mail.allidaho.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750857Ab2JHQOp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 12:14:45 -0400
X-Greylist: delayed 1364 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Oct 2012 12:14:45 EDT
From: "Dialup Jon Norstog" <thursday@allidaho.com>
To: Al Viro <viro@ZenIV.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>
Cc: dl8bcu@dl8bcu.de, peterz@infradead.org, mingo@kernel.org,
        linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        Matt Turner <mattst88@gmail.com>
Subject: Re: [regression] boot failure on alpha, bisected
Date: Mon, 8 Oct 2012 08:14:17 -0600
Message-Id: <20121008140948.M96290@allidaho.com>
In-Reply-To: <20121007193909.GK2616@ZenIV.linux.org.uk>
References: <20121006204736.GA1830@ds20.borg.net> <20121007165534.GA8024@redhat.com> <20121007170850.GJ2616@ZenIV.linux.org.uk> <20121007173336.GA14804@redhat.com> <20121007193909.GK2616@ZenIV.linux.org.uk>
X-Mailer: OpenWebMail 2.52 20061019
X-OriginatingIP: 67.206.185.50 (thursday)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!  I'm an Alpha user - I just want to thank you ll for working to keep
Linux current on this architecture.  I am still using the last working Alpha
Core release ... I hope to keep the old beast running for many more years!

Jon Norstog

www.thursdaybicycles.com


On Sun, 7 Oct 2012 20:39:09 +0100, Al Viro wrote
> On Sun, Oct 07, 2012 at 07:33:36PM +0200, Oleg Nesterov wrote:
> 
> > > Um...  There's a bunch of architectures that are in the same situation.
> > > grep for do_notify_resume() and you'll see...
> > 
> > And every do_notify_resume() should be changed anyway, do_signal() and
> > tracehook_notify_resume() should be re-ordered.
> 
> There's a bit more to it.  The thing is, we have quite a mess around
> the signal-handling loops, mixed with that regarding the signal restarts.
> On arm it's done about right by now:
> 	* looping until all signals had been handled is done in C;
> none of that "loop in asm glue" nonsense anymore.
> 	* prevention of double restarts is *also* there, TYVM.
> 	* do_work_pending() is called with interrupts disabled.
> It may return 0, in which case we are done, interrupts are disabled
> and the caller should proceed to userland without reenabling them
> until it leaves.  Otherwise we have a syscall restart to handle and
> no userland signal handler had been invoked.  Interrupts are enabled
> and we should simply reload arguments and syscall number from pt_regs
> and proceed to syscall entry, without returning to userland.  The 
> only twist is that negative return value means ERESTART_RESTARTBLOCK 
> kind of restart, in which case we need to use __NR_restart_syscall 
> for syscall number.
> 
> Note that we do *not* go through return to userland and reentering 
> the kernel on handlerless syscall restarts.  S390 uses the same 
> model, but there it's done in assembler glue - for no good reason. 
>  Should be in straight C.
> 
> For alpha there's another twist, though - there we do _not_ save all
> registers in pt_regs; there's a fairly large chunk of callee-saved
> registers we don't need to protect from being messed by C parts of
> the kernel.  We do need to save them in sigcontext, though.  So alpha
> (and quite a few other architctures) has separate struct switch_stack
> 
> (named so since switch_to() needs to save/restore the same registers)
> . Rules: 	* on fork() et.al. we save those callee-saved registers in 
> struct switch_stack, right next to pt_regs.  We do that before 
> calling the actual sys_fork() and have copy_thread() copy these guys 
> into child.  Remember that newborns are first woken up in ret_from_fork
> and as with all context switches they go through switch_to().  So these
> registers are restored by the time the sucker wakes up.
> 	* on signal delivery we save those registers in struct switch_stack
> and use it, along with pt_regs it lives next to, to fill sigcontext.
> 	* ptrace counts on those suckers being next to pt_regs.  That allows
> tracer to modify tracee's registers, including callee-saved ones.  
> So we
> (1) restore them from switch_stack once we are done with do_signal() 
> and
> (2) save/restore them around another place where we can get stopped for
> tracer to examine us - PTRACE_SYSCALL-induced paths in syscall handling.
> 	* on sigreturn/rt_sigreturn we need to restore all registers.
> So we reserve switch_stack on stack, next to pt_regs and have the C 
> part of sigreturn fill those along with pt_regs.  Once we are done,
>  read those registers from switch_stack.
> 
> That's more or less it; many other architectures are doing more or less
> similar things, but not all of them put that stuff into separate structure.
> 
> E.g. another valid solution is to leave space in pt_regs, fill only 
> a subset on entry and have switch_to() save stuff in task_struct 
> instead of putting it on kernel stack.
> 
> What it means for us is that saving all that crap on stack should *not*
> be done unless we have work to do.  OTOH, in situations when we have
> more than one pending signal it's bloody dumb to save/restore around
> each do_notify_resume() call separately.  OTTH, in situation when 
> we'd run out of timeslice and had nothing arrive until we'd regained 
> CPU save/restore around schedule() is pointless at the very least. 
>  So for things like alpha I'd do this:
> 
> 	interrupts disabled
> 	check thread flags
> 	no work to do => bugger off to userland
> 	just NEED_RESCHED?
> 		schedule()
> 		reread thread flags
> 		no work to do => bugger off to userland
> 	save callee-saved registers
> 	call do_work_pending
> 	restore callee-saved registers
> 	if do_work_pendign returned 0 => bugger off to userland
> 	deal with handlerless restart
> 
> Note that the loop around do_signal() and friends is in C and is fairly
> similar to what we've got on ARM.  x86 is in intermediate situation -
> the main complication there is v86 crap.
> 
> I'd say that for now your variant should do, but we really need to 
> get that crap under control and out of asm glue.  Are you willing to 
> participate? Guys, we need a way to do cross-architecture work 
> without going insane. I've spent quite a bit of time this year 
> crawling through that stuff. And yes, it's getting better as the 
> result, but it's not sustainable - I have VFS work to do, after all.
> 
> Basically, we need more people willing to take part in that; ideally 
> - architecture maintainers, but some of them are semi-MIA.  The 
> areas involved: 	* kernel_thread()/kernel_execve()/sys_execve()
> /fork()/vfork()/clone() - quite a bit of that is already done and I 
> hope we'll regularize that crap in the coming cycle. 	* signal 
> handling in general - a lot got done this spring and summer, quite a 
> bit more is possible to unify.  I've got a long list of common 
> landmines not to step upon and unfortunately it's *very* common to have
> architectures step on a bunch of those.
> 	* syscall restarts - see above; note that e.g. prevention of
> double restarts and restarts on sigreturn is subtle, arch-dependent
> and had been broken on *many* architectures.  And I'm not at all sure
> we'd got all suckers fixed.
> 	* ptrace work, especially around PTRACE_SYSCALL handling.  I suspect
> that the right way to handle it is a new regset aliasing the normal 
> registers, so that access to syscall arguments would be arch-
> independent.  We can do that, and it would simplify the living hell 
> out of e.g. audit hookup. Another (and closely relate) thing is 
> conversion to tracehook_report_syscall_*; the tricky bit is that we 
> probably want a uniform semantics for things like modifying syscall 
> arguments via ptrace; some architectures do it right and reload 
> arguments and syscall number from pt_regs after they'd done 
> tracehook_report_syscall_entry(), but not all of them do.  Moreover, 
> we probably want to short-circuit the syscall itself when 
> PTRACE_CONT had been done with "and deliver SIGKILL to the tracee" 
> as e.g. x86, sparc and ppc do. 	* interplay between single-stepping 
> and syscall restarts.  Really, really nasty.  And needs involvement 
> of e.g. gdb people to sort out.
> 
> 	We really need that stuff sanely synchronized between architectures.
> I'm willing to keep participating in that work, but I can't do that alone.
> It's simply not survivable.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-
> alpha" in the body of a message to majordomo@vger.kernel.org More 
> majordomo info at  http://vger.kernel.org/majordomo-info.html


--
Open WebMail Project (http://openwebmail.org)

