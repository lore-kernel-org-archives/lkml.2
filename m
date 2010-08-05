Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934876Ab0HEXFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 19:05:23 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:50339 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753672Ab0HEXFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 19:05:14 -0400
Date: Thu, 5 Aug 2010 16:05:07 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: kevin granade <kevin.granade@gmail.com>
Cc: david@lang.hm, Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100805230507.GR2447@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.DEB.2.00.1008041643490.6545@asgard.lang.hm>
 <20100805001716.GO24163@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1008041722060.6545@asgard.lang.hm>
 <20100805004802.GP24163@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1008042208350.25170@asgard.lang.hm>
 <20100805151211.GA10080@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1008050832010.25170@asgard.lang.hm>
 <AANLkTi=Yyyc-hOPbkJtsnKCVzncnFq8DPnonmyckekwm@mail.gmail.com>
 <20100805203102.GN2447@linux.vnet.ibm.com>
 <AANLkTimaaLSwVusJ=w5-QptoauBnHH0JvCvmWUr0y+KD@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimaaLSwVusJ=w5-QptoauBnHH0JvCvmWUr0y+KD@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 03:51:35PM -0500, kevin granade wrote:
> On Thu, Aug 5, 2010 at 3:31 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Thu, Aug 05, 2010 at 01:13:31PM -0500, kevin granade wrote:
> >> On Thu, Aug 5, 2010 at 10:46 AM,  <david@lang.hm> wrote:
> >> > On Thu, 5 Aug 2010, Paul E. McKenney wrote:
> >> >
> >> >> On Wed, Aug 04, 2010 at 10:18:40PM -0700, david@lang.hm wrote:
> >> >>>
> >> >>> On Wed, 4 Aug 2010, Paul E. McKenney wrote:
> >> >>>>
> >> >>>> On Wed, Aug 04, 2010 at 05:25:53PM -0700, david@lang.hm wrote:
> >> >>>>>
> >> >>>>> On Wed, 4 Aug 2010, Paul E. McKenney wrote:
> >> >>
> >> >> [ . . . ]
> >> >>
> >> >>>>>> The music player is an interesting example.  It would be idle most
> >> >>>>>> of the time, given that audio output doesn't consume very much CPU.
> >> >>>>>> So you would not want to suspend the system just because there were
> >> >>>>>> no runnable processes.  In contrast, allowing the music player to
> >> >>>>>> hold a wake lock lets the system know that it would not be appropriate
> >> >>>>>> to suspend.
> >> >>>>>>
> >> >>>>>> Or am I misunderstanding what you are proposing?
> >> >>>>>
> >> >>>>> the system would need to be idle for 'long enough' (configurable)
> >> >>>>> before deciding to suspend, so as long as 'long enough' is longer
> >> >>>>> than the music player is idle this would not be a problem.
> >> >>>>
> >> >>>> From a user standpoint, having the music player tell the system when
> >> >>>> it is OK to suspend (e.g., when the user has paused playback) seems
> >> >>>> a lot nicer than having configurable timeouts that need tweaking.
> >> >>>
> >> >>> every system that I have seen has a configurable "sleep if it's idle
> >> >>> for this long" knob. On the iphone (work issue, I didn't want it)
> >> >>> that I am currently using it can be configured from 1 min to 5 min.
> >> >>>
> >> >>> this is the sort of timeout I am talking about.
> >> >>>
> >> >>> with something in the multi-minute range for the 'do a full suspend'
> >> >>> doing a wakeup every few 10s of seconds is perfectly safe.
> >> >>
> >> >> Ah, I was assuming -much- shorter "do full suspend" timeouts.
> >> >>
> >> >> My (possibly incorrect) assumption is based on the complaint that led
> >> >> to my implementing RCU_FAST_NO_HZ.  A (non-Android) embedded person was
> >> >> quite annoyed (to put it mildly) at the earlier version of RCU because
> >> >> it prevented the system from entering the power-saving dyntick-idle mode,
> >> >> not for minutes, or even for seconds, but for a handful of -milliseconds-.
> >> >> This was my first hint that "energy efficiency" means something completely
> >> >> different in embedded systems than it does in the servers that I am
> >> >> used to.
> >> >>
> >> >> But I must defer to the Android guys on this -- who knows, perhaps
> >> >> multi-minute delays to enter full-suspend mode are OK for them.
> >> >
> >> > if the system was looking at all applications I would agree that the timeout
> >> > should be much shorter.
> >> >
> >> > I have a couple devices that are able to have the display usable, even if
> >> > the CPU is asleep (the OLPC and the Kindle, two different display
> >> > technologies). With these devices I would like to see the suspend happen so
> >> > fast that it can suspend between keystrokes.
> >> >
> >> > however, in the case of Android I think the timeouts have to end up being
> >> > _much_ longer. Otherwise you have the problem of loading an untrusted book
> >> > reader app on the device and the device suspends while you are reading the
> >> > page.
> >> >
> >> > currently Android works around this by having a wakelock held whenever the
> >> > display is on. This seems backwards to me, the display should be on because
> >> > the system is not suspended, not the system is prevented from suspending
> >> > because the display is on.
> >> >
> >> > Rather than having the display be on causing a wavelock to be held (with the
> >> > code that is controls the display having a timeout for how long it leaves
> >> > the display on), I would invert this and have the timeout be based on system
> >> > activity, and when it decides the system is not active, turn off the display
> >> > (along with other things as it suspends)
> >>
> >> IIRC, this was a major point of their (Android's) power management
> >> policy.  User input of any kind would reset the "display active"
> >> timeout, which is the primary thing keeping random untrusted
> >> user-facing programs from being suspended while in use.  They seemed
> >> to consider this to be a special case in their policy, but from the
> >> kernel's point of view it is just another suspend blocker being held.
> >>
> >> I'm not sure this is the best use case to look at though, because
> >> since it is user-facing, the timeout durations are on a different
> >> scale than the ones they are really worried about.  I think another
> >> category of use case that they are worried about is:
> >>
> >> (in suspend) -> wakeup due to network -> process network activity -> suspend
> >>
> >> or an example that has been mentioned previously:
> >>
> >> (in suspend) -> wakeup due to alarm for audio processing -> process
> >> batch of audio -> suspend
> >>
> >> In both of these cases, the display may never power on (phone might
> >> beep to indicate txt message or email, audio just keeps playing), so
> >> the magnitude of the "timeout" for suspending again should be very
> >> small.  Specifically, they don't want there to be a timeout at all, so
> >> as little time as possible time is spent out of suspend in addition to
> >> the time required to handle the event that caused wakeup.
> >
> > It would be good to get some sort of range for the "timeout".  In the
> > audio-output case, my understanding that the spacing between bursts of
> > audio-processing activity is measured in some hundreds of milliseconds,
> > in which case one would want the delays until suspend to be on the
> > millisecond scale.  But does Android really suspend between bursts of
> > audio processing while playing music?  Very cool if so!  ;-)
> 
> Oops, yea that's actually a really bad example, that's probably
> something that would be handled by low-power states.  I think the
> incoming text message example is a good one though.  There seemed to
> be a focus on user-interaction scale time scales, and I wanted to
> point out that there are also very short duration time scales to
> consider as well.
> 
> *back to lurking*

I really don't know the answer myself, so I was really asking the
question rather than trying to catch you out.

							Thanx, Paul

> Kevin
> 
> >
> >                                                        Thanx, Paul
> >
> >> >>>>>>> if the backlight being on holds the wakelock, it would seem that
> >> >>>>>>> almost every other use of the wakelock could (and probably should)
> >> >>>>>>> be replaced by something that tickles the display to stay on longer.
> >> >>>>>>
> >> >>>>>> The problem with this approach is that the display consumes quite a
> >> >>>>>> bit of power, so you don't want to leave it on unnecessarily.  So if
> >> >>>>>> the system is doing something (for example, playing music) that does
> >> >>>>>> not require the display, you really want the display to be off.
> >> >>>>>
> >> >>>>> what percentage (and types) of apps are really useful with the
> >> >>>>> display off. I think that there are relativly few apps that you
> >> >>>>> really want to keep running if the display is off.
> >> >>>>
> >> >>>> The length of time those apps are running is the governing factor
> >> >>>> for battery life, and not the number of such apps, right?
> >> >>>
> >> >>> correct, but the number of such apps indicates the scope of the problem.
> >> >>
> >> >> The number of such apps certainly indicates the amount of effort required
> >> >> to modify them, if required.  Is that what you are getting at?
> >> >
> >> > yes.
> >> >
> >> >>>> From another e-mail tonight it sounds like almost everything
> >> >>>> already talks
> >> >>>
> >> >>> to a userspace daemon, so if "(the power management service in the
> >> >>> system_server, possibly the media_server and the radio interface
> >> >>> glue)" (plus possibly some kernel activity) are the only things
> >> >>> looked at when considering if it's safe to sleep or not, all of
> >> >>> these can (or already do) do 'something' every few seconds, making
> >> >>> this problem sound significantly smaller than it sounded like
> >> >>> before.
> >> >>>
> >> >>> Android could even keep it's user-space API between the system power
> >> >>> daemon and the rest of userspace the same if they want to.
> >> >>>
> >> >>> over time, additional apps could be considered 'trusted' (or flagged
> >> >>> that way by the user) and not have to interact with the power daemon
> >> >>> to keep things alive.
> >> >>
> >> >> Hmmm...  Isn't it the "trusted" (AKA PM-driving) apps that interact with
> >> >> the power daemon via suspend blockers, rather than the other way around?
> >> >
> >> > I was looking at it from a kernel point of view, "trusted" (AKA PM-driving)
> >> > apps are ones that have permission to grab the wakelock. Any app/daemon that
> >> > is so trusted can communicate with anything else in userspace as part of
> >> > making it's decision on whento take the wakelock, but those other
> >> > applications would not qualify as "trusted" in my eyes.
> >> >
> >> >>> as for intramentation, the key tool to use to see why a system isn't
> >> >>> going to sleep would be powertop, just like on other linux systems.
> >> >>
> >> >> Powertop is indeed an extremely valuable tool, but I am not certain
> >> >> that it really provides the information that the Android guys need.
> >> >> If I understand Arve's and Brian's posts, here is the scenario that they
> >> >> are trying to detect:
> >> >>
> >> >> o       Some PM-driving application has a bug in which it fails to
> >> >>        release a wakelock, thus blocking suspend indefinitely.
> >> >>
> >> >> o       This PM-driving application, otherwise being a good citizen,
> >> >>        blocks.
> >> >>
> >> >> o       There are numerous power-oblivious apps running, consuming
> >> >>        significant CPU.
> >> >>
> >> >> What the Android developers need to know is that the trusted application
> >> >> is wrongly holding a wakelock.  Won't powertop instead tell them about
> >> >> all the power-oblivious apps?
> >> >
> >> > in my proposal (without a wakelock), powertop would tell you what
> >> > applications are running and setting timers. If we can modify the
> >> > kernel/suspend decision code to only look at processes in one cgroup when
> >> > deciding if the system should go to sleep, a similar modification to
> >> > poewrtop should let you only show stats on the "trusted" applications.
> >> >
> >> > If you have a userspace power management daemon that accepts requests from
> >> > untrusted programs and does something to keep the system from sleeping
> >> > (either taking a wakelock or setting a 'short' timer), it needs to keep the
> >> > records of this itself because otherwise all the kernel will see (with
> >> > either powertop or wakelock reporting) is that the power management daemon
> >> > is what kept the system from sleeping.
> >> >
> >> > David Lang
> >> > --
> >> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >> > the body of a message to majordomo@vger.kernel.org
> >> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> > Please read the FAQ at  http://www.tux.org/lkml/
> >> >
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
