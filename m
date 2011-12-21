Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516Ab1LUDSP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 22:18:15 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:59094 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750703Ab1LUDSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 22:18:13 -0500
Date: Wed, 21 Dec 2011 14:18:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakob Bornecrantz <jakob@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Ville =?UTF-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-Id: <20111221141801.8791507b21aa3531bf59c42e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__21_Dec_2011_14_18_01_+1100_lAPFX=1tMNIAN3rw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__21_Dec_2011_14_18_01_+1100_lAPFX=1tMNIAN3rw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/vmwgfx/vmwgfx_kms.c between commit e7ac9211f29f ("vmwgfx:
Refactor kms code to use vmw_user_lookup_handle helper") from Linus' tree
and commit 308e5bcbdb10 ("drm: add an fb creation ioctl that takes a
pixel format v5") from the drm tree.

I fixed it up (I think - see below) and can carry the fix as necessary.

Dave, you might like to merge the branch you sent to Linus into your
drm-next branch to fix this up.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
index 8aa1dbb,1748a71..0000000
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@@ -1123,29 -1041,46 +1131,29 @@@ static struct drm_framebuffer *vmw_kms_
  		return ERR_PTR(-ENOENT);
  	}
 =20
 -	/**
 -	 * End conditioned code.
 -	 */
 -
 -	ret =3D vmw_user_surface_lookup_handle(dev_priv, tfile,
 -					     mode_cmd.handle, &surface);
 +	/* returns either a dmabuf or surface */
 +	ret =3D vmw_user_lookup_handle(dev_priv, tfile,
- 				     mode_cmd->handle,
++				     mode_cmd.handle,
 +				     &surface, &bo);
  	if (ret)
 -		goto try_dmabuf;
 -
 -	if (!surface->scanout)
 -		goto err_not_scanout;
 -
 -	ret =3D vmw_kms_new_framebuffer_surface(dev_priv, file_priv, surface,
 -					      &vfb, &mode_cmd);
 -
 -	/* vmw_user_surface_lookup takes one ref so does new_fb */
 -	vmw_surface_unreference(&surface);
 -
 -	if (ret) {
 -		DRM_ERROR("failed to create vmw_framebuffer: %i\n", ret);
 -		ttm_base_object_unref(&user_obj);
 -		return ERR_PTR(ret);
 -	} else
 -		vfb->user_obj =3D user_obj;
 -	return &vfb->base;
 -
 -try_dmabuf:
 -	DRM_INFO("%s: trying buffer\n", __func__);
 -
 -	ret =3D vmw_user_dmabuf_lookup(tfile, mode_cmd.handle, &bo);
 -	if (ret) {
 -		DRM_ERROR("failed to find buffer: %i\n", ret);
 -		return ERR_PTR(-ENOENT);
 -	}
 -
 -	ret =3D vmw_kms_new_framebuffer_dmabuf(dev_priv, bo, &vfb,
 -					     &mode_cmd);
 -
 -	/* vmw_user_dmabuf_lookup takes one ref so does new_fb */
 -	vmw_dmabuf_unreference(&bo);
 +		goto err_out;
 +
 +	/* Create the new framebuffer depending one what we got back */
 +	if (bo)
 +		ret =3D vmw_kms_new_framebuffer_dmabuf(dev_priv, bo, &vfb,
- 						     mode_cmd);
++						     &mode_cmd);
 +	else if (surface)
 +		ret =3D vmw_kms_new_framebuffer_surface(dev_priv, file_priv,
- 						      surface, &vfb, mode_cmd);
++						      surface, &vfb, &mode_cmd);
 +	else
 +		BUG();
 +
 +err_out:
 +	/* vmw_user_lookup_handle takes one ref so does new_fb */
 +	if (bo)
 +		vmw_dmabuf_unreference(&bo);
 +	if (surface)
 +		vmw_surface_unreference(&surface);
 =20
  	if (ret) {
  		DRM_ERROR("failed to create vmw_framebuffer: %i\n", ret);

--Signature=_Wed__21_Dec_2011_14_18_01_+1100_lAPFX=1tMNIAN3rw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO8U/pAAoJEECxmPOUX5FEbWEQAIDG7K+pcrC/krT2p8rl4BDV
Pyp2WMARFSD3yHMPRXomPezzHBCfv8r9TDQHObiK5yNlz72tW448tigbV+er9uVX
Q7TJ6xWM97UzunOLNIL9/wRQLWk8rEDb0V+UottLoO09LtRhH3sW/o3Pg+EyKwgT
7ItS0TNRNimfpz72QJDU0CzuvZehALy9BzPUPY+QuSOY0qcowX18nJ4p7Uo4NMO8
eDgu2Qyq3qSx6PErJbA+xOYRmIgWKiWvbzp5O4kUeS4/rvvJgYugVxQbCVFZIKzT
lRrZhH8x/zmhHBieLyJ5PsCbaxdUN4gOTq79VljShC+41brGnY9oW9a/1AAf8OOa
aDOrtZOldYXTug+3rTdJ9fgpbXku7LLn/HiuImVH/jWy4dzuzSiOegezC/nX8JsQ
Um8YPU9OGSwGfReFehCsjQKav/hFmybJ+ftFGbBz8Fe3s1UMBWYfYhi3gAQLvt4q
F5kN4WLnZc0XmxDM1GdFxdMfH2Gfc1oSTT8QMJvBvyk2TnIum+gG7wZYKqTVaDUp
lOcqY1WiOc75AELRJ1MST7Bej8kskTN5BYrjSDI0Cs6fifxQomB4Qh6GmLrBWEqB
1a/ddN+vehneRkZK7oI+6zd9mQ2QVmjRc7SFdW+9BzWrqxHPAlFwGStwElu0Bar6
yYeqGHgIIRqLCC2n0kAV
=U3Xo
-----END PGP SIGNATURE-----

--Signature=_Wed__21_Dec_2011_14_18_01_+1100_lAPFX=1tMNIAN3rw--
