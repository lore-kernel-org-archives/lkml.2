Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272Ab2JCWyc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 18:54:32 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:42357 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932111Ab2JCWya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 18:54:30 -0400
MIME-Version: 1.0
In-Reply-To: <1349187780-25692-1-git-send-email-nzimmer@sgi.com>
References: <1349187780-25692-1-git-send-email-nzimmer@sgi.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 3 Oct 2012 16:54:09 -0600
Message-ID: <CAErSpo7ZQEm9==nsGiH2c_ZG8LPP8MAA8M9xSPyWPtCW2EHUUQ@mail.gmail.com>
Subject: Re: [PATCH] revert "PCI: log vendor/device ID always"
To: Nathan Zimmer <nzimmer@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 2, 2012 at 8:23 AM, Nathan Zimmer <nzimmer@sgi.com> wrote:
> Revert commit id 2c6413aee215a43b1f95e218067abcde50ccbc5e
> On larger systems (256 cores+) with signifigant IO attached this single message
> represents over 20% of the messages at boot.

Is this causing a problem?  The messages are at KERN_DEBUG, so they
shouldn't be going to the console by default anyway.

I/O devices normally have at least one BAR, as well as some PME
messages, so a change like this won't affect them too much.  My guess
is that it's really the large number of CPUs, where we find all the
uncore/memory controller/etc stuff where this is a problem.  Those
devices don't have BARs, so
this line is probably the only information about them in dmesg.

> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
>
> Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
> ---
>  drivers/pci/probe.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 9f8a6b7..a1add54 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1002,8 +1002,8 @@ int pci_setup_device(struct pci_dev *dev)
>         dev->revision = class & 0xff;
>         dev->class = class >> 8;                    /* upper 3 bytes */
>
> -       dev_printk(KERN_DEBUG, &dev->dev, "[%04x:%04x] type %02x class %#08x\n",
> -                  dev->vendor, dev->device, dev->hdr_type, dev->class);
> +       dev_dbg(&dev->dev, "[%04x:%04x] type %02x class %#08x\n",
> +               dev->vendor, dev->device, dev->hdr_type, dev->class);
>
>         /* need to have dev->class ready */
>         dev->cfg_size = pci_cfg_space_size(dev);
> --
> 1.6.0.2
>
