Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760875Ab2D0STh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 14:19:37 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39900 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760116Ab2D0STf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 14:19:35 -0400
MIME-Version: 1.0
In-Reply-To: <4F9A6ABA.6050503@msgid.tls.msk.ru>
References: <1335447289-9909-1-git-send-email-mjt@msgid.tls.msk.ru>
 <CA+55aFxEP7-+N7vTPZ-4hD-UirZ=+YMJh2x3EjZvUmjjyOchtg@mail.gmail.com> <4F9A6ABA.6050503@msgid.tls.msk.ru>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 27 Apr 2012 11:19:13 -0700
X-Google-Sender-Auth: H5kB4QarkMWbsAFx31LguG3Lb0c
Message-ID: <CA+55aFwud1nXRr+HpzH8rSkEWcZ_rJmoE7UtQt76D=A3qcb6GQ@mail.gmail.com>
Subject: Re: [PATCH v2] Introduce a version6 of autofs interface, to fix
 design error.
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>, autofs@vger.kernel.org,
        Ian Kent <raven@themaw.net>, Thomas Meyer <thomas@m3y3r.de>,
        stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 2:45 AM, Michael Tokarev <mjt@tls.msk.ru> wrote:
>
> I posted an alternative patch that "fixes" this issue for both
> old systemd and old autofs, by checking for current->comm being
> "automount". Not nice solution but it should work in practice.

Yes, I agree, it's probably what we have to go with.

I really would prefer to match on something else than ->comm, though.
I would hope that there is some *behavioral* difference between autofs
and systemd that we could trigger on. That said, it's always going to
be conditional on the whole "running 32-bit daemon on 64-bit kernel",
so whatever solution we pick will at least always be self-limiting to
that specific nasty buglet case.

> And please note also that systemd developers are saying they're
> fine with new interface and non-working old binaries of systemd,
> as long as this new interface actually solves the problem.

So the thing is, I think that a new "version 6" is worthless, if the
only problem it solves is this one - since I feel that we have to fix
the binary compatibility issue regardless.

So to me, a version 6 with just this fix is just completely pointless.
We can't just ignore existing binaries. You don't like ignoring
existing 'automount' binaries, and Thomas doesn't like ignoring
existing 'systemd' binaries. And I don't like ignoring *any* binaries
that are shipped with distributions - especially when they are central
and hard to work around.

> That's reality too, and _current_ reality we have _now_ is that
> autofs package, which worked fine for many years before, is broken.
> While systemd actually NEVER worked in this context so far, except
> of 3.3 kernel which included the fix.

Oh, I agree. We need to fix the autofs package. But reverting isn't
going to be acceptable either.

The strcmp is actually something I can accept, but I'd want it
separated out in a nicer helper function with a big comment. And quite
frankly, I'd really prefer to be able to trigger on some other
behavior - like looking at the exact details of the mount() system
call or maybe the ioctl's that get done on the control fd.

But yes, the strcmp is ugly, but it's less ugly than saying "we won't
fix this, and instead we'll create a whole new pointless protocol
version".

Btw, the whole autofs protocol is *full* of stuff like this. I just
looked at some other places where the automount daemon does reads of
fixed sizes, and one of them is a "sizeof(enum states)". Doing a
sizeof() on an enum is a f*cking bad idea - it's not very well-defined
at all (different compilers will consider the enum different sizes -
seriously). But at least that one seems to be something that is purely
internal to autofs - but it does show that the people involved did not
think through and design the protocols they used in general - more of
these kinds of "random sizes of random data structures that we don't
understand".

                         Linus
