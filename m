Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab2HVLeM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 07:34:12 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46844 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab2HVLeH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 07:34:07 -0400
Date: Wed, 22 Aug 2012 13:33:53 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Alex Shi <alex.shi@intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
Message-ID: <20120822113352.GA28247@gmail.com>
References: <20120821094203.GB12385@gmail.com>
 <20120821113951.GA22436@srcf.ucam.org>
 <20120821151910.GA5359@gmail.com>
 <20120821152828.GB28241@srcf.ucam.org>
 <20120821155908.GA5499@gmail.com>
 <20120821161324.GA29665@srcf.ucam.org>
 <20120821182346.GA7325@gmail.com>
 <20120821195234.20c173bc@pyramind.ukuu.org.uk>
 <20120822090304.GA23336@gmail.com>
 <20120822120027.7d04fd3a@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120822120027.7d04fd3a@pyramind.ukuu.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > With deep enough C states it's rather relevant whether we 
> > continue to burn +50W for a couple of more milliseconds or 
> > not, and whether we have the right information from the 
> > scheduler and timer subsystem about how long the next idle 
> > period is expected to be and how bursty a given task is.
> 
> 50W for 2mS here and there is an irrelevance compared with 
> burning a continual half a watt due to the upstream tree lack 
> some of the SATA power patches for example.

It can be more than an irrelevance if the CPU is saturated - say 
a game running on a mobile device very commonly saturates the 
CPU. A third of the energy is spent in the CPU, sometimes more.

> It's the classic "standby mode" problem - energy efficiency 
> has time as a factor and there are a lot of milliseconds in 5 
> hours. That means anything continually on rapidly dominates 
> the problem space.
> 
> > > PM means fixing the stack top to bottom, and its a whackamole 
> > > game, each one you fix you find the next. You have to sort the 
> > > entire stack from desktop apps to kernel.
> > 
> > Moving 'policy' into user-space has been an utter failure, 
> > mostly because there's not a single project/subsystem 
> > responsible for getting a good result to users. This is why 
> > I resist "policy should not be in the kernel" meme here.
> 
> You *can't* fix PM in one place. [...]

Preferably one project, not one place - but at least don't go 
down the false path of:

 " Policy always belongs into user-space so the kernel can 
   continue to do a shitty job even for pieces it could 
   understand better ..."

My opinion is that it depends, and I also think that we are so 
bad currently (on x86) that we can do little harm by trying to 
do things better.

> [...] Power management is a top to bottom thing. It starts in 
> the hardware and propogates right to the top of the user space 
> stack.

Partly because it's misdesigned: in practice there's very little 
true user policy about power saving:

- On mobile devices I almost never tweak policy as a user - 
  sometimes I override screen brightness but that's all (and 
  it's trivial compared to all the many other things that go 
  on).

- On a laptop I'd love to never have to tweak it either - 
  running fast when on AC and running efficient when on battery 
  is a perfectly fine life-time default for me.

90% of the "policy" comes with the *form factor* - i.e. it's 
something the hardware and thus the kernel could intimately
know about.

Yes, there are exceptions and there are servers.

The mobile device user mostly *only cares about battery life*, 
for a given amount of real utility provided by the device. The 
"user policy" fetish here is a serious misunderstanding of how 
it should all work. There arent millions of people out there 
wanting to tweak the heck out of PM.

People prefer no knobs at all - they want good defaults and they 
want at most a single, intuitive, actionable control to override 
the automation in 1% of the usecases, such as screen brightness.

> A single stupid behaviour in a desktop app is all it needs to 
> knock the odd hour or two off your battery life. Something is 
> mundane as refreshing a bit of the display all the time 
> keeping the GPU and CPU from sleeping well.

Even with highly powertop-optimized systems that have no such 
app and have very low wakeup rates we still lag behind the 
competition.

> Most distros haven't managed to do power management properly 
> because it is this entire integration problem. Every single 
> piece of the puzzle has to be in place before you get any 
> serious gain.

Most certainly.

So why not move most pieces into one well-informed code domain 
(the kernel) and only expose high level controls, instead of 
expecting user-space to get it all right.

Then the 'only' job of user-space would be to not be silly when 
implementing their functionality. (and there's nothing 
intimately PM about that.)

> It's not a kernel v user thing. The kernel can't fix it, 
> random bits of userspace can't fix it. This is effectively a 
> "product level" integration problem.

Of course the kernel can fix many parts by offering automation 
like automatically shutting down unused interfaces (and offering 
better ABIs if that is not possible due to some poor historic 
choice), choosing frequencies and C states wisely, etc.

Kernel design decisions *matter*:

Look for example how moving X lowlevel drivers from user-space 
into kernel-space enabled GPU level power management to begin 
with. With the old X method it was essentially impossible. Now 
it's at least possible.

Or look at how Android adding a high-level interface like 
suspend blockers materially improved the power saving situation 
for them.

This learned helplessness that "the kernel can do nothing about 
PM" is somewhat annoying :-)

Thanks,

	Ingo
