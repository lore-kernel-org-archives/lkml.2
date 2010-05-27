Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932168Ab0E0Qqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 12:46:30 -0400
Received: from www.tglx.de ([62.245.132.106]:48968 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757984Ab0E0Qq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 12:46:28 -0400
Date: Thu, 27 May 2010 18:45:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul@smtp1.linux-foundation.org,
       felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <20100527155201.GA31937@srcf.ucam.org>
Message-ID: <alpine.LFD.2.00.1005271808340.3032@localhost.localdomain>
References: <20100526120242.5c9b73ad@schatten.dmk.lab> <AANLkTim4021cTnhVZrQpefq1MG-eEPOFLDRO-XDepHb4@mail.gmail.com> <20100526133721.602633b2@schatten.dmk.lab> <AANLkTikzgaOFdQKess4E-D86OLPOzxP3dWiDkU_UR0ri@mail.gmail.com> <20100526142430.327ccbc4@schatten.dmk.lab>
 <20100526141612.3e2e0443@lxorguk.ukuu.org.uk> <AANLkTin97MMu-XO_Lk-snefBWz2ymhS0Qi1y1RxLwdVA@mail.gmail.com> <20100527003943.07c17f85@lxorguk.ukuu.org.uk> <20100527140655.GA28048@srcf.ucam.org> <alpine.LFD.2.00.1005271642440.3032@localhost.localdomain>
 <20100527155201.GA31937@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 May 2010, Matthew Garrett wrote:
> On Thu, May 27, 2010 at 05:32:56PM +0200, Thomas Gleixner wrote:
> > On Thu, 27 May 2010, Matthew Garrett wrote:
> > > Now let's try this in the Android world. The user hits a key and the 
> > > system wakes up. The input layer takes a suspend block. The application 
> > > now draws all the cows it wants to, takes its own suspend block and 
> > > reads the input device. This empties the queue and the kernel-level 
> > > suspend block is released. The application then processes the event 
> > > before releasing the suspend block. The event has been delivered and 
> > > handled.
> > 
> > Thanks for providing this example:
> > 
> >   1) It proves that suspend blockers are solely designed to encourage
> >      people to code crap.
> 
> No. Suspend blockers are designed to ensure that suspend isn't racy with 
> respect to wakeup events. The bit that mitigates badly written 
> applications is the bit where the scheduler doesn't run any more.
> 
> If you're happy with a single badly written application being able to 
> cripple your power management story, you don't need opportunistic 
> suspend. But you still have complications when it comes to deciding to 
> enter suspend at the same time as you receive a wakeup event.

Wrong. Setting the QoS requirements of the badly written app to any
latency will allow the kernel to suspend even if the crappy app is
active.

And again. I'm opposing the general chant that fixing crappy
applications in the kernel is a good thing. It's the worst decision we
could make.
 
> >      And you need to do that, because the user applications suspend
> >      blocker magic is racy as hell. To work around that you sprinkle
> >      your suspend blocker magic all over the kernel instead of telling
> >      people how to solve the problem correctly.
> 
> What /is/ the correct way to solve this problem when entering explicit 
> suspend states? How do you guarantee that an event has been delivered to 
> userspace before transitioning into suspend? Now, this is a less 
> interesting problem if you're not using opportunistic suspend, but it's 
> still a problem.

Holy crap. If an event happens _before_ we go into an idle state - and
I see suspend as an deeper idle state - then we do not go there at all.

The whole notion of treating suspend to RAM any different than a plain
idle C-State is wrong. It's not different at all. You just use a
different mechanism which has longer takedown and wakeup latencies and
requires to shut down stuff and setup extra wakeup sources.

And there is the whole problem. Switching from normal event delivery
to those special wakeup sources. That needs to be engineered in any
case carefuly and it does not matter whether you add suspend blockers
or not.
 
> >      Simply because you move the cow drawing CPU time from the point
> >      where the device wants to go into suspend to the point where the
> >      user hits a key again. You even delay the reaction of your app to
> >      the user input by the time it needs to finish drawing cows.
> 
> It's how application mainloops tend to work.

So what's the f*cking point ? You draw exactly the same amount of
power and still you are claiming that it's better or what ?
 
> > > You can't express that with resource limits or QoS constraints. If you 
> > > want to deal with this kind of situation then, as far as I can tell, you 
> > > need either suspend blockers or something so close to them that it makes 
> > > no difference.
> > 
> > Wrong. If your application is interactive then you set the QoS
> > requirement once to interactive and be done.
> >
> > So the correct point to make a power state decision is when the app
> > waits for a key press. At this point the kernel can take several
> > pathes:
> > 
> >       1) Keep the system alive because the input device is in active
> >        	 state and a key press is expected
> > 
> >       2) Go into supsend because the input device is deactivated after
> >       	 the screen lock kicked in.
> 
> That's no good. If the input device has been deactivated, how does the 
> wakeup event get delivered to the application?
>  
> > This behaves exactly the same way in terms of power consumption as
> > your blocker example just without all the mess you are trying to
> > create.
> 
> And means that wakeup events don't get delivered. That's a shortcoming.

That's utter nonsense. If we have a problem with missed wakeups then
it needs to be fixed and not papered over with suspend blocker magic.

I'm starting to get really grumpy about the chant that suspend
blockers are the only way to fix missed wakeups. That might be the
only way you can think of with your pink android glasses on, but again
this is not rocket science even if it does not fit into the current
way the kernel handles the whole suspend mechanism.

So if we really sit back and look at suspend as another idle state,
then we have first off the same requirements for entering it as we
have for any other idle state:

     No running tasks (and we can solve the don't care task problem
     nicely with QoS)

Aside of that we need to bring devices into a quiescent state and
setup the wakeup sources. That switch over needs to be done with and
without suspend blockers in a careful way for each SoC
implementation. 

If the interrupt happens _BEFORE_ we switch over to the quiescent
state, then we need to backout. If it happens after the switch then it
goes into the nirwana if the suspend wakeup has not been set up
correctly. If we have it setup correctly then we go into suspend just
to come back immediately. There is nothing you can do about that with
suspend blockers.

So if the interrupt comes in before we switch then we have that
information already today. We might not make use of it or just in a
racy way, but that does not warrant to work around that problem with a
big hammer approach.

You can try to lull me into cozy suspend blocker acceptance as long as
you want, but you better spend your time on either giving a coherent
explanation why suspend blockers are necessary or looking at the
underlying problem and fixing it in a technical correct way.

Thanks,

	tglx
