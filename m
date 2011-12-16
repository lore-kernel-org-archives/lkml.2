Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759580Ab1LPOOZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 09:14:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55033 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759520Ab1LPOOP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 09:14:15 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/7] Make shrink_dcache_for_umount_subtree() use
 ANNOTATED_BUG()
To: linux-arch@vger.kernel.org, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Fri, 16 Dec 2011 14:14:07 +0000
Message-ID: <20111216141407.24668.58875.stgit@warthog.procyon.org.uk>
In-Reply-To: <20111216141357.24668.49793.stgit@warthog.procyon.org.uk>
References: <20111216141357.24668.49793.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make shrink_dcache_for_umount_subtree() use ANNOTATED_BUG() rather than doing
printk() then BUG() so that the annotation appears _after_ the "cut here" line
instead of before it.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/dcache.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 89509b5..4083c50 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -37,6 +37,7 @@
 #include <linux/rculist_bl.h>
 #include <linux/prefetch.h>
 #include <linux/ratelimit.h>
+#include <linux/bug.h>
 #include "internal.h"
 
 /*
@@ -889,9 +890,9 @@ static void shrink_dcache_for_umount_subtree(struct dentry *dentry)
 			dentry_lru_prune(dentry);
 			__d_shrink(dentry);
 
-			if (dentry->d_count != 0) {
-				printk(KERN_ERR
-				       "BUG: Dentry %p{i=%lx,n=%s}"
+			if (unlikely(dentry->d_count != 0))
+				ANNOTATED_BUG(
+				       "Dentry %p{i=%lx,n=%s}"
 				       " still in use (%d)"
 				       " [unmount of %s %s]\n",
 				       dentry,
@@ -901,8 +902,6 @@ static void shrink_dcache_for_umount_subtree(struct dentry *dentry)
 				       dentry->d_count,
 				       dentry->d_sb->s_type->name,
 				       dentry->d_sb->s_id);
-				BUG();
-			}
 
 			if (IS_ROOT(dentry)) {
 				parent = NULL;

