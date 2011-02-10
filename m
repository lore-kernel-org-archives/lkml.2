Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab1BJLkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 06:40:19 -0500
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:40628 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751647Ab1BJLkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 06:40:17 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Brendan Cully <brendan@cs.ubc.ca>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "SUZUKI, Kazuhiro" <kaz@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.44L0.1102091837050.18843-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.1102091837050.18843-100000@netrider.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Feb 2011 11:40:05 +0000
Message-ID: <1297338005.20491.163.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [Xen-devel] Re: [linux-pm] [PATCH 0/2] Fix hangup after
 creating checkpoint on Xen.
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.1 cv=JvdXmxIgLJv2/GthKqHpGJEEHukvLcvELVXUanXFreg= c=1 sm=0 a=wRiPVX2u-SEA:10 a=IkcTkHD0fZMA:10 a=svgH3AAeiMK6LjIMaxgA:9 a=hAIPPl5yHFH87OLcuY2wHPVeBecA:4 a=QEXdDO2ut3YA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-09 at 23:42 +0000, Alan Stern wrote:
> In fact there already is a "fast suspend & resume" path in the PM core.  
> It's the freeze/thaw procedure used when starting to hibernate.  The
> documentation specifically says that drivers' freeze methods are
> supposed to quiesce their devices but not change power levels.  In
> addition, the thaw method is invoked as part of recovery from a failed
> hibernation attempt, so it already has the "cancel" semantics that xen 
> seems to want.

Sounds like that would work and I would much prefer to simply make
correct use of the core functionality.

So PMSG_FREEZE is balanced by either PMSG_RECOVER or PMSG_THAW depending
on whether the suspend was cancelled or not? So the sequence of events
is something like:
	dpm_suspend_start(PMSG_FREEZE);
         
		dpm_suspend_noirq(PMSG_FREEZE);
                         
			sysdev_suspend(PMSG_QUIESCE);
			cancelled = suspend_hypercall()
			sysdev_resume();
                 
		dpm_resume_noirq(cancelled ? PMSG_RECOVER : PMSG_THAW);
         
	dpm_resume_end(cancelled ? PMSG_RECOVER : PMSG_THAW);
?

(For comparison we currently have:
> > >         dpm_suspend_start(PMSG_SUSPEND);
> > >         
> > >                 dpm_suspend_noirq(PMSG_SUSPEND);
> > >                         
> > >                         sysdev_suspend(PMSG_SUSPEND);
> > >                         /* suspend hypercall */
> > >                         sysdev_resume();
> > >                 
> > >                 dpm_resume_noirq(PMSG_RESUME);
> > >         
> > >         dpm_resume_end(PMSG_RESUME);
)

Ian.
-- 
Ian Campbell
Current Noise: Neil Young - Angry World

If only one could get that wonderful feeling of accomplishment without
having to accomplish anything.

