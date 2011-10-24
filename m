Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab1JXKVR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 06:21:17 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57680 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754078Ab1JXKVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 06:21:16 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: NeilBrown <neilb@suse.de>
Subject: Re: [RFC][PATCH 0/2] PM / Sleep: Extended control of suspend/hibernate interfaces
Date: Mon, 24 Oct 2011 12:23:43 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>
References: <201110132145.42270.rjw@sisk.pl> <201110231516.36787.rjw@sisk.pl> <20111024104444.09337fe6@notabene.brown>
In-Reply-To: <20111024104444.09337fe6@notabene.brown>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201110241223.43362.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, October 24, 2011, NeilBrown wrote:
> On Sun, 23 Oct 2011 15:16:36 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Sunday, October 23, 2011, NeilBrown wrote:
> > > On Sun, 23 Oct 2011 00:07:33 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > 
> > > > On Tuesday, October 18, 2011, NeilBrown wrote:
> 
> > > > > > 
> > > > > > > With that problem solved, experimenting is much easier in user-space than in
> > > > > > > the kernel.
> > > > > > 
> > > > > > Somehow, I'm not exactly sure if we should throw all kernel-based solutions away
> > > > > > just yet.
> > > > > 
> > > > > My rule-of-thumb is that we should reserve kernel space for when
> > > > >   a/ it cannot be done in user space
> > > > >   b/ it cannot be done efficient in user space
> > > > >   c/ it cannot be done securely in user space
> > > > > 
> > > > > I don't think any of those have been demonstrated yet.  If/when they are it
> > > > > would be good to get those kernel-based solutions out of the draw (so yes:
> > > > > keep them out of the rubbish bin).
> > > > 
> > > > I have one more rule.  If my would-be user space solution has the following
> > > > properties:
> > > > 
> > > > * It is supposed to be used by all of the existing variants of user space
> > > >   (i.e. all existing variants of user space are expected to use the very same
> > > >   thing).
> > > > 
> > > > * It requires all of those user space variants to be modified to work with it
> > > >   correctly.
> > > > 
> > > > * It includes a daemon process having to be started on boot and run permanently.
> > > > 
> > > > then it likely is better to handle the problem in the kernel.
> > > 
> > > By that set or rules, upowerd, dbus, pulse audio, bluez, and probably systemd
> > > all need to go in the kernel.  My guess is that you might not find wide
> > > acceptance for these rules.
> > 
> > Well, that's not what I thought.  Perhaps I didn't express that precisely
> > enough.  Take systemd, for example.  You still can design and use a Linux-based
> > system without systemd, so there's no requirement that _all_ variants of user
> > space use the given approach.  The choice of whether or not to use systemd
> > is not a choice between a working and non-working system.
> > 
> > However, this is not the case with the system daemon, becuase it's supposed
> > to handle problems that aren't possible to address without it.  So either you
> > use it, or you end up with a (slightly) broken system.
> 
> I think you are seeing a distinction that isn't there.
> 
> Every system needs a process to run as 'init' - as PID == 1.
> It might be systemd, it might be sysv-init, it might be /bin/sh, but there
> are tasks that process much perform and there must be exactly one process
> performing those tasks and the test of the systems need to be able to work
> with that task (or ignore if it it is wholely independent).
> 
> Similarly every system need one process to manage suspend.  It can be my
> daemon or your daemon or Alan's daemon but it cannot be 2 or more of them
> running at the same time as that doesn't make any more sense than having
> systemd and init running at the same time.

I agree that it doesn't makes sense.  I don't agree that it implies people
won't try to do that.

> > > > > So I'd respond with "I'm not at all sure that we should throw away an
> > > > > all-userspace solution just yet".  Particularly because many of us seem to
> > > > > still be working to understand what all the issues really are.
> > > > 
> > > > OK, so perhaps we should try to implement two concurrent solutions, one
> > > > kernel-based and one purely in user space and decide which one is better
> > > > afterwards?
> > > 
> > > Absolutely.
> > > 
> > > My primary reason for entering this discussion is eloquently presented in
> > >        http://xkcd.com/386/
> > > 
> > > Someone said "We need to change the kernel to get race-free suspend" and this
> > > simply is not true.  I wanted to present a way to use the existing
> > > functionality to provide race-free suspend - and now even have code to do it.
> > > 
> > > If someone else wants to write a different implementation, either in
> > > userspace or kernel that is fine.
> > > 
> > > They can then present it as "I know this can be implemented in userspace, but
> > > I don't like that solution for reasons X, Y, Z and so here is my better
> > > kernel-space implementation" then that is cool.  We can examine X, Y, Z and
> > > the code and see if the argument holds up.  Maybe it will, maybe not.
> > > 
> > > So far the only arguments I've seen for putting the code in the kernel are:
> > > 
> > >  1/ it cannot be done in userspace - demonstrably wrong
> > 
> > I'm not sure if that's correct.  If you meant "it can be done in user space
> > without _any_ kernel modifications", I probably wouldn't agree.
> 
> I have code to do it correctly today with no kernel modifications.  It is
> called "lsusd".   Proof by example.  Or can you show that lsusd doesn't work
> correctly?

So why do you consider making changes to the kernel (described in the other
part of the thread)?  Are they completely cosmetic or are they needed for
functionality?

> > >  2/ it is more efficient in the kernel - not demonstrated or even
> > >     convincingly argued
> > 
> > I don't agree with that, but let's see.
> 
> If you don't agree, then you presumably have a demonstration or a convincing
> argument.  Can you share it?

I think I'll post a patch, but it'll take some time for me to develop it.

> > >  3/ doing it in user-space is too confusing - we would need a clear
> > >     demonstration that a kernel interface is less confusing - and still
> > >     correct.  Also the best way to remove confusion is with clear
> > >     documentation and sample code, not by making up new interfaces.
> > 
> > The user space solution makes up new interfaces too, although they are
> > confined to user space.
> > 
> > To me, it all boils down to two factors: (1) the complexity and efficiency
> > of the code needed to implement the feature and (2) the complexity of the
> > resulting framework (be it in the kernel or in user space).
> > 
> > >  4/ doing it in the kernel makes it more accessible to multiple desktops.
> > >     The success of freedesktop.org seems to contradict that.
> > 
> > I don't agree here too.  Is Android a member of freedesktop.org?
> >
> 
> This is completely irrelevant.
> 
> The "multiple desktops" issue that you brought up is (as I understand it)
> multiple desktops running on the same computer, whether concurrently or
> sequentially.
> Android simply does not face that issue - it is the only "desktop" and is in
> complete control of the machine it runs on.
> So it doesn't need to solve the issue, so it doesn't need to be a member of
> freedesktop.org.

I didn't understand what you meant by "multiple desktops", sorry about that.

> > > So if you can do it a "better" way, please do.  But also please make sure
> > > you can quantify "better".   I claim that user-space solutions are "better"
> > > because they are more flexible and easier to experiment with.  The "no
> > > regressions" rule actively discourages experimentation in the kernel so
> > > people should only do it if there is a clear benefit.
> > 
> > You seem to suppose that every kernel modification necessarily has a potential
> > to lead to some regressions.  I'm not exactly use if that's correct
> > (e.g. adding a new driver usually doesn't affect people who don't need it).
> 
> I think that experimenting in the kernel (or at least in the upstream kernel)
> is likely to result in creating functionality that ultimately will
> not get used - the whole point of experimenting is that you probably get it
> wrong the first time.
> If this happens we either:
>   - remove the unwanted functionality, which could be considered a regression
>     and so must be done very carefully

Unless nobody uses it, that is. :-)

>   - leave the unwanted functionality there thus creating clutter and a
>     maintenance burden.

I don't see this as a big problem.  I can handle that at least. :-)

> i.e. the point of the "no-regressions" reference is that it tends to make it
> harder to remove mistakes.  Not impossible of course, but it requires a lot
> more care and time.
> 
> So I am against adding code to the kernel until the problem is really well
> understood.  From the sorts of discussion that has been going on both in
> this thread and elsewhere I'm not convinced the problem really is well
> understood at all.
> I think we are very much at the stage where people should be experimenting
> with solutions, sharing the results, and learning.
> 
> So please feel free to publish sample code - whether for the kernel or for
> user-space.  But it will only be credible if it is a fairly complete
> proposal - e.g. with sample code demonstrating how the kernel features are
> used.
> 
> (my lsusd really needs a 'plugin' for pm_utils to get it to communicate with
> lsusd rather than writing to /sys/power/state ... I should probably add
> that.  Then it would be complete and usable on current desktops).

I'm actually glad that lsusd has been developed, that's something I've been
advocating for quite a while.  Still, I'm not sure how useful it turns out
to be for distros etc.

> > > User-space solutions are much easier to introduce and then deprecate.
> > 
> > That's demonstrably incorrect and the counter example is the hibernation user
> > space interface.  The sheer amount of work needed to implement user
> > space-driven hibernation and maintain that code shows that it's not exactly
> > easy and it would be more difficult to deprecate than many existing kernel
> > interfaces at this point.
> > 
> > So, even if you have implemented something in user space, the "no regressions"
> > rule and deprecation difficulties will apply to it as well as to the kernel as
> > soon as you make a sufficient number of people use it.
> 
> Can we agree then that we shouldn't impose any part of a possible solution on
> anyone until it has been sensibly tested and reviewed in a variety of
> different use cases and found to be reliable and usable?

Yes, of course.  That's why my patches in this area have been added the RFC
label in the first place.

> I think that addresses my main concern with kernel-space additions - I fear
> that parts of them will end up unnecessary and unused but we will be stuck
> with them.

OK

Thanks,
Rafael
