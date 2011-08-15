Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab1HOHMJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 03:12:09 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:36053 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273Ab1HOHMH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 03:12:07 -0400
MIME-Version: 1.0
In-Reply-To: <1313334832-1150-4-git-send-email-glommer@parallels.com>
References: <1313334832-1150-1-git-send-email-glommer@parallels.com>
	<1313334832-1150-4-git-send-email-glommer@parallels.com>
Date: Mon, 15 Aug 2011 10:12:06 +0300
X-Google-Sender-Auth: 6hPNS84GrnATFXIDoBP9aeIFnfE
Message-ID: <CAOJsxLFYD9DkEU5R+9fZr-uaznteP8-BUC_Ti+FnNFqtbOCHSw@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] limit nr_dentries per superblock
From: Pekka Enberg <penberg@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        containers@lists.linux-foundation.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        James Bottomley <JBottomley@parallels.com>,
        David Chinner <david@fromorbit.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 14, 2011 at 6:13 PM, Glauber Costa <glommer@parallels.com> wrote:
> This patch lays the foundation for us to limit the dcache size.
> Each super block can have only a maximum amount of dentries under its
> sub-tree. Allocation fails if we we're over limit and the cache
> can't be pruned to free up space for the newcomers.
>
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> CC: Dave Chinner <david@fromorbit.com>
> CC: Eric Dumazet <eric.dumazet@gmail.com>
> ---
>  fs/dcache.c        |   28 ++++++++++++++++++++++++++++
>  fs/super.c         |    1 +
>  include/linux/fs.h |    1 +
>  3 files changed, 30 insertions(+), 0 deletions(-)
>
> diff --git a/fs/dcache.c b/fs/dcache.c
> index 815d9fd..ddd02a2 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -1180,6 +1180,31 @@ void shrink_dcache_parent(struct dentry * parent)
>  }
>  EXPORT_SYMBOL(shrink_dcache_parent);
>
> +static inline int dcache_mem_check(struct super_block *sb)
> +{
> +       struct shrink_control sc = {
> +               .gfp_mask = GFP_KERNEL,
> +       };
> +
> +       if (sb->s_nr_dentry_max == INT_MAX)
> +               return 0;
> +
> +       do {
> +               int nr_dentry;
> +
> +               nr_dentry = percpu_counter_read_positive(&sb->s_nr_dentry);
> +               if (nr_dentry > sb->s_nr_dentry_max)
> +                       nr_dentry =
> +                               percpu_counter_sum_positive(&sb->s_nr_dentry);
> +               if (nr_dentry < sb->s_nr_dentry_max)
> +                       return 0;
> +
> +       /* nr_pages = 1, lru_pages = 0 should get delta ~ 2 */
> +       } while (shrink_one_shrinker(&sb->s_shrink, &sc, 1, 0));
> +
> +       return -ENOMEM;
> +}
> +
>  /**
>  * __d_alloc   -       allocate a dcache entry
>  * @sb: filesystem it will belong to
> @@ -1195,6 +1220,9 @@ struct dentry *__d_alloc(struct super_block *sb, const struct qstr *name)
>        struct dentry *dentry;
>        char *dname;
>
> +       if (dcache_mem_check(sb))
> +               return NULL;
> +
>        dentry = kmem_cache_alloc(dentry_cache, GFP_KERNEL);
>        if (!dentry)
>                return NULL;
> diff --git a/fs/super.c b/fs/super.c
> index e95ac4f..3db40fb 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -121,6 +121,7 @@ static struct super_block *alloc_super(struct file_system_type *type)
>                }
>
>                percpu_counter_init(&s->s_nr_dentry, 0);
> +               s->s_nr_dentry_max = INT_MAX;
>
>  #ifdef CONFIG_SMP
>                s->s_files = alloc_percpu(struct list_head);
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 8150f52..bc773c3 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1400,6 +1400,7 @@ struct super_block {
>        int                     s_nr_dentry_unused;     /* # of dentry on lru */
>
>        struct percpu_counter   s_nr_dentry;            /* # of dentry on this sb */
> +       int                     s_nr_dentry_max;        /* max # of dentry on this sb*/
>
>        /* s_inode_lru_lock protects s_inode_lru and s_nr_inodes_unused */
>        spinlock_t              s_inode_lru_lock ____cacheline_aligned_in_smp;

We track the total number of objects in mm/slub.c when
CONFIG_SLUB_DEBUG is enabled (look for n->total_objects in the code).
Have you considered extending that for this purpose?

                                Pekka
