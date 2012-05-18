Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031331Ab2ERXxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:53:00 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63982 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab2ERXw6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:52:58 -0400
MIME-Version: 1.0
In-Reply-To: <20120518222436.GD23089@lizard>
References: <20120518222314.GA9425@lizard>
	<20120518222436.GD23089@lizard>
Date: Fri, 18 May 2012 16:52:57 -0700
X-Google-Sender-Auth: ydYMArlQWUUIM9HS81hzzgVWfdE
Message-ID: <CAMbhsRSQj2cMby7RekQTMfJ9ngnX=CuAdsTTtLqN1XZg7sDnZQ@mail.gmail.com>
Subject: Re: [PATCH 04/14] pstore/ram: Should zap persistent zone on unlink
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
> Otherwise, unlinked file will reappear on the next boot.
>
> Reported-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
> ---
>  fs/pstore/ram.c            |    1 +
>  fs/pstore/ram_core.c       |    6 ++++++
>  include/linux/pstore_ram.h |    1 +
>  3 files changed, 8 insertions(+)
>
> diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
> index 3a7724b..43d9727 100644
> --- a/fs/pstore/ram.c
> +++ b/fs/pstore/ram.c
> @@ -186,6 +186,7 @@ static int ramoops_pstore_erase(enum pstore_type_id type, u64 id,
>                return -EINVAL;
>
>        persistent_ram_free_old(cxt->przs[id]);
> +       persistent_ram_zap(cxt->przs[id]);
>
>        return 0;
>  }
> diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
> index dff5127..28b6d7f 100644
> --- a/fs/pstore/ram_core.c
> +++ b/fs/pstore/ram_core.c
> @@ -336,6 +336,12 @@ void persistent_ram_free_old(struct persistent_ram_zone *prz)
>        prz->old_log_size = 0;
>  }
>
> +void persistent_ram_zap(struct persistent_ram_zone *prz)
> +{
> +       atomic_set(&prz->buffer->size, 0);

There are a couple places in the ringbuffer code that assume that the
data is located in the buffer in the range [0, size).  It may start
anywhere in that range and wrap, but address 0 in the buffer always
contains data.  Resetting size to 0 but leaving start non-zero may
result in no data at address zero, and will cause problems in at least
persistent_ram_save_old, persistent_ram_ecc_old,
persistent_ram_copy_old, and the detection code in
persistent_ram_post_init.  These would all need to be fixed to support
the dual-metadata ringbuffer option I mentioned in response to patch
3, but if you don't like that idea then just clear start here.

> +       persistent_ram_update_header_ecc(prz);
> +}
> +
>  static void *persistent_ram_vmap(phys_addr_t start, size_t size)
>  {
>        struct page **pages;
> diff --git a/include/linux/pstore_ram.h b/include/linux/pstore_ram.h
> index 07d59b7..085199e 100644
> --- a/include/linux/pstore_ram.h
> +++ b/include/linux/pstore_ram.h
> @@ -69,6 +69,7 @@ struct persistent_ram_zone * __init persistent_ram_new(phys_addr_t start,
>                                                       size_t size,
>                                                       bool ecc);
>  void persistent_ram_free(struct persistent_ram_zone *prz);
> +void persistent_ram_zap(struct persistent_ram_zone *prz);
>  struct persistent_ram_zone *persistent_ram_init_ringbuffer(struct device *dev,
>                bool ecc);
>
> --
> 1.7.9.2
>
