Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab1IGQtv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:49:51 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:35216 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720Ab1IGQtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:49:07 -0400
Date: Wed, 7 Sep 2011 11:03:10 +0200
From: Borislav Petkov <bp@amd64.org>
To: Don Zickus <dzickus@redhat.com>
Cc: "Richter, Robert" <robert.richter@amd.com>,
        "x86@kernel.org" <x86@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Andi Kleen <ak@linux.intel.com>, Corey Minyard <minyard@acm.org>,
        Jack Steiner <steiner@sgi.com>, Tony Luck <tony.luck@intel.com>
Subject: Re: [V3][PATCH 3/6] x86, nmi: wire up NMI handlers to new routines
Message-ID: <20110907090310.GA7725@aftab>
References: <1314290748-23569-1-git-send-email-dzickus@redhat.com>
 <1314290748-23569-4-git-send-email-dzickus@redhat.com>
 <20110906161545.GH14200@erda.amd.com>
 <20110906165253.GP5795@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110906165253.GP5795@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 06, 2011 at 12:52:53PM -0400, Don Zickus wrote:

[..]

> > > diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
> > > index 08363b0..3fc65b6 100644
> > > --- a/arch/x86/kernel/cpu/mcheck/mce.c
> > > +++ b/arch/x86/kernel/cpu/mcheck/mce.c
> > > @@ -908,9 +908,6 @@ void do_machine_check(struct pt_regs *regs, long error_code)
> > >
> > >         percpu_inc(mce_exception_count);
> > >
> > > -       if (notify_die(DIE_NMI, "machine check", regs, error_code,
> > > -                          18, SIGKILL) == NOTIFY_STOP)
> > > -               goto out;
> >
> > Yes, this code is strange. I checked all the nmi handlers but couldn't
> > find one that is direct related to this call. But it could be to
> > handle IPIs even in the case of an mce to let backtrace and reboot
> > work. CC'ing mce guys.
> >
> > I would rather add an nmi_handle() call here.
> 
> I checked to and the code predates 2.6.12, so I have no idea why it was
> there.  One of the reasons I wanted to remove it was to keep all the users
> internal to the nmi.c file.  Also I remove most of the parameters from
> notify_die as they were not being used.  I would hate to add them back in
> because of an mce hack.
> 
> I'm sure after 4-5 years (whenever this was added), we can find a better
> way to do whatever it is doing, no?
> 
> But if I have to support this call, it complicates all the changes I made
> unnecessarily. :-(

This code comes from a combined x86_64 update commit from 2003, AFAICT:

commit 3d71dbc9afbd7eecdc71e0329d6f16f2dcd48e39
Author: Andi Kleen <ak@suse.de>
Date:   Mon Mar 24 19:54:54 2003 -0800

    [PATCH] x86-64 updates

    Lots of x86-64 updates. Merge with 2.4 and NUMA works now. Also reenabled
    the preemptive kernel. And some other bug fixes.
    IOMMU disabled by default now because it has problems.

     - Add more CONFIG options for device driver debugging and iommu
       force/debug.  (don't enable iommu force currently)
     - Some S3/ACPI fixes/cleanups from Pavel.
     ....


and the file was called arch/x86_64/kernel/bluesmoke.c back then.
Unfortunately, nothing in the commit message hints at why it was added.
I guess it was some sort of a notification mechanism to warn the rest of
the kernel that we might die soon because we received an MCE, so that
prior can take some cleanup action before going down.

So I don't think we use it anywhere - originally Robert and I thought
that mce-inject.c relies on it indirectly but it does its own NMI
injection when the MCE needs to be broadcast and injected on all cores
and it also registers its own NMI notifier mce_raise_notify() which
you've already converted.

Tony, anything I'm missing?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
