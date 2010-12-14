Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758714Ab0LNAot (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 19:44:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45961 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758169Ab0LNAor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 19:44:47 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=Xc_VhLn6XDUA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=omOdbC7AAAAA:8 a=Z4Rwk6OoAAAA:8 a=cH6R9-kdAAAA:8 a=meVymXHHAAAA:8 a=bNASkjVZqgrv3PAVTvsA:9 a=ZOHScQDoJ5dYCr9l0Z4A:7 a=v8EbydJsF-UCfLx_hT_xDPgQGzwA:4 a=jEp0ucaQiEUA:10 a=jbrJJM5MRmoA:10 a=bt0zGP92IBIA:10 a=jeBq3FmKZ4MA:10 a=hqJoNkY-jCO86FVd:21 a=gMocKCwLv-l6HF7u:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101214004445.969381951@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 13 Dec 2010 19:43:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Nick Piggin <npiggin@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: [PATCH 1/3] mm: Remove likely() from mapping_unevictable()
References: <20101214004347.996651495@goodmis.org>
Content-Disposition: inline; filename=0001-mm-Remove-likely-from-mapping_unevictable.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The mapping_unevictable() has a likely() around the mapping parameter.
This mapping parameter comes from page_mapping() which has an
unlikely() that the page will be set as PAGE_MAPPING_ANON, and if
so, it will return NULL. One would think that this unlikely() means
that the mapping returned by page_mapping() would not be NULL, but
where page_mapping() is used just above mapping_unevictable(), that
unlikely() is incorrect most of the time. This means that the
"likely(mapping)" in mapping_unevictable() is incorrect most of the
time.

Running the annotated branch profiler on my main box which runs firefox,
evolution, xchat and is part of my distcc farm, I had this:

 correct incorrect  %        Function                  File              Line
 ------- ---------  -        --------                  ----              ----
12872836 1269443893  98 mapping_unevictable            pagemap.h            51
35935762 1270265395  97 page_mapping                   mm.h                 659
1306198001   143659   0 page_mapping                   mm.h                 657
203131478   121586   0 page_mapping                   mm.h                 657
 5415491     1116   0 page_mapping                   mm.h                 657
74899487     1116   0 page_mapping                   mm.h                 657
203132845      224   0 page_mapping                   mm.h                 659
 5415464       27   0 page_mapping                   mm.h                 659
   13552        0   0 page_mapping                   mm.h                 657
   13552        0   0 page_mapping                   mm.h                 659
  242630        0   0 page_mapping                   mm.h                 657
  242630        0   0 page_mapping                   mm.h                 659
74899487        0   0 page_mapping                   mm.h                 659

The page_mapping() is a static inline, which is why it shows up multiple
times. The mapping_unevictable() is also a static inline but seems to
be used only once in my setup.

The unlikely in page_mapping() was correct a total of 1909540379 times and
incorrect 1270533123 times, with a 39% being incorrect. Perhaps this is
enough to remove the unlikely from page_mapping() as well.

Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Nick Piggin <npiggin@kernel.dk>
Acked-by: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/pagemap.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 2d1ffe3..9c66e99 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -48,7 +48,7 @@ static inline void mapping_clear_unevictable(struct address_space *mapping)
 
 static inline int mapping_unevictable(struct address_space *mapping)
 {
-	if (likely(mapping))
+	if (mapping)
 		return test_bit(AS_UNEVICTABLE, &mapping->flags);
 	return !!mapping;
 }
-- 
1.7.2.3


