Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab2KWCfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 21:35:51 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56818 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755980Ab2KWCfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 21:35:50 -0500
Message-ID: <1353638130.4764.4.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 02/38] PCI/PM: Fix deadlock when unbinding device if parent
 in D3cold
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Huang Ying <ying.huang@intel.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk, Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Zhang Yanmin <yanmin.zhang@intel.com>
Date: Fri, 23 Nov 2012 02:35:30 +0000
In-Reply-To: <20121122003904.516735571@linuxfoundation.org>
References: <20121122003904.262382971@linuxfoundation.org>
	 <20121122003904.516735571@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-aGJAZ5fmvagHD/wvGDid"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-aGJAZ5fmvagHD/wvGDid
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-11-21 at 16:39 -0800, Greg Kroah-Hartman wrote:
> 3.0-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Huang Ying <ying.huang@intel.com>
>=20
> commit 90b5c1d7c45eeb622302680ff96ed30c1a2b6f0e upstream.
>=20
> If a PCI device and its parents are put into D3cold, unbinding the
> device will trigger deadlock as follow:
>=20
> - driver_unbind
>   - device_release_driver
>     - device_lock(dev)				<--- previous lock here
>     - __device_release_driver
>       - pm_runtime_get_sync
>         ...
>           - rpm_resume(dev)
>             - rpm_resume(dev->parent)
>               ...
>                 - pci_pm_runtime_resume
>                   ...
>                   - pci_set_power_state
>                     - __pci_start_power_transition
>                       - pci_wakeup_bus(dev->parent->subordinate)
>                         - pci_walk_bus
>                           - device_lock(dev)	<--- deadlock here
>=20
>=20
> If we do not do device_lock in pci_walk_bus, we can avoid deadlock.
> Device_lock in pci_walk_bus is introduced in commit:
> d71374dafbba7ec3f67371d3b7e9f6310a588808, corresponding email thread
> is: https://lkml.org/lkml/2006/5/26/38.  The patch author Zhang Yanmin
> said device_lock is added to pci_walk_bus because:
>=20
>   Some error handling functions call pci_walk_bus. For example, PCIe
>   aer. Here we lock the device, so the driver wouldn't detach from the
>   device, as the cb might call driver's callback function.
>=20
> So I fixed the deadlock as follows:
>=20
> - remove device_lock from pci_walk_bus
> - add device_lock into callback if callback will call driver's callback
>=20
> I checked pci_walk_bus users one by one, and found only PCIe aer needs
> device lock.
[...]

What about eeh_report_error() in
arch/powerpc/platforms/pseries/eeh_driver.c?

Also, is the deadlock even possible before this change in Linux 3.6?

commit 448bd857d48e69b33ef323739dc6d8ca20d4cda7
Author: Huang Ying <ying.huang@intel.com>
Date:   Sat Jun 23 10:23:51 2012 +0800

    PCI/PM: add PCIe runtime D3cold support

Ben.

--=20
Ben Hutchings
Never attribute to conspiracy what can adequately be explained by stupidity=
.

--=-aGJAZ5fmvagHD/wvGDid
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUK7g8ue/yOyVhhEJAQqvHg//UL/k6Lk7kSKbAdPo3VrEiOX8FKdKEXXP
2zW1D3GcoN/Y+UdWN36qA9Vwp746CjBeXTDsDAgSAXhxhYuz0Jz9zlU+AAJms+x+
6IQ+9lLV1+9oiuXlk2nuz6H3GEXMTiUqpB3UWKYB9yAXPmvL4dav3azcPjTgaTkL
E0Ofp7zpHe8aOJD0cPHIfLA8Okn2ZB+nFnbcRbUH5Xcgd6kNMwYIICfadBdgdbhy
bgnm/avwIxBMeQeZOVGtw0M+F8elBixGjDH8Z6Bq717mnycbiOEt5+Je5B8/giQQ
0y8HV5yQzcMUHFNP1Gxwa8nOG0z91fbhoTCI1D+Uw7PjumRleLsb3eUhbL2Hhmge
cJtF7wogWlfcXmwYOUb9XTnfp/lPa4xgDiKDw8klsJao5hWf4pLms2l4YOCiG7IQ
YfBvudM6cb0798/QsfRAGjhyrb5G539ICOp8mhLoiCxCXMHZRRNo/yHOoqjSMqeW
AjD3509KkgyJdCPpf9mR/VrqHEYXIGRPFwncU/gkTqumtKTIad9+hML3PXT4E4A2
Mamng5yzsNPAjon565x9riqBPKMSWZuRic+sX3LzuUmtoRQs9HKToKTVZkv9OxRV
kt6YTQZ943ggc4kP64ZAcoW+c8DZZnWjrDO3++fHbr8Mx16t3Wcj/P3XzANyQXxj
CL51l3SDFP8=
=9b8P
-----END PGP SIGNATURE-----

--=-aGJAZ5fmvagHD/wvGDid--
