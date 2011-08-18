Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140Ab1HRW3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 18:29:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52956 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754351Ab1HRW3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 18:29:30 -0400
Date: Thu, 18 Aug 2011 15:28:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andrew Barry <abarry@cray.com>
Cc: linux-mm <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [PATCH 1/1] hugepages: Fix race between hugetlbfs umount and
 quota update.
Message-Id: <20110818152846.e76ff944.akpm@linux-foundation.org>
In-Reply-To: <4E4C3A2B.3000405@cray.com>
References: <4E4C3A2B.3000405@cray.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Aug 2011 17:01:15 -0500
Andrew Barry <abarry@cray.com> wrote:

> This patch fixes a race between the umount of a hugetlbfs filesystem, and quota
> updates in that filesystem, which can result in the update of the filesystem
> quota record, after the record structure has been freed.
> 
> Rather than an address-space struct pointer, it puts a hugetlbfs_sb_info struct
> pointer into page_private of the page struct. A reference count and an active
> bit are added to the hugetlbfs_sb_info struct; the reference count is increased
> by hugetlb_get_quota and decreased by hugetlb_put_quota. When hugetlbfs is
> unmounted, it frees the hugetlbfs_sb_info struct, but only if the reference
> count is zero, otherwise it clears the active bit. The last hugetlb_put_quota
> then frees the hugetlbfs_sb_info struct.
> 
> Discussion was titled:  Fix refcounting in hugetlbfs quota handling.
> See:  https://lkml.org/lkml/2011/8/11/28

The changelog doesn't actually describe the race - it just asserts that
there is one.  This makes it unnecessarily difficult to review the
fix!  So I didn't really look at the code - I just scanned the trivial
stuff.

The patch was somewhat wordwrapped - please fix the email client then
resend.

> +		if (hugetlb_get_quota(HUGETLBFS_SB(inode->i_mapping->host->i_sb), chg))
> +			hugetlb_put_quota(HUGETLBFS_SB(inode->i_mapping->host->i_sb), chg);
> +	set_page_private(page, (unsigned long)HUGETLBFS_SB(inode->i_mapping->host->i_sb));
> +			hugetlb_put_quota(HUGETLBFS_SB(vma->vm_file->f_mapping->host->i_sb), reserve);
> +	if (hugetlb_get_quota(HUGETLBFS_SB(inode->i_mapping->host->i_sb), chg))
> +		hugetlb_put_quota(HUGETLBFS_SB(inode->i_mapping->host->i_sb), chg);
> +	hugetlb_put_quota(HUGETLBFS_SB(inode->i_mapping->host->i_sb), (chg - freed));

Are all the inode->i_mapping->host pointer hops actually necessary?  I
didn't see anything about them in the changelog and I'd expect that
inode->i_mapping->host is always equal to `inode' for hugetlbfs?

If they _are_ necessary then I'd suggest that the code could be cleaned
up by adding

static struct hugetlbfs_sb_info *inode_to_sb(struct inode *inode)
{
	return HUGETLBFS_SB(inode->i_mapping->host->i_sb);
}

to hugetlbfs.c.  This will reduce the relatively large number of
checkpatch warnings which were added.
