Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558Ab1BJQ0v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 11:26:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33415 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756169Ab1BJQ0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 11:26:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Xen-devel] Re: [linux-pm] [PATCH 0/2] Fix hangup after creating checkpoint on Xen.
Date: Thu, 10 Feb 2011 17:26:30 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc4+; KDE/4.4.4; x86_64; ; )
Cc: Ian Campbell <ijc@hellion.org.uk>, Brendan Cully <brendan@cs.ubc.ca>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "SUZUKI, Kazuhiro" <kaz@jp.fujitsu.com>
References: <Pine.LNX.4.44L0.1102101043010.2029-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1102101043010.2029-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102101726.30725.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 10, 2011, Alan Stern wrote:
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
> 
> > So PMSG_FREEZE is balanced by either PMSG_RECOVER or PMSG_THAW depending
> > on whether the suspend was cancelled or not?

That's correct, but from drivers' point of view PMSG_THAW is equivalent to
PMSG_RECOVER, because the both of them cause ->thaw() callbacks to be executed.

> Basically yes.  It is also "balanced" by PMSG_RESTORE, which is used
> after a memory image has been restored (although this isn't relevant to
> your snapshotting).  See the comments in include/linux/pm.h.

Yup.

> >  So the sequence of events
> > is something like:
> > 	dpm_suspend_start(PMSG_FREEZE);
> >          
> > 		dpm_suspend_noirq(PMSG_FREEZE);
> >                          
> > 			sysdev_suspend(PMSG_QUIESCE);
> 
> This should say sysdev_suspend(PMSG_FREEZE).

Yes, PMSG_QUIESCE is restore-specific.

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

Actually, I think PMSG_THAW can be used in both cases.  The resume-side
routines only use the 'state' argument for diagnostics.

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

That's correct.

Thanks,
Rafael
