Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221Ab2BHP7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 10:59:43 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:32891 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755Ab2BHP7m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 10:59:42 -0500
MIME-Version: 1.0
In-Reply-To: <1328425088-6562-10-git-send-email-yinghai@kernel.org>
References: <1328425088-6562-1-git-send-email-yinghai@kernel.org> <1328425088-6562-10-git-send-email-yinghai@kernel.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 8 Feb 2012 07:58:21 -0800
Message-ID: <CAErSpo6BwznWf3rq4J2Ao+rrgR4yWqQ0mQGygkd2KmBuA1OD8g@mail.gmail.com>
Subject: Re: [PATCH 09/24] PCI, powerpc: Register busn_res for root buses
To: Yinghai Lu <yinghai@kernel.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Tony Luck <tony.luck@intel.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        linuxppc-dev@lists.ozlabs.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 4, 2012 at 10:57 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: linuxppc-dev@lists.ozlabs.org
> ---
>  arch/powerpc/kernel/pci-common.c |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
>
> diff --git a/arch/powerpc/kernel/pci-common.c b/arch/powerpc/kernel/pci-common.c
> index cce98d7..501f29b 100644
> --- a/arch/powerpc/kernel/pci-common.c
> +++ b/arch/powerpc/kernel/pci-common.c
> @@ -1732,6 +1732,8 @@ void __devinit pcibios_scan_phb(struct pci_controller *hose)
>        bus->secondary = hose->first_busno;
>        hose->bus = bus;
>
> +       pci_bus_insert_busn_res(bus, hose->first_busno, hose->last_busno);
> +
>        /* Get probe mode and perform scan */
>        mode = PCI_PROBE_NORMAL;
>        if (node && ppc_md.pci_probe_mode)
> @@ -1742,8 +1744,11 @@ void __devinit pcibios_scan_phb(struct pci_controller *hose)
>                of_scan_bus(node, bus);
>        }
>
> -       if (mode == PCI_PROBE_NORMAL)
> +       if (mode == PCI_PROBE_NORMAL) {
> +               pci_bus_update_busn_res_end(bus, 255);
>                hose->last_busno = bus->subordinate = pci_scan_child_bus(bus);
> +               pci_bus_update_busn_res_end(bus, bus->subordinate);
> +       }

The only architecture-specific thing here is discovering the range of
bus numbers below a host bridge.  The architecture should not have to
mess around with pci_bus_update_busn_res_end() like this.  It should
be able to say "here's my bus number range" (and of course the PCI
core can default to 0-255 if the arch doesn't supply a range) and the
core should take care of the rest.

Bjorn
