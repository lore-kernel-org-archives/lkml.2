Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab1H2Iz6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 04:55:58 -0400
Received: from mail6.webfaction.com ([74.55.86.74]:60519 "EHLO
	smtp.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab1H2Izy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 04:55:54 -0400
Subject: Re: RFC: [Restatement] KBUS messaging subsystem
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Tony Ibbs <tibs@tonyibbs.co.uk>
In-Reply-To: <CAF_S4t-RV1SACnkwW9RsVWEXv-jHujvnLZh-NMfDZi4YzfJwdw@mail.gmail.com>
Date: Mon, 29 Aug 2011 09:55:49 +0100
Cc: Pekka Enberg <penberg@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Florian Fainelli <florian@openwrt.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linux-embedded <linux-embedded@vger.kernel.org>,
        Tibs at Kynesim <tibs@kynesim.co.uk>,
        Richard Watts <rrw@kynesim.co.uk>
Content-Transfer-Encoding: 7bit
Message-Id: <8728C1DF-3BB2-40FF-87B1-A7F9D5FAF5C4@tonyibbs.co.uk>
References: <cover.1300450604.git.tibs@tonyibbs.co.uk> <201105171050.38903.florian@openwrt.org> <37F5AF18-99E5-4516-B31F-00F7BD348ADE@tonyibbs.co.uk> <201107061815.36294.florian@openwrt.org> <5F531701-B760-45F0-989D-669013409FE8@tonyibbs.co.uk> <CAOJsxLFSdPO2ebjM9W9JaNcX80COzn=Y3hFukXZjn+1yY4ivZQ@mail.gmail.com> <63D130AC-E6DF-4A61-BB69-30212D238F37@tonyibbs.co.uk> <CAOJsxLEg-9hAQG99TkM+tqdTjZkpZwubOu1qM-6m7B5apZmh_w@mail.gmail.com> <1825A697-7D60-44D0-8150-BC0E9F0DEB67@tonyibbs.co.uk> <CAF_S4t-RV1SACnkwW9RsVWEXv-jHujvnLZh-NMfDZi4YzfJwdw@mail.gmail.com>
To: Bryan Donlan <bdonlan@gmail.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 Aug 2011, at 02:15, Bryan Donlan wrote:

> I think this may well be the core problem here - is KBUS, as proposed,
> a general API lots of people will find useful, or is it something that
> will fit _your_ use case well, but other use cases poorly?

Indeed.

And, by the way, thanks a lot for this email, which gives me lots of
specific items to reply to.

> Designing a good API, of course, is quite difficult, but it _must_ be
> done before integrating anything with upstream Linux, as once
> something is merged it has to be supported for decades, even if it
> turns out to be useless for 99% of use cases.

Indeed.

It's only anecdotal evidence, of course, but we have put quite a lot
of thought and testing into KBUS - many things that look as if they
are going to be simple or easy either aren't, or lead to unfortunate
consequences.

> Some good questions to ask might be:
> * Does this system play nice with namespaces?
> * What limits are in place to prevent resource exhaustion attacks?
> * Can libdbus or other such existing message brokers swap out their
> existing central-routing-process based communications with this new
> system without applications being aware?

I'll punt on namespaces, since I don't know the terminology being used
in the kernel (there seem to be several sorts of namespace, which are
essentially independent?).

KBUS at the moment is definitely not doing enough to manage its
resources, as I've said elsewhere. However, having all of the queues
in the same place, under the same management, means that it is a
relatively simple job to enforce an overall limit on the memory usage
of a particular bus, as well as per-queue and per-message limits. This
will (eventually) get mended whether KBUS ends up in the kernel or
not.

As to higher-level messaging systems using KBUS, I think that's a red
herring. For a start, I can't see why they'd necessarily be interested
- presumably if they felt the need for such a kernel module they'd
already have moved to introduce one (as in binder, for instance). If
they haven't, it's presumably because their design works well enough
(for their own aims) without. And of course they'd lose a certain
amount of control if part of their system were kernel-maintained,
which might also be important. But also, it's a significant
development project in itself to try to produce a system suitable to
act as the underpinnings for another system. One can't just say "it
looks as if it might work", one needs to implement it and test it,
because of all the edge cases one is bound not to have thought of.
That's a lot of work, and almost entirely unrelated to producing a
simple, minimal system.

  (for what it's worth, and despite that, my gut feeling is that
  any useful minimal messaging system could be used as the
  bottom-level for a libdbus or equivalent, but I'm still not
  convinced it would be worth it, and it would not necessarily give a
  better version of the higher level system)

So I'd say if libdbus or whoever *could* use such a system, that would
be nice, but it should not be the primary aim.

> Keep in mind also that the kernel API need not match the
> application-visible API, if you can add a userspace library to
> translate to the API you want.

OK, although that's basically true of all APIs (for instance, the way
I think of KBUS in the privacy of my own head is with the API I use in
the Python library, or how the message queues actually work within
KBUS itself).

If you look at the existing C and C++ APIs, they provide two somewhat
different abstractions. The Javascript APIs we've used in the past
were even further away from the actual kernel APIs (they never
mentioned a particular bus, since that could be inferred from the
message name in that application).

On the other hand, it is incumbent on us to remember that people
programming to the kernel API are users as well. So your implicit
point (as I take it) in this message that one should use familiar
interfaces in a familiar way is a good one. On the other hand, if we
can present the user with a simpler interface (as in simpler to
program with) by a relatively small amount of underlying work, then
that is a net gain - the user is less likely to make mistakes, and the
overall amount of code written will be smaller.

I think there is a general principle at work, in that one should
solve difficult problems once, in one place, if at all possible.

> So, for example, instead of numbering
> kbuses, you could define them as a new AF_UNIX protocol, and place
> them in the abstract socket namespace (ie, they'd have names like
> "\0kbus-0").

Indeed. I'd regard that as cosmetic detail - each KBUS is still
identified by a number, but instead of that number being used in a
device name, it's being used in a socket name.

> Doing something like this avoids creating a new
> namespace, and non-embedded devices could place these new primitives
> in a tmpfs or other more visible location. It also makes it very cheap
> (and a non-privileged operation!) to create kbuses.

Hmm.

The current mechanism for creating new KBUS buses as an unprivileged
user is admittedly via an ioctl, but clearly that should be replaced
by something more modern (the received wisdom on how to use things
like debugfs, for instance, seems to have changed greatly even in
KBUS's short life). It's not something that the current KBUS model
requires one to do often, so cheapness is not a great issue.

But unprivileged is good.

> So, let's look at your requirements:
> 
> * Message broadcast API with prefix filtering
> * Deterministic ordering
> * Possible to snoop on all messages being passed through
> * Must not require any kind of central userspace daemon
> * Needs a race-less way of 1) Advertising (and locking) as a replier
> for a particular message type and 2) Detecting when the replier dies
> (and synthesizing error replies in this event)
> 
> Now, to minimize this definition, why not remove prefix filtering from
> the kernel? For low-volume buses, it doesn't hurt to do the filtering
> in userspace (right?). If you want to reduce the volume of messages
> received, do it on a per-bus granularity (and set up lots of buses
> instead). After all, you can always connect to multiple buses if you
> need to listen for multiple message types. For replier registration,
> then, it would be done on a per-bus granularity, not a per-message
> granularity.
> 
> So we now have an API that might (as an example) look like this:
> 
> * Creation of buses - socket(AF_UNIX, SOCK_DGRAM, PROTO_KBUS),
> followed by bind() either to a file or in the abstract namespace
> * Advertising as a replier on a socket - setsockopt(SOL_KBUS,
> KBUS_REPLIER, &one); - returns -EEXIST if a replier is already present
> * Sending/receiving messages - ordinary sendto/recvfrom. If a reply is
> desired, use sendmsg with an ancillary data item indicating a reply is
> desired
> * Notification on replier death (or replier buffer overflow etc):
> empty message with ancillary data attached informing of the error
> condition
> * 64-bit global counter on all messages (or messages where requested
> by the client) to give a deterministic order between messages sent on
> multiple buses (reported via ancillary data)
> * Resource limitation based on memory cgroup or something? Not sure
> what AF_UNIX uses already, but you could probably use the same system.
> * Perhaps support SCM_RIGHTS/SCM_CREDENTIALS transfers as well?

Thanks a lot for concrete call examples - that makes it a lot easier
for me to think things through. I'll try to separate out my comments
into some sort of sensible sequence. Forgive me if I miss something.

Current scheme
--------------
In the current system, message sending looks something like the
following:

1. Sender opens bus 0
2. Sender creates a message with name "Fred"
3. Sender may mark the message as needing a reply.
4. Sender writes the message and sends it (these are currently two
   operations, but as was mentioned upstream, could be combined - we
   just liked them better apart).
5. If the message needs a reply, KBUS checks if the sender has enough
   space in its queue to receive a reply, and if not, rejects it
5. KBUS assigns the next message id for bus 0 to the message
6. KBUS determines who should receive the message. If the message
   needs a reply, and no-one has bound as replier, then the send
   fails. Similarly, if the replier does not have room in their queue,
   the send fails.
7. Otherwise, KBUS copies the message to the queues of everyone who
   should receive it. If the message needs a reply, then the
   header of the particular message that needs a reply will be altered
   to indicate this.

At the recipient end, the sequence is something like:

1. Listener opens bus 0.
2. Listener chooses to receive messages with a particular name,
   possibly as a replier.
3. Listener determines if there is a next message, and if so, its
   length.
4. Listener allocates a buffer to receive the message.
5. Listener reads the message into the buffer.

The recipient is guaranteed to read messages in the order they were
sent in, and to only get the messages they asked for.

Sockety scheme
--------------
In the scheme where we're just replacing the calls with appropriate
"sockety" calls, and not altering message name filtering, this
presumably proceeds in a very similar manner, except that we are using
the equivalent sockety calls.

My first question would be how the recipient is meant to tell the
length of the next message before doing their recvfrom/recvmsg.

I realise (now) that "message data may vary in length" wasn't
mentioned up front as a requirement (although I'd aver that it is
pretty evident from the documentation, and from the API proposed, that
this is meant, else why do we have NEXTMSG returning the length of the
next message?). But then I'd never imagined that someone wouldn't
assume this as a property of a general messaging system (after all,
it is clearly simple to build a fixed length message system on top of
a variable length message system, and rather harder to do the
reverse).

Can one use MSG_PEEK to retrieve just the ancillary data? It's not
clear to me from the recvmsg man page. If message data length was sent
in the ancillary data, then this could work. If one can't do that,
perhaps one could use MSG_PEEK to look at the start of the message
proper (although that feels like a horrible hack). Is there precedent
for this?

Otherwise, we're reduced to a special call of getsockopt, or, worse,
separating all messages into a standard sized header message followed
by the message data - but that way lies insanity.

There's also a decision to be made of what does get put into ancillary
data. At one extreme, all of the message header data would be treated
as ancillary data, which means that the user would need to use
sendmsg/recvmsg all of the time. That's a lot more code complexity,
and a lot more allocations. At the other extreme, we don't use
ancillary data at all, in which case we keep the header more-or-less
as is. There is the whole issue of whether message name and data are
referred to as pointers from the header, or are part of the same
buffer (there's some discussion of this in the KBUS documentation,
where it talks about "pointy" and "entire" messages). But that's a
level of detail for later, if necessary.

Also, if we're using ancillary data, can we use a socket specific
method to identify the message sender, something one can feed straight
back into sendmsg (hmm, maybe not - a quick scan around suggests that
AF_UNIX only has SCM_CREDENTIALS and SCM_RIGHTS - maybe I've not
looked hard enough).

  (KBUS's current sender id is nice and simple, but I'd assumed there
  must be some sockety equivalent we should be using...)

Regardless, we have an API comparison something like:

========================            =============================
File-oriented                       Socket-oriented
========================            =============================
open                                socket
close                               close
write [and <send> ioctl]            sendmsg or sendto
<nextmsg> ioctl                     not clear - getsockopt? peek?
read                                recvmsg or recvfrom
<bind> ioctl                        setsockopt
<unbind> ioctl                      setsockopt
poll                                poll
========================            =============================

There are also various ioctls on the file-oriented side that would
clearly be  replaced by get/setsockopt, and more that should be direct
instructions to KBUS via debugfs or something (i.e., they should never
have been ioctls in the first place, if I'd know what to do instead).

> This is a much simpler kernel API, don't you think?

I think we mean different things by that.

Replacing read/write (which are, let's face it, quite simple to use,
and just about every C programmer can get them mostly right) with
sendmsg/recvmsg (which are some of the most complicated calls to use
in the socket world, and for which most easy to find examples are
about moving file descriptors between processes) does not seem to me
to be simplifying anything.

I must admit I'm also not entirely sure why get/setsockopt calls are
*that* much better than ioctls (they do at least specify a length, and
the number of existing options is smaller, but neither of those seems
an obvious win to me).

Regardless, though, assuming the message length problem can be sorted
out (and that's obviously possible by *some* means), it is clearly
feasible to replace one API with another, and I assume one could move
the innards of the current KBUS to talk to the new interface.

Filtering in userspace
----------------------
You suggest performing message filtering in userspace, by reading all
messages and "throwing away" those which are not of interest. This is
predicated on the idea that the data is low volume. Apart from the
fact that I'm not sure what low volume means (are we contrasting
with network traffic on an STB handling audio/video?), we've tried not
to assume anything much about the amount of traffic over KBUS, or the
number of senders/listeners. Granted I personally wouldn't recommend
sending very large messages (I'm doubtful of the sanity of anything
over a few MB, myself, although KBUS will cope with multiple page
messages - albeit rather slowly), or expecting KBUS to be fast
(whatever "fast" means), but I'm reluctant to put those assumptions
into the design.

The inside of KBUS would indeed be slightly simpler if it did not
perform the message filtering (and this is substantially unoptimised
at the moment). However, if the client receives all of the messages,
that's an awful lot more copying being done. Within the kernel module,
message content is reference counted, but as data goes across the
kernel-to-userspace boundary, all of it gets copied. In the current
system, one can happily send a message knowing that it will not get
sent to recipients who do not care, and thus not worry much about the
cost in CPU, memory and so on. In the non-filtering system, such
concerns would need to be a major issue (spamming many clients with a
single large message that they are going to ignore could be a very big
deal, and would be relatively hard to defend against).

You also suggest splitting buses up into a finer granularity, in the
hope that this would cause less userspace filtering to be necessary.
I'm uncomfortable with that suggestion because it is just that, a
suggestion as to how the user might do things. It doesn't address the
problem in a technical manner at all.

I'd also note that there is virtue in having the unsplit buses. In the
current system, it is sensible to say that all messages for one task
will be on bus 0, and messages for another task on bus 1, and the two
cannot interact. One has, if you will, multiple message namespaces. It
makes sense to say that a program will only send messages on bus 0,
without needing to list the messages. In the proposed new system, a
single task will typically need to span multiple buses, and we've lost
a useful distinction.  Thus the original approach is a win for
documentation and pedagogy, if nothing else.

Replier buses
-------------
Putting replier registration on a bus basis. Hmm. So a recipient would
"bind" to a bus as replier *for that bus". Would all messages on that
bus be seen as requests by the replier? I think it would have to be
so, if only because marking messages as requests *as well* leads to
all sorts of possible confusions.

What if the recipient were monitoring messages as well, so it would
also want to "just receive" the requests? Presumably it would have to
open another connection to the bus to receive requests as ordinary
messages. OK.

Meanwhile, the sender presumably has to indicate that this bus is a
replier bus, with an appropriate setsockopt call. Note that this means
that everyone needs to know beforehand the id of that bus, and we are
getting perilously closer to needing some sort of manager of bus
ids/names (this makes me uncomfortable), or having a formalism about
how buses are named (ditto).

So sending now looks more like:

1. Sender opens bus 0

2. If this is to be a replier bus, sender marks it as such, via
   setsockopt. Definitely not via an ioctl.

   Note that we can't check for someone registered as a replier at
   this point, as they might reasonably not have connected to the bus
   yet.

3. Sender creates a message
4. Sender sends the message.

   As before, in the sockety manner.

5. If this is a replier bus, then KBUS checks to see if the sender has
   enough room to receive a reply on it.

6. KBUS assigns the next message id to the message

   In current KBUS, the message id is unique on each bus, and buses
   are isolated from each other. That doesn't work now, because we
   need the recipient to be able to reconstruct message ordering
   across buses. So the new id generation mechanism needs to be
   bus-independent. Using a 64-bit id should probably give us at least
   the id "granularity" that the current 32-bit id does.

7. If this is a replier bus, then KBUS checks to see if there is a
   replier bound to it (thus, leaving it as late as possible, and
   giving the most chance the replier will be there). If no-one has
   bound as replier, then the send fails. Similarly, if the replier
   does not have room in their queue, the send fails.

8. KBUS copies the message to the queues of everyone who has bound to
   receive it.
  
At the recipient end, the sequence is then presumably something like:

1. Listener opens bus 0.
2. Listener possibly chooses to be a replier for that bus, using
   setsockopt. It is an error if there is already a replier for the
   bus.

   Is it an error to bind as a replier on a bus that is not marked as
   such? I can't see that it can be, because otherwise we would have
   to fail with the race condition where:

   a. Listener opens bus
   b. Sender opens bus
   c. Listener binds to bus as replier
   d. Sender tells bus it is a replier bus

   So I think we have to allow a replier bound on a non-replier bus -
   they'd just never get any messages on it. Which means KBUS has to
   make sure not to send ordinary messages to a listener on a bus
   they've bound to as replier.

     (For a world of pain, invent a getsockopt option to check if a
     bus is marked as a replier bus, and wait for it to get set, and
     *then* bind as replier. But I wouldn't want to advise it.)

   That all feels rather messy, and is really one of the sorts of
   reason we went with just marking messages and leaving buses as
   message agnostic transports.

3. Listener determines if there is a next message, and if so, its
   length.

   Again, as said before, I'm not sure how this would be done.

4. Listener allocates the appropriate number of buffers to receive the
   message.

5. Listener reads the message into the buffers.

6. If the message was read via a socket with the "replier" socket
   option set (one assumes the recipient remembers this), then the
   listener needs to send a reply over that same socket.

Conceptually, this does look like it would work (subject to the
binding nastiness mentioned), and it's clearly more-or-less a dual of
the approach we've already taken. If we were splitting current KBUS
buses into finer granularities, it would be a reasonable approach to
consider.

The problem with splitting related messages over many buses
-----------------------------------------------------------
The trouble is that, whilst the recipient is guaranteed to receive
messages *on a given bus* in the correct order, this is no longer
sufficient, as the order we care about is now split over multiple
buses.

You propose that the recipient should reassemble the message order.
This is clearly possible if they are receiving all messages, but at
the cost of having to keep a list (potentially a very long list) of
message ids received and outstanding, and only "releasing" a message
when all preceding message ids have been encountered. A colleague's
comment on this was that we should not be reimplementing TCP/IP in
userspace. I'd just say that this is a non-trivial problem, and if
every recipient has to do it, a potential burden on the performance of
the whole system (especially if we're talking many buses), so it
should be done at the place that causes fewest reimplementations,
i.e., in the kernel module. Which puts us back where we were.

(Obviously, if the recipient is not getting *all* messages, then this
problem is unsolvable, since it cannot know which message ids are
missing - i.e., if it receives messages 5, 9 and 7, it has no way of
knowing whether it should also have received message 8.)

> In short, API minimalism is key to acceptance in the upstream kernel.
> Try to pare down the core API to the bare minimum to get what you
> need, rather than implementing your final use case directly into the
> kernel using ioctls or whatnot.

Hmm. As I recall, when starting KBUS development we said "what's the
simplest API we can present to the user to do the job", at the same
time as asking "what's the simplest set of functionalities that we
need to provide". So, in a very real sense, we did start by trying to
pare down the core API.

Of course, that same aim led us to reject trying to force sockets to
do the job just because "sockets are used for messaging". Not that
they always are, of course - one doesn't classically communicate with
DSPs over sockets, for instance.

> Thanks,
> Bryan

Thanks again,
Tibs

