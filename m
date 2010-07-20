Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761486Ab0GTUNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 16:13:45 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51568 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758581Ab0GTUNo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 16:13:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EMnkEuWn4/9Myvi5sKlx2mmSgL48NS+NNYjzEBh6ULOMD0pkGwrF+mK2V9aMGoP5Ak
         BYMFBKDOeU/CIXwP6cLAWk0a8xBSpNa/txYZRGXs2WMYjJl3WDC1ijsB3gNXrmT1HiM5
         aahI9REmTB/Gvy1Nbs82eVkXycC4Zqag6Ue0I=
MIME-Version: 1.0
In-Reply-To: <AANLkTilKlM9NyGgBom7ncq4cNx1O_GtS1dgsMExwdck3@mail.gmail.com>
References: <20100720014251.46b91cdd@mad-cat.localdomain>
	<AANLkTilKlM9NyGgBom7ncq4cNx1O_GtS1dgsMExwdck3@mail.gmail.com>
Date: Wed, 21 Jul 2010 00:13:42 +0400
Message-ID: <AANLkTikTetZ9vREMFfCSmJa7f9w1cmSFk145SthSFpPu@mail.gmail.com>
Subject: Re: drivers/gpu/drm/radeon/r600_blit.c: fix possible NULL pointer 
	derefernce
From: "Alexander Y. Fomichev" <git.user@gmail.com>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Dave Airlie <airlied@redhat.com>, Robert Noland <rnoland@2hip.net>,
        Matt Turner <mattst88@gmail.com>, Jerome Glisse <jglisse@redhat.com>,
        akpm@linux-foundation.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 20, 2010 at 9:37 PM, Alex Deucher <alexdeucher@gmail.com> wrote:
> On Mon, Jul 19, 2010 at 5:42 PM, Alexander Y. Fomichev
> <git.user@gmail.com> wrote:
>> This patch fix possible NULL pointer dereference when
>> r600_prepare_blit_copy tries to fill dev_priv->blit_vb->file_priv
>> without check of dev_priv->blit_vb. dev_priv->blit_vb should be
>> filled by r600_nomm_get_vb but latest can fail with EAGAIN.
>> Addresses: https://bugzilla.kernel.org/show_bug.cgi?id=16375
>>
>> ---
>>  drivers/gpu/drm/radeon/r600_blit.c |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/radeon/r600_blit.c b/drivers/gpu/drm/radeon/r600_blit.c
>> index f4fb88e..0df4a2b 100644
>> --- a/drivers/gpu/drm/radeon/r600_blit.c
>> +++ b/drivers/gpu/drm/radeon/r600_blit.c
>> @@ -541,6 +541,8 @@ r600_prepare_blit_copy(struct drm_device *dev, struct drm_file *file_priv)
>>        DRM_DEBUG("\n");
>>
>>        r600_nomm_get_vb(dev);
>> +       if (!dev_priv->blit_vb)
>> +               return;
>
> r600_prepare_blit_copy returns an int so something like this would be better:
> --- a/drivers/gpu/drm/radeon/r600_blit.c
> +++ b/drivers/gpu/drm/radeon/r600_blit.c
> @@ -539,8 +539,10 @@ r600_prepare_blit_copy(struct drm_device *dev,
> struct drm_file *file_priv)
>  {
>        drm_radeon_private_t *dev_priv = dev->dev_private;
>        DRM_DEBUG("\n");
> +       int ret = r600_nomm_get_vb(dev);
>
> -       r600_nomm_get_vb(dev);
> +       if (ret)
> +               return ret;
>
>        dev_priv->blit_vb->file_priv = file_priv;
>
>
> Alex
>
>>
>>        dev_priv->blit_vb->file_priv = file_priv;
>>
>> --
>> 1.7.1.1
>>
>

i haven't any preferneces, the only thing is - it would be logical
to have every check in common style, so other cases
(r600_blit_copy, r600_blit_swap) should be fixed, nop?

-- 
Best regards.
       Alexander Y. Fomichev <git.user@gmail.com>
