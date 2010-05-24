Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758496Ab0EXWi0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 18:38:26 -0400
Received: from kroah.org ([198.145.64.141]:42378 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758284Ab0EXWiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 18:38:22 -0400
X-Mailbox-Line: From gregkh@clark.site Mon May 24 15:30:17 2010
Message-Id: <20100524223017.591023860@clark.site>
User-Agent: quilt/0.48-8.10
Date: Mon, 24 May 2010 15:28:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Wang Sheng-Hui <crosslonelyover@gmail.com>
Subject: [15/24] trace: Fix inappropriate substraction on tracing_pages_allocated in trace_free_page()
In-Reply-To: <20100524223544.GA13721@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Wang Sheng-Hui <crosslonelyover@gmail.com>

[No matching upstream git commit id as it was fixed differently due to a
rewrite of the tracing code there.]

For normal case, the code in trace_free_page() do once more substraction
on tracing_pages_allocated, but for CONFIG_TRACER_MAX_TRACE  it doesn't
take the freed page into account. That's not consistent with
trace_alloc_page().  Well, for there are no message related with this,
so we cannot observe its incorrect state when the kernel doesn't define
"CONFIG_TRACER_MAX_TRACE". If you add some pr_info() as
trace_alloc_page(), you may notice it.

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Wang Sheng-Hui <crosslonelyover@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/trace/trace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3018,7 +3018,6 @@ static int trace_free_page(void)
 		ClearPageLRU(page);
 		list_del(&page->lru);
 		tracing_pages_allocated--;
-		tracing_pages_allocated--;
 		__free_page(page);
 
 		tracing_reset(data);
@@ -3036,6 +3035,7 @@ static int trace_free_page(void)
 		page = list_entry(p, struct page, lru);
 		ClearPageLRU(page);
 		list_del(&page->lru);
+		tracing_pages_allocated--;
 		__free_page(page);
 
 		tracing_reset(data);


