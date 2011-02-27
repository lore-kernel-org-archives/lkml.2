Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab1B0RB4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 12:01:56 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50150 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab1B0RBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 12:01:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=hdu2rnXJbKmNtINsuPD0oqovq8/R1qUnNzhIBIYoYpYzYo4WL1iBv5vOkfQray58Du
         Kiu39gwyVda941Vc8urb2/iyOW96xET3fbTZ3+MkZQBzPxkJGebUTnrrIr6njDMaDuXJ
         Q/0RAN4AI2OsJUAhZW0PUwAz4uEmliHHFQe7U=
Date: Mon, 28 Feb 2011 02:01:43 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Chad Talbott <ctalbott@google.com>,
        Justin TerAvest <teravest@google.com>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v5 6/9] memcg: add kernel calls for memcg dirty page
 stats
Message-ID: <20110227170143.GE3226@barrios-desktop>
References: <1298669760-26344-1-git-send-email-gthelen@google.com>
 <1298669760-26344-7-git-send-email-gthelen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298669760-26344-7-git-send-email-gthelen@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 01:35:57PM -0800, Greg Thelen wrote:
> Add calls into memcg dirty page accounting.  Notify memcg when pages
> transition between clean, file dirty, writeback, and unstable nfs.
> This allows the memory controller to maintain an accurate view of
> the amount of its memory that is dirty.
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>
> Signed-off-by: Andrea Righi <arighi@develer.com>
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> ---
>  fs/nfs/write.c      |    4 ++++
>  mm/filemap.c        |    1 +
>  mm/page-writeback.c |    4 ++++
>  mm/truncate.c       |    1 +
>  4 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/nfs/write.c b/fs/nfs/write.c
> index c8278f4..118935b 100644
> --- a/fs/nfs/write.c
> +++ b/fs/nfs/write.c
> @@ -451,6 +451,7 @@ nfs_mark_request_commit(struct nfs_page *req)
>  			NFS_PAGE_TAG_COMMIT);
>  	nfsi->ncommit++;
>  	spin_unlock(&inode->i_lock);
> +	mem_cgroup_inc_page_stat(req->wb_page, MEMCG_NR_FILE_UNSTABLE_NFS);
>  	inc_zone_page_state(req->wb_page, NR_UNSTABLE_NFS);
>  	inc_bdi_stat(req->wb_page->mapping->backing_dev_info, BDI_RECLAIMABLE);
>  	__mark_inode_dirty(inode, I_DIRTY_DATASYNC);
> @@ -462,6 +463,7 @@ nfs_clear_request_commit(struct nfs_page *req)
>  	struct page *page = req->wb_page;
>  
>  	if (test_and_clear_bit(PG_CLEAN, &(req)->wb_flags)) {
> +		mem_cgroup_dec_page_stat(page, MEMCG_NR_FILE_UNSTABLE_NFS);
>  		dec_zone_page_state(page, NR_UNSTABLE_NFS);
>  		dec_bdi_stat(page->mapping->backing_dev_info, BDI_RECLAIMABLE);
>  		return 1;
> @@ -1317,6 +1319,8 @@ nfs_commit_list(struct inode *inode, struct list_head *head, int how)
>  		req = nfs_list_entry(head->next);
>  		nfs_list_remove_request(req);
>  		nfs_mark_request_commit(req);
> +		mem_cgroup_dec_page_stat(req->wb_page,
> +					 MEMCG_NR_FILE_UNSTABLE_NFS);
>  		dec_zone_page_state(req->wb_page, NR_UNSTABLE_NFS);
>  		dec_bdi_stat(req->wb_page->mapping->backing_dev_info,
>  				BDI_RECLAIMABLE);
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 7b137b4..e234b8d 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -143,6 +143,7 @@ void __delete_from_page_cache(struct page *page)
>  	 * having removed the page entirely.
>  	 */
>  	if (PageDirty(page) && mapping_cap_account_dirty(mapping)) {
> +		mem_cgroup_dec_page_stat(page, MEMCG_NR_FILE_DIRTY);
>  		dec_zone_page_state(page, NR_FILE_DIRTY);
>  		dec_bdi_stat(mapping->backing_dev_info, BDI_RECLAIMABLE);
>  	}
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index 00424b9..8d61cfa 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -1119,6 +1119,7 @@ int __set_page_dirty_no_writeback(struct page *page)
>  void account_page_dirtied(struct page *page, struct address_space *mapping)
>  {
>  	if (mapping_cap_account_dirty(mapping)) {
> +		mem_cgroup_inc_page_stat(page, MEMCG_NR_FILE_DIRTY);
>  		__inc_zone_page_state(page, NR_FILE_DIRTY);
>  		__inc_zone_page_state(page, NR_DIRTIED);
>  		__inc_bdi_stat(mapping->backing_dev_info, BDI_RECLAIMABLE);
> @@ -1308,6 +1309,7 @@ int clear_page_dirty_for_io(struct page *page)
>  		 * for more comments.
>  		 */
>  		if (TestClearPageDirty(page)) {
> +			mem_cgroup_dec_page_stat(page, MEMCG_NR_FILE_DIRTY);
>  			dec_zone_page_state(page, NR_FILE_DIRTY);
>  			dec_bdi_stat(mapping->backing_dev_info,
>  					BDI_RECLAIMABLE);
> @@ -1338,6 +1340,7 @@ int test_clear_page_writeback(struct page *page)
>  				__dec_bdi_stat(bdi, BDI_WRITEBACK);
>  				__bdi_writeout_inc(bdi);
>  			}
> +			mem_cgroup_dec_page_stat(page, MEMCG_NR_FILE_WRITEBACK);
>  		}
>  		spin_unlock_irqrestore(&mapping->tree_lock, flags);
>  	} else {
> @@ -1365,6 +1368,7 @@ int test_set_page_writeback(struct page *page)
>  						PAGECACHE_TAG_WRITEBACK);
>  			if (bdi_cap_account_writeback(bdi))
>  				__inc_bdi_stat(bdi, BDI_WRITEBACK);
> +			mem_cgroup_inc_page_stat(page, MEMCG_NR_FILE_WRITEBACK);

Question:
Why should we care of BDI_CAP_NO_WRITEBACK?


-- 
Kind regards,
Minchan Kim
