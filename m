Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933399Ab0EYSZM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 14:25:12 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39389 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932354Ab0EYSZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 14:25:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=i9pK75rf0gGVk48r0ec3OTLXx/qqWlBfRGH4Kbxw8IjtYoQXh36czPVWOUVFlq7qEN
         WToPj6uJaJhTM+3xioqXYdZjy871eo1a+cbL5vHJbVg2g4KxBzgL+zP1bkSVJtiYIdil
         lQd8rRXnNH3wHVp7HvSb4v7/dWkGUfgq+pd28=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/8] PM: Opportunistic suspend support.
Date: Tue, 25 May 2010 11:24:56 -0700
User-Agent: KMail/1.13.2 (Linux/2.6.32.12-115.fc12.x86_64; KDE/4.4.2; x86_64; ; )
Cc: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
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
References: <Pine.LNX.4.44L0.1005251359580.1634-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1005251359580.1634-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201005251124.58017.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 May 2010 11:08:03 am Alan Stern wrote:
> On Tue, 25 May 2010, Dmitry Torokhov wrote:
> > > > I don't see a big difference between 2 and 3. You can use suspend
> > > > blockers to handle either.
> > > 
> > > You can, but they aren't necessary.  If 2 were the only reason for
> > > suspend blockers, I would say they shouldn't be merged.
> > > 
> > > Whereas 3, on the other hand, can _not_ be handled by any existing
> > > mechanism.  3 is perhaps the most important reason for using suspend
> > > blockers.
> > 
> > I do not see why 3 has to be implemented using suspend blockers either.
> > If you are concerned that event gets stuck somewhere in the stack make
> > sure that devices in the stack do not suspend while their queue is not
> > empty. This way if you try opportunistic suspend it will keep failing
> > until you drained all important queues.
> 
> Here's the scenario:
> 
> The system is awake, and the user presses a key. The keyboard driver
> processes the keystroke and puts it in an input queue.  A user process
> reads it from the event queue, thereby emptying the queue.
> 
> At that moment, the system decides to go into opportunistic suspend.
> Since the input queue is empty, there's nothing to stop it.  As the
> first step, userspace is frozen -- before the process has a chance to
> do anything with the keystroke it just read.  As a result, the system
> stays asleep until something else wakes it up, even though the
> keystroke was important and should have prevented it from sleeping.
> 
> Suspend blockers protect against this scenario.  Here's how:
> 
> The user process doesn't read the input queue directly; instead it
> does a select or poll.  When it sees there is data in the queue, it
> first acquires a suspend blocker and then reads the data.
> 
> Now the system _can't_ go into opportunistic suspend, because a suspend
> blocker is active.  The user process can do whatever it wants with the
> keystroke.  When it is finished, it releases the suspend blocker and
> loops back to the select/poll call.
> 

What you describe can be done in userspace though, via a "suspend manager" 
process. Tasks reading input events will post "busy" events to stop the 
manager process from sending system into suspend. But this can be confined to 
Android userspace, leaving the kernel as is (well, kernel needs to be modified 
to not go into suspend with full queues, but that is using existing kernel 
APIs).

-- 
Dmitry
