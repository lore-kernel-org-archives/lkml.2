Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab1BHLXN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 06:23:13 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:12030 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752491Ab1BHLXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 06:23:12 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "SUZUKI, Kazuhiro" <kaz@jp.fujitsu.com>,
        linux-pm@lists.linux-foundation.org, xen-devel@lists.xensource.com,
        Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <201102071035.29922.rjw@sisk.pl>
References: <20110207.180718.885783824287845425.kaz@jp.fujitsu.com>
	 <201102071035.29922.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Feb 2011 11:22:58 +0000
Message-ID: <1297164178.9388.65.camel@zakaz.uk.xensource.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH 0/2] Fix hangup after creating checkpoint on Xen.
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.1 cv=R50lirqlHffDPPkwUlkuVa99MrvKdVWo//yz83qex8g= c=1 sm=0 a=et004m4BhuUA:10 a=IkcTkHD0fZMA:10 a=TSbVqHtbAAAA:8 a=169HA-X9IguR09rBfJUA:9 a=aIsiGUkFewAeCfrBEgIA:7 a=N8KVptO9XTy4KWhOBQ30jlBqQLYA:4 a=QEXdDO2ut3YA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-07 at 10:35 +0100, Rafael J. Wysocki wrote:
> On Monday, February 07, 2011, SUZUKI, Kazuhiro wrote:
> > Hi,
> 
> Hi,
> 
> > The following patch series fixes hangup after creating checkpoint on
> > Xen. The Linux Xen guest can be saved the state to restore later, and
> > also created snapshot like checkpoint via the hypervisor.
> > But, when the snapshot is created for the PV guest, it will hangup.
> > 
> > We added 'PMSG_CANCEL' message and 'cancel' handler in dev_pm_ops
> > struct in the pm-linux part.
> 
> Please don't do that, unless you can convince me there's no other way to fix
> the problem you're trying to address.

Sorry, it was my advise to Kazuhiro that solving the underlying issue by
extending the core would be preferable to making Xen specific hacks.

The problem is that currently we have:

        dpm_suspend_start(PMSG_SUSPEND);
        
                dpm_suspend_noirq(PMSG_SUSPEND);
                        
                        sysdev_suspend(PMSG_SUSPEND);
                        /* suspend hypercall */
                        sysdev_resume();
                
                dpm_resume_noirq(PMSG_RESUME);
        
        dpm_resume_end(PMSG_RESUME);

However the suspend hypercall can return a value indicating that the
suspend didn't actually happen (e.g. was cancelled). This is used e.g.
when checkpointing guests, because in that case you want the original
guest to continue. When the suspend didn't happen the drivers need to
recover differently from if it did.

The originally proposed solution was to only call dpm_resume_end if the
suspend was not cancelled. My concern with this was that unbalancing the
dpm_suspend_* and dpm_resume_* did not seem like a correct interaction
with the core. For example dpm_suspend_* adds stuff to
dpm_suspended_list and if dpm_resume_* is not called presumably this all
gets out of sync for next time. Hence my suggestion to add a cancel
message type.

> In my opinion it's highly unrealistic to assume that device drivers
> (or even subsystems) will implement the ->cancel() callback just for the
> benefit of Xen.

I did vague wonder if a similar message might be of interest to e.g.
cancelling hibernations or similar.

> And if the only subsystem that needs to implement ->cancel() is Xen, then the
> issue should be addressed without modifying the device core code, in a different
> way.

I thought it would be preferable to make use of/extend core
functionality where possible but if that's not the case we can find
another way.

Do you have any suggestions for how to correctly interact with the core
functions?

Is adding a suspend_cancel operation to just at the struct xenbus_driver
level and introducing a xen specific function to walk to the bus the
sort of thing you were thinking of? (it seems reasonable). Should we be
doing anything with dpm_*_list in that case?

(FWIW original thread is on xen-devel at
http://thread.gmane.org/gmane.comp.emulators.xen.devel/95265/)

Ian.

-- 
Ian Campbell
Current Noise: Crowbar - Dead Sun

Why on earth do people buy old bottles of wine when they can get a
fresh one for a quarter of the price?

