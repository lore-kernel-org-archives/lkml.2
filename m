Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932575Ab2IQUyl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 16:54:41 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:49327 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932341Ab2IQUyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 16:54:38 -0400
MIME-Version: 1.0
In-Reply-To: <1347872076-5260-2-git-send-email-ying.huang@intel.com>
References: <1347872076-5260-1-git-send-email-ying.huang@intel.com> <1347872076-5260-2-git-send-email-ying.huang@intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 17 Sep 2012 14:54:16 -0600
Message-ID: <CAErSpo5fVbN2vD5Omc7dGJFWUccYZoCOVRF4YmXPe2Oxm81u5g@mail.gmail.com>
Subject: Re: [RFC 1/3] PCI/PM: Fix kexec for D3cold and bridge suspending
To: Huang Ying <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Eric Biederman <ebiederm@xmission.com>, kexec@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+cc Eric and kexec list

On Mon, Sep 17, 2012 at 2:54 AM, Huang Ying <ying.huang@intel.com> wrote:
> If PCI devices are put into D3cold before kexec, because the
> configuration registers of PCI devices in D3cold are not accessible.
>
> And if PCI bridges are put into low power state before kexec,
> configuration registers of PCI devices underneath the PCI bridges are
> not accessible too.
>
> These will make some PCI devices can not be scanned after kexec, so
> resume the PCI devices in D3cold or PCI bridges in low power state
> before kexec.

Don't we need to resume the device even without the kexec issue?  And
even if it's in D1 or D2?

It looks to me like pci_msi_shutdown() (and probably drv->shutdown())
depend on the device being in D0.

> Signed-off-by: Huang Ying <ying.huang@intel.com>
> ---
>  drivers/pci/pci-driver.c |    4 ++++
>  1 file changed, 4 insertions(+)
>
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c
> @@ -421,6 +421,10 @@ static void pci_device_shutdown(struct d
>         struct pci_dev *pci_dev = to_pci_dev(dev);
>         struct pci_driver *drv = pci_dev->driver;
>
> +       /* Resume bridges and devices in D3cold for kexec to work properly */
> +       if (pci_dev->current_state == PCI_D3cold || pci_dev->subordinate)
> +               pm_runtime_resume(dev);
> +
>         if (drv && drv->shutdown)
>                 drv->shutdown(pci_dev);
>         pci_msi_shutdown(pci_dev);
