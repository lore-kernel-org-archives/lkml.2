Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100Ab1G1WPx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 18:15:53 -0400
Received: from mail6.webfaction.com ([74.55.86.74]:53984 "EHLO
	smtp.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352Ab1G1WPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 18:15:50 -0400
X-Greylist: delayed 1650 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Jul 2011 18:15:50 EDT
Subject: RFC: [Restatement] KBUS messaging subsystem
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Tony Ibbs <tibs@tonyibbs.co.uk>
In-Reply-To: <201107061815.36294.florian@openwrt.org>
Date: Thu, 28 Jul 2011 22:48:15 +0100
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Florian Fainelli <florian@openwrt.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linux-embedded <linux-embedded@vger.kernel.org>,
        Tibs at Kynesim <tibs@kynesim.co.uk>,
        Richard Watts <rrw@kynesim.co.uk>
Content-Transfer-Encoding: 7bit
Message-Id: <5F531701-B760-45F0-989D-669013409FE8@tonyibbs.co.uk>
References: <cover.1300450604.git.tibs@tonyibbs.co.uk> <201105171050.38903.florian@openwrt.org> <37F5AF18-99E5-4516-B31F-00F7BD348ADE@tonyibbs.co.uk> <201107061815.36294.florian@openwrt.org>
To: lkml <linux-kernel@vger.kernel.org>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The company I work for does a fair amount of stuff on embedded
systems, and we often need a simple way to send interprocess
messages. DBUS is too large and complex for this, and the ad-hoc
solutions we've seen people develop normally have significant
problems. So we wrote our own. Since it's a kernel module, it seemed
appropriate to submit it for possible inclusion in Linux.

The original submission to the LKML is at
http://marc.info/?l=linux-kernel&m=130047040716848&w=2

Jonathan Corbet (22 Mar 2011, at 19:36) pointed out, though, that

> The interface is ... creative.

and on 15 Apr 2011, at 23:46, in response to a patch I wrote for a
particular issue, he wrote:

> I honestly think that the item at the top of your list, if you want
> to merge this code, must be to get the user-space API more widely
> reviewed and accepted.  It could, I think, be a big sticking point,
> and it's something you want to try to address sooner rather than later.
>
> That means getting more people to look at the patch, which could be hard.
> The problem is that, if you wait, they'll only squeal when the code is
> close to going in, and you could find yourself set back a long way.  A
> good first step might be to CC Andrew Morton on your next posting.

Other matters have caused this response to be a bit delayed, but he's
clearly right that this should be addressed. And whilst we ourselves
obviously don't mind the API, it's the functionality that we *really*
care about. So there are two questions

- is KBUS something that should be in the kernel, and if it is,
- should it have a different API?

What we want of the system
==========================
We want KBUS to be very quick to learn, and very simple to use, not
least because the target users are often already experts in several
domains, and they don't have time or effort available to spend on
learning a complex system just to send messages.

We provide user-space libraries in various languages (including C and
C++), but we also want KBUS to be simple to use "bare" - target
systems may be small, and may not have much user-space. This also
means that KBUS itself needs to be written in C.

Technically, the most important requirements are:

* We require deterministic message ordering. If A, B and C all send
  messages, anyone receiving those messages must see them in the same
  order, which must be the order they were sent in.

* Messages are identified by name. Names are formed of dot-separated
  words.
* Listeners choose which messages they wish to receive, on the basis
  of the message name. Some simple filtering is available by
  wildcarding on the last word or words of the name.
* All messages are implicitly broadcast (to anyone who wishes to
  receive them).
* Request/reply is handled by a single listener binding as a replier
  to messages with a particular name. When a request message with that
  name is sent, the replier is reponsible for sending a reply message.
  (The request and reply are both still broadcast to any "normal"
  listeners.)
* When a request message is sent, but a reply from the original
  replier is not possible - e.g., if there is noone bound as replier,
  or the original replier has unbound, or even crashed - then the
  system will send a synthetic reply to indicate this. In informal
  terms, the system guarantees a request will get a reply.

The system deliberately avoids a client/server model.

* Any client can be a sender and a listener on the same connection.
* KBUS makes no restriction on who sends messages with what names,
  and it does not restrict who may send request messages.

Whilst requests are guaranteed to be sent to the appropriate recipient
(if they're still listening), "general" listening is by default lossy.
That is, if a listener's incoming message queue is full, then new
messages will by default be dropped (but not if they're a request to
that listener, of course). However, the sender of a message can
choose that all recipients must be able to receive a particular
message (sending with either all-or-fail or all-or-wait).

* KBUS does not say anything about the data (if any) in a message.
  Different users have different requirements, so this gets
  complicated very quickly, and there are many excellent independent
  solutions for this.
* We do want support for multiple buses, which must be walled off from
  each other. Naming them by anything complicated isn't needed.

So why did we write it as a kernel module?
==========================================
As implementors, a kernel module makes a lot of sense. Not least
because:

* It gives us a lot of things for free, including list handling,
  reference counting, thread safety and (on larger systems)
  multi-processor support, which we would otherwise have to write and
  debug ourselves. This also keeps our codebase smaller.
* It helps give us reliability, partly because of the code we're
  relying on, partly because of the strictures of working in the
  kernel, partly by shielding us from userspace.
* It reduces message copying (we have userspace to kernel back to
  userspace, as opposed to a userspace daemon communicating with
  clients via sockets)
* It makes it simple for us to tell when a message recipient has "gone
  away", as the kernel will call our "release" callback for us.
* It allows us to provide the functionality on systems without
  requiring anything much beyond /dev and maybe /proc in userspace.

Since our potential users are generally all building Linux anyway,
adding an extra kernel module is not an issue.

The API
=======
KBUS as written uses the file API. KBUS bus <n> is represented as
device file /dev/kbus<n>. Bus 0 is always present.

So a client connects to KBUS by calling "open" on the appropriate
device file, and disconnects with "close". Messages are sent by
writing the appropriate data to the device using "write", and using a
SEND ioctl to indicate that the message is to be sent [1]. Messages
are read by calling an ioctl to find the length of the next message
(0 if there is none), and then reading it using "read". Polling may be
used to wait for a message read/write in the normal manner.

[1] It has already been suggested that the SEND is not needed given
    that the end of a message is deterministic, but it mirrors the
    "is there a next message" ioctl, and felt tidier to us than
    producing a "can't send" error when the write(s) for the message
    data are finished.

I believe that this use of the file API is what Jonathan Corbet calls
"creative" (we can't disagree with him).

We chose this interface for several reasons:

* All C programmers are likely to have used open/close/read/write at
  some time, and even if they've not used ioctls, our target audience
  will have called functions with arbitrary datastructures.
* We didn't want to (try to) add a new specific API to the kernel
  (I assume that is a luxury whose day has long gone).
* The socket model didn't seem like a good fit to us, not least
  because we did not want a client/server model.
* There is a lot of information on how to write a file-based kernel
  module, including many examples.
* It is obvious that the "release" callback for a "file" will be
  called when the file is closed or the opening process crashes.

I must admit that, this being my first kernel module, the "lots of
documentation and examples" influenced me.

Several people on-list have wondered why we didn't use some socket
interface. This seems partly to be based on the assumption that
"everyone knows how to do sockets" (I may be being unfair, here),
which is not in fact true - many C programmers have not worked with
sockets.

I'm not aware of any good explanations of how to do a socket based
interface to a kernel module, and particularly not of documentation of
how one *should* do it. Mea culpa if I've just looked in the wrong
places.

The interactions we'd *like* our API to have go more-or-less thus:

* Send: either manufacture an entire message, pass it to KBUS,
  and then send it, or pass parts of a message to KBUS, and when all
  of the parts have been given, send it. This latter allows (for
  instance) a common header to be written repeatedly, followed by
  varying data.

* Read: Ask for (the size of) the next message. A size of 0 can
  conveniently be taken as meaning there is no next message. Then, as
  a separate call, read that many bytes.

* Discard a message that is waiting to be read. Current KBUS does this
  by asking for (the size of) the next message again, without an
  intermediate read.

* Poll for the next message to be read. Obviously useful.
 
* Poll for being allowed to send a new message. This is useful if a
  send was rejected, perhaps because it was a request message, and
  the replier does not have room in their queue for it.

As I said earlier, I'm not sure how one would write a kernel module
with a socket-style API that does what KBUS does, although clearly one
could imagine such a thing. I must admit that our feeling is that it
would be "stretching" the normal assumptions of how sockets work in
much the same way that the current API is doing for the file-like
interface.

What already exists
===================
There is a general KBUS homepage at http://kbus-messaging.org/.

The version of KBUS on Google Code, at http://code.google.com/p/kbus/,
is used by several clients of ours, and includes a "higher level" C
library, plus bindings for Python, C++ and Java.

There is a working repository with these patches applied to
Linux 2.6.37, available via:

git pull git://github.com/crazyscot/linux-2.6-kbus.git kbus-2.6.37

The original patches were applied in branch apply-patchset-20110318
-- 
Tibs
