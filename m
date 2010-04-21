Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab0DUIBv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 04:01:51 -0400
Received: from mga12.intel.com ([143.182.124.36]:9121 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752264Ab0DUIBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 04:01:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,249,1270450800"; 
   d="asc'?scan'208";a="268271427"
Date: Wed, 21 Apr 2010 16:01:46 +0800
From: Zhenyu Wang <zhenyuw@linux.intel.com>
To: Eric Anholt <eric@anholt.net>
Cc: Takashi Iwai <tiwai@suse.de>, David Airlie <airlied@linux.ie>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] i915: Skip wrong TV outputs on HP laptop
Message-ID: <20100421080146.GA30452@zhen-devel.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
Mail-Followup-To: Eric Anholt <eric@anholt.net>,
	Takashi Iwai <tiwai@suse.de>, David Airlie <airlied@linux.ie>,
	dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
	Jesse Barnes <jbarnes@virtuousgeek.org>
References: <s5htyr6jnip.wl%tiwai@suse.de>
 <87sk6q82tr.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
In-Reply-To: <87sk6q82tr.fsf@pollan.anholt.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2010.04.20 10:13:20 -0700, Eric Anholt wrote:
> On Tue, 20 Apr 2010 14:50:54 +0200, Takashi Iwai <tiwai@suse.de> wrote:
> > A new HP laptop with GM45 seems detecting wrongly TV outputs
> > occasionally.  Most of time it detects the TV output as disconnected,
> > but spontaneously it detects NTSC 480i although the laptop has no TV
> > output at all.
> >=20
> > A simple (but ad hoc) fix is to add a DMI check as below.
> >=20
> > Signed-off-by: Takashi Iwai <tiwai@suse.de>
>=20
> Does this laptop have no TV connector on the laptop or the dock for it?

Maybe old TV quirks in UMS driver will also be helpful in case that
current BIOS check still fail.=20

This is from old UMS driver, but use pci subsys ids instead of dmi info
at that time.

=46rom 60bc20124faee4db406b856e139959f8c082830d Mon Sep 17 00:00:00 2001
=46rom: Zhenyu Wang <zhenyuw@linux.intel.com>
Date: Wed, 21 Apr 2010 15:53:51 +0800
Subject: [PATCH] drm/i915: TV quirks for laptop with no TV connector

This picks up TV connector quirks in original UMS driver,
to disable TV encoder on laptop with no physical TV port.

Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
---
 drivers/gpu/drm/i915/intel_tv.c |   69 +++++++++++++++++++++++++++++++++++=
++++
 1 files changed, 69 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_tv.c b/drivers/gpu/drm/i915/intel_t=
v.c
index 081cb90..a96a14f 100644
--- a/drivers/gpu/drm/i915/intel_tv.c
+++ b/drivers/gpu/drm/i915/intel_tv.c
@@ -1612,6 +1612,71 @@ static int tv_is_present_in_vbt(struct drm_device *d=
ev)
 	return ret;
 }
=20
+struct intel_tv_quirk {
+	int pci_device;
+	int subsys_vendor;
+	int subsys_device;
+};
+
+struct intel_tv_quirk intel_tv_quirk_list[] =3D {
+	/* Clevo M720R has no tv output */
+	{ 0x2a02, 0x1558, 0x0721 },
+	/* Dell Latitude X1 */
+	{ 0x2592, 0x1028, 0x01a3 },
+	/* Dell Latitude X1 / D630 (LP: #197740) */
+	{ 0x2592, 0x1028, 0x01f9 },
+	/* Dell XPS 1330 */
+	{ 0x2a02, 0x1028, 0x0209 },
+	/* Dell Inspiron 1535 */
+	{ 0x2a02, 0x1028, 0x0254 },
+	/* Dell Inspiron 1735 */
+	{ 0x2a02, 0x1028, 0x0256 },
+	/* Dell Inspiron 1318 */
+	{ 0x2a02, 0x1028, 0x0286 },
+	/* Dell Vostro A840 (LP: #235155) */
+	{ 0x2a02, 0x1028, 0x0298 },
+	/* Lenovo 3000 v200 */
+	{ 0x2a02, 0x17aa, 0x3c18 },
+	/* Panasonic Toughbook CF-Y4 has no TV output */
+	{ 0x2592, 0x10f7, 0x8338 },
+	/* Panasonic Toughbook CF-Y7 has no TV output */
+	{ 0x2a02, 0x10f7, 0x8338 },
+	/* Toshiba Satellite U300 has no TV output */
+	{ 0x2a02, 0x1179, 0xff50 },
+	/* Samsung Q35 has no TV output */
+	{ 0x27a2, 0x144d, 0xc504 },
+	/* Samsung Q45 has no TV output */
+	{ 0x2a02, 0x144d, 0xc510 },
+	/* HP Compaq nx6110 has no TV output */
+	{ 0x2592, 0x103c, 0x099c },
+	/* HP Compaq nx6310 has no TV output */
+	{ 0x27a2, 0x103c, 0x30aa },
+	/* HP Compaq 6730s has no TV output */
+	{ 0x2a42, 0x103c, 0x30e8 },
+	/* Ordi Enduro UW31 (See LP: #152416) */
+	{ 0x27a2, 0x1584, 0x9900 },
+	/* Littlebit Sepia X35 (rebranded Asus Z37E) (See LP: #201257) */
+	{ 0x2a02, 0x1043, 0x8265 },
+	/* end mark */
+	{ 0, 0, 0 }
+};
+
+static bool
+intel_tv_check(struct drm_device *dev)
+{
+	struct pci_dev *pdev =3D dev->pdev;
+	struct intel_tv_quirk *q =3D intel_tv_quirk_list;
+
+	while (q && q->pci_device) {
+		if (q->pci_device =3D=3D dev->pci_device &&
+		    q->subsys_vendor =3D=3D pdev->subsystem_vendor &&
+		    q->subsys_device =3D=3D pdev->subsystem_device)
+			return true;
+		++q;
+	}
+	return false;
+}
+
 void
 intel_tv_init(struct drm_device *dev)
 {
@@ -1635,6 +1700,10 @@ intel_tv_init(struct drm_device *dev)
 	if (!dev_priv->int_tv_support)
 		return;
=20
+	/* No real TV output quirks */
+	if (intel_tv_check(dev))
+		return;
+
 	/*
 	 * Sanity check the TV output by checking to see if the
 	 * DAC register holds a value
--=20
1.6.3.3


--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvOsOoACgkQsQQaM014GCeSnQCgjA3AiG5saa0omqqvxzx9ygol
zeAAn017d90oNMkN6yo6rq7MoA0NuJ4v
=O+VL
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
