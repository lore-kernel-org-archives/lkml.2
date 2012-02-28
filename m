Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803Ab2B1FhM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 00:37:12 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46198 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab2B1FhK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 00:37:10 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of bhelgaas@google.com designates 10.216.138.7 as permitted sender) smtp.mail=bhelgaas@google.com; dkim=pass header.i=bhelgaas@google.com
MIME-Version: 1.0
In-Reply-To: <1330395009-29260-9-git-send-email-yinghai@kernel.org>
References: <1330395009-29260-1-git-send-email-yinghai@kernel.org> <1330395009-29260-9-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 27 Feb 2012 22:36:48 -0700
Message-ID: <CAErSpo4bw-V=SM+h5iP4nfv3HaAnHjwvNwu+4Oz8iyQcY_3gOQ@mail.gmail.com>
Subject: Re: [PATCH 08/18] PCI, powerpc: Register busn_res for root buses
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 27, 2012 at 7:09 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: linuxppc-dev@lists.ozlabs.org
> ---
>  arch/powerpc/kernel/pci-common.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
>
> diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
> index 910b9de..ae5ae5f 100644
> --- a/arch/powerpc/kernel/pci-common.c
> +++ b/arch/powerpc/kernel/pci-common.c
> @@ -1660,6 +1660,8 @@ void __devinit pcibios_scan_phb(struct pci_controller *hose)
>        bus->secondary = hose->first_busno;
>        hose->bus = bus;
>
> +       pci_bus_insert_busn_res(bus, hose->first_busno, hose->last_busno);
> +
>        /* Get probe mode and perform scan */
>        mode = PCI_PROBE_NORMAL;
>        if (node && ppc_md.pci_probe_mode)
> @@ -1670,8 +1672,11 @@ void __devinit pcibios_scan_phb(struct pci_controller *hose)
>                of_scan_bus(node, bus);
>        }
>
> -       if (mode == PCI_PROBE_NORMAL)
> +       if (mode == PCI_PROBE_NORMAL) {
> +               pci_bus_update_busn_res_end(bus, 255);
>                hose->last_busno = bus->subordinate = pci_scan_child_bus(bus);
> +               pci_bus_update_busn_res_end(bus, bus->subordinate);
> +       }

There's a lot of powerpc code that does this:

    bus_range = of_get_property(pcictrl, "bus-range", &len);
    hose->first_busno = bus_range[0];
    hose->last_busno = bus_range[1];

That *looks* like it is discovering the bus number aperture.  Is it?
If it is, why are we using the largest bus number found by
pci_scan_child_bus() rather than "last_busno"?

Bjorn
