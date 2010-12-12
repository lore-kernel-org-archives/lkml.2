Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190Ab0LLVtz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 16:49:55 -0500
Received: from fmmailgate03.web.de ([217.72.192.234]:41156 "EHLO
	fmmailgate03.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751121Ab0LLVtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 16:49:53 -0500
Message-ID: <4D054372.6020008@web.de>
Date: Sun, 12 Dec 2010 22:49:38 +0100
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
Subject: Re: [PATCH v2 2/4] genirq: Inform handler about line sharing state
References: <cover.1292152963.git.jan.kiszka@web.de> <664535c6596c0c6bf7024f2608134c90e2093c19.1292152963.git.jan.kiszka@web.de> <alpine.LFD.2.00.1012121750520.2653@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1012121750520.2653@localhost6.localdomain6>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig318EED1660B42764D5D6B931"
X-Provags-ID: V01U2FsdGVkX1+ijDo1KZMNZMYNvCvKC0i43Td7/g69uVOKXwgK
	GYEi9Q3laskmYw+OeCkKnCds1afRSSgGax6UNRfHCg/fAG8GwV
	mfRmwk5n0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig318EED1660B42764D5D6B931
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 12.12.2010 17:53, Thomas Gleixner wrote:
> On Sun, 12 Dec 2010, Jan Kiszka wrote:
>=20
>> From: Jan Kiszka <jan.kiszka@siemens.com>
>>
>> This enabled interrupt handlers to retrieve the current line sharing s=
tate via
>> the new interrupt status word so that they can adapt to it.
>>
>> The switch from shared to exclusive is generally uncritical and can th=
us be
>> performed on demand. However, preparing a line for shared mode may req=
uire
>> preparational steps of the currently registered handler. It can theref=
ore
>> request an ahead-of-time notification via IRQF_ADAPTIVE. The notificat=
ion
>> consists of an exceptional handler invocation with IRQS_MAKE_SHAREABLE=
 set in
>> the status word.
>>
>> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
>> ---
>>  include/linux/interrupt.h |   10 ++++++++++
>>  include/linux/irqdesc.h   |    2 ++
>>  kernel/irq/irqdesc.c      |    2 ++
>>  kernel/irq/manage.c       |   44 ++++++++++++++++++++++++++++++++++++=
+++++---
>>  4 files changed, 55 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
>> index 16cdbbf..c6323a2 100644
>> --- a/include/linux/interrupt.h
>> +++ b/include/linux/interrupt.h
>> @@ -55,6 +55,7 @@
>>   *                Used by threaded interrupts which need to keep the
>>   *                irq line disabled until the threaded handler has be=
en run.
>>   * IRQF_NO_SUSPEND - Do not disable this IRQ during suspend
>> + * IRQF_ADAPTIVE - Request notification about upcoming interrupt line=
 sharing
>>   *
>>   */
>>  #define IRQF_DISABLED		0x00000020
>> @@ -67,6 +68,7 @@
>>  #define IRQF_IRQPOLL		0x00001000
>>  #define IRQF_ONESHOT		0x00002000
>>  #define IRQF_NO_SUSPEND		0x00004000
>> +#define IRQF_ADAPTIVE		0x00008000
>> =20
>>  #define IRQF_TIMER		(__IRQF_TIMER | IRQF_NO_SUSPEND)
>> =20
>> @@ -126,6 +128,14 @@ struct irqaction {
>> =20
>>  extern irqreturn_t no_action(int cpl, void *dev_id);
>> =20
>> +/*
>> + * Driver-readable IRQ line status flags:
>> + * IRQS_SHARED - line is shared between multiple handlers
>> + * IRQS_MAKE_SHAREABLE - in the process of making an exclusive line s=
hareable
>> + */
>> +#define IRQS_SHARED		0x00000001
>> +#define IRQS_MAKE_SHAREABLE	0x00000002
>> +
>>  extern unsigned long get_irq_status(unsigned long irq);
>> =20
>>  #ifdef CONFIG_GENERIC_HARDIRQS
>> diff --git a/include/linux/irqdesc.h b/include/linux/irqdesc.h
>> index 979c68c..c490e83 100644
>> --- a/include/linux/irqdesc.h
>> +++ b/include/linux/irqdesc.h
>> @@ -29,6 +29,7 @@ struct timer_rand_state;
>>   * @wait_for_threads:	wait queue for sync_irq to wait for threaded ha=
ndlers
>>   * @dir:		/proc/irq/ procfs entry
>>   * @name:		flow handler name for /proc/interrupts output
>> + * @register_lock:	protects registration & release, for unshared->sha=
red
>=20
> I think we can make that a global mutex. request/free_irq are not
> hotpath operations which require a mutex per irq descriptor.
>=20

Agreed, will change this.

Jan


--------------enig318EED1660B42764D5D6B931
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAk0FQ3cACgkQitSsb3rl5xQWfQCgpYCwlVhhmKz47e6q6kBwDNx/
HdYAoMcbxXQ/Ge+85oxJAJ2HzEAPrVZH
=ZfEo
-----END PGP SIGNATURE-----

--------------enig318EED1660B42764D5D6B931--
