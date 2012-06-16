Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758980Ab2FPDbD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 23:31:03 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:38762 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756870Ab2FPDbA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 23:31:00 -0400
MIME-Version: 1.0
In-Reply-To: <201206152321.16913.rjw@sisk.pl>
References: <1339382833-7928-1-git-send-email-ying.huang@intel.com>
	<1339382833-7928-4-git-send-email-ying.huang@intel.com>
	<201206152321.16913.rjw@sisk.pl>
Date: Sat, 16 Jun 2012 11:30:54 +0800
Message-ID: <CAC=cRTO4iNf67eP2=ATJWHSXgmj1S3qDE0b-cHNJ2vHkhfu2PQ@mail.gmail.com>
Subject: Re: [PATCH -v5 3/3] PCIe, PM, Add PCIe runtime D3cold support
From: huang ying <huang.ying.caritas@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Jesse Barnes <jesse.barnes@intel.com>
Cc: Huang Ying <ying.huang@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        ming.m.lin@intel.com, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        Zheng Yan <zheng.z.yan@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for bothering if you received this message twice.  I have some
issue with my mailing system.

On Sat, Jun 16, 2012 at 5:21 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
[snip]
>
> > @@ -731,9 +791,13 @@ int pci_set_power_state(struct pci_dev *
> >  {
> >       int error;
> >
> > -     /* bound the state we're entering */
> > -     if (state > PCI_D3hot)
> > +     /* D3cold during system suspend/hibernate is not supported */
> > +     if (!dev->runtime_d3cold && state > PCI_D3hot)
>
> I don't think this is the right place for the dev->runtime_d3cold check,
> I've already told you that and haven't heard anything from you causing me
> to change my mind.
>
> If you don't want D3cold to be used during system sleep transitions,
> please make sure that D3cold is not passed to pci_set_power_state() in
> those cases.

OK.  Checked pci_set_power_state usage with following command line:

$ grep 'pci_set_power_state' -r . | grep -v PCI_D3hot | grep -v PCI_D0
| grep -v pci_choose_state
$ grep 'pci_set_power_state' -r . | grep -v PCI_D3hot | grep -v PCI_D0
| grep -v pci_choose_state | grep -i d3cold

Found that, almost all pci_set_power_state usage is:

1) set to PCI_Dx (not PCI_D3cold)
2) set to the state that choosed by pci_choose_state()
3) driver use pci_prepare_to_sleep(), which will call pci_set_power_state()

The only two exceptions are as follow:

./drivers/misc/cb710/core.c:            pci_set_power_state(pdev, PCI_D3cold);
./arch/x86/pci/mrst.c:  pci_set_power_state(dev, PCI_D3cold);

And pci_choose_state() will not return PCI_D3cold for system suspend.

So what do you think about the following solution?

a) Change pci_prepare_to_sleep(), so that it will not put device into
PCI_D3cold.
b) Change PCI_D3cold to PCI_D3hot in the following two places,

./drivers/misc/cb710/core.c:            pci_set_power_state(pdev, PCI_D3cold);
./arch/x86/pci/mrst.c:  pci_set_power_state(dev, PCI_D3cold);

Best Regards,
Huang Ying
