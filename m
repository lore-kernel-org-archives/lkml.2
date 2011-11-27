Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343Ab1K0K4u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 05:56:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753001Ab1K0K4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 05:56:48 -0500
Date: Sun, 27 Nov 2011 12:56:43 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Liu Ping Fan <kernelfans@gmail.com>
Cc: kvm@vger.kernel.org, qemu-devel@nongnu.org, aliguori@us.ibm.com,
        ryanh@us.ibm.com, jan.kiszka@web.de, linux-kernel@vger.kernel.org,
        avi@redhat.com
Subject: Re: [Qemu-devel] [PATCH 3/5] QEMU Introduce a pci device "cpustate"
 to get CPU_DEAD event in guest
Message-ID: <20111127105643.GM2557@redhat.com>
References: <1322188529-11609-1-git-send-email-kernelfans@gmail.com>
 <1322361937-22438-3-git-send-email-kernelfans@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322361937-22438-3-git-send-email-kernelfans@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 27, 2011 at 10:45:35AM +0800, Liu Ping Fan wrote:
> From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
> 
> This device's driver in guest can get vcpu dead event and notify
> qemu through the device.
> 
This should be done through ACPI device. Look at how PCI hotplug works
in hw/acpi_piix4.c.

> Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
> ---
>  Makefile.target   |    1 +
>  hw/pc_piix.c      |    1 +
>  hw/pci.c          |   22 +++++++++++
>  hw/pci.h          |    1 +
>  hw/pci_cpustate.c |  105 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 130 insertions(+), 0 deletions(-)
>  create mode 100644 hw/pci_cpustate.c
> 
> diff --git a/Makefile.target b/Makefile.target
> index 5607c6d..c822f9f 100644
> --- a/Makefile.target
> +++ b/Makefile.target
> @@ -242,6 +242,7 @@ obj-i386-$(CONFIG_SPICE) += qxl.o qxl-logger.o qxl-render.o
>  obj-i386-y += testdev.o
>  obj-i386-y += acpi.o acpi_piix4.o
>  obj-i386-y += icc_bus.o
> +obj-i386-y += pci_cpustate.o
>  
>  obj-i386-y += pcspk.o i8254.o
>  obj-i386-$(CONFIG_KVM_PIT) += i8254-kvm.o
> diff --git a/hw/pc_piix.c b/hw/pc_piix.c
> index 7c6f42d..090d7ba 100644
> --- a/hw/pc_piix.c
> +++ b/hw/pc_piix.c
> @@ -199,6 +199,7 @@ static void pc_init1(MemoryRegion *system_memory,
>              pci_nic_init_nofail(nd, "rtl8139", NULL);
>      }
>  
> +    pc_cpustate_init(NULL);
>      ide_drive_get(hd, MAX_IDE_BUS);
>      if (pci_enabled) {
>          PCIDevice *dev;
> diff --git a/hw/pci.c b/hw/pci.c
> index 5c87a62..74a8975 100644
> --- a/hw/pci.c
> +++ b/hw/pci.c
> @@ -1663,6 +1663,28 @@ PCIDevice *pci_nic_init(NICInfo *nd, const char *default_model,
>      return pci_dev;
>  }
>  
> +PCIDevice *pc_cpustate_init(const char *default_devaddr)
> +{
> +    const char *devaddr = default_devaddr;
> +    PCIBus *bus;
> +    int devfn;
> +    PCIDevice *pci_dev;
> +    DeviceState *dev;
> +    bus = pci_get_bus_devfn(&devfn, devaddr);
> +    if (!bus) {
> +        error_report("Invalid PCI device address %s for device %s",
> +                     devaddr, "pcimmstub");
> +        return NULL;
> +    }
> +
> +    pci_dev = pci_create(bus, devfn, "cpustate");
> +    dev = &pci_dev->qdev;
> +    if (qdev_init(dev) < 0) {
> +        return NULL;
> +    }
> +    return pci_dev;
> +}
> +
>  PCIDevice *pci_nic_init_nofail(NICInfo *nd, const char *default_model,
>                                 const char *default_devaddr)
>  {
> diff --git a/hw/pci.h b/hw/pci.h
> index 071a044..bbaa013 100644
> --- a/hw/pci.h
> +++ b/hw/pci.h
> @@ -279,6 +279,7 @@ PCIDevice *pci_nic_init(NICInfo *nd, const char *default_model,
>                          const char *default_devaddr);
>  PCIDevice *pci_nic_init_nofail(NICInfo *nd, const char *default_model,
>                                 const char *default_devaddr);
> +PCIDevice *pc_cpustate_init(const char *default_devaddr);
>  int pci_bus_num(PCIBus *s);
>  void pci_for_each_device(PCIBus *bus, int bus_num, void (*fn)(PCIBus *bus, PCIDevice *d));
>  PCIBus *pci_find_root_bus(int domain);
> diff --git a/hw/pci_cpustate.c b/hw/pci_cpustate.c
> new file mode 100644
> index 0000000..fd31a1f
> --- /dev/null
> +++ b/hw/pci_cpustate.c
> @@ -0,0 +1,105 @@
> +/* pci_cpustate.c
> + * emulate a pci device to get guest os CPU_DEAD event
> + *
> + * Copyright IBM, Corp. 2011
> + *
> + * This library is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU Lesser General Public
> + * License as published by the Free Software Foundation; either
> + * version 2 of the License, or (at your option) any later version.
> + *
> + * This library is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * Lesser General Public License for more details.
> + *
> + * You should have received a copy of the GNU Lesser General Public
> + * License along with this library; if not, see <http://www.gnu.org/licenses/>
> + */
> +#include <zlib.h>
> +#include "hw.h"
> +#include "pci.h"
> +#include "qemu-timer.h"
> +#include "net.h"
> +#include "loader.h"
> +#include "sysemu.h"
> +#include "iov.h"
> +
> +#define PCI_DEVICE_ID_CPUSTATE  0x1010
> +#define CPUSTATE_REGS_SIZE  0x1000
> +
> +typedef struct VcpuState VcpuState;
> +
> +struct VcpuState {
> +    PCIDevice dev;
> +    MemoryRegion mmio;
> +    int mmio_io_addr;
> +    int mmio_index;
> +    uint32_t cpuid;
> +    uint32_t cpu_state;
> +};
> +
> +static const VMStateDescription vmstate_cpustate = {
> +    .name = "cpustate",
> +    .version_id = 1,
> +    .minimum_version_id = 0,
> +    .fields      = (VMStateField[]) {
> +        VMSTATE_END_OF_LIST()
> +    },
> +};
> +
> +static void
> +cpustate_mmio_write(void *opaque, target_phys_addr_t addr, uint64_t val,
> +                 unsigned size)
> +{
> +}
> +
> +static uint64_t
> +cpustate_mmio_read(void *opaque, target_phys_addr_t addr, unsigned size)
> +{
> +    return 0;
> +}
> +
> +static const MemoryRegionOps cpustate_ops = {
> +    .read = cpustate_mmio_read,
> +    .write = cpustate_mmio_write,
> +    .endianness = DEVICE_LITTLE_ENDIAN,
> +};
> +
> +static int pci_cpustate_init(PCIDevice *dev)
> +{
> +    uint8_t *pci_cfg = dev->config;
> +    VcpuState *s = DO_UPCAST(VcpuState, dev, dev);
> +    memory_region_init_io(&s->mmio, &cpustate_ops, s, "cpustate",
> +                        CPUSTATE_REGS_SIZE);
> +    pci_cfg[PCI_INTERRUPT_PIN] = 1;
> +    /* I/O handler for memory-mapped I/O */
> +    pci_register_bar(&s->dev, 0, PCI_BASE_ADDRESS_SPACE_MEMORY,  &s->mmio);
> +    return 0;
> +}
> +
> +static int pci_cpustate_exit(PCIDevice *dev)
> +{
> +    return 0;
> +}
> +
> +static PCIDeviceInfo cpustate_info = {
> +    .qdev.name  = "cpustate",
> +    .qdev.size  = sizeof(VcpuState),
> +    .qdev.vmsd  = &vmstate_cpustate,
> +    .init       = pci_cpustate_init,
> +    .exit       = pci_cpustate_exit,
> +    .vendor_id  = PCI_VENDOR_ID_IBM,
> +    .device_id  = PCI_DEVICE_ID_CPUSTATE,
> +    .revision   = 0x10,
> +    .class_id   = PCI_CLASS_SYSTEM_OTHER,
> +    .qdev.props = (Property[]) {
> +        DEFINE_PROP_END_OF_LIST(),
> +    }
> +};
> +
> +static void cpustate_register_devices(void)
> +{
> +    pci_qdev_register(&cpustate_info);
> +}
> +device_init(cpustate_register_devices)
> -- 
> 1.7.4.4
> 

--
			Gleb.
