Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab0KJCQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 21:16:35 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48574 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab0KJCQe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 21:16:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=pKQ+ZW4h6QCthBhIVcB1pS6sEEZdNpbwWfclDsSMEjDLC/mnnL2icwEw8DjFSvOC73
         X92+5CUYspkHaVGxfXgkqDcJS+dUA1avBHPf5z/cuxXlrVzxqjU/It4dzZXDV52HD7yX
         lpAUOYYx4gYlOKsuhemQWX1acCeBbQNlqaDUE=
MIME-Version: 1.0
In-Reply-To: <4da8e82f773833e126fc5d2d5563093b784144e5.1289348757.git.joe@perches.com>
References: <cover.1289348757.git.joe@perches.com>
	<4da8e82f773833e126fc5d2d5563093b784144e5.1289348757.git.joe@perches.com>
Date: Tue, 9 Nov 2010 21:16:33 -0500
X-Google-Sender-Auth: jZHlM_wLubkRC-eVIa8IqRfPV_0
Message-ID: <AANLkTi=Nu=rncb8+BzEGtphEj452xwVTPPM+EbCz0Fm1@mail.gmail.com>
Subject: Re: [PATCH 1/9] drivers/gpu/drm/drm_stub.c: Use printf extension %pV
From: =?UTF-8?Q?Kristian_H=C3=B8gsberg?= <krh@bitplanet.net>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 9, 2010 at 7:35 PM, Joe Perches <joe@perches.com> wrote:
> Using %pV reduces the number of printk calls and
> eliminates any possible message interleaving from
> other printk calls.
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/gpu/drm/drm_stub.c |   14 +++++++++++---
>  1 files changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/gpu/drm/drm_stub.c b/drivers/gpu/drm/drm_stub.c
> index cdc89ee..e632527 100644
> --- a/drivers/gpu/drm/drm_stub.c
> +++ b/drivers/gpu/drm/drm_stub.c
> @@ -57,13 +57,21 @@ void drm_ut_debug_printk(unsigned int request_level,
>                         const char *function_name,
>                         const char *format, ...)
>  {
> +       struct va_format vaf;
>        va_list args;
>
>        if (drm_debug & request_level) {
> -               if (function_name)
> -                       printk(KERN_DEBUG "[%s:%s], ", prefix, function_name);
>                va_start(args, format);
> -               vprintk(format, args);
> +
> +               vaf.fmt = format;
> +               vaf.va = &args;
> +
> +               if (function_name)
> +                       printk(KERN_DEBUG "[%s:%s], %pV",
> +                              prefix, function_name, &vaf);
> +               else
> +                       printk(KERN_DEBUG "%pV", &vaf);

Wouldn't it be easier and more convenient to just make the %pV format
specifier just expect a format string and the va_arg list?  Like this

  printk(KERN_DEBUG "%pV", format, &args);

I mean, the %pV is kernel specific and we can just change how it works.

Kristian
