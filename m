Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab0GZIZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 04:25:49 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:56422 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab0GZIZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 04:25:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=LJYpipwfQjkTGnYSSi+eQR6IEZxbjhI4mAr0Ox6kz/AWyUcXs4/1oK4qklLXTg+4UJ
         zrbR5LLZ4SpMHyjGlB7kDgH/eMThW+8qoQdDj/9VmV2e52Kj4VEZ8jQiDnsrp3uUlIlS
         4k/Gzk9WnWMv3zhSzOGKAYMbFU2qcNR3SrnTw=
Date: Mon, 26 Jul 2010 16:25:42 +0800
From: wzt.wzt@gmail.com
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, akpm@linux-foundation.org
Subject: [PATCH] mm: Check NULL pointer Dereference in mm/filemap.c
Message-ID: <20100726082542.GA2646@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mapping->a_ops->direct_IO() is not checked, if it's a NULL pointer, 
that will casue an oops. pagecache_write_begin/end is exported to
other functions, so they need to check null pointer before use them. 

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 mm/filemap.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 20e5642..e81e264 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1300,6 +1300,9 @@ generic_file_aio_read(struct kiocb *iocb, const struct iovec *iov,
 			retval = filemap_write_and_wait_range(mapping, pos,
 					pos + iov_length(iov, nr_segs) - 1);
 			if (!retval) {
+				if (unlikely(!mapping->a_ops ||
+					!mapping->a_ops->direct_IO))
+					goto out;
 				retval = mapping->a_ops->direct_IO(READ, iocb,
 							iov, pos, nr_segs);
 			}
@@ -1581,6 +1584,8 @@ retry_find:
 	return ret | VM_FAULT_LOCKED;
 
 no_cached_page:
+	if (unlikely(!mapping->a_ops || !mapping->a_ops->readpage))
+		return VM_FAULT_SIGBUS;
 	/*
 	 * We're only likely to ever get here if MADV_RANDOM is in
 	 * effect.
@@ -2103,6 +2108,8 @@ int pagecache_write_begin(struct file *file, struct address_space *mapping,
 {
 	const struct address_space_operations *aops = mapping->a_ops;
 
+	if (unlikely(!aops || !aops->write_begin))
+		return -EINVAL;
 	return aops->write_begin(file, mapping, pos, len, flags,
 							pagep, fsdata);
 }
@@ -2114,6 +2121,9 @@ int pagecache_write_end(struct file *file, struct address_space *mapping,
 {
 	const struct address_space_operations *aops = mapping->a_ops;
 
+	if (unlikely(!aops || !aops->write_end))
+		return -EINVAL;
+
 	mark_page_accessed(page);
 	return aops->write_end(file, mapping, pos, len, copied, page, fsdata);
 }
@@ -2161,6 +2171,9 @@ generic_file_direct_write(struct kiocb *iocb, const struct iovec *iov,
 		}
 	}
 
+	if (unlikely(!mapping->a_ops || !mapping->a_ops->direct_IO))
+		goto out;
+
 	written = mapping->a_ops->direct_IO(WRITE, iocb, iov, pos, *nr_segs);
 
 	/*
-- 
1.6.5.3

