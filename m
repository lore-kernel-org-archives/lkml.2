Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758522Ab1DZVn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:43:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56740 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758438Ab1DZVnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:43:25 -0400
Date: Tue, 26 Apr 2011 14:42:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        Mel Gorman <mel@linux.vnet.ibm.com>,
        Dave Chinner <david@fromorbit.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Itaru Kitayama <kitayama@cl.bb4u.ne.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [PATCH 1/2] split inode_wb_list_lock into
 bdi_writeback.list_lock
Message-Id: <20110426144209.06317674.akpm@linux-foundation.org>
In-Reply-To: <20110426144218.GA14862@localhost>
References: <20110426144218.GA14862@localhost>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Apr 2011 22:42:19 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> @@ -55,13 +55,16 @@ EXPORT_SYMBOL(I_BDEV);
>  static void bdev_inode_switch_bdi(struct inode *inode,
>  			struct backing_dev_info *dst)
>  {
> -	spin_lock(&inode_wb_list_lock);
> +	struct backing_dev_info *old = inode->i_data.backing_dev_info;
> +
> +	bdi_lock_two(&old->wb, &dst->wb);
>  	spin_lock(&inode->i_lock);
>  	inode->i_data.backing_dev_info = dst;
>  	if (inode->i_state & I_DIRTY)
>  		list_move(&inode->i_wb_list, &dst->wb.b_dirty);
>  	spin_unlock(&inode->i_lock);
> -	spin_unlock(&inode_wb_list_lock);
> +	spin_unlock(&old->wb.list_lock);
> +	spin_unlock(&dst->wb.list_lock);
>  }

Has this patch been well tested under lockdep?
