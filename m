Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932389Ab1IANGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 09:06:31 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:30090 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932186Ab1IANGa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 09:06:30 -0400
X-AuditID: cbfee61a-b7cf1ae00000208e-3d-4e5f8353de2e
Date: Thu, 01 Sep 2011 22:06:05 +0900
From: Inki Dae <inki.dae@samsung.com>
Subject: RE: [RFC][PATCH v3] DRM: add DRM Driver for Samsung SoC EXYNOS4210.
In-reply-to: <CAF6AEGsqbFcS_QwihrjpVLQK1Y+h1iJSyu+GFV0Govp3XHYbOw@mail.gmail.com>
To: "'Rob Clark'" <robdclark@gmail.com>
Cc: airlied@linux.ie, dri-devel@lists.freedesktop.org, sw0312.kim@samsung.com,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        linux-arm-kernel@lists.infradead.org
Message-id: <003501cc68a7$e8935aa0$b9ba0fe0$%dae@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=ISO-8859-1
Content-language: ko
Content-transfer-encoding: 8BIT
Thread-index: Acxn91gga6tU4GECQsywEcibRDUs4wAqbOyw
References: <1314359274-21585-1-git-send-email-inki.dae@samsung.com>
 <CAF6AEGu3ss-rJC28H1rm2GWLm1bAZnHLftXfMLJQNeqjBt3umQ@mail.gmail.com>
 <001001cc67aa$72760460$57620d20$%dae@samsung.com>
 <CAF6AEGsqbFcS_QwihrjpVLQK1Y+h1iJSyu+GFV0Govp3XHYbOw@mail.gmail.com>
X-OriginalArrivalTime: 01 Sep 2011 13:07:04.0354 (UTC)
 FILETIME=[0B7E9020:01CC68A8]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rob.
Below is my comments. thank you.

> -----Original Message-----
> From: Rob Clark [mailto:robdclark@gmail.com]
> Sent: Thursday, September 01, 2011 1:02 AM
> To: Inki Dae
> Cc: airlied@linux.ie; dri-devel@lists.freedesktop.org;
> sw0312.kim@samsung.com; linux-kernel@vger.kernel.org;
> kyungmin.park@samsung.com; linux-arm-kernel@lists.infradead.org
> Subject: Re: [RFC][PATCH v3] DRM: add DRM Driver for Samsung SoC
> EXYNOS4210.
> 
> On Wed, Aug 31, 2011 at 1:51 AM, Inki Dae <inki.dae@samsung.com> wrote:
> > Hello, Rob.
> > Below is my answers and questions. and could you please include me as CC
> > when you post your driver?
> 
> sure thing
> 
> 
> >> > +static int samsung_drm_connector_get_modes(struct drm_connector
> >> *connector)
> >> > +{
> >> > +       struct samsung_drm_connector *samsung_connector =
> >> > +               to_samsung_connector(connector);
> >> > +       struct samsung_drm_display *display =
> >> > +               samsung_drm_get_manager(samsung_connector->encoder)-
> >> >display;
> >> > +       unsigned int count;
> >> > +
> >> > +       DRM_DEBUG_KMS("%s\n", __FILE__);
> >> > +
> >> > +       if (display && display->get_edid) {
> >> > +               void *edid = kzalloc(MAX_EDID, GFP_KERNEL);
> >> > +               if (!edid) {
> >> > +                       DRM_ERROR("failed to allocate edid\n");
> >> > +                       return 0;
> >> > +               }
> >> > +
> >> > +               display->get_edid(connector, edid, MAX_EDID);
> >> > +
> >> > +               drm_mode_connector_update_edid_property(connector,
> > edid);
> >> > +               count = drm_add_edid_modes(connector, edid);
> >> > +
> >> > +               kfree(connector->display_info.raw_edid);
> >> > +               connector->display_info.raw_edid = edid;
> >> > +       } else {
> >> > +               struct drm_display_mode *mode =
> > drm_mode_create(connector-
> >> >dev);
> >> > +               struct fb_videomode *timing;
> >> > +
> >> > +               if (display && display->get_timing)
> >> > +                       timing = display->get_timing();
> >>
> >> also seems a bit weird to not do: display->get_timings(display)..
> >>
> >> maybe you don't have the case of multiple instances of the same
> >> display time.. but maybe someday you need that.  (Maybe this is just
> >> an artifact of how the API of your current lower layer driver is.. but
> >> maybe now is a good time to think about those APIs)
> >>
> >
> > display is static object set by hardware specific driver such as display
> > controller or hdmi. each hardware specific driver has their own display
> > object statically. You can refer to the definition in
samsung_drm_fimd.c.
> > and I understood a encoder and a connector is 1:1 relationship, when any
> > hardware specific driver is probed, they would be created with a manager
> > that includes their own display object as pointer. Could you please give
> me
> > more comments why display object should be considered for multiple
> > instances? I am afraid there is any part I don't care.
> >
> > thank you.
> 
> Just thinking hypothetically.. what if some future device had two hdmi
> controllers.  Then you'd want two instances of the same display
> object.
> 
> Although it seems this API is just internal to the DRM driver (which I
> had not realized earlier), so it should be pretty easy to change later
> if needed.
> 

You are right. I guess we should consider multiple instances to display
object because the Exynos hardware has two display controllers and also each
display controller needs one display panel with sharing same driver. thank
you for your pointing. :)

> 
> >> > +static void samsung_drm_connector_destroy(struct drm_connector
> >> *connector)
> >> > +{
> >> > +       struct samsung_drm_connector *samsung_connector =
> >> > +               to_samsung_connector(connector);
> >> > +
> >> > +       DRM_DEBUG_KMS("%s\n", __FILE__);
> >> > +
> >> > +       drm_sysfs_connector_remove(connector);
> >> > +       drm_connector_cleanup(connector);
> >> > +       connector->dev->mode_config.num_connector--;
> >>
> >> I wonder if num_connector-- should be in drm_connector_cleanup()..
> >>
> >> I missed this in OMAP driver, but it seems that none of the other drm
> >> drivers are directly decrementing this.. and it would seem more
> >> symmetric for it to be in drm_connector_cleanup().  But would be
> >
> > For this, it was already commented by Joonyoun Shim.
> 
> And it seems (which I hadn't noticed earlier) already merged :-)
> 
> So I think this (and similar bit in encoder destructor) can be removed
> 
> 
> >> > +static void samsung_drm_fb_destroy(struct drm_framebuffer *fb)
> >> > +{
> >> > +       struct samsung_drm_fb *samsung_fb = to_samsung_fb(fb);
> >> > +       int ret;
> >> > +
> >> > +       DRM_DEBUG_KMS("%s\n", __FILE__);
> >> > +
> >> > +       drm_framebuffer_cleanup(fb);
> >> > +
> >> > +       if (samsung_fb->is_default) {
> >> > +               ret = drm_gem_handle_delete(samsung_fb->file_priv,
> >> > +                               samsung_fb->gem_handle);
> >>
> >> why not keep the gem buffer ptr, and do something like:
> >>
> >>   drm_gem_object_unreference_unlocked(samsung_fb->bo)..
> >>
> >> this way, you get the right behavior if someone somewhere else took a
> >> ref to the gem buffer object?  And it avoids needing to keep the
> >> file_priv ptr in the fb (which seems a bit strange)
> >>
> >>
> > Yes, at booting time, one gem object is created. this is for linux
> > framebuffer and used as default buffer. register_framebuffer function is
> > called one time at booting time by drm driver. but when this driver is
> built
> > as modules, this gem object should be released with rmmod modules. and
> the
> > reason fb has file point is that drm_gem_handle_delete requests it to
> > release a gem object. our driver considered modularization also. If
> there is
> > any point I missed, give me any comment please. Thank you.
> 
> Oh, I missed the point that drm_gem_handle_delete() is calling
> drm_gem_object_unreference_unlocked().
> 
> But this still seems a bit odd, but I guess the difference is you are
> keeping the buffer handle, rather than the 'struct drm_gem_object'
> ptr.  I'm not sure if there is a point to keeping track of the buffer
> in handle form on the kernel side.  If instead you just keep a GEM
> object ptr, you can just drm_gem_object_unreference{_unlocked}() when
> you are done with it without having to special-case is_default stuff.

Ah, I found a problem through you. default framebuffer never has a gem
handle but only a buffer object. and as you mentioned, that isn't clear to
me also. I will consider better way. Thank you.

> 
> >> > +struct samsung_drm_gem_obj *
> >> > +               find_samsung_drm_gem_object(struct drm_file
*file_priv,
> >> > +                       struct drm_device *dev, unsigned int handle)
> >> > +{
> >> > +       struct drm_gem_object *gem_obj;
> >> > +
> >> > +       gem_obj = drm_gem_object_lookup(dev, file_priv, handle);
> >> > +       if (!gem_obj) {
> >> > +               DRM_LOG_KMS("a invalid gem object not registered to
> >> lookup.\n");
> >> > +               return NULL;
> >> > +       }
> >> > +
> >> > +       /**
> >> > +        * unreference refcount of the gem object.
> >> > +        * at drm_gem_object_lookup(), the gem object was referenced.
> >> > +        */
> >> > +       drm_gem_object_unreference(gem_obj);
> >>
> >> this doesn't seem right, to drop the reference before you use the
> >> buffer elsewhere..
> >>
> > No, see drm_gem_object_lookup fxn. at this function, if there is a
> object
> > found then drm_gem_object_reference is called to increase refcount of
> this
> > object. if there is any missing point, give me any comment please. thank
> > you.
> 
> 
> Right, but I think there is a reason it takes a reference... so that
> the object doesn't get free'd from under your feet.  So pattern
> should, I think, be:
> 
>   obj = lookup(...);
>   ... do stuff w/ obj ...
>   unreference(obj)
> 
> so the caller who is using the looked up obj should unref it when done
> 
> Instead, you have:
> 
>   obj = lookup(...);
>   unreference(obj);
>   ... do stuff w/ obj ...
> 
> 

Generally right, but in this case, it is just used to get specific gem
object through find_samsung_drm_gem_object() so doesn't reference this gem
object anywhere. 
therefore reference and unreference should be done within
find_samsung_drm_gem_object(). if there is any point I missed then let me
know please. thank you.

> BR,
> -R

