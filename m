Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756592Ab2CATOi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 14:14:38 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:47775 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756398Ab2CATOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 14:14:34 -0500
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        David Safford <safford@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Mimi Zohar <zohar@us.ibm.com>
Subject: [PATCH v2 06/11] ima: replace iint spinlock with rwlock/read_lock
Date: Thu,  1 Mar 2012 14:10:43 -0500
Message-Id: <1330629048-5933-7-git-send-email-zohar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.6.5
In-Reply-To: <1330629048-5933-1-git-send-email-zohar@linux.vnet.ibm.com>
References: <1330629048-5933-1-git-send-email-zohar@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12030119-4242-0000-0000-000000EEF03D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For performance, replace the iint spinlock with rwlock/read_lock.

Eric Paris questioned this change, from spinlocks to rwlocks, saying
"rwlocks have been shown to actually be slower on multi processor
systems in a number of cases due to the cache line bouncing required."

Based on performance measurements compiling the kernel on a cold
boot with multiple jobs with/without this patch, Dmitry Kasatkin
and I found that rwlocks performed better than spinlocks, but very
insignificantly.  For example with total compilation time around 6
minutes, with rwlocks time was 1 - 3 seconds shorter... but always
like that.

Changelog v2:
- new patch taken from the 'allocating iint improvements' patch

Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
---
 security/integrity/iint.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/security/integrity/iint.c b/security/integrity/iint.c
index c91a436..d82a5a1 100644
--- a/security/integrity/iint.c
+++ b/security/integrity/iint.c
@@ -22,7 +22,7 @@
 #include "integrity.h"
 
 static struct rb_root integrity_iint_tree = RB_ROOT;
-static DEFINE_SPINLOCK(integrity_iint_lock);
+static DEFINE_RWLOCK(integrity_iint_lock);
 static struct kmem_cache *iint_cache __read_mostly;
 
 int iint_initialized;
@@ -35,8 +35,6 @@ static struct integrity_iint_cache *__integrity_iint_find(struct inode *inode)
 	struct integrity_iint_cache *iint;
 	struct rb_node *n = integrity_iint_tree.rb_node;
 
-	assert_spin_locked(&integrity_iint_lock);
-
 	while (n) {
 		iint = rb_entry(n, struct integrity_iint_cache, rb_node);
 
@@ -63,9 +61,9 @@ struct integrity_iint_cache *integrity_iint_find(struct inode *inode)
 	if (!IS_IMA(inode))
 		return NULL;
 
-	spin_lock(&integrity_iint_lock);
+	read_lock(&integrity_iint_lock);
 	iint = __integrity_iint_find(inode);
-	spin_unlock(&integrity_iint_lock);
+	read_unlock(&integrity_iint_lock);
 
 	return iint;
 }
@@ -100,7 +98,7 @@ struct integrity_iint_cache *integrity_inode_get(struct inode *inode)
 	if (!iint)
 		return NULL;
 
-	spin_lock(&integrity_iint_lock);
+	write_lock(&integrity_iint_lock);
 
 	p = &integrity_iint_tree.rb_node;
 	while (*p) {
@@ -119,7 +117,7 @@ struct integrity_iint_cache *integrity_inode_get(struct inode *inode)
 	rb_link_node(node, parent, p);
 	rb_insert_color(node, &integrity_iint_tree);
 
-	spin_unlock(&integrity_iint_lock);
+	write_unlock(&integrity_iint_lock);
 	return iint;
 }
 
@@ -136,10 +134,10 @@ void integrity_inode_free(struct inode *inode)
 	if (!IS_IMA(inode))
 		return;
 
-	spin_lock(&integrity_iint_lock);
+	write_lock(&integrity_iint_lock);
 	iint = __integrity_iint_find(inode);
 	rb_erase(&iint->rb_node, &integrity_iint_tree);
-	spin_unlock(&integrity_iint_lock);
+	write_unlock(&integrity_iint_lock);
 
 	iint_free(iint);
 }
-- 
1.7.6.5

