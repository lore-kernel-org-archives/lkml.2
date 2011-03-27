Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab1C0THW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 15:07:22 -0400
Received: from mail6.webfaction.com ([74.55.86.74]:54478 "EHLO
	smtp.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204Ab1C0THV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 15:07:21 -0400
Subject: Re: [PATCH 00/11] RFC: KBUS messaging subsystem
Mime-Version: 1.0 (Apple Message framework v1082)
Content-Type: text/plain; charset=us-ascii
From: Tony Ibbs <tibs@tonyibbs.co.uk>
In-Reply-To: <4D8B876F.8040802@katalix.com>
Date: Sun, 27 Mar 2011 20:07:16 +0100
Cc: Jonathan Corbet <corbet@lwn.net>, Grant Likely <grant.likely@secretlab.ca>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux-embedded <linux-embedded@vger.kernel.org>,
        Tibs at Kynesim <tibs@kynesim.co.uk>,
        Richard Watts <rrw@kynesim.co.uk>
Content-Transfer-Encoding: 8BIT
Message-Id: <7728FD71-8488-445F-B52E-542F7599BEA1@tonyibbs.co.uk>
References: <cover.1300450604.git.tibs@tonyibbs.co.uk> <20110322133640.5d5c88e4@bike.lwn.net> <DBA665CD-BE12-4DC8-9B3F-4170BED789BD@tonyibbs.co.uk> <4D8B876F.8040802@katalix.com>
To: James Chapman <jchapman@katalix.com>
X-Mailer: Apple Mail (2.1082)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 Mar 2011, at 18:03, James Chapman wrote:

> On 23/03/2011 23:13, Tony Ibbs wrote:
> ...stuff I've left out, because it's expanded on below...
>
> I don't understand what Kbus really brings either.

>From one angle, KBUS aims to fit the particular needs of the embedded
user:

1. It's relatively small (so it will fit in small environments)
2. It's written in C (so no need for C++ libraries, etc., which are
   relatively large)
3. It's meant to be simple to learn (so it should be useful if you don't
   have time or resource to learn something arguably more
   complex/featureful)
4. It's meant to be simple to use without anything but the kernel
   module (i.e., you don't have to use the userspace libraries that
   the overall project also provides).

These are limitations of possible use spaces.

We also know, from practical experience, that a hard-pressed engineer
working on a project wants to be able to reach for a messaging solution
that doesn't take more than (say) an afternoon to get to grips with,
becase in general it is not anywhere near the main thrust of what
they're doing, and they don't have the time or inclination to become
expert in yet another domain. So it needs to be simple to explain and
use.

(Personally, I see this as the main failing of Dbus - even the tutorial
states up front that it is an incomplete and unfinished document. It
would be good if someone produced documentation that gives the same
enthusiasm for Dbus as the 0mq people have done with their stuff.)

>From another angle:

a. KBUS provides deterministic message ordering, so message order is
   the same for everyone receiving messages (if A sends a message,
   and B sends a message, then any of A, B, C, etc., who are listening
   to messages of that name will receive them in the same order.
   Consider messages for 'play', 'rewind' and 'pause', for instance.
   Or 'left by X', 'forward by Y' and 'up by Z' in a non-open space).
b. It guarantees that you'll get a Reply for a Request, even if that
   reply is "you aren't going to get one because the replier has gone
   away". This is done via message rather than error code, since it may
   be determined some time after the sender has sent the original
   message. Callback mechanisms can be used to similar effect, but are a
   pain if you don't want them.
c. It is not possible to send a request if the replier for that request
   does not have room in its incoming message queue. Nor is it possible
   to send a request if the sender does not have room for the (eventual)
   reply (ok, that last is perhaps a bit obvious).

Clearly, if the incoming and outgoing message queues are going be
managed in this way (i.e., according to (c)), there needs to be a
central daemon of some sort. Making sure that a daemon in userspace is
reliable is hard, and making sure that it knows when one of its clients
dies is also difficult (or perhaps "messy" would be a better word).
This last is particularly easy in the kernel, of course. Kernel modules
also come with a host of requirements and facilities that make them
easier to make reliable. Being in the kernel also brings well-debugged
handling for scalability issues, threading and multi-processing, all of
which are difficult to get absolutely right in userspace.

Some things which perhaps are not made as clear in the documentation as
they might be:

i.   KBUS is not client/server based. All senders/listeners (KBUS
     clients) are peers in this respect. Any Ksock can send messages
     (well, if it's opened for write), any Ksock can receive messages.
ii.  Anyone can choose to listen to (receive) a message of a particular 
     name. This is not dependent on who sends such a message.
iii. A single Ksock can choose to be a replier for a message of a
     particular name. This does not limit who may send request messages
     of that name, just who can reply.
iv.  From the above, it should be obvious that any request can be seen
     (received) by any listeners to that same message name, even though
     they can't reply to it. This makes debugging/logging the message
     traffic on a system particular simple.

Also (this is definitely addressed in the documentation), there is
limited wildcarding on message names - basically on the end of the
message name. This can used when binding to a message name for either
listening or replying.

Finally, KBUS does not address message content. It is not intended to be
an RPC mechanism (which I think is what Dbus, for instance, is mostly
after?). It's up to the user to choose an appropriate way of describing
data (of which there are many good examples). I don't think that's a
particularly contentious point, though, but perhaps worth mentioning.

> With good sockets programming, it is possible to avoid most of the
> issues mentioned

If someone who is a very good socket programmer wrote a user-space
library to reproduce all of the things that KBUS does, then that would
be very good (I'm unhappy with the concept of only solving "most" of the
problems, though). I don't think I could do it (hiding client/server,
handling many-to-many transfers over AF_UNIX, etc., etc.), but then I'd
not claim to be a very good socket programmer. And I'd assume it would
take rather more code (since one is, to an extent, fighting against the
underlying paradigms).

I also don't see how you'd get away without some sort of identity
broker, to indicate which socket(s) belong to whom (since I assume each
Ksock-equivalent would need multiple sockets to handle the different
things that need doing). And that's another moderately fiddly bunch of
code to be tested.

> Frameworks like Glib and DBus can also help.

Glib is, surely, addressing different issues.

Dbus is simply too large for many of the places we want to do messaging.
It is also, as I suggested above, not terribly simple to learn, so it is
not going to be picked up by people as a potential solution when they
"just" want to send messages. (Clearly, if one is wanting to communicate
with systems that already use Dbus, this is a different matter, and I
assume one can use existing examples to leverage oneself in such cases,
and anyway one doesn't have a choice.) It's also not clear to me that
Dbus allows one to do all the things we want to do with KBUS - I stand
willing to be told that I just haven't found the right documentation for
that, though.

> Have you considered other kernel messaging subsystems such as netlink
> sockets, connectors, POSIX message queues etc etc if you don't want DBus?

As I understand it, netlink is explicitly lossy (from the connector
documentation: "messages can be lost due to memory pressure or process'
receiving queue overflowed"). So one would have the issue of handling
acknowledgements and re-requests, and suddenly life is more complicated.

If one were using netlink, I think connector looks like an excellent way
to do it (it seems to have decent documentation, for a start), but it
doesn't alleviate the lossy nature of netlink itself.

In both cases, it's a lot simpler just not to do that - use a non-lossy
approach in the first place.

By 'sockets' I assume you mean over AF_UNIX, and to some extent I hope
I've addressed that above. It didn't seem a very natural fit to what
we're trying to achieve, so we didn't start from there.

Posix message queues are interesting, but I don't see how it would be
possble to do N-to-many messaging using them, without having to write
almost all of KBUS-as-infrastructure anyway. Also, as I understand it,
managing the existence of the exposed filesystem paths corresponding to
message queues in a reliable manner is difficult.

I'm not sure what other technologies are meant by "etc., etc.".

> Why would you need a new socket family?

I was assuming the alternative of writing a kernel module that "spoke"
the sockets API, instead of the file API, but still had the KBUS code
inside it (i.e., the internal management of queues, etc.), just as we've
done with the normal file interface API in current KBUS. As I said
before, we'd then need a new socket family - perhaps AF_KBUS. And I'd
contend that if this were to preserve the intended uses of KBUS, it
would be as "creative" a use of the socket interfaces as our current
code is of the file API, and I think in context even more confusing.

Or we could have taken a Poxix message queue style API, which would map
directly to KBUS usage. That, however, would involve new system calls
(i.e., replacing 'mq_' with 'kbus_') and I assume that's an absolute
forbidden.

> Perhaps KBUS is intended for uses where DBus is too big?

Addressed above. It's one of the intentions.

> Or is it to help port legacy RTOS apps to Linux?

I don't understand this point - but assume it is not relevant.

> Perhaps I misunderstand what KBUS might do for me.

I hope the above helps a bit.

> It might be useful to present two simple apps implementing the same
> thing with, say, a unix socket and KBUS, e.g. sending a message
> reliably to another process and handling possible errors.

Indeed, this would be an interesting and valuable exercise. I'm afraid I
don't see that I'm going to have time to produce such a thing in the
near future, though.

The EuroPython 2010 talk on the KBUS website does present some (very)
simple examples of use, albeit in Python, and the kmsg application
presents some very primitive usage (but hardly representative). I'm
afraid the project is sparse on examples at the moment, as most of its
use has been for customers who do not wish their code made public.

All the best,
    Tibs

