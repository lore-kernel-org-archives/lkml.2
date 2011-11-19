Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab1KSJsK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 04:48:10 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38805 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752190Ab1KSJsG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 04:48:06 -0500
MIME-Version: 1.0
In-Reply-To: <CAPQyPG4GTccLroA2NsdQK_PH1_KB3dD1v3m1FzenCeDW-8qb+g@mail.gmail.com>
References: <1321635524-8586-1-git-send-email-mgorman@suse.de>
	<1321635524-8586-5-git-send-email-mgorman@suse.de>
	<CAPQyPG4GTccLroA2NsdQK_PH1_KB3dD1v3m1FzenCeDW-8qb+g@mail.gmail.com>
Date: Sat, 19 Nov 2011 17:48:05 +0800
Message-ID: <CAPQyPG4OvL936eAuzfDzCT0KqiaE-kV+ddOkRm5pNnyVqdBJhg@mail.gmail.com>
Subject: Re: [PATCH 4/5] mm: compaction: Determine if dirty pages can be
 migreated without blocking within ->migratepage
From: Nai Xia <nai.xia@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Jan Kara <jack@suse.cz>,
        Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 19, 2011 at 4:59 PM, Nai Xia <nai.xia@gmail.com> wrote:
> On Sat, Nov 19, 2011 at 12:58 AM, Mel Gorman <mgorman@suse.de> wrote:
>> Asynchronous compaction is when allocating transparent hugepages to
>> avoid blocking for long periods of time. Due to reports of stalling,
>> synchronous compaction is never used but this impacts allocation
>> success rates. When deciding whether to migrate dirty pages, the
>> following check is made
>>
>>        if (PageDirty(page) && !sync &&
>>                mapping->a_ops->migratepage != migrate_page)
>>                        rc = -EBUSY;
>>
>> This skips over all pages using buffer_migrate_page() even though
>> it is possible to migrate some of these pages without blocking. This
>> patch updates the ->migratepage callback with a "sync" parameter. It
>> is the resposibility of the callback to gracefully fail migration of
>> the page if it cannot be achieved without blocking.
>>
>> Signed-off-by: Mel Gorman <mgorman@suse.de>
>> ---
>>  fs/btrfs/disk-io.c      |    2 +-
>>  fs/nfs/internal.h       |    2 +-
>>  fs/nfs/write.c          |    4 +-
>>  include/linux/fs.h      |    9 +++-
>>  include/linux/migrate.h |    2 +-
>>  mm/migrate.c            |  106 ++++++++++++++++++++++++++++++++---------------
>>  6 files changed, 83 insertions(+), 42 deletions(-)
>>
>> diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
>> index 62afe5c..f841f00 100644
>> --- a/fs/btrfs/disk-io.c
>> +++ b/fs/btrfs/disk-io.c
>> @@ -872,7 +872,7 @@ static int btree_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
>>
>>  #ifdef CONFIG_MIGRATION
>>  static int btree_migratepage(struct address_space *mapping,
>> -                       struct page *newpage, struct page *page)
>> +                       struct page *newpage, struct page *page, bool sync)
>>  {
>>        /*
>>         * we can't safely write a btree page from here,
>> diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
>> index c1a1bd8..d0c460f 100644
>> --- a/fs/nfs/internal.h
>> +++ b/fs/nfs/internal.h
>> @@ -328,7 +328,7 @@ void nfs_commit_release_pages(struct nfs_write_data *data);
>>
>>  #ifdef CONFIG_MIGRATION
>>  extern int nfs_migrate_page(struct address_space *,
>> -               struct page *, struct page *);
>> +               struct page *, struct page *, bool);
>>  #else
>>  #define nfs_migrate_page NULL
>>  #endif
>> diff --git a/fs/nfs/write.c b/fs/nfs/write.c
>> index 1dda78d..33475df 100644
>> --- a/fs/nfs/write.c
>> +++ b/fs/nfs/write.c
>> @@ -1711,7 +1711,7 @@ out_error:
>>
>>  #ifdef CONFIG_MIGRATION
>>  int nfs_migrate_page(struct address_space *mapping, struct page *newpage,
>> -               struct page *page)
>> +               struct page *page, bool sync)
>>  {
>>        /*
>>         * If PagePrivate is set, then the page is currently associated with
>> @@ -1726,7 +1726,7 @@ int nfs_migrate_page(struct address_space *mapping, struct page *newpage,
>>
>>        nfs_fscache_release_page(page, GFP_KERNEL);
>>
>> -       return migrate_page(mapping, newpage, page);
>> +       return migrate_page(mapping, newpage, page, sync);
>>  }
>>  #endif
>>
>> diff --git a/include/linux/fs.h b/include/linux/fs.h
>> index 0c4df26..67f8e46 100644
>> --- a/include/linux/fs.h
>> +++ b/include/linux/fs.h
>> @@ -609,9 +609,12 @@ struct address_space_operations {
>>                        loff_t offset, unsigned long nr_segs);
>>        int (*get_xip_mem)(struct address_space *, pgoff_t, int,
>>                                                void **, unsigned long *);
>> -       /* migrate the contents of a page to the specified target */
>> +       /*
>> +        * migrate the contents of a page to the specified target. If sync
>> +        * is false, it must not block. If it needs to block, return -EBUSY
>> +        */
>>        int (*migratepage) (struct address_space *,
>> -                       struct page *, struct page *);
>> +                       struct page *, struct page *, bool);
>>        int (*launder_page) (struct page *);
>>        int (*is_partially_uptodate) (struct page *, read_descriptor_t *,
>>                                        unsigned long);
>> @@ -2577,7 +2580,7 @@ extern int generic_check_addressable(unsigned, u64);
>>
>>  #ifdef CONFIG_MIGRATION
>>  extern int buffer_migrate_page(struct address_space *,
>> -                               struct page *, struct page *);
>> +                               struct page *, struct page *, bool);
>>  #else
>>  #define buffer_migrate_page NULL
>>  #endif
>> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
>> index e39aeec..14e6d2a 100644
>> --- a/include/linux/migrate.h
>> +++ b/include/linux/migrate.h
>> @@ -11,7 +11,7 @@ typedef struct page *new_page_t(struct page *, unsigned long private, int **);
>>
>>  extern void putback_lru_pages(struct list_head *l);
>>  extern int migrate_page(struct address_space *,
>> -                       struct page *, struct page *);
>> +                       struct page *, struct page *, bool);
>>  extern int migrate_pages(struct list_head *l, new_page_t x,
>>                        unsigned long private, bool offlining,
>>                        bool sync);
>> diff --git a/mm/migrate.c b/mm/migrate.c
>> index 578e291..8395697 100644
>> --- a/mm/migrate.c
>> +++ b/mm/migrate.c
>> @@ -415,7 +415,7 @@ EXPORT_SYMBOL(fail_migrate_page);
>>  * Pages are locked upon entry and exit.
>>  */
>>  int migrate_page(struct address_space *mapping,
>> -               struct page *newpage, struct page *page)
>> +               struct page *newpage, struct page *page, bool sync)
>>  {
>>        int rc;
>>
>> @@ -432,19 +432,60 @@ int migrate_page(struct address_space *mapping,
>>  EXPORT_SYMBOL(migrate_page);
>>
>>  #ifdef CONFIG_BLOCK
>> +
>> +/* Returns true if all buffers are successfully locked */
>> +bool buffer_migrate_lock_buffers(struct buffer_head *head, bool sync)
>> +{
>> +       struct buffer_head *bh = head;
>> +
>> +       /* Simple case, sync compaction */
>> +       if (sync) {
>> +               do {
>> +                       get_bh(bh);
>> +                       lock_buffer(bh);
>> +                       bh = bh->b_this_page;
>> +
>> +               } while (bh != head);
>> +
>> +               return true;
>> +       }
>> +
>> +       /* async case, we cannot block on lock_buffer so use trylock_buffer */
>> +       do {
>> +               get_bh(bh);
>> +               if (!trylock_buffer(bh)) {
>> +                       /*
>> +                        * We failed to lock the buffer and cannot stall in
>> +                        * async migration. Release the taken locks
>> +                        */
>> +                       struct buffer_head *failed_bh = bh;
>> +                       bh = head;
>> +                       do {
>> +                               unlock_buffer(bh);
>> +                               put_bh(bh);
>> +                               bh = bh->b_this_page;
>> +                       } while (bh != failed_bh);
>> +                       return false;
>> +               }
>> +
>> +               bh = bh->b_this_page;
>> +       } while (bh != head);
>> +       return true;
>> +}
>> +
>>  /*
>>  * Migration function for pages with buffers. This function can only be used
>>  * if the underlying filesystem guarantees that no other references to "page"
>>  * exist.
>>  */
>>  int buffer_migrate_page(struct address_space *mapping,
>> -               struct page *newpage, struct page *page)
>> +               struct page *newpage, struct page *page, bool sync)
>>  {
>>        struct buffer_head *bh, *head;
>>        int rc;
>>
>>        if (!page_has_buffers(page))
>> -               return migrate_page(mapping, newpage, page);
>> +               return migrate_page(mapping, newpage, page, sync);
>>
>>        head = page_buffers(page);
>>
>> @@ -453,13 +494,18 @@ int buffer_migrate_page(struct address_space *mapping,
>>        if (rc)
>>                return rc;
>>
>> -       bh = head;
>> -       do {
>> -               get_bh(bh);
>> -               lock_buffer(bh);
>> -               bh = bh->b_this_page;
>> -
>> -       } while (bh != head);
>> +       if (!buffer_migrate_lock_buffers(head, sync)) {
>> +               /*
>> +                * We have to revert the radix tree update. If this returns
>> +                * non-zero, it either means that the page count changed
>> +                * which "can't happen" or the slot changed from underneath
>> +                * us in which case someone operated on a page that did not
>> +                * have buffers fully migrated which is alarming so warn
>> +                * that it happened.
>> +                */
>> +               WARN_ON(migrate_page_move_mapping(mapping, page, newpage));
>> +               return -EBUSY;
>
> If this migrate_page_move_mapping() really fails, seems disk IO will be needed
> to bring the previously already cached page back, I wonder if we should make the

Oh, I mean for clean pages. And for dirty pages, will their content get lost on
this error path?

> double check for the two conditions of "page refs is ok " and "all bh
> trylocked"
> before doing radix_tree_replace_slot() ? which I think does not
> involve IO on the
> error path.
>
>
> Nai
>
>> +       }
>>
>>        ClearPagePrivate(page);
