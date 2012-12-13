Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab2LMDwP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 22:52:15 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:51801 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab2LMDwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 22:52:14 -0500
MIME-Version: 1.0
In-Reply-To: <50C94ECD.6020504@gmail.com>
References: <20121211090910.GA22985@gmail.com> <CA+55aFw=sifEKVJwDvmfV317+RNrf9Z88xZ5pu0SwggrQrubTw@mail.gmail.com>
 <50C94A9C.2050900@gmail.com> <CA+55aFxpLJ=gVUSiu04sTzDDrR75B89pzE35MyEyj3pVi5UbiQ@mail.gmail.com>
 <50C94ECD.6020504@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 12 Dec 2012 19:51:52 -0800
X-Google-Sender-Auth: G_7IFA9IIr-J_lO9S6q3Chy1rQ4
Message-ID: <CA+55aFzmsEbKCg=Qp0LGxQb-D+ZfBAELEa4HyUkuxkj6Z0-agA@mail.gmail.com>
Subject: Re: [GIT PULL] perf changes for v3.8
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 7:43 PM, David Ahern <dsahern@gmail.com> wrote:
>
> you know what's worse? All of your VMs blowing up because anyone runs perf
> with precise attribute. Virtualization and and performance monitoring
> collide. From the log message for commit 1342798.
>
> "Intel PEBS in VT-x context uses the DS address as a guest linear address,
> even though its programmed by the host as a host linear address. This either
> results in guest memory corruption and or the hardware faulting and
> 'crashing' the virtual machine.  Therefore we have to disable PEBS on VT-x
> enter and re-enable on VT-x exit, enforcing a strict exclude_guest."

Right.

SO WHY DON'T YOU JUST DO THAT THEN?

Disable PEBS on Vt-x enter and re-enable it on exit. End of story.
Exactly like you say.

But don't in the process screw up people WHO DON'T EVEN DO VIRTUALIZATION!

So please, just remove that idiotic "if (!event->attr.exclude_guest)"
test. It's wrong. It cannot possibly do the right thing.  It is
totally misdesigned, exactly because you don't even know beforehand if
somebody uses virtualization or not.

Now, if the feature had been done the sane way around, and you'd have
an explicit flag that says "force this even on entry to virtualized
guests", then you could have said "Dave, I can't do that combination
of precise and virtualized guests". At that point you have - at perf
record time - a valid reason to say EOPNOTSUPP.

But doing it this way was wrong. Switch that "exclude_guest" attribute
around, and admit that "H" was bogus, and that the right thing to do
was to add a "V" flag that sets the "force_guest" flag instead.

Problem solved, without screwing people who have no reason to ever care.

               Linus
