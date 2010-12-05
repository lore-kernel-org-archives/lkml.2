Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab0LEUsc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 15:48:32 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59226 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754291Ab0LEUsb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 15:48:31 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTi=7FRCK9R2PVCTdtSqKo9FZemD5cXQTFoOKLEFB@mail.gmail.com>
References: <1289783580.495.58.camel@maggy.simson.net> <1289811438.2109.474.camel@laptop>
 <1289820766.16406.45.camel@maggy.simson.net> <1289821590.16406.47.camel@maggy.simson.net>
 <20101115125716.GA22422@redhat.com> <1289856350.14719.135.camel@maggy.simson.net>
 <20101116130413.GA29368@redhat.com> <1289917109.5169.131.camel@maggy.simson.net>
 <20101116150319.GA3475@redhat.com> <1289922108.5169.185.camel@maggy.simson.net>
 <20101116172804.GA9930@elte.hu> <1290281700.28711.9.camel@maggy.simson.net>
 <AANLkTinz12n9OKkCV8XRF8n1vKytO_aj26i-ytcAhFgN@mail.gmail.com>
 <AANLkTinWQkiadp7NCVt401bFiATJeqTK1g81RcP2awCv@mail.gmail.com>
 <AANLkTinmgsBQ624habviTTj7khCdZH_p2m5mX24_SV9j@mail.gmail.com>
 <AANLkTikFXv042qg4uzXF--9_co6-b_UgJF7Jeo2bVA=f@mail.gmail.com>
 <AANLkTikrc+_r1KE477c-NeD-9PWDOXx1ExHGm08Lm6wM@mail.gmail.com>
 <AANLkTiniEUdADMHUE1a9Fs1bGsWn6F6yeJX_NO4L94JK@mail.gmail.com> <AANLkTi=7FRCK9R2PVCTdtSqKo9FZemD5cXQTFoOKLEFB@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 5 Dec 2010 12:47:42 -0800
Message-ID: <AANLkTinOQ5sWigfW844dSBc2PvVwFj5c7yu+scNXxMcv@mail.gmail.com>
Subject: Re: [PATCH v4] sched: automated per session task groups
To: Colin Walters <walters@verbum.org>
Cc: Ray Lee <ray-lk@madrabbit.org>, Mike Galbraith <efault@gmx.de>,
        Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 5, 2010 at 11:22 AM, Colin Walters <walters@verbum.org> wrote:
>
> For the purposes of this discussion again, let's say "fixing nice"
> means say "group schedule each nice level above 0".  There are
> obviously many possibilities here, but let's consider this one
> precisely.

THAT IS NOT HOW 'nice' WORKS!

For chissake, how hard is it to understand?

The semantics of "nice" are not - and have never been - to put things
into process scheduling groups of their own.

When somebody says "nice xyzzy", they are explicitly stating that
"xyzzy" isn't as important as other processes. It's done for stuff
that you don't care about, and more specifically, for stuff that you
really don't want to impact anything else. So if there are other
things to be run, 'nice' means that those should get more CPU time.

(Obviously, negative nice levels work the other way around).

This is very much documented. People rely on it. Look at the man-page.
It talks about "most favorable" vs "least favorable" scheduling.

> Two people logged in would get their "make" jobs group scheduled
> together.  What is the problem?

The problem is that you don't know what the hell you are talking about.

Different nice levels shouldn't get group scheduled together - they
should be scheduled *less*. And it's not about "make", since nobody
really ever uses nice on make anyway, it's about things like
pulseaudio (that wants higher priorities) and random background
filesystem indexers etc (that want lower priorities).

Nice levels are _not_ about group scheduling. They're about
priorities. And since the cgroup code doesn't even support priority
levels for the groups, it's a really *horrible* match.

And the thing is, the nice semantics are traditional. They are also
*horrible*, but that doesn't allow you to change their semantics.
People rely on those crazy traditional and mostly useless semantics.
Not very much (because they are mostly useless), but there really are
people who use it.

And they use it knowing that positive nice levels means that something
is less important.

In contrast, giving processes a scheduling group doesn't imply "less
important". Not AT ALL. It doesn't really mean "more important"
either, it just means "somewhat insulated from other groups".

So let's say that you have a filesystem indexer, and you nice it up to
make sure that it doesn't steal CPU bandwidth from your "real work".
Now, let's say that you start a "make -16" to build something
important.

Do you *really* think that the person who niced the filesystem indexer
down wants the indexer to get 50% of the CPU, just because it's
scheduled separately from the parallel make?

HELL NO!

So stop this idiocy. "nice" has absolutely nothing to do with group
scheduling. It cannot. It must not. It's a legacy interface, and it
has real semantics.

> Since Linus appears to be more interested in talking about nipples
> than explaining exactly what it would break, but you appear to agree
> with him, hopefully you'll be able to explain...

The reason I was talking about make nipples should be clear by now.
Think "legacy interface". Think "don't mess with it, because people
are used to it".

They may be useless, but dammit, they do what they do.

Don't try to turn male nipples into something they aren't. And don't
try to turn 'nice' into something it isn't.

                     Linus
