Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415Ab0E0OaR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 10:30:17 -0400
Received: from www.tglx.de ([62.245.132.106]:54031 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755177Ab0E0OaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 10:30:15 -0400
Date: Thu, 27 May 2010 16:29:35 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Florian Mickler <florian@mickler.org>,
       Vitaly Wool <vitalywool@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, Paul@smtp1.linux-foundation.org,
       felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
In-Reply-To: <AANLkTinOf__Q9XIM1Lll1eJ5HZ35zkDlUp60LmGcetdG@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1005271545190.3032@localhost.localdomain>
References: <1274482015-30899-1-git-send-email-arve@android.com> <201005242049.18920.rjw@sisk.pl> <87wrusvrqe.fsf@deeprootsystems.com> <201005250138.16293.rjw@sisk.pl> <1274863655.5882.4875.camel@twins> <AANLkTinN6MKvCEhPkbYQRD2gu-mGXdNW9asRsTuKN3_Y@mail.gmail.com>
 <1274867106.5882.5090.camel@twins> <20100526120242.5c9b73ad@schatten.dmk.lab> <AANLkTim4021cTnhVZrQpefq1MG-eEPOFLDRO-XDepHb4@mail.gmail.com> <20100526133721.602633b2@schatten.dmk.lab> <AANLkTikzgaOFdQKess4E-D86OLPOzxP3dWiDkU_UR0ri@mail.gmail.com>
 <20100526142430.327ccbc4@schatten.dmk.lab> <20100526141612.3e2e0443@lxorguk.ukuu.org.uk> <AANLkTin97MMu-XO_Lk-snefBWz2ymhS0Qi1y1RxLwdVA@mail.gmail.com> <20100527003943.07c17f85@lxorguk.ukuu.org.uk>
 <AANLkTinOf__Q9XIM1Lll1eJ5HZ35zkDlUp60LmGcetdG@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1214337073-1274970581=:3032"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1214337073-1274970581=:3032
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Wed, 26 May 2010, Arve Hjønnevåg wrote:
> 2010/5/26 Alan Cox <alan@lxorguk.ukuu.org.uk>:
> > On Wed, 26 May 2010 15:30:58 -0700
> > Arve Hjønnevåg <arve@android.com> wrote:
> >
> >> On Wed, May 26, 2010 at 6:16 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> >> >> Really, what are you getting at? Do you deny that there are programs,
> >> >> that prevent a device from sleeping? (Just think of the bouncing
> >> >> cows app)
> >> >>
> >> >> And if you have two kernels, one with which your device is dead after 1
> >> >> hour and one with which your device is dead after 10 hours. Which would
> >> >> you prefer? I mean really... this is ridiculous.
> >> >
> >> > The problem you have is that this is policy. If I have the device wired
> >> > to a big screen and I want cows bouncing on it I'll be most upset if
> >> > instead it suspends.
> >>
> >> We never suspend when the screen is on. If the screen is off, I would
> >> not be upset if it suspends.
> >
> > This is policy and platform specific. The OLPC can suspend with the
> > screen on. Should I write my app to know about this once for Android and
> > once for OLPC (and no doubt once for Apple). In the OLPC case cows could
> > indeed suspend to RAM between frames if the wakeup time was suitable.
> 
> Are you still talking about Linux suspend? If you can enter S3 from
> idle and still wake up for the next timer or interrupt, then do that.
> Suspend blockers should have not effect on this.

It does not matter whether it's S3 or any other power saving
state / mechanism in a particular device.

What matters is that the kernel needs to know about the QoS
requirements of the applications which are active to make optimal
decisions for power management. 

If we can go into any given power state from idle then the decision
which power state to select needs to be made on the requirements of an
application to react on the next event (timer, interrupt, ...).

So yes, we could go into S3 (with some effort) and arm the wakeup
source which will bring us back when the requirements of the apps are
known at the point where the decision is made.

> >
> > My app simply should not have to know this sort of crap, that's the whole
> > point of an OS.
> >
> 
> Most apps does not have to know about this with opportunistic suspend
> either. If the user is interacting with the device, we don't suspend.
> If your apps needs to run when the user is not interacting with the
> device, then you can block suspend.

You can express that in QoS requirements as well. If you say "max
wakeup latency 100ms" then the kernel will select a power state which
will meet this requirement. So it can decide whether to go into full
suspend on a given system or select some other better suiting power
saving mechanism. But this allows us to express this in a completely
hardware independent way. If the hardware does not provide a suitable
state, then the box stays on.

> >> > What you are essentially arguing for is for the
> >> > kernel to disobey the userspace.
> >>
> >> No I'm not. User-space asked the kernel to suspend when possible.
> >> Suspend is an existing kernel feature. All opportunistic suspend adds
> >> is the ability to use it safely when there are wakeup event you cannot
> >> afford to ignore.
> >
> > Don't get me wrong - opportunistic suspend isn't the problem. Suspend
> > blockers are - or more precisely - the manner in which they express
> > intent from userspace. Opportunistic suspend is wonderful stuff for all
> > sorts of things and if it persuades people like netbook manufacturers to
> > think harder, and Linux driver authors to optimise their suspend/resume
> > paths we all win.
> >
> >> Our actual stating point is this: Some systems can only enter their
> >> lowest power state from suspend. So we added an api that allowed us to
> >> use suspend without loosing wakeup events. Since suspending also
> >> improves our battery life on platforms that enter the same power state
> >> from idle and suspend and we already have a way to safely use suspend,
> >> we would be crazy not to use it.
> >
> > Opportunistic suspend isn't special. Suspend is just a very deep idle. In
> 
> Suspend as it is currently implemented in Linux is special. Regular
> timers stop, and only specially marked wakeup events can bring the
> system back to the normal state.

That's a matter of the current implementation. We can change that and
improve it to do better resource management. And this requirement is
not restricted to the mobile phone space, it's true for laptops,
virtualization and other areas as well.
 
> > But you can express user suspend blocking in this manner. Your call
> > incoming code would say 'I want good latency'. As someone needs good
> > latency the box won't suspend. If your approach is to start with an
> > initial 'anyone can set a low latency we don't care' then anyone can
> > block suspends.
> >
> > Equally your call handling example is about latency not about suspend.
> > You want the phone to stay on, to fetch a picture and display it promptly.
> >
> 
> I don't think a latency api is the right way to express this since the
> only latency values we would use is minimal-latency and any-latency.
> What we are expressing is that this works need to happen now, even if
> the user is not currently interacting with the device.

You're mind is stuck in a black and white decision scheme, which you
implemented with the suspend blockers big hammer approach.

There is a wide variety between minimal and any latency. It depends on
the task at hand. An interactive application will want a latency which
is in the range of acceptable user experience, but that's not
necessarily the minimal latency which the system can guarantee and
provide. A background task can say "I'm fine with 100ms" which allows
the kernel to aggregate wakeups in a clever way.

Even if andorid decides that min and any are the only two which
matter, then this approach will work for android, but lets us use the
same mechanism and technology in other areas where people are
interested to express more than the on/off QoS requirements.

> > So my working position is summarised thusly
> >
> > - Supporting Android needs well good
> > - Opportunistic suspend good
> > - Manner in which interface is expressed to userspace bad
> > - Latency constraint interface would be better
> > - Your existing behaviour can be implemented by a simplistic use of a
> >  latency constraint interface
> > - We can fix a pile of other directly connected things at the same time
> > - Implementation internals I care far less about because we can fix those
> >  later
> > - Suspend is just a power state
> >
> > How does that fit your model and vision ?
> >
> 
> We have two main modes of operation. The user is interacting with the
> device and tasks and timers should run as requested. And, the user is
> not interacting with the device and the device should enter (and stay
> in) low power states regardless of running tasks and timers. Since
> some events (e.g. incoming phone call, alarm clock) will may cause the
> user to start interacting with the device, they need special
> treatment. A per thread latency api does not work for us. A global
> latency api could work, but since would only use minimal latency or
> any latency this seem like overkill. Also, with a global latency api,
> how do I know it the requested latency is meant to improve the
> experience while the user is interacting with the app, or if it meant
> the app needs to run when the user is not interacting with the device.

Again. You do not need a global latency API. A per thread and probably
per device latency information is what matters. The global state is
extracted from the per thread/device information.

With your global approach - which is basically the suspend blocker in
a different disguise - you prevent actively that the kernel can do
more clever decisions vs. power savings when there are more options
than suspend or not suspend.

> >> What about platforms that currently cannot enter low power states from
> >> idle? Do you remove suspend support from the kernel?
> >
> > I would actually expect a system that can't do any low power states to
> > support the user API and blissfully ignore it. Applications will ask for
> 
> I don't think you understood what I asked. Currently most x86 systems
> can enter much lower power states from suspend than they can from
> idle. Are you suggesting that we remove suspend support from Linux and
> try to enter the same power states on x86 from idle that we now enter
> from suspend? It is not clear to me if this is possible.

That does not matter whether we can do that right now or whether it's
possible at all on X86. The point is that the hardware is improving
and implementing better power saving mechanisms which allow us fine
grained control over the way we save power. 

So if a system can't go into suspend from idle, then the kernel can
simply ignore that all apps told the kernel that they don't care about
latency and QoS at the moment. It just selects the lowest power state
available. And if it has no power states at all, everything just works
fine.

OTOH, when you have this fancy application which just blinks with the
LED every two seconds for whatever reason, then your black and white
approach might prevent entering suspend just because the suspend
wakeup latency is 2.2 seconds and the kernel does not know that the
LED blinker app does not care whether it's actually 2 or 2.5 seconds.

Power management has more than two states, and the most important
information for selecting a state is the acceptable latency which a
given application can tolerate for coming out of the state in order to
meet the deadlines which can be given by a particular device fifo
length or by not violating the user experience.

There is nothing which prevents you of using the black and white
approach and just using the min and any latency values to express what
you think is the best for android, but you do not prevent other people
that way from taking a more sensible approach.

Thanks,

	tglx
--8323328-1214337073-1274970581=:3032--
