Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab1GCXmq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 19:42:46 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52481 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751430Ab1GCXmp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 19:42:45 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1107031156450.16316@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1107031156450.16316@swampdragon.chaosbits.net>
Date: Mon, 4 Jul 2011 09:42:44 +1000
Message-ID: <CACAvsv6s9HbZmA4wGnZOMx1mxnJxroH1=+PyO+5Mi=kTbf3uMQ@mail.gmail.com>
Subject: Re: [PATCH] nouveau: Don't leak in nva3_pm_clock_pre()
From: Ben Skeggs <skeggsb@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, Ben Skeggs <bskeggs@redhat.com>,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 3, 2011 at 7:58 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> If nva3_calc_pll() returns less than 0 in
> drivers/gpu/drm/nouveau/nva3_pm.c:nva3_pm_clock_pre() we'll return
> without freeing 'pll'.
> This patch should fix the leak.
Firstly, thank you for the patch.

This issue however, no longer exists in nouveau git.  The patches
fixing it will make their way to Linus' tree.

Ben.

>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  drivers/gpu/drm/nouveau/nva3_pm.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
>  Compile tested only - no hardware to test for real.
>
> diff --git a/drivers/gpu/drm/nouveau/nva3_pm.c b/drivers/gpu/drm/nouveau/nva3_pm.c
> index e4b2b9e..80443d2 100644
> --- a/drivers/gpu/drm/nouveau/nva3_pm.c
> +++ b/drivers/gpu/drm/nouveau/nva3_pm.c
> @@ -137,8 +137,10 @@ nva3_pm_clock_pre(struct drm_device *dev, struct nouveau_pm_level *perflvl,
>
>        if (!pll->new_div) {
>                ret = nva3_calc_pll(dev, &limits, khz, &N, NULL, &M, &P);
> -               if (ret < 0)
> +               if (ret < 0) {
> +                       kfree(pll);
>                        return ERR_PTR(ret);
> +               }
>
>                pll->new_pnm = (P << 16) | (N << 8) | M;
>                pll->new_div = 2 - 1;
> --
> 1.7.6
>
>
> --
> Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
> Don't top-post http://www.catb.org/jargon/html/T/top-post.html
> Plain text mails only, please.
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>
