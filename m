Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261Ab1EaAmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 20:42:21 -0400
Received: from smtp-out.google.com ([74.125.121.67]:41213 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab1EaAmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 20:42:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=AA8KBNVya1ZKGn2RHVkZCz2/yOY9s9FC2y0xlNzdD1BEy8Mmh1R238U33cOqp26FfU
         DSS2wkyimnjoPfcv8hkA==
Date: Mon, 30 May 2011 17:42:17 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Thomas Hellstrom <thellstrom@vmware.com>, Dave Airlie <airlied@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 5/14] drm/ttm: use shmem_read_mapping_page
In-Reply-To: <alpine.LSU.2.00.1105301726180.5482@sister.anvils>
Message-ID: <alpine.LSU.2.00.1105301741020.5482@sister.anvils>
References: <alpine.LSU.2.00.1105301726180.5482@sister.anvils>
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
Cc: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Dave Airlie <airlied@redhat.com>
---
 drivers/gpu/drm/ttm/ttm_tt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux.orig/drivers/gpu/drm/ttm/ttm_tt.c	2011-05-30 13:56:10.112796608 -0700
+++ linux/drivers/gpu/drm/ttm/ttm_tt.c	2011-05-30 14:25:59.641670407 -0700
@@ -484,7 +484,7 @@ static int ttm_tt_swapin(struct ttm_tt *
 	swap_space = swap_storage->f_path.dentry->d_inode->i_mapping;
 
 	for (i = 0; i < ttm->num_pages; ++i) {
-		from_page = read_mapping_page(swap_space, i, NULL);
+		from_page = shmem_read_mapping_page(swap_space, i);
 		if (IS_ERR(from_page)) {
 			ret = PTR_ERR(from_page);
 			goto out_err;
@@ -557,7 +557,7 @@ int ttm_tt_swapout(struct ttm_tt *ttm, s
 		from_page = ttm->pages[i];
 		if (unlikely(from_page == NULL))
 			continue;
-		to_page = read_mapping_page(swap_space, i, NULL);
+		to_page = shmem_read_mapping_page(swap_space, i);
 		if (unlikely(IS_ERR(to_page))) {
 			ret = PTR_ERR(to_page);
 			goto out_err;
