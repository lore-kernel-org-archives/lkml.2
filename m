Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab0LDLgt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 06:36:49 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:42378 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab0LDLgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 06:36:47 -0500
Message-ID: <4CFA2763.4060102@web.de>
Date: Sat, 04 Dec 2010 12:34:59 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 0/5] KVM&genirq: Enable adaptive IRQ sharing for passed-through
 devices
References: <cover.1291419444.git.jan.kiszka@web.de> <alpine.LFD.2.00.1012041052450.2653@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1012041052450.2653@localhost6.localdomain6>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF9362955BBB5DD368CF9AB95"
X-Provags-ID: V01U2FsdGVkX1/vFsi4jL24TEFkiLWMbDZYVzuL46iUIM1JdEKH
	uYcIEG3t9fBDou7cAo0AGl7MHT9z6WQ2y+wjh4ACcv9F/CZe6b
	KYiMw6s5E=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF9362955BBB5DD368CF9AB95
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 04.12.2010 11:37, Thomas Gleixner wrote:
> On Sat, 4 Dec 2010, Jan Kiszka wrote:
>=20
>> Besides 3 cleanup patches, this series consists of two major changes.
>> The first introduces an interrupt sharing notifier to the genirq
>> subsystem. It fires when an interrupt line is about to be use by more
>> than one driver or the last but one user called free_irq.
>>
>> The second major change makes use of this interface in KVM's PCI pass-=

>> through subsystem. KVM has to keep the interrupt source disabled while=

>> calling into the guest to handle the event. This can be done at device=

>> or line level. The former is required to share the interrupt line, the=

>> latter is an order of magnitude faster (see patch 3 for details).
>>
>> Beside pass-through support of KVM, further users of the IRQ notifier
>> could become VFIO (not yet mainline) and uio_pci_generic which have to=

>> resolve the same conflict.
>=20
> Hmm. You basically want to have the following functionality:
>=20
> If interrupt is shared, then you want to keep the current behaviour:
>=20
>    disable at line level (IRQF_ONESHOT)
>    run handler thread (PCI level masking)
>    reenable at line level in irq_finalize_oneshot()
>    reenable at PCI level when guest is done

If the interrupt is shared, we must mask at PCI level inside the primary
handler as we also have to support non-threaded users of the same line.
So we always have a transition line-level -> device-level
masking in a primary handler.

>=20
> If interrupt is not shared:
>=20
>    disable at line level (IRQF_ONESHOT)
>    run handler thread (no PCI level masking)
>    no reenable at line level
>    reenable at line level when guest is done

We only use threaded handlers so far for hairy lock-dependency reasons
and as certain injection complexity is too much guest-controllable. We
hope to move most injection cases (ie. any IRQ directed to a single VCPU
/ user space task) directly into a primary handler in the future to
reduce the latency. So both threaded and non-threaded cases should be
addressable by any approach.

>=20
> I think the whole notifier approach including the extra irq handlers
> plus the requirement to call disable_irq_nosync() from the non shared
> handler is overkill. We can be more clever.

Always welcome.

>=20
> The genirq code knows whether you have one or more handler
> registered. So we can add IRQF_ONESHOT_UNMASK_SHARED and add a status
> field to irq_data (which I was going to do anyway for other
> reasons). In that status field you get a bit which says IRQ_MASK_DEVICE=
=2E
>=20
> So with IRQF_ONESHOT_UNMASK_SHARED =3D=3D 0 we keep the current behavio=
ur.
>=20
> If IRQF_ONESHOT_UNMASK_SHARED=3D=3D 1 and IRQ_MASK_DEVICE =3D=3D 1 we k=
eep the
> current behaviour.
>=20
> If IRQF_ONESHOT_UNMASK_SHARED=3D=3D 1 and IRQ_MASK_DEVICE =3D=3D 0 then=
 then
> irq_finalize_oneshot() simply marks the interrupt disabled (equivalent
> to disable_irq_nosync()) and returns.

That sounds good.

>=20
> Now in your primary irq handler you simply check the IRQ_MASK_DEVICE
> status flag and decide whether you need to mask at PCI level or not.
>=20
> Your threaded handler gets the same information via IRQ_MASK_DEVICE so
> it can issue the appropriate user space notification depending on that
> flag.
>=20
> This works fully transparent across adding and removing handlers. On
> request_irq/free_irq we update the IRQ_MASK_DEVICE flag with the
> following logic:
>=20
>     nr_actions	IRQF_ONESHOT_UNMASK_SHARED	IRQ_MASK_DEVICE
>     1		0				1
>     1		1				0
>     >1		don't care			1
>=20
> If interrupts are in flight accross request/free then this change
> takes effect when the next interrupt comes in.

For registration, that might be too late. We need to synchronize on
in-flight interrupts for that line and then ensure that it gets enabled
independently of the registered user. That user may have applied
outdated information, thus would block the line for too long if user
space decides to do something else.

I think this will be the trickier part of the otherwise nice & simple
concept.

>=20
> No notifiers, no disable_irq_nosync() magic, less and simpler code.
>=20
> Thoughts ?

Pulling the effect of disable_irq_nosync into genirq also for threaded
handling would remove the need for re-registering handlers. That's good.
But we need to think about the hand-over scenarios again. Maybe
solvable, but non-trivial.

Jan


--------------enigF9362955BBB5DD368CF9AB95
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAkz6J2cACgkQitSsb3rl5xS06ACg0SXfss1bKXy/rQ1y5yXkA/HM
1nMAn0wfcM68q0M1gVfreyoa1Vnp6yNZ
=Oyoc
-----END PGP SIGNATURE-----

--------------enigF9362955BBB5DD368CF9AB95--
