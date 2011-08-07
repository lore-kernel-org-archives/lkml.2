Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab1HGUYh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 16:24:37 -0400
Received: from mail6.webfaction.com ([74.55.86.74]:55030 "EHLO
	smtp.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755010Ab1HGUYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 16:24:34 -0400
Subject: Re: RFC: [Restatement] KBUS messaging subsystem
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Tony Ibbs <tibs@tonyibbs.co.uk>
In-Reply-To: <CAOJsxLFSdPO2ebjM9W9JaNcX80COzn=Y3hFukXZjn+1yY4ivZQ@mail.gmail.com>
Date: Sun, 7 Aug 2011 21:24:29 +0100
Cc: lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Florian Fainelli <florian@openwrt.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linux-embedded <linux-embedded@vger.kernel.org>,
        Tibs at Kynesim <tibs@kynesim.co.uk>,
        Richard Watts <rrw@kynesim.co.uk>
Content-Transfer-Encoding: 7bit
Message-Id: <63D130AC-E6DF-4A61-BB69-30212D238F37@tonyibbs.co.uk>
References: <cover.1300450604.git.tibs@tonyibbs.co.uk> <201105171050.38903.florian@openwrt.org> <37F5AF18-99E5-4516-B31F-00F7BD348ADE@tonyibbs.co.uk> <201107061815.36294.florian@openwrt.org> <5F531701-B760-45F0-989D-669013409FE8@tonyibbs.co.uk> <CAOJsxLFSdPO2ebjM9W9JaNcX80COzn=Y3hFukXZjn+1yY4ivZQ@mail.gmail.com>
To: Pekka Enberg <penberg@kernel.org>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 3 Aug 2011, at 21:48, Pekka Enberg wrote:
> Your description doesn't really explain what you want to use this
> thing exactly for in userspace.

A typical use might be communicating between components in a
set-top-box (STB). This might involve:

* Some sort of GUI user interface (e.g., a browser). This will
  send control messages and receive state messages.
* Some sort of IR input, reading keypresses from a remote control. The
  program reading the keypresses will decide to send control messages
  for some of them.
* Possibly input from a mobile phone (over bluetooth or whatever),
  acting as another source of control. It's possible messages may also
  be received that require sending information back to the phone.
* A process reading data streams from the network and passing the
  appropriate parts therefrom to audio and video decoders. This will
  receive messages to tell it which programs to play, and send
  messages indicating what it is doing.
* Another process recording programs to disk, as directed by the user
  inputs. It may need to send messages to the process reading data
  streams. It will also send messages of interest to the GUI.
* A process playing programs back from disk, including "trick play" -
  that is, fast forward, skip and reverse. Obviously it receives
  messages telling it which program to play, and what trick play
  operations to perform. It in turn will send messages to the UI to
  say what it is doing.

Having the listener choose what it wants to listen to is a clear win
in these circumstances - it means that the sender of a message does
not need to know if a new piece of infrastructure is added that also
wants to receive it.

Similarly, allowing any sender to send a particular request also makes
sense, as several processes might want to ask the current location of
play in the displayed video stream, or to request some sort of trick
play action.

(I'm sure all of this could be done perfectly well with, for instance,
DBus as well, but I hope I've adequately explained elsewhere why
that's not an applicable solution.)

A small example might be several programs waiting for particular
conditions to be satisfied, and sending messages to a central program
which lights up LEDs according to the messages it reveives.

Real examples of usage that aren't the STB are a bit difficult to give
because they belong to customer projects that we're not allowed to
talk about.

> On Fri, Jul 29, 2011 at 12:48 AM, Tony Ibbs <tibs@tonyibbs.co.uk> wrote:
> > So why did we write it as a kernel module?
> > ==========================================
> > As implementors, a kernel module makes a lot of sense. Not least
> > because:
> > 
> > * It gives us a lot of things for free, including list handling,
> >  reference counting, thread safety and (on larger systems)
> >  multi-processor support, which we would otherwise have to write and
> >  debug ourselves. This also keeps our codebase smaller.
> 
> That's not a reason to put this into the kernel, really.

It's part of the reason why we wrote KBUS as a kernel module, which is
what this section was about. Agreed, it's not a reason that one can
readily use to argue that "X" (whatever that may be) should go in the
kernel-as-distributed, or we'd have all of user space there, which
would no longer be Linux (not sure what it *would* be).

> > * It helps give us reliability, partly because of the code we're
> >  relying on, partly because of the strictures of working in the
> >  kernel, partly by shielding us from userspace.
> 
> So now instead of crashing in userspace, we crash the kernel? This
> seems like a bogus argument as well.

Well, ignoring the tone of that comment, the same argument as above
applies. Although I would point out that what I was saying was that it
would be intrinsically much less likely to crash anywhere because it
is a kernel module.

> > * It reduces message copying (we have userspace to kernel back to
> >  userspace, as opposed to a userspace daemon communicating with
> >  clients via sockets)
> 
> Now this sounds like a real reason but you'd have to explain why you
> can't reuse existing zero-copy mechanisms like splice() and tee().

Hmm. vmsplice() too, presumably. I'll freely admit I don't know
anything beyond what I've just read about these functions. If one was
writing KBUS from scratch as a userspace library, with associated
daemon, then they might well be useful, but one would need to think
their use through very carefully, and I don't believe the code would
be simple (the image I have in mind is managing message structures
with two-metre long tongs, through an air-water boundary).

> > * It makes it simple for us to tell when a message recipient has "gone
> >  away", as the kernel will call our "release" callback for us.
> 
> Again, sounds like a reasonable technical requirement but doesn't
> really justify putting all this code into the kernel.

I'll get back to that below.

> > * It allows us to provide the functionality on systems without
> >  requiring anything much beyond /dev and maybe /proc in userspace.
> 
> Why is this important?

Because we sometimes want to target systems that do not need a
userspace filesystem, either because they are very simple (so their
needs can be satisfied by starting the necessary programs up in init),
or because they're trying to save space, or because they don't have
any physical storage associated with them, etc.

I assume the real point of your post is that I wrote about the reasons
why we made KBUS a kernel module, but did not really address the
reasons why KBUS might want to be a kernel module in general usage.

Obviously, there's one overriding reason, which is key:

* Inter-process messaging is hard to get right, and very easy to get
  wrong. The kernel provides low-level mechanisms one can use to write
  a userspace inter-process messaging system, but not an actual
  solution.

  Our contention is that a simple inter-process messaging module is a
  worthwhile addition to the toolkit supplied by the kernel. The trick
  is not to get over-ambitious (clearly enterprise solutions like DBus
  belong in userspace), but to provide a sensible mimumum. KBUS is our
  attempt at this, based on our experience of what one actually needs
  in a relatively simple system.

  Clearly, as the needs of a system grow, there is likely to be a
  point at which larger, more powerful solutions may be necessary
  (inevitably if you need things KBUS doesn't provide), but that
  shouldn't preclude providing the simpler solution.

Otherwise, I'll try to give some subsidiary reasons below, but I'm
bound to have forgotten something. The points aren't in any particular
order.

* I aleady said that it is important that the kernel has a single
  point where it knows that a process has gone away. Knowing this is a
  fundamental requirement of KBUS, and it would be difficult and
  unreliable to do in userspace. I actually think this is a very
  important point, as it is at the core of how KBUS works.

* All the queues are in one place.
 
  If KBUS was a userspace daemon, then it has to maintain the same
  queues as it does now (in order to get the same effect), plus some
  fraction of N message copies in transit through the kernel, where N
  is the number of clients sending/receiving messages at a particular
  time.

  With KBUS in the kernel, that "fraction of N" is not needed, and
  thus KBUS can account much more accurately for the memory it is
  using. This in turn means that it can be less conservative about the
  amount of memory available for its queues, meaning it can have more
  messages in transit.

  (Note that KBUS at the moment is nowhere near as good at this as it
  should be, but resource management is acknowledged to be a problem
  that we need to address, and it would be very simple to have a
  memory limit per bus.)

  Again, it's not that one can't do something similar in userspace,
  but that doing it in userspace is both more complicated and more
  wasteful.

* On embedded systems with not much memory, the OOM killer can be
  quite active in userspace. If the message system is crucial, then it
  is a big advantage having it in the kernel, where it cannot be
  killed (that's not to claim that KBUS as it stands is well suited to
  this use case, but it is more suitable than if it were a userspace
  daemon).

  (I do realise that there are ways of overriding the OOM killer per
  process, but being removed from the problem seems more sensible.)

* KBUS works in each client's priority, and thus avoids priority
  inversion problems, compared to userspace daemons.

  A userspace daemon must run at its own particuar priority. If it is
  high, then a low priority program sending messages can starve a
  higher process program, and if it is low, the low prioriy processes
  can preempt higher priority processes.

* Userspace peer-to-peer messaging via sockets (for instance) needs a
  persistent store of client identities ("names"). Writing this so
  that race conditions are minimised is not simple, and doing so makes
  the whole messaging infrastructure more complex. I hope the example
  at the beginning of this email makes it clearer why we'd rather not
  have such.

* It was mentioned before that KBUS being a kernel module makes it
  significantly smaller, as it can leverage code that is already
  present in the kernel. This can be important on embedded systems,
  since NAND flash is slow, and loading an extra few MB of library can
  slow the boot process down unacceptably.

  This matters to us quite a lot, it may matter less to the general
  kernel community...

* Despite having said that we weren't aiming for the sort of security
  handling that DBus provides, some security considerations are of
  interest. In particular, being a kernel module means that KBUS
  definitatively knows the identity of the sender and recipient(s) of
  each message. This makes it possible, for instance, for a sender of
  a request to assert that it should only succeed (at "write" time) if
  the intended recipient is that expected (so if the original recipient
  unbinds and a new recipient rebinds, this can be trivially
  detected - we use this so a sender can realise that the replier has
  changed and will not have any required state).

* Coming back to the "being in the kernel means more code reuse"
  issue, this is not insignificant. If your message manager crashes,
  for whatever reason, you will typically have lost all the in-transit
  messages. This is a fairly serious issue. Reusing lots of well
  tested code, and having to adhere to a moderately rigourous coding
  style and set of practices helps a lot. It's not enough by itself to
  justify being in the kernel, but it should not be ignored as a
  contributory factor once one is balancing issues.

* Being in the kernel means that it should be a lot easier to scale to
  multiple processors. And other forms of scaling that the kernel does
  for you (more or less).

* I've recently received a specific request for support of messaging
  between kernel and userspace (and vice-versa). I've yet to look at
  the feasibility of this (it's my next job after this email), but I
  think it's a fairly simple and non-obscure set of changes to KBUS. I
  don't believe this would be as true of a userspace system.

  This would allow us to replace writing to a user process that exists
  merely to write to a (locally written) driver for a piece of
  hardware with direct communication with that driver.

Tibs


