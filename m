Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465Ab1HOUbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 16:31:11 -0400
Received: from exprod6og117.obsmtp.com ([64.18.1.39]:47422 "EHLO
	exprod6og117.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab1HOUbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 16:31:08 -0400
X-Greylist: delayed 326 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Aug 2011 16:31:03 EDT
Message-ID: <4E4980BF.7090801@cray.com>
Date: Mon, 15 Aug 2011 15:25:35 -0500
From: Andrew Barry <abarry@cray.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-2.3 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: David Gibson <dwg@au1.ibm.com>, David Gibson <david@gibson.dropbear.id.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Jan Kiszka <jan.kiszka@web.de>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "agraf@suse.de" <agraf@suse.de>, kvm <kvm@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Andrew Hastings <abh@cray.com>,
        Adam Litke <agl@us.ibm.com>, Minchan Kim <minchan.kim@gmail.com>
Subject: Re: Fix refcounting in hugetlbfs quota handling
References: <20110811064059.GU6342@yookeroo.fritz.box> <CA+55aFzXJo78Ah_Qiy6cSHdXHv165nXJ2nTD186NNdCXBABZjA@mail.gmail.com> <CAEwNFnB+5DZQw0CrfkcdP_rd5FBM6fw26=_yS3P283a9TKLNiw@mail.gmail.com> <alpine.LSU.2.00.1108121126560.1290@sister.anvils> <20110813010839.GC30552@yookeroo.fritz.box> <alpine.LSU.2.00.1108151057380.1394@sister.anvils>
In-Reply-To: <alpine.LSU.2.00.1108151057380.1394@sister.anvils>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been doing something similar to this last proposal. I put a
hugetlbfs_sb_info pointer into page_private, and dropped a reference counter and
an active/inactive bit into the hugetlbfs_sb_info struct. At Umount time, the
sbinfo is freed, only if the reference count is zero. Otherwise, the last
put_quota frees the sbinfo structure. This fixed the race we were seeing between
umount and a put_quota from an rdma transaction. I just gave it a cursory test
on a 3.0 kernel; it has seen quite a lot more testing on a 2.6.32-derived
kernel, with no more hits of the umount race.

Does this address the problems you were thinking about?
-Andrew Barry

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 87b6e04..2ed1cca 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -615,8 +615,12 @@ static void hugetlbfs_put_super(struct s
 	struct hugetlbfs_sb_info *sbi = HUGETLBFS_SB(sb);

 	if (sbi) {
+		sbi->active = HPAGE_INACTIVE;
 		sb->s_fs_info = NULL;
-		kfree(sbi);
+
+		/*Free only if used quota is zero. */
+		if (sbi->used_blocks == 0)
+			kfree(sbi);
 	}
 }

@@ -851,6 +855,8 @@ hugetlbfs_fill_super(struct super_block
 	sbinfo->free_blocks = config.nr_blocks;
 	sbinfo->max_inodes = config.nr_inodes;
 	sbinfo->free_inodes = config.nr_inodes;
+	sbinfo->used_blocks = 0;
+	sbinfo->active = HPAGE_ACTIVE;
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
 	sb->s_blocksize = huge_page_size(config.hstate);
 	sb->s_blocksize_bits = huge_page_shift(config.hstate);
@@ -874,30 +880,36 @@ out_free:
 	return -ENOMEM;
 }

-int hugetlb_get_quota(struct address_space *mapping, long delta)
+int hugetlb_get_quota(struct hugetlbfs_sb_info *sbinfo, long delta)
 {
 	int ret = 0;
-	struct hugetlbfs_sb_info *sbinfo = HUGETLBFS_SB(mapping->host->i_sb);

-	if (sbinfo->free_blocks > -1) {
-		spin_lock(&sbinfo->stat_lock);
-		if (sbinfo->free_blocks - delta >= 0)
+	spin_lock(&sbinfo->stat_lock);
+	if ((sbinfo->free_blocks == -1) || (sbinfo->free_blocks - delta >= 0)) {
+		if (sbinfo->free_blocks != -1)
 			sbinfo->free_blocks -= delta;
-		else
-			ret = -ENOMEM;
-		spin_unlock(&sbinfo->stat_lock);
+		sbinfo->used_blocks += delta;
+		sbinfo->active = HPAGE_ACTIVE;
+	} else {
+		ret = -ENOMEM;
 	}
+	spin_unlock(&sbinfo->stat_lock);

 	return ret;
 }

-void hugetlb_put_quota(struct address_space *mapping, long delta)
+void hugetlb_put_quota(struct hugetlbfs_sb_info *sbinfo, long delta)
 {
-	struct hugetlbfs_sb_info *sbinfo = HUGETLBFS_SB(mapping->host->i_sb);
-
-	if (sbinfo->free_blocks > -1) {
-		spin_lock(&sbinfo->stat_lock);
+	spin_lock(&sbinfo->stat_lock);
+	if (sbinfo->free_blocks > -1)
 		sbinfo->free_blocks += delta;
+	sbinfo->used_blocks -= delta;
+	/* If hugetlbfs_put_super couldn't free sbinfo due to
+	* an outstanding quota reference, free it now. */
+	if ((sbinfo->used_blocks == 0) && (sbinfo->active == HPAGE_INACTIVE)) {
+		spin_unlock(&sbinfo->stat_lock);
+		kfree(sbinfo);
+	} else {
 		spin_unlock(&sbinfo->stat_lock);
 	}
 }
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 19644e0..8780a91 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -142,11 +142,16 @@ struct hugetlbfs_config {
 	struct hstate *hstate;
 };

+#define HPAGE_INACTIVE  0
+#define HPAGE_ACTIVE    1
+
 struct hugetlbfs_sb_info {
 	long	max_blocks;   /* blocks allowed */
 	long	free_blocks;  /* blocks free */
 	long	max_inodes;   /* inodes allowed */
 	long	free_inodes;  /* inodes free */
+	long	used_blocks;  /* blocks used */
+	long	active;		  /* active bit */
 	spinlock_t	stat_lock;
 	struct hstate *hstate;
 };
@@ -171,8 +176,8 @@ extern const struct file_operations huge
 extern const struct vm_operations_struct hugetlb_vm_ops;
 struct file *hugetlb_file_setup(const char *name, size_t size, vm_flags_t acct,
 				struct user_struct **user, int creat_flags);
-int hugetlb_get_quota(struct address_space *mapping, long delta);
-void hugetlb_put_quota(struct address_space *mapping, long delta);
+int hugetlb_get_quota(struct hugetlbfs_sb_info *sbinfo, long delta);
+void hugetlb_put_quota(struct hugetlbfs_sb_info *sbinfo, long delta);

 static inline int is_file_hugepages(struct file *file)
 {
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index dae27ba..cf26ae9 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -533,9 +533,9 @@ static void free_huge_page(struct page *
 	 */
 	struct hstate *h = page_hstate(page);
 	int nid = page_to_nid(page);
-	struct address_space *mapping;
+	struct hugetlbfs_sb_info *sbinfo;

-	mapping = (struct address_space *) page_private(page);
+	sbinfo = ( struct hugetlbfs_sb_info *) page_private(page);
 	set_page_private(page, 0);
 	page->mapping = NULL;
 	BUG_ON(page_count(page));
@@ -551,8 +551,8 @@ static void free_huge_page(struct page *
 		enqueue_huge_page(h, page);
 	}
 	spin_unlock(&hugetlb_lock);
-	if (mapping)
-		hugetlb_put_quota(mapping, 1);
+	if (sbinfo)
+		hugetlb_put_quota(sbinfo, 1);
 }

 static void prep_new_huge_page(struct hstate *h, struct page *page, int nid)
@@ -1035,7 +1035,7 @@ static struct page *alloc_huge_page(stru
 	if (chg < 0)
 		return ERR_PTR(-VM_FAULT_OOM);
 	if (chg)
-		if (hugetlb_get_quota(inode->i_mapping, chg))
+		if (hugetlb_get_quota(HUGETLBFS_SB(inode->i_mapping->host->i_sb), chg))
 			return ERR_PTR(-VM_FAULT_SIGBUS);

 	spin_lock(&hugetlb_lock);
@@ -1045,12 +1045,12 @@ static struct page *alloc_huge_page(stru
 	if (!page) {
 		page = alloc_buddy_huge_page(h, NUMA_NO_NODE);
 		if (!page) {
-			hugetlb_put_quota(inode->i_mapping, chg);
+			hugetlb_put_quota(HUGETLBFS_SB(inode->i_mapping->host->i_sb), chg);
 			return ERR_PTR(-VM_FAULT_SIGBUS);
 		}
 	}

-	set_page_private(page, (unsigned long) mapping);
+	set_page_private(page, (unsigned long)
HUGETLBFS_SB(inode->i_mapping->host->i_sb));

 	vma_commit_reservation(h, vma, addr);

@@ -2086,7 +2086,7 @@ static void hugetlb_vm_op_close(struct v

 		if (reserve) {
 			hugetlb_acct_memory(h, -reserve);
-			hugetlb_put_quota(vma->vm_file->f_mapping, reserve);
+			hugetlb_put_quota(HUGETLBFS_SB(vma->vm_file->f_mapping->host->i_sb), reserve);
 		}
 	}
 }
@@ -2884,7 +2884,7 @@ int hugetlb_reserve_pages(struct inode *
 		return chg;

 	/* There must be enough filesystem quota for the mapping */
-	if (hugetlb_get_quota(inode->i_mapping, chg))
+	if (hugetlb_get_quota(HUGETLBFS_SB(inode->i_mapping->host->i_sb), chg))
 		return -ENOSPC;

 	/*
@@ -2893,7 +2893,7 @@ int hugetlb_reserve_pages(struct inode *
 	 */
 	ret = hugetlb_acct_memory(h, chg);
 	if (ret < 0) {
-		hugetlb_put_quota(inode->i_mapping, chg);
+		hugetlb_put_quota(HUGETLBFS_SB(inode->i_mapping->host->i_sb), chg);
 		return ret;
 	}

@@ -2922,7 +2922,7 @@ void hugetlb_unreserve_pages(struct inod
 	inode->i_blocks -= (blocks_per_huge_page(h) * freed);
 	spin_unlock(&inode->i_lock);

-	hugetlb_put_quota(inode->i_mapping, (chg - freed));
+	hugetlb_put_quota(HUGETLBFS_SB(inode->i_mapping->host->i_sb), (chg - freed));
 	hugetlb_acct_memory(h, -(chg - freed));
 }



On 08/15/2011 01:00 PM, Hugh Dickins wrote:
> On Sat, 13 Aug 2011, David Gibson wrote:
>> On Fri, Aug 12, 2011 at 12:15:21PM -0700, Hugh Dickins wrote:
>>>
>>> Setting that aside, I think this thing of grabbing a reference to inode
>>> for each page just does not work as you wish: when we unlink an inode,
>>> all its pages should be freed; but because they are themselves holding
>>> references to the inode, it and its pages stick around forever.
>>
>> Ugh, yes.  You're absolutely right.  That circular reference will mess
>> everything up.  Thinking it through and testing fail.
>>
>>> A quick experiment with your patch versus without confirmed that:
>>> meminfo HugePages_Free stayed down with your patch, but went back to
>>> HugePages_Total without it.  Please check, perhaps I'm just mistaken.
>>>
>>> Sorry, I've not looked into what a constructive alternative might be;
>>> and it's not the first time we've had this difficulty - it came up last
>>> year when the ->freepage function was added, that the inode may be gone
>>> by the time ->freepage(page) is called.
>>
>> Ok, so.  In fact the quota functions we call at free time only need
>> the super block, not the inode per se.  If we put a superblock pointer
>> instead of an inode pointer in page private, and refcounted that, I
>> think that should remove the circular ref.  The only reason I didn't
>> do it before is that the superblock refcounting functions didn't seem
>> to be globally visible in an obvious way.
>>
>> Does that sound like a reasonable approach?
> 
> That does sound closer to a reaonable approach, but my guess is that it
> will suck you into a world of superblock mutexes and semaphores, which
> you cannot take at free_huge_page() time.
> 
> It might be necessary to hang your own tiny structure off the superblock,
> with one refcount for the superblock, and one for each hugepage attached,
> you freeing that structure when the count goes down to zero from either
> direction.
> 
> Whatever you do needs testing with lockdep and atomic sleep checks.
> 
> I do dislike tying these separate levels together in such an unusual way,
> but it is a difficult problem and I don't know of an easy answer.  Maybe
> we'll need to find a better answer for other reasons, it does come up
> from time to time e.g. recent race between evicting inode and nrpages
> going down to 0.
> 
> You might care to take a look at how tmpfs (mm/shmem.c) deals with
> the equivalent issue there (sbinfo->used_blocks).  But I expect you to
> conclude that hugetlbfs cannot afford the kind of approximations that
> tmpfs can afford.
> 
> Although I think tmpfs is more correct, to be associating the count
> with pagecache (so the count goes down as soon as a page is truncated
> or evicted from pagecache), your fewer and huger pages, and reservation
> conventions, may well demand that the count stays up until the page is
> actually freed back to hugepool.  And let's not pretend that what tmpfs
> does is wonderful: the strange shmem_recalc_inode() tries its best to
> notice when memory pressure has freed clean pages, but it never looks
> beyond the inode being accessed at the times it's called.  Not at all
> satisfactory, but not actually an issue in practice, since we stopped
> allocating pages for simple reads from sparse file.  I did want to
> convert tmpfs to use ->freepage(), but couldn't manage it without
> stable mapping - same problem as you have.
> 
> Hugh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

