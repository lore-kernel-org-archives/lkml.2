Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978Ab2JIDof (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 23:44:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:48134 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754847Ab2JIDoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 23:44:21 -0400
X-IronPort-AV: E=Sophos;i="4.80,558,1344182400"; 
   d="scan'208";a="5964972"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, linux-fsdevel@vger.kernel.org
Subject: [PATCH 3/3] lglock: add DEFINE_STATIC_LGLOCK()
Date: Tue, 9 Oct 2012 11:46:40 +0800
Message-Id: <1349754403-4798-3-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1349754403-4798-1-git-send-email-laijs@cn.fujitsu.com>
References: <1349754403-4798-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/09 11:44:13,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/09 11:44:14,
	Serialize complete at 2012/10/09 11:44:14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When if the lglock don't to be exported,
we can use DEFINE_STATIC_LGLOCK().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 fs/file_table.c        |    2 +-
 include/linux/lglock.h |    8 +++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index 701985e..e26fd31 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -36,7 +36,7 @@ struct files_stat_struct files_stat = {
 	.max_files = NR_FILE
 };
 
-DEFINE_LGLOCK(files_lglock);
+DEFINE_STATIC_LGLOCK(files_lglock);
 
 /* SLAB cache for file structures */
 static struct kmem_cache *filp_cachep __read_mostly;
diff --git a/include/linux/lglock.h b/include/linux/lglock.h
index 8f97451..0d24e93 100644
--- a/include/linux/lglock.h
+++ b/include/linux/lglock.h
@@ -32,7 +32,8 @@
 #define br_write_lock(name)	lg_global_lock(name)
 #define br_write_unlock(name)	lg_global_unlock(name)
 
-#define DEFINE_BRLOCK(name)	DEFINE_LGLOCK(name)
+#define DEFINE_BRLOCK(name)		DEFINE_LGLOCK(name)
+#define DEFINE_STATIC_BRLOCK(name)	DEFINE_STATIC_LGLOCK(name)
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 #define LOCKDEP_INIT_MAP lockdep_init_map
@@ -53,6 +54,11 @@ struct lglock {
 	= __ARCH_SPIN_LOCK_UNLOCKED;					\
 	struct lglock name = { .lock = &name ## _lock }
 
+#define DEFINE_STATIC_LGLOCK(name)					\
+	static DEFINE_PER_CPU(arch_spinlock_t, name ## _lock)		\
+	= __ARCH_SPIN_LOCK_UNLOCKED;					\
+	static struct lglock name = { .lock = &name ## _lock }
+
 void lg_lock_init(struct lglock *lg, char *name);
 void lg_local_lock(struct lglock *lg);
 void lg_local_unlock(struct lglock *lg);
-- 
1.7.4.4

