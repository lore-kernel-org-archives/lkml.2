Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965926Ab2B1SJn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 13:09:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965737Ab2B1SJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 13:09:41 -0500
Message-ID: <4F4D1857.4010706@redhat.com>
Date: Tue, 28 Feb 2012 20:09:27 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Josh Boyer <jwboyer@gmail.com>,
        Jongman Heo <jongman.heo@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 2/2] i387: split up <asm/i387.h> into exported and internal
 interfaces
References: <alpine.LFD.2.02.1202191412060.3898@i5.linux-foundation.org> <alpine.LFD.2.02.1202201147350.4237@i5.linux-foundation.org> <alpine.LFD.2.02.1202201148100.4237@i5.linux-foundation.org> <CA+5PVA5Zkka6Q2kcvWbvA3xr9=5TZ+VWWsWzYcRQ1GpccpJHew@mail.gmail.com> <CA+55aFyqz-2ejsRpbRdYx7UHDBg3q=9nvmtrj2nLeuZonrkz1A@mail.gmail.com> <4F42FE08.5020309@zytor.com> <CA+55aFxKLvHXRkx-x+zOkHJk__uTJc90Z0i+00W-hqDaQb_HCQ@mail.gmail.com> <4F43DB69.9060509@zytor.com> <CA+55aFxap0zAAJOCcz0f+DKBuG6VQa7kq1j2JD1S4ysgmb62aA@mail.gmail.com> <4F440945.1020904@zytor.com> <alpine.LFD.2.02.1202211338420.5354@i5.linux-foundation.org> <alpine.LFD.2.02.1202211339590.5354@i5.linux-foundation.org> <alpine.LFD.2.02.1202211340330.5354@i5.linux-foundation.org> <4F4CB89C.4060500@redhat.com> <CA+55aFwKJspohPdmbzXZzN4xtNU1Sz0RMA9AfTLnoRWgpPGzHg@mail.gmail.com> <4F4D0D18.4060409@redhat.com> <CA+55aFyA=b-27XbhGdDQfSRMk=xet2jOD9H8hkjEq1md29bJJA@mail.gmail.com>
In-Reply-To: <CA+55aFyA=b-27XbhGdDQfSRMk=xet2jOD9H8hkjEq1md29bJJA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2012 07:37 PM, Linus Torvalds wrote:
> On Tue, Feb 28, 2012 at 9:21 AM, Avi Kivity <avi@redhat.com> wrote:
> >
> > What you described is the slow path.
>
> Indeed. I'd even call it the "glacial and stupid" path.

Right.  It won't be offended, since it's almost never called.

> >The fast path is
> >
> >  void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
> >  {
> >      if (vcpu->guest_fpu_loaded)
> >          return;
> >
> > If we're emulating an fpu instruction, it's very likely that we have the
> > guest fpu loaded into the cpu.  If we do take that path, we have the
> > right fpu state loaded, but CR0.TS is set by the recent exit, so we need
> > to clear it (the comment is in fact correct, except that it misspelled
> > "set").
>
> So why the hell do you put the clts in the wrong place, then?

You mean, why not in kvm_load_guest_fpu()?  Most of the uses of
kvm_load_guest_fpu() are just before guest entry, so the clts() would be
immediately overwritten by the loading of the GUEST_CR0 register (which
may have TS set or clear).  So putting it here would be wasting cycles.

>
> Dammit, the code is crap.
>
> The clts's are in random places, they don't make any sense, the
> comments are *wrong*, and the only reason they exist in the first
> place is exactly the fact that the code does what it does in the wrong
> place.
>
> There's a reason I called the code crap. It makes no sense. Your
> explanation only explains what it does (badly) when what *should* have
> happened is you saying "ok, that makes no sense, let's fix it up".
>
> So let me re-iterate: it makes ZERO SENSE to clear clts *after*
> restoring the state. Don't do it. Don't make excuses for doing it.
> It's WRONG. Whether it even happens to work by random chance isn't
> even the issue.
>
> Where it *can* make sense to clear TS is in your code that says
>
> >      if (vcpu->guest_fpu_loaded)
> >          return;
>
> where you could have done it like this:
>
>     /* If we already have the FPU loaded, just clear TS - it was set
> by a recent exit */
>     if (vcpu->guest_fpu_loaded) {
>         clts();
>         return;
>     }
>
> And then at least the *placement* of clts would make sense. 

True, it's cleaner, but as noted above, it's wasteful.

> HOWEVER.
> Even if you did that, what guarantees that the most recent FP usage
> was by *your* kvm process? Sure, the "recent exit" may have set TS,
> but have you had preemption disabled for the whole time? Guaranteed?

Both the vcpu_load() and emulation paths happen with preemption disabled.

> Because TS may be set because something else rescheduled too.
>
> So where's the comment about why you actually own and control CR0.TS,
> and nobody else does?

The code is poorly commented, yes.

> Finally, how does this all interact with the fact that the task
> switching now keeps the FPU state around in the FPU and caches what
> state it is? I have no idea, because the kvm code is so inpenetratable
> due to all these totally unexplained things.

This is done by preempt notifiers.  Whenever a task switch happens we
push the guest fpu state into memory (if loaded) and let the normal
stuff happen.  So the if we had a task switch during instruction
emulation, for example, then we'd get the "glacial and stupid path" to fire.

> Btw, don't get me wrong - the core FPU state save/restore was a mess
> of random "TS_USEDFPU" and clts() crap too. We had several bugs there,
> partly exactly because the core FPU restore code also had "clts()"
> separated from the logic that actually set or cleared the TS_USEDFPU
> bit, and it was not at all clear at a "local" setting what the F was
> going on.
>
> Most of the recent i387 changes were actually to clean up and make
> sense of that thing, and making sure that the clts() was paired with
> the action of actually giving the FPU to the thread etc. So at least
> now the core FPU handling is reasonably sane, and the clts's and
> stts's are paired with the things that take control of the FPU, and we
> have a few helper functions and some abstraction in place.
>
> The kvm code definitely needs the same kind of cleanup. Because as it
> is now, it's just random code junk, and there is no obvious reason why
> it wouldn't interact horribly badly with an interrupt doing
> "irq_fpu_usable()" + "kernel_fpu_begin/end()" for example.

Well, interrupted_kernel_fpu_idle() does look like it returns the wrong
result when kvm is active.  Has the semantics of that changed in the
recent round?  The kvm fpu code is quite old and we haven't had any
reports of bad interactions with RAID/encryption since it was stabilized.

> Seriously.

I agree a refactoring is needed.  We may need to replace read_cr0() in

  static inline bool interrupted_kernel_fpu_idle(void)
  {
    return !(current_thread_info()->status & TS_USEDFPU) &&
        (read_cr0() & X86_CR0_TS);
  }

with some percpu variable since CR0.TS is not reliable in interrupt
context while kvm is running.

-- 
error compiling committee.c: too many arguments to function

