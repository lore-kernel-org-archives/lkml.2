Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932884Ab1JDQoT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 12:44:19 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:55540 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932785Ab1JDQoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 12:44:13 -0400
Message-ID: <4E8B3794.9040301@web.de>
Date: Tue, 04 Oct 2011 18:43:00 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: pingfank@linux.vnet.com
CC: linux-acpi@vger.kernel.org, qemu-devel@nongnu.org, aliguori@us.ibm.com,
        Liu Ping Fan <pingfank@linux.vnet.ibm.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, ryanh@us.ibm.com, shaohua.li@intel.com,
        lenb@kernel.org
Subject: Re: [PATCH 2/2] LAPIC: make lapic support cpu hotplug
References: <1317726818-8514-1-git-send-email-pingfank@linux.vnet.com> <1317726818-8514-4-git-send-email-pingfank@linux.vnet.com>
In-Reply-To: <1317726818-8514-4-git-send-email-pingfank@linux.vnet.com>
X-Enigmail-Version: 1.3.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD4462D7FDEC70A3873B57BE0"
X-Provags-ID: V01U2FsdGVkX1/RURTnH62kMRBJoRyUMlU1iyIHW5N4KDsMhIZQ
	F0NO1DtF7ClqLP7FxU5ewiU/RyvoOn+mHH8NBT95ObZceufLz9
	CtNN+MlIU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD4462D7FDEC70A3873B57BE0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 2011-10-04 13:13, pingfank@linux.vnet.com wrote:
> From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
>=20
> Separate apic from qbus to icc bus which supports hotplug feature.

Modeling the ICC bus looks like a step in the right direction. The
IOAPIC could be attached to it as well to get rid of "ioapics[MAX_IOAPICS=
]".

> And make the creation of apic as part of cpu initialization, so
> apic's state has been ready, before setting kvm_apic.

There is no kvm-apic upstream yet, so it's hard to judge why we need
this here. If we do, this has to be a separate patch. But I seriously
doubt we need it (my hack worked without it, and that was not because of
its hack nature).

>=20
> Signed-off-by: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
> ---
>  Makefile.target      |    1 +
>  hw/apic.c            |    7 ++++-
>  hw/apic.h            |    1 +
>  hw/icc_bus.c         |   62 ++++++++++++++++++++++++++++++++++++++++++=
++++++++
>  hw/icc_bus.h         |   24 +++++++++++++++++++
>  hw/pc.c              |   11 ++++-----
>  target-i386/cpu.h    |    1 +
>  target-i386/helper.c |    7 +++++-
>  target-i386/kvm.c    |    1 -
>  9 files changed, 105 insertions(+), 10 deletions(-)
>  create mode 100644 hw/icc_bus.c
>  create mode 100644 hw/icc_bus.h
>=20
> diff --git a/Makefile.target b/Makefile.target
> index 9011f28..5607c6d 100644
> --- a/Makefile.target
> +++ b/Makefile.target
> @@ -241,6 +241,7 @@ obj-i386-$(CONFIG_KVM) +=3D kvmclock.o
>  obj-i386-$(CONFIG_SPICE) +=3D qxl.o qxl-logger.o qxl-render.o
>  obj-i386-y +=3D testdev.o
>  obj-i386-y +=3D acpi.o acpi_piix4.o
> +obj-i386-y +=3D icc_bus.o
> =20
>  obj-i386-y +=3D pcspk.o i8254.o
>  obj-i386-$(CONFIG_KVM_PIT) +=3D i8254-kvm.o
> diff --git a/hw/apic.c b/hw/apic.c
> index 69d6ac5..95a1664 100644
> --- a/hw/apic.c
> +++ b/hw/apic.c
> @@ -24,6 +24,7 @@
>  #include "sysbus.h"
>  #include "trace.h"
>  #include "kvm.h"
> +#include "icc_bus.h"
> =20
>  /* APIC Local Vector Table */
>  #define APIC_LVT_TIMER   0
> @@ -304,11 +305,13 @@ void cpu_set_apic_base(DeviceState *d, uint64_t v=
al)
> =20
>      if (!s)
>          return;
> +
>      if (kvm_enabled() && kvm_irqchip_in_kernel())
>          s->apicbase =3D val;
>      else
>          s->apicbase =3D (val & 0xfffff000) |
>              (s->apicbase & (MSR_IA32_APICBASE_BSP | MSR_IA32_APICBASE_=
ENABLE));
> +
>      /* if disabled, cannot be enabled again */
>      if (!(val & MSR_IA32_APICBASE_ENABLE)) {
>          s->apicbase &=3D ~MSR_IA32_APICBASE_ENABLE;
> @@ -1075,7 +1078,7 @@ static const VMStateDescription vmstate_apic =3D =
{
>      }
>  };
> =20
> -static void apic_reset(DeviceState *d)
> +void apic_reset(DeviceState *d)

Still unused outside of this file, so keep it private.

>  {
>      APICState *s =3D DO_UPCAST(APICState, busdev.qdev, d);
>      int bsp;
> @@ -1138,7 +1141,7 @@ static SysBusDeviceInfo apic_info =3D {
> =20
>  static void apic_register_devices(void)
>  {
> -    sysbus_register_withprop(&apic_info);
> +    iccbus_register(&apic_info);
>  }
> =20
>  device_init(apic_register_devices)
> diff --git a/hw/apic.h b/hw/apic.h
> index c857d52..e258efa 100644
> --- a/hw/apic.h
> +++ b/hw/apic.h
> @@ -24,5 +24,6 @@ void apic_sipi(DeviceState *s);
>  /* pc.c */
>  int cpu_is_bsp(CPUState *env);
>  DeviceState *cpu_get_current_apic(void);
> +void apic_reset(DeviceState *d);
> =20
>  #endif
> diff --git a/hw/icc_bus.c b/hw/icc_bus.c
> new file mode 100644
> index 0000000..360ca2a
> --- /dev/null
> +++ b/hw/icc_bus.c
> @@ -0,0 +1,62 @@
> +/*
> +*/
> +#define ICC_BUS_PLUG
> +#ifdef ICC_BUS_PLUG
> +#include "icc_bus.h"
> +
> +
> +
> +struct icc_bus_info icc_info =3D {
> +    .qinfo.name =3D "icc",
> +    .qinfo.size =3D sizeof(struct icc_bus),
> +    .qinfo.props =3D (Property[]) {
> +        DEFINE_PROP_END_OF_LIST(),
> +    }
> +
> +};
> +
> +
> +static const VMStateDescription vmstate_icc_bus =3D {
> +    .name =3D "icc_bus",
> +    .version_id =3D 1,
> +    .minimum_version_id =3D 1,
> +    .minimum_version_id_old =3D 1,
> +    .pre_save =3D NULL,
> +    .post_load =3D NULL,
> +};
> +
> +struct icc_bus *g_iccbus;
> +
> +struct icc_bus *icc_init_bus(DeviceState *parent, const char *name)
> +{
> +    struct icc_bus *bus;
> +
> +    bus =3D FROM_QBUS(icc_bus, qbus_create(&icc_info.qinfo, parent, na=
me));
> +    bus->qbus.allow_hotplug =3D 1; /* Yes, we can */
> +    bus->qbus.name =3D "icc";
> +    vmstate_register(NULL, -1, &vmstate_icc_bus, bus);

The chipset is the owner of this bus and instantiates it. So it also
provides a vmstate. You can drop this unneeded one here (it's created
via an obsolete API anyway).

> +    g_iccbus =3D bus;
> +    return bus;
> +}
> +
> +
> +
> +
> +
> +static int iccbus_device_init(DeviceState *dev, DeviceInfo *base)
> +{
> +    SysBusDeviceInfo *info =3D container_of(base, SysBusDeviceInfo, qd=
ev);
> +
> +    return info->init(sysbus_from_qdev(dev));
> +}
> +
> +void iccbus_register(SysBusDeviceInfo *info)
> +{
> +    info->qdev.init =3D iccbus_device_init;
> +    info->qdev.bus_info =3D &icc_info.qinfo;
> +
> +    assert(info->qdev.size >=3D sizeof(SysBusDevice));
> +    qdev_register(&info->qdev);
> +}

This service should be unneeded when the bus is properly embedded into
its parent (ie. the chipset).

> +
> +#endif
> diff --git a/hw/icc_bus.h b/hw/icc_bus.h
> new file mode 100644
> index 0000000..94d9242
> --- /dev/null
> +++ b/hw/icc_bus.h
> @@ -0,0 +1,24 @@
> +#ifndef QEMU_ICC_H
> +#define QEMU_ICC_H
> +
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
> +extern struct icc_bus *icc_init_bus(DeviceState *parent, const char *n=
ame);
> +extern void iccbus_register(SysBusDeviceInfo *info);
> +
> +#endif
> diff --git a/hw/pc.c b/hw/pc.c
> index 6b3662e..10371d8 100644
> --- a/hw/pc.c
> +++ b/hw/pc.c
> @@ -24,6 +24,7 @@
>  #include "hw.h"
>  #include "pc.h"
>  #include "apic.h"
> +#include "icc_bus.h"
>  #include "fdc.h"
>  #include "ide.h"
>  #include "pci.h"
> @@ -91,6 +92,7 @@ struct e820_table {
>  static struct e820_table e820_table;
>  struct hpet_fw_config hpet_cfg =3D {.count =3D UINT8_MAX};
> =20
> +
>  void isa_irq_handler(void *opaque, int n, int level)
>  {
>      IsaIrqState *isa =3D (IsaIrqState *)opaque;
> @@ -872,13 +874,13 @@ DeviceState *cpu_get_current_apic(void)
>      }
>  }
> =20
> -static DeviceState *apic_init(void *env, uint8_t apic_id)
> +DeviceState *apic_init(void *env, uint8_t apic_id)
>  {
>      DeviceState *dev;
>      SysBusDevice *d;
>      static int apic_mapped;
> =20
> -    dev =3D qdev_create(NULL, "apic");
> +    dev =3D qdev_create(&g_iccbus->qbus, "apic");
>      qdev_prop_set_uint8(dev, "id", apic_id);
>      qdev_prop_set_ptr(dev, "cpu_env", env);
>      qdev_init_nofail(dev);
> @@ -943,10 +945,6 @@ CPUState *pc_new_cpu(const char *cpu_model)
>          fprintf(stderr, "Unable to find x86 CPU definition\n");
>          exit(1);
>      }
> -    if ((env->cpuid_features & CPUID_APIC) || smp_cpus > 1) {
> -        env->cpuid_apic_id =3D env->cpu_index;
> -        env->apic_state =3D apic_init(env, env->cpuid_apic_id);
> -    }
>      qemu_register_reset(pc_cpu_reset, env);
>      pc_cpu_reset(env);
>      return env;
> @@ -956,6 +954,7 @@ void pc_cpus_init(const char *cpu_model)
>  {
>      int i;
> =20
> +    icc_init_bus(NULL, "icc");
>      /* init CPUs */
>      for(i =3D 0; i < smp_cpus; i++) {
>          pc_new_cpu(cpu_model);
> diff --git a/target-i386/cpu.h b/target-i386/cpu.h
> index 2a071f2..0160c55 100644
> --- a/target-i386/cpu.h
> +++ b/target-i386/cpu.h
> @@ -1062,4 +1062,5 @@ void svm_check_intercept(CPUState *env1, uint32_t=
 type);
> =20
>  uint32_t cpu_cc_compute_all(CPUState *env1, int op);
> =20
> +extern DeviceState *apic_init(void *env, uint8_t apic_id);
>  #endif /* CPU_I386_H */
> diff --git a/target-i386/helper.c b/target-i386/helper.c
> index 5df40d4..551a8a2 100644
> --- a/target-i386/helper.c
> +++ b/target-i386/helper.c
> @@ -30,6 +30,7 @@
>  #include "monitor.h"
>  #endif
> =20
> +
>  //#define DEBUG_MMU
> =20
>  /* NOTE: must be called outside the CPU execute loop */
> @@ -1257,7 +1258,11 @@ CPUX86State *cpu_x86_init(const char *cpu_model)=

>          return NULL;
>      }
>      mce_init(env);
> -
> +    if ((env->cpuid_features & CPUID_APIC)
> +        || smp_cpus > 1) {
> +        env->cpuid_apic_id =3D env->cpu_index;
> +        env->apic_state =3D apic_init(env, env->cpuid_apic_id);
> +    }
>      qemu_init_vcpu(env);
> =20
>      return env;
> diff --git a/target-i386/kvm.c b/target-i386/kvm.c
> index 571d792..407dba6 100644
> --- a/target-i386/kvm.c
> +++ b/target-i386/kvm.c
> @@ -880,7 +880,6 @@ static int kvm_put_sregs(CPUState *env)
> =20
>      sregs.cr8 =3D cpu_get_apic_tpr(env->apic_state);
>      sregs.apic_base =3D cpu_get_apic_base(env->apic_state);
> -
>      sregs.efer =3D env->efer;
> =20
>      return kvm_vcpu_ioctl(env, KVM_SET_SREGS, &sregs);

Would be good to see the full series, i.e. everything that is required
to make CPU hotplug work. First for QEMU upstream without in-kernel
irqchips and then the qemu-kvm bits.

Jan


--------------enigD4462D7FDEC70A3873B57BE0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk6LN5QACgkQitSsb3rl5xTtpACg21NyAkpufYMHyfOSxqM1KNfa
6ZQAn3ueWWsq8qucpC+lXK7cNCgZkm6x
=eaSp
-----END PGP SIGNATURE-----

--------------enigD4462D7FDEC70A3873B57BE0--
