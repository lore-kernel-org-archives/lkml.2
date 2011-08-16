Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751794Ab1HPRps (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 13:45:48 -0400
Received: from exprod6og115.obsmtp.com ([64.18.1.35]:52424 "EHLO
	exprod6og115.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab1HPRpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 13:45:46 -0400
Message-ID: <4E4AACB8.3090007@cray.com>
Date: Tue, 16 Aug 2011 12:45:28 -0500
From: Andrew Barry <abarry@cray.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-2.3 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Hugh Dickins <hughd@google.com>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Jan Kiszka <jan.kiszka@web.de>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "agraf@suse.de" <agraf@suse.de>, kvm <kvm@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Andrew Hastings <abh@cray.com>,
        Adam Litke <agl@us.ibm.com>, Minchan Kim <minchan.kim@gmail.com>
Subject: [RFC PATCH] mm/hugepages: Fix race between hugetlbfs umount and quota
 update.
References: <20110811064059.GU6342@yookeroo.fritz.box> <CA+55aFzXJo78Ah_Qiy6cSHdXHv165nXJ2nTD186NNdCXBABZjA@mail.gmail.com> <CAEwNFnB+5DZQw0CrfkcdP_rd5FBM6fw26=_yS3P283a9TKLNiw@mail.gmail.com> <alpine.LSU.2.00.1108121126560.1290@sister.anvils> <20110813010839.GC30552@yookeroo.fritz.box> <alpine.LSU.2.00.1108151057380.1394@sister.anvils> <4E4980BF.7090801@cray.com> <20110816034748.GG18203@yookeroo.fritz.box>
In-Reply-To: <20110816034748.GG18203@yookeroo.fritz.box>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Discussion was titled:  Fix refcounting in hugetlbfs quota handling

This patch fixes a race between the umount of a hugetlbfs filesystem, and quota
updates in that filesystem, which can result in the update of the filesystem
quota record, after the record structure has been freed.

Rather than an address-space struct pointer, it puts a hugetlbfs_sb_info struct
pointer into page_private of the page struct. A reference count and an active
bit are added to the hugetlbfs_sb_info struct; the reference count is increased
by hugetlb_get_quota and decreased by hugetlb_put_quota. When hugetlbfs is
unmounted, it frees the hugetlbfs_sb_info struct, but only if the reference
count is zero, otherwise it clears the active bit. The last hugetlb_put_quota
then frees the hugetlbfs_sb_info struct.

Signed-off-by: Andrew Barry <abarry@cray.com>

---

 fs/hugetlbfs/inode.c    |   40 ++++++++++++++++++++++++++--------------
 include/linux/hugetlb.h |    9 +++++++--
 mm/hugetlb.c            |   22 +++++++++++-----------
 3 files changed, 44 insertions(+), 27 deletions(-)


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


On 08/15/2011 10:47 PM, David Gibson wrote:
> On Mon, Aug 15, 2011 at 03:25:35PM -0500, Andrew Barry wrote:
>> I've been doing something similar to this last proposal. I put a
>> hugetlbfs_sb_info pointer into page_private, and dropped a reference counter and
>> an active/inactive bit into the hugetlbfs_sb_info struct. At Umount time, the
>> sbinfo is freed, only if the reference count is zero. Otherwise, the last
>> put_quota frees the sbinfo structure. This fixed the race we were seeing between
>> umount and a put_quota from an rdma transaction. I just gave it a cursory test
>> on a 3.0 kernel; it has seen quite a lot more testing on a 2.6.32-derived
>> kernel, with no more hits of the umount race.
>>
>> Does this address the problems you were thinking about?
> 
> Ah, this looks much better than my patch.  And the fact that you've
> seen your race demonstrates clearly that this isn't just a kvm
> problem.  I hope we can push this upstream very soon - what can I do
> to help?
> 
>> -Andrew Barry
>>



