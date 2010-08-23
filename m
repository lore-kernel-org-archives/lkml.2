Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab0HWGs6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 02:48:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:16458 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751978Ab0HWGs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 02:48:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,256,1280732400"; 
   d="asc'?scan'208";a="650232580"
Date: Mon, 23 Aug 2010 14:48:54 +0800
From: Zhenyu Wang <zhenyuw@linux.intel.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Eric Anholt <eric@anholt.net>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] agp/intel: Fix dma mask for Sandybridge
Message-ID: <20100823064854.GE29442@zhen-devel.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
Mail-Followup-To: Takashi Iwai <tiwai@suse.de>,
	Eric Anholt <eric@anholt.net>, David Airlie <airlied@linux.ie>,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <s5hlj81cn4n.wl%tiwai@suse.de>
 <20100823013507.GA29442@zhen-devel.sh.intel.com>
 <s5h62z1ew1y.wl%tiwai@suse.de>
 <20100823054303.GC29442@zhen-devel.sh.intel.com>
 <s5hzkwddfy5.wl%tiwai@suse.de>
 <20100823061922.GD29442@zhen-devel.sh.intel.com>
 <s5hiq31delt.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QXO0/MSS4VvK6f+D"
Content-Disposition: inline
In-Reply-To: <s5hiq31delt.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QXO0/MSS4VvK6f+D
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2010.08.23 08:31:42 +0200, Takashi Iwai wrote:
> > bit 31			 bit 11			 bit 4			bit 0
> >    |<-physical addr 31:12->|<-physical addr 39:32->|<-cache ctl 3:1->|v=
alid|
>=20
> Then I really don't understand why it works.
> You shift 28bit and mask with 0xff.  Obviously it overwrite bits 0:3
> with original 28:31 bits.  Masking 0xff0 fixes the issue.
>=20

ah, sorry, my stupid. Thanks for catching this!

Subject: [PATCH] agp/intel: fix physical address mask bits for sandybridge

It should shift bit 39-32 into pte's bit 11-4.

Reported-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
---
 drivers/char/agp/intel-gtt.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/char/agp/intel-gtt.c b/drivers/char/agp/intel-gtt.c
index d22ffb8..0edfc87 100644
--- a/drivers/char/agp/intel-gtt.c
+++ b/drivers/char/agp/intel-gtt.c
@@ -1333,8 +1333,8 @@ static unsigned long intel_i965_mask_memory(struct ag=
p_bridge_data *bridge,
 static unsigned long intel_gen6_mask_memory(struct agp_bridge_data *bridge,
 					    dma_addr_t addr, int type)
 {
-	/* Shift high bits down */
-	addr |=3D (addr >> 28) & 0xff;
+	/* gen6 has bit11-4 for physical addr bit39-32 */
+	addr |=3D (addr >> 28) & 0xff0;
=20
 	/* Type checking must be done elsewhere */
 	return addr | bridge->driver->masks[type].mask;
--=20
1.7.0.4

--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--QXO0/MSS4VvK6f+D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkxyGdYACgkQsQQaM014GCeQfACgmL8JvmFYh1ud1pv/3rtC1sLt
G5kAnR9ix7NmtRlk6Mc1OqNs8NGQKS34
=Rvh6
-----END PGP SIGNATURE-----

--QXO0/MSS4VvK6f+D--
