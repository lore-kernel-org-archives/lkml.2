Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab0HXOa6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 10:30:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54383 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab0HXOa5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 10:30:57 -0400
Date: Tue, 24 Aug 2010 16:30:11 +0200
From: Jan Kara <jack@suse.cz>
To: Shaohua Li <shaohua.li@intel.com>
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, alex.shi@intel.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH]dquot: do full inode dirty in allocating space
Message-ID: <20100824143011.GF3713@quack.suse.cz>
References: <20100820084943.GA1131@sli10-desk.sh.intel.com>
 <20100824142359.GE3713@quack.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
In-Reply-To: <20100824142359.GE3713@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue 24-08-10 16:23:59, Jan Kara wrote:
>   Hi,
> 
> On Fri 20-08-10 16:49:43, Shaohua Li wrote:
> > Alex Shi found a regression when doing ffsb test. The test has several threads,
> > and each thread creates a small file, write to it and then delete it. ffsb
> > reports about 20% regression and Alex bisected it to 43d2932d88e4. The test
> > will call __mark_inode_dirty 3 times. without this commit, we only take
> > inode_lock one time, while with it, we take the lock 3 times with flags (
> > I_DIRTY_SYNC,I_DIRTY_PAGES,I_DIRTY). Perf shows the lock contention increased
> > too much. Below proposed patch fixes it.
>   Thanks for the analysis and the patch!  With which filesystem have you
> measured the results? And what kind of machine it was?
> 
> > fs is allocating blocks, which usually means file writes and the inode
> > will be dirtied soon. We fully dirty the inode to reduce some inode_lock
> > contention in several calls of __mark_inode_dirty.
>   Well, this is rather a workaround for a poor handling of inode dirty
> bits. BTW, I think Nick's VFS scalability patches address inode_lock
> contention as well so with them the contention you see should be reduced.
>   Anyway, I will take this patch for the time before inode_lock
> contention improves and add a proper comment about this before
> mark_inode_dirty.
  Attached is a version of the patch that is in my tree now.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--T4sUOijqQbZv57TR
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-dquot-do-full-inode-dirty-in-allocating-space.patch"

>From 2a7ad4df051b43a481862fe0afa50539bc7e6b78 Mon Sep 17 00:00:00 2001
From: Shaohua Li <shaohua.li@intel.com>
Date: Fri, 20 Aug 2010 16:49:43 +0800
Subject: [PATCH] dquot: do full inode dirty in allocating space

Alex Shi found a regression when doing ffsb test. The test has several threads,
and each thread creates a small file, write to it and then delete it. ffsb
reports about 20% regression and Alex bisected it to 43d2932d88e4. The test
will call __mark_inode_dirty 3 times. without this commit, we only take
inode_lock one time, while with it, we take the lock 3 times with flags (
I_DIRTY_SYNC,I_DIRTY_PAGES,I_DIRTY). Perf shows the lock contention increased
too much. Below proposed patch fixes it.

fs is allocating blocks, which usually means file writes and the inode
will be dirtied soon. We fully dirty the inode to reduce some inode_lock
contention in several calls of __mark_inode_dirty.

Jan Kara: Added comment.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Alex Shi <alex.shi@intel.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/quotaops.h |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index d50ba85..d1a9193 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -274,8 +274,14 @@ static inline int dquot_alloc_space(struct inode *inode, qsize_t nr)
 	int ret;
 
 	ret = dquot_alloc_space_nodirty(inode, nr);
-	if (!ret)
-		mark_inode_dirty_sync(inode);
+	if (!ret) {
+		/*
+		 * Mark inode fully dirty. Since we are allocating blocks, inode
+		 * would become fully dirty soon anyway and it reportedly
+		 * reduces inode_lock contention.
+		 */
+		mark_inode_dirty(inode);
+	}
 	return ret;
 }
 
-- 
1.6.4.2


--T4sUOijqQbZv57TR--
