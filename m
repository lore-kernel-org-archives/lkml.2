Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab1FCQNn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 12:13:43 -0400
Received: from smtp-out.google.com ([74.125.121.67]:37148 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612Ab1FCQNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 12:13:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=ahYUgwnd2y1hQPlZ3zKhTosDj5wRnYZFi45zNBdptU6xjlyU37MKXAFzSp6j4dNgN
	YvCMZl2YzYZ4fIYAJHFgA==
From: Greg Thelen <gthelen@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        containers@lists.osdl.org, linux-fsdevel@vger.kernel.org,
        Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Vivek Goyal <vgoyal@redhat.com>,
        Dave Chinner <david@fromorbit.com>, Greg Thelen <gthelen@google.com>
Subject: [PATCH v8 02/12] memcg: add page_cgroup flags for dirty page tracking
Date: Fri,  3 Jun 2011 09:12:08 -0700
Message-Id: <1307117538-14317-3-git-send-email-gthelen@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1307117538-14317-1-git-send-email-gthelen@google.com>
References: <1307117538-14317-1-git-send-email-gthelen@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add additional flags to page_cgroup to track dirty pages
within a mem_cgroup.

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Signed-off-by: Andrea Righi <arighi@develer.com>
Signed-off-by: Greg Thelen <gthelen@google.com>
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

