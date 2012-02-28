Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757185Ab2B1MRa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 07:17:30 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:47116 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab2B1MR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 07:17:29 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dhillf@gmail.com designates 10.52.20.78 as permitted sender) smtp.mail=dhillf@gmail.com; dkim=pass header.i=dhillf@gmail.com
MIME-Version: 1.0
In-Reply-To: <87ipirclhe.fsf@linux.vnet.ibm.com>
References: <1330280398-27956-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<20120227151135.7d4076c6.akpm@linux-foundation.org>
	<87ipirclhe.fsf@linux.vnet.ibm.com>
Date: Tue, 28 Feb 2012 20:17:28 +0800
Message-ID: <CAJd=RBA05LqrUohAfO43ywZR_xwi4KygpzZP2zun=taKTLCvnQ@mail.gmail.com>
Subject: Re: [PATCH] hugetlbfs: Add new rw_semaphore to fix truncate/read race
From: Hillf Danton <dhillf@gmail.com>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, hughd@google.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 6:15 PM, Aneesh Kumar K.V
<aneesh.kumar@linux.vnet.ibm.com> wrote:
>
> Will update the patch with these details
>

A scratch is cooked, based on the -next tree, for accelerating your redelivery,
if you like it, in which i_mutex is eliminated directly and page lock is used.

-hd


--- a/fs/hugetlbfs/inode.c	Tue Feb 28 19:43:32 2012
+++ b/fs/hugetlbfs/inode.c	Tue Feb 28 19:56:50 2012
@@ -245,17 +245,10 @@ static ssize_t hugetlbfs_read(struct fil
 	loff_t isize;
 	ssize_t retval = 0;

-	mutex_lock(&inode->i_mutex);
-
 	/* validate length */
 	if (len == 0)
 		goto out;

-	isize = i_size_read(inode);
-	if (!isize)
-		goto out;
-
-	end_index = (isize - 1) >> huge_page_shift(h);
 	for (;;) {
 		struct page *page;
 		unsigned long nr, ret;
@@ -263,6 +256,8 @@ static ssize_t hugetlbfs_read(struct fil

 		/* nr is the maximum number of bytes to copy from this page */
 		nr = huge_page_size(h);
+		isize = i_size_read(inode);
+		end_index = isize >> huge_page_shift(h);
 		if (index >= end_index) {
 			if (index > end_index)
 				goto out;
@@ -274,7 +269,7 @@ static ssize_t hugetlbfs_read(struct fil
 		nr = nr - offset;

 		/* Find the page */
-		page = find_get_page(mapping, index);
+		page = find_lock_page(mapping, index);
 		if (unlikely(page == NULL)) {
 			/*
 			 * We have a HOLE, zero out the user-buffer for the
@@ -286,17 +281,30 @@ static ssize_t hugetlbfs_read(struct fil
 			else
 				ra = 0;
 		} else {
+			unlock_page(page);
+
+			/* Without i_mutex held, check isize again */
+			nr = huge_page_size(h);
+			isize = i_size_read(inode);
+			end_index = isize >> huge_page_shift(h);
+			if (index == end_index) {
+				nr = isize & ~huge_page_mask(h);
+				if (nr <= offset) {
+					page_cache_release(page);
+					goto out;
+				}
+			}
+			nr -= offset;
 			/*
 			 * We have the page, copy it to user space buffer.
 			 */
 			ra = hugetlbfs_read_actor(page, offset, buf, len, nr);
 			ret = ra;
+			page_cache_release(page);
 		}
 		if (ra < 0) {
 			if (retval == 0)
 				retval = ra;
-			if (page)
-				page_cache_release(page);
 			goto out;
 		}

@@ -306,16 +314,12 @@ static ssize_t hugetlbfs_read(struct fil
 		index += offset >> huge_page_shift(h);
 		offset &= ~huge_page_mask(h);

-		if (page)
-			page_cache_release(page);
-
 		/* short read or no more work */
 		if ((ret != nr) || (len == 0))
 			break;
 	}
 out:
 	*ppos = ((loff_t)index << huge_page_shift(h)) + offset;
-	mutex_unlock(&inode->i_mutex);
 	return retval;
 }

--
