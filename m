Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754267Ab1JVWFL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 18:05:11 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:55855 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061Ab1JVWFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 18:05:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: NeilBrown <neilb@suse.de>
Subject: Re: [RFC][PATCH 0/2] PM / Sleep: Extended control of suspend/hibernate interfaces
Date: Sun, 23 Oct 2011 00:07:33 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        mark gross <markgross@thegnar.org>,
        LKML <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>
References: <201110132145.42270.rjw@sisk.pl> <201110180002.30932.rjw@sisk.pl> <20111018103631.6943a97a@notabene.brown>
In-Reply-To: <20111018103631.6943a97a@notabene.brown>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201110230007.33683.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 18, 2011, NeilBrown wrote:
> On Tue, 18 Oct 2011 00:02:30 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Monday, October 17, 2011, NeilBrown wrote:
> > > On Sun, 16 Oct 2011 00:10:40 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > ...
> > > > 
> > > > >  But I think it is very wrong to put some hack in the kernel like your
> > > > >    suspend_mode = disabled
> > > > 
> > > > Why is it wrong and why do you think it is a "hack"?
> > > 
> > > I think it is a "hack" because it is addressing a specific complaint rather
> > > than fixing a real problem.
> > 
> > I wonder why you think that there's no real problem here.
> > 
> > The problem I see is that multiple processes can use the suspend/hibernate
> > interfaces pretty much at the same time (not exactly in parallel, becuase
> > there's some locking in there, but very well there may be two different
> > processes operating /sys/power/state independently of each other), while
> > the /sys/power/wakeup_count interface was designed with the assumption that
> > there will be only one such process in mind.
> 
> Multiple process can write to your mail box at the same time.  But some how
> they don't.  This isn't because the kernel enforces anything, but because all
> the relevant programs have an agreed protocol by which they arbitrate access.
> One upon a time this involved creating a lock file with O_CREAT|O_EXCL.
> These days it is fcntl locking.  But it is still advisory.
> 
> In the same way - we stop multiple processes from suspending/hibernating at
> the same time by having an agreed protocol by which they share access to the
> resource.  The kernel does not need to be explicitly involved in this.

Not really.  The main difference is that such a protocol doesn't exist for
processes that may want to suspend/hibernate the system.

Moreover, the race is real, because if you have two processes trying to use
/sys/power/wakeup_count at the same time, you can get:

Process A		Process B
read from wakeup_count
talk to apps
write to wakeup_count
--------- wakeup event ----------
			read from wakeup_count
			talk to apps
			write to wakeup_count
try to suspend -> success (should be failure, because the wakeup event
may still be processed by applications at this point and Process A hasn't
checked that).

Now, there are systems running two (or more) desktop environments each of
which has a power manager that may want to suspend on it's own.  They both
will probably use pm-utils, but then I somehow doubt that pm-utils is well
prepared to handle such concurrency.

> 
> ...
> 
> > > > Well, I used to think that it's better to do things in user space.  Hence,
> > > > the hibernate user space interface that's used by many people.  And my
> > > > experience with that particular thing made me think that doing things in
> > > > the kernel may actually work better, even if they _can_ be done in user space.
> > > > 
> > > > Obviously, that doesn't apply to everything, but sometimes it simply is worth
> > > > discussing (if not trying).  If it doesn't work out, then fine, let's do it
> > > > differently, but I'm really not taking the "this should be done in user space"
> > > > argument at face value any more.  Sorry about that.
> > > 
> > > :-)  I have had similar mixed experiences.   Sometimes it can be a lot easier
> > > to get things working if it is all in the kernel.
> > > But I think that doing things in user-space leads to a lot more flexibility.
> > > Once you have the interfaces and designs worked out you can then start doing
> > > more interesting things and experimenting with ideas more easily.
> > > 
> > > In this case, I think the *only* barrier to a simple solution in user-space
> > > is the pre-existing software that uses the 'old' kernel interface.  It seems
> > > that interfacing with that is as easy as adding a script or two to pm-utils.
> > 
> > Well, assuming that we're only going to address the systems that use PM utils.
> 
> I suspect (and claim without proof :-) that any system will have some single
> user-space thing that is responsible for initiating suspend.

Well, see above.

> Every time I look at one I see a whole host of things that need to be done
> just before suspend, and other things just after resume.
> They used to be in /etc/apm/event.d.  Now there are
> in /usr/lib/pm-utils/sleep.d.

I know of systems that don't need those hooks, however.

> I think they were in /etc/acpid once.
> I've seen one thing that uses shared-library modules instead of shell scripts
> on the basis that it avoids forking and goes fast (and it probably does).
> But I doubt there is any interesting system where writing to /sys/power/state
> is the *only* thing you need to do for a clean suspend.

I have such a system on my desk. :-)

> So all systems will have some user-space infrastructure to support suspend,
> and we just need to hook in to that.
> 
> 
> > 
> > > With that problem solved, experimenting is much easier in user-space than in
> > > the kernel.
> > 
> > Somehow, I'm not exactly sure if we should throw all kernel-based solutions away
> > just yet.
> 
> My rule-of-thumb is that we should reserve kernel space for when
>   a/ it cannot be done in user space
>   b/ it cannot be done efficient in user space
>   c/ it cannot be done securely in user space
> 
> I don't think any of those have been demonstrated yet.  If/when they are it
> would be good to get those kernel-based solutions out of the draw (so yes:
> keep them out of the rubbish bin).

I have one more rule.  If my would-be user space solution has the following
properties:

* It is supposed to be used by all of the existing variants of user space
  (i.e. all existing variants of user space are expected to use the very same
  thing).

* It requires all of those user space variants to be modified to work with it
  correctly.

* It includes a daemon process having to be started on boot and run permanently.

then it likely is better to handle the problem in the kernel.

> So I'd respond with "I'm not at all sure that we should throw away an
> all-userspace solution just yet".  Particularly because many of us seem to
> still be working to understand what all the issues really are.

OK, so perhaps we should try to implement two concurrent solutions, one
kernel-based and one purely in user space and decide which one is better
afterwards?

Rafael
