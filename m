Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758817Ab0EYTq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 15:46:28 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39227 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758743Ab0EYTqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 15:46:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 1/8] PM: Opportunistic suspend support.
Date: Tue, 25 May 2010 21:47:22 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-tst; KDE/4.3.5; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
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
References: <Pine.LNX.4.44L0.1005251359580.1634-100000@iolanthe.rowland.org> <201005251124.58017.dmitry.torokhov@gmail.com>
In-Reply-To: <201005251124.58017.dmitry.torokhov@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005252147.22358.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 May 2010, Dmitry Torokhov wrote:
> On Tuesday 25 May 2010 11:08:03 am Alan Stern wrote:
> > On Tue, 25 May 2010, Dmitry Torokhov wrote:
> > > > > I don't see a big difference between 2 and 3. You can use suspend
> > > > > blockers to handle either.
> > > > 
> > > > You can, but they aren't necessary.  If 2 were the only reason for
> > > > suspend blockers, I would say they shouldn't be merged.
> > > > 
> > > > Whereas 3, on the other hand, can _not_ be handled by any existing
> > > > mechanism.  3 is perhaps the most important reason for using suspend
> > > > blockers.
> > > 
> > > I do not see why 3 has to be implemented using suspend blockers either.
> > > If you are concerned that event gets stuck somewhere in the stack make
> > > sure that devices in the stack do not suspend while their queue is not
> > > empty. This way if you try opportunistic suspend it will keep failing
> > > until you drained all important queues.
> > 
> > Here's the scenario:
> > 
> > The system is awake, and the user presses a key. The keyboard driver
> > processes the keystroke and puts it in an input queue.  A user process
> > reads it from the event queue, thereby emptying the queue.
> > 
> > At that moment, the system decides to go into opportunistic suspend.
> > Since the input queue is empty, there's nothing to stop it.  As the
> > first step, userspace is frozen -- before the process has a chance to
> > do anything with the keystroke it just read.  As a result, the system
> > stays asleep until something else wakes it up, even though the
> > keystroke was important and should have prevented it from sleeping.
> > 
> > Suspend blockers protect against this scenario.  Here's how:
> > 
> > The user process doesn't read the input queue directly; instead it
> > does a select or poll.  When it sees there is data in the queue, it
> > first acquires a suspend blocker and then reads the data.
> > 
> > Now the system _can't_ go into opportunistic suspend, because a suspend
> > blocker is active.  The user process can do whatever it wants with the
> > keystroke.  When it is finished, it releases the suspend blocker and
> > loops back to the select/poll call.
> > 
> 
> What you describe can be done in userspace though, via a "suspend manager" 
> process. Tasks reading input events will post "busy" events to stop the 
> manager process from sending system into suspend. But this can be confined to 
> Android userspace, leaving the kernel as is (well, kernel needs to be modified 
> to not go into suspend with full queues, but that is using existing kernel 
> APIs).

For that to work, you'd have to make the user space suspend manager prevent
key-reading processes from emptying the queue before it orders the kernel to
put the system to sleep.  Otherwise it still is possible that the queue will be
emptied right at the moment it writes to /sys/power/state and the scenario
described by Alan is going to happen.

Moreover, I don't think it's limited to the input subsystem, because the wakeup
events may originate from the network or some other sources and all of them
would require similar handling.

The problem here is that user space can't do anything to stop the freezing of
tasks without suspend blockers (or something more-or-less equivalent).

Now, you can argue that in theory we can avoid that if tasks are not frozen,
but quite frankly that's not a very realistic way to go.

Rafael
