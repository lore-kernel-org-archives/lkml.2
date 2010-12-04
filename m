Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab0LDOyM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 09:54:12 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:50283 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336Ab0LDOyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 09:54:10 -0500
Message-ID: <4CFA560C.3050206@web.de>
Date: Sat, 04 Dec 2010 15:54:04 +0100
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
References: <cover.1291419444.git.jan.kiszka@web.de> <alpine.LFD.2.00.1012041052450.2653@localhost6.localdomain6> <4CFA2763.4060102@web.de> <alpine.LFD.2.00.1012041526280.2653@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1012041526280.2653@localhost6.localdomain6>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB008F71C8643AF0EBDB6F0DF"
X-Provags-ID: V01U2FsdGVkX19BpSyHz9bXwSQYE/DI5RNABJ/r/Bv+bdOLUMdi
	Tl/VrMmt2Q70ZfJKkdTfgCYg/HvR1qIDMT6ZpQigNtxgDRHdwS
	peujfUiEc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB008F71C8643AF0EBDB6F0DF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 04.12.2010 15:41, Thomas Gleixner wrote:
> Jan,
>=20
> On Sat, 4 Dec 2010, Jan Kiszka wrote:
>=20
>> Am 04.12.2010 11:37, Thomas Gleixner wrote:
>>> On Sat, 4 Dec 2010, Jan Kiszka wrote:
>>> If interrupt is shared, then you want to keep the current behaviour:
>>>
>>>    disable at line level (IRQF_ONESHOT)
>>>    run handler thread (PCI level masking)
>>>    reenable at line level in irq_finalize_oneshot()
>>>    reenable at PCI level when guest is done
>>
>> If the interrupt is shared, we must mask at PCI level inside the prima=
ry
>> handler as we also have to support non-threaded users of the same line=
=2E
>> So we always have a transition line-level -> device-level
>> masking in a primary handler.
>=20
> Sorry that left out the hard irq part. Of course it needs to do the
> PCI level masking in the primary one.
> =20
>> reduce the latency. So both threaded and non-threaded cases should be
>> addressable by any approach.
>=20
> The oneshot magic should work on non threaded cases as well. Needs
> some modifications, but nothing complex.
> =20
>>> If interrupts are in flight accross request/free then this change
>>> takes effect when the next interrupt comes in.
>>
>> For registration, that might be too late. We need to synchronize on
>> in-flight interrupts for that line and then ensure that it gets enable=
d
>> independently of the registered user. That user may have applied
>> outdated information, thus would block the line for too long if user
>> space decides to do something else.
>=20
> No, that's really just a corner case when going from one to two
> handlers and I don't think it matters much. If you setup a new driver
> it's not really important whether that first thing comes in a few ms
> later.

The worst case remains infinite (user space never signals end of interrup=
t).

>=20
> Also there is a pretty simple solution for this: The core code knows,
> that there is an ONESHOT interrupt in flight, so it simply can call

It doesn't synchronize the tail part against the masking in the
handler(s), that's driver business.

> the primary handler of that device with the appropriate flag set
> (maybe an additional one to indicate the transition) and let that deal
> with it. Needs some thought vs. locking and races, but that shouldn't
> be hard.

Yes, I thought about this kind of transition (re-invoking the existing
handler) already. We do need notification of the switch (at least for
exclusive->shared) as only the driver can migrate the masking for
in-flight interrupts.

Jan


--------------enigB008F71C8643AF0EBDB6F0DF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAkz6Vg8ACgkQitSsb3rl5xTzNACgoyWHSOe52HrFW5LxB9qZFFr+
P4EAoL9zHKbCdHFGyrvs9WTyeSy9gvxU
=DvzA
-----END PGP SIGNATURE-----

--------------enigB008F71C8643AF0EBDB6F0DF--
