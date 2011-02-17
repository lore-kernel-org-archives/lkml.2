Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228Ab1BQRWA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 12:22:00 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63633 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756687Ab1BQRV4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 12:21:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=w5D+X43C8o+2lppySX7Ms3QFi8hgcpAnyabgAZziXofyTnoevN1mPGqop61cHR/qdm
         +Uc87m/WuANiIsYEdhXFSnQZgWN2hFZsxpR7ztpjTfSP0uhBCL8D3T6QvKyimqElxCRo
         a+olNNittJsPEnxYUlknGlLWVYzDk+c9eWRqk=
MIME-Version: 1.0
In-Reply-To: <4D5D562A0200007800032744@vpn.id2.novell.com>
References: <4D5D562A0200007800032744@vpn.id2.novell.com>
Date: Thu, 17 Feb 2011 09:21:54 -0800
X-Google-Sender-Auth: xZrGOb6fCsUvdcbmBxSAp3dmgMk
Message-ID: <AANLkTik8B_evoOh_B9=2w=5nDAheZZiZLWyLGHavPy1c@mail.gmail.com>
Subject: Re: [PATCH, resend] x86/PCI: don't export a __devinit function
From: Yinghai Lu <yinghai@kernel.org>
To: Jan Beulich <JBeulich@novell.com>,
        "Barnes, Jesse" <jesse.barnes@intel.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, arozansk@redhat.com,
        mchehab@redhat.com, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 8:08 AM, Jan Beulich <JBeulich@novell.com> wrote:
> Exporting a __devinit function (pcibios_scan_specific_bus()) isn't
> correct. (Michal, any reason why modpost only warns about exported
> __init functions?) Short of being able to think of a better solution,
> and short of making the whole call tree (reaching into the arch-
> independent part of the PCI subsystem) non-__devinit, export the
> symbol only when HOTPLUG is enabled (which is always the case for non-
> expert configurations), use section mismatch avoidance annotations for
> that case (knowing that __devinit functions will not be discarded),
> and mark the symbol __devinit only in the !HOTPLUG case.
>
> Consequently, EDAC_I7CORE (consuming the export) then has to depend on
> HOTPLUG. A fundamental question of course if whether this driver has
> to use that function in the first place (i.e. whether it wouldn't be
> better to just remove the export) - the problem it tries to address
> happens on other systems too, but the PCI bus the devices in question
> live on isn't necessarily bus 255. For the affected system I have, the
> alternative approach is to set pcibios_last_bus from __pci_mmcfg_init()
> based on the highest bus number on segment 0 being covered by MCFG.
>
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> Cc: Aristeu Sergio <arozansk@redhat.com>
> Cc: Michal Marek <mmarek@suse.cz>
>
> ---
>  arch/x86/pci/legacy.c |   21 ++++++++++++++++++---
>  drivers/edac/Kconfig  |    2 +-
>  2 files changed, 19 insertions(+), 4 deletions(-)
>
> --- 2.6.38-rc5/arch/x86/pci/legacy.c
> +++ 2.6.38-rc5-x86-pci-section-conflict/arch/x86/pci/legacy.c
> @@ -36,7 +36,23 @@ int __init pci_legacy_init(void)
>        return 0;
>  }
>
> -void __devinit pcibios_scan_specific_bus(int busn)
> +#ifdef CONFIG_HOTPLUG
> +static void __ref
> +#else
> +static inline void
> +#endif
> +_pci_scan_bus_on_node(int busno, int node)
> +{
> +       pci_scan_bus_on_node(busno, &pci_root_ops, node);
> +}
> +
> +#ifdef CONFIG_HOTPLUG
> +EXPORT_SYMBOL_GPL(pcibios_scan_specific_bus);
> +void
> +#else
> +void __devinit
> +#endif

anyway to avoid or reduce those #ifdef?

Yinghai

> +pcibios_scan_specific_bus(int busn)
>  {
>        int devfn;
>        long node;
> @@ -51,12 +67,11 @@ void __devinit pcibios_scan_specific_bus
>                    l != 0x0000 && l != 0xffff) {
>                        DBG("Found device at %02x:%02x [%04x]\n", busn, devfn, l);
>                        printk(KERN_INFO "PCI: Discovered peer bus %02x\n", busn);
> -                       pci_scan_bus_on_node(busn, &pci_root_ops, node);
> +                       _pci_scan_bus_on_node(busn, node);
>                        return;
>                }
>        }
>  }
> -EXPORT_SYMBOL_GPL(pcibios_scan_specific_bus);
>
>  int __init pci_subsys_init(void)
>  {
> --- 2.6.38-rc5/drivers/edac/Kconfig
> +++ 2.6.38-rc5-x86-pci-section-conflict/drivers/edac/Kconfig
> @@ -173,7 +173,7 @@ config EDAC_I5400
>
>  config EDAC_I7CORE
>        tristate "Intel i7 Core (Nehalem) processors"
> -       depends on EDAC_MM_EDAC && PCI && X86
> +       depends on EDAC_MM_EDAC && PCI && X86 && HOTPLUG
>        select EDAC_MCE
>        help
>          Support for error detection and correction the Intel
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
