Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933188Ab2DKUT1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 16:19:27 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:54756 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933047Ab2DKUT0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 16:19:26 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1204112209040.2137@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1204112209040.2137@swampdragon.chaosbits.net>
Date: Wed, 11 Apr 2012 13:19:24 -0700
X-Google-Sender-Auth: U4xEHqWw00JHHFIqnDNGQCJdx2w
Message-ID: <CAMbhsRQiT7oFu=B1_+Ygy+kX1sSs6GijwBv1ArHUO=0BMMDOaQ@mail.gmail.com>
Subject: Re: [PATCH] staging: android: fix mem leaks in __persistent_ram_init()
From: Colin Cross <ccross@android.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        John Stultz <john.stultz@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 1:10 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> If, in __persistent_ram_init(), the call to
> persistent_ram_buffer_init() fails or the call to
> persistent_ram_init_ecc() fails then we fail to free the memory we
> allocated to 'prz' with kzalloc() - thus leaking it.
>
> To prevent the leaks I consolidated all error exits from the function
> at a 'err:' label at the end and made all error cases jump to that
> label where we can then make sure we always free 'prz'. This is safe
> since all the situations where the code bails out happen before 'prz'
> has been stored anywhere and although we'll do a redundant kfree(NULL)
> call in the case of kzalloc() itself failing that's OK since kfree()
> deals gracefully with NULL pointers and I felt it was more important
> to keep all error exits at a single location than to avoid that one
> harmless/redundant kfree() on a error path.
>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  drivers/staging/android/persistent_ram.c |   11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/android/persistent_ram.c b/drivers/staging/android/persistent_ram.c
> index e08f257..8d8c1e3 100644
> --- a/drivers/staging/android/persistent_ram.c
> +++ b/drivers/staging/android/persistent_ram.c
> @@ -399,12 +399,12 @@ static  __init
>  struct persistent_ram_zone *__persistent_ram_init(struct device *dev, bool ecc)
>  {
>        struct persistent_ram_zone *prz;
> -       int ret;
> +       int ret = -ENOMEM;
>
>        prz = kzalloc(sizeof(struct persistent_ram_zone), GFP_KERNEL);
>        if (!prz) {
>                pr_err("persistent_ram: failed to allocate persistent ram zone\n");
> -               return ERR_PTR(-ENOMEM);
> +               goto err;
>        }
>
>        INIT_LIST_HEAD(&prz->node);
> @@ -412,13 +412,13 @@ struct persistent_ram_zone *__persistent_ram_init(struct device *dev, bool ecc)
>        ret = persistent_ram_buffer_init(dev_name(dev), prz);
This adds virtual mappings, which should get unmapped on error.

>        if (ret) {
>                pr_err("persistent_ram: failed to initialize buffer\n");
> -               return ERR_PTR(ret);
> +               goto err;
>        }
>
>        prz->ecc = ecc;
>        ret = persistent_ram_init_ecc(prz, prz->buffer_size);
>        if (ret)
> -               return ERR_PTR(ret);
> +               goto err;
>
>        if (prz->buffer->sig == PERSISTENT_RAM_SIG) {
>                if (buffer_size(prz) > prz->buffer_size ||
> @@ -442,6 +442,9 @@ struct persistent_ram_zone *__persistent_ram_init(struct device *dev, bool ecc)
>        atomic_set(&prz->buffer->size, 0);
>
>        return prz;
> +err:
> +       kfree(prz);
> +       return ERR_PTR(ret);
>  }
>
>  struct persistent_ram_zone * __init
> --
> 1.7.10
>
>
> --
> Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
> Don't top-post http://www.catb.org/jargon/html/T/top-post.html
> Plain text mails only, please.
>

Acked-by: Colin Cross <ccross@android.com>
