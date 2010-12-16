Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab0LPU0P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 15:26:15 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:50154 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755218Ab0LPU0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 15:26:13 -0500
Message-ID: <4D0A75E3.3090900@web.de>
Date: Thu, 16 Dec 2010 21:26:11 +0100
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
References: <cover.1292281184.git.jan.kiszka@web.de> <a59c76552ebeaa128022ba9bcc7ea0753b312447.1292281184.git.jan.kiszka@web.de> <alpine.LFD.2.00.1012161410440.12146@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1012161410440.12146@localhost6.localdomain6>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig31FE168D31B48AE3A07F5685"
X-Provags-ID: V01U2FsdGVkX1/GNM3rgfJs1ge0djXUSCs7fVHXFKMeZR0881ws
	5iazVNx5w6y1TI9uJzhqGQPVaA/44vchApoTsEkczJONa0cpfj
	GxERpuM6E=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig31FE168D31B48AE3A07F5685
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 16.12.2010 14:13, Thomas Gleixner wrote:
> On Mon, 13 Dec 2010, Jan Kiszka wrote:
>> +	if (old_action && (old_action->flags & IRQF_ADAPTIVE) &&
>> +	    !(desc->irq_data.drv_status & IRQS_SHARED)) {
>> +		/*
>> +		 * Signal the old handler that is has to switch to shareable
>> +		 * handling mode. Disable the line to avoid any conflict with
>> +		 * a real IRQ.
>> +		 */
>> +		disable_irq(irq);
>=20
> This is weird, really. I thought you wanted to avoid waiting for the
> threaded handler to finish if it's on the fly. So this should be
> disable_irq_nosync() or did you change your mind ?

No, I did not. I wanted to avoid that we set MAKE_SHAREABLE while there
might be another IRQ in flight. The handler that is called due to a real
IRQ might misinterpret MAKE_SHAREABLE as "there is no real event" and
perform the wrong steps (at least the current implementation for KVM woul=
d).

However, I will rebase my patch over your series now and try to re-think
this. The question is what could go wrong if we do not guarantee that
MAKE_SHAREABLE and ordinary IRQ will always be distinguishable. If there
is really nothing, specifically for the KVM scenario, we could even drop
the disable/enable_irq. That would be also be nicer when thinking about
potential delays of the already registered handler during this
transitional phase.

Jan


--------------enig31FE168D31B48AE3A07F5685
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAk0KdeMACgkQitSsb3rl5xShGACcCTwxqFSStR315SgUCfUQVyPX
FsAAoOLqp7gBD0E2mVivE8jvcgkzZrN+
=NQQB
-----END PGP SIGNATURE-----

--------------enig31FE168D31B48AE3A07F5685--
