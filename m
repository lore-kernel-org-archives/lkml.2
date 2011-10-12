Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab1JLQso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 12:48:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296Ab1JLQsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 12:48:42 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/7] Make shrink_dcache_for_umount_subtree() use the core
 assertion code
To: linux-arch@vger.kernel.org
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org
Date: Wed, 12 Oct 2011 17:47:38 +0100
Message-ID: <20111012164738.539.55474.stgit@warthog.procyon.org.uk>
In-Reply-To: <20111012164717.539.44368.stgit@warthog.procyon.org.uk>
References: <20111012164717.539.44368.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make shrink_dcache_for_umount_subtree() use the core assertion code rather than
doing printk() then BUG() so that the annotation appears _after_ the "cut here"
line instead of before it.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/dcache.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index a88948b..29f9e44 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -36,6 +36,7 @@
 #include <linux/bit_spinlock.h>
 #include <linux/rculist_bl.h>
 #include <linux/prefetch.h>
+#include <linux/assert.h>
 #include "internal.h"
 
 /*
@@ -858,9 +859,9 @@ static void shrink_dcache_for_umount_subtree(struct dentry *dentry)
 			dentry_lru_del(dentry);
 			__d_shrink(dentry);
 
-			if (dentry->d_count != 0) {
-				printk(KERN_ERR
-				       "BUG: Dentry %p{i=%lx,n=%s}"
+			if (unlikely(dentry->d_count != 0))
+				assertion_failed(
+				       "Dentry %p{i=%lx,n=%s}"
 				       " still in use (%d)"
 				       " [unmount of %s %s]\n",
 				       dentry,
@@ -870,8 +871,6 @@ static void shrink_dcache_for_umount_subtree(struct dentry *dentry)
 				       dentry->d_count,
 				       dentry->d_sb->s_type->name,
 				       dentry->d_sb->s_id);
-				BUG();
-			}
 
 			if (IS_ROOT(dentry)) {
 				parent = NULL;

