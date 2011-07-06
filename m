Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab1GFQLj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 12:11:39 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:59579 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab1GFQLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 12:11:37 -0400
From: Florian Fainelli <florian@openwrt.org>
Organization: OpenWrt
To: Tony Ibbs <tibs@tonyibbs.co.uk>
Subject: Re: [PATCH 00/11] RFC: KBUS messaging subsystem
Date: Wed, 6 Jul 2011 18:15:36 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38-8-server; KDE/4.6.2; x86_64; ; )
Cc: Jonathan Corbet <corbet@lwn.net>, Grant Likely <grant.likely@secretlab.ca>,
        lkml <linux-kernel@vger.kernel.org>,
        "Linux-embedded" <linux-embedded@vger.kernel.org>,
        Tibs at Kynesim <tibs@kynesim.co.uk>,
        Richard Watts <rrw@kynesim.co.uk>
References: <cover.1300450604.git.tibs@tonyibbs.co.uk> <201105171050.38903.florian@openwrt.org> <37F5AF18-99E5-4516-B31F-00F7BD348ADE@tonyibbs.co.uk>
In-Reply-To: <37F5AF18-99E5-4516-B31F-00F7BD348ADE@tonyibbs.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107061815.36294.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tony,

On Sunday 22 May 2011 21:58:13 Tony Ibbs wrote:
> On 17 May 2011, at 09:50, Florian Fainelli wrote:
> > Hello,
> > 
> > Sorry for this late answer.
> 
> Not a problem from here, all responses are helpful. In, turn, apologies
> for taking so long to reply.

My answer is also pretty late, sorry about that.

> 
> > Most implementations (if not all) involving system-wide message
> > delivery for other daemons are running in user-space.
> 
> OK. Although I certainly wouldn't claim to have anywhere near a complete
> list of such (an annotated list of all the messaging systems on Linux
> would be rather interesting, though!).

Here is a non-exhaustive one:
- ubus: http://nbd.name/gitweb.cgi?p=luci2/ubus.git;a=summary
- dbus

and at least another one I am using at work.

One thing that I missed while mentionning that I prefer an userland 
implementation, is that you allow several interesting features to be available 
such as:

- peer to peer between two daemons
- shared memory support between two daemons

The later specifically is interesting if you need to transfer large amounts of 
data like images.

> 
> > If you had in mind that this daemon might be killed under OOM
> > conditions, then maybe your whole system has an issue, which
> > could be circumvented by making sure the messaging process gets
> > respawned when possible (upstart like mechanism or such).
> 
> OOM isn't particularly an issue I'd worried about for any part of the
> system. Other things tend to cause user processes to crash - using
> ffmpeg on random video data, for instance. Of course, that is clearly
> not a problem for KBUS itself.
> 
> Respawning itself isn't directly a problem, but getting everyone talking
> to everyone else again is typically a nasty pain (and one users don't
> want to think about), so one tends to want one's messaging handler to be
> *very* robust. I think the discipline of working in-kernel helps with
> that, although I'd be surprised if that were considered enough reason to
> add a new kernel module!

Even if a program which is implementing some KBUS methods is crashing, and 
then restarting, I see two methods to deal with this:
- the caller of the remote kbus method should be made aware that its endpoint 
is not connected and deal with the error
- the respawning program, once registering back on the bus "server" should 
cause the bus server to emit a signal "program-xyz" is back online

It seems to me that we achieve the reliable feature that you want, without 
still making the kernel responsible for this.

Needless to say, there should be some respawning mechanism (ala upstart).

> 
> > From: Jonathan Corbet <corbet@lwn.net>
> > Date: 22 March 2011 19:36:40 GMT
> > 
> > >   Even better might be to just use the socket API.
> > 
> > Indeed, I would also suggest having a look at what generic netlink
> > already provides like messages per application PID, multicasting and
> > marshaling.
> 
> As I said in an earlier message, I'd ignored netlink because it sounded
> as if were intrinsically losssy (no way of not losing messages if a
> queue got full) which is a problem for KBUS requests/replies.

Changing netlink to report "queue full" errors sounds good for both ends, so 
it is not really a big problem. Same goes for all errors actually, it will 
just benefit the existing netlink users.

> 
> On the other hand, understanding netlink from scratch is somewhat
> difficult (I've just spent some hours doing more research, and don't
> feel like I've begun to get a good idea of its boundaries yet).
> 
> I have also been reading the libnl documentation, which seems to make
> the userspace end somewhat less complex, and looks like a good thing.

Yes, libnl hides a lot of complexity of netlink but still adds some, like 
caches and such. But in the end there is no more than 5 to 6 libnl 
handles/objects to use, and there you go. Then you usually use another library 
like libevent to get called on socket writes/reads.

> 
> > If you intend to keep a part of it in the kernel, you should have a
> > look at this, because from my experience with generic netlink, most of
> > the hard job you are re-doing here, has already been done in a generic
> > manner.
> 
> It looks interesting, but the worrying part of statements like this is
> always the "most of".
> 
> Is your suggestion that netlink would be a better API than the current
> "creating" use of a file API for communicating from user space to the
> KBUS kernel module, and then back?

What I like with netlink, which I do not with your implementation, is that 
netlink uses sockets and not traditionnal devices. But what is exposed to 
KBUS-implementors is good.

netlink in my mind is just a transport layer, while you see the transport 
layer as a /dev/kbus<N> device and its kernel module.

> 
> The LWN article http://lwn.net/Articles/131802/ makes that sound
> plausible (assuming one can still detect "release" events for netlink
> sockets - I assume one can). At first glance I'm not sure how much
> harder it is to program such a netlink interface "bare" (without a
> userspace library such as libnl) than it is to use the current KBUS
> interface in such a manner.

It is probably more work to use netlink rather than KBUS with a bare library.

> 
> (Aside: a quick look at my current KBUS build shows kbus.ko as 60KB,
> libkbus.so (the C userspace library on top of the "raw" usage) as 54KB,
> and libnl.so as 277KB - although I don't know how Ubuntu build the
> latter, and it obviously also includes all sorts of data description
> handling which KBUS deliberately does not. So netlink smaller if "bare",
> and bigger, but not a huge amount, if used with its library.)

libnl by default is pretty big, this is why we maintain a stripped down 
version, called libnl-tiny in OpenWrt: 
https://dev.openwrt.org/browser/trunk/package/libnl-tiny (based on libnl-1.1)

this is an orthogonal problem though. Some people might even go for static 
linking to automatically strip down their daemons linking with such a library.

> 
> I'm not entirely sure what happens if either end of the netlink API
> doesn't respond in a timely manner - is netlink allowed to throw things
> away?

As usual with sockets, if you do not read from it, data is thrown away, or you 
end-up looping until all is read if doing epoll.

> 
> Or did you mean that netlink is appropriate to replace some/much of the
> KBUS kernel module as well? In that case I'd have to think about it a
> lot more to have an informed opinion.
> 
> Anyway.
> 
> What I'm working on at the moment is an email in which I try to restate
> what we are/were trying to do with KBUS, with simple examples of the
> sorts of call we're talking about, and ask if that is a sensible thing
> to have in the kernel, emphasising that we are more worried about the
> functionality than the API.
> 
> If the concept is a good thing but our implementation of it is
> objectionable (e.g., we need to rewrite to a less "creative" interface,
> be more sockety, or whatever), then so be it, we'll need to rewrite.

I personaly prefer your interface to be more "sockety" to use your wording. 
Having a /dev/kbus<N> device does not seem very natural to me to read/write 
from, using a socket would be more appropriate. This is why I suggest generic 
netlink, because you will most likely end up doing the same thing, if you go 
the kernel way, which is:

- identifying your process uniquely
- marshalling/unmarshalling data sent to/from the daemon
- allowing several recipients to receive a message from a sender
...

My suggestion is that, if you really want to go the kernel way for transport 
(which I discourage, you certainly got that), let's just use generic netlink 
which has been proven to be reliable and easy to use for this.

> 
> If you'd be willing to look at that email when it is posted, I hope it
> will be easier to point at specific things and say "yes, that would be
> better done with netlink" or, perhaps, "netlink would not address this,
> but one might attack it in this way".

Let's say that if I was to integrate something like KBUS in the kernel, I 
would do it that way:

- rework the KBUS module to implement a generic netlink family and multicast 
group
- keep the same data format/marshalling
- create an user-space library which abstracts the using of this generic 
netlink socket and the KBUS specific messaging

> 
> Thanks,
>     Tibs

This is coming pretty late, but I hope that you are still willing to work on 
this subject despite my comments.
--
Florian
