Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab1BJQfO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 11:35:14 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:38091 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756432Ab1BJQfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 11:35:13 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Brendan Cully <brendan@cs.ubc.ca>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "SUZUKI, Kazuhiro" <kaz@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.44L0.1102101043010.2029-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1102101043010.2029-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Feb 2011 16:34:48 +0000
Message-ID: <1297355688.21980.488.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [Xen-devel] Re: [linux-pm] [PATCH 0/2] Fix hangup after
 creating checkpoint on Xen.
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.1 cv=JvdXmxIgLJv2/GthKqHpGJEEHukvLcvELVXUanXFreg= c=1 sm=0 a=wRiPVX2u-SEA:10 a=IkcTkHD0fZMA:10 a=55PpCY4J7TVtE7DOIrkA:9 a=REzEPONeQ46m5Ty-hPAL3dybLT0A:4 a=QEXdDO2ut3YA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-10 at 11:00 -0500, Alan Stern wrote:
> On Thu, 10 Feb 2011, Ian Campbell wrote:
> 
> > On Wed, 2011-02-09 at 23:42 +0000, Alan Stern wrote:
> > > In fact there already is a "fast suspend & resume" path in the PM core.  
> > > It's the freeze/thaw procedure used when starting to hibernate.  The
> > > documentation specifically says that drivers' freeze methods are
> > > supposed to quiesce their devices but not change power levels.  In
> > > addition, the thaw method is invoked as part of recovery from a failed
> > > hibernation attempt, so it already has the "cancel" semantics that xen 
> > > seems to want.
> > 
> > Sounds like that would work and I would much prefer to simply make
> > correct use of the core functionality.
> 
> It seems like a reasonable approach.  Whether it will actually _work_ 
> is a harder question...  :-)

Heh.

> > So PMSG_FREEZE is balanced by either PMSG_RECOVER or PMSG_THAW depending
> > on whether the suspend was cancelled or not?
> 
> Basically yes.  It is also "balanced" by PMSG_RESTORE, which is used
> after a memory image has been restored (although this isn't relevant to
> your snapshotting).  See the comments in include/linux/pm.h.

The documentation of the individual events in pm.h is good. Is there a
reference for the sequence of events for the different types of
suspend/hibernate/etc?

> >  So the sequence of events
> > is something like:
> > 	dpm_suspend_start(PMSG_FREEZE);
> >          
> > 		dpm_suspend_noirq(PMSG_FREEZE);
> >                          
> > 			sysdev_suspend(PMSG_QUIESCE);
> 
> This should say sysdev_suspend(PMSG_FREEZE).
> 
> > 			cancelled = suspend_hypercall()
> 
> At this point swsusp_arch_suspend() is called.  If that translates to 
> suspend_hypercall() in your setting, then yes.
> 
> > 			sysdev_resume();
> >                  
> > 		dpm_resume_noirq(cancelled ? PMSG_RECOVER : PMSG_THAW);
> >          
> > 	dpm_resume_end(cancelled ? PMSG_RECOVER : PMSG_THAW);
> > ?
> 
> Yes.

Both of those call ->thaw ->complete. Did I mean "cancelled ?
PMSG_THAW : PMSG_RESTORE"? (or s/THAW/RECOVER?)

If the suspend was cancelled then we want the devices to simply pickup
where they were before the freeze, wereas if we really did suspend (or
migrate or whatever) then they need to do a more complete reset and
reconnect operation so we want some sort of indication to the driver
which happened.

> > (For comparison we currently have:
> > > > >         dpm_suspend_start(PMSG_SUSPEND);
> > > > >         
> > > > >                 dpm_suspend_noirq(PMSG_SUSPEND);
> > > > >                         
> > > > >                         sysdev_suspend(PMSG_SUSPEND);
> > > > >                         /* suspend hypercall */
> > > > >                         sysdev_resume();
> > > > >                 
> > > > >                 dpm_resume_noirq(PMSG_RESUME);
> > > > >         
> > > > >         dpm_resume_end(PMSG_RESUME);
> > )
> 
> Right.  The sequence of calls is the same, but the PMSG_ argument is 
> different so drivers are expected to act differently in response.

The drivers don't actually see the PMSG_* though right? They only see a
differing sequence of hooks from dev_pm_ops called.

Thanks,
Ian.

> 
> Alan Stern
> 
> 

-- 
Ian Campbell
Current Noise: Sworn Amongst - Useless

Accident, n.:
	A condition in which presence of mind is good, but absence of
	body is better.
		-- Foolish Dictionary

