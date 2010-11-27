Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab0K0K2n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 05:28:43 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:6979 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753123Ab0K0K1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 05:27:02 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApcFAO1p8Ex5Lcx2/2dsb2JhbACVC44Acr12hUcEimGFFA
Message-Id: <2fb8e630df8ffe4685c319015100cf1bcaa73789.1290852959.git.npiggin@kernel.dk>
In-Reply-To: <cover.1290852958.git.npiggin@kernel.dk>
References: <cover.1290852958.git.npiggin@kernel.dk>
From: Nick Piggin <npiggin@kernel.dk>
Date: Sat, 27 Nov 2010 20:44:52 +1100
Subject: [PATCH 22/46] fs: dcache reduce locking in d_alloc
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Nick Piggin <npiggin@kernel.dk>
---
 fs/dcache.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index a117139..3e4f7c1 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1220,11 +1220,13 @@ struct dentry *d_alloc(struct dentry * parent, const struct qstr *name)
 
 	if (parent) {
 		spin_lock(&parent->d_lock);
-		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
+		/*
+		 * don't need child lock because it is not subject
+		 * to concurrency here
+		 */
 		dentry->d_parent = dget_dlock(parent);
 		dentry->d_sb = parent->d_sb;
 		list_add(&dentry->d_u.d_child, &parent->d_subdirs);
-		spin_unlock(&dentry->d_lock);
 		spin_unlock(&parent->d_lock);
 	}
 
-- 
1.7.1

