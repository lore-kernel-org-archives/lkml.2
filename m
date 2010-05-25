Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934208Ab0EYUoT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 16:44:19 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49530 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932105Ab0EYUoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 16:44:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eQN7+FOOG82z3EL/gDz7TBuHWvr4YQkCpTIfJjALTCs0Px3+3hE4xf8HMPHTzlEri0
         0kCRfXzteOZ1sp3r/H60deZfX6+iMYuJpOmDQmL9sMw0+7e9Xzyb2VnT61YJF45dgG2q
         wfEoGXxBJ1r7zdrt62A6hAB/+aCCO9Spw3CNs=
Date: Tue, 25 May 2010 13:44:05 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@linux.intel.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Tejun Heo <tj@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nigel Cunningham <nigel@tuxonice.net>, Ming Lei <tom.leiming@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/8] PM: Opportunistic suspend support.
Message-ID: <20100525204405.GE4455@core.coreip.homeip.net>
References: <Pine.LNX.4.44L0.1005251359580.1634-100000@iolanthe.rowland.org>
 <201005252147.22358.rjw@sisk.pl>
 <20100525195300.GA4455@core.coreip.homeip.net>
 <201005252221.55888.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005252221.55888.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 10:21:55PM +0200, Rafael J. Wysocki wrote:
> On Tuesday 25 May 2010, Dmitry Torokhov wrote:
> > On Tue, May 25, 2010 at 09:47:22PM +0200, Rafael J. Wysocki wrote:
> > > On Tuesday 25 May 2010, Dmitry Torokhov wrote:
> > > > On Tuesday 25 May 2010 11:08:03 am Alan Stern wrote:
> > > > > On Tue, 25 May 2010, Dmitry Torokhov wrote:
> > > > > > > > I don't see a big difference between 2 and 3. You can use suspend
> > > > > > > > blockers to handle either.
> > > > > > > 
> > > > > > > You can, but they aren't necessary.  If 2 were the only reason for
> > > > > > > suspend blockers, I would say they shouldn't be merged.
> > > > > > > 
> > > > > > > Whereas 3, on the other hand, can _not_ be handled by any existing
> > > > > > > mechanism.  3 is perhaps the most important reason for using suspend
> > > > > > > blockers.
> > > > > > 
> > > > > > I do not see why 3 has to be implemented using suspend blockers either.
> > > > > > If you are concerned that event gets stuck somewhere in the stack make
> > > > > > sure that devices in the stack do not suspend while their queue is not
> > > > > > empty. This way if you try opportunistic suspend it will keep failing
> > > > > > until you drained all important queues.
> > > > > 
> > > > > Here's the scenario:
> > > > > 
> > > > > The system is awake, and the user presses a key. The keyboard driver
> > > > > processes the keystroke and puts it in an input queue.  A user process
> > > > > reads it from the event queue, thereby emptying the queue.
> > > > > 
> > > > > At that moment, the system decides to go into opportunistic suspend.
> > > > > Since the input queue is empty, there's nothing to stop it.  As the
> > > > > first step, userspace is frozen -- before the process has a chance to
> > > > > do anything with the keystroke it just read.  As a result, the system
> > > > > stays asleep until something else wakes it up, even though the
> > > > > keystroke was important and should have prevented it from sleeping.
> > > > > 
> > > > > Suspend blockers protect against this scenario.  Here's how:
> > > > > 
> > > > > The user process doesn't read the input queue directly; instead it
> > > > > does a select or poll.  When it sees there is data in the queue, it
> > > > > first acquires a suspend blocker and then reads the data.
> > > > > 
> > > > > Now the system _can't_ go into opportunistic suspend, because a suspend
> > > > > blocker is active.  The user process can do whatever it wants with the
> > > > > keystroke.  When it is finished, it releases the suspend blocker and
> > > > > loops back to the select/poll call.
> > > > > 
> > > > 
> > > > What you describe can be done in userspace though, via a "suspend manager" 
> > > > process. Tasks reading input events will post "busy" events to stop the 
> > > > manager process from sending system into suspend. But this can be confined to 
> > > > Android userspace, leaving the kernel as is (well, kernel needs to be modified 
> > > > to not go into suspend with full queues, but that is using existing kernel 
> > > > APIs).
> > > 
> > > For that to work, you'd have to make the user space suspend manager prevent
> > > key-reading processes from emptying the queue before it orders the kernel to
> > > put the system to sleep.  Otherwise it still is possible that the queue will be
> > > emptied right at the moment it writes to /sys/power/state and the scenario
> > > described by Alan is going to happen.
> > >
> > 
> > You do exactly the same as what Alan done, but in userspace - poll, post
> > "busy" event to suspend manager, read, process, retract "busy".
> > Basically you still have the suspend blocker, but it is confined to your
> > userspace.
> 
> OK, now the question is why this is actually better.
> 
> > > Moreover, I don't think it's limited to the input subsystem, because the wakeup
> > > events may originate from the network or some other sources and all of them
> > > would require similar handling.
> > 
> > Yes, all devices (real or virtual), not only input ones, holding the
> > queues have to refuse suspending for this to work.
> 
> So, basically, you'd prefer to move the entire complexity to user space.

Yes, I want to shift it from the kernel that use used by all platforms
into platform-sepcific userspace. Especially since I do not see everyone
buying into suspend-blocker model.

> I'm not sure if that's a big win and I'm not sure anyone is actually going to
> implement it (and some drivers would still have to be modified to participate
> in this framework).

I think it is much less than sprinkling every input driver out there
with suspend blockers.

  So again, we have a hunch that the goal may be achieved
> in a different way, but at this point we'd rather need a _working_ _solution_
> (in the form of code one can build and actually use).
> 
> I don't think it's realistic to expect the Android people to go and redesign
> their stuff along the lines you've described, because they have a working
> implementation (in the kernel) that they are satisfied with.
> 

Hmm, and this is different form ever other vendor solution how?

> Now, we can reject their patches, but that's not going to cause any progress
> to happen, realistically.  Quite on the contrary, Android will continue to use
> wakelocks and Android driver writers will continue to ignore the mainline
> and the gap between the two kernel lines will only get wider and wider over
> time.
> 
> And what really is the drawback if we merge the patches?  Quite frankly,
> I don't see any.

Adding stuff that is not beneficial to anyone but a particular platform?
It is uncommon to say the least.

-- 
Dmitry
