Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758310Ab2EOAiB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 20:38:01 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52187 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758285Ab2EOAh6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 20:37:58 -0400
MIME-Version: 1.0
In-Reply-To: <20120512001734.GD14782@lizard>
References: <20120512001506.GA8653@lizard>
	<20120512001734.GD14782@lizard>
Date: Mon, 14 May 2012 17:37:56 -0700
X-Google-Sender-Auth: xF52gNfk_QWyu4GRfPOl5Jrho6I
Message-ID: <CAMbhsRR3gsajDCyODgf0XrtEr5Jeeo7yPXxk_R6JfVkk-kGvyQ@mail.gmail.com>
Subject: Re: [PATCH 04/11] persistent_ram: Introduce persistent_ram_new()
From: Colin Cross <ccross@android.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>,
        John Stultz <john.stultz@linaro.org>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 5:17 PM, Anton Vorontsov
<anton.vorontsov@linaro.org> wrote:
> The routine just creates a persistent ram zone at a specified address.
>
> For persistent_ram_init_ringbuffer() we'd need to add a
> 'struct persistent_ram' to the global list, and associate it with a
> device. We don't need all this complexity in pstore_ram, so we introduce
> the simple function.
>
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
> ---
>  drivers/staging/android/persistent_ram.c |   26 ++++++++++++++++++++++++++
>  drivers/staging/android/persistent_ram.h |    4 ++++
>  2 files changed, 30 insertions(+)
>
> diff --git a/drivers/staging/android/persistent_ram.c b/drivers/staging/android/persistent_ram.c
> index ec23822..c0c3d32 100644
> --- a/drivers/staging/android/persistent_ram.c
> +++ b/drivers/staging/android/persistent_ram.c
> @@ -412,6 +412,32 @@ static int __init persistent_ram_post_init(struct persistent_ram_zone *prz, bool
>        return 0;
>  }
>
> +struct persistent_ram_zone * __init persistent_ram_new(phys_addr_t start,
> +                                                      size_t size,
> +                                                      bool ecc)
> +{
> +       struct persistent_ram_zone *prz;
> +       int ret = -ENOMEM;
> +
> +       prz = kzalloc(sizeof(struct persistent_ram_zone), GFP_KERNEL);
> +       if (!prz) {
> +               pr_err("persistent_ram: failed to allocate persistent ram zone\n");
> +               goto err;
> +       }
> +
> +       ret = persistent_ram_buffer_map(start, size, prz);
> +       if (ret)
> +               goto err;
> +
> +       persistent_ram_post_init(prz, ecc);
> +       persistent_ram_update_header_ecc(prz);
> +
> +       return prz;
> +err:
> +       kfree(prz);
> +       return ERR_PTR(ret);
> +}
> +
>  static  __init
>  struct persistent_ram_zone *__persistent_ram_init(struct device *dev, bool ecc)
>  {
> diff --git a/drivers/staging/android/persistent_ram.h b/drivers/staging/android/persistent_ram.h
> index 5635355..8154d15 100644
> --- a/drivers/staging/android/persistent_ram.h
> +++ b/drivers/staging/android/persistent_ram.h
> @@ -19,6 +19,7 @@
>  #include <linux/kernel.h>
>  #include <linux/list.h>
>  #include <linux/types.h>
> +#include <linux/init.h>
>
>  struct persistent_ram_buffer;
>
> @@ -62,6 +63,9 @@ struct persistent_ram_zone {
>
>  int persistent_ram_early_init(struct persistent_ram *ram);
>
> +struct persistent_ram_zone * __init persistent_ram_new(phys_addr_t start,
> +                                                      size_t size,
> +                                                      bool ecc);
>  struct persistent_ram_zone *persistent_ram_init_ringbuffer(struct device *dev,
>                bool ecc);
>
> --
> 1.7.9.2
>

Overall I like this series, but I'm not sure I agree with
persistent_ram_new().  The point of persistent_ram_early_init with the
call to memblock_reserve and the persistent_ram_descriptor list was to
have a single pool of persistent memory that could be parcelled out to
whatever drivers needed it, keeping the code out of the board file.
With persistent_ram_new, the board file is now responsible for making
sure that the memory has been reserved with memblock_reserve(), or,
even worse, mem= from the bootloader.  Mixing the two methods together
would be confusing.  Either persistent_ram_early_init should be
removed completely (or replaced with something that is easier to
register ramoops into), or ramoops should use
persistent_ram_init_ringbuffer like ram_console does.
