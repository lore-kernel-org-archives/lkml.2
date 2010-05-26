Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017Ab0EZN7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 09:59:12 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59484 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755281Ab0EZN7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 09:59:03 -0400
Date: Wed, 26 May 2010 09:59:01 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
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
       Maxim Levitsky <maximlevitsky@gmail.com>, <linux-doc@vger.kernel.org>
Subject: Re: [PATCH 1/8] PM: Opportunistic suspend support.
In-Reply-To: <20100525225544.GA5331@core.coreip.homeip.net>
Message-ID: <Pine.LNX.4.44L0.1005260946430.1961-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 May 2010, Dmitry Torokhov wrote:

> > How is that not polling? If the user is holding down a key, the keypad
> > driver has to block suspend, and user space will try to suspend again
> > and again and again...
> > 
> 
> If your userpsace is that stupid - sure. However, you can:
> 
> 1. Notify the suspend manager process that he rest of your userspace is
> busy handling keystrokes so that it does not try to suspend while there
> are events pending.
> 
> 2. Wait a tiny bit after last application notified you that it finished
> processing events.

This is more complicated than necessary.  Arve is wrong; my suggested 
design does not require polling.

The reason is simple: When a user process initiates an opportunistic 
suspend, you make it wait in an interruptible sleep until all the 
kernel suspend blockers are released.  No polling.  If another user 
thread decides in the meantime that it needs to block the suspend, it 
sends a signal to the power manager process.

In fact, other threads should signal the power manager process whenever 
they want to block or unblock suspends.  That way the power manager 
process can spend all its time sleeping, without doing any polling.

> So basically the difference is that with in-kernel suspend blockers,
> there is a tiny window where we haven't started the suspend yet but are
> about to the driver has a chance to prevent entire system from starting
> sleep.
> 
> Without the blocker we may start suspending and will stop midcycle. We
> may be even better off in the end since we could leave some devices
> still powered down after aborting system-wide suspend.

That's not so easy.  The design of the PM core requires that when the 
system wakes up from suspend (or from an aborted suspend attempt), all 
devices should go to full-power-on.  This is explained in section 6 of
Documentation/power/runtime_pm.txt.

The decision over whether to use kernel-space suspend blockers vs. 
aborting suspends when queues are non-empty comes down to a tradeoff:

	Suspend blockers involve a little more code (to create,
	destroy, enable, and disable them) plus a little extra
	runtime overhead each time an event occurs.  (Some people
	may object to this extra overhead, although so far nobody
	in this discussion has done so.)

	Suspend blockers eliminate the extra overhead involved in
	starting suspends that are just going to be aborted.

	Suspend blockers offer extra debugging and accountability
	(the user can find out which subsystems are responsible for
	keeping the system awake).

Which way you think the tradeoff should go is a subjective decision.  I 
think that kernel suspend blockers are acceptable.

Alan Stern

