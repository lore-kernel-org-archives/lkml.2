Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198Ab0LPOuz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 09:50:55 -0500
Received: from mail-gw0-f42.google.com ([74.125.83.42]:54318 "EHLO
	mail-gw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756113Ab0LPOuw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 09:50:52 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1012142020030.12693@tigran.mtv.corp.google.com>
References: <20101130194945.58962c44@xenia.leun.net>
	<alpine.LSU.2.00.1011301453090.12516@tigran.mtv.corp.google.com>
	<E1PNjsI-0005Bk-NB@pomaz-ex.szeredi.hu>
	<20101201124528.6809c539@xenia.leun.net>
	<E1PNqO1-0005px-9h@pomaz-ex.szeredi.hu>
	<20101202084159.6bff7355@xenia.leun.net>
	<20101202091552.4a63f717@xenia.leun.net>
	<E1PO5gh-00079U-Ma@pomaz-ex.szeredi.hu>
	<20101202115722.1c00afd5@xenia.leun.net>
	<20101203085350.55f94057@xenia.leun.net>
	<E1PPaIw-0004pW-Mk@pomaz-ex.szeredi.hu>
	<20101206204303.1de6277b@xenia.leun.net>
	<E1PRQDn-0007jZ-5S@pomaz-ex.szeredi.hu>
	<20101213142059.643f8080.akpm@linux-foundation.org>
	<E1PSSO8-0003sy-Vr@pomaz-ex.szeredi.hu>
	<alpine.LSU.2.00.1012142020030.12693@tigran.mtv.corp.google.com>
Date: Thu, 16 Dec 2010 15:50:50 +0100
Message-ID: <AANLkTim-WizK2PrfGM0zJ1=_VQkJao-D7oAcQ_et7-fi@mail.gmail.com>
Subject: Re: kernel BUG at mm/truncate.c:475!
From: =?UTF-8?B?Um9iZXJ0IMWad2nEmWNraQ==?= <robert@swiecki.net>
To: Hugh Dickins <hughd@google.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        lkml20101129@newton.leun.net, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Yes, this looks to me like what is needed for now.
>
> I'd feel rather happier about it if I thought it would also fix
> Robert's kernel BUG at /build/buildd/linux-2.6.35/mm/filemap.c:128!
> but I've still not found time to explain that one.
>
> Robert, you said yours is usually repeatable in 12 hours - any chance
> you could give iknowthis a run with the patch below, to see if it
> makes any difference to yours?  (I admit I don't see how it would.)

Hi Hugh,

Do you still want me to do that?

> Thanks,
> Hugh
>
>>
>> ---
>  fs/gfs2/main.c     |    9 +--------
>  fs/inode.c         |   22 +++++++++++++++-------
>  fs/nilfs2/btnode.c |    5 -----
>  fs/nilfs2/btnode.h |    1 -
>  fs/nilfs2/mdt.c    |    4 ++--
>  fs/nilfs2/page.c   |   13 -------------
>  fs/nilfs2/page.h   |    1 -
>  fs/nilfs2/super.c  |    2 +-
>  include/linux/fs.h |    2 ++
>  mm/memory.c        |    2 ++
>  10 files changed, 23 insertions(+), 38 deletions(-)
>
> Index: linux.git/mm/memory.c
> ===================================================================
> --- linux.git.orig/mm/memory.c  2010-12-11 14:09:55.000000000 +0100
> +++ linux.git/mm/memory.c       2010-12-14 11:20:47.000000000 +0100
> @@ -2572,6 +2572,7 @@ void unmap_mapping_range(struct address_
>                details.last_index = ULONG_MAX;
>        details.i_mmap_lock = &mapping->i_mmap_lock;
>
> +       mutex_lock(&mapping->unmap_mutex);
>        spin_lock(&mapping->i_mmap_lock);
>
>        /* Protect against endless unmapping loops */
> @@ -2588,6 +2589,7 @@ void unmap_mapping_range(struct address_
>        if (unlikely(!list_empty(&mapping->i_mmap_nonlinear)))
>                unmap_mapping_range_list(&mapping->i_mmap_nonlinear, &details);
>        spin_unlock(&mapping->i_mmap_lock);Hi,
> +       mutex_unlock(&mapping->unmap_mutex);
>  }
>  EXPORT_SYMBOL(unmap_mapping_range);
>
> Index: linux.git/fs/gfs2/main.c
> ===================================================================
> --- linux.git.orig/fs/gfs2/main.c       2010-11-26 10:52:16.000000000 +0100
> +++ linux.git/fs/gfs2/main.c    2010-12-14 11:15:53.000000000 +0100
> @@ -59,14 +59,7 @@ static void gfs2_init_gl_aspace_once(voi
>        struct address_space *mapping = (struct address_space *)(gl + 1);
>
>        gfs2_init_glock_once(gl);
> -       memset(mapping, 0, sizeof(*mapping));
> -       INIT_RADIX_TREE(&mapping->page_tree, GFP_ATOMIC);
> -       spin_lock_init(&mapping->tree_lock);
> -       spin_lock_init(&mapping->i_mmap_lock);
> -       INIT_LIST_HEAD(&mapping->private_list);
> -       spin_lock_init(&mapping->private_lock);
> -       INIT_RAW_PRIO_TREE_ROOT(&mapping->i_mmap);
> -       INIT_LIST_HEAD(&mapping->i_mmap_nonlinear);
> +       address_space_init_once(mapping);
>  }
>
>  /**
> Index: linux.git/fs/inode.c
> ===================================================================
> --- linux.git.orig/fs/inode.c   2010-11-26 10:52:16.000000000 +0100
> +++ linux.git/fs/inode.c        2010-12-14 11:21:49.000000000 +0100
> @@ -280,6 +280,20 @@ static void destroy_inode(struct inode *
>                kmem_cache_free(inode_cachep, (inode));
>  }
>
> +void address_space_init_once(struct address_space *mapping)
> +{
> +       memset(mapping, 0, sizeof(*mapping));
> +       INIT_RADIX_TREE(&mapping->page_tree, GFP_ATOMIC);
> +       spin_lock_init(&mapping->tree_lock);
> +       spin_lock_init(&mapping->i_mmap_lock);
> +       INIT_LIST_HEAD(&mapping->private_list);
> +       spin_lock_init(&mapping->private_lock);
> +       INIT_RAW_PRIO_TREE_ROOT(&mapping->i_mmap);
> +       INIT_LIST_HEAD(&mapping->i_mmap_nonlinear);
> +       mutex_init(&mapping->unmap_mutex);
> +}
> +EXPORT_SYMBOL(address_space_init_once);
> +
>  /*
>  * These are initializations that only need to be done
>  * once, because the fields are idempotent across use
> @@ -293,13 +307,7 @@ void inode_init_once(struct inode *inode
>        INIT_LIST_HEAD(&inode->i_devices);
>        INIT_LIST_HEAD(&inode->i_wb_list);
>        INIT_LIST_HEAD(&inode->i_lru);
> -       INIT_RADIX_TREE(&inode->i_data.page_tree, GFP_ATOMIC);
> -       spin_lock_init(&inode->i_data.tree_lock);
> -       spin_lock_init(&inode->i_data.i_mmap_lock);
> -       INIT_LIST_HEAD(&inode->i_data.private_list);
> -       spin_lock_init(&inode->i_data.private_lock);
> -       INIT_RAW_PRIO_TREE_ROOT(&inode->i_data.i_mmap);
> -       INIT_LIST_HEAD(&inode->i_data.i_mmap_nonlinear);
> +       address_space_init_once(&inode->i_data);
>        i_size_ordered_init(inode);
>  #ifdef CONFIG_FSNOTIFY
>        INIT_HLIST_HEAD(&inode->i_fsnotify_marks);
> Index: linux.git/fs/nilfs2/btnode.c
> ===================================================================
> --- linux.git.orig/fs/nilfs2/btnode.c   2010-11-26 10:52:17.000000000 +0100
> +++ linux.git/fs/nilfs2/btnode.c        2010-12-14 11:19:52.000000000 +0100
> @@ -35,11 +35,6 @@
>  #include "btnode.h"
>
>
> -void nilfs_btnode_cache_init_once(struct address_space *btnc)
> -{
> -       nilfs_mapping_init_once(btnc);
> -}
> -
>  static const struct address_space_operations def_btnode_aops = {
>        .sync_page              = block_sync_page,
>  };
> Index: linux.git/fs/nilfs2/btnode.h
> ===================================================================
> --- linux.git.orig/fs/nilfs2/btnode.h   2010-10-05 18:49:12.000000000 +0200
> +++ linux.git/fs/nilfs2/btnode.h        2010-12-14 11:20:01.000000000 +0100
> @@ -37,7 +37,6 @@ struct nilfs_btnode_chkey_ctxt {
>        struct buffer_head *newbh;
>  };
>
> -void nilfs_btnode_cache_init_once(struct address_space *);
>  void nilfs_btnode_cache_init(struct address_space *, struct backing_dev_info *);
>  void nilfs_btnode_cache_clear(struct address_space *);
>  struct buffer_head *nilfs_btnode_create_block(struct address_space *btnc,
> Index: linux.git/fs/nilfs2/mdt.c
> ===================================================================
> --- linux.git.orig/fs/nilfs2/mdt.c      2010-11-26 10:52:17.000000000 +0100
> +++ linux.git/fs/nilfs2/mdt.c   2010-12-14 11:18:18.000000000 +0100
> @@ -460,9 +460,9 @@ int nilfs_mdt_setup_shadow_map(struct in
>        struct backing_dev_info *bdi = inode->i_sb->s_bdi;
>
>        INIT_LIST_HEAD(&shadow->frozen_buffers);
> -       nilfs_mapping_init_once(&shadow->frozen_data);
> +       address_space_init_once(&shadow->frozen_data);
>        nilfs_mapping_init(&shadow->frozen_data, bdi, &shadow_map_aops);
> -       nilfs_mapping_init_once(&shadow->frozen_btnodes);
> +       address_space_init_once(&shadow->frozen_btnodes);
>        nilfs_mapping_init(&shadow->frozen_btnodes, bdi, &shadow_map_aops);
>        mi->mi_shadow = shadow;
>        return 0;
> Index: linux.git/fs/nilfs2/page.c
> ===================================================================
> --- linux.git.orig/fs/nilfs2/page.c     2010-11-26 10:52:17.000000000 +0100
> +++ linux.git/fs/nilfs2/page.c  2010-12-14 11:17:26.000000000 +0100
> @@ -492,19 +492,6 @@ unsigned nilfs_page_count_clean_buffers(
>        return nc;
>  }
>
> -void nilfs_mapping_init_once(struct address_space *mapping)
> -{
> -       memset(mapping, 0, sizeof(*mapping));
> -       INIT_RADIX_TREE(&mapping->page_tree, GFP_ATOMIC);
> -       spin_lock_init(&mapping->tree_lock);
> -       INIT_LIST_HEAD(&mapping->private_list);
> -       spin_lock_init(&mapping->private_lock);
> -
> -       spin_lock_init(&mapping->i_mmap_lock);
> -       INIT_RAW_PRIO_TREE_ROOT(&mapping->i_mmap);
> -       INIT_LIST_HEAD(&mapping->i_mmap_nonlinear);
> -}
> -
>  void nilfs_mapping_init(struct address_space *mapping,
>                        struct backing_dev_info *bdi,
>                        const struct address_space_operations *aops)
> Index: linux.git/fs/nilfs2/page.h
> ===================================================================
> --- linux.git.orig/fs/nilfs2/page.h     2010-11-26 10:52:17.000000000 +0100
> +++ linux.git/fs/nilfs2/page.h  2010-12-14 11:17:35.000000000 +0100
> @@ -61,7 +61,6 @@ void nilfs_free_private_page(struct page
>  int nilfs_copy_dirty_pages(struct address_space *, struct address_space *);
>  void nilfs_copy_back_pages(struct address_space *, struct address_space *);
>  void nilfs_clear_dirty_pages(struct address_space *);
> -void nilfs_mapping_init_once(struct address_space *mapping);
>  void nilfs_mapping_init(struct address_space *mapping,
>                        struct backing_dev_info *bdi,
>                        const struct address_space_operations *aops);
> Index: linux.git/fs/nilfs2/super.c
> ===================================================================
> --- linux.git.orig/fs/nilfs2/super.c    2010-11-26 10:52:17.000000000 +0100
> +++ linux.git/fs/nilfs2/super.c 2010-12-14 11:20:19.000000000 +0100
> @@ -1262,7 +1262,7 @@ static void nilfs_inode_init_once(void *
>  #ifdef CONFIG_NILFS_XATTR
>        init_rwsem(&ii->xattr_sem);
>  #endif
> -       nilfs_btnode_cache_init_once(&ii->i_btnode_cache);
> +       address_space_init_once(&ii->i_btnode_cache);
>        ii->i_bmap = &ii->i_bmap_data;
>        inode_init_once(&ii->vfs_inode);
>  }
> Index: linux.git/include/linux/fs.h
> ===================================================================
> --- linux.git.orig/include/linux/fs.h   2010-12-07 20:17:55.000000000 +0100
> +++ linux.git/include/linux/fs.h        2010-12-14 11:21:30.000000000 +0100
> @@ -645,6 +645,7 @@ struct address_space {
>        spinlock_t              private_lock;   /* for use by the address_space */
>        struct list_head        private_list;   /* ditto */
>        struct address_space    *assoc_mapping; /* ditto */
> +       struct mutex            unmap_mutex;    /* to protect unmapping */
>  } __attribute__((aligned(sizeof(long))));
>        /*
>         * On most architectures that alignment is already the case; but
> @@ -2205,6 +2206,7 @@ extern loff_t vfs_llseek(struct file *fi
>
>  extern int inode_init_always(struct super_block *, struct inode *);
>  extern void inode_init_once(struct inode *);
> +extern void address_space_init_once(struct address_space *mapping);
>  extern void ihold(struct inode * inode);
>  extern void iput(struct inode *);
>  extern struct inode * igrab(struct inode *);
>



-- 
Robert Święcki
