Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933326Ab1INUnO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 16:43:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34655 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933143Ab1INUnM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 16:43:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 2/5] PM / Runtime: Do not run callbacks under lock for power.irq_safe set
Date: Wed, 14 Sep 2011 22:45:14 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Linux-sh list" <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, Kevin Hilman <khilman@ti.com>,
        jean.pihet@newoldbits.com
References: <201108310017.03103.rjw@sisk.pl> <201109131806.39050.rjw@sisk.pl> <CACVXFVMFZJioG_vgJ_tx9rA8_=H0HcKZLCyLcTu8oSSSmUoNJg@mail.gmail.com>
In-Reply-To: <CACVXFVMFZJioG_vgJ_tx9rA8_=H0HcKZLCyLcTu8oSSSmUoNJg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109142245.14808.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 14, 2011, Ming Lei wrote:
> Hi,
> 
> On Wed, Sep 14, 2011 at 12:06 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> >> >> If power.lock is released, the transition states(resuming or suspending)
> >> >
> >> >> may be observed in rpm_suspend or rpm_resume, then tasks schedule
> >> >
> >> >> will be produced in these two functions,
> >> >
> >> > I don't think so, because the interrupts are still off.
> >>
> >> Yes, the interrupts are still off on local CPU, but the release of spin lock may
> >> cause another CPUs to run into rpm_suspend or rpm_resume and produce
> >> task schedule inside the two functions.
> >
> > Not for the same device, though.
> 
> I think it is probable to happen on the same device in theory, see below:
> 
> - suppose irq_safe is set before calling two pm_runtime_suspend below
> - suppose this patch has been applied
> 
> CPU0						CPU1
> pm_runtime_suspend
> 	acquired power lock
> 	rpm_suspend
> 						pm_runtime_suspend
> 							spining power lock
> 	...
> 	release power lock
> 							acquired power lock
> 	run .runtime_suspend
> 							found the dev suspending
> 							wait for power state and schedule

OK, I see what the problem is.  The second CPU can see the status
being RPM_SUSPENDING in the irq_safe case, which isn't possible
without the patch.

Good catch!

I think in that case rpm_suspend() should just release the lock,
run cpu_relax(), reacquire the lock and go to the "repeat" label.

Thanks,
Rafael
