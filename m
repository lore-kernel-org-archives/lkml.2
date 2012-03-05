Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964912Ab2CEN4x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 08:56:53 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37674 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932327Ab2CEN4v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:56:51 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dhillf@gmail.com designates 10.68.234.166 as permitted sender) smtp.mail=dhillf@gmail.com; dkim=pass header.i=dhillf@gmail.com
MIME-Version: 1.0
In-Reply-To: <878vjgdvo4.fsf@linux.vnet.ibm.com>
References: <1330593380-1361-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<20120301144029.545a5589.akpm@linux-foundation.org>
	<878vjgdvo4.fsf@linux.vnet.ibm.com>
Date: Mon, 5 Mar 2012 21:56:50 +0800
Message-ID: <CAJd=RBAJxVs0Jz+=PNO222oDvF0n6+hh7FNuFpSYTS3EJL8fpw@mail.gmail.com>
Subject: Re: [PATCH -V2 0/9] memcg: add HugeTLB resource tracking
From: Hillf Danton <dhillf@gmail.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com, aarcange@redhat.com,
        mhocko@suse.cz, hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 5, 2012 at 3:15 AM, Aneesh Kumar K.V
<aneesh.kumar@linux.vnet.ibm.com> wrote:
> On Thu, 1 Mar 2012 14:40:29 -0800, Andrew Morton <akpm@linux-foundation.org> wrote:
>> I haven't begin to get my head around this yet, but I'd like to draw
>> your attention to https://lkml.org/lkml/2012/2/15/548.
>
> Hmm that's really serious bug.
>
>>  That fix has
>> been hanging around for a while, but I haven't done anything with it
>> yet because I don't like its additional blurring of the separation
>> between hugetlb core code and hugetlbfs.  I want to find time to sit
>> down and see if the fix can be better architected but haven't got
>> around to that yet.
>>
>> I expect that your patches will conflict at least mechanically with
>> David's, which is not a big issue.  But I wonder whether your patches
>> will copy the same bug into other places, and whether you can think of
>> a tidier way of addressing the bug which David is seeing?
>>
>
> I will go through the implementation again and make sure the problem
> explained by David doesn't happen in the new code path added by the
> patch series.
>
Hi Aneesh

When you tackle that problem, please take the following approach also
into account, though it is a draft, in which quota handback is simply
eliminated when huge page is freed, if that problem is caused by extra
reference count.
And get_quota is carefully paired with put_quota for newly allocated
page. That is all, and feel free to correct me.

Best Regards
-hd

--- a/mm/hugetlb.c	Mon Mar  5 20:20:34 2012
+++ b/mm/hugetlb.c	Mon Mar  5 21:20:14 2012
@@ -533,9 +533,7 @@ static void free_huge_page(struct page *
 	 */
 	struct hstate *h = page_hstate(page);
 	int nid = page_to_nid(page);
-	struct address_space *mapping;

-	mapping = (struct address_space *) page_private(page);
 	set_page_private(page, 0);
 	page->mapping = NULL;
 	BUG_ON(page_count(page));
@@ -551,8 +549,6 @@ static void free_huge_page(struct page *
 		enqueue_huge_page(h, page);
 	}
 	spin_unlock(&hugetlb_lock);
-	if (mapping)
-		hugetlb_put_quota(mapping, 1);
 }

 static void prep_new_huge_page(struct hstate *h, struct page *page, int nid)
@@ -1021,7 +1017,8 @@ static void vma_commit_reservation(struc
 }

 static struct page *alloc_huge_page(struct vm_area_struct *vma,
-				    unsigned long addr, int avoid_reserve)
+				    unsigned long addr, int avoid_reserve,
+				    long *quota)
 {
 	struct hstate *h = hstate_vma(vma);
 	struct page *page;
@@ -1050,7 +1047,8 @@ static struct page *alloc_huge_page(stru
 	if (!page) {
 		page = alloc_buddy_huge_page(h, NUMA_NO_NODE);
 		if (!page) {
-			hugetlb_put_quota(inode->i_mapping, chg);
+			if (chg)
+				hugetlb_put_quota(inode->i_mapping, chg);
 			return ERR_PTR(-VM_FAULT_SIGBUS);
 		}
 	}
@@ -1058,6 +1056,8 @@ static struct page *alloc_huge_page(stru
 	set_page_private(page, (unsigned long) mapping);

 	vma_commit_reservation(h, vma, addr);
+	if (quota)
+		*quota = chg;

 	return page;
 }
@@ -2365,6 +2365,7 @@ static int hugetlb_cow(struct mm_struct
 	struct page *old_page, *new_page;
 	int avoidcopy;
 	int outside_reserve = 0;
+	long quota = 0;

 	old_page = pte_page(pte);

@@ -2397,7 +2398,8 @@ retry_avoidcopy:

 	/* Drop page_table_lock as buddy allocator may be called */
 	spin_unlock(&mm->page_table_lock);
-	new_page = alloc_huge_page(vma, address, outside_reserve);
+	quota = 0;
+	new_page = alloc_huge_page(vma, address, outside_reserve, &quota);

 	if (IS_ERR(new_page)) {
 		page_cache_release(old_page);
@@ -2439,6 +2441,8 @@ retry_avoidcopy:
 	if (unlikely(anon_vma_prepare(vma))) {
 		page_cache_release(new_page);
 		page_cache_release(old_page);
+		if (quota)
+			hugetlb_put_quota(vma->vm_file->f_mapping, quota);
 		/* Caller expects lock to be held */
 		spin_lock(&mm->page_table_lock);
 		return VM_FAULT_OOM;
@@ -2470,6 +2474,8 @@ retry_avoidcopy:
 			address & huge_page_mask(h),
 			(address & huge_page_mask(h)) + huge_page_size(h));
 	}
+	else if (quota)
+		hugetlb_put_quota(vma->vm_file->f_mapping, quota);
 	page_cache_release(new_page);
 	page_cache_release(old_page);
 	return 0;
@@ -2519,6 +2525,7 @@ static int hugetlb_no_page(struct mm_str
 	struct page *page;
 	struct address_space *mapping;
 	pte_t new_pte;
+	long quota = 0;

 	/*
 	 * Currently, we are forced to kill the process in the event the
@@ -2540,12 +2547,13 @@ static int hugetlb_no_page(struct mm_str
 	 * before we get page_table_lock.
 	 */
 retry:
+	quota = 0;
 	page = find_lock_page(mapping, idx);
 	if (!page) {
 		size = i_size_read(mapping->host) >> huge_page_shift(h);
 		if (idx >= size)
 			goto out;
-		page = alloc_huge_page(vma, address, 0);
+		page = alloc_huge_page(vma, address, 0, &quota);
 		if (IS_ERR(page)) {
 			ret = -PTR_ERR(page);
 			goto out;
@@ -2560,6 +2568,8 @@ retry:
 			err = add_to_page_cache(page, mapping, idx, GFP_KERNEL);
 			if (err) {
 				put_page(page);
+				if (quota)
+					hugetlb_put_quota(mapping, quota);
 				if (err == -EEXIST)
 					goto retry;
 				goto out;
@@ -2633,6 +2643,8 @@ backout:
 backout_unlocked:
 	unlock_page(page);
 	put_page(page);
+	if (quota)
+		hugetlb_put_quota(mapping, quota);
 	goto out;
 }

--
