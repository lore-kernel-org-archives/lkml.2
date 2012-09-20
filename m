Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192Ab2ITTOW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 15:14:22 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:36766 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754513Ab2ITTOC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 15:14:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>, Huang Ying <ying.huang@intel.com>
Subject: Re: [RFC 1/3] PCI/PM: Fix kexec for D3cold and bridge suspending
Date: Thu, 20 Sep 2012 21:20:31 +0200
User-Agent: KMail/1.13.6 (Linux/3.6.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, Eric Biederman <ebiederm@xmission.com>,
        kexec@lists.infradead.org
References: <1347872076-5260-1-git-send-email-ying.huang@intel.com> <1347872076-5260-2-git-send-email-ying.huang@intel.com> <CAErSpo5fVbN2vD5Omc7dGJFWUccYZoCOVRF4YmXPe2Oxm81u5g@mail.gmail.com>
In-Reply-To: <CAErSpo5fVbN2vD5Omc7dGJFWUccYZoCOVRF4YmXPe2Oxm81u5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209202120.32029.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 17, 2012, Bjorn Helgaas wrote:
> +cc Eric and kexec list
> 
> On Mon, Sep 17, 2012 at 2:54 AM, Huang Ying <ying.huang@intel.com> wrote:
> > If PCI devices are put into D3cold before kexec, because the
> > configuration registers of PCI devices in D3cold are not accessible.
> >
> > And if PCI bridges are put into low power state before kexec,
> > configuration registers of PCI devices underneath the PCI bridges are
> > not accessible too.
> >
> > These will make some PCI devices can not be scanned after kexec, so
> > resume the PCI devices in D3cold or PCI bridges in low power state
> > before kexec.
> 
> Don't we need to resume the device even without the kexec issue?  And
> even if it's in D1 or D2?
> 
> It looks to me like pci_msi_shutdown() (and probably drv->shutdown())
> depend on the device being in D0.

We should in theory, but we didn't do any power management of PCI bridges
before, so this is the first time we have a problem with it.

So I'd say, yeah, let's resume if current_state is between D1 and D3cold
inclusive and the kexec comment is not very helpful (the problem is not
kexec-specific in general).

Speaking of kexec, it might consider using the hibernation device freeze
instead of device shutdown (which the kexec jump feature does).  I've seen
reports of problems that would be solved this way most likely.

Thanks,
Rafael


> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> > ---
> >  drivers/pci/pci-driver.c |    4 ++++
> >  1 file changed, 4 insertions(+)
> >
> > --- a/drivers/pci/pci-driver.c
> > +++ b/drivers/pci/pci-driver.c
> > @@ -421,6 +421,10 @@ static void pci_device_shutdown(struct d
> >         struct pci_dev *pci_dev = to_pci_dev(dev);
> >         struct pci_driver *drv = pci_dev->driver;
> >
> > +       /* Resume bridges and devices in D3cold for kexec to work properly */
> > +       if (pci_dev->current_state == PCI_D3cold || pci_dev->subordinate)
> > +               pm_runtime_resume(dev);
> > +
> >         if (drv && drv->shutdown)
> >                 drv->shutdown(pci_dev);
> >         pci_msi_shutdown(pci_dev);
> 
> 

