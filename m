Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243Ab2ITWD6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 18:03:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19048 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790Ab2ITWD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 18:03:56 -0400
X-Authority-Analysis: v=2.0 cv=C49rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=mDYbXTAqAuEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=csqk5SOtqX8A:10 a=VwQbUJbxAAAA:8 a=omOdbC7AAAAA:8 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=Z4Rwk6OoAAAA:8 a=L5JWO0G1mFL6_1CW1c0A:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=jbrJJM5MRmoA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1348178633.13080.69.camel@gandalf.local.home>
Subject: [PATCH][GIT PULL][v3.6] tracing: Don't call page_to_pfn() if page
 is NULL
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan@kernel.org>
Date: Thu, 20 Sep 2012 18:03:53 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

I wrote a test that triggers the bug, and tested this patch which seems
to fix it as well.

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
tip/perf/urgent

Head SHA1: 85f2a2ef1d0ab99523e0b947a2b723f5650ed6aa


Wen Congyang (1):
      tracing: Don't call page_to_pfn() if page is NULL

----
 include/trace/events/kmem.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
---------------------------
commit 85f2a2ef1d0ab99523e0b947a2b723f5650ed6aa
Author: Wen Congyang <wency@cn.fujitsu.com>
Date:   Thu Sep 20 14:04:47 2012 +0800

    tracing: Don't call page_to_pfn() if page is NULL
    
    When allocating memory fails, page is NULL. page_to_pfn() will
    cause the kernel panicked if we don't use sparsemem vmemmap.
    
    Link: http://lkml.kernel.org/r/505AB1FF.8020104@cn.fujitsu.com
    
    Cc: Frederic Weisbecker <fweisbec@gmail.com>
    Cc: Ingo Molnar <mingo@redhat.com>
    Cc: Andrew Morton <akpm@linux-foundation.org>
    Cc: stable <stable@vger.kernel.org>
    Acked-by: Mel Gorman <mel@csn.ul.ie>
    Reviewed-by: Minchan Kim <minchan@kernel.org>
    Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
index 5f889f1..08fa272 100644
--- a/include/trace/events/kmem.h
+++ b/include/trace/events/kmem.h
@@ -214,7 +214,7 @@ TRACE_EVENT(mm_page_alloc,
 
 	TP_printk("page=%p pfn=%lu order=%d migratetype=%d gfp_flags=%s",
 		__entry->page,
-		page_to_pfn(__entry->page),
+		__entry->page ? page_to_pfn(__entry->page) : 0,
 		__entry->order,
 		__entry->migratetype,
 		show_gfp_flags(__entry->gfp_flags))
@@ -240,7 +240,7 @@ DECLARE_EVENT_CLASS(mm_page,
 
 	TP_printk("page=%p pfn=%lu order=%u migratetype=%d percpu_refill=%d",
 		__entry->page,
-		page_to_pfn(__entry->page),
+		__entry->page ? page_to_pfn(__entry->page) : 0,
 		__entry->order,
 		__entry->migratetype,
 		__entry->order == 0)


