Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab2HWFvc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 01:51:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:23631 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754315Ab2HWFv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 01:51:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,298,1344236400"; 
   d="scan'208";a="137006936"
Date: Thu, 23 Aug 2012 13:45:57 +0800
From: Feng Tang <feng.tang@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Avi Kivity <avi@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
        Yinghai Lu <yinghai@kernel.org>, <linux-pci@vger.kernel.org>
Subject: Re: pci_get_subsys: GFP_KERNEL allocations with IRQs disabled
Message-ID: <20120823134557.00fdeb58@feng-i7>
In-Reply-To: <CAErSpo7HhdDi4EhbQZ-oZbsbGVvTfZW8MwKn7Tm+6B8jaQxLBg@mail.gmail.com>
References: <5017D19B.5080806@redhat.com>
	<1343738627.27983.30.camel@gandalf.stny.rr.com>
	<5017D4AB.3090107@redhat.com>
	<1343740419.27983.33.camel@gandalf.stny.rr.com>
	<20120731234336.GA5526@localhost>
	<1343778699.27983.70.camel@gandalf.stny.rr.com>
	<20120731235705.GW2422@linux.vnet.ibm.com>
	<1343779778.27983.73.camel@gandalf.stny.rr.com>
	<20120801001811.GX2422@linux.vnet.ibm.com>
	<20120801004319.GA7043@localhost>
	<20120822025008.GA8066@localhost>
	<20120822154908.2e6ef3c0@feng-i7>
	<CAErSpo7HhdDi4EhbQZ-oZbsbGVvTfZW8MwKn7Tm+6B8jaQxLBg@mail.gmail.com>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bjorn,

On Wed, 22 Aug 2012 11:02:52 -0700
Bjorn Helgaas <bhelgaas@google.com> wrote:

> On Wed, Aug 22, 2012 at 12:49 AM, Feng Tang <feng.tang@intel.com> wrote:
> > Hi Fengguang,
> >
> >
> > On Wed, 22 Aug 2012 10:50:08 +0800
> > Fengguang Wu <fengguang.wu@intel.com> wrote:
> >
> >> Feng,
> >>
> >> > I think it's pci_get_subsys() triggered this assert:
> >> >
> >> >         /*
> >> >          * Oi! Can't be having __GFP_FS allocations with IRQs disabled.
> >> >          */
> >> >         if (DEBUG_LOCKS_WARN_ON(irqs_disabled_flags(flags)))
> >> >                 return;
> >>
> >> It's bisected down to this commit:
> >>
> >> commit 55c844a4dd16a4d1fdc0cf2a283ec631a02ec448
> >> Author:     Feng Tang <feng.tang@intel.com>
> >> AuthorDate: Wed May 30 23:15:41 2012 +0800
> >> Commit:     Ingo Molnar <mingo@kernel.org>
> >> CommitDate: Wed Jun 6 12:03:23 2012 +0200
> >>
> >>     x86/reboot: Fix a warning message triggered by stop_other_cpus()
> >>
> >> Thanks,
> >> Fengguang
> >
> > Thanks for the bisection.
> >
> > Revert my commit should be a solution, but can we simply make the pci_device_id
> > a local on stack one instead of using sleepable kmalloc for it, as this
> > sounds fragile when pci_get_subsys get called in a late system reboot stage?
> 
> I think this is a great idea.  Can you make this a real patch, with a
> changelog and Signed-off-by?

Thanks and will do.

> 
> We should also remove the obsolete comment about early boot.  I'm not
> sure the no_pci_devices() check is needed, either.  And we can make
> the same simplification in pci_get_class().

Will check the no_pci_devices() part, and try to make it a separate
patch for easy reverting in case of error.

> 
> > ------------
> > diff --git a/drivers/pci/search.c b/drivers/pci/search.c
> > index 993d4a0..e5ccede 100644
> > --- a/drivers/pci/search.c
> > +++ b/drivers/pci/search.c
> > @@ -246,7 +246,7 @@ struct pci_dev *pci_get_subsys(unsigned int vendor, unsigned int device,
> >                                struct pci_dev *from)
> >  {
> > +       id.vendor = vendor;
> > +       id.device = device;
> > +       id.subvendor = ss_vendor;
> > +       id.subdevice = ss_device;
> >
> > +       pdev = pci_get_dev_by_id(&id, from);
> 
> No need for "pdev" here, since we don't have to free anything.

ok, will directly return it.

Thanks,
Feng
