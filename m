Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875Ab2B1Rh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 12:37:58 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:50366 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052Ab2B1Rh4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 12:37:56 -0500
MIME-Version: 1.0
In-Reply-To: <4F4D0D18.4060409@redhat.com>
References: <alpine.LFD.2.02.1202191412060.3898@i5.linux-foundation.org>
 <alpine.LFD.2.02.1202201145130.4237@i5.linux-foundation.org>
 <alpine.LFD.2.02.1202201146450.4237@i5.linux-foundation.org>
 <alpine.LFD.2.02.1202201147350.4237@i5.linux-foundation.org>
 <alpine.LFD.2.02.1202201148100.4237@i5.linux-foundation.org>
 <CA+5PVA5Zkka6Q2kcvWbvA3xr9=5TZ+VWWsWzYcRQ1GpccpJHew@mail.gmail.com>
 <CA+55aFyqz-2ejsRpbRdYx7UHDBg3q=9nvmtrj2nLeuZonrkz1A@mail.gmail.com>
 <4F42FE08.5020309@zytor.com> <CA+55aFxKLvHXRkx-x+zOkHJk__uTJc90Z0i+00W-hqDaQb_HCQ@mail.gmail.com>
 <4F43DB69.9060509@zytor.com> <CA+55aFxap0zAAJOCcz0f+DKBuG6VQa7kq1j2JD1S4ysgmb62aA@mail.gmail.com>
 <4F440945.1020904@zytor.com> <alpine.LFD.2.02.1202211338420.5354@i5.linux-foundation.org>
 <alpine.LFD.2.02.1202211339590.5354@i5.linux-foundation.org>
 <alpine.LFD.2.02.1202211340330.5354@i5.linux-foundation.org>
 <4F4CB89C.4060500@redhat.com> <CA+55aFwKJspohPdmbzXZzN4xtNU1Sz0RMA9AfTLnoRWgpPGzHg@mail.gmail.com>
 <4F4D0D18.4060409@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 28 Feb 2012 09:37:34 -0800
X-Google-Sender-Auth: BDmIdauJXv9OLDDzTYj1UCWd490
Message-ID: <CA+55aFyA=b-27XbhGdDQfSRMk=xet2jOD9H8hkjEq1md29bJJA@mail.gmail.com>
Subject: Re: [PATCH 2/2] i387: split up <asm/i387.h> into exported and
 internal interfaces
To: Avi Kivity <avi@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Josh Boyer <jwboyer@gmail.com>,
        Jongman Heo <jongman.heo@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 9:21 AM, Avi Kivity <avi@redhat.com> wrote:
>
> What you described is the slow path.

Indeed. I'd even call it the "glacial and stupid" path.

>The fast path is
>
>  void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
>  {
>      if (vcpu->guest_fpu_loaded)
>          return;
>
> If we're emulating an fpu instruction, it's very likely that we have the
> guest fpu loaded into the cpu.  If we do take that path, we have the
> right fpu state loaded, but CR0.TS is set by the recent exit, so we need
> to clear it (the comment is in fact correct, except that it misspelled
> "set").

So why the hell do you put the clts in the wrong place, then?

Dammit, the code is crap.

The clts's are in random places, they don't make any sense, the
comments are *wrong*, and the only reason they exist in the first
place is exactly the fact that the code does what it does in the wrong
place.

There's a reason I called the code crap. It makes no sense. Your
explanation only explains what it does (badly) when what *should* have
happened is you saying "ok, that makes no sense, let's fix it up".

So let me re-iterate: it makes ZERO SENSE to clear clts *after*
restoring the state. Don't do it. Don't make excuses for doing it.
It's WRONG. Whether it even happens to work by random chance isn't
even the issue.

Where it *can* make sense to clear TS is in your code that says

>      if (vcpu->guest_fpu_loaded)
>          return;

where you could have done it like this:

    /* If we already have the FPU loaded, just clear TS - it was set
by a recent exit */
    if (vcpu->guest_fpu_loaded) {
        clts();
        return;
    }

And then at least the *placement* of clts would make sense. HOWEVER.
Even if you did that, what guarantees that the most recent FP usage
was by *your* kvm process? Sure, the "recent exit" may have set TS,
but have you had preemption disabled for the whole time? Guaranteed?

Because TS may be set because something else rescheduled too.

So where's the comment about why you actually own and control CR0.TS,
and nobody else does?

Finally, how does this all interact with the fact that the task
switching now keeps the FPU state around in the FPU and caches what
state it is? I have no idea, because the kvm code is so inpenetratable
due to all these totally unexplained things.

Btw, don't get me wrong - the core FPU state save/restore was a mess
of random "TS_USEDFPU" and clts() crap too. We had several bugs there,
partly exactly because the core FPU restore code also had "clts()"
separated from the logic that actually set or cleared the TS_USEDFPU
bit, and it was not at all clear at a "local" setting what the F was
going on.

Most of the recent i387 changes were actually to clean up and make
sense of that thing, and making sure that the clts() was paired with
the action of actually giving the FPU to the thread etc. So at least
now the core FPU handling is reasonably sane, and the clts's and
stts's are paired with the things that take control of the FPU, and we
have a few helper functions and some abstraction in place.

The kvm code definitely needs the same kind of cleanup. Because as it
is now, it's just random code junk, and there is no obvious reason why
it wouldn't interact horribly badly with an interrupt doing
"irq_fpu_usable()" + "kernel_fpu_begin/end()" for example.

Seriously.

              Linus
