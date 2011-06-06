Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347Ab1FFE3M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 00:29:12 -0400
Received: from smtp-out.google.com ([74.125.121.67]:24333 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab1FFE3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 00:29:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=ixzxbQ6UEnrbePz+GMjvbzArSdn8n46BIZrIvR+WXVX2brsJgeA2tuZx65Rai8eCKf
         QF08bHRtydyZfiNUvINA==
Date: Sun, 5 Jun 2011 21:29:09 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Hellwig <hch@infradead.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCH 5/14] drm/ttm: use shmem_read_mapping_page
In-Reply-To: <alpine.LSU.2.00.1106052116350.17116@sister.anvils>
Message-ID: <alpine.LSU.2.00.1106052127400.17116@sister.anvils>
References: <alpine.LSU.2.00.1106052116350.17116@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Soon tmpfs will stop supporting ->readpage and read_mapping_page():
once "tmpfs: add shmem_read_mapping_page_gfp" has been applied,
this patch can be applied to ease the transition.

ttm_tt_swapin() and ttm_tt_swapout() use shmem_read_mapping_page()
in place of read_mapping_page(), since their swap_space has been
created with shmem_file_setup().

Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Dave Airlie <airlied@redhat.com>
---
 drivers/gpu/drm/ttm/ttm_tt.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- linux.orig/drivers/gpu/drm/ttm/ttm_tt.c	2011-05-18 21:06:34.000000000 -0700
+++ linux/drivers/gpu/drm/ttm/ttm_tt.c	2011-06-05 18:24:09.501854133 -0700
@@ -31,6 +31,7 @@
 #include <linux/sched.h>
 #include <linux/highmem.h>
 #include <linux/pagemap.h>
+#include <linux/shmem_fs.h>
 #include <linux/file.h>
 #include <linux/swap.h>
 #include <linux/slab.h>
@@ -484,7 +485,7 @@ static int ttm_tt_swapin(struct ttm_tt *
 	swap_space = swap_storage->f_path.dentry->d_inode->i_mapping;
 
 	for (i = 0; i < ttm->num_pages; ++i) {
-		from_page = read_mapping_page(swap_space, i, NULL);
+		from_page = shmem_read_mapping_page(swap_space, i);
 		if (IS_ERR(from_page)) {
 			ret = PTR_ERR(from_page);
 			goto out_err;
@@ -557,7 +558,7 @@ int ttm_tt_swapout(struct ttm_tt *ttm, s
 		from_page = ttm->pages[i];
 		if (unlikely(from_page == NULL))
 			continue;
-		to_page = read_mapping_page(swap_space, i, NULL);
+		to_page = shmem_read_mapping_page(swap_space, i);
 		if (unlikely(IS_ERR(to_page))) {
 			ret = PTR_ERR(to_page);
 			goto out_err;
