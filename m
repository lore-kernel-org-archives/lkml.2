Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757949Ab0GTRhh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 13:37:37 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56463 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962Ab0GTRhg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 13:37:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uKNk/qwrhMoiexjD7ZIoCY2/sAhQ+KFwLpPK7YjkfXpR3uehjtwZ/eSDy+N0V/jwQJ
         HSQqpKKAX9K4CU9kLUdJB44mQy5uOz5TiTyY/8Pp/mv++dJygQF2CLjaU1WbxENgukds
         13TlJNsC84UqgjbbZxzvq/CqMJ/eLgLaJyx3s=
MIME-Version: 1.0
In-Reply-To: <20100720014251.46b91cdd@mad-cat.localdomain>
References: <20100720014251.46b91cdd@mad-cat.localdomain>
Date: Tue, 20 Jul 2010 13:37:23 -0400
Message-ID: <AANLkTilKlM9NyGgBom7ncq4cNx1O_GtS1dgsMExwdck3@mail.gmail.com>
Subject: Re: drivers/gpu/drm/radeon/r600_blit.c: fix possible NULL pointer 
	derefernce
From: Alex Deucher <alexdeucher@gmail.com>
To: "Alexander Y. Fomichev" <git.user@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>, Robert Noland <rnoland@2hip.net>,
        Matt Turner <mattst88@gmail.com>, Jerome Glisse <jglisse@redhat.com>,
        akpm@linux-foundation.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 19, 2010 at 5:42 PM, Alexander Y. Fomichev
<git.user@gmail.com> wrote:
> This patch fix possible NULL pointer dereference when
> r600_prepare_blit_copy tries to fill dev_priv->blit_vb->file_priv
> without check of dev_priv->blit_vb. dev_priv->blit_vb should be
> filled by r600_nomm_get_vb but latest can fail with EAGAIN.
> Addresses: https://bugzilla.kernel.org/show_bug.cgi?id=16375
>
> ---
>  drivers/gpu/drm/radeon/r600_blit.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/gpu/drm/radeon/r600_blit.c b/drivers/gpu/drm/radeon/r600_blit.c
> index f4fb88e..0df4a2b 100644
> --- a/drivers/gpu/drm/radeon/r600_blit.c
> +++ b/drivers/gpu/drm/radeon/r600_blit.c
> @@ -541,6 +541,8 @@ r600_prepare_blit_copy(struct drm_device *dev, struct drm_file *file_priv)
>        DRM_DEBUG("\n");
>
>        r600_nomm_get_vb(dev);
> +       if (!dev_priv->blit_vb)
> +               return;

r600_prepare_blit_copy returns an int so something like this would be better:
--- a/drivers/gpu/drm/radeon/r600_blit.c
+++ b/drivers/gpu/drm/radeon/r600_blit.c
@@ -539,8 +539,10 @@ r600_prepare_blit_copy(struct drm_device *dev,
struct drm_file *file_priv)
 {
        drm_radeon_private_t *dev_priv = dev->dev_private;
        DRM_DEBUG("\n");
+       int ret = r600_nomm_get_vb(dev);

-       r600_nomm_get_vb(dev);
+       if (ret)
+               return ret;

        dev_priv->blit_vb->file_priv = file_priv;


Alex

>
>        dev_priv->blit_vb->file_priv = file_priv;
>
> --
> 1.7.1.1
>
