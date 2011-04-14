Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933924Ab1DNSYo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:24:44 -0400
Received: from mail.windriver.com ([147.11.1.11]:38237 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933188Ab1DNRqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:46:36 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Patrick McHardy <kaber@trash.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 063/209] netfilter: nf_conntrack: allow nf_ct_alloc_hashtable() to get highmem pages
Date: Thu, 14 Apr 2011 13:41:33 -0400
Message-Id: <1302803039-9400-64-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 6b1686a71e3158d3c5f125260effce171cc7852b upstream.

commit ea781f197d6a8 (use SLAB_DESTROY_BY_RCU and get rid of call_rcu())
did a mistake in __vmalloc() call in nf_ct_alloc_hashtable().

I forgot to add __GFP_HIGHMEM, so pages were taken from LOWMEM only.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 net/netfilter/nf_conntrack_core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 0c9bbe9..a1af890 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1240,7 +1240,8 @@ void *nf_ct_alloc_hashtable(unsigned int *sizep, int *vmalloced, int nulls)
 	if (!hash) {
 		*vmalloced = 1;
 		printk(KERN_WARNING "nf_conntrack: falling back to vmalloc.\n");
-		hash = __vmalloc(sz, GFP_KERNEL | __GFP_ZERO, PAGE_KERNEL);
+		hash = __vmalloc(sz, GFP_KERNEL | __GFP_HIGHMEM | __GFP_ZERO,
+				 PAGE_KERNEL);
 	}
 
 	if (hash && nulls)
-- 
1.7.4.4

