Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085Ab0EKTXG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 15:23:06 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45057 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab0EKTXD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 15:23:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oGCtzVnWTvrN7KFrCF5P++4u9knSZkBaWvNVRtpQ3WVLJeJI56q35gi+4zaTyK4Rbf
         fFb6+pB/WC2TT5QMFg/GwvHBrLOS2iy6teOWy06cs25RMCH9CKXf+hnRoWP6wWul7rJ7
         WWnAqAlyFSj1UvTHR89YcGq0nprtXbGsKSfww=
MIME-Version: 1.0
In-Reply-To: <1273602134-6359-1-git-send-email-chris@chris-wilson.co.uk>
References: <0100511104818.8382a7de.akpm@linux-foundation.org>
	 <1273602134-6359-1-git-send-email-chris@chris-wilson.co.uk>
Date: Wed, 12 May 2010 00:52:56 +0530
Message-ID: <AANLkTimglAyS94q0Y3DEx9RROPxus-7l3OfF2_b-zAR3@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: Record error batch buffers using iomem
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: intel-gfx@lists.freedesktop.org, Andrew Morton <akpm@linux-foundation.org>,
       dri-devel@lists.freedesktop.org, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Chris and Andrew,

On Tue, May 11, 2010 at 11:52 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> Directly read the GTT mapping for the contents of the batch buffers
> rather than relying on possibly stale CPU caches. Also for completeness
> scan the flushing/inactive lists for the current buffers - we are
> collecting error state after all.
>
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>

Yes, I have tested this patch.

I booted 3 times, and this patch fixes the DRM as well as softirq
warnings and I am getting Xwindows with this patch.

I am still doing more testing.

Thanks,
--
Jaswinder Singh.
> ---
>  drivers/gpu/drm/i915/i915_irq.c |   64 ++++++++++++++++++++++++++++++++++----
>  1 files changed, 57 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/i915_irq.c b/drivers/gpu/drm/i915/i915_irq.c
> index 87113da..14301a4 100644
> --- a/drivers/gpu/drm/i915/i915_irq.c
> +++ b/drivers/gpu/drm/i915/i915_irq.c
> @@ -441,9 +441,11 @@ static struct drm_i915_error_object *
>  i915_error_object_create(struct drm_device *dev,
>                         struct drm_gem_object *src)
>  {
> +       drm_i915_private_t *dev_priv = dev->dev_private;
>        struct drm_i915_error_object *dst;
>        struct drm_i915_gem_object *src_priv;
>        int page, page_count;
> +       u32 reloc_offset;
>
>        if (src == NULL)
>                return NULL;
> @@ -458,14 +460,23 @@ i915_error_object_create(struct drm_device *dev,
>        if (dst == NULL)
>                return NULL;
>
> +       reloc_offset = src_priv->gtt_offset;
>        for (page = 0; page < page_count; page++) {
> -               void *s, *d = kmalloc(PAGE_SIZE, GFP_ATOMIC);
> +               void __iomem *s;
> +               void *d;
> +
> +               d = kmalloc(PAGE_SIZE, GFP_ATOMIC);
>                if (d == NULL)
>                        goto unwind;
> -               s = kmap_atomic(src_priv->pages[page], KM_USER0);
> -               memcpy(d, s, PAGE_SIZE);
> -               kunmap_atomic(s, KM_USER0);
> +
> +               s = io_mapping_map_atomic_wc(dev_priv->mm.gtt_mapping,
> +                                            reloc_offset);
> +               memcpy_fromio(d, s, PAGE_SIZE);
> +               io_mapping_unmap_atomic(s);
> +
>                dst->pages[page] = d;
> +
> +               reloc_offset += PAGE_SIZE;
>        }
>        dst->page_count = page_count;
>        dst->gtt_offset = src_priv->gtt_offset;
> @@ -621,18 +632,57 @@ static void i915_capture_error_state(struct drm_device *dev)
>
>                if (batchbuffer[1] == NULL &&
>                    error->acthd >= obj_priv->gtt_offset &&
> -                   error->acthd < obj_priv->gtt_offset + obj->size &&
> -                   batchbuffer[0] != obj)
> +                   error->acthd < obj_priv->gtt_offset + obj->size)
>                        batchbuffer[1] = obj;
>
>                count++;
>        }
> +       /* Scan the other lists for completeness for those bizarre errors. */
> +       if (batchbuffer[0] == NULL || batchbuffer[1] == NULL) {
> +               list_for_each_entry(obj_priv, &dev_priv->mm.flushing_list, list) {
> +                       struct drm_gem_object *obj = obj_priv->obj;
> +
> +                       if (batchbuffer[0] == NULL &&
> +                           bbaddr >= obj_priv->gtt_offset &&
> +                           bbaddr < obj_priv->gtt_offset + obj->size)
> +                               batchbuffer[0] = obj;
> +
> +                       if (batchbuffer[1] == NULL &&
> +                           error->acthd >= obj_priv->gtt_offset &&
> +                           error->acthd < obj_priv->gtt_offset + obj->size)
> +                               batchbuffer[1] = obj;
> +
> +                       if (batchbuffer[0] && batchbuffer[1])
> +                               break;
> +               }
> +       }
> +       if (batchbuffer[0] == NULL || batchbuffer[1] == NULL) {
> +               list_for_each_entry(obj_priv, &dev_priv->mm.inactive_list, list) {
> +                       struct drm_gem_object *obj = obj_priv->obj;
> +
> +                       if (batchbuffer[0] == NULL &&
> +                           bbaddr >= obj_priv->gtt_offset &&
> +                           bbaddr < obj_priv->gtt_offset + obj->size)
> +                               batchbuffer[0] = obj;
> +
> +                       if (batchbuffer[1] == NULL &&
> +                           error->acthd >= obj_priv->gtt_offset &&
> +                           error->acthd < obj_priv->gtt_offset + obj->size)
> +                               batchbuffer[1] = obj;
> +
> +                       if (batchbuffer[0] && batchbuffer[1])
> +                               break;
> +               }
> +       }
>
>        /* We need to copy these to an anonymous buffer as the simplest
>         * method to avoid being overwritten by userpace.
>         */
>        error->batchbuffer[0] = i915_error_object_create(dev, batchbuffer[0]);
> -       error->batchbuffer[1] = i915_error_object_create(dev, batchbuffer[1]);
> +       if (batchbuffer[1] != batchbuffer[0])
> +               error->batchbuffer[1] = i915_error_object_create(dev, batchbuffer[1]);
> +       else
> +               error->batchbuffer[1] = NULL;
>
>        /* Record the ringbuffer */
>        error->ringbuffer = i915_error_object_create(dev, dev_priv->ring.ring_obj);
> --
> 1.7.1
>
>
