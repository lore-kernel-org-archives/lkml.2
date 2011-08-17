Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab1HQQRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 12:17:36 -0400
Received: from smtp-out.google.com ([216.239.44.51]:40905 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059Ab1HQQRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 12:17:33 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=QnZFJIFyjFYexWx2/VxsR0VT8v4i//yd1IiW3iz21oZ6onCvnXwh6LFjZitTPtS8s
	DiCDtgClUl4k2uBjD9otg==
From: Greg Thelen <gthelen@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        containers@lists.osdl.org, linux-fsdevel@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Dave Chinner <david@fromorbit.com>, Vivek Goyal <vgoyal@redhat.com>,
        Andrea Righi <andrea@betterlinux.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>, Greg Thelen <gthelen@google.com>
Subject: [PATCH v9 02/13] memcg: add page_cgroup flags for dirty page tracking
Date: Wed, 17 Aug 2011 09:14:54 -0700
Message-Id: <1313597705-6093-3-git-send-email-gthelen@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1313597705-6093-1-git-send-email-gthelen@google.com>
References: <1313597705-6093-1-git-send-email-gthelen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add additional flags to page_cgroup to track dirty pages
within a mem_cgroup.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrea Righi <andrea@betterlinux.com>
Signed-off-by: Greg Thelen <gthelen@google.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
---
 include/linux/page_cgroup.h |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
index 961ecc7..66d3245 100644
--- a/include/linux/page_cgroup.h
+++ b/include/linux/page_cgroup.h
@@ -10,6 +10,9 @@ enum {
 	/* flags for mem_cgroup and file and I/O status */
 	PCG_MOVE_LOCK, /* For race between move_account v.s. following bits */
 	PCG_FILE_MAPPED, /* page is accounted as "mapped" */
+	PCG_FILE_DIRTY, /* page is dirty */
+	PCG_FILE_WRITEBACK, /* page is under writeback */
+	PCG_FILE_UNSTABLE_NFS, /* page is NFS unstable */
 	/* No lock in page_cgroup */
 	PCG_ACCT_LRU, /* page has been accounted for (under lru_lock) */
 	__NR_PCG_FLAGS,
@@ -67,6 +70,10 @@ static inline void ClearPageCgroup##uname(struct page_cgroup *pc)	\
 static inline int TestClearPageCgroup##uname(struct page_cgroup *pc)	\
 	{ return test_and_clear_bit(PCG_##lname, &pc->flags);  }
 
+#define TESTSETPCGFLAG(uname, lname)			\
+static inline int TestSetPageCgroup##uname(struct page_cgroup *pc)	\
+	{ return test_and_set_bit(PCG_##lname, &pc->flags); }
+
 /* Cache flag is set only once (at allocation) */
 TESTPCGFLAG(Cache, CACHE)
 CLEARPCGFLAG(Cache, CACHE)
@@ -86,6 +93,22 @@ SETPCGFLAG(FileMapped, FILE_MAPPED)
 CLEARPCGFLAG(FileMapped, FILE_MAPPED)
 TESTPCGFLAG(FileMapped, FILE_MAPPED)
 
+SETPCGFLAG(FileDirty, FILE_DIRTY)
+CLEARPCGFLAG(FileDirty, FILE_DIRTY)
+TESTPCGFLAG(FileDirty, FILE_DIRTY)
+TESTCLEARPCGFLAG(FileDirty, FILE_DIRTY)
+TESTSETPCGFLAG(FileDirty, FILE_DIRTY)
+
+SETPCGFLAG(FileWriteback, FILE_WRITEBACK)
+CLEARPCGFLAG(FileWriteback, FILE_WRITEBACK)
+TESTPCGFLAG(FileWriteback, FILE_WRITEBACK)
+
+SETPCGFLAG(FileUnstableNFS, FILE_UNSTABLE_NFS)
+CLEARPCGFLAG(FileUnstableNFS, FILE_UNSTABLE_NFS)
+TESTPCGFLAG(FileUnstableNFS, FILE_UNSTABLE_NFS)
+TESTCLEARPCGFLAG(FileUnstableNFS, FILE_UNSTABLE_NFS)
+TESTSETPCGFLAG(FileUnstableNFS, FILE_UNSTABLE_NFS)
+
 SETPCGFLAG(Migration, MIGRATION)
 CLEARPCGFLAG(Migration, MIGRATION)
 TESTPCGFLAG(Migration, MIGRATION)
-- 
1.7.3.1

