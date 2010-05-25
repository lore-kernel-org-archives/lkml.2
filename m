Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933503Ab0EYSrw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 14:47:52 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42521 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932294Ab0EYSru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 14:47:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=H+V83VXw5MHmRAUHsuGdu0O+uTUxYdTBzbuabzc4znjYacISttJCIQpWp1fZv9BH5E
         r92MXEDVtGQA9ZcYbueAr5RJo5G9HaHbk3Exedfxsjey4HpcKz7OHS5zFYBlbtQeYIFo
         E76W12Pk+QN30qeVloui9Q3e0DwmCm0HwSyqM=
Date: Tue, 25 May 2010 11:47:40 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
       Pavel Machek <pavel@ucw.cz>, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@linux.intel.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Tejun Heo <tj@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nigel Cunningham <nigel@tuxonice.net>, Ming Lei <tom.leiming@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-doc@vger.kernel.org
Subject: Re: [PATCH 1/8] PM: Opportunistic suspend support.
Message-ID: <20100525184740.GA4248@core.coreip.homeip.net>
References: <201005251124.58017.dmitry.torokhov@gmail.com>
 <Pine.LNX.4.44L0.1005251428090.1634-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1005251428090.1634-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 02:35:17PM -0400, Alan Stern wrote:
> On Tue, 25 May 2010, Dmitry Torokhov wrote:
> 
> > > Here's the scenario:
> > > 
> > > The system is awake, and the user presses a key. The keyboard driver
> > > processes the keystroke and puts it in an input queue.  A user process
> > > reads it from the event queue, thereby emptying the queue.
> > > 
> > > At that moment, the system decides to go into opportunistic suspend.
> > > Since the input queue is empty, there's nothing to stop it.  As the
> > > first step, userspace is frozen -- before the process has a chance to
> > > do anything with the keystroke it just read.  As a result, the system
> > > stays asleep until something else wakes it up, even though the
> > > keystroke was important and should have prevented it from sleeping.
> > > 
> > > Suspend blockers protect against this scenario.  Here's how:
> > > 
> > > The user process doesn't read the input queue directly; instead it
> > > does a select or poll.  When it sees there is data in the queue, it
> > > first acquires a suspend blocker and then reads the data.
> > > 
> > > Now the system _can't_ go into opportunistic suspend, because a suspend
> > > blocker is active.  The user process can do whatever it wants with the
> > > keystroke.  When it is finished, it releases the suspend blocker and
> > > loops back to the select/poll call.
> > > 
> > 
> > What you describe can be done in userspace though, via a "suspend manager" 
> > process. Tasks reading input events will post "busy" events to stop the 
> > manager process from sending system into suspend. But this can be confined to 
> > Android userspace, leaving the kernel as is (well, kernel needs to be modified 
> > to not go into suspend with full queues, but that is using existing kernel 
> > APIs).
> 
> I think that could be made to work.  And it might remove the need for 
> the userspace suspend-blocker API, which would be an advantage.  It 
> could even remove the need for the opportunistic-suspend workqueue -- 
> opportunistic suspends would be initiated by the "suspend manager" 
> process instead of by the kernel.
> 
> However you still have the issue of modifying the kernel drivers to 
> disallow opportunistic suspend if their queues are non-empty.  Doing 
> that is more or less equivalent to implementing kernel-level suspend 
> blockers.  (The suspend blocker approach is slightly more efficient, 
> because it will prevent a suspend from starting if a queue is 
> non-empty, instead of allowing the suspend to start and then aborting 
> it partway through.)
>
> Maybe I'm missing something here...  No doubt someone will point it out 
> if I am.
> 

Well, from my perspective that would limit changes to the evdev driver
(well, limited input core plumbing will be needed) but that is using the
current PM infrastructure. The HW driver changes will be limited to what
you described "type 2" in your other e-mail.

Also, not suspending while events are in progress) is probably
beneficial for platforms other than Android as well. So unless I am
missing something this sounds like a win.

-- 
Dmitry
