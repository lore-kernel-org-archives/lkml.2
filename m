Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768Ab1JDM6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 08:58:37 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40370 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756235Ab1JDM6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 08:58:35 -0400
Message-ID: <4E8B02F7.6020000@codemonkey.ws>
Date: Tue, 04 Oct 2011 07:58:31 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Lightning/1.0b2 Thunderbird/3.1.13
MIME-Version: 1.0
To: pingfank@linux.vnet.com
CC: linux-acpi@vger.kernel.org, qemu-devel@nongnu.org, aliguori@us.ibm.com,
        Liu Ping Fan <pingfank@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, ryanh@us.ibm.com, shaohua.li@intel.com,
        lenb@kernel.org
Subject: Re: [Qemu-devel] [PATCH 2/2] LAPIC: make lapic support cpu hotplug
References: <1317726818-8514-1-git-send-email-pingfank@linux.vnet.com> <1317726818-8514-4-git-send-email-pingfank@linux.vnet.com>
In-Reply-To: <1317726818-8514-4-git-send-email-pingfank@linux.vnet.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2011 06:13 AM, pingfank@linux.vnet.com wrote:
> From: Liu Ping Fan<pingfank@linux.vnet.ibm.com>
>
> Separate apic from qbus to icc bus which supports hotplug feature.
> And make the creation of apic as part of cpu initialization, so
> apic's state has been ready, before setting kvm_apic.
>
> Signed-off-by: Liu Ping Fan<pingfank@linux.vnet.ibm.com>
> ---
>   Makefile.target      |    1 +
>   hw/apic.c            |    7 ++++-
>   hw/apic.h            |    1 +
>   hw/icc_bus.c         |   62 ++++++++++++++++++++++++++++++++++++++++++++++++++
>   hw/icc_bus.h         |   24 +++++++++++++++++++
>   hw/pc.c              |   11 ++++-----
>   target-i386/cpu.h    |    1 +
>   target-i386/helper.c |    7 +++++-
>   target-i386/kvm.c    |    1 -
>   9 files changed, 105 insertions(+), 10 deletions(-)
>   create mode 100644 hw/icc_bus.c
>   create mode 100644 hw/icc_bus.h
>
> diff --git a/Makefile.target b/Makefile.target
> index 9011f28..5607c6d 100644
> --- a/Makefile.target
> +++ b/Makefile.target
> @@ -241,6 +241,7 @@ obj-i386-$(CONFIG_KVM) += kvmclock.o
>   obj-i386-$(CONFIG_SPICE) += qxl.o qxl-logger.o qxl-render.o
>   obj-i386-y += testdev.o
>   obj-i386-y += acpi.o acpi_piix4.o
> +obj-i386-y += icc_bus.o
>
>   obj-i386-y += pcspk.o i8254.o
>   obj-i386-$(CONFIG_KVM_PIT) += i8254-kvm.o
> diff --git a/hw/apic.c b/hw/apic.c
> index 69d6ac5..95a1664 100644
> --- a/hw/apic.c
> +++ b/hw/apic.c
> @@ -24,6 +24,7 @@
>   #include "sysbus.h"
>   #include "trace.h"
>   #include "kvm.h"
> +#include "icc_bus.h"
>
>   /* APIC Local Vector Table */
>   #define APIC_LVT_TIMER   0
> @@ -304,11 +305,13 @@ void cpu_set_apic_base(DeviceState *d, uint64_t val)
>
>       if (!s)
>           return;
> +
>       if (kvm_enabled()&&  kvm_irqchip_in_kernel())
>           s->apicbase = val;
>       else
>           s->apicbase = (val&  0xfffff000) |
>               (s->apicbase&  (MSR_IA32_APICBASE_BSP | MSR_IA32_APICBASE_ENABLE));
> +
>       /* if disabled, cannot be enabled again */
>       if (!(val&  MSR_IA32_APICBASE_ENABLE)) {
>           s->apicbase&= ~MSR_IA32_APICBASE_ENABLE;
> @@ -1075,7 +1078,7 @@ static const VMStateDescription vmstate_apic = {
>       }
>   };

Please don't introduce extra whitespace in unrelated code.

>
> -static void apic_reset(DeviceState *d)
> +void apic_reset(DeviceState *d)
>   {
>       APICState *s = DO_UPCAST(APICState, busdev.qdev, d);
>       int bsp;
> @@ -1138,7 +1141,7 @@ static SysBusDeviceInfo apic_info = {
>
>   static void apic_register_devices(void)
>   {
> -    sysbus_register_withprop(&apic_info);
> +    iccbus_register(&apic_info);
>   }
>
>   device_init(apic_register_devices)
> diff --git a/hw/apic.h b/hw/apic.h
> index c857d52..e258efa 100644
> --- a/hw/apic.h
> +++ b/hw/apic.h
> @@ -24,5 +24,6 @@ void apic_sipi(DeviceState *s);
>   /* pc.c */
>   int cpu_is_bsp(CPUState *env);
>   DeviceState *cpu_get_current_apic(void);
> +void apic_reset(DeviceState *d);
>
>   #endif
> diff --git a/hw/icc_bus.c b/hw/icc_bus.c
> new file mode 100644
> index 0000000..360ca2a
> --- /dev/null
> +++ b/hw/icc_bus.c
> @@ -0,0 +1,62 @@
> +/*
> +*/

New files need to include copyright/licenses.

> +#define ICC_BUS_PLUG
> +#ifdef ICC_BUS_PLUG

Drop these guards here and at the end of the file.  We conditionally build files 
by having an:

obj-$(CONFIG_ICC_BUS) += icc_bus.o

In the Makefile.

> +#include "icc_bus.h"

> +
> +
> +
> +struct icc_bus_info icc_info = {
> +    .qinfo.name = "icc",
> +    .qinfo.size = sizeof(struct icc_bus),
> +    .qinfo.props = (Property[]) {
> +        DEFINE_PROP_END_OF_LIST(),
> +    }
> +
> +};

Structure name is not following Coding Style.

> +
> +static const VMStateDescription vmstate_icc_bus = {
> +    .name = "icc_bus",
> +    .version_id = 1,
> +    .minimum_version_id = 1,
> +    .minimum_version_id_old = 1,
> +    .pre_save = NULL,
> +    .post_load = NULL,
> +};
> +
> +struct icc_bus *g_iccbus;
> +
> +struct icc_bus *icc_init_bus(DeviceState *parent, const char *name)
> +{
> +    struct icc_bus *bus;
> +
> +    bus = FROM_QBUS(icc_bus, qbus_create(&icc_info.qinfo, parent, name));
> +    bus->qbus.allow_hotplug = 1; /* Yes, we can */
> +    bus->qbus.name = "icc";
> +    vmstate_register(NULL, -1,&vmstate_icc_bus, bus);
> +    g_iccbus = bus;
> +    return bus;
> +}
> +
> +
> +
> +
> +
> +static int iccbus_device_init(DeviceState *dev, DeviceInfo *base)
> +{
> +    SysBusDeviceInfo *info = container_of(base, SysBusDeviceInfo, qdev);
> +
> +    return info->init(sysbus_from_qdev(dev));
> +}
> +
> +void iccbus_register(SysBusDeviceInfo *info)
> +{
> +    info->qdev.init = iccbus_device_init;
> +    info->qdev.bus_info =&icc_info.qinfo;
> +
> +    assert(info->qdev.size>= sizeof(SysBusDevice));
> +    qdev_register(&info->qdev);
> +}
> +

It's not obvious to me why you need the g_iccbus variable.

> +#endif
> diff --git a/hw/icc_bus.h b/hw/icc_bus.h
> new file mode 100644
> index 0000000..94d9242
> --- /dev/null
> +++ b/hw/icc_bus.h
> @@ -0,0 +1,24 @@
> +#ifndef QEMU_ICC_H
> +#define QEMU_ICC_H


Needs copyright and a blurb explaining what this file is and what the ICC bus is.

Same comments re: whitespace below.

Regards,

Anthony Liguori

> +#include "qdev.h"
> +#include "sysbus.h"
> +
> +typedef struct icc_bus icc_bus;
> +typedef struct icc_bus_info icc_bus_info;
> +
> +
> +struct icc_bus {
> +    BusState qbus;
> +};
> +
> +struct icc_bus_info {
> +    BusInfo qinfo;
> +};
> +
> +extern struct icc_bus_info icc_info;
> +extern struct icc_bus *g_iccbus;
> +extern struct icc_bus *icc_init_bus(DeviceState *parent, const char *name);
> +extern void iccbus_register(SysBusDeviceInfo *info);

Functions don't need an 'extern' modifier.  I don't think icc_info needs to be 
exported either.

Instead of exporting g_iccbus, it would be better to have a get_icc_bus() method 
that returned the global iccbus.  That way we can more easily hook accesses to 
the bus.

> +#endif
> diff --git a/hw/pc.c b/hw/pc.c
> index 6b3662e..10371d8 100644
> --- a/hw/pc.c
> +++ b/hw/pc.c
> @@ -24,6 +24,7 @@
>   #include "hw.h"
>   #include "pc.h"
>   #include "apic.h"
> +#include "icc_bus.h"
>   #include "fdc.h"
>   #include "ide.h"
>   #include "pci.h"
> @@ -91,6 +92,7 @@ struct e820_table {
>   static struct e820_table e820_table;
>   struct hpet_fw_config hpet_cfg = {.count = UINT8_MAX};
>
> +
>   void isa_irq_handler(void *opaque, int n, int level)
>   {
>       IsaIrqState *isa = (IsaIrqState *)opaque;
> @@ -872,13 +874,13 @@ DeviceState *cpu_get_current_apic(void)
>       }
>   }
>
> -static DeviceState *apic_init(void *env, uint8_t apic_id)
> +DeviceState *apic_init(void *env, uint8_t apic_id)
>   {
>       DeviceState *dev;
>       SysBusDevice *d;
>       static int apic_mapped;
>
> -    dev = qdev_create(NULL, "apic");
> +    dev = qdev_create(&g_iccbus->qbus, "apic");
>       qdev_prop_set_uint8(dev, "id", apic_id);
>       qdev_prop_set_ptr(dev, "cpu_env", env);
>       qdev_init_nofail(dev);
> @@ -943,10 +945,6 @@ CPUState *pc_new_cpu(const char *cpu_model)
>           fprintf(stderr, "Unable to find x86 CPU definition\n");
>           exit(1);
>       }
> -    if ((env->cpuid_features&  CPUID_APIC) || smp_cpus>  1) {
> -        env->cpuid_apic_id = env->cpu_index;
> -        env->apic_state = apic_init(env, env->cpuid_apic_id);
> -    }
>       qemu_register_reset(pc_cpu_reset, env);
>       pc_cpu_reset(env);
>       return env;
> @@ -956,6 +954,7 @@ void pc_cpus_init(const char *cpu_model)
>   {
>       int i;
>
> +    icc_init_bus(NULL, "icc");
>       /* init CPUs */
>       for(i = 0; i<  smp_cpus; i++) {
>           pc_new_cpu(cpu_model);
> diff --git a/target-i386/cpu.h b/target-i386/cpu.h
> index 2a071f2..0160c55 100644
> --- a/target-i386/cpu.h
> +++ b/target-i386/cpu.h
> @@ -1062,4 +1062,5 @@ void svm_check_intercept(CPUState *env1, uint32_t type);
>
>   uint32_t cpu_cc_compute_all(CPUState *env1, int op);
>
> +extern DeviceState *apic_init(void *env, uint8_t apic_id);
>   #endif /* CPU_I386_H */
> diff --git a/target-i386/helper.c b/target-i386/helper.c
> index 5df40d4..551a8a2 100644
> --- a/target-i386/helper.c
> +++ b/target-i386/helper.c
> @@ -30,6 +30,7 @@
>   #include "monitor.h"
>   #endif
>
> +
>   //#define DEBUG_MMU
>
>   /* NOTE: must be called outside the CPU execute loop */
> @@ -1257,7 +1258,11 @@ CPUX86State *cpu_x86_init(const char *cpu_model)
>           return NULL;
>       }
>       mce_init(env);
> -
> +    if ((env->cpuid_features&  CPUID_APIC)
> +        || smp_cpus>  1) {
> +        env->cpuid_apic_id = env->cpu_index;
> +        env->apic_state = apic_init(env, env->cpuid_apic_id);
> +    }
>       qemu_init_vcpu(env);
>
>       return env;
> diff --git a/target-i386/kvm.c b/target-i386/kvm.c
> index 571d792..407dba6 100644
> --- a/target-i386/kvm.c
> +++ b/target-i386/kvm.c
> @@ -880,7 +880,6 @@ static int kvm_put_sregs(CPUState *env)
>
>       sregs.cr8 = cpu_get_apic_tpr(env->apic_state);
>       sregs.apic_base = cpu_get_apic_base(env->apic_state);
> -
>       sregs.efer = env->efer;
>
>       return kvm_vcpu_ioctl(env, KVM_SET_SREGS,&sregs);

