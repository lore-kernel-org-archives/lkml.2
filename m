Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933947Ab1IOOsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 10:48:30 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:44797
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933524Ab1IOOs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 10:48:28 -0400
Date: Thu, 15 Sep 2011 10:48:27 -0400
From: Christoph Hellwig <hch@infradead.org>
To: torvalds@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] hfsplus: Fix kfree of wrong pointers in
 hfsplus_fill_super() error path
Message-ID: <20110915144827.GA19082@infradead.org>
References: <20110722152722.GA11946@infradead.org>
 <20110915144810.GA18876@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110915144810.GA18876@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Seth Forshee <seth.forshee@canonical.com>

Commit 6596528 (hfsplus: ensure bio requests are not smaller than the
hardware sectors) changed the pointers used for volume header allocations
but failed to free the correct pointers in the error path path of
hfsplus_fill_super() and hfsplus_read_wrapper.

The second hunk came from a separate patch by Pavel Ivanov.

Reported-by: Pavel Ivanov <paivanof@gmail.com>
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Signed-off-by: Christoph Hellwig <hch@tuxera.com>
Cc: <stable@kernel.org>
---
 fs/hfsplus/super.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/fs/hfsplus/super.c
===================================================================
--- linux-2.6.orig/fs/hfsplus/super.c	2011-09-10 11:34:46.271616471 -0400
+++ linux-2.6/fs/hfsplus/super.c	2011-09-11 10:44:13.349746484 -0400
@@ -525,8 +525,8 @@ out_close_cat_tree:
 out_close_ext_tree:
 	hfs_btree_close(sbi->ext_tree);
 out_free_vhdr:
-	kfree(sbi->s_vhdr);
-	kfree(sbi->s_backup_vhdr);
+	kfree(sbi->s_vhdr_buf);
+	kfree(sbi->s_backup_vhdr_buf);
 out_unload_nls:
 	unload_nls(sbi->nls);
 	unload_nls(nls);
Index: linux-2.6/fs/hfsplus/wrapper.c
===================================================================
--- linux-2.6.orig/fs/hfsplus/wrapper.c	2011-09-11 10:44:36.949746343 -0400
+++ linux-2.6/fs/hfsplus/wrapper.c	2011-09-11 10:44:49.679746266 -0400
@@ -272,9 +272,9 @@ reread:
 	return 0;
 
 out_free_backup_vhdr:
-	kfree(sbi->s_backup_vhdr);
+	kfree(sbi->s_backup_vhdr_buf);
 out_free_vhdr:
-	kfree(sbi->s_vhdr);
+	kfree(sbi->s_vhdr_buf);
 out:
 	return error;
 }
