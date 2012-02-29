Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030642Ab2B2BMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 20:12:32 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:44729 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966198Ab2B2BMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 20:12:31 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 29 Feb 2012 10:10:54 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Thelen <gthelen@google.com>, Jan Kara <jack@suse.cz>,
        Ying Han <yinghan@google.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Rik van Riel <riel@redhat.com>, Andrea Righi <andrea@betterlinux.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/9] memcg: add kernel calls for memcg dirty page stats
Message-Id: <20120229101054.98e121fc.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120228144747.044421224@intel.com>
References: <20120228140022.614718843@intel.com>
	<20120228144747.044421224@intel.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Feb 2012 22:00:25 +0800
Fengguang Wu <fengguang.wu@intel.com> wrote:

> From: Greg Thelen <gthelen@google.com>
> 
> Add calls into memcg dirty page accounting.  Notify memcg when pages
> transition between clean, file dirty, writeback, and unstable nfs.  This
> allows the memory controller to maintain an accurate view of the amount
> of its memory that is dirty.
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>
> Signed-off-by: Andrea Righi <andrea@betterlinux.com>
> Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
> ---
>  fs/nfs/write.c      |    4 ++++
>  mm/filemap.c        |    1 +
>  mm/page-writeback.c |    4 ++++
>  mm/truncate.c       |    1 +
>  4 files changed, 10 insertions(+)
> 
> --- linux.orig/fs/nfs/write.c	2012-02-19 10:53:14.000000000 +0800
> +++ linux/fs/nfs/write.c	2012-02-19 10:53:21.000000000 +0800
> @@ -449,6 +449,7 @@ nfs_mark_request_commit(struct nfs_page 
>  	nfsi->ncommit++;
>  	spin_unlock(&inode->i_lock);
>  	pnfs_mark_request_commit(req, lseg);
> +	mem_cgroup_inc_page_stat(req->wb_page, MEMCG_NR_FILE_UNSTABLE_NFS);

Hmm...Is the status UNSTABLE_NFS cannot be obtaiend by 'struct page' ?

One idea to avoid adding a new flag to pc->flags is..

Can't we do this by following if 'req' exists per page ?

	memcg = mem_cgroup_from_page(page);  # update memcg's refcnt+1
	req->memcg = memcg;		     # record memcg to req.
	mem_cgroup_inc_nfs_unstable(memcg)   # a new call



>  	inc_zone_page_state(req->wb_page, NR_UNSTABLE_NFS);
>  	inc_bdi_stat(req->wb_page->mapping->backing_dev_info, BDI_RECLAIMABLE);
>  	__mark_inode_dirty(inode, I_DIRTY_DATASYNC);
> @@ -460,6 +461,7 @@ nfs_clear_request_commit(struct nfs_page
>  	struct page *page = req->wb_page;
>  
>  	if (test_and_clear_bit(PG_CLEAN, &(req)->wb_flags)) {
> +		mem_cgroup_dec_page_stat(page, MEMCG_NR_FILE_UNSTABLE_NFS);
>  		dec_zone_page_state(page, NR_UNSTABLE_NFS);
>  		dec_bdi_stat(page->mapping->backing_dev_info, BDI_RECLAIMABLE);
>  		return 1;
> @@ -1408,6 +1410,8 @@ void nfs_retry_commit(struct list_head *
>  		req = nfs_list_entry(page_list->next);
>  		nfs_list_remove_request(req);
>  		nfs_mark_request_commit(req, lseg);
> +		mem_cgroup_dec_page_stat(req->wb_page,
> +					 MEMCG_NR_FILE_UNSTABLE_NFS);
>  		dec_zone_page_state(req->wb_page, NR_UNSTABLE_NFS);
>  		dec_bdi_stat(req->wb_page->mapping->backing_dev_info,
>  			     BDI_RECLAIMABLE);
> --- linux.orig/mm/filemap.c	2012-02-19 10:53:14.000000000 +0800
> +++ linux/mm/filemap.c	2012-02-19 10:53:21.000000000 +0800
> @@ -142,6 +142,7 @@ void __delete_from_page_cache(struct pag
>  	 * having removed the page entirely.
>  	 */
>  	if (PageDirty(page) && mapping_cap_account_dirty(mapping)) {
> +		mem_cgroup_dec_page_stat(page, MEMCG_NR_FILE_DIRTY);


I think we can make use of PageDirty() as explained.

Thanks,
-Kame

