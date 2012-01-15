Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab2AOVgq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 16:36:46 -0500
Received: from cc-smtpout2.netcologne.de ([89.1.8.212]:46888 "EHLO
	cc-smtpout2.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab2AOVgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 16:36:45 -0500
Date: Sun, 15 Jan 2012 22:30:05 +0100
From: Kurt Garloff <kurt@garloff.de>
To: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: stable@vger.kernel.org, Len Brown <lenb@kernel.org>
Subject: [PATCH 0/3] ACPI SRAT: Disregard reserved PXM bits
Message-ID: <20120115213005.GT12380@tpkurt2.garloff.de>
Mail-Followup-To: Kurt Garloff <kurt@garloff.de>,
	linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
	stable@vger.kernel.org, Len Brown <lenb@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xr11uZXTBybZk4CB"
Content-Disposition: inline
X-Operating-System: Linux 2.6.32.46-0.3-default x86_64
X-PGP-Info: on http://www.garloff.de/kurt/mykeys.pgp
X-PGP-Key: 1024D/1C98774E
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xr11uZXTBybZk4CB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

this has been submitted thrice already -- and while it found a bit of
friendly feedback, it has not been merged. It should be IMVHO, and I
hope this time the right eyes see this flying by ...
I should mention that it fixes a real problem (wrong affinities reported
in sysfs and thus userspace high-perf compute code taking wrong
decisions) and that this has been part of SUSE enterprise kernels since=20
a few years now.
It should also go right into stable IMVHO.

Original description to follow ...


ACPI specification says that the OS must disregard reserved bits.
The x86_64 SRAT parser does not discard the upper 24 bits of the
proximity_domain (pxm) in the acpi_srat_mem_affinity entries for
SRAT v1 tables. (v2 has 32 bits wide fields, v1 only 8 bits.)
This can lead to problems with poor BIOS implementations that failed
to set reserved bytes to zero. (The ACPI spec is a bit vague here
unfortunately.)

This was also inconsistent: On x86-64 (srat_64.c), the=20
_cpu_affinity does only use the low 8 bits of pxm, while the
full 32 bits of _mem_affinity are consumed.
In srat_32.c (x86), only 8bits are used (which is OK, a 32bit system
with >256 PXMs does not seem reasonable at all).
On ia64, the support of more than 8 bits was consistent between
mem and cpu affinity entries, however it was dependent on "sn2"=20
platform.

The patch series has the following goals:
* Make the kernel support consistently 8bits or 32bits for the
  proximity domain
* Make this dependent on the SRAT version; v1 =3D> 8bits, v2 =3D> 32bits.

Overview over the patches:
- [1/3] Store the SRAT table version value in acpi_srat_revision=20
- [2/3] x86-64: Discard the upper 24 bits in mem_affinity if rev <=3D 1
        and use upper 24bits in cpu_affinity if rev >=3D 2
- [3/3] ia64: Also use upper 8/24bits if rev >=3D 2 (but leave logic to
        enable on sn2 as well -- I don't know if sn2 reports v1 or v2
        SRAT) Also add two __init decls in ia64 pxm accessors.

Patch is against current git.

Note: If you respond to this mail, please keep me in Cc -- I'm not
subscribed to LKML these days.

Cheers,
--=20
Kurt Garloff <kurt@garloff.de>  [Koeln/Greven]


--xr11uZXTBybZk4CB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iD8DBQFPE0VdxmLh6hyYd04RAkoxAJ9ZtQwFcjDW8swwfuaAJ0KFA2yBUwCgrrZ4
Lo2UgdwS6bGhRLyMOuvDBYA=
=LLnV
-----END PGP SIGNATURE-----

--xr11uZXTBybZk4CB--
