Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965704Ab2B1QFa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 11:05:30 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:43639 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964917Ab2B1QF2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 11:05:28 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.180.84.170 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <4F4CB89C.4060500@redhat.com>
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
 <alpine.LFD.2.02.1202211340330.5354@i5.linux-foundation.org> <4F4CB89C.4060500@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 28 Feb 2012 08:05:07 -0800
X-Google-Sender-Auth: gXiPqkxNvTEQ2ajNovKcEH2bUGQ
Message-ID: <CA+55aFwKJspohPdmbzXZzN4xtNU1Sz0RMA9AfTLnoRWgpPGzHg@mail.gmail.com>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 3:21 AM, Avi Kivity <avi@redhat.com> wrote:
>
> Can you elaborate on what you don't like in the kvm code (apart from "it
> does virtualiztion")?

It doesn't fit any of the patterns of the x87 save/restore code, and I
don't know what it does.

It does clts on its own, in random places without actually restoring
the FPU state. Why is that ok? I don't know. And I don't think it is,
but I didn't change any of it. Why doesn't that thing corrupt the lazy
state save of some other process, for example?

Doing a "clts()" without restoring the FPU state immediately
afterwards is fundamentally *wrong*. It's crazy. Insane. You can now
use the FPU, but with whatever random state that is in it that caused
TS to be set to begin with.

And if you don't have any FPU state to restore, because you want to
use your own kernel state, you should use the
"kernel_fpu_begin()/end()" things that we have had forever.

Here's an example of the kind of UTTER AND ABSOLUTE SHIT that kvm FPU
state restore is:

  static void emulator_get_fpu(struct x86_emulate_ctxt *ctxt)
  {
        preempt_disable();
        kvm_load_guest_fpu(emul_to_vcpu(ctxt));
        /*
         * CR0.TS may reference the host fpu state, not the guest fpu state,
         * so it may be clear at this point.
         */
        clts();
  }

that whole "comment" says nothing at all. And clearing CR0.TS *after*
loading the FPU state is a f*cking joke, since you need it clear to
load the FPU state to begin with. So as far as I can tell,
kvm_load_guest_fpu() will have cleared the FPU state already, but *it*
did it by:

        unlazy_fpu(current);
        fpu_restore_checking(&vcpu->arch.guest_fpu);

where "unlazy_fpu()" will have *set* TS if it wasn't set before, so
fpu_restore_checking() will now TAKE A FAULT, and in that fault
handler it will clear TS so that it can reload the state we just saved
(yes, really), only to then return to fpu_restore_checking() and
reload yet *another* state.

The code is crap. It's insane. It may work, but if it does, it does so
by pure chance and happenstance. The code is CLEARLY INSANE.

I wasn't going to touch it. It had been written by a
random-code-generator that had strung the various FPU accessor
functions up in random order until it compiled.

                  Linus
