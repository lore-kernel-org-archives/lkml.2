Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753210Ab1L1CoW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 21:44:22 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:40847 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab1L1CoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 21:44:20 -0500
Date: Wed, 28 Dec 2011 13:44:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <jglisse@redhat.com>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-Id: <20111228134408.c03f0dd6dc1c38982c679842@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Dec_2011_13_44_08_+1100_3cdUCAtxxFzyGKhp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Dec_2011_13_44_08_+1100_3cdUCAtxxFzyGKhp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/radeon/evergreen.c between commit 77e00f2ea94a
("drm/radeon/kms: bail on BTC parts if MC ucode is missing") from Linus'
tree and commit b15ba51207e5 ("drm/radeon: introduce a sub allocator and
convert ib pool to it v4") from the drm tree.

I think it is just context changes.  I fixed it up (see below) and can
carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/radeon/evergreen.c
index 92c9628,1934728..0000000
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@@ -3264,30 -3337,6 +3337,18 @@@ int evergreen_init(struct radeon_devic
  		evergreen_pcie_gart_fini(rdev);
  		rdev->accel_working =3D false;
  	}
- 	if (rdev->accel_working) {
- 		r =3D radeon_ib_pool_init(rdev);
- 		if (r) {
- 			DRM_ERROR("radeon: failed initializing IB pool (%d).\n", r);
- 			rdev->accel_working =3D false;
- 		}
- 		r =3D r600_ib_test(rdev);
- 		if (r) {
- 			DRM_ERROR("radeon: failed testing IB (%d).\n", r);
- 			rdev->accel_working =3D false;
- 		}
- 	}
 +
 +	/* Don't start up if the MC ucode is missing on BTC parts.
 +	 * The default clocks and voltages before the MC ucode
 +	 * is loaded are not suffient for advanced operations.
 +	 */
 +	if (ASIC_IS_DCE5(rdev)) {
 +		if (!rdev->mc_fw && !(rdev->flags & RADEON_IS_IGP)) {
 +			DRM_ERROR("radeon: MC ucode required for NI+.\n");
 +			return -EINVAL;
 +		}
 +	}
 +
  	return 0;
  }
 =20

--Signature=_Wed__28_Dec_2011_13_44_08_+1100_3cdUCAtxxFzyGKhp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO+oJ4AAoJEECxmPOUX5FEAXEQAKRnajR9q99shqhBXCDLcHc8
GjV3X7y/6YC5RdmL3HXtj7IAI6InSKxdWhhG83hcZ25GHzFoBWrASu8+4bCKy7xf
he/TW4unx1M0cfg6KnsvI8pq0Tfv/DaJeOB4Rs+5u+rG4uDJqnFr+/+GskKjwv4C
8pwjlZV3+8DUexEiJXRpgJ56WOJx2ykYxXSQb9znQLKBw15J4iQ0a6iZocu8X5C2
mkcAS5gbI/Q7hp+TNy4tOYdj85lv/d8lR5qpXllLcsR1PAbkergoUOK4OFZK5otW
DTEftqUoWG/N5pENJgqMWn+4A7IQ8TFOb2Q/cZjjf/KCd6c7t9ldeOVYRRDdL8t8
lV8TuwBy3HaNGQ6e7FX+p6jWuQ33nUosxLfVC8dxhCvf5J9VC4cABC/+XUjxZfGF
RwY3cw5zojAdfJEL3yGd5R/DeiaXbGIst4ko+zlb+MmTdAVOJDOrkIN1viSG7ZPz
4BMdXEqRn56ZBvgR6oWGQkchf79AcEdgpocqPND/FB/oAZtfZ7sVv9rFAZq0YAK+
Uri28oHfEO1htBJcO2R7qEMwpfiKw/whmS9ApNZmFnVSDT1Z+eMKQSg/fYYMZlNB
LQS+/OCHinqPnt3520wy61i3xdPekuEAbq/W6wEDzrYZdJ1Y6pL6L3JsML3POeSO
IJ/f2xflCAMGMkcRczB6
=4R+U
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Dec_2011_13_44_08_+1100_3cdUCAtxxFzyGKhp--
