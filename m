Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030307Ab2B1T0k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 14:26:40 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:44661 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030277Ab2B1T0i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 14:26:38 -0500
MIME-Version: 1.0
In-Reply-To: <4F4D25A2.70307@redhat.com>
References: <alpine.LFD.2.02.1202191412060.3898@i5.linux-foundation.org>
 <alpine.LFD.2.02.1202201148100.4237@i5.linux-foundation.org>
 <CA+5PVA5Zkka6Q2kcvWbvA3xr9=5TZ+VWWsWzYcRQ1GpccpJHew@mail.gmail.com>
 <CA+55aFyqz-2ejsRpbRdYx7UHDBg3q=9nvmtrj2nLeuZonrkz1A@mail.gmail.com>
 <4F42FE08.5020309@zytor.com> <CA+55aFxKLvHXRkx-x+zOkHJk__uTJc90Z0i+00W-hqDaQb_HCQ@mail.gmail.com>
 <4F43DB69.9060509@zytor.com> <CA+55aFxap0zAAJOCcz0f+DKBuG6VQa7kq1j2JD1S4ysgmb62aA@mail.gmail.com>
 <4F440945.1020904@zytor.com> <alpine.LFD.2.02.1202211338420.5354@i5.linux-foundation.org>
 <alpine.LFD.2.02.1202211339590.5354@i5.linux-foundation.org>
 <alpine.LFD.2.02.1202211340330.5354@i5.linux-foundation.org>
 <4F4CB89C.4060500@redhat.com> <CA+55aFwKJspohPdmbzXZzN4xtNU1Sz0RMA9AfTLnoRWgpPGzHg@mail.gmail.com>
 <4F4D0D18.4060409@redhat.com> <CA+55aFyA=b-27XbhGdDQfSRMk=xet2jOD9H8hkjEq1md29bJJA@mail.gmail.com>
 <4F4D1857.4010706@redhat.com> <CA+55aFxgf_HHZKhN9FwOBgKoJHbkFzdCrPhMwWbWKXhb9NpkPg@mail.gmail.com>
 <4F4D25A2.70307@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 28 Feb 2012 11:26:17 -0800
X-Google-Sender-Auth: amIZjeORwhhfEkx50tWEcJr_y4I
Message-ID: <CA+55aFxtWnE89DbPZhytC0mfhUFZaaFWU7k8-tY8ZX-YRE4UtA@mail.gmail.com>
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

On Tue, Feb 28, 2012 at 11:06 AM, Avi Kivity <avi@redhat.com> wrote:
>
> No, the scheduler saves the state into task_struct.  I need it saved
> into the vcpu structure.  We have two fpu states, the user state, and
> the guest state.  APIs that take a task_struct as a parameter, or
> reference current implicitly, aren't going to work.

As far as I can tell, you should do the saving into the vcpu structure
when you actually switch the thing around.

In fact, you can do it these days by just playing around with the
"tsk->thread.fpu.state" pointer, I guess.

But it all boils down to the fact that your code is not just ugly,
it's *buggy*. If you play around with setting TS, you *will* be hit by
interrupts etc that will start to use the FP code that you "don't
use".

And there is no excuse for you touching the host TS. The kernel does
that for you, and does it better. And caches the end result in
TS_USEDFPU (old) or in some variable that you shouldn't look at but
can access with the user_has_fpu() helpers.

                    Linus
