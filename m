Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958Ab0HXKux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 06:50:53 -0400
Received: from smtp-out.google.com ([216.239.44.51]:20444 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754914Ab0HXKuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 06:50:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=SkT4dytOp98gBiTEi4mIL9T1ljUlx938KWrQpn/6IynbY+8CDa3Vy5g+pkI9xq2y2
	hpYb5REtNHELal9rSPC7Q==
Date: Tue, 24 Aug 2010 03:50:38 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Anton Altaparmakov <aia21@cantab.net>,
        linux-ntfs-dev@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [patch 5/5] ntfs: remove dependency on __GFP_NOFAIL
In-Reply-To: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1008240348560.19596@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008240340010.18908@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reimplement ntfs_malloc_nofs_nofail() to loop forever calling
ntfs_malloc_nofs() until the allocation succeeds.

If the first allocation attempt fails, a warning will be emitted,
including a call trace.  Subsequent failures will suppress this warning.

This was added as a helper function for documentation and auditability.
No future callers should be added.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 fs/ntfs/malloc.h |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/ntfs/malloc.h b/fs/ntfs/malloc.h
--- a/fs/ntfs/malloc.h
+++ b/fs/ntfs/malloc.h
@@ -76,11 +76,21 @@ static inline void *ntfs_malloc_nofs(unsigned long size)
  * This function guarantees that the allocation will succeed.  It will sleep
  * for as long as it takes to complete the allocation.
  *
- * If there was insufficient memory to complete the request, return NULL.
+ * NOTE: no new callers of this function should be implemented!
+ * All memory allocations should be failable whenever possible.
  */
 static inline void *ntfs_malloc_nofs_nofail(unsigned long size)
 {
-	return __ntfs_malloc(size, GFP_NOFS | __GFP_HIGHMEM | __GFP_NOFAIL);
+	void *ret;
+
+	for (;;) {
+		ret = ntfs_malloc_nofs(size);
+		if (ret)
+			return ret;
+		WARN_ONCE(1, "Out of memory, no fallback implemented "
+				"(size=%lu)\n",
+				size);
+	}
 }
 
 static inline void ntfs_free(void *addr)
