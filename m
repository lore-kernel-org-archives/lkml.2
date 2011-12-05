Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab1LEE1p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 23:27:45 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56821 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830Ab1LEE1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 23:27:43 -0500
Date: Sun, 4 Dec 2011 20:27:36 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: riyer <riyer@nvidia.com>
Cc: "rydberg@euromail.se" <rydberg@euromail.se>,
        Stephen Warren <swarren@nvidia.com>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v1] Input: tegra-kbc - report wakeup key for some
 platforms.
Message-ID: <20111205042736.GA23733@core.coreip.homeip.net>
References: <1322685811-14060-1-git-send-email-riyer@nvidia.com>
 <20111130212022.GB3108@core.coreip.homeip.net>
 <1FC56210173BB445BD77F608D6FB8D034F3D1BB4BD@HQMAIL03.nvidia.com>
 <20111201072649.GE16816@core.coreip.homeip.net>
 <1FC56210173BB445BD77F608D6FB8D034F3D1BB4C9@HQMAIL03.nvidia.com>
 <20111204085038.GC14593@core.coreip.homeip.net>
 <1323047897.3056.14.camel@riyer-dt2.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323047897.3056.14.camel@riyer-dt2.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 04, 2011 at 05:18:17PM -0800, riyer wrote:
> Hello Dmitry.
> Please find replies inline.
> 
> On Sun, 2011-12-04 at 00:50 -0800, Dmitry Torokhov wrote:
> > Hi Rakesh,
> > 
> > On Thu, Dec 01, 2011 at 01:09:59PM -0800, Rakesh Iyer wrote:
> > > Hello Dmitry.
> > > 
> > > Sorry for the wrap issue, my Outlook does not seem to obey the settings.
> > > 
> > > I wanted to explain the tegra system resume path implementation so I can justify 
> > > why I am doing this complicated fix and why I feel it will guarantee the resume 
> > > is due to keypress.
> > > 
> > > The tegra wake resume code is registered as a syscore ops.
> > > When the system is resumed due to a wake event, the suspend_enter (after wakeup) 
> > > routine will invoke the tegra syscoreops_resume method and that routine will propagate 
> > > the wake event to the individual ISR's through genirq.
> > > If kbc was wake source, kbc_isr will be invoked in this execution path.
> > > 
> > > If system is resumed due to other reason, the tegra_syscoreops_resume code will not 
> > > find the event.
> > 
> > Consider the following sequence:
> > 
> > 1. Something other than keyboard generates wakeup event
> > 2. It's IRQ fires up and gets serviced
> At this point syscoreops_resume has finished all its wakeup processing.
> 
> > 3. System starts resuming devices
> > 4. User presses a key on the keypad while it is still suspended _and_
> >    registered as a wakeup source
> This will have no impact on the system and keypad ISR will not be
> invoked.
> > 5. Keypad's ISR runs as well and you decide that KEY_POWER should be
> >    reported even though keypad wasn't the real reason the system
> >    woke up.
> The interrupt line we use to detect wakeup processing is the keypress
> interrupt which is disabled and will never cause the ISR invocation from
> a device interrupt(i.e. the PIC).
> 
> In other words KBC isr gets invoked for 2 reasons
> a) FIFO interrupt is generated, which will not happen as long as
> scanning logic is disabled until kbc_resume executes.
> b) The syscoreops_resume codepath calls into the ISR after finding KBC
> was a wakesource. If this happens it will happen only when the kernel
> resumes from its suspend code path.

Is this code already in mainline or still somewhere else?

> > 
> > Is this scenario not possible?
> > 
> > Thanks.
> > 
> With that being the case do you think the fix makes sense?

OK, yes. I do not think it is that important if we occasionally report
KEY_POWER even if KBC was not a true wakeup source but that's fine.

Thanks.

-- 
Dmitry
