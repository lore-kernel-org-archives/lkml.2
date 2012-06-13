Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752230Ab2FMVEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 17:04:45 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:55149 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab2FMVEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 17:04:44 -0400
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] staging: zsmalloc: fix uninit'ed variable warning
Date: Wed, 13 Jun 2012 16:03:42 -0500
Message-Id: <1339621422-8449-1-git-send-email-sjenning@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061321-4242-0000-0000-000001F59E3C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes an uninitialized variable warning in
alloc_zspage().  It also fixes the secondary issue of
prev_page leaving scope on each loop iteration.  The only
reason this ever worked was because prev_page was occupying
the same space on the stack on each iteration.

Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 drivers/staging/zsmalloc/zsmalloc-main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
index fb54a9b..4af3dd6 100644
--- a/drivers/staging/zsmalloc/zsmalloc-main.c
+++ b/drivers/staging/zsmalloc/zsmalloc-main.c
@@ -400,7 +400,7 @@ static void init_zspage(struct page *first_page, struct size_class *class)
 static struct page *alloc_zspage(struct size_class *class, gfp_t flags)
 {
 	int i, error;
-	struct page *first_page = NULL;
+	struct page *first_page = NULL, *uninitialized_var(prev_page);
 
 	/*
 	 * Allocate individual pages and link them together as:
@@ -415,7 +415,7 @@ static struct page *alloc_zspage(struct size_class *class, gfp_t flags)
 	 */
 	error = -ENOMEM;
 	for (i = 0; i < class->pages_per_zspage; i++) {
-		struct page *page, *prev_page;
+		struct page *page;
 
 		page = alloc_page(flags);
 		if (!page)
-- 
1.7.9.5

