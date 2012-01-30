Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab2A3QFF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 11:05:05 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:60547 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935Ab2A3QFA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 11:05:00 -0500
MIME-Version: 1.0
In-Reply-To: <1327718971-9598-11-git-send-email-yinghai@kernel.org>
References: <1327718971-9598-1-git-send-email-yinghai@kernel.org> <1327718971-9598-11-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 30 Jan 2012 08:04:39 -0800
Message-ID: <CAErSpo7RsR+2gDJvWic4ta-_SWfUwECaVxRrCVnTFZyFG5RCkw@mail.gmail.com>
Subject: Re: [PATCH 10/13] PCI: Strict checking of valid range for bridge
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 6:49 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> children bridges busn range should be able to be allocated from parent bus range.
>
> to avoid overlapping between sibling bridges on same bus.
>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  drivers/pci/probe.c |   27 +++++++++++++++++++++++++++
>  1 files changed, 27 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 83df3fb..e12f65f0 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -791,6 +791,33 @@ reduce_needed_size:
>        return ret;
>  }
>
> +static int __devinit pci_bridge_check_busn_res(struct pci_bus *bus,
> +                               struct pci_dev *dev,
> +                               int secondary, int subordinate)

This function returns a boolean, but the function name doesn't give
any clue about what a true/false return means.  Something like
"busn_valid" would make the callers more readable.

> +{
> +       int broken = 0;
> +
> +       struct resource busn_res;
> +       int ret;
> +
> +       memset(&busn_res, 0, sizeof(struct resource));
> +       dev_printk(KERN_DEBUG, &dev->dev,
> +                "check if busn %02x-%02x is in busn_res: %06llx-%06llx\n",
> +                secondary, subordinate,
> +                (unsigned long long)bus->busn_res.start,
> +                (unsigned long long)bus->busn_res.end);
> +       ret = allocate_resource(&bus->busn_res, &busn_res,
> +                        (subordinate - secondary + 1),
> +                        (pci_domain_nr(bus)<<8) | secondary,
> +                        (pci_domain_nr(bus)<<8) | subordinate,

I think this "(pci_domain_nr(bus)<<8) | secondary" stuff needs to be a
macro or something.

> +                        1, NULL, NULL);
> +       if (ret)
> +               broken = 1;
> +       else
> +               release_resource(&busn_res);
> +
> +       return broken;
> +}
>  /*
>  * If it's a bridge, configure it and scan the bus behind it.
>  * For CardBus bridges, we don't scan behind as the devices will
> --
> 1.7.7
>
