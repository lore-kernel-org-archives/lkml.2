Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab1DOB1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 21:27:37 -0400
Received: from smtp-out.google.com ([74.125.121.67]:7171 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754902Ab1DOB1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 21:27:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hwFqB+d834J1NxuR+DZxnsg380v4eHMk7+6uIZkemvvnsIFyBNdDJqwC1rZQl+9t3Q
         mM0zkBXP/QEZChRntG5w==
MIME-Version: 1.0
In-Reply-To: <1302524879-4737-1-git-send-email-namhyung@gmail.com>
References: <1302524879-4737-1-git-send-email-namhyung@gmail.com>
Date: Thu, 14 Apr 2011 18:27:31 -0700
Message-ID: <BANLkTin4mOMZqq4Sg04hj8Ep2XiCcZOBLg@mail.gmail.com>
Subject: Re: [PATCH] shmem: factor out remove_indirect_page()
From: Hugh Dickins <hughd@google.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p3F1Rp3R025166

On Mon, Apr 11, 2011 at 5:27 AM, Namhyung Kim <namhyung@gmail.com> wrote:
> Split out some common code in shmem_truncate_range() in order to
> improve readability (hopefully) and to reduce code duplication.
>
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>

Thank you for taking the trouble to do this.

However... all that shmem_swp index code is irredeemably unreadable
(my fault, dating from when I converted it to use highmem with kmaps),
and I'd rather leave it untouched until we simply delete it
completely.

I have a patch/set (good for my testing but not yet good for final
submission) which removes all that code, and the need to allocate
shmem_swp index pages (even when CONFIG_SWAP is not set!): instead
saving the swp_entries in the standard pagecache radix_tree for the
file, so no extra allocations are needed at all.

It is possible that my patch/set will not be accepted (extending the
radix_tree in that way may meet some resistance); but I do think
that's the right way forward.

Thanks,
Hugh

> ---
>  mm/shmem.c |   62 ++++++++++++++++++++++++++++++++++-------------------------
>  1 files changed, 36 insertions(+), 26 deletions(-)
>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 58da7c150ba6..58ad1159678f 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -531,6 +531,31 @@ static void shmem_free_pages(struct list_head *next)
>        } while (next);
>  }
>
> +/**
> + * remove_indirect_page - remove a indirect page from upper layer
> + * @dir:       pointer to the indirect page in the upper layer
> + * @page:      indirect page to be removed
> + * @needs_lock:        pointer to spinlock if needed
> + * @free_list: list which the removed page will be inserted into
> + *
> + * This function removes @page from @dir and insert it into @free_list.
> + * The @page still remains after this function but will not be seen by
> + * other tasks. Finally it will be freed via shmem_free_pages().
> + */
> +static void remove_indirect_page(struct page **dir, struct page *page,
> +               spinlock_t *needs_lock, struct list_head *free_list)
> +{
> +       if (needs_lock) {
> +               spin_lock(needs_lock);
> +               *dir = NULL;
> +               spin_unlock(needs_lock);
> +       } else {
> +               *dir = NULL;
> +       }
> +
> +       list_add(&page->lru, free_list);
> +}
> +
>  static void shmem_truncate_range(struct inode *inode, loff_t start, loff_t end)
>  {
>        struct shmem_inode_info *info = SHMEM_I(inode);
> @@ -582,9 +607,9 @@ static void shmem_truncate_range(struct inode *inode, loff_t start, loff_t end)
>
>        topdir = info->i_indirect;
>        if (topdir && idx <= SHMEM_NR_DIRECT && !punch_hole) {
> -               info->i_indirect = NULL;
> +               remove_indirect_page(&info->i_indirect, topdir, NULL,
> +                                    &pages_to_free);
>                nr_pages_to_free++;
> -               list_add(&topdir->lru, &pages_to_free);
>        }
>        spin_unlock(&info->lock);
>
> @@ -637,15 +662,10 @@ static void shmem_truncate_range(struct inode *inode, loff_t start, loff_t end)
>                        diroff = ((idx - ENTRIES_PER_PAGEPAGE/2) %
>                                ENTRIES_PER_PAGEPAGE) / ENTRIES_PER_PAGE;
>                        if (!diroff && !offset && upper_limit >= stage) {
> -                               if (needs_lock) {
> -                                       spin_lock(needs_lock);
> -                                       *dir = NULL;
> -                                       spin_unlock(needs_lock);
> -                                       needs_lock = NULL;
> -                               } else
> -                                       *dir = NULL;
> +                               remove_indirect_page(dir, middir, needs_lock,
> +                                                    &pages_to_free);
>                                nr_pages_to_free++;
> -                               list_add(&middir->lru, &pages_to_free);
> +                               needs_lock = NULL;
>                        }
>                        shmem_dir_unmap(dir);
>                        dir = shmem_dir_map(middir);
> @@ -672,15 +692,10 @@ static void shmem_truncate_range(struct inode *inode, loff_t start, loff_t end)
>                        if (punch_hole)
>                                needs_lock = &info->lock;
>                        if (upper_limit >= stage) {
> -                               if (needs_lock) {
> -                                       spin_lock(needs_lock);
> -                                       *dir = NULL;
> -                                       spin_unlock(needs_lock);
> -                                       needs_lock = NULL;
> -                               } else
> -                                       *dir = NULL;
> +                               remove_indirect_page(dir, middir, needs_lock,
> +                                                    &pages_to_free);
>                                nr_pages_to_free++;
> -                               list_add(&middir->lru, &pages_to_free);
> +                               needs_lock = NULL;
>                        }
>                        shmem_dir_unmap(dir);
>                        cond_resched();
> @@ -690,15 +705,10 @@ static void shmem_truncate_range(struct inode *inode, loff_t start, loff_t end)
>                punch_lock = needs_lock;
>                subdir = dir[diroff];
>                if (subdir && !offset && upper_limit-idx >= ENTRIES_PER_PAGE) {
> -                       if (needs_lock) {
> -                               spin_lock(needs_lock);
> -                               dir[diroff] = NULL;
> -                               spin_unlock(needs_lock);
> -                               punch_lock = NULL;
> -                       } else
> -                               dir[diroff] = NULL;
> +                       remove_indirect_page(&dir[diroff], subdir, needs_lock,
> +                                            &pages_to_free);
>                        nr_pages_to_free++;
> -                       list_add(&subdir->lru, &pages_to_free);
> +                       punch_lock = NULL;
>                }
>                if (subdir && page_private(subdir) /* has swap entries */) {
>                        size = limit - idx;
> --
> 1.7.4
>
>
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
