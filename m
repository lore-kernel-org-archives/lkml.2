Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760247Ab0LNXAp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 18:00:45 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:58425 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756060Ab0LNXAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 18:00:43 -0500
Message-ID: <4D07F70A.30209@web.de>
Date: Wed, 15 Dec 2010 00:00:26 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        linux-kernel@vger.kernel.org, kvm <kvm@vger.kernel.org>,
        Tom Lyon <pugs@cisco.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH v3 2/4] genirq: Inform handler about line sharing state
References: <cover.1292281184.git.jan.kiszka@web.de> <a59c76552ebeaa128022ba9bcc7ea0753b312447.1292281184.git.jan.kiszka@web.de> <alpine.LFD.2.00.1012142147420.12146@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1012142147420.12146@localhost6.localdomain6>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig30DBE9776EC3FE5A5D9B529F"
X-Provags-ID: V01U2FsdGVkX1+kEshGbxSkeOVLO3CNT/QL9x3xMNuc39cXY4We
	jE/94L1cC2pNldP11B+ohtlRqbrC3kPvkdOUvXEGfkOVCMX9Tl
	c7VE6ib6Q=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig30DBE9776EC3FE5A5D9B529F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 14.12.2010 21:54, Thomas Gleixner wrote:
> On Mon, 13 Dec 2010, Jan Kiszka wrote:
>> @@ -943,6 +950,9 @@ static struct irqaction *__free_irq(unsigned int i=
rq, void *dev_id)
>>  	/* Make sure it's not being used on another CPU: */
>>  	synchronize_irq(irq);
>> =20
>> +	if (single_handler)
>> +		desc->irq_data.drv_status &=3D ~IRQS_SHARED;
>> +
>=20
> What's the reason to clear this flag outside of the desc->lock held
> region.

We need to synchronize the irq first before clearing the flag.

The problematic scenario behind this: An IRQ started in shared mode,
this the line was unmasked after the hardirq. Now we clear IRQS_SHARED
before calling into the threaded handler. And that handler may now think
that the line is still masked as IRQS_SHARED is set.

> I need this status for other purposes as well, where I
> definitely need serialization.

Well, two options: wrap all bit manipulations with desc->lock
acquisition/release or turn drv_status into an atomic. I don't know what
your plans with drv_status are, so...

>=20
>> +	mutex_lock(&register_lock);
>> +
>> +	old_action =3D desc->action;
>> +	if (old_action && (old_action->flags & IRQF_ADAPTIVE) &&
>> +	    !(desc->irq_data.drv_status & IRQS_SHARED)) {
>> +		/*
>> +		 * Signal the old handler that is has to switch to shareable
>> +		 * handling mode. Disable the line to avoid any conflict with
>> +		 * a real IRQ.
>> +		 */
>> +		disable_irq(irq);
>> +		local_irq_disable();
>> +
>> +		desc->irq_data.drv_status |=3D IRQS_SHARED | IRQS_MAKE_SHAREABLE;
>=20
> Unserialized access as well. Will think about it.
>=20
>> +		old_action->handler(irq, old_action->dev_id);
>> +		desc->irq_data.drv_status &=3D ~IRQS_MAKE_SHAREABLE;
>=20
> Thanks,
>=20
> 	tglx

Jan


--------------enig30DBE9776EC3FE5A5D9B529F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAk0H9w8ACgkQitSsb3rl5xQ1vwCg0zyEKWV2dwEbR1PWgcgBChPa
qVcAnjMO758LOKzK+pEAjxc2lnPIuivO
=0+nL
-----END PGP SIGNATURE-----

--------------enig30DBE9776EC3FE5A5D9B529F--
