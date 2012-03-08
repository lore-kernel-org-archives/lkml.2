Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481Ab2CHL7a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 06:59:30 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:49452 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720Ab2CHL72 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 06:59:28 -0500
MIME-Version: 1.0
In-Reply-To: <87boo7afr2.fsf@linux.vnet.ibm.com>
References: <1331095694-27780-1-git-send-email-david@gibson.dropbear.id.au>
	<1331095694-27780-2-git-send-email-david@gibson.dropbear.id.au>
	<CAJd=RBCPFtyLzxyzRVKzypErt_Te1guT8gi6qu1cLvNVFVOgKQ@mail.gmail.com>
	<87boo7afr2.fsf@linux.vnet.ibm.com>
Date: Thu, 8 Mar 2012 19:59:27 +0800
Message-ID: <CAJd=RBDQmw6zP5nF41cjQ6oJDiDX1bUKTVwG03BpkG=h+Qt6ow@mail.gmail.com>
Subject: Re: [PATCH 2/2] hugepages: Fix use after free bug in "quota" handling
From: Hillf Danton <dhillf@gmail.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: David Gibson <david@gibson.dropbear.id.au>, akpm@linux-foundation.org,
        hughd@google.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        Andrew Barry <abarry@cray.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan.kim@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 8, 2012 at 12:17 PM, Aneesh Kumar K.V
<aneesh.kumar@linux.vnet.ibm.com> wrote:
> On Wed, 7 Mar 2012 20:28:39 +0800, Hillf Danton <dhillf@gmail.com> wrote:
>> On Wed, Mar 7, 2012 at 12:48 PM, David Gibson
>> > @@ -533,9 +611,9 @@ static void free_huge_page(struct page *page)
>> >         */
>> >        struct hstate *h = page_hstate(page);
>> >        int nid = page_to_nid(page);
>> > -       struct address_space *mapping;
>> > +       struct hugepage_subpool *spool =
>> > +               (struct hugepage_subpool *)page_private(page);
>> >
>> > -       mapping = (struct address_space *) page_private(page);
>> >        set_page_private(page, 0);
>> >        page->mapping = NULL;
>> >        BUG_ON(page_count(page));
>> > @@ -551,8 +629,7 @@ static void free_huge_page(struct page *page)
>> >                enqueue_huge_page(h, page);
>> >        }
>> >        spin_unlock(&hugetlb_lock);
>> > -       if (mapping)
>> > -               hugetlb_put_quota(mapping, 1);
>> > +       hugepage_subpool_put_pages(spool, 1);
>>
>> Like current code, quota is handed back *unconditionally*, but ...
>
>
> We will end up doing get_quota for every allocated page. get_quota
> happens either during mmap() if MAP_NORESERVE is not specified.
> or during alloc_huge_page if we haven't done a quota reservation during
> mmap for that range. Are you finding any part of code where we miss that ?
>
>
Thank you, Aneesh, I work it out along the direction of your question.

Apart from David's approach, quota is no longer reclaimed when pages are freed,
but when they are truncated, and we end up with smaller .text size, and with
the use-after-free bug fixed as well.

-hd

--- a/mm/hugetlb.c	Mon Mar  5 20:20:34 2012
+++ b/mm/hugetlb.c	Thu Mar  8 19:47:26 2012
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
@@ -2944,8 +2940,8 @@ void hugetlb_unreserve_pages(struct inod
 	inode->i_blocks -= (blocks_per_huge_page(h) * freed);
 	spin_unlock(&inode->i_lock);

-	hugetlb_put_quota(inode->i_mapping, (chg - freed));
-	hugetlb_acct_memory(h, -(chg - freed));
+	hugetlb_put_quota(inode->i_mapping, chg);
+	hugetlb_acct_memory(h, -chg);
 }

 #ifdef CONFIG_MEMORY_FAILURE
--
