Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861Ab2BZFwh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 00:52:37 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55057 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab2BZFwg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 00:52:36 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dhillf@gmail.com designates 10.52.28.167 as permitted sender) smtp.mail=dhillf@gmail.com; dkim=pass header.i=dhillf@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120225022710.GA29455@dcvr.yhbt.net>
References: <20120225022710.GA29455@dcvr.yhbt.net>
Date: Sun, 26 Feb 2012 13:52:35 +0800
Message-ID: <CAJd=RBDHB8yM=LGkzhOWZO6ftYFyZ42SQKySc0hUzNEQzrmVTw@mail.gmail.com>
Subject: Re: [PATCH] fadvise: avoid EINVAL if user input is valid
From: Hillf Danton <dhillf@gmail.com>
To: Eric Wong <normalperson@yhbt.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 25, 2012 at 10:27 AM, Eric Wong <normalperson@yhbt.net> wrote:
> The kernel is not required to act on fadvise, so fail silently
> and ignore advice as long as it has a valid descriptor and
> parameters.
>
> Cc: linux-mm@kvack.org
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Eric Wong <normalperson@yhbt.net>
> ---
>
>  Of course I wouldn't knowingly call posix_fadvise() on a file in
>  tmpfs, but a userspace app often doesn't know (nor should it
>  care) what type of filesystem it's on.
>
>  I encountered EINVAL while running the Ruby 1.9.3 test suite on a
>  stock Debian wheezy installation.  Wheezy uses tmpfs for "/tmp" by
>  default and the test suite creates a temporary file to test the
>  Ruby wrapper for posix_fadvise() on.
>
>  mm/fadvise.c |   19 +++++++------------
>  1 file changed, 7 insertions(+), 12 deletions(-)
>
> diff --git a/mm/fadvise.c b/mm/fadvise.c
> index 469491e0..f9e48dd 100644
> --- a/mm/fadvise.c
> +++ b/mm/fadvise.c
> @@ -43,13 +43,13 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, loff_t offset, loff_t len, int advice)
>                goto out;
>        }
>
> -       mapping = file->f_mapping;
> -       if (!mapping || len < 0) {
> +       if (len < 0) {

Current code makes sure mapping is valid after the above check,

>                ret = -EINVAL;
>                goto out;
>        }
>
> -       if (mapping->a_ops->get_xip_mem) {
> +       mapping = file->f_mapping;
> +       if (!mapping || mapping->a_ops->get_xip_mem) {
>                switch (advice) {
>                case POSIX_FADV_NORMAL:
>                case POSIX_FADV_RANDOM:

but backing devices info is no longer evaluated with that
guarantee in your change.

-hd

75:	bdi = mapping->backing_dev_info;

> @@ -93,10 +93,9 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, loff_t offset, loff_t len, int advice)
>                spin_unlock(&file->f_lock);
>                break;
>        case POSIX_FADV_WILLNEED:
> -               if (!mapping->a_ops->readpage) {
> -                       ret = -EINVAL;
> +               /* ignore the advice if readahead isn't possible (tmpfs) */
> +               if (!mapping->a_ops->readpage)
>                        break;
> -               }
>
>                /* First and last PARTIAL page! */
>                start_index = offset >> PAGE_CACHE_SHIFT;
> @@ -106,12 +105,8 @@ SYSCALL_DEFINE(fadvise64_64)(int fd, loff_t offset, loff_t len, int advice)
>                nrpages = end_index - start_index + 1;
>                if (!nrpages)
>                        nrpages = ~0UL;
> -
> -               ret = force_page_cache_readahead(mapping, file,
> -                               start_index,
> -                               nrpages);
> -               if (ret > 0)
> -                       ret = 0;
> +
> +               force_page_cache_readahead(mapping, file, start_index, nrpages);
>                break;
>        case POSIX_FADV_NOREUSE:
>                break;
> --
> Eric Wong
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
>
