Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933586Ab0HEPMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 11:12:21 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:43386 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933467Ab0HEPMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 11:12:17 -0400
Date: Thu, 5 Aug 2010 08:12:11 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: david@lang.hm
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100805151211.GA10080@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <AANLkTimRZc2B1=ic-0jrGBX7ahCu=NCoQadCOePGDmh9@mail.gmail.com>
 <alpine.DEB.2.00.1008041554580.6545@asgard.lang.hm>
 <AANLkTingom2AKfMu0EbfdfLiMnHo+buy1e4=PBENf3Vi@mail.gmail.com>
 <alpine.DEB.2.00.1008041620010.6545@asgard.lang.hm>
 <20100804233013.GN24163@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1008041643490.6545@asgard.lang.hm>
 <20100805001716.GO24163@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1008041722060.6545@asgard.lang.hm>
 <20100805004802.GP24163@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1008042208350.25170@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1008042208350.25170@asgard.lang.hm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 10:18:40PM -0700, david@lang.hm wrote:
> On Wed, 4 Aug 2010, Paul E. McKenney wrote:
> >On Wed, Aug 04, 2010 at 05:25:53PM -0700, david@lang.hm wrote:
> >>On Wed, 4 Aug 2010, Paul E. McKenney wrote:

[ . . . ]

> >>>The music player is an interesting example.  It would be idle most
> >>>of the time, given that audio output doesn't consume very much CPU.
> >>>So you would not want to suspend the system just because there were
> >>>no runnable processes.  In contrast, allowing the music player to
> >>>hold a wake lock lets the system know that it would not be appropriate
> >>>to suspend.
> >>>
> >>>Or am I misunderstanding what you are proposing?
> >>
> >>the system would need to be idle for 'long enough' (configurable)
> >>before deciding to suspend, so as long as 'long enough' is longer
> >>than the music player is idle this would not be a problem.
> >
> >From a user standpoint, having the music player tell the system when
> >it is OK to suspend (e.g., when the user has paused playback) seems
> >a lot nicer than having configurable timeouts that need tweaking.
> 
> every system that I have seen has a configurable "sleep if it's idle
> for this long" knob. On the iphone (work issue, I didn't want it)
> that I am currently using it can be configured from 1 min to 5 min.
> 
> this is the sort of timeout I am talking about.
> 
> with something in the multi-minute range for the 'do a full suspend'
> doing a wakeup every few 10s of seconds is perfectly safe.

Ah, I was assuming -much- shorter "do full suspend" timeouts.

My (possibly incorrect) assumption is based on the complaint that led
to my implementing RCU_FAST_NO_HZ.  A (non-Android) embedded person was
quite annoyed (to put it mildly) at the earlier version of RCU because
it prevented the system from entering the power-saving dyntick-idle mode,
not for minutes, or even for seconds, but for a handful of -milliseconds-.
This was my first hint that "energy efficiency" means something completely
different in embedded systems than it does in the servers that I am
used to.

But I must defer to the Android guys on this -- who knows, perhaps
multi-minute delays to enter full-suspend mode are OK for them.

> >>>>if the backlight being on holds the wakelock, it would seem that
> >>>>almost every other use of the wakelock could (and probably should)
> >>>>be replaced by something that tickles the display to stay on longer.
> >>>
> >>>The problem with this approach is that the display consumes quite a
> >>>bit of power, so you don't want to leave it on unnecessarily.  So if
> >>>the system is doing something (for example, playing music) that does
> >>>not require the display, you really want the display to be off.
> >>
> >>what percentage (and types) of apps are really useful with the
> >>display off. I think that there are relativly few apps that you
> >>really want to keep running if the display is off.
> >
> >The length of time those apps are running is the governing factor
> >for battery life, and not the number of such apps, right?
> 
> correct, but the number of such apps indicates the scope of the problem.

The number of such apps certainly indicates the amount of effort required
to modify them, if required.  Is that what you are getting at?

> >From another e-mail tonight it sounds like almost everything
> >already talks
> 
> to a userspace daemon, so if "(the power management service in the
> system_server, possibly the media_server and the radio interface
> glue)" (plus possibly some kernel activity) are the only things
> looked at when considering if it's safe to sleep or not, all of
> these can (or already do) do 'something' every few seconds, making
> this problem sound significantly smaller than it sounded like
> before.
> 
> Android could even keep it's user-space API between the system power
> daemon and the rest of userspace the same if they want to.
> 
> over time, additional apps could be considered 'trusted' (or flagged
> that way by the user) and not have to interact with the power daemon
> to keep things alive.

Hmmm...  Isn't it the "trusted" (AKA PM-driving) apps that interact with
the power daemon via suspend blockers, rather than the other way around?

> as for intramentation, the key tool to use to see why a system isn't
> going to sleep would be powertop, just like on other linux systems.

Powertop is indeed an extremely valuable tool, but I am not certain
that it really provides the information that the Android guys need.
If I understand Arve's and Brian's posts, here is the scenario that they
are trying to detect:

o	Some PM-driving application has a bug in which it fails to
	release a wakelock, thus blocking suspend indefinitely.

o	This PM-driving application, otherwise being a good citizen,
	blocks.

o	There are numerous power-oblivious apps running, consuming
	significant CPU.

What the Android developers need to know is that the trusted application
is wrongly holding a wakelock.  Won't powertop instead tell them about
all the power-oblivious apps?

							Thanx, Paul
