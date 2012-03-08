Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab2CHER0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 23:17:26 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:41751 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752346Ab2CHERY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 23:17:24 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Hillf Danton <dhillf@gmail.com>,
        David Gibson <david@gibson.dropbear.id.au>
Cc: akpm@linux-foundation.org, hughd@google.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, Andrew Barry <abarry@cray.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: [PATCH 2/2] hugepages: Fix use after free bug in "quota" handling
In-Reply-To: <CAJd=RBCPFtyLzxyzRVKzypErt_Te1guT8gi6qu1cLvNVFVOgKQ@mail.gmail.com>
References: <1331095694-27780-1-git-send-email-david@gibson.dropbear.id.au> <1331095694-27780-2-git-send-email-david@gibson.dropbear.id.au> <CAJd=RBCPFtyLzxyzRVKzypErt_Te1guT8gi6qu1cLvNVFVOgKQ@mail.gmail.com>
User-Agent: Notmuch/0.11.1+190~g31a336a (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 08 Mar 2012 09:47:05 +0530
Message-ID: <87boo7afr2.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
x-cbid: 12030804-3864-0000-0000-000001BD6A23
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Mar 2012 20:28:39 +0800, Hillf Danton <dhillf@gmail.com> wrote:
> On Wed, Mar 7, 2012 at 12:48 PM, David Gibson
> <david@gibson.dropbear.id.au> wrote:
> > hugetlbfs_{get,put}_quota() are badly named.  They don't interact with the
> > general quota handling code, and they don't much resemble its behaviour.
> > Rather than being about maintaining limits on on-disk block usage by
> > particular users, they are instead about maintaining limits on in-memory
> > page usage (including anonymous MAP_PRIVATE copied-on-write pages)
> > associated with a particular hugetlbfs filesystem instance.
> >
> > Worse, they work by having callbacks to the hugetlbfs filesystem code from
> > the low-level page handling code, in particular from free_huge_page().
> > This is a layering violation of itself, but more importantly, if the kernel
> > does a get_user_pages() on hugepages (which can happen from KVM amongst
> > others), then the free_huge_page() can be delayed until after the
> > associated inode has already been freed.  If an unmount occurs at the
> > wrong time, even the hugetlbfs superblock where the "quota" limits are
> > stored may have been freed.
> >
> > Andrew Barry proposed a patch to fix this by having hugepages, instead of
> > storing a pointer to their address_space and reaching the superblock from
> > there, had the hugepages store pointers directly to the superblock, bumping
> > the reference count as appropriate to avoid it being freed.  Andrew Morton
> > rejected that version, however, on the grounds that it made the existing
> > layering violation worse.
> >
> > This is a reworked version of Andrew's patch, which removes the extra, and
> > some of the existing, layering violation.  It works by introducing the
> > concept of a hugepage "subpool" at the lower hugepage mm layer - that is
> > a finite logical pool of hugepages to allocate from.  hugetlbfs now creates
> > a subpool for each filesystem instance with a page limit set, and a pointer
> > to the subpool gets added to each allocated hugepage, instead of the
> > address_space pointer used now.  The subpool has its own lifetime and is
> > only freed once all pages in it _and_ all other references to it (i.e.
> > superblocks) are gone.
> >
> > subpools are optional - a NULL subpool pointer is taken by the code to mean
> > that no subpool limits are in effect.
> >
> > Previous discussion of this bug found in:  "Fix refcounting in hugetlbfs
> > quota handling.". See:  https://lkml.org/lkml/2011/8/11/28 or
> > http://marc.info/?l=linux-mm&m=126928970510627&w=1
> >
> > v2: Fixed a bug spotted by Hillf Danton, and removed the extra parameter to
> > alloc_huge_page() - since it already takes the vma, it is not necessary.
> >
> > Signed-off-by: Andrew Barry <abarry@cray.com>
> > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > Cc: Hugh Dickins <hughd@google.com>
> > Cc: Mel Gorman <mgorman@suse.de>
> > Cc: Minchan Kim <minchan.kim@gmail.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Hillf Danton <dhillf@gmail.com>
> > ---
> >  fs/hugetlbfs/inode.c    |   54 +++++++-----------
> >  include/linux/hugetlb.h |   14 ++++--
> >  mm/hugetlb.c            |  135 +++++++++++++++++++++++++++++++++++++---------
> >  3 files changed, 139 insertions(+), 64 deletions(-)
> >
> > diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> > index bb0e366..74c6ba2 100644
> > --- a/fs/hugetlbfs/inode.c
> > +++ b/fs/hugetlbfs/inode.c
> > @@ -626,9 +626,15 @@ static int hugetlbfs_statfs(struct dentry *dentry, struct kstatfs *buf)
> >                spin_lock(&sbinfo->stat_lock);
> >                /* If no limits set, just report 0 for max/free/used
> >                 * blocks, like simple_statfs() */
> > -               if (sbinfo->max_blocks >= 0) {
> > -                       buf->f_blocks = sbinfo->max_blocks;
> > -                       buf->f_bavail = buf->f_bfree = sbinfo->free_blocks;
> > +               if (sbinfo->spool) {
> > +                       long free_pages;
> > +
> > +                       spin_lock(&sbinfo->spool->lock);
> > +                       buf->f_blocks = sbinfo->spool->max_hpages;
> > +                       free_pages = sbinfo->spool->max_hpages
> > +                               - sbinfo->spool->used_hpages;
> > +                       buf->f_bavail = buf->f_bfree = free_pages;
> > +                       spin_unlock(&sbinfo->spool->lock);
> >                        buf->f_files = sbinfo->max_inodes;
> >                        buf->f_ffree = sbinfo->free_inodes;
> >                }
> > @@ -644,6 +650,10 @@ static void hugetlbfs_put_super(struct super_block *sb)
> >
> >        if (sbi) {
> >                sb->s_fs_info = NULL;
> > +
> > +               if (sbi->spool)
> > +                       hugepage_put_subpool(sbi->spool);
> > +
> >                kfree(sbi);
> >        }
> >  }
> > @@ -874,10 +884,14 @@ hugetlbfs_fill_super(struct super_block *sb, void *data, int silent)
> >        sb->s_fs_info = sbinfo;
> >        sbinfo->hstate = config.hstate;
> >        spin_lock_init(&sbinfo->stat_lock);
> > -       sbinfo->max_blocks = config.nr_blocks;
> > -       sbinfo->free_blocks = config.nr_blocks;
> >        sbinfo->max_inodes = config.nr_inodes;
> >        sbinfo->free_inodes = config.nr_inodes;
> > +       sbinfo->spool = NULL;
> > +       if (config.nr_blocks != -1) {
> > +               sbinfo->spool = hugepage_new_subpool(config.nr_blocks);
> > +               if (!sbinfo->spool)
> > +                       goto out_free;
> > +       }
> >        sb->s_maxbytes = MAX_LFS_FILESIZE;
> >        sb->s_blocksize = huge_page_size(config.hstate);
> >        sb->s_blocksize_bits = huge_page_shift(config.hstate);
> > @@ -896,38 +910,12 @@ hugetlbfs_fill_super(struct super_block *sb, void *data, int silent)
> >        sb->s_root = root;
> >        return 0;
> >  out_free:
> > +       if (sbinfo->spool)
> > +               kfree(sbinfo->spool);
> >        kfree(sbinfo);
> >        return -ENOMEM;
> >  }
> >
> > -int hugetlb_get_quota(struct address_space *mapping, long delta)
> > -{
> > -       int ret = 0;
> > -       struct hugetlbfs_sb_info *sbinfo = HUGETLBFS_SB(mapping->host->i_sb);
> > -
> > -       if (sbinfo->free_blocks > -1) {
> > -               spin_lock(&sbinfo->stat_lock);
> > -               if (sbinfo->free_blocks - delta >= 0)
> > -                       sbinfo->free_blocks -= delta;
> > -               else
> > -                       ret = -ENOMEM;
> > -               spin_unlock(&sbinfo->stat_lock);
> > -       }
> > -
> > -       return ret;
> > -}
> > -
> > -void hugetlb_put_quota(struct address_space *mapping, long delta)
> > -{
> > -       struct hugetlbfs_sb_info *sbinfo = HUGETLBFS_SB(mapping->host->i_sb);
> > -
> > -       if (sbinfo->free_blocks > -1) {
> > -               spin_lock(&sbinfo->stat_lock);
> > -               sbinfo->free_blocks += delta;
> > -               spin_unlock(&sbinfo->stat_lock);
> > -       }
> > -}
> > -
> >  static struct dentry *hugetlbfs_mount(struct file_system_type *fs_type,
> >        int flags, const char *dev_name, void *data)
> >  {
> > diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> > index 7adc492..cf01817 100644
> > --- a/include/linux/hugetlb.h
> > +++ b/include/linux/hugetlb.h
> > @@ -14,6 +14,15 @@ struct user_struct;
> >  #include <linux/shm.h>
> >  #include <asm/tlbflush.h>
> >
> > +struct hugepage_subpool {
> > +       spinlock_t lock;
> > +       long count;
> > +       long max_hpages, used_hpages;
> > +};
> > +
> > +struct hugepage_subpool *hugepage_new_subpool(long nr_blocks);
> > +void hugepage_put_subpool(struct hugepage_subpool *spool);
> > +
> >  int PageHuge(struct page *page);
> >
> >  void reset_vma_resv_huge_pages(struct vm_area_struct *vma);
> > @@ -129,12 +138,11 @@ enum {
> >
> >  #ifdef CONFIG_HUGETLBFS
> >  struct hugetlbfs_sb_info {
> > -       long    max_blocks;   /* blocks allowed */
> > -       long    free_blocks;  /* blocks free */
> >        long    max_inodes;   /* inodes allowed */
> >        long    free_inodes;  /* inodes free */
> >        spinlock_t      stat_lock;
> >        struct hstate *hstate;
> > +       struct hugepage_subpool *spool;
> >  };
> >
> >  static inline struct hugetlbfs_sb_info *HUGETLBFS_SB(struct super_block *sb)
> > @@ -146,8 +154,6 @@ extern const struct file_operations hugetlbfs_file_operations;
> >  extern const struct vm_operations_struct hugetlb_vm_ops;
> >  struct file *hugetlb_file_setup(const char *name, size_t size, vm_flags_t acct,
> >                                struct user_struct **user, int creat_flags);
> > -int hugetlb_get_quota(struct address_space *mapping, long delta);
> > -void hugetlb_put_quota(struct address_space *mapping, long delta);
> >
> >  static inline int is_file_hugepages(struct file *file)
> >  {
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index 5f34bd8..36b38b3a 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -53,6 +53,84 @@ static unsigned long __initdata default_hstate_size;
> >  */
> >  static DEFINE_SPINLOCK(hugetlb_lock);
> >
> > +static inline void unlock_or_release_subpool(struct hugepage_subpool *spool)
> > +{
> > +       bool free = (spool->count == 0) && (spool->used_hpages == 0);
> > +
> > +       spin_unlock(&spool->lock);
> > +
> > +       /* If no pages are used, and no other handles to the subpool
> > +        * remain, free the subpool the subpool remain */
> > +       if (free)
> > +               kfree(spool);
> > +}
> > +
> > +struct hugepage_subpool *hugepage_new_subpool(long nr_blocks)
> > +{
> > +       struct hugepage_subpool *spool;
> > +
> > +       spool = kmalloc(sizeof(*spool), GFP_KERNEL);
> > +       if (!spool)
> > +               return NULL;
> > +
> > +       spin_lock_init(&spool->lock);
> > +       spool->count = 1;
> > +       spool->max_hpages = nr_blocks;
> > +       spool->used_hpages = 0;
> > +
> > +       return spool;
> > +}
> > +
> > +void hugepage_put_subpool(struct hugepage_subpool *spool)
> > +{
> > +       spin_lock(&spool->lock);
> > +       BUG_ON(!spool->count);
> > +       spool->count--;
> > +       unlock_or_release_subpool(spool);
> > +}
> > +
> > +static int hugepage_subpool_get_pages(struct hugepage_subpool *spool,
> > +                                     long delta)
> > +{
> > +       int ret = 0;
> > +
> > +       if (!spool)
> > +               return 0;
> > +
> > +       spin_lock(&spool->lock);
> > +       if ((spool->used_hpages + delta) <= spool->max_hpages) {
> > +               spool->used_hpages += delta;
> > +       } else {
> > +               ret = -ENOMEM;
> > +       }
> > +       spin_unlock(&spool->lock);
> > +
> > +       return ret;
> > +}
> > +
> > +static void hugepage_subpool_put_pages(struct hugepage_subpool *spool,
> > +                                      long delta)
> > +{
> > +       if (!spool)
> > +               return;
> > +
> > +       spin_lock(&spool->lock);
> > +       spool->used_hpages -= delta;
> > +       /* If hugetlbfs_put_super couldn't free spool due to
> > +       * an outstanding quota reference, free it now. */
> > +       unlock_or_release_subpool(spool);
> > +}
> > +
> > +static inline struct hugepage_subpool *subpool_inode(struct inode *inode)
> > +{
> > +       return HUGETLBFS_SB(inode->i_sb)->spool;
> > +}
> > +
> > +static inline struct hugepage_subpool *subpool_vma(struct vm_area_struct *vma)
> > +{
> > +       return subpool_inode(vma->vm_file->f_dentry->d_inode);
> > +}
> > +
> >  /*
> >  * Region tracking -- allows tracking of reservations and instantiated pages
> >  *                    across the pages in a mapping.
> > @@ -533,9 +611,9 @@ static void free_huge_page(struct page *page)
> >         */
> >        struct hstate *h = page_hstate(page);
> >        int nid = page_to_nid(page);
> > -       struct address_space *mapping;
> > +       struct hugepage_subpool *spool =
> > +               (struct hugepage_subpool *)page_private(page);
> >
> > -       mapping = (struct address_space *) page_private(page);
> >        set_page_private(page, 0);
> >        page->mapping = NULL;
> >        BUG_ON(page_count(page));
> > @@ -551,8 +629,7 @@ static void free_huge_page(struct page *page)
> >                enqueue_huge_page(h, page);
> >        }
> >        spin_unlock(&hugetlb_lock);
> > -       if (mapping)
> > -               hugetlb_put_quota(mapping, 1);
> > +       hugepage_subpool_put_pages(spool, 1);
> 
> Like current code, quota is handed back *unconditionally*, but ...


We will end up doing get_quota for every allocated page. get_quota
happens either during mmap() if MAP_NORESERVE is not specified.
or during alloc_huge_page if we haven't done a quota reservation during
mmap for that range. Are you finding any part of code where we miss that ?

-aneesh

