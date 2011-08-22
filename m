Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314Ab1HVBQR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 21:16:17 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38891 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756226Ab1HVBQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 21:16:13 -0400
MIME-Version: 1.0
In-Reply-To: <1825A697-7D60-44D0-8150-BC0E9F0DEB67@tonyibbs.co.uk>
References: <cover.1300450604.git.tibs@tonyibbs.co.uk> <201105171050.38903.florian@openwrt.org>
 <37F5AF18-99E5-4516-B31F-00F7BD348ADE@tonyibbs.co.uk> <201107061815.36294.florian@openwrt.org>
 <5F531701-B760-45F0-989D-669013409FE8@tonyibbs.co.uk> <CAOJsxLFSdPO2ebjM9W9JaNcX80COzn=Y3hFukXZjn+1yY4ivZQ@mail.gmail.com>
 <63D130AC-E6DF-4A61-BB69-30212D238F37@tonyibbs.co.uk> <CAOJsxLEg-9hAQG99TkM+tqdTjZkpZwubOu1qM-6m7B5apZmh_w@mail.gmail.com>
 <1825A697-7D60-44D0-8150-BC0E9F0DEB67@tonyibbs.co.uk>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Sun, 21 Aug 2011 21:15:31 -0400
Message-ID: <CAF_S4t-RV1SACnkwW9RsVWEXv-jHujvnLZh-NMfDZi4YzfJwdw@mail.gmail.com>
Subject: Re: RFC: [Restatement] KBUS messaging subsystem
To: Tony Ibbs <tibs@tonyibbs.co.uk>
Cc: Pekka Enberg <penberg@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Florian Fainelli <florian@openwrt.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linux-embedded <linux-embedded@vger.kernel.org>,
        Tibs at Kynesim <tibs@kynesim.co.uk>,
        Richard Watts <rrw@kynesim.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 21, 2011 at 09:28, Tony Ibbs <tibs@tonyibbs.co.uk> wrote:
>
> On 15 Aug 2011, at 12:46, Pekka Enberg wrote:
>
>> I simply don't see a convincing argument why existing IPC and other
>> kernel mechanisms are not sufficient to implement what you need. I'm
>> sure there is one but it's not apparent from your emails.
>
> Our major concern, strongly based on experience, is that given the
> existing kernel mechanisms, users do not build robust (or even
> sometimes working!) solutions for inter-process communication.
>
> This is in large part because they do not realise (at the start) how
> difficult this is to do. Especially if they want to keep it small.
>
> The only *sure* way of solving this is to provide a mechanism that is
> "always there", and that really means a solution provided by the
> kernel. This needs to be at a higher level than what is currently
> available, but obviously what exactly is provided is then a matter for
> discussion. We'd obviously argue that KBUS hits a "sweet spot" for the
> needs we perceive, given our application areas.
>
>> The whole thing feels more like "lets put a message broker into the
>> kernel" rather than set of kernel APIs that make sense. I suppose the
>> rather extensive ioctl() ABI is partly to blame here.
>
> I'm not sure what you mean by "message broker", except that it's
> plainly meant to be a bad thing - the wikipedia meaning doesn't seem
> terribly applicable to KBUS, as it covers an awful lot more territory
> (mind, the discussion page is amusing).
>
> I'll freely admit we started with the idea of what functionality we
> wanted and then chose a simple-to-implement API to make it happen.
>
> *If* KBUS were in the kernel, with its current functionality, what API
> would you expect? (not just "a sockety one", but what actual API?) If
> one recasts as a sockety API, how is many new socket options better
> than a set of ioctls? (or is that just one of those questions to which
> the answer is "well, it is"?)

I think this may well be the core problem here - is KBUS, as proposed,
a general API lots of people will find useful, or is it something that
will fit _your_ usecase well, but other usecases poorly?
Designing a good API, of course, is quite difficult, but it _must_ be
done before integrating anything with upstream Linux, as once
something is merged it has to be supported for decades, even if it
turns out to be useless for 99% of usecases.

Some good questions to ask might be:
* Does this system play nice with namespaces?
* What limits are in place to prevent resource exhaustion attacks?
* Can libdbus or other such existing message brokers swap out their
existing central-routing-process based communications with this new
system without applications being aware?

Keep in mind also that the kernel API need not match the
application-visible API, if you can add a userspace library to
translate to the API you want. So, for example, instead of numbering
kbuses, you could define them as a new AF_UNIX protocol, and place
them in the abstract socket namespace (ie, they'd have names like
"\0kbus-0"). Doing something like this avoids creating a new
namespace, and non-embedded devices could place these new primitives
in a tmpfs or other more visible location. It also makes it very cheap
(and a non-privileged operation!) to create kbuses.

So, let's look at your requirements:

* Message broadcast API with prefix filtering
* Deterministic ordering
* Possible to snoop on all messages being passed through
* Must not require any kind of central userspace daemon
* Needs a race-less way of 1) Advertising (and locking) as a replier
for a particular message type and 2) Detecting when the replier dies
(and synthesizing error replies in this event)

Now, to minimize this definition, why not remove prefix filtering from
the kernel? For low-volume buses, it doesn't hurt to do the filtering
in userspace (right?). If you want to reduce the volume of messages
received, do it on a per-bus granularity (and set up lots of buses
instead). After all, you can always connect to multiple buses if you
need to listen for multiple message types. For replier registration,
then, it would be done on a per-bus granularity, not a per-message
granularity.

So we now have an API that might (as an example) look like this:

* Creation of buses - socket(AF_UNIX, SOCK_DGRAM, PROTO_KBUS),
followed by bind() either to a file or in the abstract namespace
* Advertising as a replier on a socket - setsockopt(SOL_KBUS,
KBUS_REPLIER, &one); - returns -EEXIST if a replier is already present
* Sending/receiving messages - ordinary sendto/recvfrom. If a reply is
desired, use sendmsg with an ancillary data item indicating a reply is
desired
* Notification on replier death (or replier buffer overflow etc):
empty message with ancillary data attached informing of the error
condition
* 64-bit global counter on all messages (or messages where requested
by the client) to give a deterministic order between messages sent on
multiple buses (reported via ancillary data)
* Resource limitation based on memory cgroup or something? Not sure
what AF_UNIX uses already, but you could probably use the same system.
* Perhaps support SCM_RIGHTS/SCM_CREDENTIALS transfers as well?

This is a much simpler kernel API, don't you think? It's also easy to
see how dbus could use it as well - just add a method to filter
unicast messages from being seen by other uninterested clients, create
a kbus socket for each dbus connection (with appropriate symlinks for
any registered aliases), and have the owner of a connection socket
register itself as a replier. Now you can send dbus broadcast messages
across the KBUS socket as usual, and perhaps send replies to unicast
messages over a socket passed in over a SCM_CREDENTIALS transfer.
Alternately, you could assign connection IDs, and have a control
message to route unicast replies to their sender - in any case, these
details are something dbus people would need to comment on, if they're
interested, but you can see that it's a use case that shows promise
(I'm not familiar with the dbus security model, however, and so I'm
not sure if this'll play well with it).

In short, API minimalism is key to acceptance in the upstream kernel.
Try to pare down the core API to the bare minimum to get what you
need, rather than implementing your final use case directly into the
kernel using ioctls or whatnot.

Thanks,

Bryan
