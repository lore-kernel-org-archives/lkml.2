Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965939Ab2B1RWh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 12:22:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965889Ab2B1RVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 12:21:45 -0500
Message-ID: <4F4D0D18.4060409@redhat.com>
Date: Tue, 28 Feb 2012 19:21:28 +0200
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
References: <alpine.LFD.2.02.1202191412060.3898@i5.linux-foundation.org> <alpine.LFD.2.02.1202201145130.4237@i5.linux-foundation.org> <alpine.LFD.2.02.1202201146450.4237@i5.linux-foundation.org> <alpine.LFD.2.02.1202201147350.4237@i5.linux-foundation.org> <alpine.LFD.2.02.1202201148100.4237@i5.linux-foundation.org> <CA+5PVA5Zkka6Q2kcvWbvA3xr9=5TZ+VWWsWzYcRQ1GpccpJHew@mail.gmail.com> <CA+55aFyqz-2ejsRpbRdYx7UHDBg3q=9nvmtrj2nLeuZonrkz1A@mail.gmail.com> <4F42FE08.5020309@zytor.com> <CA+55aFxKLvHXRkx-x+zOkHJk__uTJc90Z0i+00W-hqDaQb_HCQ@mail.gmail.com> <4F43DB69.9060509@zytor.com> <CA+55aFxap0zAAJOCcz0f+DKBuG6VQa7kq1j2JD1S4ysgmb62aA@mail.gmail.com> <4F440945.1020904@zytor.com> <alpine.LFD.2.02.1202211338420.5354@i5.linux-foundation.org> <alpine.LFD.2.02.1202211339590.5354@i5.linux-foundation.org> <alpine.LFD.2.02.1202211340330.5354@i5.linux-foundation.org> <4F4CB89C.4060500@redhat.com> <CA+55aFwKJspohPdmbzXZzN4xtNU1Sz0RMA9AfTLnoRWgpPGzHg@mail.gmail.com>
In-Reply-To: <CA+55aFwKJspohPdmbzXZzN4xtNU1Sz0RMA9AfTLnoRWgpPGzHg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2012 06:05 PM, Linus Torvalds wrote:
> On Tue, Feb 28, 2012 at 3:21 AM, Avi Kivity <avi@redhat.com> wrote:
> >
> > Can you elaborate on what you don't like in the kvm code (apart from "it
> > does virtualiztion")?
>
> It doesn't fit any of the patterns of the x87 save/restore code, and I
> don't know what it does.

It tries to do two things: first, keep the guest fpu loaded while
running kernel code, and second, allow the instruction emulator to
access the guest fpu.

> It does clts on its own, in random places without actually restoring
> the FPU state. Why is that ok? I don't know. 

The way we use vmx, it does an implicit stts() after an exit from a
guest (it's not required, but it's expensive to play with the value of
the host cr0, so we set it to a safe value and clear it when needed). 
So sometimes we need these random clts()s.

> And I don't think it is,
> but I didn't change any of it. Why doesn't that thing corrupt the lazy
> state save of some other process, for example?
>
> Doing a "clts()" without restoring the FPU state immediately
> afterwards is fundamentally *wrong*. It's crazy. Insane. You can now
> use the FPU, but with whatever random state that is in it that caused
> TS to be set to begin with.

There are two cases.  In one of them, we do restore the guest fpu
immediately afterwards.  In the other, we're just clearing a CR0.TS that
was set spuriously.

> And if you don't have any FPU state to restore, because you want to
> use your own kernel state, you should use the
> "kernel_fpu_begin()/end()" things that we have had forever.

We do have state - the guest state.

> Here's an example of the kind of UTTER AND ABSOLUTE SHIT that kvm FPU
> state restore is:
>
>   static void emulator_get_fpu(struct x86_emulate_ctxt *ctxt)
>   {
>         preempt_disable();
>         kvm_load_guest_fpu(emul_to_vcpu(ctxt));
>         /*
>          * CR0.TS may reference the host fpu state, not the guest fpu state,
>          * so it may be clear at this point.
>          */
>         clts();
>   }
>
> that whole "comment" says nothing at all. And clearing CR0.TS *after*
> loading the FPU state is a f*cking joke, since you need it clear to
> load the FPU state to begin with. So as far as I can tell,
> kvm_load_guest_fpu() will have cleared the FPU state already, but *it*
> did it by:
>
>         unlazy_fpu(current);
>         fpu_restore_checking(&vcpu->arch.guest_fpu);
>
> where "unlazy_fpu()" will have *set* TS if it wasn't set before, so
> fpu_restore_checking() will now TAKE A FAULT, and in that fault
> handler it will clear TS so that it can reload the state we just saved
> (yes, really), only to then return to fpu_restore_checking() and
> reload yet *another* state.
>
> The code is crap. It's insane. It may work, but if it does, it does so
> by pure chance and happenstance. The code is CLEARLY INSANE.

What you described is the slow path.  The fast path is

  void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
  {
      if (vcpu->guest_fpu_loaded)
          return;

If we're emulating an fpu instruction, it's very likely that we have the
guest fpu loaded into the cpu.  If we do take that path, we have the
right fpu state loaded, but CR0.TS is set by the recent exit, so we need
to clear it (the comment is in fact correct, except that it misspelled
"set").

> I wasn't going to touch it. It had been written by a
> random-code-generator that had strung the various FPU accessor
> functions up in random order until it compiled.

The tried and tested way, yes.

-- 
error compiling committee.c: too many arguments to function

