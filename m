Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756168Ab1CBIij (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 03:38:39 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:65510 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755903Ab1CBIih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 03:38:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer:in-reply-to:references;
        b=SqfU/rBFLrUWBjjSg+nDu2KKXbwTZQ754KVTgtZ9kj+Q6Xj6SxQKaKm7C6fX6HzQzp
         5kZI3OiAqp8hYKhOMf2mSRD0rqC6i6Sx5pLXFpIiklsABBuQFTUCS8gSKEcgdSAIEfcR
         zKiItCNToVXbEuMPgOlF/S2XGrTqS18ENsOjQ=
From: Liu Yuan <namei.unix@gmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, jaxboe@fusionio.com,
        akpm@linux-foundation.org, fengguang.wu@intel.com
Subject: [RFC PATCH 5/5] mm: Add readpages accounting
Date: Wed,  2 Mar 2011 16:38:10 +0800
Message-Id: <1299055090-23976-5-git-send-email-namei.unix@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <no>
References: <no>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Yuan <tailai.ly@taobao.com>

The _readpages_ counter simply counts how many pages the kernel
really request from the disk, either by readahead module or
aop->readpage() when readahead window equals 0.

This counter is request-centric and doesnot check read errors
since the read requests are issued to the block layer already.

Signed-off-by: Liu Yuan <tailai.ly@taobao.com>
---
 mm/filemap.c   |    1 +
 mm/readahead.c |    2 ++
 2 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 5388b2a..d638391 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1137,6 +1137,7 @@ readpage:
 		 */
 		ClearPageError(page);
 		/* Start the actual read. The read will unlock the page. */
+		page_cache_acct_readpages(mapping->host->i_sb, 1);
 		error = mapping->a_ops->readpage(filp, page);
 
 		if (unlikely(error)) {
diff --git a/mm/readahead.c b/mm/readahead.c
index 77506a2..483acb8 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -112,6 +112,8 @@ static int read_pages(struct address_space *mapping, struct file *filp,
 	unsigned page_idx;
 	int ret;
 
+	page_cache_acct_readpages(mapping->host->i_sb, nr_pages);
+
 	if (mapping->a_ops->readpages) {
 		ret = mapping->a_ops->readpages(filp, mapping, pages, nr_pages);
 		/* Clean up the remaining pages */
-- 
1.7.0.4

