Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758749Ab0LNApc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 19:45:32 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62672 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758171Ab0LNAor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 19:44:47 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=wb1bTaglDM8A:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=omOdbC7AAAAA:8 a=Z4Rwk6OoAAAA:8 a=cH6R9-kdAAAA:8 a=meVymXHHAAAA:8 a=UJbBCv4JZKF3S0SSkg4A:9 a=KzDMi6IgfJOiP8Po_-MmncSJljwA:4 a=jEp0ucaQiEUA:10 a=jbrJJM5MRmoA:10 a=bt0zGP92IBIA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101214004446.291657413@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 13 Dec 2010 19:43:50 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Nick Piggin <npiggin@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: [PATCH 2/3] mm: Remove unlikely() from page_mapping()
References: <20101214004347.996651495@goodmis.org>
Content-Disposition: inline; filename=0002-mm-Remove-unlikely-from-page_mapping.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

page_mapping() has a unlikely that the mapping has PAGE_MAPPING_ANON
set. But running the annotated branch profiler on a normal desktop
system doing vairous tasks (xchat, evolution, firefox, distcc),
it is not really that unlikely that the mapping here will have the
PAGE_MAPPING_ANON flag set:

 correct incorrect  %        Function                  File              Line
 ------- ---------  -        --------                  ----              ----
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
times.

The unlikely in page_mapping() was correct a total of 1909540379 times and
incorrect 1270533123 times, with a 39% being incorrect. With this much of an
error, it's best to simply remove the unlikely and have the compiler and
branch prediction figure this out.

Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/mm.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 721f451..b064264 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -657,7 +657,7 @@ static inline struct address_space *page_mapping(struct page *page)
 	VM_BUG_ON(PageSlab(page));
 	if (unlikely(PageSwapCache(page)))
 		mapping = &swapper_space;
-	else if (unlikely((unsigned long)mapping & PAGE_MAPPING_ANON))
+	else if ((unsigned long)mapping & PAGE_MAPPING_ANON)
 		mapping = NULL;
 	return mapping;
 }
-- 
1.7.2.3


