Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab1HXOgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 10:36:14 -0400
Received: from mail-pz0-f70.google.com ([209.85.210.70]:53554 "EHLO
	mail-pz0-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab1HXOfk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 10:35:40 -0400
X-Greylist: delayed 422 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Aug 2011 10:35:40 EDT
MIME-Version: 1.0
In-Reply-To: <1314167063-15785-2-git-send-email-dengcheng.zhu@gmail.com>
References: <1314167063-15785-1-git-send-email-dengcheng.zhu@gmail.com> <1314167063-15785-2-git-send-email-dengcheng.zhu@gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 24 Aug 2011 08:35:19 -0600
Message-ID: <CAErSpo4091J2pGvzZKPbKK68LWWkDyVApA7suZYn7miq=tXrQg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/3] MIPS: PCI: Use pci_bus_remove_resources()/pci_bus_add_resource()
 to set up root resources
To: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
Cc: jbarnes@virtuousgeek.org, ralf@linux-mips.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org, eyal@mips.com,
        zenon@mips.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 12:24 AM, Deng-Cheng Zhu
<dengcheng.zhu@gmail.com> wrote:
> Use this new style (instead of filling in the pci_bus->resource[] array
> directly) to hide some ugly implementation details.
>
> Signed-off-by: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
> ---
>  arch/mips/pci/pci.c |   11 +++++++++--
>  1 files changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/arch/mips/pci/pci.c b/arch/mips/pci/pci.c
> index 33bba7b..7473214 100644
> --- a/arch/mips/pci/pci.c
> +++ b/arch/mips/pci/pci.c
> @@ -261,6 +261,14 @@ static void pcibios_fixup_device_resources(struct pci_dev *dev,
>        }
>  }
>
> +static void __devinit
> +pcibios_setup_root_resources(struct pci_bus *bus, struct pci_controller *ctrl)
> +{
> +       pci_bus_remove_resources(bus);
> +       pci_bus_add_resource(bus, ctrl->io_resource, 0);
> +       pci_bus_add_resource(bus, ctrl->mem_resource, 0);
> +}
> +
>  void __devinit pcibios_fixup_bus(struct pci_bus *bus)
>  {
>        /* Propagate hose info into the subordinate devices.  */
> @@ -270,8 +278,7 @@ void __devinit pcibios_fixup_bus(struct pci_bus *bus)
>        struct pci_dev *dev = bus->self;
>
>        if (!dev) {
> -               bus->resource[0] = hose->io_resource;
> -               bus->resource[1] = hose->mem_resource;
> +               pcibios_setup_root_resources(bus, hose);
>        } else if (pci_probe_only &&
>                   (dev->class >> 8) == PCI_CLASS_BRIDGE_PCI) {
>                pci_read_bridge_bases(bus);

I don't understand this patch.

Wouldn't it be enough to have [PATCH 2/3], which adds the
pci_create_bus() argument with nobody using it yet, then [PATCH 3/3],
which makes mips supply the new argument, and add a hunk to [PATCH
3/3] that completely removes the bus->resource fixups in
pcibios_fixup_bus() at the same time?

Bjorn
