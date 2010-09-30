Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244Ab0I3KWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 06:22:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57150 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab0I3KWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 06:22:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=fBoxr7Pr7Yli9KKnJ68U8cCnfNczDj8EcdDUiylrKT4Lq9wQCZFUShdWhOxGyhtbDV
         Q9uI6hcMLPPEe9Nz5tynizekvWrL+/WxlOdJLnLIOTnUx9PFymAHXhekK6UmiZ5eej/M
         9SkC/DQyCEIAUYKi0GzjkpeMzczOfQdc7IeiI=
Subject: [PATCH] fs: inode per-cpu last_ino allocator
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100930011417.6ca16ed7.akpm@linux-foundation.org>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
	 <1285762729-17928-16-git-send-email-david@fromorbit.com>
	 <20100929215312.5fcb6976.akpm@linux-foundation.org>
	 <1285824982.5211.675.camel@edumazet-laptop>
	 <1285833189.2615.31.camel@edumazet-laptop>
	 <20100930011417.6ca16ed7.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Sep 2010 12:22:16 +0200
Message-ID: <1285842136.2615.251.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 30 septembre 2010 à 01:14 -0700, Andrew Morton a écrit :

> Perhaps
> 
> 	WARN_ON_ONCE(preemptible());
> 
> if we had a developer-only version of WARN_ON_ONCE, which we don't.

Or just use a regular PER_CPU variable, even on !SMP, and get preempt
safe implementation.

What do you think of following patch, on top of current linux-2.6 tree ?

Thanks

[PATCH] fs: inode per-cpu last_ino allocator

new_inode() dirties a contended cache line to get increasing
inode numbers.

Solve this problem by providing to each cpu a per_cpu variable,
feeded by the shared last_ino, but once every 1024 allocations.
This reduces contention on the shared last_ino, and give same
spreading ino numbers than before (i.e. same wraparound after 2^32
allocations).

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/inode.c |   45 ++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 38 insertions(+), 7 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 8646433..122914e 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -624,6 +624,43 @@ void inode_add_to_lists(struct super_block *sb, struct inode *inode)
 }
 EXPORT_SYMBOL_GPL(inode_add_to_lists);
 
+#define LAST_INO_BATCH 1024
+
+/*
+ * Each cpu owns a range of LAST_INO_BATCH numbers.
+ * 'shared_last_ino' is dirtied only once out of LAST_INO_BATCH allocations,
+ * to renew the exhausted range.
+ *
+ * This does not significantly increase overflow rate because every CPU can
+ * consume at most LAST_INO_BATCH-1 unused inode numbers. So there is
+ * NR_CPUS*(LAST_INO_BATCH-1) wastage. At 4096 and 1024, this is ~0.1% of the
+ * 2^32 range, and is a worst-case. Even a 50% wastage would only increase
+ * overflow rate by 2x, which does not seem too significant.
+ *
+ * On a 32bit, non LFS stat() call, glibc will generate an EOVERFLOW
+ * error if st_ino won't fit in target struct field. Use 32bit counter
+ * here to attempt to avoid that.
+ */
+static DEFINE_PER_CPU(unsigned int, last_ino);
+
+static noinline unsigned int last_ino_get(void)
+{
+	unsigned int *p = &get_cpu_var(last_ino);
+	unsigned int res = *p;
+
+#ifdef CONFIG_SMP
+	if (unlikely((res & (LAST_INO_BATCH - 1)) == 0)) {
+		static atomic_t shared_last_ino;
+		int next = atomic_add_return(LAST_INO_BATCH, &shared_last_ino);
+
+		res = next - LAST_INO_BATCH;
+	}
+#endif
+	*p = ++res;
+	put_cpu_var(last_ino);
+	return res;
+}
+
 /**
  *	new_inode 	- obtain an inode
  *	@sb: superblock
@@ -638,12 +675,6 @@ EXPORT_SYMBOL_GPL(inode_add_to_lists);
  */
 struct inode *new_inode(struct super_block *sb)
 {
-	/*
-	 * On a 32bit, non LFS stat() call, glibc will generate an EOVERFLOW
-	 * error if st_ino won't fit in target struct field. Use 32bit counter
-	 * here to attempt to avoid that.
-	 */
-	static unsigned int last_ino;
 	struct inode *inode;
 
 	spin_lock_prefetch(&inode_lock);
@@ -652,7 +683,7 @@ struct inode *new_inode(struct super_block *sb)
 	if (inode) {
 		spin_lock(&inode_lock);
 		__inode_add_to_lists(sb, NULL, inode);
-		inode->i_ino = ++last_ino;
+		inode->i_ino = last_ino_get();
 		inode->i_state = 0;
 		spin_unlock(&inode_lock);
 	}


