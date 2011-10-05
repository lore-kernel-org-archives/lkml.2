Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934409Ab1JELBT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 07:01:19 -0400
Received: from fmmailgate03.web.de ([217.72.192.234]:37206 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934176Ab1JELBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 07:01:17 -0400
Message-ID: <4E8C38F3.2070504@web.de>
Date: Wed, 05 Oct 2011 13:01:07 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: liu ping fan <qemulist@gmail.com>
CC: aliguori@us.ibm.com, pingfank@linux.vnet.ibm.com, kvm@vger.kernel.org,
        qemu-devel@nongnu.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, ryanh@us.ibm.com, shaohua.li@intel.com,
        lenb@kernel.org
Subject: Re: [Qemu-devel] [PATCH 2/2] LAPIC: make lapic support cpu hotplug
References: <1317726818-8514-1-git-send-email-pingfank@linux.vnet.com> <1317726818-8514-4-git-send-email-pingfank@linux.vnet.com> <4E8B3794.9040301@web.de> <CAJnKYQn69-CcUZRHFZgeB=PQj43kTQmSEpE=XTz3LHWNMQTKnQ@mail.gmail.com>
In-Reply-To: <CAJnKYQn69-CcUZRHFZgeB=PQj43kTQmSEpE=XTz3LHWNMQTKnQ@mail.gmail.com>
X-Enigmail-Version: 1.3.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8AFC5E63CEAB7427A4CD4432"
X-Provags-ID: V01U2FsdGVkX19485tir1NrnIfzBkfno9+eI1UOcBTRfGcpUzvO
	so9SfeGSRpm8T23NsfajVQzBRC2f7g4bJwQaViW213sP7TpYuC
	Rl/JofK4Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8AFC5E63CEAB7427A4CD4432
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 2011-10-05 12:26, liu ping fan wrote:
>>  > And make the creation of apic as part of cpu initialization, so
>>> apic's state has been ready, before setting kvm_apic.
>>
>> There is no kvm-apic upstream yet, so it's hard to judge why we need
>> this here. If we do, this has to be a separate patch. But I seriously
>> doubt we need it (my hack worked without it, and that was not because =
of
>> its hack nature).
>>
>> Sorry, I did not explain it clearly. What I mean is that =93env->apic_=
state=94
> must be prepared
> before qemu_kvm_cpu_thread_fn() -> ... -> kvm_put_sregs(), where we get=

> apic_base by
> =93 sregs.apic_base =3D cpu_get_apic_base(env->apic_state);=94
> and then call =93kvm_vcpu_ioctl(env, KVM_SET_SREGS, &sregs);=94 which w=
ill
> finally affect the
> kvm_apic structure in kernel.
>=20
> But as current code, in pc_new_cpu(), we call apic_init() to initialize=

> apic_state, after cpu_init(),
> so we can not guarantee the order of apic_state initializaion and the
> setting to kernel.
>=20
> Because LAPIC is part of x86 chip, I want to move it into cpu_x86_init(=
),
> and ensure apic_init()
> called before thread =93qemu_kvm_cpu_thread_fn()=94 creation.

The LAPIC is part of the CPU, the classic APIC was a dedicated chip.

For various reasons, a safer approach for creating a new CPU is to stop
the machine, add the new device models, run cpu_synchronize_post_init on
that new cpu (looks like you missed that) and then resume everything.
See
http://git.kiszka.org/?p=3Dqemu-kvm.git;a=3Dcommitdiff;h=3Dbe8f21c6b54eac=
82f7add7ee9d4ecf9cb8ebb320

=2E..
>>> diff --git a/hw/icc_bus.c b/hw/icc_bus.c
>>> new file mode 100644
>>> index 0000000..360ca2a
>>> --- /dev/null
>>> +++ b/hw/icc_bus.c
>>> @@ -0,0 +1,62 @@
>>> +/*
>>> +*/
>>> +#define ICC_BUS_PLUG
>>> +#ifdef ICC_BUS_PLUG
>>> +#include "icc_bus.h"
>>> +
>>> +
>>> +
>>> +struct icc_bus_info icc_info =3D {
>>> +    .qinfo.name =3D "icc",
>>> +    .qinfo.size =3D sizeof(struct icc_bus),
>>> +    .qinfo.props =3D (Property[]) {
>>> +        DEFINE_PROP_END_OF_LIST(),
>>> +    }
>>> +
>>> +};
>>> +
>>> +
>>> +static const VMStateDescription vmstate_icc_bus =3D {
>>> +    .name =3D "icc_bus",
>>> +    .version_id =3D 1,
>>> +    .minimum_version_id =3D 1,
>>> +    .minimum_version_id_old =3D 1,
>>> +    .pre_save =3D NULL,
>>> +    .post_load =3D NULL,
>>> +};
>>> +
>>> +struct icc_bus *g_iccbus;
>>> +
>>> +struct icc_bus *icc_init_bus(DeviceState *parent, const char *name)
>>> +{
>>> +    struct icc_bus *bus;
>>> +
>>> +    bus =3D FROM_QBUS(icc_bus, qbus_create(&icc_info.qinfo, parent,
>> name));
>>> +    bus->qbus.allow_hotplug =3D 1; /* Yes, we can */
>>> +    bus->qbus.name =3D "icc";
>>> +    vmstate_register(NULL, -1, &vmstate_icc_bus, bus);
>>
>> The chipset is the owner of this bus and instantiates it. So it also
>> provides a vmstate. You can drop this unneeded one here (it's created
>> via an obsolete API anyway).
>>
>=20
> No familiar with Qemu bus emulation, keep on learning :) . But what I
> thought is,
> the x86-ICC bus is not the same as bus like PCI.
> For a PCI bus, it lies behind a host bridge, but ICC is shared by all x=
86
> processors in SMP system,
> so there is not a outstanding owner.  And I right?

ICC is also attached to the chipset (due to the IOAPIC). So it looks
reasonable to me to let the chipset do the lifecycle management as well.
It is the fixed point, CPUs may come and go.

Jan


--------------enig8AFC5E63CEAB7427A4CD4432
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk6MOPoACgkQitSsb3rl5xQLMQCbBnXQVhfq2Hf69noAnTftG97N
ESIAoJ5b+K8CieLE6Jba5+C3JQrLYaGL
=4m0M
-----END PGP SIGNATURE-----

--------------enig8AFC5E63CEAB7427A4CD4432--
