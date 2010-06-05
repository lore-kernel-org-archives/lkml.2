Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933725Ab0FEQuf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 12:50:35 -0400
Received: from www.tglx.de ([62.245.132.106]:35531 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933666Ab0FEQue (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 12:50:34 -0400
Date: Sat, 5 Jun 2010 18:47:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, tytso@mit.edu,
       Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
       Alan Stern <stern@rowland.harvard.edu>,
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
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend blockers & Android integration
In-Reply-To: <AANLkTikU21xF49Z-_Lnrq7U7buNmqw_gyEEST8LuN24z@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1006051736040.2933@localhost.localdomain>
References: <20100603193045.GA7188@elte.hu> <20100603232302.GA16184@elte.hu> <1275644619.27810.39462.camel@twins> <201006050138.30859.rjw@sisk.pl> <alpine.LFD.2.00.1006050148080.2933@localhost.localdomain> <AANLkTikGDSzaENwg_0BAtsYf3ulGd_6sGPR30WsvUxMi@mail.gmail.com>
 <alpine.LFD.2.00.1006050246350.2933@localhost.localdomain> <AANLkTikU21xF49Z-_Lnrq7U7buNmqw_gyEEST8LuN24z@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-852715769-1275756468=:2933"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-852715769-1275756468=:2933
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

B1;2005;0cOn Fri, 4 Jun 2010, Arve Hjønnevåg wrote:

> 2010/6/4 Thomas Gleixner <tglx@linutronix.de>:
> > Arve,
> >
> > On Fri, 4 Jun 2010, Arve Hjønnevåg wrote:
> >
> >> On Fri, Jun 4, 2010 at 5:05 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >> > On Sat, 5 Jun 2010, Rafael J. Wysocki wrote:
> >> >> I kind of agree here, so I'd like to focus a bit on that.
> >> >>
> >> >> Here's my idea in the very general terms:
> >> >>
> >> >> (1) Use the cgroup freezer to "suspend" the "untrusted" apps (ie. the ones
> >> >>     that don't use suspend blockers aka wakelocks in the Android world) at the
> >> >>     point Android would normally start opportunistic suspend.
> >> >
> >> > There is an additional benefit to this approach:
> >> >
> >> >     In the current android world a background task (e.g. download
> >> >     initiated before the screensaver kicked in) prevents the suspend,
> >> >     but that also means that the crapplications can still suck power
> >> >     completely unconfined.
> >> >
> >>
> >> Yes this can happen. It is usually only a big problem when you combine
> >> an (trusted) application that has a bug that blocks suspend forever
> >> with an application that wakes up too often for us to enter low power
> >> idle modes.
> >
> > Why is it a BUG in the trusted app, when I initiate a download and put
> > the phone down ?
> >
> 
> It is not, but we have had bugs where a trusted app does not unblock
> suspend after some failure case where it is no longer making any
> progress.

Well, that's simply an application bug which sucks battery with or
without suspend blockers. So it's unrelated to the freezing of
untrusted apps while a trusted app still works in the background
before allowing the machine to suspend.
 
> > That download might take a minute or two, but that's not an
> > justification for the crapplication to run unconfined and prevent
> > lower power states.
> >
> 
> I agree, but this is not a simple problem to solve.

Not with suspend blockers, but with cgroup confinement of crap, it's
straight forward.

> >> >     With the cgroup freezer you can "suspend" them right away and
> >> >     just keep the trusted background task(s) alive which allows us to
> >> >     go into deeper idle states instead of letting the crapplications
> >> >     run unconfined until the download finished and the suspend
> >> >     blocker goes away.
> >> >
> >>
> >> Yes this would be better, but I want it in addition to suspend, not
> >> instead of it. It is also unclear if our user-space code could easily
> >> make use of it since our trusted code calls into untrusted code.
> >
> > Sorry, that's really the worst argument I saw in this whole
> > discussion.
> >
> > You're basically saying, that you have no idea what your user space
> > stack is doing and you do not care at all as long as your suspend
> > blocker scheme makes things work somehow.
> >
> 
> Yes I don't know everything our user-space stack is doing, but I do
> know that it makes many calls between processes (and in both
> directions). As far as I know it uses timeouts when calling into
> untrusted code, so a misbehaving application will cause an error
> dialog to pop up asking if the user if it should wait longer or
> terminate the application.

Sigh, the more I learn about the details of android and it's violation
of all sane engineering principles the more I understand why you
invented a huge nail to push through all layers in order to bring the
system into idle at all. And yes, you need a sledge hammer to drive
that big nail through everything, so you are using the right tool.

Seriously, the cross app call goes through your framework, which
already knows, that the untrusted part is frozen. So it can deal
nicely with it in any way you want including unfreezing.

> > Up to that point, I really tried hard to step back from my initial
> > "OMG, promoting crap is a nono" reaction and work with you on a
> > sensible technical solution to confine crap and make it aligned with
> > other efforts in this area.
> >
> > So now, after I spent a reasonable amount of time (as you did) to
> > understand what your requirements are, you come up with another
> > restriction which is so outside of any level of sanity, that I'm at
> > the point of giving up and just going into NAK mode.
> >
> 
> I don't think this is a new restriction. Both Brian and I have
> mentioned that we have a lot of dependencies between processes.
> 
> > Can you please answer the following question:
> >
> >    What is the point of having the distinction of "trusted" and
> >    "untrusted" when you have no way to prevent "trusted" code calling
> >    "into "untrusted" code ?
> >
> 
> Trusted code that calls into untrusted code has to deal with the
> untrusted code not responding, but we only want to pop up a message
> that the application is not responding if it is misbehaving, not just
> because it was frozen though no fault of its own.

See above.
 
> > That's violating any sense of abstraction and layering and makes it
> > entirely clear that the only way you can deal with your own design
> > failure is a big hammer which you need to force into the kernel.
> >
> 
> How can it be fixed? The user presses the back button, the framework
> determines that app A is in the foreground and send the key to app A,
> app A decides that it it does not have anything internal to go back to
> and tells the framework to switch back to the previous app. If the
> user presses the back key again, the framework does not know which app
> this key should go to until app A has finished processing the first
> key press.

Errm, what has this to do with frozen apps? If your system is
handling input events then there are no frozen apps and even if they
are frozen your framework can unfreeze them _before_ talking to them.

So which unfixable problem are you describing with the above example ?

Thanks,

	tglx
--8323328-852715769-1275756468=:2933--
