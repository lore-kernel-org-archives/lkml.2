Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759022Ab2ECXwe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 19:52:34 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:51780 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756672Ab2ECXwc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 19:52:32 -0400
MIME-Version: 1.0
In-Reply-To: <20120427190033.GA17588@ldl.usa.hp.com>
References: <20120427190033.GA17588@ldl.usa.hp.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 3 May 2012 17:52:10 -0600
Message-ID: <CAErSpo7mwheYBxM5_PhSmUdbybRbO9s1nTmZrL83NPuNW6g8SA@mail.gmail.com>
Subject: Re: [PATCH] Disable Bus Master on PCI device shutdown
To: linux-pci@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 1:00 PM, Khalid Aziz <khalid.aziz@hp.com> wrote:
> Disable Bus Master bit on the device in
> pci_device_shutdown() to ensure PCI devices do not continue
> to DMA data after shutdown. This can cause memory
> corruption in case of a kexec where the current kernel
> shuts down and transfers control to a new kernel while a
> PCI device continues to DMA to memory that does not belong
> to it any more in the new kernel.
>
> I have tested this code on two laptops, two workstations and
> a 16-socket server. kexec worked correctly on all of them.
>
>
> Signed-off-by: Khalid Aziz <khalid.aziz@hp.com>
> ---
>  drivers/pci/pci-driver.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
> index 6b54b23..9db5940 100644
> --- a/drivers/pci/pci-driver.c
> +++ b/drivers/pci/pci-driver.c
> @@ -420,6 +420,12 @@ static void pci_device_shutdown(struct device *dev)
>        pci_msi_shutdown(pci_dev);
>        pci_msix_shutdown(pci_dev);
>
> +       /*
> +        * Turn off Bus Master bit on the device to tell it to not
> +        * continue to do DMA
> +        */
> +       pci_disable_device(pci_dev);
> +
>        /*
>         * Devices may be enabled to wake up by runtime PM, but they need not
>         * be supposed to wake up the system from its "power off" state (e.g.

Any comment on this, Eric?  It seems reasonable to me.
