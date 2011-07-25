Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab1GYUfw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 16:35:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5329 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752478Ab1GYUfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 16:35:50 -0400
From: Johannes Weiner <jweiner@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: fuse-devel@lists.sourceforge.net, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch 2/2] fuse: mark pages accessed when written to
Date: Mon, 25 Jul 2011 22:35:35 +0200
Message-Id: <1311626135-14279-2-git-send-email-jweiner@redhat.com>
In-Reply-To: <1311626135-14279-1-git-send-email-jweiner@redhat.com>
References: <1311626135-14279-1-git-send-email-jweiner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As fuse does not use the page cache library functions when userspace
writes to a file, it did not benefit from 'c8236db mm: mark page
accessed before we write_end()' that made sure pages are properly
marked accessed when written to.

Signed-off-by: Johannes Weiner <jweiner@redhat.com>
---
 fs/fuse/file.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index 5c48126..471067e 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -14,6 +14,7 @@
 #include <linux/sched.h>
 #include <linux/module.h>
 #include <linux/compat.h>
+#include <linux/swap.h>
 
 static const struct file_operations fuse_direct_io_file_operations;
 
@@ -828,6 +829,8 @@ static ssize_t fuse_fill_write_pages(struct fuse_req *req,
 		pagefault_enable();
 		flush_dcache_page(page);
 
+		mark_page_accessed(page);
+
 		if (!tmp) {
 			unlock_page(page);
 			page_cache_release(page);
-- 
1.7.6

