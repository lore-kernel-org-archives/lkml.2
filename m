Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845Ab1HCUPI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 16:15:08 -0400
Received: from mail6.webfaction.com ([74.55.86.74]:57248 "EHLO
	smtp.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755110Ab1HCUO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 16:14:59 -0400
Subject: Re: RFC: [Restatement] KBUS messaging subsystem
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Tony Ibbs <tibs@tonyibbs.co.uk>
In-Reply-To: <CADkLE3XRg6N2cWHXH_JsU56tfw5v5XmJJLfLBM_RtWJRMcZWtA@mail.gmail.com>
Date: Wed, 3 Aug 2011 21:14:53 +0100
Cc: lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Florian Fainelli <florian@openwrt.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linux-embedded <linux-embedded@vger.kernel.org>,
        Tibs at Kynesim <tibs@kynesim.co.uk>,
        Richard Watts <rrw@kynesim.co.uk>
Content-Transfer-Encoding: 7bit
Message-Id: <81866CAA-9010-4167-A556-84191E0BDFBA@tonyibbs.co.uk>
References: <cover.1300450604.git.tibs@tonyibbs.co.uk> <201105171050.38903.florian@openwrt.org> <37F5AF18-99E5-4516-B31F-00F7BD348ADE@tonyibbs.co.uk> <201107061815.36294.florian@openwrt.org> <5F531701-B760-45F0-989D-669013409FE8@tonyibbs.co.uk> <CADkLE3XRg6N2cWHXH_JsU56tfw5v5XmJJLfLBM_RtWJRMcZWtA@mail.gmail.com>
To: Colin Walters <walters@verbum.org>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delay in replying - the last several days have had no
free time at all (otherwise this would be shorter as well!).

On 29 Jul 2011, at 00:58, Colin Walters wrote:

> So, what I think your description of this project lacks is high-level
> technical requirements and goals;

Well. I thought that was what I was doing. Mea culpa.

> you mention basically just "deterministic ordering"

I'd count the following as our driving requirements/goals, although
this is really just a rephrasing of stuff from last message, so
apologies if I'm missing the point:

* deterministic message ordering (as defined last email)
* messages identified by name (i.e., something human readable and
  potentially mnemonic, not just numbers)
* all messages visible to (can be received by) any interested party
  (this can be particularly important for logging/diagnosis)
* recipient chooses which messages it is interested in
* only (at most!) one replier allowed for a particular message name
* no restriction on who can send messages
* guaranteed reply to a request (a legitimate reply being "the
  designated replier has gone away")
* multiple buses allowed, messages do not move between buses
* a client can send/receive messages on the same connection

Those are the issues that give KBUS its particular flavour.

Implied by some of that is:

* no client/server model
* no timeouts (OK, I didn't say that last email, and it is fairly
  unobviously implicit)

and not quite API:

* must be written in C
* must be a relatively small amount of code (yes, that's subjective)
* must be documented (although I'd take that as a given, and it can
  always be done better)
* must have a relatively small API (again, subjective)

but I thought that was all in the last email. Sorry if it was unclear.

> and "easy API" (the latter being fairly subjective).

Yes, of course it is. But a simple system should be simpler to
explain/use than a complex one. Although I take your point further
down.

> You don't mention what your performance requirements are
> (if any) for example.

We don't particularly have any - we're nearer to user-reaction timing
than real-time issues. Some rough tests a while back indicated that
KBUS performed at about either half or double the speed of inotify
(sorry, I'm not at work so don't have the notes to hand) - so not
particularly fast. It was written to provide the functionality we
needed, with the intention to optimise as needed, and since it's been
fast enough, we've not tried to speed it up. Although I've strong
suspicions (*not* validated by testing, though, so not reliable) of
what is probably slow.

> If you had a high-level requirements list it might be easier to
> compare with other things.

> For example, you might ask "Why not SYSV IPC"?

I know this is probably a rhetorical question, but well, it's poorly
specified, too low level and doesn't do all the things we want (for
instance, how does one handle many-to-many transactions?).

> Or  "why not drop files in a temporary directory and use
> inotify" etc.

Can we all say "ick" (although back in the day on IBM mainframes that
wasn't a bad way to do data passing, as the infrastructure existed to
allow one to know when directory contents changed in a fairly
efficient manner - I had a client using just such a mechanism for
passing around documents containing data reports).

> My feeling as a DBus developer is that by far its most important
> feature is providing a dynamic naming service (the RequestName call).
> I don't know how one could sanely do a general-purpose operating
> system without a way for loosely-coupled components to find each other
> at runtime.  Things like Debian or Fedora where one can assemble
> arbitrary sets of packages basically demand the ability do to this -
> think things like X being able to talk to HAL, or Firefox being able
> to find NetworkManager.

That sounds like a good characterisation of the world DBus is trying
to work in.

> KBUS seems not to provide this (or at least, I'm not seeing it).

Exactly.

I'm not sure why people keep wanting to compare KBUS and DBus (maybe
my fault for the name), as their scopes are so different it feels
rather like comparing a bicycle with a bus company.

Anyway, from what I understand, DBus is an "enterprise" style solution
to messaging for major-level infrastructure - large systems such as
Gnome and its associated programs. As such its aim is to provide a
one-stop solution for all ones messaging needs, including:

* client name brokering (and the very existence of client naming)
* data schemas
* IPC (clearly a specialisation of the above)
* allowing/forbidding message receipt/transmission according to policy
* security policies (see below)

and so on.

These all sound like necessary things in the arena in which DBus is
used. They are not things that KBUS intends to provide. If such things
are needed, DBus already exists and is in common use.

So I would say that DBus is, of necessity, trying to find the maximal
solution for the problem space, so that users do not need to
learn/deploy more than one thing. This makes sense for what it is
trying to do.

    (One could argue about whether it is better to have one large
    system providing everything, or a small core and many extensions,
    but experience shows that the one-large-system tends to win, as
    for instance with EULisp versus Common Lisp, presumably for good
    psychological reasons.)

KBUS, however, is trying to find the minimum that is useful for our
problem space, which is small systems oriented.

So it eschews data description. After all, not all messages *have*
data, and there are many good ways of describing data that already
exist (from ASN.1 to JSON to the google protocol descriptions).

KBUS provides a mechanism for choosing which messages to receive, and
who might reply to a particular message name. But it itself doesn't
provide a registry of allowed names. For many systems that would be
overkill, and if it is needed, then it can be done separately (often,
in fact, in paper specifications).

> DBus *does* have deterministic ordering too - I'm not sure why you
> say we don't.

That's good. I *thought* I'd said that I couldn't tell from the
documentation, but that there was one place that I'd seen that seemed
(possibly) to imply it couldn't.

> DBus does have some flaws - for example, the resource controls were
> poorly thought out and basically useless.  If we were designing them
> today, we'd probably have DBus connections tied to Linux cgroups
> somehow.

Of course, cgroups have only recently begun to be adopted widely, and
presumably weren't around at all when DBus was started.

> KBUS from what I can see shares this flaw

Indeed. Since we've been using it on systems where we control the
system-as-a-whole, it was something we mostly didn't remember to worry
about, and that is a significant flaw, which has already been picked
up on lkml. Regardless of what happens in terms of adoption into the
kernel, it's something we have to address.

> A somewhat weaker but still useful part of DBus is that it has
> mandatory security controls; the policy can restrict which uids can
> talk to a given service on the bus, and also allows userspace to check
> the credentials of messages they receive (think SO_PEERCRED).  By
> having KBUS based on files you seem to lose this which you'd get from
> a socket API.

Again, this is the sort of support one would want in a realistic
enterprise/large scale solution. It's also deliberately not part of
the KBUS design - we want any recipient to be able to receive any
messages (on a given bus). In that sense, KBUS is (by design)
inherently insecure.

> On a different topic, I find myself really unconvinced by the length
> to which you go to claim the API is simple and easy to use.

Point taken.

> I mean, I really can't imagine it'd be hard to write a userspace C
> library implementing the semantics you have here, and have it be as
> easy or easier.    Oh you actually do have a "libkbus" here:
> http://code.google.com/p/kbus/source/browse/libkbus/kbus.h

I'm not sure what you mean by this. libkbus is a layer around the
"bare" usage of KBUS, allowing people to do the more common actions
without (for instance) fettling "errno" all over the place. It's
polite to provide that, as we do for Python (which was the first such
wrapper, so I could write unit tests easily) and C++ - but all of
those *are* just wrappers around the "bare" usage (the Java library is
different, since it's a wrapper around the C library, but that's Java
for you).

I am willing, however, to assert that it would have been harder to
write a C library that did this job in userspace, if only (and
trivially) because I would have had to write all the support code that
the kernel already supplies for me. And then debug it.

> You never mention what tradeoffs you might see from having that in
> userspace or whether you tried it for that matter.

Obviously we haven't tried rewriting KBUS in userspace for Linux. If
we ever ported the functionality to Windows (or BSD or Mac), then a
userspace solution would perhaps be necessary (I don't think it's
quite comparable), but on Linux, where we currently need it, the
solution we've got works well for us.

My belief is that a userspace solution would be less reliable (for one
thing, it's harder to reliably detect that a replier has crashed as
opposed to just being very busy for a moment). It would definitely be
larger.

That doesn't, of course, mean that *other people* will find KBUS
valuable in the kernel (as I think Grant Likely said, uplist, every
extra piece of code added to the kernel imposes a heavy maintenance
load, and so must be very carefully justified).

We've done the work for ourselves, and feel that KBUS provides
something the kernel might want (a simple, low-level messaging system
that is just enough higher level than what is already provided to be
useful), so it's worth our submitting it.

Anyway, thanks for taking the trouble to comment, and I hope this
all makes sense,
Tibs

