Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757773Ab2JZJBT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 05:01:19 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:52273 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753919Ab2JZJBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 05:01:13 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo7mcDkWUhUBvnZ6P+5TOYsE=j6zB7MHqfY1wvqyyE1CBQ@mail.gmail.com>
References: <CADCVGbTDD-4WOVJWwaGBvay5=of=3VKBCVacrrW-z12BYZ1xbQ@mail.gmail.com>
	<CAErSpo7mcDkWUhUBvnZ6P+5TOYsE=j6zB7MHqfY1wvqyyE1CBQ@mail.gmail.com>
Date: Fri, 26 Oct 2012 17:01:10 +0800
Message-ID: <CADCVGbTQTH05TtoGUm-oNYnM8NR9OKr0GVgK0sETnW6H29b+6A@mail.gmail.com>
Subject: Re: PCIe IO space support on Tilera GX: Is there any one who can
 confirm my modification to fix it is OK?
From: Cyberman Wu <cypher.w@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're not using 3.6.x, we're using is from MDE-4.1.0 from Tilera and
it patch 3.0.38.
>From its release notes that PCIe I/O space is already supported.
I provide diff of pci_gx.c between 3.6.3 and MDE-4.1.0 for a hint,
since I don't know
if it's allowed to use attached file in mail list, and their patch for
3.0.38 is bigger than
7MB.

For mvsas, it seems do think 0 I/O address invalied. Some code from
drivers/scsi/mvsas/mv_init.c:
int mvs_ioremap(struct mvs_info *mvi, int bar, int bar_ex)
{
	unsigned long res_start, res_len, res_flag, res_flag_ex = 0;
	struct pci_dev *pdev = mvi->pdev;
	if (bar_ex != -1) {
		/*
		 * ioremap main and peripheral registers
		 */
		res_start = pci_resource_start(pdev, bar_ex);
		res_len = pci_resource_len(pdev, bar_ex);
		if (!res_start || !res_len)
			goto err_out;

		res_flag_ex = pci_resource_flags(pdev, bar_ex);
		if (res_flag_ex & IORESOURCE_MEM) {
			if (res_flag_ex & IORESOURCE_CACHEABLE)
				mvi->regs_ex = ioremap(res_start, res_len);
			else
				mvi->regs_ex = ioremap_nocache(res_start,
						res_len);
		} else
			mvi->regs_ex = (void *)res_start;
		if (!mvi->regs_ex)
			goto err_out;
	}

	res_start = pci_resource_start(pdev, bar);
	res_len = pci_resource_len(pdev, bar);
	if (!res_start || !res_len)
		goto err_out;

	res_flag = pci_resource_flags(pdev, bar);
	if (res_flag & IORESOURCE_CACHEABLE)
		mvi->regs = ioremap(res_start, res_len);
	else
		mvi->regs = ioremap_nocache(res_start, res_len);

	if (!mvi->regs) {
		if (mvi->regs_ex && (res_flag_ex & IORESOURCE_MEM))
			iounmap(mvi->regs_ex);
		mvi->regs_ex = NULL;
		goto err_out;
	}

	return 0;
err_out:
	return -1;
}

For 64xx, bar_ex is I/O space, and
		res_start = pci_resource_start(pdev, bar_ex);
		res_len = pci_resource_len(pdev, bar_ex);
		if (!res_start || !res_len)
			goto err_out;
will cause driver loading failed.

When we using MDE-4.0.0 it don't support I/O space, I just bypass
these check since after
investigate all code of mvsas it seems that I/O space map to BAR 2 is
not really used.

When the same card inserted into x86 platform, the allocated I/O space
is not start from 0,
so it works fine.


On Fri, Oct 26, 2012 at 4:03 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> [+cc Chris, also a few comments below]
>
> On Fri, Oct 26, 2012 at 12:59 AM, Cyberman Wu <cypher.w@gmail.com> wrote:
>> After we upgrade to MDE 4.1.0 from Tilera, we encounter a problem that
>> only on HighPoint 2680 card works, I've
>> tried to fix it, but since most time I'm working in user space, I'm
>> not sure my fix is enough. Their FAE said that
>> the guy who add PCIe I/O space support is on vacation and I can't get
>> help from him now, I hope maybe there
>> will have somebody can help.
>>
>>
>> Problem we encountered:
>>
>> pci 0000:00:00.0: BAR 8: assigned [mem 0x100c0000000-0x100c00fffff]
>> pci 0000:00:00.0: BAR 9: assigned [mem 0x100c0100000-0x100c01fffff pref]
>> pci 0000:00:00.0: BAR 7: assigned [io  0x0000-0x0fff]
>> pci 0000:01:00.0: BAR 6: assigned [mem 0x100c0100000-0x100c013ffff pref]
>> pci 0000:01:00.0: BAR 6: set to [mem 0x100c0100000-0x100c013ffff pref]
>> (PCI address [0xc0100000-0xc013ffff])
>> pci 0000:01:00.0: BAR 4: assigned [mem 0x100c0000000-0x100c000ffff 64bit]
>> pci 0000:01:00.0: BAR 4: set to [mem 0x100c0000000-0x100c000ffff
>> 64bit] (PCI address [0xc0000000-0xc000ffff])
>> pci 0000:01:00.0: BAR 2: assigned [io  0x0000-0x007f]
>> pci 0000:01:00.0: BAR 2: set to [io  0x0000-0x007f] (PCI address [0x0-0x7f])
>> pci 0000:00:00.0: PCI bridge to [bus 01-01]
>> pci 0000:00:00.0:   bridge window [io  0x0000-0x0fff]
>> pci 0000:00:00.0:   bridge window [mem 0x100c0000000-0x100c00fffff]
>> pci 0000:00:00.0:   bridge window [mem 0x100c0100000-0x100c01fffff pref]
>> pci 0001:00:00.0: BAR 8: assigned [mem 0x101c0000000-0x101c00fffff]
>> pci 0001:00:00.0: BAR 9: assigned [mem 0x101c0100000-0x101c01fffff pref]
>> pci 0001:00:00.0: BAR 7: assigned [io  0x0000-0x0fff]
>> pci 0001:01:00.0: BAR 6: assigned [mem 0x101c0100000-0x101c013ffff pref]
>> pci 0001:01:00.0: BAR 6: set to [mem 0x101c0100000-0x101c013ffff pref]
>> (PCI address [0xc0100000-0xc013ffff])
>> pci 0001:01:00.0: BAR 4: assigned [mem 0x101c0000000-0x101c000ffff 64bit]
>> pci 0001:01:00.0: BAR 4: set to [mem 0x101c0000000-0x101c000ffff
>> 64bit] (PCI address [0xc0000000-0xc000ffff])
>> pci 0001:01:00.0: BAR 2: assigned [io  0x0000-0x007f]
>> pci 0001:01:00.0: BAR 2: set to [io  0x0000-0x007f] (PCI address [0x0-0x7f])
>> pci 0001:00:00.0: PCI bridge to [bus 01-01]
>> pci 0001:00:00.0:   bridge window [io  0x0000-0x0fff]
>> pci 0001:00:00.0:   bridge window [mem 0x101c0000000-0x101c00fffff]
>> pci 0001:00:00.0:   bridge window [mem 0x101c0100000-0x101c01fffff pref]
>> pci 0000:00:00.0: enabling device (0006 -> 0007)
>> pci 0001:00:00.0: enabling device (0006 -> 0007)
>> pci_bus 0000:00: resource 0 [io  0x0000-0xffffffff]
>> pci_bus 0000:00: resource 1 [mem 0x100c0000000-0x100ffffffff]
>> pci_bus 0000:01: resource 0 [io  0x0000-0x0fff]
>> pci_bus 0000:01: resource 1 [mem 0x100c0000000-0x100c00fffff]
>> pci_bus 0000:01: resource 2 [mem 0x100c0100000-0x100c01fffff pref]
>> pci_bus 0001:00: resource 0 [io  0x0000-0xffffffff]
>> pci_bus 0001:00: resource 1 [mem 0x101c0000000-0x101ffffffff]
>> pci_bus 0001:01: resource 0 [io  0x0000-0x0fff]
>> pci_bus 0001:01: resource 1 [mem 0x101c0000000-0x101c00fffff]
>> pci_bus 0001:01: resource 2 [mem 0x101c0100000-0x101c01fffff pref]
>> ......
>> mvsas 0000:01:00.0: mvsas: driver version 0.8.2
>> mvsas 0000:01:00.0: enabling device (0000 -> 0003)
>> mvsas 0000:01:00.0: enabling bus mastering
>> mvsas 0000:01:00.0: mvsas: PCI-E x4, Bandwidth Usage: 2.5 Gbps
>> mvsas 0000:01:00.0: Phy3 : No sig fis
>> scsi0 : mvsas
>> ......
>> mvsas 0001:01:00.0: mvsas: driver version 0.8.2
>> mvsas 0001:01:00.0: enabling device (0000 -> 0003)
>> mvsas 0001:01:00.0: enabling bus mastering
>> mvsas 0001:01:00.0: BAR 2: can't reserve [io  0x0000-0x007f]
>> mvsas: probe of 0001:01:00.0 failed with error -16
>>
>>
>> My modification:
>>
>> --- /opt/tilera/TileraMDE-4.1.0.148119/tilegx/src/linux-2.6.40.38/arch/tile/kernel/pci_gx.c     2012-10-22
>> 14:56:59.783096378 +0800
>> +++ Tilera_src/src/linux-2.6.40.38/arch/tile/kernel/pci_gx.c    2012-10-26
>> 13:55:02.731947886 +0800
>> @@ -368,6 +368,10 @@
>>         int num_trio_shims = 0;
>>         int ctl_index = 0;
>>         int i, j;
>> +    // Modified by Cyberman Wu on Oct 25th, 2012.
>> +       resource_size_t io_mem_start;
>> +       resource_size_t io_mem_end;
>> +       resource_size_t io_mem_size;
>>
>>         if (!pci_probe) {
>>                 pr_info("PCI: disabled by boot argument\n");
>> @@ -457,6 +461,18 @@
>>         }
>>
>>  out:
>> +       // Use IO memory space 0~0xffffffff for every controller will
>> +       // cause device on controller other than the first failed to
>> +       // load driver if it using IO regions.
>> +       // Is reserve the first 4K IO address space OK? Tilera use
>> +       // IO space address begin from 0, but some drivers in Linux
>> +       // recognize 0 address a error, say, mvsas, so for compatiblity
>> +       // reserve some address from 0 should be better?
>
> It's not that mvsas thinks I/O address 0 is invalid, it's just that we
> already assigned [io 0x0000-0x007f] to the device at 0000:01:00.0:
>
>   pci 0000:01:00.0: BAR 2: set to [io  0x0000-0x007f]
>
> so that range can't also be assigned to 0001:01:00.0.
>
>> +       // Modified by Cyberman Wu on Oct 25th, 2012.
>> +       io_mem_start = 4096;
>> +       io_mem_end = (resource_size_t)IO_SPACE_LIMIT + 1;
>> +       io_mem_size = (io_mem_end - io_mem_start) / num_rc_controllers;
>> +       io_mem_size &= ~3;
>>         /*
>>          * Configure each PCIe RC port.
>>          */
>> @@ -470,8 +486,9 @@
>>                 controller->index = i;
>>                 controller->ops = &tile_cfg_ops;
>>
>> -               controller->io_space.start = 0;
>> -               controller->io_space.end = IO_SPACE_LIMIT;
>> +               // Modified by Cyberman Wu on Oct 25th, 2012.
>> +               controller->io_space.start = io_mem_start + (i * io_mem_size);
>> +               controller->io_space.end = controller->io_space.start + io_mem_size - 1;
>>                 controller->io_space.flags = IORESOURCE_IO;
>>                 snprintf(controller->io_space_name,
>>                          sizeof(controller->io_space_name),
>>
>>
>> Please note that we're using MDE-4.1.0, which use kernel 3.0.38, patch
>> it and reversion it
>> to 2.6.40.38.
>> I've checked source code under arch/tile of kernel 3.6.3 and PCIe I/O
>> space support is still
>> not here. Below is diff of arch/tile/pci_gx.c between kernel 3.6.3 and
>> MDE-4.1.0:
>
> Per http://lkml.indiana.edu/hypermail/linux/kernel/1205.1/01176.html,
> Chris considered adding I/O space support and decided against it at
> that time, partly because it would use up a TRIO PIO region.
>
> I don't know his current thoughts.  Possibly it could be done under a
> config option or something.
>
> But of course, you'd have to do it by adding I/O space support to the
> current 3.6 kernel *without* reverting all the other changes that have
> been made since 2.6.40.
>
>> --- .cache/.fr-9Oo37J/linux-3.6.3/arch/tile/kernel/pci_gx.c     2012-10-22
>> 00:32:56.000000000 +0800
>> +++ /opt/tilera/TileraMDE-4.1.0.148119/tilegx/src/linux-2.6.40.38/arch/tile/kernel/pci_gx.c     2012-10-22
>> 14:56:59.783096378 +0800
>> @@ -69,19 +69,18 @@
>>   * a HW PCIe link-training bug. The exact delay is specified with
>>   * a kernel boot argument in the form of "pcie_rc_delay=T,P,S",
>>   * where T is the TRIO instance number, P is the port number and S is
>> - * the delay in seconds. If the delay is not provided, the value
>> - * will be DEFAULT_RC_DELAY.
>> + * the delay in seconds. If the argument is specified, but the delay is
>> + * not provided, the value will be DEFAULT_RC_DELAY.
>>   */
>>  static int __devinitdata rc_delay[TILEGX_NUM_TRIO][TILEGX_TRIO_PCIES];
>>
>>  /* Default number of seconds that the PCIe RC port probe can be delayed. */
>>  #define DEFAULT_RC_DELAY       10
>>
>> -/* Max number of seconds that the PCIe RC port probe can be delayed. */
>> -#define MAX_RC_DELAY           20
>> -
>> +#if !defined(GX_FPGA)
>>  /* Array of the PCIe ports configuration info obtained from the BIB. */
>>  struct pcie_port_property pcie_ports[TILEGX_NUM_TRIO][TILEGX_TRIO_PCIES];
>> +#endif
>>
>>  /* All drivers share the TRIO contexts defined here. */
>>  gxio_trio_context_t trio_contexts[TILEGX_NUM_TRIO];
>> @@ -97,6 +96,41 @@
>>  static struct cpumask intr_cpus_map;
>>
>>  /*
>> + * Convert a resource to a PCI device bus address or bus window.
>> + */
>> +void __devinit
>> +pcibios_resource_to_bus(struct pci_dev *dev, struct pci_bus_region *region,
>> +                       struct resource *res)
>> +{
>> +       struct pci_controller *controller =
>> +               (struct pci_controller *)dev->sysdata;
>> +       unsigned long offset = 0;
>> +
>> +       if (res->flags & IORESOURCE_MEM)
>> +               offset = controller->mem_offset;
>> +
>> +       region->start = res->start - offset;
>> +       region->end = res->end - offset;
>> +}
>> +EXPORT_SYMBOL(pcibios_resource_to_bus);
>> +
>> +void __devinit
>> +pcibios_bus_to_resource(struct pci_dev *dev, struct resource *res,
>> +                       struct pci_bus_region *region)
>> +{
>> +       struct pci_controller *controller =
>> +               (struct pci_controller *)dev->sysdata;
>> +       unsigned long offset = 0;
>> +
>> +       if (res->flags & IORESOURCE_MEM)
>> +               offset = controller->mem_offset;
>> +
>> +       res->start = region->start + offset;
>> +       res->end = region->end + offset;
>> +}
>> +EXPORT_SYMBOL(pcibios_bus_to_resource);
>> +
>> +/*
>>   * We don't need to worry about the alignment of resources.
>>   */
>>  resource_size_t pcibios_align_resource(void *data, const struct resource *res,
>> @@ -274,6 +308,10 @@
>>
>>         cpumask_copy(&intr_cpus_map, cpu_online_mask);
>>
>> +#ifdef CONFIG_DATAPLANE
>> +       /* Remove dataplane cpus. */
>> +       cpumask_andnot(&intr_cpus_map, &intr_cpus_map, &dataplane_map);
>> +#endif
>>
>>         for (i = 0; i < 4; i++) {
>>                 gxio_trio_context_t *context = controller->trio;
>> @@ -325,7 +363,7 @@
>>   *
>>   * Returns the number of controllers discovered.
>>   */
>> -int __init tile_pci_init(void)
>> +int __devinit tile_pci_init(void)
>>  {
>>         int num_trio_shims = 0;
>>         int ctl_index = 0;
>> @@ -359,6 +397,7 @@
>>          * We look at the Board Information Block first and then see if there
>>          * are any overriding configuration by the HW strapping pin.
>>          */
>> +#if !defined(GX_FPGA)
>>         for (i = 0; i < TILEGX_NUM_TRIO; i++) {
>>                 gxio_trio_context_t *context = &trio_contexts[i];
>>                 int ret;
>> @@ -386,6 +425,13 @@
>>                         }
>>                 }
>>         }
>> +#else
>> +       /*
>> +        * For now, just assume that there is a single RC port on trio/0.
>> +        */
>> +       num_rc_controllers = 1;
>> +       pcie_rc[0][2] = 1;
>> +#endif
>>
>>         /*
>>          * Return if no PCIe ports are configured to operate in RC mode.
>> @@ -424,13 +470,20 @@
>>                 controller->index = i;
>>                 controller->ops = &tile_cfg_ops;
>>
>> +               controller->io_space.start = 0;
>> +               controller->io_space.end = IO_SPACE_LIMIT;
>> +               controller->io_space.flags = IORESOURCE_IO;
>> +               snprintf(controller->io_space_name,
>> +                        sizeof(controller->io_space_name),
>> +                        "PCI I/O domain %d", i);
>> +               controller->io_space.name = controller->io_space_name;
>> +
>>                 /*
>>                  * The PCI memory resource is located above the PA space.
>>                  * For every host bridge, the BAR window or the MMIO aperture
>>                  * is in range [3GB, 4GB - 1] of a 4GB space beyond the
>>                  * PA space.
>>                  */
>> -
>>                 controller->mem_offset = TILE_PCI_MEM_START +
>>                         (i * TILE_PCI_BAR_WINDOW_TOP);
>>                 controller->mem_space.start = controller->mem_offset +
>> @@ -451,7 +504,7 @@
>>   * (pin - 1) converts from the PCI standard's [1:4] convention to
>>   * a normal [0:3] range.
>>   */
>> -static int tile_map_irq(const struct pci_dev *dev, u8 device, u8 pin)
>> +static int tile_map_irq(struct pci_dev *dev, u8 device, u8 pin)
>>  {
>>         struct pci_controller *controller =
>>                 (struct pci_controller *)dev->sysdata;
>> @@ -463,11 +516,12 @@
>>                                                 controller)
>>  {
>>         gxio_trio_context_t *trio_context = controller->trio;
>> -       struct pci_bus *root_bus = controller->root_bus;
>>         TRIO_PCIE_RC_DEVICE_CONTROL_t dev_control;
>>         TRIO_PCIE_RC_DEVICE_CAP_t rc_dev_cap;
>> +       unsigned int smallest_max_payload;
>> +       struct pci_dev *dev = NULL;
>>         unsigned int reg_offset;
>> -       struct pci_bus *child;
>> +       u16 new_values;
>>         int mac;
>>         int err;
>>
>> @@ -508,33 +562,59 @@
>>         __gxio_mmio_write32(trio_context->mmio_base_mac + reg_offset,
>>                                                 rc_dev_cap.word);
>>
>> -       /* Configure PCI Express MPS setting. */
>> -       list_for_each_entry(child, &root_bus->children, node) {
>> -               struct pci_dev *self = child->self;
>> -               if (!self)
>> +       smallest_max_payload = rc_dev_cap.mps_sup;
>> +
>> +       /* Scan for the smallest maximum payload size. */
>> +       while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
>> +               int pcie_caps_offset;
>> +               u32 devcap;
>> +               int max_payload;
>> +
>> +               /* Skip device that is not in this PCIe domain. */
>> +               if ((struct pci_controller *)dev->sysdata != controller)
>>                         continue;
>>
>> -               pcie_bus_configure_settings(child, self->pcie_mpss);
>> +               pcie_caps_offset = pci_find_capability(dev, PCI_CAP_ID_EXP);
>> +               if (pcie_caps_offset == 0)
>> +                       continue;
>> +
>> +               pci_read_config_dword(dev, pcie_caps_offset + PCI_EXP_DEVCAP,
>> +                                     &devcap);
>> +               max_payload = devcap & PCI_EXP_DEVCAP_PAYLOAD;
>> +               if (max_payload < smallest_max_payload)
>> +                       smallest_max_payload = max_payload;
>> +       }
>> +
>> +       /* Now, set the max_payload_size for all devices to that value. */
>> +       new_values = smallest_max_payload << 5;
>> +       while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
>> +               int pcie_caps_offset;
>> +               u16 devctl;
>> +
>> +               /* Skip device that is not in this PCIe domain. */
>> +               if ((struct pci_controller *)dev->sysdata != controller)
>> +                       continue;
>> +
>> +               pcie_caps_offset = pci_find_capability(dev, PCI_CAP_ID_EXP);
>> +               if (pcie_caps_offset == 0)
>> +                       continue;
>> +
>> +               pci_read_config_word(dev, pcie_caps_offset + PCI_EXP_DEVCTL,
>> +                                    &devctl);
>> +               devctl &= ~PCI_EXP_DEVCTL_PAYLOAD;
>> +               devctl |= new_values;
>> +               pci_write_config_word(dev, pcie_caps_offset + PCI_EXP_DEVCTL,
>> +                                     devctl);
>>         }
>>
>>         /*
>>          * Set the mac_config register in trio based on the MPS/MRS of the link.
>>          */
>> -       reg_offset =
>> -               (TRIO_PCIE_RC_DEVICE_CONTROL <<
>> -                       TRIO_CFG_REGION_ADDR__REG_SHIFT) |
>> -               (TRIO_CFG_REGION_ADDR__INTFC_VAL_MAC_STANDARD <<
>> -                       TRIO_CFG_REGION_ADDR__INTFC_SHIFT ) |
>> -               (mac << TRIO_CFG_REGION_ADDR__MAC_SEL_SHIFT);
>> -
>> -       dev_control.word = __gxio_mmio_read32(trio_context->mmio_base_mac +
>> -                                               reg_offset);
>> -
>>         err = gxio_trio_set_mps_mrs(trio_context,
>> -                                   dev_control.max_payload_size,
>> +                                   smallest_max_payload,
>>                                     dev_control.max_read_req_sz,
>>                                     mac);
>> -        if (err < 0) {
>> +       if (err < 0) {
>>                 pr_err("PCI: PCIE_CONFIGURE_MAC_MPS_MRS failure, "
>>                         "MAC %d on TRIO %d\n",
>>                         mac, controller->trio_index);
>> @@ -571,14 +651,9 @@
>>                 if (!isdigit(*str))
>>                         return -EINVAL;
>>                 delay = simple_strtoul(str, (char **)&str, 10);
>> -               if (delay > MAX_RC_DELAY)
>> -                       return -EINVAL;
>>         }
>>
>>         rc_delay[trio_index][mac] = delay ? : DEFAULT_RC_DELAY;
>> -       pr_info("Delaying PCIe RC link training for %u sec"
>> -               " on MAC %lu on TRIO %lu\n", rc_delay[trio_index][mac],
>> -               mac, trio_index);
>>         return 0;
>>  }
>>  early_param("pcie_rc_delay", setup_pcie_rc_delay);
>> @@ -586,18 +661,14 @@
>>  /*
>>   * PCI initialization entry point, called by subsys_initcall.
>>   */
>> -int __init pcibios_init(void)
>> +int __devinit pcibios_init(void)
>>  {
>>         resource_size_t offset;
>> -       LIST_HEAD(resources);
>>         int next_busno;
>>         int i;
>>
>>         tile_pci_init();
>>
>> -       if (num_rc_controllers == 0 && num_ep_controllers == 0)
>> -               return 0;
>> -
>>         /*
>>          * We loop over all the TRIO shims and set up the MMIO mappings.
>>          */
>> @@ -623,6 +694,9 @@
>>                 }
>>         }
>>
>> +       if (num_rc_controllers == 0 && num_ep_controllers == 0)
>> +               return 0;
>> +
>>         /*
>>          * Delay a bit in case devices aren't ready.  Some devices are
>>          * known to require at least 20ms here, but we use a more
>> @@ -684,15 +758,36 @@
>>                 }
>>
>>                 /*
>> -                * Delay the RC link training if needed.
>> +                * Delay the bus probe if needed.
>>                  */
>> -               if (rc_delay[trio_index][mac])
>> +               if (rc_delay[trio_index][mac]) {
>> +                       pr_info("Delaying PCIe RC link training for %d sec"
>> +                               " on MAC %d on TRIO %d\n",
>> +                               rc_delay[trio_index][mac], mac,
>> +                               trio_index);
>>                         msleep(rc_delay[trio_index][mac] * 1000);
>> +               }
>>
>> -               ret = gxio_trio_force_rc_link_up(trio_context, mac);
>> -               if (ret < 0)
>> -                       pr_err("PCI: PCIE_FORCE_LINK_UP failure, "
>> -                               "MAC %d on TRIO %d\n", mac, trio_index);
>> +               /*
>> +                * Check for PCIe link-up status to decide if we need
>> +                * to force the link to come up.
>> +                */
>> +               reg_offset =
>> +                       (TRIO_PCIE_INTFC_PORT_STATUS <<
>> +                               TRIO_CFG_REGION_ADDR__REG_SHIFT) |
>> +                       (TRIO_CFG_REGION_ADDR__INTFC_VAL_MAC_INTERFACE <<
>> +                               TRIO_CFG_REGION_ADDR__INTFC_SHIFT ) |
>> +                       (mac << TRIO_CFG_REGION_ADDR__MAC_SEL_SHIFT);
>> +
>> +               port_status.word =
>> +                       __gxio_mmio_read(trio_context->mmio_base_mac +
>> +                                        reg_offset);
>> +               if (!port_status.dl_up) {
>> +                       ret = gxio_trio_force_rc_link_up(trio_context, mac);
>> +                       if (ret < 0)
>> +                               pr_err("PCI: PCIE_FORCE_LINK_UP failure, "
>> +                                       "MAC %d on TRIO %d\n", mac, trio_index);
>> +               }
>>
>>                 pr_info("PCI: Found PCI controller #%d on TRIO %d MAC %d\n", i,
>>                         trio_index, controller->mac);
>> @@ -704,22 +799,20 @@
>>                 msleep(1000);
>>
>>                 /*
>> -                * Check for PCIe link-up status.
>> +                * Check for PCIe link-up status again.
>>                  */
>> -
>> -               reg_offset =
>> -                       (TRIO_PCIE_INTFC_PORT_STATUS <<
>> -                               TRIO_CFG_REGION_ADDR__REG_SHIFT) |
>> -                       (TRIO_CFG_REGION_ADDR__INTFC_VAL_MAC_INTERFACE <<
>> -                               TRIO_CFG_REGION_ADDR__INTFC_SHIFT ) |
>> -                       (mac << TRIO_CFG_REGION_ADDR__MAC_SEL_SHIFT);
>> -
>>                 port_status.word =
>>                         __gxio_mmio_read(trio_context->mmio_base_mac +
>>                                          reg_offset);
>>                 if (!port_status.dl_up) {
>> -                       pr_err("PCI: link is down, MAC %d on TRIO %d\n",
>> -                               mac, trio_index);
>> +                       if (pcie_ports[trio_index][mac].removable) {
>> +                               pr_info("PCI: link is down, MAC %d on TRIO %d",
>> +                                       mac, trio_index);
>> +                               pr_info("This is expected if no PCIe card"
>> +                                       " is connected to this link");
>> +                       } else
>> +                               pr_err("PCI: link is down, MAC %d on TRIO %d",
>> +                                       mac, trio_index);
>>                         continue;
>>                 }
>>
>> @@ -842,19 +935,22 @@
>>                 }
>>
>>                 /*
>> -                * The PCI memory resource is located above the PA space.
>> -                * The memory range for the PCI root bus should not overlap
>> -                * with the physical RAM
>> +                * This comes from the generic Linux PCI driver.
>> +                *
>> +                * It reads the PCI tree for this bus into the Linux
>> +                * data structures.
>> +                *
>> +                * This is inlined in linux/pci.h and calls into
>> +                * pci_scan_bus_parented() in probe.c.
>>                  */
>> -               pci_add_resource_offset(&resources, &controller->mem_space,
>> -                                       controller->mem_offset);
>> -
>> -               controller->first_busno = next_busno;
>> -               bus = pci_scan_root_bus(NULL, next_busno, controller->ops,
>> -                                       controller, &resources);
>> +               controller->first_busno= next_busno;
>> +               bus = pci_scan_bus(next_busno, controller->ops, controller);
>>                 controller->root_bus = bus;
>> -               next_busno = bus->busn_res.end + 1;
>> -
>> +#if 0
>> +               next_busno = bus->subordinate + 1;
>> +#else
>> +               next_busno = 0;
>> +#endif
>>         }
>>
>>         /* Do machine dependent PCI interrupt routing */
>> @@ -951,6 +1047,37 @@
>>                 }
>>
>>                 /*
>> +                * Alloc a PIO region for PCI I/O space access for each RC port.
>> +                */
>> +               ret = gxio_trio_alloc_pio_regions(trio_context, 1, 0, 0);
>> +               if (ret < 0) {
>> +                       pr_err("PCI: I/O PIO alloc failure on TRIO %d mac %d, "
>> +                               "give up\n", controller->trio_index,
>> +                               controller->mac);
>> +
>> +                       continue;
>> +               }
>> +
>> +               controller->pio_io_index = ret;
>> +
>> +               /*
>> +                * For PIO IO, the bus_address_hi parameter is hard-coded 0
>> +                * because PCI I/O address space is 32-bit.
>> +                */
>> +               ret = gxio_trio_init_pio_region_aux(trio_context,
>> +                                                   controller->pio_io_index,
>> +                                                   controller->mac,
>> +                                                   0,
>> +                                                   HV_TRIO_PIO_FLAG_IO_SPACE);
>> +               if (ret < 0) {
>> +                       pr_err("PCI: I/O PIO init failure on TRIO %d mac %d, "
>> +                               "give up\n", controller->trio_index,
>> +                               controller->mac);
>> +
>> +                       continue;
>> +               }
>> +
>> +               /*
>>                  * Configure a Mem-Map region for each memory controller so
>>                  * that Linux can map all of its PA space to the PCI bus.
>>                  * Use the IOMMU to handle hash-for-home memory.
>> @@ -1015,9 +1142,22 @@
>>  }
>>  subsys_initcall(pcibios_init);
>>
>> -/* Note: to be deleted after Linux 3.6 merge. */
>> +/*
>> + * PCI scan code calls the arch specific pcibios_fixup_bus() each time it scans
>> + * a new bridge. Called after each bus is probed, but before its children are
>> + * examined.
>> + */
>>  void __devinit pcibios_fixup_bus(struct pci_bus *bus)
>>  {
>> +       struct pci_dev *dev = bus->self;
>> +
>> +       if (!dev) {
>> +               struct pci_controller *controller = bus->sysdata;
>> +
>> +               /* This is the root bus. */
>> +               bus->resource[0] = &controller->io_space;
>> +               bus->resource[1] = &controller->mem_space;
>> +       }
>>  }
>>
>>  /*
>> @@ -1043,8 +1183,7 @@
>>
>>  /*
>>   * Enable memory address decoding, as appropriate, for the
>> - * device described by the 'dev' struct. The I/O decoding
>> - * is disabled, though the TILE-Gx supports I/O addressing.
>> + * device described by the 'dev' struct.
>>   *
>>   * This is called from the generic PCI layer, and can be called
>>   * for bridges or endpoints.
>> @@ -1126,10 +1265,95 @@
>>          * We need to keep the PCI bus address's in-page offset in the VA.
>>          */
>>         return iorpc_ioremap(trio_fd, offset, size) +
>> -               (phys_addr & (PAGE_SIZE - 1));
>> +               (start & (PAGE_SIZE - 1));
>>  }
>>  EXPORT_SYMBOL(ioremap);
>>
>> +/* Map a PCI I/O address into VA space. */
>> +void __iomem *ioport_map(unsigned long port, unsigned int size)
>> +{
>> +       struct pci_controller *controller = NULL;
>> +       resource_size_t bar_start;
>> +       resource_size_t bar_end;
>> +       resource_size_t offset;
>> +       resource_size_t start;
>> +       resource_size_t end;
>> +       int trio_fd;
>> +       int i;
>> +
>> +       start = port;
>> +       end = port + size - 1;
>> +
>> +       /*
>> +        * In the following, each PCI controller's mem_resources[0]
>> +        * represents its PCI I/O resource. By searching port in each
>> +        * controller's mem_resources[0], we can determine the controller
>> +        * that should accept the PCI I/O access.
>> +        */
>> +
>> +       for (i = 0; i < num_rc_controllers; i++) {
>> +               /*
>> +                * Skip controllers that are not properly initialized or
>> +                * have down links.
>> +                */
>> +               if (pci_controllers[i].root_bus == NULL)
>> +                       continue;
>> +
>> +               bar_start = pci_controllers[i].mem_resources[0].start;
>> +               bar_end = pci_controllers[i].mem_resources[0].end;
>> +
>> +               if ((start >= bar_start) && (end <= bar_end)) {
>> +
>> +                       controller = &pci_controllers[i];
>> +
>> +                       goto got_it;
>> +               }
>> +       }
>> +
>> +       if (controller == NULL)
>> +               return NULL;
>> +
>> +got_it:
>> +       trio_fd = controller->trio->fd;
>> +
>> +       offset = HV_TRIO_PIO_OFFSET(controller->pio_io_index) + port;
>> +
>> +       /*
>> +        * We need to keep the PCI bus address's in-page offset in the VA.
>> +        */
>> +       return iorpc_ioremap(trio_fd, offset, size) + (port & (PAGE_SIZE - 1));
>> +}
>> +EXPORT_SYMBOL(ioport_map);
>> +
>> +void ioport_unmap(void __iomem *addr)
>> +{
>> +       iounmap(addr);
>> +}
>> +EXPORT_SYMBOL(ioport_unmap);
>> +
>> +/*
>> + * Create a virtual mapping cookie for a PCI BAR (memory or IO).
>> + */
>> +void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max)
>> +{
>> +       resource_size_t start = pci_resource_start(dev, bar);
>> +       resource_size_t len = pci_resource_len(dev, bar);
>> +       unsigned long flags = pci_resource_flags(dev, bar);
>> +
>> +       if (!len)
>> +               return NULL;
>> +       if (max && len > max)
>> +               len = max;
>> +       if (flags & IORESOURCE_IO)
>> +               return ioport_map(start, len);
>> +       if (flags & IORESOURCE_MEM)
>> +               return ioremap(start, len);
>> +
>> +       pr_err("PCI: Trying to map invalid resource %#lx\n", flags);
>> +       return NULL;
>> +}
>> +EXPORT_SYMBOL(pci_iomap);
>> +
>>  void pci_iounmap(struct pci_dev *dev, void __iomem *addr)
>>  {
>>         iounmap(addr);
>> @@ -1478,32 +1702,55 @@
>>         trio_context = controller->trio;
>>
>>         /*
>> -        * Allocate the Mem-Map that will accept the MSI write and
>> -        * trigger the TILE-side interrupts.
>> -        */
>> -       mem_map = gxio_trio_alloc_memory_maps(trio_context, 1, 0, 0);
>> -       if (mem_map < 0) {
>> -               dev_printk(KERN_INFO, &pdev->dev,
>> -                       "%s Mem-Map alloc failure. "
>> -                       "Failed to initialize MSI interrupts. "
>> -                       "Falling back to legacy interrupts.\n",
>> -                       desc->msi_attrib.is_msix ? "MSI-X" : "MSI");
>> +        * Allocate a scatter-queue that will accept the MSI write and
>> +        * trigger the TILE-side interrupts. We use the scatter-queue regions
>> +        * before the mem map regions, because the latter are needed by more
>> +        * applications.
>> +        */
>> +       mem_map = gxio_trio_alloc_scatter_queues(trio_context, 1, 0, 0);
>> +       if (mem_map >= 0) {
>> +               TRIO_MAP_SQ_DOORBELL_FMT_t doorbell_template = {{
>> +                       .pop = 0,
>> +                       .doorbell = 1,
>> +               }};
>> +
>> +               mem_map += TRIO_NUM_MAP_MEM_REGIONS;
>> +               mem_map_base = MEM_MAP_INTR_REGIONS_BASE +
>> +                       mem_map * MEM_MAP_INTR_REGION_SIZE;
>> +               mem_map_limit = mem_map_base + MEM_MAP_INTR_REGION_SIZE - 1;
>> +
>> +               msi_addr = mem_map_base + MEM_MAP_INTR_REGION_SIZE - 8;
>> +               msg.data = (unsigned int)doorbell_template.word;
>> +       } else {
>> +               /* SQ regions are out, allocate from map mem regions. */
>> +               mem_map = gxio_trio_alloc_memory_maps(trio_context, 1, 0, 0);
>> +               if (mem_map < 0) {
>> +                       dev_printk(KERN_INFO, &pdev->dev,
>> +                               "%s Mem-Map alloc failure. "
>> +                               "Failed to initialize MSI interrupts. "
>> +                               "Falling back to legacy interrupts.\n",
>> +                               desc->msi_attrib.is_msix ? "MSI-X" : "MSI");
>> +                       ret = -ENOMEM;
>> +                       goto msi_mem_map_alloc_failure;
>> +               }
>>
>> -               ret = -ENOMEM;
>> -               goto msi_mem_map_alloc_failure;
>> +               mem_map_base = MEM_MAP_INTR_REGIONS_BASE +
>> +                       mem_map * MEM_MAP_INTR_REGION_SIZE;
>> +               mem_map_limit = mem_map_base + MEM_MAP_INTR_REGION_SIZE - 1;
>> +
>> +               msi_addr = mem_map_base + TRIO_MAP_MEM_REG_INT3 -
>> +                       TRIO_MAP_MEM_REG_INT0;
>> +
>> +               msg.data = mem_map;
>>         }
>>
>>         /* We try to distribute different IRQs to different tiles. */
>>         cpu = tile_irq_cpu(irq);
>>
>>         /*
>> -        * Now call up to the HV to configure the Mem-Map interrupt and
>> +        * Now call up to the HV to configure the MSI interrupt and
>>          * set up the IPI binding.
>>          */
>> -       mem_map_base = MEM_MAP_INTR_REGIONS_BASE +
>> -               mem_map * MEM_MAP_INTR_REGION_SIZE;
>> -       mem_map_limit = mem_map_base + MEM_MAP_INTR_REGION_SIZE - 1;
>> -
>>         ret = gxio_trio_config_msi_intr(trio_context, cpu_x(cpu), cpu_y(cpu),
>>                                         KERNEL_PL, irq, controller->mac,
>>                                         mem_map, mem_map_base, mem_map_limit,
>> @@ -1516,13 +1763,9 @@
>>
>>         irq_set_msi_desc(irq, desc);
>>
>> -       msi_addr = mem_map_base + TRIO_MAP_MEM_REG_INT3 - TRIO_MAP_MEM_REG_INT0;
>> -
>>         msg.address_hi = msi_addr >> 32;
>>         msg.address_lo = msi_addr & 0xffffffff;
>>
>> -       msg.data = mem_map;
>> -
>>         write_msi_msg(irq, &msg);
>>         irq_set_chip_and_handler(irq, &tilegx_msi_chip, handle_level_irq);
>>         irq_set_handler_data(irq, controller);
>>
>>
>> What we got after my fix:
>>
>> pci 0000:00:00.0: BAR 8: assigned [mem 0x100c0000000-0x100c00fffff]
>> pci 0000:00:00.0: BAR 9: assigned [mem 0x100c0100000-0x100c01fffff pref]
>> pci 0000:00:00.0: BAR 7: assigned [io  0x1000-0x1fff]
>> pci 0000:01:00.0: BAR 6: assigned [mem 0x100c0100000-0x100c013ffff pref]
>> pci 0000:01:00.0: BAR 6: set to [mem 0x100c0100000-0x100c013ffff pref]
>> (PCI address [0xc0100000-0xc013ffff])
>> pci 0000:01:00.0: BAR 4: assigned [mem 0x100c0000000-0x100c000ffff
>> 64bit]
>> pci 0000:01:00.0: BAR 4: set to [mem 0x100c0000000-0x100c000ffff
>> 64bit] (PCI address [0xc0000000-0xc000ffff])
>> pci 0000:01:00.0: BAR 2: assigned [io  0x1000-0x107f]
>> pci 0000:01:00.0: BAR 2: set to [io  0x1000-0x107f] (PCI address
>> [0x1000-0x107f])
>> pci 0000:00:00.0: PCI bridge to [bus 01-01]
>> pci 0000:00:00.0:   bridge window [io  0x1000-0x1fff]
>> pci 0000:00:00.0:   bridge window [mem 0x100c0000000-0x100c00fffff]
>> pci 0000:00:00.0:   bridge window [mem 0x100c0100000-0x100c01fffff
>> pref]
>> pci 0001:00:00.0: BAR 8: assigned [mem 0x101c0000000-0x101c00fffff]
>> pci 0001:00:00.0: BAR 9: assigned [mem 0x101c0100000-0x101c01fffff
>> pref]
>> pci 0001:00:00.0: BAR 7: assigned [io  0x80001000-0x80001fff]
>> pci 0001:01:00.0: BAR 6: assigned [mem 0x101c0100000-0x101c013ffff
>> pref]
>> pci 0001:01:00.0: BAR 6: set to [mem 0x101c0100000-0x101c013ffff pref]
>> (PCI address [0xc0100000-0xc013ffff])
>> pci 0001:01:00.0: BAR 4: assigned [mem 0x101c0000000-0x101c000ffff
>> 64bit]
>> pci 0001:01:00.0: BAR 4: set to [mem 0x101c0000000-0x101c000ffff
>> 64bit] (PCI address [0xc0000000-0xc000ffff])
>> pci 0001:01:00.0: BAR 2: assigned [io  0x80001000-0x8000107f]
>> pci 0001:01:00.0: BAR 2: set to [io  0x80001000-0x8000107f] (PCI
>> address [0x80001000-0x8000107f])
>> pci 0001:00:00.0: PCI bridge to [bus 01-01]
>> pci 0001:00:00.0:   bridge window [io  0x80001000-0x80001fff]
>> pci 0001:00:00.0:   bridge window [mem 0x101c0000000-0x101c00fffff]
>> pci 0001:00:00.0:   bridge window [mem 0x101c0100000-0x101c01fffff
>> pref]
>> pci 0000:00:00.0: enabling device (0006 -> 0007)
>> pci 0001:00:00.0: enabling device (0006 -> 0007)
>> pci_bus 0000:00: resource 0 [io  0x1000-0x800007ff]
>> pci_bus 0000:00: resource 1 [mem 0x100c0000000-0x100ffffffff]
>> pci_bus 0000:01: resource 0 [io  0x1000-0x1fff]
>> pci_bus 0000:01: resource 1 [mem 0x100c0000000-0x100c00fffff]
>> pci_bus 0000:01: resource 2 [mem 0x100c0100000-0x100c01fffff pref]
>> pci_bus 0001:00: resource 0 [io  0x80000800-0xffffffff]
>> pci_bus 0001:00: resource 1 [mem 0x101c0000000-0x101ffffffff]
>> pci_bus 0001:01: resource 0 [io  0x80001000-0x80001fff]
>> pci_bus 0001:01: resource 1 [mem 0x101c0000000-0x101c00fffff]
>> pci_bus 0001:01: resource 2 [mem 0x101c0100000-0x101c01fffff pref]
>> ......
>> mvsas 0000:01:00.0: mvsas: driver version 0.8.2
>> mvsas 0000:01:00.0: enabling device (0000 -> 0003)
>> mvsas 0000:01:00.0: enabling bus mastering
>> mvsas 0000:01:00.0: mvsas: PCI-E x4, Bandwidth Usage: 2.5 Gbps
>> scsi0 : mvsas
>> ......
>> mvsas 0001:01:00.0: mvsas: driver version 0.8.2
>> mvsas 0001:01:00.0: enabling device (0000 -> 0003)
>> mvsas 0001:01:00.0: enabling bus mastering
>> mvsas 0001:01:00.0: mvsas: PCI-E x4, Bandwidth Usage: 2.5 Gbps
>> scsi1 : mvsas
>>
>>
>> It works now. But I really need some one to confirm whether my
>> modification is enough or not,
>> if there have other potential problems.
>>
>>
>>
>> Best regards.
>>
>> --
>> Cyberman Wu
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Cyberman Wu
