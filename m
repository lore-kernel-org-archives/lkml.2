Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab0FXDRD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:17:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36048 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754221Ab0FXDP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:15:57 -0400
Message-Id: <20100624030729.566820679@suse.de>
User-Agent: quilt/0.48-4.4
Date: Thu, 24 Jun 2010 13:02:37 +1000
From: npiggin@suse.de
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: [patch 25/52] fs: dcache DCACHE_REFERENCED improve
References: <20100624030212.676457061@suse.de>
Content-Disposition: inline; filename=fs-dput-d_referenced-improve.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dentry referenced bit is only set when installing the dentry back
onto the LRU. However with lazy LRU, the dentry can already be on
the LRU list at dput time, thus missing out on setting the referenced
bit. Fix this. 

Signed-off-by: Nick Piggin <npiggin@suse.de>

Index: linux-2.6/fs/dcache.c
===================================================================
--- linux-2.6.orig/fs/dcache.c
+++ linux-2.6/fs/dcache.c
@@ -387,10 +387,10 @@ repeat:
 	/* Unreachable? Get rid of it */
  	if (d_unhashed(dentry))
 		goto kill_it;
-  	if (list_empty(&dentry->d_lru)) {
-  		dentry->d_flags |= DCACHE_REFERENCED;
+	/* Otherwise leave it cached and ensure it's on the LRU */
+  	if (list_empty(&dentry->d_lru))
 		dentry_lru_add(dentry);
-  	}
+	dentry->d_flags |= DCACHE_REFERENCED;
 	dentry->d_count--;
 	spin_unlock(&dentry->d_lock);
   	return;


