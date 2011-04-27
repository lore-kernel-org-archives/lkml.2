Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757721Ab1D0CeU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 22:34:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:36008 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756811Ab1D0CeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 22:34:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,272,1301900400"; 
   d="scan'208";a="914860445"
Date: Wed, 27 Apr 2011 10:34:04 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
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
Message-ID: <20110427023404.GA5821@localhost>
References: <20110426144218.GA14862@localhost>
 <20110426144209.06317674.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110426144209.06317674.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 05:42:09AM +0800, Andrew Morton wrote:
> On Tue, 26 Apr 2011 22:42:19 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > @@ -55,13 +55,16 @@ EXPORT_SYMBOL(I_BDEV);
> >  static void bdev_inode_switch_bdi(struct inode *inode,
> >  			struct backing_dev_info *dst)
> >  {
> > -	spin_lock(&inode_wb_list_lock);
> > +	struct backing_dev_info *old = inode->i_data.backing_dev_info;
> > +
> > +	bdi_lock_two(&old->wb, &dst->wb);
> >  	spin_lock(&inode->i_lock);
> >  	inode->i_data.backing_dev_info = dst;
> >  	if (inode->i_state & I_DIRTY)
> >  		list_move(&inode->i_wb_list, &dst->wb.b_dirty);
> >  	spin_unlock(&inode->i_lock);
> > -	spin_unlock(&inode_wb_list_lock);
> > +	spin_unlock(&old->wb.list_lock);
> > +	spin_unlock(&dst->wb.list_lock);
> >  }
> 
> Has this patch been well tested under lockdep?

Yes, it runs OK on concurrent dd and dd+tar workloads over all major
filesystems, including NFS. Lockdep is always enabled in my kernels,
no warnings are found in dmesg.

Thanks,
Fengguang
