Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754457Ab2JOSgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 14:36:48 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53281 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422Ab2JOSgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 14:36:46 -0400
MIME-Version: 1.0
In-Reply-To: <20121015065526.2832.90867.sendpatchset@indoh>
References: <20121015065516.2832.42378.sendpatchset@indoh>
	<20121015065526.2832.90867.sendpatchset@indoh>
Date: Mon, 15 Oct 2012 11:36:44 -0700
X-Google-Sender-Auth: dl45CfjESgHMtKJ30Q9iTNT3Mgk
Message-ID: <CAE9FiQXKjNU4Sasj4LmiFiNNu9quGgKAdW3ciVnXggoWZiYXJA@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] x86, pci: Reset PCIe devices at boot time
From: Yinghai Lu <yinghai@kernel.org>
To: Takao Indoh <indou.takao@jp.fujitsu.com>
Cc: linux-pci@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        martin.wilck@ts.fujitsu.com, kexec@lists.infradead.org,
        hbabu@us.ibm.com, andi@firstfloor.org, ddutile@redhat.com,
        ishii.hironobu@jp.fujitsu.com, hpa@zytor.com, bhelgaas@google.com,
        tglx@linutronix.de, mingo@redhat.com, vgoyal@redhat.com,
        khalid@gonehiking.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 12:00 AM, Takao Indoh
<indou.takao@jp.fujitsu.com> wrote:
> This patch resets PCIe devices at boot time by hot reset when
> "reset_devices" is specified.

how about pci devices that domain_nr is not zero ?

>
> Signed-off-by: Takao Indoh <indou.takao@jp.fujitsu.com>
> ---
>  arch/x86/include/asm/pci-direct.h |    1
>  arch/x86/kernel/setup.c           |    3
>  arch/x86/pci/early.c              |  344 ++++++++++++++++++++++++++++
>  include/linux/pci.h               |    2
>  init/main.c                       |    4
>  5 files changed, 352 insertions(+), 2 deletions(-)
>
> diff --git a/arch/x86/include/asm/pci-direct.h b/arch/x86/include/asm/pci-direct.h
> index b1e7a45..de30db2 100644
> --- a/arch/x86/include/asm/pci-direct.h
> +++ b/arch/x86/include/asm/pci-direct.h
> @@ -18,4 +18,5 @@ extern int early_pci_allowed(void);
>  extern unsigned int pci_early_dump_regs;
>  extern void early_dump_pci_device(u8 bus, u8 slot, u8 func);
>  extern void early_dump_pci_devices(void);
> +extern void early_reset_pcie_devices(void);
>  #endif /* _ASM_X86_PCI_DIRECT_H */
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index a2bb18e..73d3425 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -987,6 +987,9 @@ void __init setup_arch(char **cmdline_p)
>         generic_apic_probe();
>
>         early_quirks();
> +#ifdef CONFIG_PCI
> +       early_reset_pcie_devices();
> +#endif
>
>         /*
>          * Read APIC and some other early information from ACPI tables.
> diff --git a/arch/x86/pci/early.c b/arch/x86/pci/early.c
> index d1067d5..683b30f 100644
> --- a/arch/x86/pci/early.c
> +++ b/arch/x86/pci/early.c
> @@ -1,5 +1,6 @@
>  #include <linux/kernel.h>
>  #include <linux/pci.h>
> +#include <linux/bootmem.h>
>  #include <asm/pci-direct.h>
>  #include <asm/io.h>
>  #include <asm/pci_x86.h>
> @@ -109,3 +110,346 @@ void early_dump_pci_devices(void)
>                 }
>         }
>  }
> +
> +#define PCI_EXP_SAVE_REGS      7
> +#define pcie_cap_has_devctl(type, flags)       1
> +#define pcie_cap_has_lnkctl(type, flags)               \
> +               ((flags & PCI_EXP_FLAGS_VERS) > 1 ||    \
> +                (type == PCI_EXP_TYPE_ROOT_PORT ||     \
> +                 type == PCI_EXP_TYPE_ENDPOINT ||      \
> +                 type == PCI_EXP_TYPE_LEG_END))
> +#define pcie_cap_has_sltctl(type, flags)               \
> +               ((flags & PCI_EXP_FLAGS_VERS) > 1 ||    \
> +                ((type == PCI_EXP_TYPE_ROOT_PORT) ||   \
> +                 (type == PCI_EXP_TYPE_DOWNSTREAM &&   \
> +                  (flags & PCI_EXP_FLAGS_SLOT))))
> +#define pcie_cap_has_rtctl(type, flags)                        \
> +               ((flags & PCI_EXP_FLAGS_VERS) > 1 ||    \
> +                (type == PCI_EXP_TYPE_ROOT_PORT ||     \
> +                 type == PCI_EXP_TYPE_RC_EC))
> +
> +struct save_config {
> +       u32 pci[16];
> +       u16 pcie[PCI_EXP_SAVE_REGS];
> +};
> +
> +struct pcie_dev {
> +       int cap;   /* position of PCI Express capability */
> +       int flags; /* PCI_EXP_FLAGS */
> +       struct save_config save; /* saved configration register */
> +};
> +
> +struct pcie_port {
> +       struct list_head dev;
> +       u8 secondary;
> +       struct pcie_dev child[PCI_MAX_FUNCTIONS];
> +};
> +
> +static LIST_HEAD(device_list);
> +static void __init pci_udelay(int loops)
> +{
> +       while (loops--) {
> +               /* Approximately 1 us */
> +               native_io_delay();
> +       }
> +}
> +
> +/* Derived from drivers/pci/pci.c */
> +#define PCI_FIND_CAP_TTL       48
> +static int __init __pci_find_next_cap_ttl(u8 bus, u8 slot, u8 func,
> +                                         u8 pos, int cap, int *ttl)
> +{
> +       u8 id;
> +
> +       while ((*ttl)--) {
> +               pos = read_pci_config_byte(bus, slot, func, pos);
> +               if (pos < 0x40)
> +                       break;
> +               pos &= ~3;
> +               id = read_pci_config_byte(bus, slot, func,
> +                                       pos + PCI_CAP_LIST_ID);
> +               if (id == 0xff)
> +                       break;
> +               if (id == cap)
> +                       return pos;
> +               pos += PCI_CAP_LIST_NEXT;
> +       }
> +       return 0;
> +}
> +
> +static int __init __pci_find_next_cap(u8 bus, u8 slot, u8 func, u8 pos, int cap)
> +{
> +       int ttl = PCI_FIND_CAP_TTL;
> +
> +       return __pci_find_next_cap_ttl(bus, slot, func, pos, cap, &ttl);
> +}
> +
> +static int __init __pci_bus_find_cap_start(u8 bus, u8 slot, u8 func,
> +                                          u8 hdr_type)
> +{
> +       u16 status;
> +
> +       status = read_pci_config_16(bus, slot, func, PCI_STATUS);
> +       if (!(status & PCI_STATUS_CAP_LIST))
> +               return 0;
> +
> +       switch (hdr_type) {
> +       case PCI_HEADER_TYPE_NORMAL:
> +       case PCI_HEADER_TYPE_BRIDGE:
> +               return PCI_CAPABILITY_LIST;
> +       case PCI_HEADER_TYPE_CARDBUS:
> +               return PCI_CB_CAPABILITY_LIST;
> +       default:
> +               return 0;
> +       }
> +
> +       return 0;
> +}
> +
> +static int __init early_pci_find_capability(u8 bus, u8 slot, u8 func, int cap)
> +{
> +       int pos;
> +       u8 type = read_pci_config_byte(bus, slot, func, PCI_HEADER_TYPE);
> +
> +       pos = __pci_bus_find_cap_start(bus, slot, func, type & 0x7f);
> +       if (pos)
> +               pos = __pci_find_next_cap(bus, slot, func, pos, cap);
> +
> +       return pos;
> +}
> +
> +static void __init do_reset(u8 bus, u8 slot, u8 func)
> +{
> +       u16 ctrl;
> +
> +       printk(KERN_INFO "pci 0000:%02x:%02x.%d reset\n", bus, slot, func);
> +
> +       /* Assert Secondary Bus Reset */
> +       ctrl = read_pci_config_16(bus, slot, func, PCI_BRIDGE_CONTROL);
> +       ctrl |= PCI_BRIDGE_CTL_BUS_RESET;
> +       write_pci_config_16(bus, slot, func, PCI_BRIDGE_CONTROL, ctrl);
> +
> +       /*
> +        * PCIe spec requires software to ensure a minimum reset duration
> +        * (Trst == 1ms). We have here 5ms safety margin because pci_udelay is
> +        * not precise.
> +        */
> +       pci_udelay(5000);
> +
> +       /* De-assert Secondary Bus Reset */
> +       ctrl &= ~PCI_BRIDGE_CTL_BUS_RESET;
> +       write_pci_config_16(bus, slot, func, PCI_BRIDGE_CONTROL, ctrl);
> +}
> +
> +static void __init save_state(unsigned bus, unsigned slot, unsigned func,
> +               struct pcie_dev *dev)
> +{
> +       int i;
> +       int pcie, flags, pcie_type;
> +       struct save_config *save;
> +
> +       pcie = dev->cap;
> +       flags = dev->flags;
> +       pcie_type = (flags & PCI_EXP_FLAGS_TYPE) >> 4;
> +       save = &dev->save;
> +
> +       printk(KERN_INFO "pci 0000:%02x:%02x.%d save state\n", bus, slot, func);
> +
> +       for (i = 0; i < 16; i++)
> +               save->pci[i] = read_pci_config(bus, slot, func, i * 4);
> +       i = 0;
> +       if (pcie_cap_has_devctl(pcie_type, flags))
> +               save->pcie[i++] = read_pci_config_16(bus, slot, func,
> +                                                     pcie + PCI_EXP_DEVCTL);
> +       if (pcie_cap_has_lnkctl(pcie_type, flags))
> +               save->pcie[i++] = read_pci_config_16(bus, slot, func,
> +                                                     pcie + PCI_EXP_LNKCTL);
> +       if (pcie_cap_has_sltctl(pcie_type, flags))
> +               save->pcie[i++] = read_pci_config_16(bus, slot, func,
> +                                                     pcie + PCI_EXP_SLTCTL);
> +       if (pcie_cap_has_rtctl(pcie_type, flags))
> +               save->pcie[i++] = read_pci_config_16(bus, slot, func,
> +                                                     pcie + PCI_EXP_RTCTL);
> +
> +       if ((flags & PCI_EXP_FLAGS_VERS) >= 2) {
> +               save->pcie[i++] = read_pci_config_16(bus, slot, func,
> +                                                     pcie + PCI_EXP_DEVCTL2);
> +               save->pcie[i++] = read_pci_config_16(bus, slot, func,
> +                                                     pcie + PCI_EXP_LNKCTL2);
> +               save->pcie[i++] = read_pci_config_16(bus, slot, func,
> +                                                     pcie + PCI_EXP_SLTCTL2);
> +       }
> +}
> +
> +static void __init restore_state(unsigned bus, unsigned slot, unsigned func,
> +               struct pcie_dev *dev)
> +{
> +       int i = 0;
> +       int pcie, flags, pcie_type;
> +       struct save_config *save;
> +
> +       pcie = dev->cap;
> +       flags = dev->flags;
> +       pcie_type = (flags & PCI_EXP_FLAGS_TYPE) >> 4;
> +       save = &dev->save;
> +
> +       printk(KERN_INFO "pci 0000:%02x:%02x.%d restore state\n",
> +              bus, slot, func);
> +
> +       if (pcie_cap_has_devctl(pcie_type, flags))
> +               write_pci_config_16(bus, slot, func,
> +                                   pcie + PCI_EXP_DEVCTL, save->pcie[i++]);
> +       if (pcie_cap_has_lnkctl(pcie_type, flags))
> +               write_pci_config_16(bus, slot, func,
> +                                   pcie + PCI_EXP_LNKCTL, save->pcie[i++]);
> +       if (pcie_cap_has_sltctl(pcie_type, flags))
> +               write_pci_config_16(bus, slot, func,
> +                                   pcie + PCI_EXP_SLTCTL, save->pcie[i++]);
> +       if (pcie_cap_has_rtctl(pcie_type, flags))
> +               write_pci_config_16(bus, slot, func,
> +                                   pcie + PCI_EXP_RTCTL, save->pcie[i++]);
> +
> +       if ((flags & PCI_EXP_FLAGS_VERS) >= 2) {
> +               write_pci_config_16(bus, slot, func,
> +                                   pcie + PCI_EXP_DEVCTL2, save->pcie[i++]);
> +               write_pci_config_16(bus, slot, func,
> +                                   pcie + PCI_EXP_LNKCTL2, save->pcie[i++]);
> +               write_pci_config_16(bus, slot, func,
> +                                   pcie + PCI_EXP_SLTCTL2, save->pcie[i++]);
> +       }
> +
> +       for (i = 15; i >= 0; i--)
> +               write_pci_config(bus, slot, func, i * 4, save->pci[i]);
> +}

do you have to pass bus/slot/func and use read/pci_config directly ?

I had one patchset that use dummy pci device and reuse existing late quirk code
in early_quirk to do usb handoff early.

please check

git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
for-x86-early-quirk-usb

678a023: x86: usb handoff in early_quirk
2d418d8: pci, usb: Make usb handoff func all take base remapping
d9bd1ad: x86, pci: add dummy pci device for early stage
de38757: x86: early_quirk check all bus/dev/func in domain 0
325cc7a: make msleep to do mdelay before scheduler is running
eec78a4: x86: set percpu cpu_info lpj to default
52ebec4: x86, pci: early dump skip device the same way as later probe code

if that could help.
you may reuse some later functions that take pci_dev as parameters.
also mdelay should work early...
and use early_quirk instead add another calling in setup.c

Yinghai
