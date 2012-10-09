Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858Ab2JIFNe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 01:13:34 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:25228 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab2JIFNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 01:13:32 -0400
X-AuditID: cbfee61a-b7f726d000000ec7-17-5073b27adc0b
From: Chul Lee <chur.lee@samsung.com>
To: dave@jikos.cz, "'?????????'" <jaegeuk.kim@samsung.com>
Cc: viro@zeniv.linux.org.uk, "'Theodore Ts'o'" <tytso@mit.edu>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        cm224.lee@samsung.com, jooyoung.hwang@samsung.com,
        linux-fsdevel@vger.kernel.org
References: <000a01cda2f0$a2375b40$e6a611c0$%kim@samsung.com>
 <20121006232240.GB4405@twin.jikos.cz>
In-reply-to: <20121006232240.GB4405@twin.jikos.cz>
Subject: RE: [PATCH 03/16] f2fs: add superblock and major in-memory structures
Date: Tue, 09 Oct 2012 14:13:29 +0900
Message-id: <007101cda5dc$d22c01e0$768405a0$%lee@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2kGYEPfiBuEbjpTEm1LYrTM7nylwBoONHg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrELMWRmVeSWpSXmKPExsVy+t9jAd2qTcUBBs2XVC327D3JYnF51xw2
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDLunepjLDjmULFuxlOWBsYZhl2MnBwSAiYSm29/Y4Gw
	xSQu3FvP1sXIxSEksIhRYuOKkywQzh9GicstP8Cq2ARUJc7tWsjexcjBISJgIfGi0Rukhlng
	HKPE6hMn2EBqhARSJS7PXMQKYnMKGEm0rnjJDGILC/hJLP7XDTaHBWjO5UNrwWp4BWwl/i99
	wARhC0r8mHwPrIZZQEti/c7jTBC2vMTmNW+ZQfZKCKhLPPqrCxIWARp/7OlrNogSEYl9L94x
	TmAUmoVk0iwkk2YhmTQLScsCRpZVjKKpBckFxUnpuYZ6xYm5xaV56XrJ+bmbGMEh/UxqB+PK
	BotDjAIcjEo8vB+iigOEWBPLiitzDzFKcDArifBeTwQK8aYkVlalFuXHF5XmpBYfYpTmYFES
	5232SAkQEkhPLEnNTk0tSC2CyTJxcEo1MNoySzybHFh8QiydQYJhxlZZoZvxWbYMV649Vpik
	5XVm9gZxj79h/yqmb7rY+euLTRC/3+VH/c9/tVcsM35jaZV0fEb+3QOPrTd1/L5SPL3S5kVb
	nPpflpyGH7OERDPun5Kf6rZ62rU1edry/J+Pnk31XW54Y2Lq7F/zH+UkfPipvXeBddnL2hVK
	LMUZiYZazEXFiQCFLJgZZQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear David Sterba,

David Sterba wrote: 
> On Fri, Oct 05, 2012 at 08:57:46PM +0900, ????????? wrote:
> > +struct f2fs_nm_info {
> > +	block_t nat_blkaddr;		/* base disk address of NAT */
> > +	unsigned int nat_segs;		/* the number of nat segments */
> > +	unsigned int nat_blocks;	/* the number of nat blocks of
> > +					   one size */
> > +	nid_t max_nid;		/* */
> > +
> > +	unsigned int nat_cnt;		/* the number of nodes in NAT
> Buffer */
> > +	struct radix_tree_root nat_root;
> > +	rwlock_t nat_tree_lock;		/* Protect nat_tree_lock */
> > +	struct list_head nat_entries;	/* cached nat entry list (clean)
> */
> > +	struct list_head dirty_nat_entries; /* cached nat entry list (dirty)
> */
> > +
> > +	unsigned int fcnt;		/* the number of free node id */
> > +	struct mutex build_lock;	/* lock for build free nids */
> > +	struct list_head free_nid_list;	/* free node list */
> > +	spinlock_t free_nid_list_lock;	/* Protect pre-free nid list */
> > +
> > +	spinlock_t stat_lock;		/* Protect status variables */
> 
> a mutex and 2 spinlocks that will probably share the same cacheline (I
> counted only roughly, looks like it's the 2nd cacheline), this may incur
> performance drop if the locks are contended frequently and all at once.
> 
> Verifying if this is the case needs to be more familiar with the
> codepaths and access patterns, which I'm not, this is JFYI.
> 


Thank for the info. We'll omit one spinlock (stat_lock) and consider
rearranging the others.


> > +
> > +	int nat_upd_blkoff[3];		/* Block offset
> > +					   in current journal segment
> > +					   where the last NAT update
happened */
> > +	int lst_upd_blkoff[3];		/* Block offset
> > +					   in current journal segment */
> > +
> > +	unsigned int written_valid_node_count;
> > +	unsigned int written_valid_inode_count;
> > +	char *nat_bitmap;		/* NAT bitmap pointer */
> > +	int bitmap_size;		/* bitmap size */
> > +
> > +	nid_t init_scan_nid;	/* the first nid to be scanned */
> > +	nid_t next_scan_nid;	/* the next nid to be scanned */
> > +};
> > +
> > +struct dnode_of_data {
> > +	struct inode *inode;
> > +	struct page *inode_page;
> > +	struct page *node_page;
> > +	nid_t nid;
> > +	unsigned int ofs_in_node;
> > +	int ilock;
> 
> A variable named like-a lock but not a lock type? This at least looks
> strange and a comment would not hurt. From a quick look I don't see any
> global lock that would protect it against any races, but also I don't
> see a scenario where a race condition can occur.
> 


There could be a confusion by the name. We intended to use the variable
(ilock) to indicate that the inode_page is already locked and can be updated
without locking on it. If the ilock is not set, lock_page() on the
inode_page is needed.
Also, we defined the struct dnode_of_data for using it as a collection of
common passing parameters to some functions, that maybe why you don't see
any global lock.

We'll consider renaming it with a comment.


> > +	block_t	data_blkaddr;
> > +};
> > +
> > +struct f2fs_sb_info {
> > +	struct super_block *sb;			/* Pointer to VFS super
> block */
> > +	int s_dirty;
> 
> Is s_dirty actually used? I can see it only set and reset at checkpoint,
> not eg. synced with an on-disk block to signalize a dirty status.
> 


The s_dirty is checked, when sync_fs is called.


> > +	struct f2fs_super_block *raw_super;	/* Pointer to the super
> block
> > +						   in the buffer */
> > +	struct buffer_head *raw_super_buf;	/* Buffer containing
> > +						   the f2fs raw super block
*/
> > +	struct f2fs_checkpoint *ckpt;		/* Pointer to the
> checkpoint
> > +						   in the buffer */
> > +	struct mutex orphan_inode_mutex;
> > +	spinlock_t dir_inode_lock;
> > +	struct mutex cp_mutex;
> > +	/* orphan Inode list to be written in Journal block during CP  */
> > +	struct list_head orphan_inode_list;
> > +	struct list_head dir_inode_list;
> > +	unsigned int n_orphans, n_dirty_dirs;
> > +
> > +	unsigned int log_sectorsize;
> > +	unsigned int log_sectors_per_block;
> > +	unsigned int log_blocksize;
> > +	unsigned int blocksize;
> > +	unsigned int root_ino_num;		/* Root Inode Number*/
> > +	unsigned int node_ino_num;		/* Root Inode Number*/
> > +	unsigned int meta_ino_num;		/* Root Inode Number*/
> > +	unsigned int log_blocks_per_seg;
> > +	unsigned int blocks_per_seg;
> > +	unsigned int log_segs_per_sec;
> > +	unsigned int segs_per_sec;
> > +	unsigned int secs_per_zone;
> > +	unsigned int total_sections;
> > +	unsigned int total_node_count;
> > +	unsigned int total_valid_node_count;
> > +	unsigned int total_valid_inode_count;
> > +	unsigned int segment_count[2];
> > +	unsigned int block_count[2];
> > +	unsigned int last_victim[2];
> > +	block_t user_block_count;
> > +	block_t total_valid_block_count;
> > +	block_t alloc_valid_block_count;
> > +	block_t last_valid_block_count;
> > +	atomic_t nr_pages[NR_COUNT_TYPE];
> > +
> > +	struct f2fs_mount_info mount_opt;
> > +
> > +	/* related to NM */
> > +	struct f2fs_nm_info *nm_info;		/* Node Manager information
> */
> > +
> > +	/* related to SM */
> > +	struct f2fs_sm_info *sm_info;		/* Segment Manager
> > +						   information */
> > +	int total_hit_ext, read_hit_ext;
> > +	int rr_flush;
> > +
> > +	/* related to GC */
> > +	struct proc_dir_entry *s_proc;
> > +	struct f2fs_gc_info *gc_info;		/* Garbage Collector
> > +						   information */
> > +	struct mutex gc_mutex;			/* mutex for GC */
> > +	struct mutex fs_lock[NR_LOCK_TYPE];	/* mutex for GP */
> > +	struct mutex write_inode;		/* mutex for write inode */
> > +	struct mutex writepages;		/* mutex for writepages() */
> 
> wow, thats 1+8+2 = 11 mutexes in a row! The ones hidden under
> NR_LOCK_TYPE may hurt, as they seem to protect various and common file
> opterations (guesed from the lock_type names).


Yes, they protect global variables shared by various operations and
checkpoint.
Could you tell me what you recommend? Each fs_lock's under NR_LOCK_TYPE
would have had different lock names?


> 
> > +	struct f2fs_gc_kthread	*gc_thread;	/* GC thread */
> > +	int bg_gc;
> > +	int last_gc_status;
> > +	int por_doing;
> > +
> > +	struct inode *node_inode;
> > +	struct inode *meta_inode;
> > +
> > +	struct bio *bio[NR_PAGE_TYPE];
> > +	sector_t last_block_in_bio[NR_PAGE_TYPE];
> > +	struct rw_semaphore bio_sem;
> > +	void *ckpt_mutex;			/* mutex protecting
> > +						   node buffer */
> 
> where do you use the ckpt_mutex variable? also same concern about naming
> vs. type ...


We'll remove the obsolete variable. Thanks.

> 
> > +	spinlock_t stat_lock;			/* lock for handling the
> number
> > +						   of valid blocks and
> > +						   valid nodes */
> 
> and again a sequence of synchronization primitives.
> 

We'll omit the stat_lock in the f2fs_nm_info.

> > +};
> 
> > +static inline unsigned char inc_node_version(unsigned char version)
> > +{
> > +	(version == 255) ? version = 0 : ++version;
> 
> Isn't this equivalent to simply
> 
> 	return ++version;
> 
> ?


That would be great. Thanks.

> 
> > +	return version;
> > +}
> > +
> > +struct nat_entry {
> > +	struct node_info ni;
> > +	bool checkpointed;
> > +	struct list_head list;	/* clean/dirty list */
> > +} __packed;
> 
> This is packed, but only an in-memory structure, so reorder the
> checkpointed and list so that 'list' is aligned. Otherwise, the compiler
> will cope with that, but generates extra code on architectures that
> don't like unaligned access.
> 

Thanks for the info. We'll reorder them.


> > +static inline uint64_t div64_64(uint64_t dividend, uint64_t divisor)
> 
> Duplicating an existing function? (Or the variant 64/64 is not exported?)

Right. We should've used div64_u64().


> 
> > +{
> > +	uint32_t d = divisor;
> > +
> > +	if (divisor > 0xffffffffUll) {
> > +		unsigned int shift = fls(divisor >> 32);
> > +		d = divisor >> shift;
> > +		dividend >>= shift;
> > +	}
> > +
> > +	if (dividend >> 32)
> > +		do_div(dividend, d);
> > +	else
> > +		dividend = (uint32_t) dividend / d;
> > +
> > +	return dividend;
> > +}
> 
> david

Chul

