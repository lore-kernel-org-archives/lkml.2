Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933137Ab1CWXNw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 19:13:52 -0400
Received: from mail6.webfaction.com ([74.55.86.74]:34268 "EHLO
	smtp.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933037Ab1CWXNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 19:13:51 -0400
Subject: Re: [PATCH 00/11] RFC: KBUS messaging subsystem
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Tony Ibbs <tibs@tonyibbs.co.uk>
In-Reply-To: <20110322133640.5d5c88e4@bike.lwn.net>
Date: Wed, 23 Mar 2011 23:13:46 +0000
Cc: Grant Likely <grant.likely@secretlab.ca>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux-embedded <linux-embedded@vger.kernel.org>,
        Tibs at Kynesim <tibs@kynesim.co.uk>,
        Richard Watts <rrw@kynesim.co.uk>
Content-Transfer-Encoding: 7bit
Message-Id: <DBA665CD-BE12-4DC8-9B3F-4170BED789BD@tonyibbs.co.uk>
References: <cover.1300450604.git.tibs@tonyibbs.co.uk> <20110322133640.5d5c88e4@bike.lwn.net>
To: Jonathan Corbet <corbet@lwn.net>
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 22 Mar 2011, at 19:36, Jonathan Corbet wrote:

> On Fri, 18 Mar 2011 17:21:09 +0000
> Tony Ibbs <tibs@tonyibbs.co.uk> wrote:
>
> > KBUS is a lightweight, Linux kernel mediated messaging system,
> > particularly intended for use in embedded environments.

> - Why kbus over, say, a user-space daemon and unix-domain sockets?  I'm
>  not sure I see the advantage that comes with putting this into kernel
>  space.

Mostly, a kernel module gives us reliability.

In particular, a kernel module allows us to guarantee that a replier
that "goes away" (including crashing) will be detected by KBUS, and
cause a synthetic reply to be sent, so that the sender can know that it
will not get a real reply.

This same guarantee means that the sender end of a stateful dialogue can
be reliably told if the replier end disconnects and (some new version of
it) reconnects - in which case state presumably needs to be
reestablished.

Doing this in userspace would be difficult and unreliable.

There are other problems with userspace daemons, including setting up
many-to-many messaging, message atomicity, and so on. Our past
experience of other people's solutions (previous customers in
particular) is that it is perilously easy to get it wrong in userspace,
and especially to end up with race conditions.

> - The interface is ... creative.

That's very tactfully put.

>  If you have to do this in kernel space,
>  it would be nice to do away with the split write()/ioctl() API for
>  reading or writing messages.  It seems like either a write(), OR an
>  ioctl() with a message data pointer would suffice; that would cut the
>  number of syscalls the applications need to make too.

When the reader is reading a message, using 'read' seems very natural,
and is simple to explain. Because we always return an "entire" message
(i.e., one in which all the message data is in one chunk, rather than
a header pointing to message name and/or data), it also means that
memory handling on return to user space is much simplified. Doing an
ioctl first to find out the length of the message to come is also
simple to explain.

Also, in the case of reading a message, I can see clear advantage
in being able to "stream" the reading of the message data (for a
long and appropriately structured message).

Writing a message *could* be done with 'write' alone. I must admit that
having 'write' detect the end of the message by looking at it feels
wrong, somehow, but that's not a very compelling answer. It is,
however, definitely easier for the user to understand the error if
they try to <send> and get told they haven't written enough data
yet, rather than just waiting for the 'write' to magically complete.

There is also a certain symmetry to using <nextmsg>/'read' and
'write'/<send>, but as you said at the start, it's a bit unusual.

Using an ioctl instead of 'write' would involve a more complex ioctl
than we're otherwise commonly using, would lose the symmetry, and just
didn't feel right. It also means pointer handling for even the simplest
message.

>  Even better might be to just use the socket API.

Whilst the current API is a bit odd, trying to use the socket API looked
to us as if it would be a worse fit.

The socket API doesn't seem to match what we wanted KBUS to do
particularly well. It's not, for instance, obvious how to do a 'recv' of
a variable length message that might be quite short or several hundred
KB long - does one 'recv' the header first, and then the body (which
isn't very nice)? Doing a 'next message' ioctl as current KBUS does
would feel really alien in a socket environment.

Of course, we'd still have to invent our own addressing scheme, and our
own ``struct *addr``, and appropriate socket options, and also decide
how the common options should apply or not (for instance, SO_ACCEPTCONN,
SO_BROADCAST). And how to work with accept/listen/bind and all the other
common calls.

Also, lazily on my part, it's fairly obvious how to write a file
interface for the kernel, but the socket API (from the inside) appears
to be more complex, and to have fewer examples with training wheels.

We *could* reimplement in terms of sockets, but I think the code would
get a lot bigger, and I think using the system would be a lot harder to
explain (I don't think the current message name binding mechanisms would
get any clearer, for instance).

And some of the semantics of KBUS (the sending of a message to say that
the expected replier has been replaced by a new one, for instance) seem
to fit oddly with how people expect sockets to work. Or being told that
the far end has gone away, or is not who one expected it to be.

Also, I'm afraid my experience is that people find sockets hard to
understand (not necessarily justifiably), whereas explaining KBUS to its
intended users is fairly simple - one can assume they know about file
interfaces, and people fairly easily accept a few "odd" extra calls. But
that may not be a very compelling reason from the inside of the
kernel...

> - Does anything bound the size of a message fed into the kernel with
>  write()?  I couldn't find it.  It seems like an application could
>  consume arbitrary amounts of kernel memory.

That is indeed a misfeature. There should be a default limit, and some
way of changing it.

> - It would be good to use the kernel's dynamic debugging and tracing
>  facilities rather than rolling your own.

Mea culpa. KBUS's debug support grew rather erratically, and only
recently got converted to at least using dev_debug and friends.
Also, I'm not at all sure what the current kernel mechanisms are
(pointers are welcomed, since this is a clear case where normal
kernel conventions should be followed, and I don't know what they are).

> - There's lots of kmalloc()/memset() pairs that could be kzalloc().

And I just missed that.

> That's as far as I could get for now.

Thanks, it's all appreciated, and all makes sense.

(and I should say thank you since I started out writing KBUS with a copy
of Linux Device Drivers beside me, and bookmarks for various LWN
articles. It would all be a lot worse without those).

Hope this all makes sense - it's late here but I shan't have a chance to
reply tomorrow.

Tibs

