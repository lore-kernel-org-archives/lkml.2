Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071Ab2FPVDq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 17:03:46 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:45826 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756632Ab2FPVDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 17:03:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: huang ying <huang.ying.caritas@gmail.com>
Subject: Re: [PATCH -v5 3/3] PCIe, PM, Add PCIe runtime D3cold support
Date: Sat, 16 Jun 2012 23:09:01 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: =?iso-8859-2?q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>,
        Jesse Barnes <jesse.barnes@intel.com>,
        Huang Ying <ying.huang@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        ming.m.lin@intel.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        Zheng Yan <zheng.z.yan@intel.com>
References: <1339382833-7928-1-git-send-email-ying.huang@intel.com> <201206152321.16913.rjw@sisk.pl> <CAC=cRTOCaMGxyS8pvDzYR55w_QOEbcNjgococfE0NtobAg24Hg@mail.gmail.com>
In-Reply-To: <CAC=cRTOCaMGxyS8pvDzYR55w_QOEbcNjgococfE0NtobAg24Hg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201206162309.02170.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, June 16, 2012, huang ying wrote:
> On Sat, Jun 16, 2012 at 5:21 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> [snip]
> >
> > > @@ -731,9 +791,13 @@ int pci_set_power_state(struct pci_dev *
> > >  {
> > >       int error;
> > >
> > > -     /* bound the state we're entering */
> > > -     if (state > PCI_D3hot)
> > > +     /* D3cold during system suspend/hibernate is not supported */
> > > +     if (!dev->runtime_d3cold && state > PCI_D3hot)
> >
> > I don't think this is the right place for the dev->runtime_d3cold check,
> > I've already told you that and haven't heard anything from you causing me
> > to change my mind.
> >
> > If you don't want D3cold to be used during system sleep transitions,
> > please make sure that D3cold is not passed to pci_set_power_state() in
> > those cases.
> >
> 
> OK.  Checked pci_set_power_state usage with following command line:
> 
> $ grep 'pci_set_power_state' -r . | grep -v PCI_D3hot | grep -v PCI_D0 |
> grep -v pci_choose_state
> $ grep 'pci_set_power_state' -r . | grep -v PCI_D3hot | grep -v PCI_D0 |
> grep -v pci_choose_state | grep -i d3cold
> 
> Found that, almost all pci_set_power_state usage is:
> 
> 1) set to PCI_Dx (not PCI_D3cold)
> 2) set to the state that choosed by pci_choose_state()
> 3) driver use pci_prepare_to_sleep(), which will call pci_set_power_state()
> 
> The only two exceptions are as follow:
> 
> ./drivers/misc/cb710/core.c:            pci_set_power_state(pdev,
> PCI_D3cold);
> ./arch/x86/pci/mrst.c:  pci_set_power_state(dev, PCI_D3cold);

Well, no one is supposed to pass PCI_D3cold to pci_set_power_state() before
the $subject patch, so they should be fixed anyway.

> And pci_choose_state() will not return PCI_D3cold for system suspend.
> 
> So what do you think about the following solution?
> 
> a) Change pci_prepare_to_sleep(), so that it will not put device into
> PCI_D3cold.
> b) Change PCI_D3cold to PCI_D3hot in the following two places,
> 
> ./drivers/misc/cb710/core.c:            pci_set_power_state(pdev,
> PCI_D3cold);
> ./arch/x86/pci/mrst.c:  pci_set_power_state(dev, PCI_D3cold);

Yes, that will do.

Thanks,
Rafael
