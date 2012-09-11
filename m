Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105Ab2IKWv5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 18:51:57 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:48347 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385Ab2IKWvz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 18:51:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dave Airlie <airlied@gmail.com>
Subject: Re: runtime PM and special power switches
Date: Wed, 12 Sep 2012 00:58:16 +0200
User-Agent: KMail/1.13.6 (Linux/3.6.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        "dri-devel" <dri-devel@lists.freedesktop.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-pci@vger.kernel.org
References: <201209112255.10486.rjw@sisk.pl> <Pine.LNX.4.44L0.1209111730340.22718-100000@netrider.rowland.org> <CAPM=9tzp8MnoGttxB=WrOZ8nMAESJn_0GAHT84PdmSgri==aCA@mail.gmail.com>
In-Reply-To: <CAPM=9tzp8MnoGttxB=WrOZ8nMAESJn_0GAHT84PdmSgri==aCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209120058.16701.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 12, 2012, Dave Airlie wrote:
> On Wed, Sep 12, 2012 at 7:32 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Tue, 11 Sep 2012, Rafael J. Wysocki wrote:
> >
> >> Hi,
> >>
> >> On Tuesday, September 11, 2012, Dave Airlie wrote:
> >> > Hi Rafael,
> >> >
> >> > I've been investigating runtime PM support for some use-cases on GPUs.
> >> >
> >> > In some laptops we have a secondary GPU (optimus) that can be powered
> >> > up for certain 3D tasks and then turned off when finished with. Now I
> >> > did an initial pass on supporting it without using the kernel runtime
> >> > PM stuff, but Alan said I should take a look so here I am.
> >>
> >> Alan Stern or Alan Cox? :-)
> >>
> >> > While I've started to get a handle on things, we have a bit of an
> >> > extra that I'm not sure we cater for.
> >> >
> >> > Currently we get called from the PCI layer which after we are finished
> >> > with our runtime suspend callback, will go put the device into the
> >> > correct state etc, however on these optimus/powerxpress laptops we
> >> > have a separate ACPI or platform driver controlled power switch that
> >> > we need to call once the PCI layer is finished the job. This switch
> >> > effectively turns the power to the card completely off leaving it
> >> > drawing no power.
> >> >
> >> > No we can't hit the switch from the driver callback as the PCI layer
> >> > will get lost, so I'm wondering how you'd envisage we could plug this
> >> > in.
> >>
> >> Hmm.  In principle we might modify pci_pm_runtime_suspend() so that it
> >> doesn't call pci_finish_runtime_suspend() if pci_dev->state_saved is
> >> set.  That would actually make it work in analogy with pci_pm_suspend_noirq(),
> >> so perhaps it's not even too dangerous.
> >
> > This sounds more like a job for a power domain.  Unless the power
> > switch is already in the device hierarchy as a parent to the PCI
> > device.
> 
> I'll have to investigate power domains then,
> 
> The switch is hidden in many different places, one some laptops its in
> a ACPI _DSM on one GPU, on others its in an ACPI _DSM on the other
> one, in some its in a different ACPI _DSM, then we have it in the ACPI
> ATPX method on others, and finally Apple have it in a piece of hw that
> isn't just on the LPC bus or somewhere like that.
> 
> Currently we just hide it all inside vga_switcheroo and I'd just need
> an interface to call that once the layers have stopped poking
> registers in PCI config space, if we could fix PCI runtime suspend so
> the driver was the last to get called then that would also not suck.

Well, as I said, we may try to change the PCI layer so that it doesn't
access the device any more in pci_pm_runtime_suspend() if it sees that
pci_dev->state_saved has been set by the driver's callback.  Then,
your drivers would only need to set pci_dev->state_saved in their
.runtime_suspend() callbacks.

Alternatively, which may be less hackish but more work, you can set the
pm_domain pointer in the device structure to a struct dev_pm_domain whose
ops will just call the corresponding bus type's ops except for
.runtime_suspend() that will execute the additional ACPI stuff after calling
the bus type's method.

Thanks,
Rafael
