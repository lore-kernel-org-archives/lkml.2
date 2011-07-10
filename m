Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab1GJU1L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 16:27:11 -0400
Received: from home.keithp.com ([63.227.221.253]:54045 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755596Ab1GJU1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 16:27:07 -0400
From: Keith Packard <keithp@keithp.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: i915_gem_inactive_shrink fault
In-Reply-To: <1309856364.18875.110.camel@minggr.sh.intel.com>
References: <1309856364.18875.110.camel@minggr.sh.intel.com>
User-Agent: Notmuch/0.5-202-g6ae4e7d (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Sun, 10 Jul 2011 13:27:02 -0700
Message-ID: <yund3hhg9ux.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Tue, 05 Jul 2011 16:59:24 +0800, Lin Ming <ming.m.lin@intel.com> wrote:


> WARNING: at /linux-2.6/drivers/gpu/drm/i915/intel_display.c:826 assert_fd=
i_tx+0xcc/0xd8()
> Hardware name: To be filled by O.E.M.
> FDI TX state assertion failure (expected off, current on)
> Modules linked in:
> Pid: 1, comm: swapper Not tainted 3.0.0-rc6-tip-mlin+ #571
> Call Trace:
>  [<ffffffff81037802>] warn_slowpath_common+0x7e/0x96
>  [<ffffffff810378ae>] warn_slowpath_fmt+0x41/0x43
>  [<ffffffff813637c4>] assert_fdi_tx+0xcc/0xd8
>  [<ffffffff8136f68a>] ironlake_crtc_disable+0x3de/0xdbe

That's weird -- this test happens after the FDI has been explicitly
disabled.

> [drm:init_ring_common] *ERROR* failed to set render ring head to zero ctl=
 ffffffff head ffffffff tail ffffffff start ffffffff
> [drm:init_ring_common] *ERROR* render ring initialization failed ctl ffff=
ffff head ffffffff tail ffffffff start ffffffff
> [drm:init_ring_common] *ERROR* failed to set bsd ring head to zero ctl ff=
ffffff head ffffffff tail ffffffff start ffffffff
> [drm:init_ring_common] *ERROR* bsd ring initialization failed ctl fffffff=
f head ffffffff tail ffffffff start ffffffff
> [drm:i915_driver_load] *ERROR* failed to init modeset

That looks like the hardware just cannot be mapped at all.

> BUG: unable to handle kernel NULL pointer dereference at 0000000000000060

>  [<ffffffff81355191>] i915_gem_inactive_shrink+0x2b/0x18d

Failing to load, the i915 driver isn't cleaning up and is leaving its
shrinker in place. That part, at least, should be easy to fix. That
doesn't explain why the driver cannot access the hardware.

Here's a patch which cleans up a bunch of failure-path issues. It should
prevent the BUG, but it won't help load the driver on your hardware. I'd
like to see this patch tested and then we can go figure out why your
hardware doesn't work with the driver.

From=20138df88a83f36e3ba8709d7a8a88d3b536dbc70b Mon Sep 17 00:00:00 2001
From: Keith Packard <keithp@keithp.com>
Date: Sun, 10 Jul 2011 13:12:17 -0700
Subject: [PATCH] drm/i915: Clean up i915_driver_load failure path

i915_driver_load adds a write-combining MTRR region for the GTT
aperture to improve memory speeds through the aperture. If
i915_driver_load fails after this, it would not have cleaned up the
MTRR. This shouldn't cause any problems, except for consuming an MTRR
register. Still, it's best to clean up completely in the failure path,
which is easily done by calling mtrr_del if the mtrr was successfully
allocated.

i915_driver_load calls i915_gem_load which register
i915_gem_inactive_shrink. If i915_driver_load fails after calling
i915_gem_load, the shrinker will be left registered. When called, it
will access freed memory and crash. The fix is to unregister the shrinker i=
n the
failure path using code duplicated from i915_driver_unload.

After failing to initialize the GTT (which cannot happen, btw,
intel_gtt_get returns a fixed (non-NULL) value), it tries to free the
uninitialized WC IO mapping. Fixed this by changing the target from
out_iomapfree to out_rmmap

Signed-off-by: Keith Packard <keithp@keithp.com>
=2D--
 drivers/gpu/drm/i915/i915_dma.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dm=
a.c
index e178702..296fbd6 100644
=2D-- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1943,7 +1943,7 @@ int i915_driver_load(struct drm_device *dev, unsigned=
 long flags)
 	if (!dev_priv->mm.gtt) {
 		DRM_ERROR("Failed to initialize GTT\n");
 		ret =3D -ENODEV;
=2D		goto out_iomapfree;
+		goto out_rmmap;
 	}
=20
 	agp_size =3D dev_priv->mm.gtt->gtt_mappable_entries << PAGE_SHIFT;
@@ -1987,7 +1987,7 @@ int i915_driver_load(struct drm_device *dev, unsigned=
 long flags)
 	if (dev_priv->wq =3D=3D NULL) {
 		DRM_ERROR("Failed to create our workqueue.\n");
 		ret =3D -ENOMEM;
=2D		goto out_iomapfree;
+		goto out_mtrrfree;
 	}
=20
 	/* enable GEM by default */
@@ -2074,13 +2074,21 @@ int i915_driver_load(struct drm_device *dev, unsign=
ed long flags)
 	return 0;
=20
 out_gem_unload:
+	if (dev_priv->mm.inactive_shrinker.shrink)
+		unregister_shrinker(&dev_priv->mm.inactive_shrinker);
+
 	if (dev->pdev->msi_enabled)
 		pci_disable_msi(dev->pdev);
=20
 	intel_teardown_gmbus(dev);
 	intel_teardown_mchbar(dev);
 	destroy_workqueue(dev_priv->wq);
=2Dout_iomapfree:
+out_mtrrfree:
+	if (dev_priv->mm.gtt_mtrr >=3D 0) {
+		mtrr_del(dev_priv->mm.gtt_mtrr, dev->agp->base,
+			 dev->agp->agp_info.aper_size * 1024 * 1024);
+		dev_priv->mm.gtt_mtrr =3D -1;
+	}
 	io_mapping_free(dev_priv->mm.gtt_mapping);
 out_rmmap:
 	pci_iounmap(dev->pdev, dev_priv->regs);
=2D-=20
1.7.5.4

=20=20=20=20=20=20=20=20
=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFOGgsWQp8BWwlsTdMRAtsRAKCH+sFLEFtyXr9us8OYyKUAnKPzhwCfTOrY
H0UwC7zsiKGF5GVTTEmqD5g=
=wU10
-----END PGP SIGNATURE-----
--=-=-=--
