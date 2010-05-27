Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757143Ab0E0Nhf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 09:37:35 -0400
Received: from www.tglx.de ([62.245.132.106]:54354 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755349Ab0E0Nhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 09:37:33 -0400
Date: Thu, 27 May 2010 15:37:11 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Florian Mickler <florian@mickler.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Vitaly Wool <vitalywool@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <20100526215409.33296d94@schatten.dmk.lab>
Message-ID: <alpine.LFD.2.00.1005271535350.3032@localhost.localdomain>
References: <20100526171106.0e44a736@schatten.dmk.lab> <alpine.LFD.2.00.1005261829540.2995@localhost.localdomain> <20100526215409.33296d94@schatten.dmk.lab>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010, Florian Mickler wrote:

> On Wed, 26 May 2010 19:22:16 +0200 (CEST)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> > On Wed, 26 May 2010, Florian Mickler wrote:
> > >
> > > On the other hand, applications can say, they don't need that much
> > > power and userspace guaranties and not take a suspend blocker.
> > > 
> > > This is an option which they currently don't have.
> > 
> > Wrong. A well coded power aware application is very well able to
> > express that in various ways already today. Admittedly it's far from
> > perfect, but that can be fixed by adding interfaces which allow the
> > power aware coder to express the requirements of his application
> > actively, not by avoiding it.
> 
> Yeah, but a user can't say: "I don't
> know programming, but I had this idea. Here try it out." 
> to his friend. Because his friends phone then will crap out.
> 
> This is a negative. The phone just doesn't work well. 
> 
> A knowledgeable programmer is able to do extra work to enable specific
> guarantees. A dummy-throw-away-programmer doesn't want to do
> any extra work. 

Trying to solve that inside the kernel is the patently wrong
approach. The only way to give Joe Clicker the ability to "code" his
idea is to give him a restricted sandbox environment which takes care
of the extra work and is created by knowledgable programmers with the
Joe Clickers in mind.

Every Joe Clicker can "code" websites and does this happily in his
sandbox which consists of a web server and a web application
framework. There is no single line of code in the kernel to make this
work.

As I said before we need new interfaces and new technologies to let
the kernel do better power management, but definitely not a big hammer
approach which is actively preventing the kernel to do smarter
decisions.

The correct approach is QoS based and everything else is just a
bandaid which is going to hurt us badly.

> > 
> > suspend blockers are completely backwards as they basically disable
> > the kernels ability to do resource management.
> 
> I don't think this is a defect in the approach but the point of it. 

I know that this is the point of the approach, but that does not make
it less wrong. Me, Alan and others explained already in great length
why it is the wrong approach, but you refuse to listen.

You remind me of my 14 year old son, who argues in circles to convince
me that I must allow him something which is wrong. And if he would
think about it w/o his primary goal of getting permission in mind he
would concede that it's wrong.

> > 
> > Also they enforce a black and white scheme (suspend or run) on the
> > kernel which is stupid, as there are more options to efficiently save
> > power than those two. While current android devices might not provide
> > them, later hardware will have it and any atom based device has them
> > already.
> 
> This is true. Nonetheless, in my opinion, implementing the "backwards
> approach" in any form (suspend blockers or some other sort of "sane"
> interface) is necessary in the long run.  I also believe that Alan's
> approach is the more flexible one. But I'm not in a position to judge
> on this.
> 
> If it really is better and superior, I think userland will switch
> over to it, as soon as it is possible to do it. The impact to the
> drivers code is needed anyway. What looses the kernel by implementing
> suspend blockers, and later a more finegrained approach and mapping the
> userspace part of suspend blockers on that finegrained approach later
> on?

The kernel loses the ability to remove suspend blockers once the
interface is exposed to user space. That's the whole point. We would
have to carry it on for a long time and trying to work around it when
implementing a technical correct approach.

And we have never seen crap move to a better interface. It will stay
there forever and hell will break lose when we break it.

> > So what the kernel needs to know to make better decisions are things
> > like:
> > 
> >   - how much slack can timers have (exisiting interface)
> 
> I liked this idea of Arjan, to give some applications infinite timer
> slack. But I don't know if it can made work in a "dummy proof" way.
> (I.e. it is too complicated to get it right in general, except for the
> "infinity" or not kind of tuning)

A mobile device can implement sensible defaults for the careless
applications and let the "good" apps override them.
 
> >   - how much delay of wakeups is tolerated (missing interface)
> 
> Doesn't solve the segregation problem and is probably overkill for most

It solves the segregration problem quite nicely, as again it can be
set to sensible defaults and to "very long" for the non verified apps.

> applications. I see this as an orthogonal thing (i.e. not
> affecting this merge). 

It's not orthogonal, it's essential to do QoS based power management,
which is the only sensible technical solution to do, as it allows the
kernel to optimize in various areas while at the same time
guaranteeing the response time to applications which require them.

Blockers are not orthogonal at all, as they actively prevent clever
decisions.

> > The power efficiency of a mobile device is depending on a sane overall
> > software stack and not on the ability to mitigate crappy software in
> > some obscure way which is prone to malfunction and disappoint users.
> 
> True. But I wouldnt say, that it is the linux kernel who should force
> this politics onto its users.

The kernel does not make politics. You and the folks who are pushing
that blockers stuff with all might are making politics on the ground
of a very bad argument. It does not matter at all whether android
ships that blockers or not, it neither matters whether android folks
consider this to be the best invention since sliced bread.

The only thing which matters is technical sanity of the approach and
the maintainability of it. And none of those is given.

Thanks,

	tglx
