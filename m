Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759Ab0I3R26 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 13:28:58 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37381 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778Ab0I3R24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 13:28:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=YURz/DtJOfHazNMF7Y9oIGdo9feaULTfs2SO23HRtq5SiXWuEDmjT8pgQZCQ918raV
         KuE0ArXXRtZ2AtY6Zd0kAmyGOyq5mDcj5pmT4fAaKnhUyiHk8DX5fmy3HURMIWXa++Tz
         nBseYg+F2exAsKpjE3uNpHif7sFUs241PSxYk=
Subject: Re: [PATCH] fs: inode per-cpu last_ino allocator
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100930094558.97c9afa2.akpm@linux-foundation.org>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
	 <1285762729-17928-16-git-send-email-david@fromorbit.com>
	 <20100929215312.5fcb6976.akpm@linux-foundation.org>
	 <1285824982.5211.675.camel@edumazet-laptop>
	 <1285833189.2615.31.camel@edumazet-laptop>
	 <20100930011417.6ca16ed7.akpm@linux-foundation.org>
	 <1285842136.2615.251.camel@edumazet-laptop>
	 <20100930094558.97c9afa2.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 30 Sep 2010 19:28:05 +0200
Message-ID: <1285867685.2615.865.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 30 septembre 2010 à 09:45 -0700, Andrew Morton a écrit :

> Could eliminate `p' I guess, but that would involve using
> __get_cpu_var() as an lval, which looks vile and might generate worse
> code.
> 

Hmm, I see, please check this new patch, using the most modern stuff ;)

> Readers of this code won't know why last_ino_get() was marked noinline.
> It looks wrong, really.

Oops sorry, this was a temporary hack of mine to ease disassembly
analysis. Good catch !

Here is the new generated code on i686 (with the noinline) : 
pretty good ;)

c02e5930 <last_ino_get>:
c02e5930:	55                   	push   %ebp
c02e5931:	89 e5                	mov    %esp,%ebp
c02e5933:	64 a1 44 29 7d c0    	mov    %fs:0xc07d2944,%eax
c02e5939:	a9 ff 03 00 00       	test   $0x3ff,%eax
c02e593e:	74 09                	je     c02e5949 <last_ino_get+0x19>
c02e5940:	40                   	inc    %eax
c02e5941:	64 a3 44 29 7d c0    	mov    %eax,%fs:0xc07d2944
c02e5947:	c9                   	leave  
c02e5948:	c3                   	ret    
c02e5949:	b8 00 04 00 00       	mov    $0x400,%eax
c02e594e:	f0 0f c1 05 80 c8 92 c0	lock xadd %eax,0xc092c880
c02e5956:	eb e8                	jmp    c02e5940 <last_ino_get+0x10>


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
 fs/inode.c |   47 ++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 40 insertions(+), 7 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 8646433..5c233f0 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -624,6 +624,45 @@ void inode_add_to_lists(struct super_block *sb, struct inode *inode)
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
+static unsigned int last_ino_get(void)
+{
+	unsigned int res;
+
+	get_cpu();
+	res = __this_cpu_read(last_ino);
+#ifdef CONFIG_SMP
+	if (unlikely((res & (LAST_INO_BATCH - 1)) == 0)) {
+		static atomic_t shared_last_ino;
+		int next = atomic_add_return(LAST_INO_BATCH, &shared_last_ino);
+
+		res = next - LAST_INO_BATCH;
+	}
+#endif
+	res++;
+	__this_cpu_write(last_ino, res);
+	put_cpu();
+	return res;
+}
+
 /**
  *	new_inode 	- obtain an inode
  *	@sb: superblock
@@ -638,12 +677,6 @@ EXPORT_SYMBOL_GPL(inode_add_to_lists);
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
@@ -652,7 +685,7 @@ struct inode *new_inode(struct super_block *sb)
 	if (inode) {
 		spin_lock(&inode_lock);
 		__inode_add_to_lists(sb, NULL, inode);
-		inode->i_ino = ++last_ino;
+		inode->i_ino = last_ino_get();
 		inode->i_state = 0;
 		spin_unlock(&inode_lock);
 	}


