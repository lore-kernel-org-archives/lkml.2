Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566Ab0LGCYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 21:24:13 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64894 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023Ab0LGCYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 21:24:12 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=aH0YrG8yK9sA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=Z4Rwk6OoAAAA:8 a=meVymXHHAAAA:8 a=w9w-REy3VHsbP2wsAPAA:9 a=rQHBK-qtTidJUTk75ZOSAKBNyzcA:4 a=PUjeQqilurYA:10 a=TZKiN4vec_IA:10 a=jEp0ucaQiEUA:10 a=jbrJJM5MRmoA:10 a=jeBq3FmKZ4MA:10 a=mVSS6hngvTFlF1_x:21 a=h-yt-G3dzGjxQ2YR:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 05/10] mm: Remove likely() from
 grab_cache_page_write_begin()
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>
In-Reply-To: <20101207021329.476854013@goodmis.org>
References: <20101207015834.196176991@goodmis.org>
	 <20101207021329.476854013@goodmis.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 06 Dec 2010 21:24:10 -0500
Message-ID: <1291688650.16223.124.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Resending to Nick's real email address ]

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

Cc: Nick Piggin <npiggin@kernel.dk>
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


