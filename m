Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab1GVSAy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 14:00:54 -0400
Received: from home.keithp.com ([63.227.221.253]:56420 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750927Ab1GVSAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 14:00:52 -0400
From: Keith Packard <keithp@keithp.com>
To: Kirill Smelkov <kirr@mns.spb.ru>, Pekka Enberg <penberg@kernel.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Luke-Jr <luke@dashjr.org>,
        intel-gfx@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Ray Lee <ray-lk@madrabbit.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Florian Mickler <florian@mickler.org>
Subject: Re: Major 2.6.38 / 2.6.39 / 3.0 regression ignored?
In-Reply-To: <20110722110806.GA29757@tugrik.mns.mnsspb.ru>
References: <201105201306.31204.luke@dashjr.org> <BANLkTimOqhNEsBEg6f=nMiMJqYGNyFJmeQ@mail.gmail.com> <013811$4lfs6@fmsmga002.fm.intel.com> <201105211123.56053.luke@dashjr.org> <aefc95$1usaq@orsmga001.jf.intel.com> <20110528131920.GA10467@tugrik.mns.mnsspb.ru> <20110712171706.GA18414@tugrik.mns.mnsspb.ru> <CAOJsxLEz-fPnb9oYnLMk9UbGqgsfm-g1d2yH=TrEiEk7HvyQzA@mail.gmail.com> <20110722110806.GA29757@tugrik.mns.mnsspb.ru>
User-Agent: Notmuch/0.6.1-66-ga900dda (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Fri, 22 Jul 2011 11:00:41 -0700
Message-ID: <yun7h7atcty.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 22 Jul 2011 15:08:06 +0400, Kirill Smelkov <kirr@mns.spb.ru> wrote:

> And now after v3.0 is out, I've tested it again, and yes, like it was
> broken on v3.0-rc5, it is (now even more) broken on v3.0 -- after first
> bad io access the system freezes completely:

I looked at this when I first saw it (a couple of weeks ago), and I
couldn't see any obvious reason this patch would cause this particular
problem. I didn't want to revert the patch at that point as I feared it
would cause other subtle problems. Given that you've got a work-around,
it seemed best to just push this off past 3.0.

Given the failing address passed to ioread32, this seems like it's
probably the call to READ_BREADCRUMB -- I915_BREADCRUMB_INDEX is 0x21,
which is an offset in 32-bit units within the hardware status page. If
the status_page.page_addr value was zero, then the computed address
would end up being 0x84.

And, it looks like status_page.page_addr *will* end up being zero as a
result of the patch in question. The patch resets the entire ring
structure contents back to the initial values, which includes smashing
the status_page structure to zero, clearing the value of
status_page.page_addr set in i915_init_phys_hws.

Here's an untested patch which moves the initialization of
status_page.page_addr into intel_render_ring_init_dri. I note that
intel_init_render_ring_buffer *already* has the setting of the
status_page.page_addr value, and so I've removed the setting of
status_page.page_addr from i915_init_phys_hws.

I suspect we could remove the memset from intel_init_render_ring_buffer;
it seems entirely superfluous given the memset in i915_init_phys_hws.

From=20159ba1dd207fc52590ce8a3afd83f40bd2cedf46 Mon Sep 17 00:00:00 2001
From: Keith Packard <keithp@keithp.com>
Date: Fri, 22 Jul 2011 10:44:39 -0700
Subject: [PATCH] drm/i915: Initialize RCS ring status page address in
 intel_render_ring_init_dri

Physically-addressed hardware status pages are initialized early in
the driver load process by i915_init_phys_hws. For UMS environments,
the ring structure is not initialized until the X server starts. At
that point, the entire ring structure is re-initialized with all new
values. Any values set in the ring structure (including
ring->status_page.page_addr) will be lost when the ring is
re-initialized.

This patch moves the initialization of the status_page.page_addr value
to intel_render_ring_init_dri.

Signed-off-by: Keith Packard <keithp@keithp.com>
=2D--
 drivers/gpu/drm/i915/i915_dma.c         |    6 ++----
 drivers/gpu/drm/i915/intel_ringbuffer.c |    3 +++
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dm=
a.c
index 1271282..8a3942c 100644
=2D-- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -61,7 +61,6 @@ static void i915_write_hws_pga(struct drm_device *dev)
 static int i915_init_phys_hws(struct drm_device *dev)
 {
 	drm_i915_private_t *dev_priv =3D dev->dev_private;
=2D	struct intel_ring_buffer *ring =3D LP_RING(dev_priv);
=20
 	/* Program Hardware Status Page */
 	dev_priv->status_page_dmah =3D
@@ -71,10 +70,9 @@ static int i915_init_phys_hws(struct drm_device *dev)
 		DRM_ERROR("Can not allocate hardware status page\n");
 		return -ENOMEM;
 	}
=2D	ring->status_page.page_addr =3D
=2D		(void __force __iomem *)dev_priv->status_page_dmah->vaddr;
=20
=2D	memset_io(ring->status_page.page_addr, 0, PAGE_SIZE);
+	memset_io((void __force __iomem *)dev_priv->status_page_dmah->vaddr,
+		  0, PAGE_SIZE);
=20
 	i915_write_hws_pga(dev);
=20
diff --git a/drivers/gpu/drm/i915/intel_ringbuffer.c b/drivers/gpu/drm/i915=
/intel_ringbuffer.c
index e961568..47b9b27 100644
=2D-- a/drivers/gpu/drm/i915/intel_ringbuffer.c
+++ b/drivers/gpu/drm/i915/intel_ringbuffer.c
@@ -1321,6 +1321,9 @@ int intel_render_ring_init_dri(struct drm_device *dev=
, u64 start, u32 size)
 		ring->get_seqno =3D pc_render_get_seqno;
 	}
=20
+	if (!I915_NEED_GFX_HWS(dev))
+		ring->status_page.page_addr =3D dev_priv->status_page_dmah->vaddr;
+
 	ring->dev =3D dev;
 	INIT_LIST_HEAD(&ring->active_list);
 	INIT_LIST_HEAD(&ring->request_list);
=2D-=20
1.7.5.4

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOKbrJQp8BWwlsTdMRAhILAKCFk+JsTeM6qrL4QVZSujTVOSTZ1wCfYXEV
zGP/v/rIhDD7jebppGLJbSo=
=a2oD
-----END PGP SIGNATURE-----
--=-=-=--
