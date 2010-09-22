Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787Ab0IVEtd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 00:49:33 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47980 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab0IVEtc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 00:49:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=t5fBllQEw1iUVUPRmmgEQfPapOEhINbqM/whNdBzwUs3QZBqWJ0jrXVhEF+eGXbO2X
         Od7riyC8CAYHrajLHIUO9mRL9u8gpLDmEdNTSASFMVbv9+pXdlFvjts9hnTkJaoaXFUG
         WAP0ob2uJe8PgpirbHrkKxvspIl3N2xuetWrc=
MIME-Version: 1.0
In-Reply-To: <AANLkTikCHktMEKu_RfNCS4=jYf-Y5c871axmNRJFhr8a@mail.gmail.com>
References: <AANLkTikCHktMEKu_RfNCS4=jYf-Y5c871axmNRJFhr8a@mail.gmail.com>
Date: Wed, 22 Sep 2010 00:49:27 -0400
Message-ID: <AANLkTinzTePAhfqCcqua97_+M9kRWCzpWD6g3=oYc+cN@mail.gmail.com>
Subject: Re: [2.6.36-rc5] DRM resource leak fixes...
From: Alex Deucher <alexdeucher@gmail.com>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 21, 2010 at 12:55 PM, Daniel J Blueman
<daniel.blueman@gmail.com> wrote:
> Hi Alex; for your review:
>
> Fix up some indirect and scratch buffer leaks, and correctly release a
> buffer object along various error paths.

These look good to me.

Reviewed-by: Alex Deucher <alexdeucher@gmail.com>

>
> diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
> index e817a0b..5a7d6a0 100644
> --- a/drivers/gpu/drm/radeon/r100.c
> +++ b/drivers/gpu/drm/radeon/r100.c
> @@ -3540,9 +3540,9 @@ int r100_ib_test(struct radeon_device *rdev)
>        }
>        WREG32(scratch, 0xCAFEDEAD);
>        r = radeon_ib_get(rdev, &ib);
> -       if (r) {
> -               return r;
> -       }
> +       if (r)
> +               goto out2;
> +
>        ib->ptr[0] = PACKET0(scratch, 0);
>        ib->ptr[1] = 0xDEADBEEF;
>        ib->ptr[2] = PACKET2(0);
> @@ -3553,15 +3553,13 @@ int r100_ib_test(struct radeon_device *rdev)
>        ib->ptr[7] = PACKET2(0);
>        ib->length_dw = 8;
>        r = radeon_ib_schedule(rdev, ib);
> -       if (r) {
> -               radeon_scratch_free(rdev, scratch);
> -               radeon_ib_free(rdev, &ib);
> -               return r;
> -       }
> +       if (r)
> +               goto out1;
> +
>        r = radeon_fence_wait(ib->fence, false);
> -       if (r) {
> -               return r;
> -       }
> +       if (r)
> +               goto out1;
> +
>        for (i = 0; i < rdev->usec_timeout; i++) {
>                tmp = RREG32(scratch);
>                if (tmp == 0xDEADBEEF) {
> @@ -3576,8 +3574,10 @@ int r100_ib_test(struct radeon_device *rdev)
>                          scratch, tmp);
>                r = -EINVAL;
>        }
> -       radeon_scratch_free(rdev, scratch);
> +out1:
>        radeon_ib_free(rdev, &ib);
> +out2:
> +       radeon_scratch_free(rdev, scratch);
>        return r;
>  }
>
> diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
> index afc18d8..bfdfa3e 100644
> --- a/drivers/gpu/drm/radeon/r600.c
> +++ b/drivers/gpu/drm/radeon/r600.c
> @@ -2689,7 +2689,7 @@ int r600_ib_test(struct radeon_device *rdev)
>        r = radeon_ib_get(rdev, &ib);
>        if (r) {
>                DRM_ERROR("radeon: failed to get ib (%d).\n", r);
> -               return r;
> +               goto out2;
>        }
>        ib->ptr[0] = PACKET3(PACKET3_SET_CONFIG_REG, 1);
>        ib->ptr[1] = ((scratch - PACKET3_SET_CONFIG_REG_OFFSET) >> 2);
> @@ -2710,15 +2710,13 @@ int r600_ib_test(struct radeon_device *rdev)
>        ib->length_dw = 16;
>        r = radeon_ib_schedule(rdev, ib);
>        if (r) {
> -               radeon_scratch_free(rdev, scratch);
> -               radeon_ib_free(rdev, &ib);
>                DRM_ERROR("radeon: failed to schedule ib (%d).\n", r);
> -               return r;
> +               goto out1;
>        }
>        r = radeon_fence_wait(ib->fence, false);
>        if (r) {
>                DRM_ERROR("radeon: fence wait failed (%d).\n", r);
> -               return r;
> +               goto out1;
>        }
>        for (i = 0; i < rdev->usec_timeout; i++) {
>                tmp = RREG32(scratch);
> @@ -2733,8 +2731,10 @@ int r600_ib_test(struct radeon_device *rdev)
>                          scratch, tmp);
>                r = -EINVAL;
>        }
> -       radeon_scratch_free(rdev, scratch);
> +out1:
>        radeon_ib_free(rdev, &ib);
> +out2:
> +       radeon_scratch_free(rdev, scratch);
>        return r;
>  }
>
> diff --git a/drivers/gpu/drm/radeon/r600_blit_kms.c
> b/drivers/gpu/drm/radeon/r600_blit_kms.c
> index d13622a..e532a81 100644
> --- a/drivers/gpu/drm/radeon/r600_blit_kms.c
> +++ b/drivers/gpu/drm/radeon/r600_blit_kms.c
> @@ -492,6 +492,7 @@ int r600_blit_init(struct radeon_device *rdev)
>        r = radeon_bo_kmap(rdev->r600_blit.shader_obj, &ptr);
>        if (r) {
>                DRM_ERROR("failed to map blit object %d\n", r);
> +               radeon_bo_unreserve(rdev->r600_blit.shader_obj);
>                return r;
>        }
>        if (rdev->family >= CHIP_RV770)
> --
> Daniel J Blueman
>
