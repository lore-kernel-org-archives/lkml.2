Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab1JWNOM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 09:14:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56461 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240Ab1JWNOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 09:14:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: NeilBrown <neilb@suse.de>
Subject: Re: [RFC][PATCH 0/2] PM / Sleep: Extended control of suspend/hibernate interfaces
Date: Sun, 23 Oct 2011 15:16:36 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>
References: <201110132145.42270.rjw@sisk.pl> <201110230007.33683.rjw@sisk.pl> <20111023135745.2bfe1d80@notabene.brown>
In-Reply-To: <20111023135745.2bfe1d80@notabene.brown>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201110231516.36787.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, October 23, 2011, NeilBrown wrote:
> On Sun, 23 Oct 2011 00:07:33 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Tuesday, October 18, 2011, NeilBrown wrote:
> > > On Tue, 18 Oct 2011 00:02:30 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > 
> > > > On Monday, October 17, 2011, NeilBrown wrote:
> > > > > On Sun, 16 Oct 2011 00:10:40 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > > ...
> > > > > > 
> > > > > > >  But I think it is very wrong to put some hack in the kernel like your
> > > > > > >    suspend_mode = disabled
> > > > > > 
> > > > > > Why is it wrong and why do you think it is a "hack"?
> > > > > 
> > > > > I think it is a "hack" because it is addressing a specific complaint rather
> > > > > than fixing a real problem.
> > > > 
> > > > I wonder why you think that there's no real problem here.
> > > > 
> > > > The problem I see is that multiple processes can use the suspend/hibernate
> > > > interfaces pretty much at the same time (not exactly in parallel, becuase
> > > > there's some locking in there, but very well there may be two different
> > > > processes operating /sys/power/state independently of each other), while
> > > > the /sys/power/wakeup_count interface was designed with the assumption that
> > > > there will be only one such process in mind.
> > > 
> > > Multiple process can write to your mail box at the same time.  But some how
> > > they don't.  This isn't because the kernel enforces anything, but because all
> > > the relevant programs have an agreed protocol by which they arbitrate access.
> > > One upon a time this involved creating a lock file with O_CREAT|O_EXCL.
> > > These days it is fcntl locking.  But it is still advisory.
> > > 
> > > In the same way - we stop multiple processes from suspending/hibernating at
> > > the same time by having an agreed protocol by which they share access to the
> > > resource.  The kernel does not need to be explicitly involved in this.
> > 
> > Not really.  The main difference is that such a protocol doesn't exist for
> > processes that may want to suspend/hibernate the system.
> > 
> > Moreover, the race is real, because if you have two processes trying to use
> > /sys/power/wakeup_count at the same time, you can get:
> > 
> > Process A		Process B
> > read from wakeup_count
> > talk to apps
> > write to wakeup_count
> > --------- wakeup event ----------
> > 			read from wakeup_count
> > 			talk to apps
> > 			write to wakeup_count
> > try to suspend -> success (should be failure, because the wakeup event
> > may still be processed by applications at this point and Process A hasn't
> > checked that).
> > 
> > Now, there are systems running two (or more) desktop environments each of
> > which has a power manager that may want to suspend on it's own.  They both
> > will probably use pm-utils, but then I somehow doubt that pm-utils is well
> > prepared to handle such concurrency.
> 
> I think that "upowerd" is the current "solution" to this problem.  Different
> desktops can communicate with it to negotiate when suspend will happen.
> 
> When upowerd decides to suspend, it calls the relevant pm_utils command.
> 
> So with modern desktops we would never expect two different processes to be
> requesting pm_utils to suspend at the same time.  If we did that would be a
> problem  but we don't.  There is no race here to fix.

I have a slightly different view on that.  Since there is no mechanism to
prevent the race from occuring, we need to assume the race is going to happen
in certain situations.

> I'm not certain that upowerd provides good interfaces.  But its existence
> shows that this sort of problem that you see is not that hard to solve.
> 
> Sure: people could still design systems  which exhibited racy access to
> suspend, but people have always being able to write buggy code - making up
> new interfaces isn't going to stop them.

I'd say that depends on what the new interfaces are.  For one, I wouldn't
agree with the statement that we couldn't invent interfaces that were better
than what we had. :-)

> > 
> > > 
> > > ...
> > > 
> > > > > > Well, I used to think that it's better to do things in user space.  Hence,
> > > > > > the hibernate user space interface that's used by many people.  And my
> > > > > > experience with that particular thing made me think that doing things in
> > > > > > the kernel may actually work better, even if they _can_ be done in user space.
> > > > > > 
> > > > > > Obviously, that doesn't apply to everything, but sometimes it simply is worth
> > > > > > discussing (if not trying).  If it doesn't work out, then fine, let's do it
> > > > > > differently, but I'm really not taking the "this should be done in user space"
> > > > > > argument at face value any more.  Sorry about that.
> > > > > 
> > > > > :-)  I have had similar mixed experiences.   Sometimes it can be a lot easier
> > > > > to get things working if it is all in the kernel.
> > > > > But I think that doing things in user-space leads to a lot more flexibility.
> > > > > Once you have the interfaces and designs worked out you can then start doing
> > > > > more interesting things and experimenting with ideas more easily.
> > > > > 
> > > > > In this case, I think the *only* barrier to a simple solution in user-space
> > > > > is the pre-existing software that uses the 'old' kernel interface.  It seems
> > > > > that interfacing with that is as easy as adding a script or two to pm-utils.
> > > > 
> > > > Well, assuming that we're only going to address the systems that use PM utils.
> > > 
> > > I suspect (and claim without proof :-) that any system will have some single
> > > user-space thing that is responsible for initiating suspend.
> > 
> > Well, see above.
> 
> See also upowerd.
> 
> 
> > 
> > > Every time I look at one I see a whole host of things that need to be done
> > > just before suspend, and other things just after resume.
> > > They used to be in /etc/apm/event.d.  Now there are
> > > in /usr/lib/pm-utils/sleep.d.
> > 
> > I know of systems that don't need those hooks, however.
> > 
> > > I think they were in /etc/acpid once.
> > > I've seen one thing that uses shared-library modules instead of shell scripts
> > > on the basis that it avoids forking and goes fast (and it probably does).
> > > But I doubt there is any interesting system where writing to /sys/power/state
> > > is the *only* thing you need to do for a clean suspend.
> > 
> > I have such a system on my desk. :-)
> 
> :-)
> I guess I would have to conclude that it is therefore not interesting :-)
> 
> Would you accept that is more of an exception than the rule?

Not really.  For example, on systems that run Android it is not necessary to
do anything in user space before suspending and after resuming.  There is quite
a number of such systems around.

> The real point though is that lots of system do want pre/post scripts, so we
> can expect that avoiding races between such scripts is a solved problem - and
> this is what we find in e.g. upowerd.

Well, I'm not entirely convinced that this is the case. :-)

> > > So all systems will have some user-space infrastructure to support suspend,
> > > and we just need to hook in to that.
> > > 
> > > 
> > > > 
> > > > > With that problem solved, experimenting is much easier in user-space than in
> > > > > the kernel.
> > > > 
> > > > Somehow, I'm not exactly sure if we should throw all kernel-based solutions away
> > > > just yet.
> > > 
> > > My rule-of-thumb is that we should reserve kernel space for when
> > >   a/ it cannot be done in user space
> > >   b/ it cannot be done efficient in user space
> > >   c/ it cannot be done securely in user space
> > > 
> > > I don't think any of those have been demonstrated yet.  If/when they are it
> > > would be good to get those kernel-based solutions out of the draw (so yes:
> > > keep them out of the rubbish bin).
> > 
> > I have one more rule.  If my would-be user space solution has the following
> > properties:
> > 
> > * It is supposed to be used by all of the existing variants of user space
> >   (i.e. all existing variants of user space are expected to use the very same
> >   thing).
> > 
> > * It requires all of those user space variants to be modified to work with it
> >   correctly.
> > 
> > * It includes a daemon process having to be started on boot and run permanently.
> > 
> > then it likely is better to handle the problem in the kernel.
> 
> By that set or rules, upowerd, dbus, pulse audio, bluez, and probably systemd
> all need to go in the kernel.  My guess is that you might not find wide
> acceptance for these rules.

Well, that's not what I thought.  Perhaps I didn't express that precisely
enough.  Take systemd, for example.  You still can design and use a Linux-based
system without systemd, so there's no requirement that _all_ variants of user
space use the given approach.  The choice of whether or not to use systemd
is not a choice between a working and non-working system.

However, this is not the case with the system daemon, becuase it's supposed
to handle problems that aren't possible to address without it.  So either you
use it, or you end up with a (slightly) broken system.
 
> > > So I'd respond with "I'm not at all sure that we should throw away an
> > > all-userspace solution just yet".  Particularly because many of us seem to
> > > still be working to understand what all the issues really are.
> > 
> > OK, so perhaps we should try to implement two concurrent solutions, one
> > kernel-based and one purely in user space and decide which one is better
> > afterwards?
> 
> Absolutely.
> 
> My primary reason for entering this discussion is eloquently presented in
>        http://xkcd.com/386/
> 
> Someone said "We need to change the kernel to get race-free suspend" and this
> simply is not true.  I wanted to present a way to use the existing
> functionality to provide race-free suspend - and now even have code to do it.
> 
> If someone else wants to write a different implementation, either in
> userspace or kernel that is fine.
> 
> They can then present it as "I know this can be implemented in userspace, but
> I don't like that solution for reasons X, Y, Z and so here is my better
> kernel-space implementation" then that is cool.  We can examine X, Y, Z and
> the code and see if the argument holds up.  Maybe it will, maybe not.
> 
> So far the only arguments I've seen for putting the code in the kernel are:
> 
>  1/ it cannot be done in userspace - demonstrably wrong

I'm not sure if that's correct.  If you meant "it can be done in user space
without _any_ kernel modifications", I probably wouldn't agree.

>  2/ it is more efficient in the kernel - not demonstrated or even
>     convincingly argued

I don't agree with that, but let's see.

>  3/ doing it in user-space is too confusing - we would need a clear
>     demonstration that a kernel interface is less confusing - and still
>     correct.  Also the best way to remove confusion is with clear
>     documentation and sample code, not by making up new interfaces.

The user space solution makes up new interfaces too, although they are
confined to user space.

To me, it all boils down to two factors: (1) the complexity and efficiency
of the code needed to implement the feature and (2) the complexity of the
resulting framework (be it in the kernel or in user space).

>  4/ doing it in the kernel makes it more accessible to multiple desktops.
>     The success of freedesktop.org seems to contradict that.

I don't agree here too.  Is Android a member of freedesktop.org?

> So if you can do it a "better" way, please do.  But also please make sure
> you can quantify "better".   I claim that user-space solutions are "better"
> because they are more flexible and easier to experiment with.  The "no
> regressions" rule actively discourages experimentation in the kernel so
> people should only do it if there is a clear benefit.

You seem to suppose that every kernel modification necessarily has a potential
to lead to some regressions.  I'm not exactly use if that's correct
(e.g. adding a new driver usually doesn't affect people who don't need it).

> User-space solutions are much easier to introduce and then deprecate.

That's demonstrably incorrect and the counter example is the hibernation user
space interface.  The sheer amount of work needed to implement user
space-driven hibernation and maintain that code shows that it's not exactly
easy and it would be more difficult to deprecate than many existing kernel
interfaces at this point.

So, even if you have implemented something in user space, the "no regressions"
rule and deprecation difficulties will apply to it as well as to the kernel as
soon as you make a sufficient number of people use it.

Thanks,
Rafael
