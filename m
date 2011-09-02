Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933014Ab1IBBSI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 21:18:08 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41789 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932958Ab1IBBSF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 21:18:05 -0400
MIME-Version: 1.0
In-Reply-To: <003501cc68a7$e8935aa0$b9ba0fe0$%dae@samsung.com>
References: <1314359274-21585-1-git-send-email-inki.dae@samsung.com>
	<CAF6AEGu3ss-rJC28H1rm2GWLm1bAZnHLftXfMLJQNeqjBt3umQ@mail.gmail.com>
	<001001cc67aa$72760460$57620d20$%dae@samsung.com>
	<CAF6AEGsqbFcS_QwihrjpVLQK1Y+h1iJSyu+GFV0Govp3XHYbOw@mail.gmail.com>
	<003501cc68a7$e8935aa0$b9ba0fe0$%dae@samsung.com>
Date: Thu, 1 Sep 2011 20:18:04 -0500
Message-ID: <CAF6AEGuZb1nhMJwc+k-cwPTPLHTiO1PkHcpGN899Yq3pEMUwkA@mail.gmail.com>
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

On Thu, Sep 1, 2011 at 8:06 AM, Inki Dae <inki.dae@samsung.com> wrote:
>> >> > +struct samsung_drm_gem_obj *
>> >> > +               find_samsung_drm_gem_object(struct drm_file
> *file_priv,
>> >> > +                       struct drm_device *dev, unsigned int handle)
>> >> > +{
>> >> > +       struct drm_gem_object *gem_obj;
>> >> > +
>> >> > +       gem_obj = drm_gem_object_lookup(dev, file_priv, handle);
>> >> > +       if (!gem_obj) {
>> >> > +               DRM_LOG_KMS("a invalid gem object not registered to
>> >> lookup.\n");
>> >> > +               return NULL;
>> >> > +       }
>> >> > +
>> >> > +       /**
>> >> > +        * unreference refcount of the gem object.
>> >> > +        * at drm_gem_object_lookup(), the gem object was referenced.
>> >> > +        */
>> >> > +       drm_gem_object_unreference(gem_obj);
>> >>
>> >> this doesn't seem right, to drop the reference before you use the
>> >> buffer elsewhere..
>> >>
>> > No, see drm_gem_object_lookup fxn. at this function, if there is a
>> object
>> > found then drm_gem_object_reference is called to increase refcount of
>> this
>> > object. if there is any missing point, give me any comment please. thank
>> > you.
>>
>>
>> Right, but I think there is a reason it takes a reference... so that
>> the object doesn't get free'd from under your feet.  So pattern
>> should, I think, be:
>>
>>   obj = lookup(...);
>>   ... do stuff w/ obj ...
>>   unreference(obj)
>>
>> so the caller who is using the looked up obj should unref it when done
>>
>> Instead, you have:
>>
>>   obj = lookup(...);
>>   unreference(obj);
>>   ... do stuff w/ obj ...
>>
>>
>
> Generally right, but in this case, it is just used to get specific gem
> object through find_samsung_drm_gem_object() so doesn't reference this gem
> object anywhere.
> therefore reference and unreference should be done within
> find_samsung_drm_gem_object(). if there is any point I missed then let me
> know please. thank you.
>

Still, it seems like find_samsung_drm_gem_object() is encouraging the
wrong usage-pattern, even if it works fine today because you know
somewhere else is holding a reference to the object.  Later if you
expand your use of GEM objects, this fxn might come back to bite you.
There is a good reason that drm_gem_object_lookup() takes a reference
to the object, and it feels wrong to intentionally subvert that.

(I'm perfectly willing to be overridden on the subject.. there are
plenty of folks on this list who have been doing the GEM thing longer
than I have.  But it just seems better to use APIs like
drm_gem_object_lookup() the way they were intended.)

BR,
-R
