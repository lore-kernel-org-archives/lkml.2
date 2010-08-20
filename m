Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab0HTIts (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 04:49:48 -0400
Received: from mga01.intel.com ([192.55.52.88]:26582 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753129Ab0HTItp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 04:49:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,238,1280732400"; 
   d="scan'208";a="598536527"
Date: Fri, 20 Aug 2010 16:49:43 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: linux-kernel@vger.kernel.org
Cc: jack@suse.cz, alex.shi@intel.com, akpm@linux-foundation.org
Subject: [PATCH]dquot: do full inode dirty in allocating space
Message-ID: <20100820084943.GA1131@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
Signed-off-by: Alex Shi <alex.shi@intel.com>

diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index d50ba85..8dd2cc3 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -275,7 +275,7 @@ static inline int dquot_alloc_space(struct inode *inode, qsize_t nr)
 
 	ret = dquot_alloc_space_nodirty(inode, nr);
 	if (!ret)
-		mark_inode_dirty_sync(inode);
+		mark_inode_dirty(inode);
 	return ret;
 }
 
