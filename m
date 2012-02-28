Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757193Ab2B1S3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 13:29:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15522 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587Ab2B1S3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 13:29:20 -0500
Message-ID: <4F4D1CEF.20107@redhat.com>
Date: Tue, 28 Feb 2012 20:29:03 +0200
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
References: <alpine.LFD.2.02.1202191412060.3898@i5.linux-foundation.org> <alpine.LFD.2.02.1202201148100.4237@i5.linux-foundation.org> <CA+5PVA5Zkka6Q2kcvWbvA3xr9=5TZ+VWWsWzYcRQ1GpccpJHew@mail.gmail.com> <CA+55aFyqz-2ejsRpbRdYx7UHDBg3q=9nvmtrj2nLeuZonrkz1A@mail.gmail.com> <4F42FE08.5020309@zytor.com> <CA+55aFxKLvHXRkx-x+zOkHJk__uTJc90Z0i+00W-hqDaQb_HCQ@mail.gmail.com> <4F43DB69.9060509@zytor.com> <CA+55aFxap0zAAJOCcz0f+DKBuG6VQa7kq1j2JD1S4ysgmb62aA@mail.gmail.com> <4F440945.1020904@zytor.com> <alpine.LFD.2.02.1202211338420.5354@i5.linux-foundation.org> <alpine.LFD.2.02.1202211339590.5354@i5.linux-foundation.org> <alpine.LFD.2.02.1202211340330.5354@i5.linux-foundation.org> <4F4CB89C.4060500@redhat.com> <CA+55aFwKJspohPdmbzXZzN4xtNU1Sz0RMA9AfTLnoRWgpPGzHg@mail.gmail.com> <4F4D0D18.4060409@redhat.com> <CA+55aFyA=b-27XbhGdDQfSRMk=xet2jOD9H8hkjEq1md29bJJA@mail.gmail.com> <CA+55aFzzw3W0-e1sb0pKhu42TEojuLwkrDk0c-BksU-sjV-LNg@mail.gmail.com>
In-Reply-To: <CA+55aFzzw3W0-e1sb0pKhu42TEojuLwkrDk0c-BksU-sjV-LNg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2012 08:08 PM, Linus Torvalds wrote:
> On Tue, Feb 28, 2012 at 9:37 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > So where's the comment about why you actually own and control CR0.TS,
> > and nobody else does?
>
> So what I think KVM should strive for (but I really don't know the
> code, so maybe there are good reasons why it is impossible) is to just
> never touch TS at all, and let the core kernel code do it all for you.

Which TS?  With kvm (restricting ourselves to vmx at this moment) there
are three versions lying around: CR0.TS, GUEST_CR0.TS (which is loaded
by the cpu during entry into the guest) and HOST_CR0.TS (which is loaded
by the cpu during guest exit).  GUEST_CR0.TS is actually a combination
of the guest's virtualized CR0.TS, and a flag that says whether the
guest fpu is loaded or not.  HOST_CR0 is basically a cached CR0, but as
it's expensive to change it, we don't want to reflect CR0.TS into
HOST_CR0.TS.

> When you need access to the FPU, let the core code just handle it for
> you. Let it trap and restore the state. When you get scheduled away,
> let the core code just set TS, because you really can't touch the FP
> state again.
>
> IOW, just do the FP operations you do within the thread you are. Never
> touch TS at all, just don't worry about it. Worry about your own
> internal FP state machine, but don't interact with the "global" kernel
> TS state machine.

I can't avoid touching it.  On exit vmx will set it for me.  I can
atomically copy CR0.TS into HOST_CR0.TS, but that's expensive.

Maybe we should just virtualize it into a percpu variable.  Should speed
up the non-kvm case as well since read_cr0() is likely not very fast.

> You can't do a lot better than that, I think. Especially now that we
> do the lazy restore, we can schedule between two tasks and if only one
> of them actually uses the FPU, we won't bother with extraneous state
> restores.

Ah, this is a new bit, I'll have to study it.

> The one exception I can think of is that if you are loading totally
> *new* FP state, and you think that TS is likely to be set, instead of
> trapping (and loading the old state in the trap handling) only to
> return to load the *new* state, we could expose a helper for that
> situation. It would look something like
>
>    user_fpu_begin();
>    fpu_restore_checking(newfpustate);
>
> and it would avoid the trap when loading the new state.
>

-- 
error compiling committee.c: too many arguments to function

