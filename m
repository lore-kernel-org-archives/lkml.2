Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab1BHRgJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 12:36:09 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:34014 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754906Ab1BHRgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 12:36:08 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
        xen-devel@lists.xensource.com, "SUZUKI, Kazuhiro" <kaz@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Brendan Cully <brendan@cs.ubc.ca>
In-Reply-To: <Pine.LNX.4.44L0.1102081143470.2100-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1102081143470.2100-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Feb 2011 17:35:54 +0000
Message-ID: <1297186554.9388.248.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [linux-pm] [PATCH 0/2] Fix hangup after creating checkpoint on
 Xen.
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.1 cv=JvdXmxIgLJv2/GthKqHpGJEEHukvLcvELVXUanXFreg= c=1 sm=0 a=2S6qIz6xbxMA:10 a=IkcTkHD0fZMA:10 a=WPuq61PRAAAA:8 a=BReQj0yh0c_fV96CEwwA:9 a=rFfIINi57ZWGGWIgbI1HLPSwTOMA:4 a=QEXdDO2ut3YA:10 a=gco2Wzeg9zIA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-02-08 at 11:46 -0500, Alan Stern wrote:
> On Tue, 8 Feb 2011, Ian Campbell wrote:
> 
> > The problem is that currently we have:
> > 
> >         dpm_suspend_start(PMSG_SUSPEND);
> >         
> >                 dpm_suspend_noirq(PMSG_SUSPEND);
> >                         
> >                         sysdev_suspend(PMSG_SUSPEND);
> >                         /* suspend hypercall */
> >                         sysdev_resume();
> >                 
> >                 dpm_resume_noirq(PMSG_RESUME);
> >         
> >         dpm_resume_end(PMSG_RESUME);
> > 
> > However the suspend hypercall can return a value indicating that the
> > suspend didn't actually happen (e.g. was cancelled). This is used e.g.
> > when checkpointing guests, because in that case you want the original
> > guest to continue. When the suspend didn't happen the drivers need to
> > recover differently from if it did.
> 
> That is odd, and it is quite different from the intended design of the 
> PM core.  Drivers are supposed to put their devices into a known 
> suspended state; then afterwards they put the devices back into an 
> operational state.  What happens while the devices are in the suspended 
> state isn't supposed to matter -- the system transition can fail, but 
> devices get treated exactly the same way as if it succeeded.
> 
> Why do your drivers need to recover differently based on the success of 
> the hypercall?

checkpointing isn't really my area but AIUI you don't want to do a full
device teardown and reconnect like you would with a proper suspend
because of the time that takes which prevents you from doing continuous
rolling checkpoints at granularity which people want to implement
various disaster recovery schemes.

Hopefully one of the Xen checkpointing folks will chime in and explain
why this is not possible to achieve at the individual driver level (or,
even better, with a patch which does it that way ;-)).

Ian.

-- 
Ian Campbell
Current Noise: Buckcherry - King Of Kings

Beauty?  What's that?
		-- Larry Wall in <199710221937.MAA25131@wall.org>

