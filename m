Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030232Ab2B1TG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 14:06:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36120 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965674Ab2B1TGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 14:06:23 -0500
Message-ID: <4F4D25A2.70307@redhat.com>
Date: Tue, 28 Feb 2012 21:06:10 +0200
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
References: <alpine.LFD.2.02.1202191412060.3898@i5.linux-foundation.org> <alpine.LFD.2.02.1202201148100.4237@i5.linux-foundation.org> <CA+5PVA5Zkka6Q2kcvWbvA3xr9=5TZ+VWWsWzYcRQ1GpccpJHew@mail.gmail.com> <CA+55aFyqz-2ejsRpbRdYx7UHDBg3q=9nvmtrj2nLeuZonrkz1A@mail.gmail.com> <4F42FE08.5020309@zytor.com> <CA+55aFxKLvHXRkx-x+zOkHJk__uTJc90Z0i+00W-hqDaQb_HCQ@mail.gmail.com> <4F43DB69.9060509@zytor.com> <CA+55aFxap0zAAJOCcz0f+DKBuG6VQa7kq1j2JD1S4ysgmb62aA@mail.gmail.com> <4F440945.1020904@zytor.com> <alpine.LFD.2.02.1202211338420.5354@i5.linux-foundation.org> <alpine.LFD.2.02.1202211339590.5354@i5.linux-foundation.org> <alpine.LFD.2.02.1202211340330.5354@i5.linux-foundation.org> <4F4CB89C.4060500@redhat.com> <CA+55aFwKJspohPdmbzXZzN4xtNU1Sz0RMA9AfTLnoRWgpPGzHg@mail.gmail.com> <4F4D0D18.4060409@redhat.com> <CA+55aFyA=b-27XbhGdDQfSRMk=xet2jOD9H8hkjEq1md29bJJA@mail.gmail.com> <4F4D1857.4010706@redhat.com> <CA+55aFxgf_HHZKhN9FwOBgKoJHbkFzdCrPhMwWbWKXhb9NpkPg@mail.gmail.com>
In-Reply-To: <CA+55aFxgf_HHZKhN9FwOBgKoJHbkFzdCrPhMwWbWKXhb9NpkPg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2012 08:34 PM, Linus Torvalds wrote:
> On Tue, Feb 28, 2012 at 10:09 AM, Avi Kivity <avi@redhat.com> wrote:
> >
> > This is done by preempt notifiers.  Whenever a task switch happens we
> > push the guest fpu state into memory (if loaded) and let the normal
> > stuff happen.  So the if we had a task switch during instruction
> > emulation, for example, then we'd get the "glacial and stupid path" to fire.
>
> Oh christ.
>
> This is exactly what the scheduler has ALWAYS ALREADY DONE FOR YOU.

No, the scheduler saves the state into task_struct.  I need it saved
into the vcpu structure.  We have two fpu states, the user state, and
the guest state.  APIs that take a task_struct as a parameter, or
reference current implicitly, aren't going to work.

> That's what the i387 save-and-restore code is all about. What's the
> advantage of just re-implementing it in non-obvious ways?
>
> Stop doing it. You get *zero* advantages from just doing what the
> scheduler natively does for you, and the scheduler does it *better*.

The scheduler does something different.

What I'd ideally want is

  struct fpu {
      int cpu;  /* -1 = not loaded */
      union thread_xstate *state;
  };

Perhaps with a struct fpu_ops *ops if needed.  We could then let various
users' fpus float around freely and only save/load them at the last moment.


-- 
error compiling committee.c: too many arguments to function

