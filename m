Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab1HaQCM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 12:02:12 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36645 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755787Ab1HaQCI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 12:02:08 -0400
MIME-Version: 1.0
In-Reply-To: <001001cc67aa$72760460$57620d20$%dae@samsung.com>
References: <1314359274-21585-1-git-send-email-inki.dae@samsung.com>
	<CAF6AEGu3ss-rJC28H1rm2GWLm1bAZnHLftXfMLJQNeqjBt3umQ@mail.gmail.com>
	<001001cc67aa$72760460$57620d20$%dae@samsung.com>
Date: Wed, 31 Aug 2011 11:02:07 -0500
Message-ID: <CAF6AEGsqbFcS_QwihrjpVLQK1Y+h1iJSyu+GFV0Govp3XHYbOw@mail.gmail.com>
Subject: Re: [RFC][PATCH v3] DRM: add DRM Driver for Samsung SoC EXYNOS4210.
From: Rob Clark <robdclark@gmail.com>
To: Inki Dae <inki.dae@samsung.com>
Cc: airlied@linux.ie, dri-devel@lists.freedesktop.org, sw0312.kim@samsung.com,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 31, 2011 at 1:51 AM, Inki Dae <inki.dae@samsung.com> wrote:
> Hello, Rob.
> Below is my answers and questions. and could you please include me as CC
> when you post your driver?

sure thing


>> > +static int samsung_drm_connector_get_modes(struct drm_connector
>> *connector)
>> > +{
>> > +       struct samsung_drm_connector *samsung_connector =
>> > +               to_samsung_connector(connector);
>> > +       struct samsung_drm_display *display =
>> > +               samsung_drm_get_manager(samsung_connector->encoder)-
>> >display;
>> > +       unsigned int count;
>> > +
>> > +       DRM_DEBUG_KMS("%s\n", __FILE__);
>> > +
>> > +       if (display && display->get_edid) {
>> > +               void *edid = kzalloc(MAX_EDID, GFP_KERNEL);
>> > +               if (!edid) {
>> > +                       DRM_ERROR("failed to allocate edid\n");
>> > +                       return 0;
>> > +               }
>> > +
>> > +               display->get_edid(connector, edid, MAX_EDID);
>> > +
>> > +               drm_mode_connector_update_edid_property(connector,
> edid);
>> > +               count = drm_add_edid_modes(connector, edid);
>> > +
>> > +               kfree(connector->display_info.raw_edid);
>> > +               connector->display_info.raw_edid = edid;
>> > +       } else {
>> > +               struct drm_display_mode *mode =
> drm_mode_create(connector-
>> >dev);
>> > +               struct fb_videomode *timing;
>> > +
>> > +               if (display && display->get_timing)
>> > +                       timing = display->get_timing();
>>
>> also seems a bit weird to not do: display->get_timings(display)..
>>
>> maybe you don't have the case of multiple instances of the same
>> display time.. but maybe someday you need that.  (Maybe this is just
>> an artifact of how the API of your current lower layer driver is.. but
>> maybe now is a good time to think about those APIs)
>>
>
> display is static object set by hardware specific driver such as display
> controller or hdmi. each hardware specific driver has their own display
> object statically. You can refer to the definition in samsung_drm_fimd.c.
> and I understood a encoder and a connector is 1:1 relationship, when any
> hardware specific driver is probed, they would be created with a manager
> that includes their own display object as pointer. Could you please give me
> more comments why display object should be considered for multiple
> instances? I am afraid there is any part I don't care.
>
> thank you.

Just thinking hypothetically.. what if some future device had two hdmi
controllers.  Then you'd want two instances of the same display
object.

Although it seems this API is just internal to the DRM driver (which I
had not realized earlier), so it should be pretty easy to change later
if needed.


>> > +static void samsung_drm_connector_destroy(struct drm_connector
>> *connector)
>> > +{
>> > +       struct samsung_drm_connector *samsung_connector =
>> > +               to_samsung_connector(connector);
>> > +
>> > +       DRM_DEBUG_KMS("%s\n", __FILE__);
>> > +
>> > +       drm_sysfs_connector_remove(connector);
>> > +       drm_connector_cleanup(connector);
>> > +       connector->dev->mode_config.num_connector--;
>>
>> I wonder if num_connector-- should be in drm_connector_cleanup()..
>>
>> I missed this in OMAP driver, but it seems that none of the other drm
>> drivers are directly decrementing this.. and it would seem more
>> symmetric for it to be in drm_connector_cleanup().  But would be
>
> For this, it was already commented by Joonyoun Shim.

And it seems (which I hadn't noticed earlier) already merged :-)

So I think this (and similar bit in encoder destructor) can be removed


>> > +static void samsung_drm_fb_destroy(struct drm_framebuffer *fb)
>> > +{
>> > +       struct samsung_drm_fb *samsung_fb = to_samsung_fb(fb);
>> > +       int ret;
>> > +
>> > +       DRM_DEBUG_KMS("%s\n", __FILE__);
>> > +
>> > +       drm_framebuffer_cleanup(fb);
>> > +
>> > +       if (samsung_fb->is_default) {
>> > +               ret = drm_gem_handle_delete(samsung_fb->file_priv,
>> > +                               samsung_fb->gem_handle);
>>
>> why not keep the gem buffer ptr, and do something like:
>>
>>   drm_gem_object_unreference_unlocked(samsung_fb->bo)..
>>
>> this way, you get the right behavior if someone somewhere else took a
>> ref to the gem buffer object?  And it avoids needing to keep the
>> file_priv ptr in the fb (which seems a bit strange)
>>
>>
> Yes, at booting time, one gem object is created. this is for linux
> framebuffer and used as default buffer. register_framebuffer function is
> called one time at booting time by drm driver. but when this driver is built
> as modules, this gem object should be released with rmmod modules. and the
> reason fb has file point is that drm_gem_handle_delete requests it to
> release a gem object. our driver considered modularization also. If there is
> any point I missed, give me any comment please. Thank you.

Oh, I missed the point that drm_gem_handle_delete() is calling
drm_gem_object_unreference_unlocked().

But this still seems a bit odd, but I guess the difference is you are
keeping the buffer handle, rather than the 'struct drm_gem_object'
ptr.  I'm not sure if there is a point to keeping track of the buffer
in handle form on the kernel side.  If instead you just keep a GEM
object ptr, you can just drm_gem_object_unreference{_unlocked}() when
you are done with it without having to special-case is_default stuff.

>> > +struct samsung_drm_gem_obj *
>> > +               find_samsung_drm_gem_object(struct drm_file *file_priv,
>> > +                       struct drm_device *dev, unsigned int handle)
>> > +{
>> > +       struct drm_gem_object *gem_obj;
>> > +
>> > +       gem_obj = drm_gem_object_lookup(dev, file_priv, handle);
>> > +       if (!gem_obj) {
>> > +               DRM_LOG_KMS("a invalid gem object not registered to
>> lookup.\n");
>> > +               return NULL;
>> > +       }
>> > +
>> > +       /**
>> > +        * unreference refcount of the gem object.
>> > +        * at drm_gem_object_lookup(), the gem object was referenced.
>> > +        */
>> > +       drm_gem_object_unreference(gem_obj);
>>
>> this doesn't seem right, to drop the reference before you use the
>> buffer elsewhere..
>>
> No, see drm_gem_object_lookup fxn. at this function, if there is a object
> found then drm_gem_object_reference is called to increase refcount of this
> object. if there is any missing point, give me any comment please. thank
> you.


Right, but I think there is a reason it takes a reference... so that
the object doesn't get free'd from under your feet.  So pattern
should, I think, be:

  obj = lookup(...);
  ... do stuff w/ obj ...
  unreference(obj)

so the caller who is using the looked up obj should unref it when done

Instead, you have:

  obj = lookup(...);
  unreference(obj);
  ... do stuff w/ obj ...


BR,
-R
