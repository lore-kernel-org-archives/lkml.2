Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933544Ab0FEWnI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 18:43:08 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55495 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933381Ab0FEWnG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 18:43:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: suspend blockers & Android integration
Date: Sun, 6 Jun 2010 00:44:16 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       tytso@mit.edu, Brian Swetland <swetland@google.com>,
       Neil Brown <neilb@suse.de>, Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20100603193045.GA7188@elte.hu> <alpine.LFD.2.00.1006051736040.2933@localhost.localdomain> <AANLkTinD39rI47innPbGz1Gi8PsXV5HqkmaQuJ70oQ63@mail.gmail.com>
In-Reply-To: <AANLkTinD39rI47innPbGz1Gi8PsXV5HqkmaQuJ70oQ63@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006060044.16950.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 05 June 2010, Arve Hjønnevåg wrote:
> 2010/6/5 Thomas Gleixner <tglx@linutronix.de>:
> > B1;2005;0cOn Fri, 4 Jun 2010, Arve Hjønnevåg wrote:
> >
> >> 2010/6/4 Thomas Gleixner <tglx@linutronix.de>:
> >> > Arve,
> >> >
> >> > On Fri, 4 Jun 2010, Arve Hjønnevåg wrote:
> >> >
> >> >> On Fri, Jun 4, 2010 at 5:05 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >> >> > On Sat, 5 Jun 2010, Rafael J. Wysocki wrote:
> >> >> >> I kind of agree here, so I'd like to focus a bit on that.
> >> >> >>
> >> >> >> Here's my idea in the very general terms:
> >> >> >>
> >> >> >> (1) Use the cgroup freezer to "suspend" the "untrusted" apps (ie. the ones
> >> >> >>     that don't use suspend blockers aka wakelocks in the Android world) at the
> >> >> >>     point Android would normally start opportunistic suspend.
> >> >> >
> >> >> > There is an additional benefit to this approach:
> >> >> >
> >> >> >     In the current android world a background task (e.g. download
> >> >> >     initiated before the screensaver kicked in) prevents the suspend,
> >> >> >     but that also means that the crapplications can still suck power
> >> >> >     completely unconfined.
> >> >> >
> >> >>
> >> >> Yes this can happen. It is usually only a big problem when you combine
> >> >> an (trusted) application that has a bug that blocks suspend forever
> >> >> with an application that wakes up too often for us to enter low power
> >> >> idle modes.
> >> >
> >> > Why is it a BUG in the trusted app, when I initiate a download and put
> >> > the phone down ?
> >> >
> >>
> >> It is not, but we have had bugs where a trusted app does not unblock
> >> suspend after some failure case where it is no longer making any
> >> progress.
> >
> > Well, that's simply an application bug which sucks battery with or
> > without suspend blockers. So it's unrelated to the freezing of
> > untrusted apps while a trusted app still works in the background
> > before allowing the machine to suspend.
> >
> 
> It is not unrelated if the trusted app has stopped working but still
> blocks suspend. The battery drains when you combine them.
> 
> >> > That download might take a minute or two, but that's not an
> >> > justification for the crapplication to run unconfined and prevent
> >> > lower power states.
> >> >
> >>
> >> I agree, but this is not a simple problem to solve.
> >
> > Not with suspend blockers, but with cgroup confinement of crap, it's
> > straight forward.
> >
> 
> I don't think is is straight forward. If the a process in the frozen
> group holds a resource that a process in the unfrozen group needs, how
> do deal with that?

That depends a good deal on what you mean by holding a resource.

Generally, however, if your "trusted" processes depend on the processes you
don't trust, then either the former should not be trusted, or the latter should
be trusted.

> >> >> >     With the cgroup freezer you can "suspend" them right away and
> >> >> >     just keep the trusted background task(s) alive which allows us to
> >> >> >     go into deeper idle states instead of letting the crapplications
> >> >> >     run unconfined until the download finished and the suspend
> >> >> >     blocker goes away.
> >> >> >
> >> >>
> >> >> Yes this would be better, but I want it in addition to suspend, not
> >> >> instead of it. It is also unclear if our user-space code could easily
> >> >> make use of it since our trusted code calls into untrusted code.
> >> >
> >> > Sorry, that's really the worst argument I saw in this whole
> >> > discussion.
> >> >
> >> > You're basically saying, that you have no idea what your user space
> >> > stack is doing and you do not care at all as long as your suspend
> >> > blocker scheme makes things work somehow.
> >> >
> >>
> >> Yes I don't know everything our user-space stack is doing, but I do
> >> know that it makes many calls between processes (and in both
> >> directions). As far as I know it uses timeouts when calling into
> >> untrusted code, so a misbehaving application will cause an error
> >> dialog to pop up asking if the user if it should wait longer or
> >> terminate the application.
> >
> > Sigh, the more I learn about the details of android and it's violation
> > of all sane engineering principles the more I understand why you
> > invented a huge nail to push through all layers in order to bring the
> > system into idle at all. And yes, you need a sledge hammer to drive
> > that big nail through everything, so you are using the right tool.
> >
> > Seriously, the cross app call goes through your framework, which
> > already knows, that the untrusted part is frozen. So it can deal
> > nicely with it in any way you want including unfreezing.
> 
> Cross app calls do not go through a central process.

Well, yeah.

Arve, we're still learning you have some more requirements we had no idea
about before and such that _only_ the suspend blockers (or wakelocks) framework
is suitable to satisfy them.  I don't realistically think we can make any
progress this way.

> >> > Up to that point, I really tried hard to step back from my initial
> >> > "OMG, promoting crap is a nono" reaction and work with you on a
> >> > sensible technical solution to confine crap and make it aligned with
> >> > other efforts in this area.
> >> >
> >> > So now, after I spent a reasonable amount of time (as you did) to
> >> > understand what your requirements are, you come up with another
> >> > restriction which is so outside of any level of sanity, that I'm at
> >> > the point of giving up and just going into NAK mode.
> >> >
> >>
> >> I don't think this is a new restriction. Both Brian and I have
> >> mentioned that we have a lot of dependencies between processes.

Which is not the same as "the dependencies are such that they can't be
taken into account in any way other than by using wakelocks (or suspend
blockers)".

> >> > Can you please answer the following question:
> >> >
> >> >    What is the point of having the distinction of "trusted" and
> >> >    "untrusted" when you have no way to prevent "trusted" code calling
> >> >    "into "untrusted" code ?
> >> >
> >>
> >> Trusted code that calls into untrusted code has to deal with the
> >> untrusted code not responding, but we only want to pop up a message
> >> that the application is not responding if it is misbehaving, not just
> >> because it was frozen though no fault of its own.

When Android starts opportunistic suspend, all applications are frozen,
"trusted" as well as "untrusted", right?  So, after they are all frozen, none
of them can do anything to prevent suspend from happening, right?

Now, in my proposed approach the "untrusted" apps are frozen exactly at the
point Android would start opportunistic suspend and they wouldn't be able
to do anything about that anyway.  So if one of your "trusted" apps depends
on the "untrusted" ones in a way that you describe, you alread have a bug
(the "trusted" app cannot prevent automatic suspend from happening even if it
wants, because it depends on an "untrusted" app that has just been frozen).

> >> > That's violating any sense of abstraction and layering and makes it
> >> > entirely clear that the only way you can deal with your own design
> >> > failure is a big hammer which you need to force into the kernel.
> >> >
> >>
> >> How can it be fixed? The user presses the back button, the framework
> >> determines that app A is in the foreground and send the key to app A,
> >> app A decides that it it does not have anything internal to go back to
> >> and tells the framework to switch back to the previous app. If the
> >> user presses the back key again, the framework does not know which app
> >> this key should go to until app A has finished processing the first
> >> key press.
> >
> > Errm, what has this to do with frozen apps? If your system is
> > handling input events then there are no frozen apps and even if they
> > are frozen your framework can unfreeze them _before_ talking to them.
> >
> > So which unfixable problem are you describing with the above example ?
> >
> 
> You are claiming that trusted code should not have any dependencies on
> untrusted code.

Not "any".  It shouldn't have dependencies that make a difference between
"trusted" and "untrusted".

Think of security, for example.  A root-owned process surely can exchange data
with processes owned by non-root users, but it shouldn't blindly accept any
data these processes give it.

Your wakelock-holding application is a counterpart of the root-owned process
above.  It can exchange data with processes that don't take wakelocks, but not
in such a way that would prevent them from taking wakelocks if necessary
(or from dropping wakelocks if no longer needed from their point of view).

If this condition is satisfied, then I claim you won't have any problems with
freezing the "untrusted" apps upfront.  If this condition is not satisfied, in
turn, your framework already doesn't work.

Rafael
