Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab0HXOYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 10:24:48 -0400
Received: from cantor.suse.de ([195.135.220.2]:52347 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755009Ab0HXOYq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 10:24:46 -0400
Date: Tue, 24 Aug 2010 16:23:59 +0200
From: Jan Kara <jack@suse.cz>
To: Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, alex.shi@intel.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH]dquot: do full inode dirty in allocating space
Message-ID: <20100824142359.GE3713@quack.suse.cz>
References: <20100820084943.GA1131@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100820084943.GA1131@sli10-desk.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

On Fri 20-08-10 16:49:43, Shaohua Li wrote:
> Alex Shi found a regression when doing ffsb test. The test has several threads,
> and each thread creates a small file, write to it and then delete it. ffsb
> reports about 20% regression and Alex bisected it to 43d2932d88e4. The test
> will call __mark_inode_dirty 3 times. without this commit, we only take
> inode_lock one time, while with it, we take the lock 3 times with flags (
> I_DIRTY_SYNC,I_DIRTY_PAGES,I_DIRTY). Perf shows the lock contention increased
> too much. Below proposed patch fixes it.
  Thanks for the analysis and the patch!  With which filesystem have you
measured the results? And what kind of machine it was?

> fs is allocating blocks, which usually means file writes and the inode
> will be dirtied soon. We fully dirty the inode to reduce some inode_lock
> contention in several calls of __mark_inode_dirty.
  Well, this is rather a workaround for a poor handling of inode dirty
bits. BTW, I think Nick's VFS scalability patches address inode_lock
contention as well so with them the contention you see should be reduced.
  Anyway, I will take this patch for the time before inode_lock
contention improves and add a proper comment about this before
mark_inode_dirty.

								Honza
> 
> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> 
> diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
> index d50ba85..8dd2cc3 100644
> --- a/include/linux/quotaops.h
> +++ b/include/linux/quotaops.h
> @@ -275,7 +275,7 @@ static inline int dquot_alloc_space(struct inode *inode, qsize_t nr)
>  
>  	ret = dquot_alloc_space_nodirty(inode, nr);
>  	if (!ret)
> -		mark_inode_dirty_sync(inode);
> +		mark_inode_dirty(inode);
>  	return ret;
>  }
>  
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
