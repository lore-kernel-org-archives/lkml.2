Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932564Ab2FUAHU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 20:07:20 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:65382 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932513Ab2FUAHS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 20:07:18 -0400
MIME-Version: 1.0
In-Reply-To: <4FDF2044020000780008A66F@nat28.tlf.novell.com>
References: <4FDF2044020000780008A66F@nat28.tlf.novell.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 20 Jun 2012 18:06:55 -0600
Message-ID: <CAErSpo4yf66A-MoBLyUynMaha3Oa8_M2rNpwgK+2D1LgTaLhUw@mail.gmail.com>
Subject: Re: [PATCH] x86/PCI: adjust section annotations
To: Jan Beulich <JBeulich@suse.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, linux-cris-kernel@axis.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 4:34 AM, Jan Beulich <JBeulich@suse.com> wrote:
> DMI tables referenced from __init code only can be __initconst, and as
> a result the functions referenced from there can become __init.
>
> pcibios_setup() can be __init as being a command line parsing function
> only.
>
> A few other variables can then also have their attributes adjusted.

This seems OK as far as it goes.

However, if you're going to make pcibios_setup() __init for x86, I'd
really encourage you to make it consistent across all the other
architectures.  And if you do *that*, I think it would be cool if you
supplied a generic do-nothing "weak" version in the PCI core.  That
would allow you to remove it altogether from alpha, ia64, microblaze,
mips pmc-sierra, parisc, powerpc, sh, sparc, tile, and xtensa.

CRIS-folk: It would also fix what looks like a bug in cris, which
implements pcibios_setup() such that pci_setup() doesn't even look for
all the supposedly generic options.

> Signed-off-by: Jan Beulich <jbeulich@suse.com>
>
> ---
>  arch/x86/pci/common.c |   22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
>
> --- 3.5-rc3/arch/x86/pci/common.c
> +++ 3.5-rc3-x86-pci-common-sections/arch/x86/pci/common.c
> @@ -21,10 +21,10 @@
>  unsigned int pci_probe = PCI_PROBE_BIOS | PCI_PROBE_CONF1 | PCI_PROBE_CONF2 |
>                                PCI_PROBE_MMCONF;
>
> -unsigned int pci_early_dump_regs;
> -static int pci_bf_sort;
> -static int smbios_type_b1_flag;
> -int pci_routeirq;
> +unsigned int __initdata pci_early_dump_regs;
> +static int __devinitdata pci_bf_sort;
> +static int __devinitdata smbios_type_b1_flag;
> +int __initdata pci_routeirq;
>  int noioapicquirk;
>  #ifdef CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS
>  int noioapicreroute = 0;
> @@ -32,7 +32,7 @@ int noioapicreroute = 0;
>  int noioapicreroute = 1;
>  #endif
>  int pcibios_last_bus = -1;
> -unsigned long pirq_table_addr;
> +unsigned long __initdata pirq_table_addr;
>  struct pci_bus *pci_root_bus;
>  const struct pci_raw_ops *__read_mostly raw_pci_ops;
>  const struct pci_raw_ops *__read_mostly raw_pci_ext_ops;
> @@ -80,14 +80,14 @@ struct pci_ops pci_root_ops = {
>  */
>  DEFINE_RAW_SPINLOCK(pci_config_lock);
>
> -static int __devinit can_skip_ioresource_align(const struct dmi_system_id *d)
> +static int __init can_skip_ioresource_align(const struct dmi_system_id *d)
>  {
>        pci_probe |= PCI_CAN_SKIP_ISA_ALIGN;
>        printk(KERN_INFO "PCI: %s detected, can skip ISA alignment\n", d->ident);
>        return 0;
>  }
>
> -static const struct dmi_system_id can_skip_pciprobe_dmi_table[] __devinitconst = {
> +static const struct dmi_system_id can_skip_pciprobe_dmi_table[] __initconst = {
>  /*
>  * Systems where PCI IO resource ISA alignment can be skipped
>  * when the ISA enable bit in the bridge control is not set
> @@ -221,7 +221,7 @@ static int __devinit find_sort_method(co
>  * Enable renumbering of PCI bus# ranges to reach all PCI busses (Cardbus)
>  */
>  #ifdef __i386__
> -static int __devinit assign_all_busses(const struct dmi_system_id *d)
> +static int __init assign_all_busses(const struct dmi_system_id *d)
>  {
>        pci_probe |= PCI_ASSIGN_ALL_BUSSES;
>        printk(KERN_INFO "%s detected: enabling PCI bus# renumbering"
> @@ -230,7 +230,7 @@ static int __devinit assign_all_busses(c
>  }
>  #endif
>
> -static int __devinit set_scan_all(const struct dmi_system_id *d)
> +static int __init set_scan_all(const struct dmi_system_id *d)
>  {
>        printk(KERN_INFO "PCI: %s detected, enabling pci=pcie_scan_all\n",
>               d->ident);
> @@ -238,7 +238,7 @@ static int __devinit set_scan_all(const
>        return 0;
>  }
>
> -static const struct dmi_system_id __devinitconst pciprobe_dmi_table[] = {
> +static const struct dmi_system_id __initconst pciprobe_dmi_table[] = {
>  #ifdef __i386__
>  /*
>  * Laptops which need pci=assign-busses to see Cardbus cards
> @@ -494,7 +494,7 @@ int __init pcibios_init(void)
>        return 0;
>  }
>
> -char * __devinit  pcibios_setup(char *str)
> +char *__init pcibios_setup(char *str)
>  {
>        if (!strcmp(str, "off")) {
>                pci_probe = 0;
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
