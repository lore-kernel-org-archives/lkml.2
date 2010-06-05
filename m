Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933440Ab0FEWMn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 18:12:43 -0400
Received: from www.tglx.de ([62.245.132.106]:40888 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932711Ab0FEWMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 18:12:41 -0400
Date: Sun, 6 Jun 2010 00:11:06 +0200 (CEST)
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
In-Reply-To: <AANLkTinD39rI47innPbGz1Gi8PsXV5HqkmaQuJ70oQ63@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1006052348200.2933@localhost.localdomain>
References: <20100603193045.GA7188@elte.hu> <20100603232302.GA16184@elte.hu> <1275644619.27810.39462.camel@twins> <201006050138.30859.rjw@sisk.pl> <alpine.LFD.2.00.1006050148080.2933@localhost.localdomain> <AANLkTikGDSzaENwg_0BAtsYf3ulGd_6sGPR30WsvUxMi@mail.gmail.com>
 <alpine.LFD.2.00.1006050246350.2933@localhost.localdomain> <AANLkTikU21xF49Z-_Lnrq7U7buNmqw_gyEEST8LuN24z@mail.gmail.com> <alpine.LFD.2.00.1006051736040.2933@localhost.localdomain> <AANLkTinD39rI47innPbGz1Gi8PsXV5HqkmaQuJ70oQ63@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-2022448962-1275775868=:2933"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-2022448962-1275775868=:2933
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Sat, 5 Jun 2010, Arve Hjønnevåg wrote:
> 2010/6/5 Thomas Gleixner <tglx@linutronix.de>:
> > B1;2005;0cOn Fri, 4 Jun 2010, Arve Hjønnevåg wrote:
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

What you are describing is a problem which is not solvable either way.
If you take the lock and do not release it you're not going to
suspend. I never claimed that any other mechanism resolves this.

But this is not related to the fact that freezing crap while running a
sane background task is going to save you power vs. an approach where
running a sane background task allows crap to consume power unconfined
until it is done.

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

I'm going to fix the framework which puts the group into freeze state
w/o making sure that there is no held shared resource. Come on it's
not rocket science.
 
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

It's not about a central process, it goes through your framework,
which should be able to deal with it. If not, it's a design failure
which needs to be fixed at the place where the failure happened.
 
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
> untrusted code. I gave you a visible example of such a dependency and
> want you to tell me how you can avoid this dependency. Since you are
> claiming that our user-space framework is fundamentally broken if it
> has to wait for untrusted code, I don't think it is unreasonable for
> you to answer this. Or do you think it is valid to communicate with
> untrusted code when the screen is on but not when it is off.

It does not matter whether the screen is off or not. If you need to
call into that untrusted app from your trusted app and you know about
the might be frozen state then you can deal with it.

So taking your example:

Event happens and gets delivered to the framework

      framework selects A because it is in the foreground
      
      if (A is frozen)
      	 unfreeze(A)

      deliver_event_to(A)

It's that simple.

If your framework cannot deal with that simple problem then you have a
much more serious problem already.

Thanks,

	tglx

--8323328-2022448962-1275775868=:2933--
