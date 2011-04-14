Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab1DNXhx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 19:37:53 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40313 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab1DNXhv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 19:37:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jRBawvSdjLdI6r6p7c+g8PAJ/4iFkBJBMekMdJmptnkp/XzfcDAzVUxXJyv58zkqBW
         HWTnpI8RVnrgD95loxj9hFi5mj6yXmN30eBkpF1lJWM8b9KtDgEGmL9Z8cFiITNpN09s
         AHNBm/osHHGWJg3W39ngAxgrH7IzPjJf38/vc=
MIME-Version: 1.0
In-Reply-To: <20110414211732.GA27761@ca-server1.us.oracle.com>
References: <20110414211732.GA27761@ca-server1.us.oracle.com>
Date: Fri, 15 Apr 2011 08:37:49 +0900
Message-ID: <BANLkTimEbtY8F6bpsfhfQ770ao9Hn7Spww@mail.gmail.com>
Subject: Re: [PATCH V8 4/8] mm/fs: add hooks to support cleancache
From: Minchan Kim <minchan.kim@gmail.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: chris.mason@oracle.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        adilger.kernel@dilger.ca, tytso@mit.edu, mfasheh@suse.com,
        jlbec@evilplan.org, matthew@wil.cx, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        linux-mm@kvack.org, hch@infradead.org, ngupta@vflare.org,
        jeremy@goop.org, JBeulich@novell.com, kurt.hackel@oracle.com,
        npiggin@kernel.dk, dave.mccracken@oracle.com, riel@redhat.com,
        avi@redhat.com, konrad.wilk@oracle.com, mel@csn.ul.ie,
        yinghan@google.com, gthelen@google.com, torvalds@linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

On Fri, Apr 15, 2011 at 6:17 AM, Dan Magenheimer
<dan.magenheimer@oracle.com> wrote:
> [PATCH V8 4/8] mm/fs: add hooks to support cleancache
>
> This fourth patch of eight in this cleancache series provides the
> core hooks in VFS for: initializing cleancache per filesystem;
> capturing clean pages reclaimed by page cache; attempting to get
> pages from cleancache before filesystem read; and ensuring coherency
> between pagecache, disk, and cleancache.  Note that the placement
> of these hooks was stable from 2.6.18 to 2.6.38; a minor semantic
> change was required due to a patchset in 2.6.39.
>
> All hooks become no-ops if CONFIG_CLEANCACHE is unset, or become
> a check of a boolean global if CONFIG_CLEANCACHE is set but no
> cleancache "backend" has claimed cleancache_ops.
>
> Details and a FAQ can be found in Documentation/vm/cleancache.txt
>
> [v8: minchan.kim@gmail.com: adapt to new remove_from_page_cache function]
> Signed-off-by: Chris Mason <chris.mason@oracle.com>
> Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
> Reviewed-by: Jeremy Fitzhardinge <jeremy@goop.org>
> Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Al Viro <viro@ZenIV.linux.org.uk>
> Cc: Matthew Wilcox <matthew@wil.cx>
> Cc: Nick Piggin <npiggin@kernel.dk>
> Cc: Mel Gorman <mel@csn.ul.ie>
> Cc: Rik Van Riel <riel@redhat.com>
> Cc: Jan Beulich <JBeulich@novell.com>
> Cc: Andreas Dilger <adilger@sun.com>
> Cc: Ted Ts'o <tytso@mit.edu>
> Cc: Mark Fasheh <mfasheh@suse.com>
> Cc: Joel Becker <joel.becker@oracle.com>
> Cc: Nitin Gupta <ngupta@vflare.org>
>
> ---
>
> Diffstat:
>  fs/buffer.c                              |    5 +++++
>  fs/mpage.c                               |    7 +++++++
>  fs/super.c                               |    3 +++
>  mm/filemap.c                             |   11 +++++++++++
>  mm/truncate.c                            |    6 ++++++
>  5 files changed, 32 insertions(+)
>
> --- linux-2.6.39-rc3/fs/super.c 2011-04-11 18:21:51.000000000 -0600
> +++ linux-2.6.39-rc3-cleancache/fs/super.c      2011-04-13 17:08:09.175853426 -0600
> @@ -31,6 +31,7 @@
>  #include <linux/mutex.h>
>  #include <linux/backing-dev.h>
>  #include <linux/rculist_bl.h>
> +#include <linux/cleancache.h>
>  #include "internal.h"
>
>
> @@ -112,6 +113,7 @@ static struct super_block *alloc_super(s
>                s->s_maxbytes = MAX_NON_LFS;
>                s->s_op = &default_op;
>                s->s_time_gran = 1000000000;
> +               s->cleancache_poolid = -1;
>        }
>  out:
>        return s;
> @@ -177,6 +179,7 @@ void deactivate_locked_super(struct supe
>  {
>        struct file_system_type *fs = s->s_type;
>        if (atomic_dec_and_test(&s->s_active)) {
> +               cleancache_flush_fs(s);
>                fs->kill_sb(s);
>                /*
>                 * We need to call rcu_barrier so all the delayed rcu free
> --- linux-2.6.39-rc3/fs/buffer.c        2011-04-11 18:21:51.000000000 -0600
> +++ linux-2.6.39-rc3-cleancache/fs/buffer.c     2011-04-13 17:07:24.700917174 -0600
> @@ -41,6 +41,7 @@
>  #include <linux/bitops.h>
>  #include <linux/mpage.h>
>  #include <linux/bit_spinlock.h>
> +#include <linux/cleancache.h>
>
>  static int fsync_buffers_list(spinlock_t *lock, struct list_head *list);
>
> @@ -269,6 +270,10 @@ void invalidate_bdev(struct block_device
>        invalidate_bh_lrus();
>        lru_add_drain_all();    /* make sure all lru add caches are flushed */
>        invalidate_mapping_pages(mapping, 0, -1);
> +       /* 99% of the time, we don't need to flush the cleancache on the bdev.
> +        * But, for the strange corners, lets be cautious
> +        */
> +       cleancache_flush_inode(mapping);
>  }
>  EXPORT_SYMBOL(invalidate_bdev);
>
> --- linux-2.6.39-rc3/fs/mpage.c 2011-04-11 18:21:51.000000000 -0600
> +++ linux-2.6.39-rc3-cleancache/fs/mpage.c      2011-04-13 17:07:24.706913410 -0600
> @@ -27,6 +27,7 @@
>  #include <linux/writeback.h>
>  #include <linux/backing-dev.h>
>  #include <linux/pagevec.h>
> +#include <linux/cleancache.h>
>
>  /*
>  * I/O completion handler for multipage BIOs.
> @@ -271,6 +272,12 @@ do_mpage_readpage(struct bio *bio, struc
>                SetPageMappedToDisk(page);
>        }
>
> +       if (fully_mapped && blocks_per_page == 1 && !PageUptodate(page) &&
> +           cleancache_get_page(page) == 0) {
> +               SetPageUptodate(page);
> +               goto confused;
> +       }
> +
>        /*
>         * This page will go to BIO.  Do we need to send this BIO off first?
>         */
> --- linux-2.6.39-rc3/mm/filemap.c       2011-04-11 18:21:51.000000000 -0600
> +++ linux-2.6.39-rc3-cleancache/mm/filemap.c    2011-04-13 17:09:46.367852002 -0600
> @@ -34,6 +34,7 @@
>  #include <linux/hardirq.h> /* for BUG_ON(!in_atomic()) only */
>  #include <linux/memcontrol.h>
>  #include <linux/mm_inline.h> /* for page_is_file_cache() */
> +#include <linux/cleancache.h>
>  #include "internal.h"
>
>  /*
> @@ -118,6 +119,16 @@ void __delete_from_page_cache(struct pag
>  {
>        struct address_space *mapping = page->mapping;
>
> +       /*
> +        * if we're uptodate, flush out into the cleancache, otherwise
> +        * invalidate any existing cleancache entries.  We can't leave
> +        * stale data around in the cleancache once our page is gone
> +        */
> +       if (PageUptodate(page) && PageMappedToDisk(page))
> +               cleancache_put_page(page);
> +       else
> +               cleancache_flush_page(mapping, page);
> +

First of all, thanks for resolving conflict with my patch.

Before I suggested a thing about cleancache_flush_page, cleancache_flush_inode.

what's the meaning of flush's semantic?
I thought it means invalidation.
AFAIC, how about change flush with invalidate?


-- 
Kind regards,
Minchan Kim
