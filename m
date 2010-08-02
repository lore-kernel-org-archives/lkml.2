Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab0HBBKR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 21:10:17 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:58949 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480Ab0HBBKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 21:10:12 -0400
Date: Sun, 1 Aug 2010 18:10:06 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100802011006.GS2470@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100731175841.GA9367@linux.vnet.ibm.com>
 <20100731215214.2543c07e@infradead.org>
 <20100801054816.GI2470@linux.vnet.ibm.com>
 <20100731230101.7cc1d8c7@infradead.org>
 <20100801191228.GL2470@linux.vnet.ibm.com>
 <20100801154708.19817b75@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100801154708.19817b75@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 01, 2010 at 03:47:08PM -0700, Arjan van de Ven wrote:
> On Sun, 1 Aug 2010 12:12:28 -0700
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > I agree that much progress has been made over the past four years.
> > My laptop's battery life has increased substantially, with roughly
> > half of the increase due to software changes.  Taken over all the
> > laptops and PCs out there, this indeed adds up to substantial and
> > valuable savings.
> > 
> > So, yes, you have done quite well.
> > 
> > However, your reliance on application-by-application fixes, while good
> > up to a point, is worrisome longer term.  The reason for my concern is
> > that computing history has not been kind to those who fail to
> > vigorously automate.  The Android guys have offered up one way of
> > automating power efficiency.  There might be better ways, but their
> > approach does at the very least deserve a fair hearing -- and no one
> > who read the recent LKML discussion of their approach could possibly
> > mistake it for anything resembling a fair hearing.
> > 
> > And yes, I do understand and appreciate your contributions in the
> > form of things like timer aggregation, which does automate the
> > otherwise-tricky task of coordinating power usage across unrelated
> > applications, at least in some important cases.  But power efficiency
> > will likely require multiple approaches, especially if the Linux
> > stack is to approach the power efficiencies provided by dedicated
> > devices.
> 
> power indeed needs multiple approaches. For example the timer work you
> mention. What the timer work allows is controlling the behavior of
> applications that are not well behaved. This is an important way of
> driving progress, one the android guys sort of swept under the table.
> 
> Is the flash plugin (which seems to be the most popular and also worst
> behaving software in these type of discussions) waking up 100 times per
> second? <small adjustment by a policy manager> ... now it's only waking
> up once every 10 seconds, or when something else causes system activity
> anyway.
> 
> That capability is there in Linux today, and has been there for a long
> time now. It's highly underused unfortunately... at least outside the
> MeeGo world of Linux distributions. 

I agree that timer control is important and will continue to be.
It doesn't seem to me to be in conflict with the Android guys' approach,
in fact, it should help reduce power consumption while the device
is active.  I might well be missing something, though.

> Another one: freezing whole cgroups..... we have that today. it
> actually works quite well.... of course the hard part is the decision
> what to put in which cgroup, and at what frequency and duration you let
> cgroups run.

Indeed, the Android guys seemed to be quite excited by cgroup freezing
until they thought about the application-classification problem.
Seems like it should be easy for some types of applications, but I do
admit that apps can have non-trivial and non-obvious dependencies.

> on the suspend blockers for drivers; the linux device runtime PM is
> effectively doing the same things; it allows drivers to suspend/resume
> individually (with a very nice API/programming model I should say) based
> on usage. And it works on a tree level, so that it's relatively easy
> to do things like "I want to go to <this magic deep idle state>, but
> only if <this set of devices is suspended already>". This is obviously
> an important functionality for all low power devices, ARM or x86. 
> Suspend blockers had this functionality as part of what it did (they do
> more obviously) but I'd wager that the current Linux infrastructure is
> outright nicer. 

This is what Rafael has been working on?

Of course, the Android guys also want to pay attention to which apps
are running as well as to the state of devices on the system.

> It's what I want to be using for the Intel phone silicon (which isn't
> all that different in power behavior/requirements than ARM based
> silicon), and I need to thank Qualcomm here for providing some very
> good patches to the kernel to allow this model to work for this
> scenario.

I must have missed those, and I am not seeing any obvious commits
in v2.6.35-rc6.  Would you be willing to send a pointer?

> As for the aware-versus-good-behaving point; applications can be aware,
> and yet bad behaving, and can be unaware but good behaving. You don't
> like me saying this, but the reality is that the behavior matters in
> the end. *AND WE OBSERVE THIS BEHAVIOR*. It's not hard to move a
> program/task/whatever from a "behaves well, let run unrestricted" to a
> "doesn't behave well, needs its behavior adjusted" list and back, just
> from its behavior. PowerTOP observes such apps. Android has an
> equivalent thing that observes app behavior. It's not all that hard to 
> detect such things.... and the result is much better than some static
> "aware" flag one can tag an application with. The "aware" flag
> indicates that there is a "before" and an "after", and that that's it.
> Reality isn't so black and white as you stated, but that goes for both
> sides. Observing *current* behavior is much more powerful.
> Is the part of the app you use fine, even though some function you
> don't use behave badly? No problem, you get it categorized with the
> good guys. Is an app 98% working clean, but you on your phone like
> using the 2% all the time? it's moved to the "must get its attitude
> adjusted" list.

If I understand you correctly, a key point of agreement between you and
the Android guys is that both the system and the user have some say over
how applications are treated by the system in terms of how seriously
the system takes a given application's requests.

The Android guys also want the user to have some say about what
applications are permitted to have some control over "I want to go to
<this magic deep idle state>" requests.  Does that seem reasonable
to you?

						Thanx, Paul
