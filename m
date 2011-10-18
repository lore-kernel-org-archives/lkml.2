Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757205Ab1JRCTp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 22:19:45 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64111 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068Ab1JRCTn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 22:19:43 -0400
MIME-Version: 1.0
In-Reply-To: <1318896400-32498-1-git-send-email-msb@chromium.org>
References: <1318896400-32498-1-git-send-email-msb@chromium.org>
Date: Tue, 18 Oct 2011 10:19:42 +0800
Message-ID: <CABqxG0eKhaGUMvdNMOdahnqdYiT8i+3Hhf8vbQyq8TEJUOU0Lg@mail.gmail.com>
Subject: Re: [PATCH] drm: avoid switching to text console if there is no panic timeout
From: Dave Young <hidave.darkstar@gmail.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        Hugh Dickins <hughd@chromium.org>, Hugh Dickins <hughd@google.com>,
        Dave Airlie <airlied@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 8:06 AM, Mandeep Singh Baines <msb@chromium.org> wrote:
> From: Hugh Dickins <hughd@chromium.org>
>
> Add a check for panic_timeout in the drm_fb_helper_panic() notifier: if
> we're going to reboot immediately, the user will not be able to see the
> messages anyway, and messing with the video mode may display artifacts,
> and certainly get into several layers of complexity (including mutexes and
> memory allocations) which we shall be much safer to avoid.

There's one exception is use printk_delay

>
> Signed-off-by: Hugh Dickins <hughd@google.com>
> [ Edited commit message and modified to short-circuit panic_timeout < 0
>  instead of testing panic_timeout >= 0.  -Mandeep ]
> Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
> Cc: Dave Airlie <airlied@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: dri-devel@lists.freedesktop.org
> ---
>  drivers/gpu/drm/drm_fb_helper.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
> index f7c6854..0e62c93 100644
> --- a/drivers/gpu/drm/drm_fb_helper.c
> +++ b/drivers/gpu/drm/drm_fb_helper.c
> @@ -254,6 +254,13 @@ bool drm_fb_helper_force_kernel_mode(void)
>  int drm_fb_helper_panic(struct notifier_block *n, unsigned long ununsed,
>                        void *panic_str)
>  {
> +       /*
> +        * It's a waste of time and effort to switch back to text console
> +        * if the kernel should reboot before panic messages can be seen.
> +        */
> +       if (panic_timeout < 0)
> +               return 0;
> +
>        printk(KERN_ERR "panic occurred, switching back to text console\n");
>        return drm_fb_helper_force_kernel_mode();
>  }
> --
> 1.7.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Regards
Dave
