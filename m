Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab2FWSQG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 14:16:06 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:62277 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046Ab2FWSQC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 14:16:02 -0400
MIME-Version: 1.0
In-Reply-To: <1340322477.56127.2.camel@localhost.localdomain>
References: <1340222160.77018.19.camel@localhost.localdomain> <1340322477.56127.2.camel@localhost.localdomain>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Sat, 23 Jun 2012 12:15:39 -0600
Message-ID: <CAErSpo7AWQCofnTRhtMKVP3pm_BDq9v+axGpide0RbmignsV9A@mail.gmail.com>
Subject: Re: [PATCH] pci: support alignments upto 8Gb in pbus_size_mem()
To: Nikhil P Rao <nikhil.rao@intel.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 5:47 PM, Nikhil P Rao <nikhil.rao@intel.com> wrote:
> I ran into the "disabling BAR .." error message when
> trying to use a 8Gb PCIe card on a system with a BIOS
> that didnt have support for BAR size > 2Gb.

So the BIOS left the 8Gb BAR unassigned, and you got the "disabling
BAR ... (bad alignment)" message when Linux tried to enable it?

How do we know 8Gb is the correct new limit?  Are we going to be
fixing this again when we see a 16Gb or a 32Gb BAR?  Do we need a
better algorithm that doesn't have a limit like this?

 This patch fixed
> the problem, but I also see the code reading the IORESOURCE_MEM_64
> flag so I am not sure what the right solution is
>
> Signed-off-by: Nikhil P Rao <nikhil.rao@intel.com>
> ---
>  drivers/pci/setup-bus.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> index 8fa2d4b..3b3601f 100644
> --- a/drivers/pci/setup-bus.c
> +++ b/drivers/pci/setup-bus.c
> @@ -780,7 +780,7 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
>  {
>        struct pci_dev *dev;
>        resource_size_t min_align, align, size, size0, size1;
> -       resource_size_t aligns[12];     /* Alignments from 1Mb to 2Gb */
> +       resource_size_t aligns[14];     /* Alignments from 1Mb to 8Gb */
>        int order, max_order;
>        struct resource *b_res = find_free_bus_resource(bus, type);
>        unsigned int mem64_mask = 0;
> @@ -819,7 +819,7 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
>                        /* For bridges size != alignment */
>                        align = pci_resource_alignment(dev, r);
>                        order = __ffs(align) - 20;
> -                       if (order > 11) {
> +                       if (order >= ARRAY_SIZE(aligns)) {
>                                dev_warn(&dev->dev, "disabling BAR %d: %pR "
>                                         "(bad alignment %#llx)\n", i, r,
>                                         (unsigned long long) align);
> --
> 1.7.1
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
