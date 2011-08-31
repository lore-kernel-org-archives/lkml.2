Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab1HaCJH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 22:09:07 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:53698 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775Ab1HaCJF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 22:09:05 -0400
Date: Tue, 30 Aug 2011 22:06:52 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Rob Clark <robdclark@gmail.com>
Cc: Inki Dae <inki.dae@samsung.com>, sw0312.kim@samsung.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        kyungmin.park@samsung.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC][PATCH v3] DRM: add DRM Driver for Samsung SoC EXYNOS4210.
Message-ID: <20110831020652.GA16547@dumpdata.com>
References: <1314359274-21585-1-git-send-email-inki.dae@samsung.com>
 <CAF6AEGu3ss-rJC28H1rm2GWLm1bAZnHLftXfMLJQNeqjBt3umQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <CAF6AEGu3ss-rJC28H1rm2GWLm1bAZnHLftXfMLJQNeqjBt3umQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4E5D9777.0043:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +       entry->vaddr = dma_alloc_writecombine(dev->dev, entry->size,
> > +                       (dma_addr_t *)&entry->paddr, GFP_KERNEL);
> > +       if (!entry->paddr) {
> > +               DRM_ERROR("failed to allocate buffer.\n");
> > +               return -ENOMEM;
> > +       }
> > +
> > +       DRM_DEBUG_KMS("allocated : vaddr(0x%x), paddr(0x%x), size(0x%x)\n",
> > +                       (unsigned int)entry->vaddr, entry->paddr, entry->size);
> > +
> > +       return 0;
> > +}
> > +
> [snip]
> 
> > diff --git a/drivers/gpu/drm/samsung/samsung_drm_buf.h b/drivers/gpu/drm/samsung/samsung_drm_buf.h
> > new file mode 100644
> > index 0000000..d6a7e95
> > --- /dev/null
> > +++ b/drivers/gpu/drm/samsung/samsung_drm_buf.h
> [snip]
> > +/**
> > + * samsung drm buffer entry structure.
> > + *
> > + * @paddr: physical address of allocated memory.
> > + * @vaddr: kernel virtual address of allocated memory.
> > + * @size: size of allocated memory.
> > + */
> > +struct samsung_drm_buf_entry {
> > +       unsigned int paddr;

This could be made 'dma_addr_t' and then you can drop all of the
casts to (dma_addr_t *).

.. snip..
> > +static int samsung_drm_connector_get_modes(struct drm_connector *connector)

Why not make the return be 'unsigned int'? 

.. snip..
> > +/* get detection status of display device. */
> > +static enum drm_connector_status
> > +samsung_drm_connector_detect(struct drm_connector *connector, bool force)
> > +{
> > +       struct samsung_drm_connector *samsung_connector =
> > +               to_samsung_connector(connector);
> > +       struct samsung_drm_display *display =
> > +               samsung_drm_get_manager(samsung_connector->encoder)->display;
> > +       unsigned int ret = connector_status_unknown;

Not 'enum drm_connector_status ret = connector_status_unknown' ?

> > +
> > +       DRM_DEBUG_KMS("%s\n", __FILE__);
> > +
> > +       if (display && display->is_connected) {
> > +               if (display->is_connected())
> > +                       ret = connector_status_connected;
> > +               else
> > +                       ret = connector_status_disconnected;
> > +       }
> > +
> > +       return ret;
> > +}

.. snip..
> > +static void samsung_drm_fb_destroy(struct drm_framebuffer *fb)
> > +{
> > +       struct samsung_drm_fb *samsung_fb = to_samsung_fb(fb);
> > +       int ret;

Get rid of 'ret'
> > +
> > +       DRM_DEBUG_KMS("%s\n", __FILE__);
> > +
> > +       drm_framebuffer_cleanup(fb);
> > +
> > +       if (samsung_fb->is_default) {
> > +               ret = drm_gem_handle_delete(samsung_fb->file_priv,
> > +                               samsung_fb->gem_handle);
> 
> why not keep the gem buffer ptr, and do something like:
> 
>   drm_gem_object_unreference_unlocked(samsung_fb->bo)..
> 
> this way, you get the right behavior if someone somewhere else took a
> ref to the gem buffer object?  And it avoids needing to keep the
> file_priv ptr in the fb (which seems a bit strange)
> 
> 
> > +               if (ret < 0)
> > +                       DRM_ERROR("failed to delete drm_gem_handle.\n");

And just do the check on the function return value here. You are not using
the 'ret' for anything.
> > +       }
> > +
> > +       kfree(samsung_fb);
> > +}
> > +
> [snip]

Hm, so I stopped here - just realized that I am missing some of the code
and I should look at the original patch..

