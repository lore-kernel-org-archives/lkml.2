Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751548Ab2HMJP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 05:15:28 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:54321 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751402Ab2HMJPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 05:15:25 -0400
Date: Mon, 13 Aug 2012 12:20:42 +0300
From: Sergei Trofimovich <slyich@gmail.com>
To: linux-pm@lists.linux-foundation.org, Matthew Garrett <mjg@redhat.com>,
        Holger Macht <holger@homac.de>, Lin Ming <ming.m.lin@intel.com>,
        Jeff Garzik <jgarzik@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: bisected regression: v3.6-rc1: resume from s2ram does not restore
 ata_piix (v3.5 worked)
Message-ID: <20120813122042.4fd81835@sf>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/9adQ69i6ES4fpN.RZn2v/l1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/9adQ69i6ES4fpN.RZn2v/l1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

It's a laptop compaq 2510p (~5 years old core2 laptop) with a
single SATA drive:

00:1f.1 IDE interface: Intel Corporation 82801HM/HEM (ICH8M/ICH8M-E) IDE Co=
ntroller (rev 03)
        Subsystem: Hewlett-Packard Company Device 30c9
        Kernel driver in use: ata_piix

kernel v3.5 worked fine. 3.6-rc1 resumes, but disk stays inaccessble.
Seems to be 100% reproducible. Bisection gave sane result[1].

I was not able to revert it as-is, thus couldn't verify the revert
helps on top of master.

Do you need more info?

Thanks!

[1]
commit 30dcf76acc695cbd2fa919e294670fe9552e16e7
Author: Matthew Garrett <mjg@redhat.com>
Date:   Mon Jun 25 16:13:04 2012 +0800

    libata: migrate ACPI code over to new bindings
   =20
    Now that we have the ability to directly glue the ACPI namespace to the
    driver model in libata, we don't need the custom code to handle the same
    thing. Remove it and migrate the functions over to the new code.
   =20
    Signed-off-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Holger Macht <holger@homac.de>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

:040000 040000 6a659a9d4a92b2085f6d0b58484cb2f82cd12cfa 125fe5d5fa8b208a087=
92b03e752571d825465d2 M      drivers
:040000 040000 b7c3819be4e82ae6e2ac9688055aeb2bc1bc4ebd 9cbc8fd15b147a178f7=
23bcdb9e7c34f9868400f M      include

git bisect good 492d542273a4859f8bf8cc7744cdf71ef50b39ea
# bad: [354b2eac3848bddbcb111079138b907ccca70ae8] libata-acpi: fix up for a=
cpi_pm_device_sleep_state API
git bisect bad 354b2eac3848bddbcb111079138b907ccca70ae8
# bad: [dc7f71f486f4f5fa96f6dcf86833da020cde8a11] sata_dwc_460ex: device tr=
ee may specify dma_channel
git bisect bad dc7f71f486f4f5fa96f6dcf86833da020cde8a11
# bad: [91e4d5a1d7d11ca0b08803a11cb8dc866d2d611f] drivers/acpi/glue: revert=
 accidental license-related 6b66d95895c bits
git bisect bad 91e4d5a1d7d11ca0b08803a11cb8dc866d2d611f
# bad: [3bd46600a7a7e938c54df8cdbac9910668c7dfb0] libata-acpi: add ata port=
 runtime D3Cold support
git bisect bad 3bd46600a7a7e938c54df8cdbac9910668c7dfb0
# bad: [30dcf76acc695cbd2fa919e294670fe9552e16e7] libata: migrate ACPI code=
 over to new bindings
git bisect bad 30dcf76acc695cbd2fa919e294670fe9552e16e7
# good: [6b66d95895c149cbc04d4fac5a2f5477c543a8ae] libata: bind the Linux d=
evice tree to the ACPI device tree
git bisect good 6b66d95895c149cbc04d4fac5a2f5477c543a8ae
# good: [6b66d95895c149cbc04d4fac5a2f5477c543a8ae] libata: bind the Linux d=
evice tree to the ACPI device tree
git bisect good 6b66d95895c149cbc04d4fac5a2f5477c543a8ae
30dcf76acc695cbd2fa919e294670fe9552e16e7 is the first bad commit

--=20

  Sergei

--Sig_/9adQ69i6ES4fpN.RZn2v/l1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlAoxvMACgkQcaHudmEf86r8vgCgiJP/7Jo6K3u25Idbe73wv5ra
kRUAnjCcdsxe8hvhn1fhoYfnrknGr8oL
=seCM
-----END PGP SIGNATURE-----

--Sig_/9adQ69i6ES4fpN.RZn2v/l1--
