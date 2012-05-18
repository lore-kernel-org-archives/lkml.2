Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759787Ab2ERXzm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:55:42 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61665 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726Ab2ERXzk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:55:40 -0400
MIME-Version: 1.0
In-Reply-To: <20120518222418.GB23089@lizard>
References: <20120518222314.GA9425@lizard>
	<20120518222418.GB23089@lizard>
Date: Fri, 18 May 2012 16:55:39 -0700
X-Google-Sender-Auth: mZjZiU817vnbMaaRI3kzlAnkrXM
Message-ID: <CAMbhsRQKbqarZRtJnO=kGEzp59dLTrOcoANrfPk7DjCwDU4ikQ@mail.gmail.com>
Subject: Re: [PATCH 02/14] pstore/ram: Should update old dmesg buffer before reading
From: Colin Cross <ccross@android.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>,
        Shuah Khan <shuahkhan@gmail.com>, arve@android.com,
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

On Fri, May 18, 2012 at 3:24 PM, Anton Vorontsov
<anton.vorontsov@linaro.org> wrote:
> Without the update, we'll only see the new dmesg buffer after the
> reboot, but previously we could see it right away. Making an oops
> visible in pstore filesystem before reboot is a somewhat dubious
> feature, but removing it wasn't an intentional change, so let's
> restore it for now.
>
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
> ---
>  fs/pstore/ram.c            |    2 ++
>  fs/pstore/ram_core.c       |   21 +++++++++++++++++++--
>  include/linux/pstore_ram.h |    1 +
>  3 files changed, 22 insertions(+), 2 deletions(-)
>
> diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
> index 9123cce..3a7724b 100644
> --- a/fs/pstore/ram.c
> +++ b/fs/pstore/ram.c
> @@ -106,6 +106,8 @@ static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
>        time->tv_sec = 0;
>        time->tv_nsec = 0;
>
> +       /* Update old/shadowed buffer. */
> +       persistent_ram_copy_old(prz);
>        size = persistent_ram_old_size(prz);
>        *buf = kmalloc(size, GFP_KERNEL);
>        if (*buf == NULL)
> diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
> index 31f8d18..849a542 100644
> --- a/fs/pstore/ram_core.c
> +++ b/fs/pstore/ram_core.c
> @@ -250,8 +250,7 @@ static void notrace persistent_ram_update(struct persistent_ram_zone *prz,
>        persistent_ram_update_ecc(prz, start, count);
>  }
>
> -static void __init
> -persistent_ram_save_old(struct persistent_ram_zone *prz)
> +static void persistent_ram_save_old(struct persistent_ram_zone *prz)
>  {
>        struct persistent_ram_buffer *buffer = prz->buffer;
>        size_t size = buffer_size(prz);
> @@ -272,6 +271,24 @@ persistent_ram_save_old(struct persistent_ram_zone *prz)
>        memcpy(prz->old_log + size - start, &buffer->data[0], start);
>  }
>
> +void persistent_ram_copy_old(struct persistent_ram_zone *prz)
> +{
> +       struct persistent_ram_buffer *buffer = prz->buffer;
> +       size_t size = buffer_size(prz);
> +       size_t start = buffer_start(prz);
> +
> +       if (!size)
> +               return;
> +
> +       if (!prz->old_log) {
> +               persistent_ram_save_old(prz);
> +               return;
> +       }
> +       prz->old_log_size = size;
> +       memcpy(prz->old_log, &buffer->data[start], size - start);
> +       memcpy(prz->old_log + size - start, &buffer->data[0], start);
> +}

This duplicates most of persistent_ram_save_old, including all the
ringbuffer math that may change.  Can they be the same function, and
only malloc and ecc if old_log doesn't exist?

>  int notrace persistent_ram_write(struct persistent_ram_zone *prz,
>        const void *s, unsigned int count)
>  {
> diff --git a/include/linux/pstore_ram.h b/include/linux/pstore_ram.h
> index 7ed7fd4..07d59b7 100644
> --- a/include/linux/pstore_ram.h
> +++ b/include/linux/pstore_ram.h
> @@ -75,6 +75,7 @@ struct persistent_ram_zone *persistent_ram_init_ringbuffer(struct device *dev,
>  int persistent_ram_write(struct persistent_ram_zone *prz, const void *s,
>        unsigned int count);
>
> +void persistent_ram_copy_old(struct persistent_ram_zone *prz);
>  size_t persistent_ram_old_size(struct persistent_ram_zone *prz);
>  void *persistent_ram_old(struct persistent_ram_zone *prz);
>  void persistent_ram_free_old(struct persistent_ram_zone *prz);
> --
> 1.7.9.2
>
