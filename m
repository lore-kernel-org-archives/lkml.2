Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683Ab0EYXA4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 19:00:56 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:65250 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800Ab0EYXAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 19:00:54 -0400
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Arve =?iso-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>,
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
Subject: Re: [PATCH 1/8] PM: Opportunistic suspend support.
References: <Pine.LNX.4.44L0.1005251359580.1634-100000@iolanthe.rowland.org>
	<201005252147.22358.rjw@sisk.pl>
	<20100525195300.GA4455@core.coreip.homeip.net>
	<201005252221.55888.rjw@sisk.pl>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Tue, 25 May 2010 16:00:50 -0700
In-Reply-To: <201005252221.55888.rjw@sisk.pl> (Rafael J. Wysocki's message of "Tue\, 25 May 2010 22\:21\:55 +0200")
Message-ID: <87fx1fio2l.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> On Tuesday 25 May 2010, Dmitry Torokhov wrote:
>> On Tue, May 25, 2010 at 09:47:22PM +0200, Rafael J. Wysocki wrote:
>> > On Tuesday 25 May 2010, Dmitry Torokhov wrote:
>> > > On Tuesday 25 May 2010 11:08:03 am Alan Stern wrote:
>> > > > On Tue, 25 May 2010, Dmitry Torokhov wrote:
>> > > > > > > I don't see a big difference between 2 and 3. You can use suspend
>> > > > > > > blockers to handle either.
>> > > > > > 
>> > > > > > You can, but they aren't necessary.  If 2 were the only reason for
>> > > > > > suspend blockers, I would say they shouldn't be merged.
>> > > > > > 
>> > > > > > Whereas 3, on the other hand, can _not_ be handled by any existing
>> > > > > > mechanism.  3 is perhaps the most important reason for using suspend
>> > > > > > blockers.
>> > > > > 
>> > > > > I do not see why 3 has to be implemented using suspend blockers either.
>> > > > > If you are concerned that event gets stuck somewhere in the stack make
>> > > > > sure that devices in the stack do not suspend while their queue is not
>> > > > > empty. This way if you try opportunistic suspend it will keep failing
>> > > > > until you drained all important queues.
>> > > > 
>> > > > Here's the scenario:
>> > > > 
>> > > > The system is awake, and the user presses a key. The keyboard driver
>> > > > processes the keystroke and puts it in an input queue.  A user process
>> > > > reads it from the event queue, thereby emptying the queue.
>> > > > 
>> > > > At that moment, the system decides to go into opportunistic suspend.
>> > > > Since the input queue is empty, there's nothing to stop it.  As the
>> > > > first step, userspace is frozen -- before the process has a chance to
>> > > > do anything with the keystroke it just read.  As a result, the system
>> > > > stays asleep until something else wakes it up, even though the
>> > > > keystroke was important and should have prevented it from sleeping.
>> > > > 
>> > > > Suspend blockers protect against this scenario.  Here's how:
>> > > > 
>> > > > The user process doesn't read the input queue directly; instead it
>> > > > does a select or poll.  When it sees there is data in the queue, it
>> > > > first acquires a suspend blocker and then reads the data.
>> > > > 
>> > > > Now the system _can't_ go into opportunistic suspend, because a suspend
>> > > > blocker is active.  The user process can do whatever it wants with the
>> > > > keystroke.  When it is finished, it releases the suspend blocker and
>> > > > loops back to the select/poll call.
>> > > > 
>> > > 
>> > > What you describe can be done in userspace though, via a "suspend manager" 
>> > > process. Tasks reading input events will post "busy" events to stop the 
>> > > manager process from sending system into suspend. But this can be confined to 
>> > > Android userspace, leaving the kernel as is (well, kernel needs to be modified 
>> > > to not go into suspend with full queues, but that is using existing kernel 
>> > > APIs).
>> > 
>> > For that to work, you'd have to make the user space suspend manager prevent
>> > key-reading processes from emptying the queue before it orders the kernel to
>> > put the system to sleep.  Otherwise it still is possible that the queue will be
>> > emptied right at the moment it writes to /sys/power/state and the scenario
>> > described by Alan is going to happen.
>> >
>> 
>> You do exactly the same as what Alan done, but in userspace - poll, post
>> "busy" event to suspend manager, read, process, retract "busy".
>> Basically you still have the suspend blocker, but it is confined to your
>> userspace.
>
> OK, now the question is why this is actually better.

A couple things come to mind...

1. Fixes problems for *all* kernel users, not just Android.

The kernel changes (refuse to suspend) would be done in a way that
would fix problems in the traditional suspend path as well as the
opportunistic suspend path, thus benefiting everyone.

2. Keep policy out of the kernel

A userspace suspend manager could implement _policy_ decisions in a
platform specific way, rather than having policy hard-coded into the
kernel.

Keeping the policy/governor in userspace would also allow various
governor techniques to be experimented with (polling/timeout
intervals, etc.) without having to patch the kernel.

Kevin
