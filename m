Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849Ab0LGCOG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 21:14:06 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48718 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab0LGCNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 21:13:31 -0500
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=4OWeZdFjri4A:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=Z4Rwk6OoAAAA:8 a=meVymXHHAAAA:8 a=esFTRVs0bCtYpAnA6rQA:9 a=7QirWHDLgzEXafWqIMK6rj5pesUA:4 a=jEp0ucaQiEUA:10 a=0kPLrQdw3YYA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101207021329.476854013@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 06 Dec 2010 20:58:39 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@suse.de>
Subject: [RFC][PATCH 05/10] mm: Remove likely() from grab_cache_page_write_begin()
References: <20101207015834.196176991@goodmis.org>
Content-Disposition: inline; filename=0005-mm-Remove-likely-from-grab_cache_page_write_begin.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Running the annotated branch profiler on a box doing average work
(firefox, evolution, xchat, distcc farm), the likely() used in
grab_cache_page_write_begin() was incorrect most of the time:

 correct incorrect  %        Function                  File              Line
 ------- ---------  -        --------                  ----              ----
 1924262 71332401  97 grab_cache_page_write_begin    filemap.c           2206

Adding a trace_printk() and running the function tracer limited to
just this function I can see:

        gconfd-2-2696  [000]  4467.268935: grab_cache_page_write_begin: page=          (null) mapping=ffff8800676a9460 index=7
        gconfd-2-2696  [000]  4467.268946: grab_cache_page_write_begin <-ext3_write_begin
        gconfd-2-2696  [000]  4467.268947: grab_cache_page_write_begin: page=          (null) mapping=ffff8800676a9460 index=8
        gconfd-2-2696  [000]  4467.268959: grab_cache_page_write_begin <-ext3_write_begin
        gconfd-2-2696  [000]  4467.268960: grab_cache_page_write_begin: page=          (null) mapping=ffff8800676a9460 index=9
        gconfd-2-2696  [000]  4467.268972: grab_cache_page_write_begin <-ext3_write_begin
        gconfd-2-2696  [000]  4467.268973: grab_cache_page_write_begin: page=          (null) mapping=ffff8800676a9460 index=10
        gconfd-2-2696  [000]  4467.268991: grab_cache_page_write_begin <-ext3_write_begin
        gconfd-2-2696  [000]  4467.268992: grab_cache_page_write_begin: page=          (null) mapping=ffff8800676a9460 index=11
        gconfd-2-2696  [000]  4467.269005: grab_cache_page_write_begin <-ext3_write_begin

Which shows that a lot of calls from ext3_write_begin will result in
the page returned by "find_lock_page" will be NULL.

Cc: Nick Piggin <npiggin@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 mm/filemap.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index ea89840..d557fe7 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2218,7 +2218,7 @@ struct page *grab_cache_page_write_begin(struct address_space *mapping,
 		gfp_notmask = __GFP_FS;
 repeat:
 	page = find_lock_page(mapping, index);
-	if (likely(page))
+	if (page)
 		return page;
 
 	page = __page_cache_alloc(mapping_gfp_mask(mapping) & ~gfp_notmask);
-- 
1.7.2.3


