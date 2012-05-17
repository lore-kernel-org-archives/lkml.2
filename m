Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967313Ab2EQQe0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 12:34:26 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:58415 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966239Ab2EQQeU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 12:34:20 -0400
MIME-Version: 1.0
In-Reply-To: <20120517071518.GB19999@lizard>
References: <20120517071148.GA16946@lizard>
	<20120517071518.GB19999@lizard>
Date: Thu, 17 May 2012 09:34:19 -0700
X-Google-Sender-Auth: RCbGzQ2W4mLnHBrcPJdBO2PI8S8
Message-ID: <CAGXu5jJY478UM0fnqB5SML0gCc1HxoJyA-d6+rZH6mTWQkGegw@mail.gmail.com>
Subject: Re: [PATCH 2/3] pstore/ram: Switch to persistent_ram routines
From: Kees Cook <keescook@chromium.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>,
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

On Thu, May 17, 2012 at 12:15 AM, Anton Vorontsov
<anton.vorontsov@linaro.org> wrote:
> The patch switches pstore RAM backend to use persistent_ram routines,
> one step closer to the ECC support.
>
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
> Acked-by: Marco Stornelli <marco.stornelli@gmail.com>
> ---
>  fs/pstore/ram.c |  106 +++++++++++++++++++++++++++++++------------------------
>  1 file changed, 59 insertions(+), 47 deletions(-)
>
> diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
> index e443c9c..62b13ed 100644
> --- a/fs/pstore/ram.c
> +++ b/fs/pstore/ram.c
> @@ -57,7 +57,7 @@ MODULE_PARM_DESC(dump_oops,
>                "set to 1 to dump oopses, 0 to only dump panics (default 1)");
>
>  struct ramoops_context {
> -       void *virt_addr;
> +       struct persistent_ram_zone **przs;
>        phys_addr_t phys_addr;
>        unsigned long size;
>        size_t record_size;
> @@ -85,39 +85,56 @@ static ssize_t ramoops_pstore_read(u64 *id, enum pstore_type_id *type,
>                                   struct pstore_info *psi)
>  {
>        ssize_t size;
> -       char *rambuf;
>        struct ramoops_context *cxt = psi->data;
> +       struct persistent_ram_zone *prz;
>
>        if (cxt->read_count >= cxt->max_count)
>                return -EINVAL;
> +
>        *id = cxt->read_count++;
> +       prz = cxt->przs[*id];
> +
>        /* Only supports dmesg output so far. */
>        *type = PSTORE_TYPE_DMESG;
>        /* TODO(kees): Bogus time for the moment. */
>        time->tv_sec = 0;
>        time->tv_nsec = 0;
>
> -       rambuf = cxt->virt_addr + (*id * cxt->record_size);
> -       size = strnlen(rambuf, cxt->record_size);
> +       size = persistent_ram_old_size(prz);
>        *buf = kmalloc(size, GFP_KERNEL);
>        if (*buf == NULL)
>                return -ENOMEM;
> -       memcpy(*buf, rambuf, size);
> +       memcpy(*buf, persistent_ram_old(prz), size);
>
>        return size;
>  }
>
> +static size_t ramoops_write_kmsg_hdr(struct persistent_ram_zone *prz)
> +{
> +       char *hdr;
> +       struct timeval timestamp;
> +       size_t len;
> +
> +       do_gettimeofday(&timestamp);
> +       hdr = kasprintf(GFP_ATOMIC, RAMOOPS_KERNMSG_HDR "%lu.%lu\n",
> +               (long)timestamp.tv_sec, (long)timestamp.tv_usec);
> +       WARN_ON_ONCE(!hdr);
> +       len = hdr ? strlen(hdr) : 0;
> +       persistent_ram_write(prz, hdr, len);
> +       kfree(hdr);
> +
> +       return len;
> +}
> +
>  static int ramoops_pstore_write(enum pstore_type_id type,
>                                enum kmsg_dump_reason reason,
>                                u64 *id,
>                                unsigned int part,
>                                size_t size, struct pstore_info *psi)
>  {
> -       char *buf;
> -       size_t res;
> -       struct timeval timestamp;
>        struct ramoops_context *cxt = psi->data;
> -       size_t available = cxt->record_size;
> +       struct persistent_ram_zone *prz = cxt->przs[cxt->count];
> +       size_t hlen;
>
>        /* Currently ramoops is designed to only store dmesg dumps. */
>        if (type != PSTORE_TYPE_DMESG)
> @@ -142,22 +159,10 @@ static int ramoops_pstore_write(enum pstore_type_id type,
>        if (part != 1)
>                return -ENOSPC;
>
> -       buf = cxt->virt_addr + (cxt->count * cxt->record_size);
> -
> -       res = sprintf(buf, "%s", RAMOOPS_KERNMSG_HDR);
> -       buf += res;
> -       available -= res;
> -
> -       do_gettimeofday(&timestamp);
> -       res = sprintf(buf, "%lu.%lu\n", (long)timestamp.tv_sec, (long)timestamp.tv_usec);
> -       buf += res;
> -       available -= res;
> -
> -       if (size > available)
> -               size = available;
> -
> -       memcpy(buf, cxt->pstore.buf, size);
> -       memset(buf + size, '\0', available - size);
> +       hlen = ramoops_write_kmsg_hdr(prz);
> +       if (size + hlen > prz->buffer_size)
> +               size = prz->buffer_size - hlen;
> +       persistent_ram_write(prz, cxt->pstore.buf, size);

This still needs to wipe out the remaining bytes in the buffer (the
second memset above).

>        cxt->count = (cxt->count + 1) % cxt->max_count;
>
> @@ -167,14 +172,12 @@ static int ramoops_pstore_write(enum pstore_type_id type,
>  static int ramoops_pstore_erase(enum pstore_type_id type, u64 id,
>                                struct pstore_info *psi)
>  {
> -       char *buf;
>        struct ramoops_context *cxt = psi->data;
>
>        if (id >= cxt->max_count)
>                return -EINVAL;
>
> -       buf = cxt->virt_addr + (id * cxt->record_size);
> -       memset(buf, '\0', cxt->record_size);
> +       persistent_ram_free_old(cxt->przs[id]);

Same here -- erasing the buffer means wiping it with NULL bytes.

Otherwise, it looks good to me.

-Kees

-- 
Kees Cook
Chrome OS Security
