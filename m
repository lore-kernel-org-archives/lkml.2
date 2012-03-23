Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab2CWUtD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 16:49:03 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:62380 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab2CWUtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 16:49:00 -0400
Date: Fri, 23 Mar 2012 13:48:35 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH] swapon: check validity of swap_flags
Message-ID: <alpine.LSU.2.00.1203231346500.1940@eggly.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most system calls taking flags first check that the flags passed in are
valid, and that helps userspace to detect when new flags are supported.

But swapon never did so: start checking now, to help if we ever want to
support more swap_flags in future.

It's difficult to get stray bits set in an int, and swapon is not widely
used, so this is most unlikely to break any userspace; but we can just
revert if it turns out to do so.

Signed-off-by: Hugh Dickins <hughd@google.com>
---

 include/linux/swap.h |    3 +++
 mm/swapfile.c        |    3 +++
 2 files changed, 6 insertions(+)

--- linux.git/include/linux/swap.h	2012-03-23 10:19:53.408051631 -0700
+++ linux/include/linux/swap.h	2012-03-23 10:34:02.956071819 -0700
@@ -21,6 +21,9 @@ struct bio;
 #define SWAP_FLAG_PRIO_SHIFT	0
 #define SWAP_FLAG_DISCARD	0x10000 /* discard swap cluster after use */
 
+#define SWAP_FLAGS_VALID	(SWAP_FLAG_PRIO_MASK | SWAP_FLAG_PREFER | \
+				 SWAP_FLAG_DISCARD)
+
 static inline int current_is_kswapd(void)
 {
 	return current->flags & PF_KSWAPD;
--- linux.git/mm/swapfile.c	2012-03-23 10:19:53.588051635 -0700
+++ linux/mm/swapfile.c	2012-03-23 10:35:52.764074181 -0700
@@ -2022,6 +2022,9 @@ SYSCALL_DEFINE2(swapon, const char __use
 	struct page *page = NULL;
 	struct inode *inode = NULL;
 
+	if (swap_flags & ~SWAP_FLAGS_VALID)
+		return -EINVAL;
+
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
