Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab0DLAFF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 20:05:05 -0400
Received: from mail-iw0-f197.google.com ([209.85.223.197]:41515 "EHLO
	mail-iw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab0DLAFD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 20:05:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ioGpnHH+ghVU8PDD32JX7CFTD++SAehMSu5/2WVd9pkJdMFBBaNLzd7D9R8VPNyfWt
         a8rGndbFk2ASjQ2q+0N6Uwa07poYE63tp/4+tiKSc2T/00obDMkb58yFpYPhMFeTPoy7
         AQLcg/eOU7TPau3cKhmoXQpTkS1DcGxQG/Y8o=
MIME-Version: 1.0
In-Reply-To: <20100409151148.4312e5cb@virtuousgeek.org>
References: <20100409151050.74ef6dcd@virtuousgeek.org>
	 <20100409151148.4312e5cb@virtuousgeek.org>
Date: Mon, 12 Apr 2010 10:05:00 +1000
Message-ID: <z2q21d7e9971004111705p4d1760dax9f324777be44f299@mail.gmail.com>
Subject: Re: [PATCH] drm: add locked variant of drm_fb_helper_force_kernel_mode
From: Dave Airlie <airlied@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       James Simmons <jsimmons@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 10, 2010 at 8:11 AM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> Needed for panic and kdb, since we need to avoid taking the mode_config
> mutex.

One comment below.

>
> Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> ---
>  drivers/gpu/drm/drm_fb_helper.c |   42 +++++++++++++++++++++++++++++++++-----
>  1 files changed, 36 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
> index 6929f5b..962eadb 100644
> --- a/drivers/gpu/drm/drm_fb_helper.c
> +++ b/drivers/gpu/drm/drm_fb_helper.c
> @@ -242,18 +242,22 @@ static int drm_fb_helper_parse_command_line(struct drm_fb_helper *fb_helper)
>        return 0;
>  }
>
> -bool drm_fb_helper_force_kernel_mode(void)
> +bool drm_fb_helper_force_kernel_mode_locked(void)
>  {
>        int i = 0;
>        bool ret, error = false;
>        struct drm_fb_helper *helper;
> -
> -       if (list_empty(&kernel_fb_helper_list))
> -               return false;
> +       struct drm_mode_set *mode_set;
> +       struct drm_crtc *crtc;
>
>        list_for_each_entry(helper, &kernel_fb_helper_list, kernel_fb_list) {
>                for (i = 0; i < helper->crtc_count; i++) {
> -                       struct drm_mode_set *mode_set = &helper->crtc_info[i].mode_set;
> +                       mode_set = &helper->crtc_info[i].mode_set;
> +                       crtc = helper->crtc_info[i].mode_set.crtc;
> +
> +                       if (!crtc->enabled)
> +                               continue;
> +
>                        ret = drm_crtc_helper_set_config(mode_set);
>                        if (ret)
>                                error = true;
> @@ -262,11 +266,37 @@ bool drm_fb_helper_force_kernel_mode(void)
>        return error;
>  }
>
> +bool drm_fb_helper_force_kernel_mode(void)
> +{
> +       bool ret;
> +       struct drm_device *dev;
> +       struct drm_fb_helper *helper;
> +       struct drm_mode_set *mode_set;
> +
> +       if (list_empty(&kernel_fb_helper_list)) {
> +               DRM_DEBUG_KMS("no fb helper list??\n");
> +               return false;
> +       }
> +
> +       /* Get the DRM device */
> +       helper = list_first_entry(&kernel_fb_helper_list,
> +                                 struct drm_fb_helper,
> +                                 kernel_fb_list);
> +       mode_set = &helper->crtc_info[0].mode_set;
> +       dev = mode_set->crtc->dev;
> +
> +       mutex_lock(&dev->mode_config.mutex);
> +       ret = drm_fb_helper_force_kernel_mode_locked();
> +       mutex_unlock(&dev->mode_config.mutex);
> +
> +       return ret;
> +}
> +
>  int drm_fb_helper_panic(struct notifier_block *n, unsigned long ununsed,
>                        void *panic_str)
>  {
>        DRM_ERROR("panic occurred, switching back to text console\n");
> -       return drm_fb_helper_force_kernel_mode();
> +       drm_fb_helper_force_kernel_mode_locked();

Any reason to drop the return here?

not just remove the return 0?

Dave.

>        return 0;
>  }
>  EXPORT_SYMBOL(drm_fb_helper_panic);
> --
> 1.6.6.1
>
>
>
