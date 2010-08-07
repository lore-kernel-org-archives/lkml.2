Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab0HGPcc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 11:32:32 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:37705 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117Ab0HGPcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 11:32:31 -0400
Date: Sat, 7 Aug 2010 08:32:25 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: david@lang.hm
Cc: "Ted Ts'o" <tytso@mit.edu>, Brian Swetland <swetland@google.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk,
        menage@google.com, david-b@pacbell.net, James.Bottomley@suse.de,
        arjan@infradead.org, swmike@swm.pp.se, galibert@pobox.com,
        dipankar@in.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
Message-ID: <20100807153225.GD19600@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100731175841.GA9367@linux.vnet.ibm.com>
 <20100804195704.GA23681@linux.vnet.ibm.com>
 <20100806225453.GA3947@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1008061651530.30564@asgard.lang.hm>
 <AANLkTikyRhtfX4R3x_NDgHnXssmfVuhjC5PbhRZ0a7su@mail.gmail.com>
 <alpine.DEB.2.00.1008062010510.30564@asgard.lang.hm>
 <20100807061558.GA28087@thunk.org>
 <alpine.DEB.2.00.1008070206010.30564@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1008070206010.30564@asgard.lang.hm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 07, 2010 at 02:38:35AM -0700, david@lang.hm wrote:
> On Sat, 7 Aug 2010, Ted Ts'o wrote:
> 
> >On Fri, Aug 06, 2010 at 08:14:09PM -0700, david@lang.hm wrote:
> >>
> >>that description sounds far more like normal sleep power management
> >>that suspending. especially since they want to set timers to wake
> >>the system up and the defining characteristic of suspend (according
> >>to this thread) is that timers don't fire while suspended.
> >>
> >>as I am seeing it, there are two reasons why this don't "just work"
> >>
> >>1. sleeping can't currently save as much power as suspending
> >
> >No, I don't think that's the case at all.  The key thing here is that
> >*most* applications don't need to be modified to use suspend locks,
> >because even though they might be in an event loop, when the user user
> >turns off the display, the user generally doesn't want it doing things
> >on their behalf.
> >
> >Again, take for example the Mac Book, since Apple has gotten this
> >right for most users' use cases.  When you close the lid, you even if
> >the application is under the misguided belief that it should be
> >checking every five seconds to see whether or not the web page has
> >reloaded --- actually, that's not what you want.  You probably want
> >the application to be forcibly put to sleep.  So the whole point of
> >the suspend blocker design is that you don't have to modify most
> >applications; they just simply get put to sleep when you close the
> >MacBook lid, or, in the case of the Android device, you push the
> >button that turns off the screen.
> 
> this doesn't require wakelocks or anything else new. all it takes is
> setting the policy that you don't want anything to run when the lid
> is closed and a switch to detect the lid being closed. Laptops have
> been doing this for years.

Please re-read Ted's paragraph above, but carefully this time.  You will
then see that the desired policy is -not- "you don't want anything to
run when the lid is closed."

> >So the reason why this doesn't work is that power management for small
> >mobile devices *is* different from power management for laptops and
> >data center servers, and if you want a rich application ecosystem,
> >it's best if you don't require them to be specially tuned to use the
> >absolute minimum power.  (And that means waking up every 30 seconds
> >might be too much; as Brian and Arve have pointed out, with the G1 in
> >airplane mode, the CPU might be waking up once every half hour or more
> >--- and at that rate, powertop will be waking up the CPU more than
> >Android system would be doing so.)
> 
> note that nothing that I have proposed would wake up a sleeping
> system. the 'every several seconds' thing that I proposed was that
> on a system that's fully awake, busy and doesn't want to sleep,
> there would be a context switch periodically by a privilaged process
> so that the system would not end up deciding it was idle and halt
> everything. Now that I think about this more, it's not needed if you
> want to override this to keep everything running for a significant
> amount of time, just change the power saving mode from "sleep if a
> privilaged task isn't running" to "disable suspend". This can be
> done today by changing the right sysfs value. normal privilaged
> processes would never need to do this, only gatekeeper daemons that
> want to let unprivilaged processes run even if no privilaged
> processes want to run would need to do this (i.e. in the current
> system, whatever process controls the screen would probably be
> right)
> 
> >So the real key here is to take most applications, which may be
> >written using techniques that might be considered well written from a
> >laptop point of view, but not for a cell phone, and not require
> >modifications.  Even though the application writer might think it's
> >doing well by waking up every 15 seconds, if the laptop lid is down,
> >or if the screen is off, for **most** applications, it should be
> >forcibly put to sleep.
> >
> >It's only the rare applications that should really be allowed to run
> >while screen is off.  And it's only those applications that need
> >modifications to use suspend blocker.  From your earlier comments, it
> >seems that this is the key point which you are missing.  (No doubt,
> >some of these applications that do need to know about suspend blockers
> >are important ones; ones that make sure the battery isn't about to
> >blow up, or ones which silently wake up every 10-15 minutes to pull
> >down fresh mail for you from your mail server.  But those applications
> >are the exception, not the rule.)
> 
> the question is what it takes to make an application privilaged like this.
> 
> what I proposed was to make it possible for the user/admin to select
> what applications are allowed to keep the system awake.

The Android guys do the same.

> wakelocks require that the application developer decide that they
> want to keep the system awake as well as the user/admin

Whereas you require that the application developer redesign/rewrite
applications to decide when to keep the system awake, e.g., by carefully
determining when to idle themselves.  The difference is that the Android
developer need only release a suspend blocker.  In contrast, you are
requiring that the developer rewrite all the code that follows the point
where the Android developer would release a suspend blocker.

Your way seems to require that the developer do more work for the
same result.  Why?

Now, I do agree that a safe way to freeze the power-oblivious applications
could be valuable, as it might reduce power consumption while the
screen was blanked but while a PM-driving application was holding a
suspend blocker.  However, as we have discussed, you have to be very
careful not to freeze any app holding a user-level resource.

> take your example of a mail client waking up every 15 min.
> 
> with Android it needs to be privilaged to grab the wakelock while
> fetching the mail, it also needs to use a privilaged API to set the
> wakeups to wake it up at those times.
> 
> with what I proposed all you need to do is to tag the application as
> power privilaged and then if the application sleeps for 15 min
> between doing thing the system will wake up every 15 min, work for a
> short time, then go back to sleep.
> 
> 
> if you want to put everything to sleep when the screen blanks,
> that's trivial to do.
> 
> the fun starts when you want to say that there are some things you
> don't want to put to sleep.

Which is in fact a critical requirement that you appear to have been
ignoring in your words above.

> do you let some processes run while halting others?
>   in which case how do you prevent deadlocks?
>     on the other hand, sleeping again is simple, you sleep when
> there is nothing more to run
> or do you let wasteful processes run while you are awake?
>   this avoids deadlocks, but how do you decide when to sleep again?
> 
> 
> Android approaches this by requiring that any program that a user
> may want to keep running must be modified to use wakelocks.
> 
> My suggestion was that the system ignore other processes when
> deciding if the system is idle enough to put to sleep.

But your suggestion seems to require quite a bit more coding effort for
little gain.  The Android developer can just release a suspend blocker,
and in contrast, a developer using your proposal needs to rewrite all
the code following the point at which the Android developer released the
suspend blocker.  So why are you saying that your is approach better?  ;-)

> Yes the Android approach works reasonably well on the phones where
> everything must currently be custom developed anyway (due to screen
> and UI constraints), but as Android starts getting used on laptops
> and other larger devices is that really still the right approach? or
> would it be better to have something that could use standard
> software in the privilaged mode?
> 
> to use your example of a mail client, why should someone not be able
> to use fetchmail to get their mail instead of requiring that
> fetchmail be modified to use wavelocks (or a substatute written)?
> 
> 
> 
> the theoretical best approach would probably look nothing like
> either of these. Instead it would probably either
> 
> forbid privilaged processes from having blocking dependancies on
> unprivilaged processes (you can then just halt the unprivilaged
> processes when you blank the screen and let idle sleep deal with the
> privilged processes)
> 
> or
> 
> use something like priority inheritance through userspace so that if
> a privilaged process blocks on something where it's waiting for an
> unprivilaged process, that unprivilaged process gets woken up and
> allowed to run until it unblocks the privilaged process.
> 
> both of these have been deemed too hard

And for good reason.

							Thanx, Paul
