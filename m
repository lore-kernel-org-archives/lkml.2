Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759603Ab0HEB6X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 21:58:23 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54221 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759366Ab0HEB6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 21:58:20 -0400
Date: Wed, 4 Aug 2010 18:58:15 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, rjw@sisk.pl,
        stern@rowland.harvard.edu, swetland@google.com, peterz@infradead.org,
        tglx@linutronix.de, alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100805015815.GN2927@count0.beaverton.ibm.com>
References: <20100731215214.2543c07e@infradead.org>
 <20100801054816.GI2470@linux.vnet.ibm.com>
 <20100731230101.7cc1d8c7@infradead.org>
 <20100801191228.GL2470@linux.vnet.ibm.com>
 <20100801154708.19817b75@infradead.org>
 <20100802011006.GS2470@linux.vnet.ibm.com>
 <AANLkTi=a-1hn_oL=i-=RKK9xOur+4mQjTRut+aiXtYkE@mail.gmail.com>
 <20100803183447.0275c134@infradead.org>
 <20100804163216.GB24163@linux.vnet.ibm.com>
 <20100804163509.GA31523@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100804163509.GA31523@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 05:35:09PM +0100, Matthew Garrett wrote:
> On Wed, Aug 04, 2010 at 09:32:16AM -0700, Paul E. McKenney wrote:
> 
> > If this doesn't work for the Android folks for whatever reason, another
> > approach would be to do the freeze in user code, which could track
> > whether any user-level resources (pthread mutexes, SysV semas, whatever)
> > where held, and do the freeze on a thread-by-thread basis within each
> > "victim" application as the threads reach safe points.
> 
> The main problem I see with the cgroups solution is that it doesn't seem 
> to do anything to handle avoiding loss of wakeup events.

cgroups alone don't but there is a solution which doesn't require routing
all event data through a single server -- use SIGIO.

Suppose we've got two cgroups of tasks -- those in the initial freezer
cgroup and those in a freezer cgroup meant for power-naive apps. Let's
call the second cgroup the naive cgroup.

One task -- let's call it the "waker" -- is in the initial cgroup is normaly
asleep waiting for SIGIO. Note it's not an "app" -- it's been trusted/blessed
to be a non-power-naive task. It will be signaled via SIGIO by the
applications which want to be unfrozen when an event comes in.

When the power-naive app in the naive cgroup opens a file descriptor it's
going through the Android interpretter to make the syscall. The interpretter
can do fcntl() on the fd to cause SIGIO to be delivered to the waker task.
When the waker gets SIGIO it unfreezes the naive cgroup and thus wakes the
power-naive app. When the power-naive app wakes it will
poll/return-from-poll/read/return-from-read and thus retrieve the event.

Then it's just a matter of choosing when to freeze the naive cgroup. That
requires a userspace implementation of the suspend blockers API plus
opportunistic suspend but does not require any other kernel pieces. Then you
can use sigprocmask to prevent the freeze/wake-event race. You would
probably even merge the waker with the daemon which implements
opportunistic suspend.

Cheers,
    -Matt Helsley
