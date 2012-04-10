Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239Ab2DJAC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 20:02:27 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:63800 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab2DJACY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 20:02:24 -0400
MIME-Version: 1.0
In-Reply-To: <201204072319.q37NJlNp019384@farm-0023.internal.tilera.com>
References: <201204072316.q37NGv8d019280@farm-0023.internal.tilera.com> <201204072319.q37NJlNp019384@farm-0023.internal.tilera.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 9 Apr 2012 18:01:59 -0600
Message-ID: <CAErSpo6_gV1XKJ1jsDSvHo+BEORL_5wLC2YRyVG+OjVNDYbHgw@mail.gmail.com>
Subject: Re: [PATCH 3/3] arch/tile: tilegx PCI root complex support
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Myron Stowe <myron.stowe@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Jiri Kosina <jkosina@suse.cz>, Joe Perches <joe@perches.com>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 7, 2012 at 3:10 PM, Chris Metcalf <cmetcalf@tilera.com> wrote:
> This change implements PCIe root complex support for tilegx using
> the kernel support layer for accessing the TRIO hardware shim.

> +static void __devinit fixup_read_and_payload_sizes(struct pci_controller *
> +                                               controller)
> +{
> +       gxio_trio_context_t *trio_context = controller->trio;
> +       TRIO_PCIE_RC_DEVICE_CONTROL_t dev_control;
> +       TRIO_PCIE_RC_DEVICE_CAP_t rc_dev_cap;
> +       unsigned int smallest_max_payload;
> +       struct pci_dev *dev = NULL;
> +       unsigned int reg_offset;
> +       u16 new_values;
> +       int mac;
> +       int err;
> +
> +       mac = controller->mac;
> +
> +       /*
> +        * Set our max read request size to be 4KB.
> +        */
> +       reg_offset =
> +               (TRIO_PCIE_RC_DEVICE_CONTROL <<
> +                       TRIO_CFG_REGION_ADDR__REG_SHIFT) |
> +               (TRIO_CFG_REGION_ADDR__INTFC_VAL_MAC_STANDARD <<
> +                       TRIO_CFG_REGION_ADDR__INTFC_SHIFT ) |
> +               (mac << TRIO_CFG_REGION_ADDR__MAC_SEL_SHIFT);
> +
> +       dev_control.word = __gxio_mmio_read32(trio_context->mmio_base_mac +
> +                                               reg_offset);
> +       dev_control.max_read_req_sz = 5;
> +       __gxio_mmio_write32(trio_context->mmio_base_mac + reg_offset,
> +                                               dev_control.word);
> +
> +       /*
> +        * Set the max payload size supported by this Gx PCIe MAC.
> +        * Though Gx PCIe supports Max Payload Size of up to 1024 bytes,
> +        * experiments have shown that setting MPS to 256 yields the
> +        * best performance.
> +        */
> +       reg_offset =
> +               (TRIO_PCIE_RC_DEVICE_CAP <<
> +                       TRIO_CFG_REGION_ADDR__REG_SHIFT) |
> +               (TRIO_CFG_REGION_ADDR__INTFC_VAL_MAC_STANDARD <<
> +                       TRIO_CFG_REGION_ADDR__INTFC_SHIFT ) |
> +               (mac << TRIO_CFG_REGION_ADDR__MAC_SEL_SHIFT);
> +
> +       rc_dev_cap.word = __gxio_mmio_read32(trio_context->mmio_base_mac +
> +                                               reg_offset);
> +       rc_dev_cap.mps_sup = 1;
> +       __gxio_mmio_write32(trio_context->mmio_base_mac + reg_offset,
> +                                               rc_dev_cap.word);
> +
> +       smallest_max_payload = rc_dev_cap.mps_sup;
> +
> +       /* Scan for the smallest maximum payload size. */
> +       while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {

Can this be done with the generic pcie_bus_configure_settings() or is
there something tilegx-specific about this?

> +               int pcie_caps_offset;
> +               u32 devcap;
> +               int max_payload;
> +
> +               /* Skip device that is not in this PCIe domain. */
> +               if ((struct pci_controller *)dev->sysdata != controller)
> +                       continue;
> +
> +               pcie_caps_offset = pci_find_capability(dev, PCI_CAP_ID_EXP);
> +               if (pcie_caps_offset == 0)
> +                       continue;
> +
> +               pci_read_config_dword(dev, pcie_caps_offset + PCI_EXP_DEVCAP,
> +                                     &devcap);
> +               max_payload = devcap & PCI_EXP_DEVCAP_PAYLOAD;
> +               if (max_payload < smallest_max_payload)
> +                       smallest_max_payload = max_payload;
> +       }
> +
> +       /* Now, set the max_payload_size for all devices to that value. */
> +       new_values = smallest_max_payload << 5;
> +       while ((dev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, dev)) != NULL) {
> +               int pcie_caps_offset;
> +               u16 devctl;
> +
> +               /* Skip device that is not in this PCIe domain. */
> +               if ((struct pci_controller *)dev->sysdata != controller)
> +                       continue;
> +
> +               pcie_caps_offset = pci_find_capability(dev, PCI_CAP_ID_EXP);
> +               if (pcie_caps_offset == 0)
> +                       continue;
> +
> +               pci_read_config_word(dev, pcie_caps_offset + PCI_EXP_DEVCTL,
> +                                    &devctl);
> +               devctl &= ~PCI_EXP_DEVCTL_PAYLOAD;
> +               devctl |= new_values;
> +               pci_write_config_word(dev, pcie_caps_offset + PCI_EXP_DEVCTL,
> +                                     devctl);
> +       }
> +
> +       /*
> +        * Set the mac_config register in trio based on the MPS/MRS of the link.
> +        */
> +        err = gxio_trio_set_mps_mrs(trio_context,
> +                        smallest_max_payload,
> +                        dev_control.max_read_req_sz,
> +                        mac);
> +        if (err < 0) {
> +               pr_err("PCI: PCIE_CONFIGURE_MAC_MPS_MRS failure, "
> +                       "MAC %d on TRIO %d\n",
> +                       mac, controller->trio_index);
> +       }
> +}
> +
> +
> +/*
> + * Second PCI initialization entry point, called by subsys_initcall.
> + *
> + * The controllers have been set up by the time we get here, by a call to
> + * tile_pci_init.
> + */
> +int __devinit pcibios_init(void)
> +{
> +       resource_size_t offset;
> +       int i;
> +
> +        if (num_rc_controllers == 0 && num_ep_controllers == 0)
> +               return 0;
> +
> +       pr_info("PCI: Probing PCI hardware\n");
> +
> +       /*
> +        * We loop over all the TRIO shims and set up the MMIO mappings.
> +        * This step can't be done in tile_pci_init because the MM subsystem
> +        * hasn't been initialized then.
> +        */
> +       for (i = 0; i < TILEGX_NUM_TRIO; i++) {
> +               gxio_trio_context_t *context = &trio_contexts[i];
> +
> +               if (context->fd < 0)
> +                       continue;
> +
> +               /*
> +                * Map in the MMIO space for the MAC.
> +                 */
> +               offset = 0;
> +               context->mmio_base_mac =
> +                       iorpc_ioremap(context->fd, offset,
> +                                     HV_TRIO_CONFIG_IOREMAP_SIZE);
> +               if (context->mmio_base_mac == NULL) {
> +                       pr_err("PCI: MAC map failure on TRIO %d\n", i);
> +
> +                       hv_dev_close(context->fd);
> +                       context->fd = -1;
> +                       continue;
> +               }
> +       }
> +
> +       /*
> +        * Delay a bit in case devices aren't ready.  Some devices are
> +        * known to require at least 20ms here, but we use a more
> +        * conservative value.
> +        */
> +       mdelay(250);
> +
> +       /* Scan all of the recorded PCI controllers.  */
> +       for (i = 0; i < num_rc_controllers; i++) {
> +               struct pci_controller *controller = &pci_controllers[i];
> +               gxio_trio_context_t *trio_context = controller->trio;
> +               TRIO_PCIE_INTFC_PORT_CONFIG_t port_config;
> +               TRIO_PCIE_INTFC_PORT_STATUS_t port_status;
> +               TRIO_PCIE_INTFC_TX_FIFO_CTL_t tx_fifo_ctl;
> +               struct pci_bus *bus;
> +               unsigned int reg_offset;
> +               unsigned int class_code_revision;
> +               int mac;
> +#ifndef USE_SHARED_PCIE_CONFIG_REGION
> +               int ret;
> +#endif
> +
> +               if (trio_context->fd < 0)
> +                       continue;
> +
> +               mac = controller->mac;
> +
> +               /*
> +                * Check the port strap state which will override the BIB
> +                * setting.
> +                */
> +
> +               reg_offset =
> +                       (TRIO_PCIE_INTFC_PORT_CONFIG <<
> +                               TRIO_CFG_REGION_ADDR__REG_SHIFT) |
> +                       (TRIO_CFG_REGION_ADDR__INTFC_VAL_MAC_INTERFACE <<
> +                               TRIO_CFG_REGION_ADDR__INTFC_SHIFT ) |
> +                       (mac << TRIO_CFG_REGION_ADDR__MAC_SEL_SHIFT);
> +
> +               port_config.word =
> +                       __gxio_mmio_read(trio_context->mmio_base_mac +
> +                                        reg_offset);
> +
> +               if ((port_config.strap_state !=
> +                       TRIO_PCIE_INTFC_PORT_CONFIG__STRAP_STATE_VAL_AUTO_CONFIG_RC) &&
> +                       (port_config.strap_state !=
> +                       TRIO_PCIE_INTFC_PORT_CONFIG__STRAP_STATE_VAL_AUTO_CONFIG_RC_G1)) {
> +                       /*
> +                        * If this is really intended to be an EP port,
> +                        * record it so that the endpoint driver will know about it.
> +                        */
> +                       if (port_config.strap_state ==
> +                       TRIO_PCIE_INTFC_PORT_CONFIG__STRAP_STATE_VAL_AUTO_CONFIG_ENDPOINT ||
> +                       port_config.strap_state ==
> +                       TRIO_PCIE_INTFC_PORT_CONFIG__STRAP_STATE_VAL_AUTO_CONFIG_ENDPOINT_G1)
> +                               pcie_ports[controller->trio_index][mac].allow_ep = 1;
> +
> +                       continue;
> +               }
> +
> +               ret = gxio_trio_force_link_up(trio_context, mac);
> +               if (ret < 0)
> +                       pr_err("PCI: PCIE_FORCE_LINK_UP failure, "
> +                               "MAC %d on TRIO %d\n",
> +                               mac, controller->trio_index);
> +
> +               pr_info("PCI: Found PCI controller #%d on TRIO %d MAC %d\n", i,
> +                       controller->trio_index, controller->mac);
> +
> +               /*
> +                * Wait a bit here because some EP devices take longer to come up.
> +                */
> +               mdelay(1000);
> +
> +               /*
> +                * Check for PCIe link-up status.
> +                */
> +
> +               reg_offset =
> +                       (TRIO_PCIE_INTFC_PORT_STATUS <<
> +                               TRIO_CFG_REGION_ADDR__REG_SHIFT) |
> +                       (TRIO_CFG_REGION_ADDR__INTFC_VAL_MAC_INTERFACE <<
> +                               TRIO_CFG_REGION_ADDR__INTFC_SHIFT ) |
> +                       (mac << TRIO_CFG_REGION_ADDR__MAC_SEL_SHIFT);
> +
> +               port_status.word =
> +                       __gxio_mmio_read(trio_context->mmio_base_mac +
> +                                        reg_offset);
> +               if (!port_status.dl_up) {
> +                       pr_err("PCI: link is down, MAC %d on TRIO %d\n",
> +                               mac, controller->trio_index);
> +                       continue;
> +               }
> +
> +               /*
> +                * Ensure that the link can come out of L1 power down state.
> +                * Strictly speaking, this is needed only in the case of
> +                * heavy RC-initiated DMAs.
> +                */
> +               reg_offset =
> +                       (TRIO_PCIE_INTFC_TX_FIFO_CTL <<
> +                               TRIO_CFG_REGION_ADDR__REG_SHIFT) |
> +                       (TRIO_CFG_REGION_ADDR__INTFC_VAL_MAC_INTERFACE <<
> +                               TRIO_CFG_REGION_ADDR__INTFC_SHIFT ) |
> +                       (mac << TRIO_CFG_REGION_ADDR__MAC_SEL_SHIFT);
> +               tx_fifo_ctl.word =
> +                       __gxio_mmio_read(trio_context->mmio_base_mac +
> +                                        reg_offset);
> +               tx_fifo_ctl.min_p_credits = 0;
> +               __gxio_mmio_write(trio_context->mmio_base_mac + reg_offset,
> +                                 tx_fifo_ctl.word);
> +
> +               /*
> +                * Change the device ID so that Linux bus crawl doesn't confuse
> +                * the internal bridge with any Tilera endpoints.
> +                */
> +
> +               reg_offset =
> +                       (TRIO_PCIE_RC_DEVICE_ID_VEN_ID <<
> +                               TRIO_CFG_REGION_ADDR__REG_SHIFT) |
> +                       (TRIO_CFG_REGION_ADDR__INTFC_VAL_MAC_STANDARD <<
> +                               TRIO_CFG_REGION_ADDR__INTFC_SHIFT ) |
> +                       (mac << TRIO_CFG_REGION_ADDR__MAC_SEL_SHIFT);
> +
> +               __gxio_mmio_write32(trio_context->mmio_base_mac + reg_offset,
> +                                   (TILERA_GX36_RC_DEV_ID <<
> +                                   TRIO_PCIE_RC_DEVICE_ID_VEN_ID__DEV_ID_SHIFT) |
> +                                   TILERA_VENDOR_ID);
> +
> +               /*
> +                * Set the internal P2P bridge class code.
> +                */
> +
> +               reg_offset =
> +                       (TRIO_PCIE_RC_REVISION_ID <<
> +                               TRIO_CFG_REGION_ADDR__REG_SHIFT) |
> +                       (TRIO_CFG_REGION_ADDR__INTFC_VAL_MAC_STANDARD <<
> +                               TRIO_CFG_REGION_ADDR__INTFC_SHIFT ) |
> +                       (mac << TRIO_CFG_REGION_ADDR__MAC_SEL_SHIFT);
> +
> +               class_code_revision =
> +                       __gxio_mmio_read32(trio_context->mmio_base_mac +
> +                                          reg_offset);
> +               class_code_revision = (class_code_revision & 0xff ) |
> +                                       (PCI_CLASS_BRIDGE_PCI << 16);
> +
> +               __gxio_mmio_write32(trio_context->mmio_base_mac +
> +                                   reg_offset, class_code_revision);
> +
> +#ifdef USE_SHARED_PCIE_CONFIG_REGION
> +
> +               /*
> +                * Map in the MMIO space for the PIO region.
> +                 */
> +               offset = HV_TRIO_PIO_OFFSET(trio_context->pio_cfg_index) |
> +                       (((unsigned long long)mac) <<
> +                       TRIO_TILE_PIO_REGION_SETUP_CFG_ADDR__MAC_SHIFT);
> +
> +#else
> +
> +               /*
> +                * Alloc a PIO region for PCI config access per MAC.
> +                */
> +               ret = gxio_trio_alloc_pio_regions(trio_context, 1, 0, 0);
> +               if (ret < 0) {
> +                       pr_err("PCI: PCI CFG PIO alloc failure for mac %d "
> +                               "on TRIO %d, give up\n",
> +                               mac, controller->trio_index);
> +
> +                       /* TBD: cleanup ... */
> +
> +                       continue;
> +               }
> +
> +               trio_context->pio_cfg_index[mac] = ret;
> +
> +               /*
> +                * For PIO CFG, the bus_address_hi parameter is 0.
> +                */
> +               ret = gxio_trio_init_pio_region_aux(trio_context,
> +                       trio_context->pio_cfg_index[mac],
> +                       mac, 0, HV_TRIO_PIO_FLAG_CONFIG_SPACE);
> +               if (ret < 0) {
> +                       pr_err("PCI: PCI CFG PIO init failure for mac %d "
> +                               "on TRIO %d, give up\n",
> +                               mac, controller->trio_index);
> +
> +                       /* TBD: cleanup ... */
> +
> +                       continue;
> +               }
> +
> +               offset = HV_TRIO_PIO_OFFSET(trio_context->pio_cfg_index[mac]) |
> +                       (((unsigned long long)mac) <<
> +                       TRIO_TILE_PIO_REGION_SETUP_CFG_ADDR__MAC_SHIFT);
> +
> +#endif
> +
> +               trio_context->mmio_base_pio_cfg[mac] =
> +                       iorpc_ioremap(trio_context->fd, offset,
> +                       (1 << TRIO_TILE_PIO_REGION_SETUP_CFG_ADDR__MAC_SHIFT));
> +               if (trio_context->mmio_base_pio_cfg[mac] == NULL) {
> +                       pr_err("PCI: PIO map failure for mac %d on TRIO %d\n",
> +                               mac, controller->trio_index);
> +
> +                       /* TBD: cleanup ... */
> +
> +                       continue;
> +               }
> +
> +               /*
> +                * Initialize the PCIe interrupts.
> +                 */
> +               if (tile_init_irqs(controller)) {
> +                       pr_err("PCI: IRQs init failure for mac %d on TRIO %d\n",
> +                               mac, controller->trio_index);
> +
> +                       continue;
> +               }
> +
> +               /*
> +                * This comes from the generic Linux PCI driver.
> +                *
> +                * It reads the PCI tree for this bus into the Linux
> +                * data structures.
> +                *
> +                * This is inlined in linux/pci.h and calls into
> +                * pci_scan_bus_parented() in probe.c.
> +                */
> +               bus = pci_scan_bus(0, controller->ops, controller);

If at all possible, you should use pci_scan_root_bus() here instead,
so you can tell PCI what the host bridge apertures are.

You do fill in pci_controllers[].mem_resources[] below, which looks
like they might be apertures, but I don't see anywhere that the PCI
core would learn about those.

> +               controller->root_bus = bus;
> +               controller->last_busno = bus->subordinate;
> +
> +       }
> +
> +       /* Do machine dependent PCI interrupt routing */
> +       pci_fixup_irqs(pci_common_swizzle, tile_map_irq);
> +
> +       /*
> +        * This comes from the generic Linux PCI driver.
> +        *
> +        * It allocates all of the resources (I/O memory, etc)
> +        * associated with the devices read in above.
> +        */
> +
> +       pci_assign_unassigned_resources();
> +
> +       /* Record the I/O resources in the PCI controller structure. */
> +       for (i = 0; i < num_rc_controllers; i++) {
> +               struct pci_controller *controller = &pci_controllers[i];
> +               gxio_trio_context_t *trio_context = controller->trio;
> +               struct pci_bus *root_bus = pci_controllers[i].root_bus;
> +               struct pci_bus *next_bus;
> +               uint32_t bus_address_hi;
> +               struct pci_dev *dev;
> +               int ret;
> +               int j;
> +
> +               /*
> +                * Skip controllers that are not properly initialized or
> +                * have down links.
> +                */
> +               if (root_bus == NULL)
> +                       continue;
> +
> +               /* Configure the max_payload_size values for this domain. */
> +               fixup_read_and_payload_sizes(controller);
> +
> +               list_for_each_entry(dev, &root_bus->devices, bus_list) {
> +                       /* Find the PCI host controller, ie. the 1st bridge. */
> +                       if ((dev->class >> 8) == PCI_CLASS_BRIDGE_PCI &&
> +                               (PCI_SLOT(dev->devfn) == 0)) {
> +                               next_bus = dev->subordinate;
> +                               pci_controllers[i].mem_resources[0] =
> +                                       *next_bus->resource[0];
> +                               pci_controllers[i].mem_resources[1] =
> +                                        *next_bus->resource[1];
> +                               pci_controllers[i].mem_resources[2] =
> +                                        *next_bus->resource[2];
> +
> +                               break;
> +                       }
> +               }
> +
> +               if (pci_controllers[i].mem_resources[1].flags & IORESOURCE_MEM)
> +                       bus_address_hi =
> +                               pci_controllers[i].mem_resources[1].start >> 32;
> +               else if (pci_controllers[i].mem_resources[2].flags & IORESOURCE_PREFETCH)
> +                       bus_address_hi =
> +                               pci_controllers[i].mem_resources[2].start >> 32;
> +               else {
> +                       /* This is unlikely. */
> +                       pr_err("PCI: no memory resources on TRIO %d mac %d\n",
> +                               controller->trio_index, controller->mac);
> +                       continue;
> +               }
> +
> +               /*
> +                * We always assign 32-bit PCI bus BAR ranges.
> +                 */
> +               BUG_ON(bus_address_hi != 0);
> +
> +               /*
> +                * Alloc a PIO region for PCI memory access for each RC port.
> +                */
> +               ret = gxio_trio_alloc_pio_regions(trio_context, 1, 0, 0);
> +               if (ret < 0) {
> +                       pr_err("PCI: MEM PIO alloc failure on TRIO %d mac %d, "
> +                               "give up\n", controller->trio_index,
> +                               controller->mac);
> +
> +                       /* TBD: cleanup ... */
> +
> +                       continue;
> +               }
> +
> +               controller->pio_mem_index = ret;
> +
> +               /*
> +                * For PIO MEM, the bus_address_hi parameter is hard-coded 0
> +                * because we always assign 32-bit PCI bus BAR ranges.
> +                 */
> +               ret = gxio_trio_init_pio_region_aux(trio_context,
> +                                                   controller->pio_mem_index,
> +                                                   controller->mac,
> +                                                   bus_address_hi,
> +                                                   0);
> +               if (ret < 0) {
> +                       pr_err("PCI: MEM PIO init failure on TRIO %d mac %d, "
> +                               "give up\n", controller->trio_index,
> +                               controller->mac);
> +
> +                       /* TBD: cleanup ... */
> +
> +                       continue;
> +               }
> +
> +               /*
> +                * Configure a Mem-Map region for each memory controller so
> +                * that Linux can map all of its PA space to the PCI bus.
> +                * Use the IOMMU to handle hash-for-home memory.
> +                 */
> +               for_each_online_node(j) {
> +                       unsigned long start_pfn = node_start_pfn[j];
> +                       unsigned long end_pfn = node_end_pfn[j];
> +                       unsigned long nr_pages = end_pfn - start_pfn;
> +
> +                       ret = gxio_trio_alloc_memory_maps(trio_context, 1, 0,
> +                                                         0);
> +                       if (ret < 0) {
> +                               pr_err("PCI: Mem-Map alloc failure on TRIO %d "
> +                                       "mac %d for MC %d, give up\n",
> +                                       controller->trio_index,
> +                                       controller->mac, j);
> +
> +                               /* TBD: cleanup ... */
> +
> +                               goto alloc_mem_map_failed;
> +                       }
> +
> +                       controller->mem_maps[j] = ret;
> +
> +                       /*
> +                        * Initialize the Mem-Map and the I/O MMU so that all
> +                        * the physical memory can be accessed by the endpoint
> +                        * devices. The base bus address is set to the base CPA
> +                        * of this memory controller, so is the base VA. The
> +                        * I/O MMU table essentially translates the CPA to
> +                        * the real PA.
> +                         */
> +                       ret = gxio_trio_init_memory_map_mmu_aux(trio_context,
> +                               controller->mem_maps[j],
> +                               start_pfn << PAGE_SHIFT,
> +                               nr_pages << PAGE_SHIFT,
> +                               trio_context->asid,
> +                               controller->mac,
> +                               start_pfn << PAGE_SHIFT,
> +                               j,
> +                               GXIO_TRIO_ORDER_MODE_UNORDERED);
> +                       if (ret < 0) {
> +                               pr_err("PCI: Mem-Map init failure on TRIO %d "
> +                                       "mac %d for MC %d, give up\n",
> +                                       controller->trio_index,
> +                                       controller->mac, j);
> +
> +                               /* TBD: cleanup ... */
> +
> +                               goto alloc_mem_map_failed;
> +                       }
> +
> +                       continue;
> +
> +alloc_mem_map_failed:
> +                       break;
> +               }
> +
> +       }
> +
> +       return 0;
> +}
> +subsys_initcall(pcibios_init);

> +int pcibios_enable_device(struct pci_dev *dev, int mask)
> +{
> +       u16 cmd, old_cmd;
> +       u8 header_type;
> +       int i;
> +       struct resource *r;
> +
> +       pci_read_config_byte(dev, PCI_HEADER_TYPE, &header_type);
> +
> +       pci_read_config_word(dev, PCI_COMMAND, &cmd);
> +       old_cmd = cmd;
> +       if ((header_type & 0x7F) == PCI_HEADER_TYPE_BRIDGE) {
> +               /*
> +                * For bridges, we enable both memory and I/O decoding
> +                * in call cases.
> +                */
> +               cmd |= PCI_COMMAND_IO;
> +               cmd |= PCI_COMMAND_MEMORY;
> +       } else {
> +               /*
> +                * For endpoints, we enable memory and/or I/O decoding
> +                * only if they have a memory resource of that type.
> +                */
> +               for (i = 0; i < 6; i++) {
> +                       r = &dev->resource[i];
> +                       if (r->flags & IORESOURCE_UNSET) {
> +                               pr_err("PCI: Device %s not available "
> +                                      "because of resource collisions\n",
> +                                      pci_name(dev));
> +                               return -EINVAL;
> +                       }
> +                       if (r->flags & IORESOURCE_IO)
> +                               cmd |= PCI_COMMAND_IO;
> +                       if (r->flags & IORESOURCE_MEM)
> +                               cmd |= PCI_COMMAND_MEMORY;
> +               }

It would be nice if you could use pci_enable_resources() here, though
you use IORESOURCE_UNSET here, while pci_enable_resources() does not.
But you could at least use PCI_NUM_RESOURCES and "mask."  There's
nothing fundamentally architecture-dependent here, so I'd like to move
toward a generic implementation.

> +       }
> +
> +       /*
> +        * We only write the command if it changed.
> +        */
> +       if (cmd != old_cmd)
> +               pci_write_config_word(dev, PCI_COMMAND, cmd);
> +       return 0;
> +}

> +static int __devinit tile_cfg_read(struct pci_bus *bus,
> +                                  unsigned int devfn,
> +                                  int offset,
> +                                  int size,
> +                                  u32 *val)
> +{
> +       struct pci_controller *controller = bus->sysdata;
> +       gxio_trio_context_t *trio_context = controller->trio;
> +       int busnum = bus->number & 0xff;
> +       int device = (devfn >> 3) & 0x1f;
> +       int function = devfn & 0x7;

Could use PCI_SLOT() and PCI_FUNC() here and below.
