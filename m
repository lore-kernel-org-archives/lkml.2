Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401Ab1EVT6Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 15:58:25 -0400
Received: from mail6.webfaction.com ([74.55.86.74]:53678 "EHLO
	smtp.webfaction.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab1EVT6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 15:58:18 -0400
Subject: Re: [PATCH 00/11] RFC: KBUS messaging subsystem
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Tony Ibbs <tibs@tonyibbs.co.uk>
In-Reply-To: <201105171050.38903.florian@openwrt.org>
Date: Sun, 22 May 2011 20:58:13 +0100
Cc: Jonathan Corbet <corbet@lwn.net>, Grant Likely <grant.likely@secretlab.ca>,
        lkml <linux-kernel@vger.kernel.org>,
        "Linux-embedded" <linux-embedded@vger.kernel.org>,
        Tibs at Kynesim <tibs@kynesim.co.uk>,
        Richard Watts <rrw@kynesim.co.uk>
Content-Transfer-Encoding: 7bit
Message-Id: <37F5AF18-99E5-4516-B31F-00F7BD348ADE@tonyibbs.co.uk>
References: <cover.1300450604.git.tibs@tonyibbs.co.uk> <20110322133640.5d5c88e4@bike.lwn.net> <201105171050.38903.florian@openwrt.org>
To: Florian Fainelli <florian@openwrt.org>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 May 2011, at 09:50, Florian Fainelli wrote:
 
> Hello,
> 
> Sorry for this late answer.

Not a problem from here, all responses are helpful. In, turn, apologies
for taking so long to reply.

> Most implementations (if not all) involving system-wide message
> delivery for other daemons are running in user-space.

OK. Although I certainly wouldn't claim to have anywhere near a complete
list of such (an annotated list of all the messaging systems on Linux
would be rather interesting, though!).

> If you had in mind that this daemon might be killed under OOM
> conditions, then maybe your whole system has an issue, which
> could be circumvented by making sure the messaging process gets
> respawned when possible (upstart like mechanism or such).

OOM isn't particularly an issue I'd worried about for any part of the
system. Other things tend to cause user processes to crash - using
ffmpeg on random video data, for instance. Of course, that is clearly
not a problem for KBUS itself.

Respawning itself isn't directly a problem, but getting everyone talking
to everyone else again is typically a nasty pain (and one users don't
want to think about), so one tends to want one's messaging handler to be
*very* robust. I think the discipline of working in-kernel helps with
that, although I'd be surprised if that were considered enough reason to
add a new kernel module!

> From: Jonathan Corbet <corbet@lwn.net>
> Date: 22 March 2011 19:36:40 GMT
>
> >   Even better might be to just use the socket API.
> 
> Indeed, I would also suggest having a look at what generic netlink already 
> provides like messages per application PID, multicasting and marshaling.

As I said in an earlier message, I'd ignored netlink because it sounded
as if were intrinsically losssy (no way of not losing messages if a
queue got full) which is a problem for KBUS requests/replies.

On the other hand, understanding netlink from scratch is somewhat
difficult (I've just spent some hours doing more research, and don't
feel like I've begun to get a good idea of its boundaries yet).

I have also been reading the libnl documentation, which seems to make
the userspace end somewhat less complex, and looks like a good thing.

> If you intend to keep a part of it in the kernel, you should have a
> look at this, because from my experience with generic netlink, most of
> the hard job you are re-doing here, has already been done in a generic
> manner.

It looks interesting, but the worrying part of statements like this is
always the "most of".

Is your suggestion that netlink would be a better API than the current
"creating" use of a file API for communicating from user space to the
KBUS kernel module, and then back?

The LWN article http://lwn.net/Articles/131802/ makes that sound
plausible (assuming one can still detect "release" events for netlink
sockets - I assume one can). At first glance I'm not sure how much
harder it is to program such a netlink interface "bare" (without a
userspace library such as libnl) than it is to use the current KBUS
interface in such a manner.

(Aside: a quick look at my current KBUS build shows kbus.ko as 60KB,
libkbus.so (the C userspace library on top of the "raw" usage) as 54KB,
and libnl.so as 277KB - although I don't know how Ubuntu build the
latter, and it obviously also includes all sorts of data description
handling which KBUS deliberately does not. So netlink smaller if "bare",
and bigger, but not a huge amount, if used with its library.)

I'm not entirely sure what happens if either end of the netlink API
doesn't respond in a timely manner - is netlink allowed to throw things
away?

Or did you mean that netlink is appropriate to replace some/much of the
KBUS kernel module as well? In that case I'd have to think about it a
lot more to have an informed opinion.

Anyway.

What I'm working on at the moment is an email in which I try to restate
what we are/were trying to do with KBUS, with simple examples of the
sorts of call we're talking about, and ask if that is a sensible thing
to have in the kernel, emphasising that we are more worried about the
functionality than the API.

If the concept is a good thing but our implementation of it is
objectionable (e.g., we need to rewrite to a less "creative" interface,
be more sockety, or whatever), then so be it, we'll need to rewrite.

If you'd be willing to look at that email when it is posted, I hope it
will be easier to point at specific things and say "yes, that would be
better done with netlink" or, perhaps, "netlink would not address this,
but one might attack it in this way".

Thanks,
    Tibs

