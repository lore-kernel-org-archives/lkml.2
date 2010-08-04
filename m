Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759162Ab0HDVdH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 17:33:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38659 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759044Ab0HDVdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 17:33:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: paulmck@linux.vnet.ibm.com
Subject: Re: Attempted summary of suspend-blockers LKML thread
Date: Wed, 4 Aug 2010 23:31:14 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, david@lang.hm,
        Arjan van de Ven <arjan@infradead.org>,
        Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        pavel@ucw.cz, florian@mickler.org, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
References: <20100801054816.GI2470@linux.vnet.ibm.com> <20100804205654.GA4986@srcf.ucam.org> <20100804211521.GI24163@linux.vnet.ibm.com>
In-Reply-To: <20100804211521.GI24163@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008042331.14851.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 04, 2010, Paul E. McKenney wrote:
> On Wed, Aug 04, 2010 at 09:56:55PM +0100, Matthew Garrett wrote:
> > On Wed, Aug 04, 2010 at 10:51:07PM +0200, Rafael J. Wysocki wrote:
> > > On Wednesday, August 04, 2010, Matthew Garrett wrote:
> > > > No! And that's precisely the issue. Android's existing behaviour could 
> > > > be entirely implemented in the form of binary that manually triggers 
> > > > suspend when (a) the screen is off and (b) no userspace applications 
> > > > have indicated that the system shouldn't sleep, except for the wakeup 
> > > > event race. Imagine the following:
> > > > 
> > > > 1) The policy timeout is about to expire. No applications are holding 
> > > > wakelocks. The system will suspend providing nothing takes a wakelock.
> > > > 2) A network packet arrives indicating an incoming SIP call
> > > > 3) The VOIP application takes a wakelock and prevents the phone from 
> > > > suspending while the call is in progress
> > > > 
> > > > What stops the system going to sleep between (2) and (3)? cgroups don't, 
> > > > because the voip app is an otherwise untrusted application that you've 
> > > > just told the scheduler to ignore.
> > > 
> > > I _think_ you can use the just-merged /sys/power/wakeup_count mechanism to
> > > avoid the race (if pm_wakeup_event() is called at 2)).
> > 
> > Yes, I think that solves the problem. The only question then is whether 
> > it's preferable to use cgroups or suspend fully, which is pretty much up 
> > to the implementation. In other words, is there a reason we're still 
> > having this conversation? :) It'd be good to have some feedback from 
> > Google as to whether this satisfies their functional requirements.
> 
> The issue with cgroup freezer as currently defined is that it can freeze
> processes that hold user-level resources (pthread mutexes, SysV semas,
> ...).  If some non-frozen process attempts to acquire that resource, you
> get a hang.  There might be some ways to work around this, for example,
> Arjan suggests momentarily unfreezing periodically, and I suggested doing
> the freeze in user-space code, but we don't know if either of these will
> really do what is required.
> 
> Also, I believe that Android's use of cgroups would be in addition to
> suspending fully rather than instead of.  Freezing a subset of the
> applications allows cutting power drain from output-only apps when
> the screen blanks but where some app such as a download needs to keep
> the system active.  They still would need to suspend once the download
> completes.

One can argue that once the download has been completed, the cpuidle framework
should make the system reduce its energy consumption to the level achievable
by using suspend.

However, the problem is the cpuidle framework only deals with CPUs right
now (at least generally) and there's a problem of the interrupt sources that
allow the monotonic clock to advance and are deactivated during suspend
(which allows more energy to be saved, because periodic timers are then
effectively disabled).

So, it seems, system suspend is necessary to maximize energy savings
as long as the cpuidle framework cannot take care of I/O devices and interrupt
sources in general.

Thanks,
Rafael
