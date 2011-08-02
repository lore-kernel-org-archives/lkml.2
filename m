Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904Ab1HBHU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 03:20:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35178 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751535Ab1HBHUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 03:20:21 -0400
Date: Tue, 2 Aug 2011 00:22:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Xiaotian Feng <xtfeng@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel <linux-kernel@vger.kernel.org>,
        mgorman@suse.de
Subject: Re: kernel BUG at mm/vmscan.c:1114
Message-Id: <20110802002226.3ff0b342.akpm@linux-foundation.org>
In-Reply-To: <CAJn8CcG-pNbg88+HLB=tRr26_R+A0RxZEWsJQg4iGe4eY2noXA@mail.gmail.com>
References: <CAJn8CcE20-co4xNOD8c+0jMeABrc1mjmGzju3xT34QwHHHFsUA@mail.gmail.com>
	<CAJn8CcG-pNbg88+HLB=tRr26_R+A0RxZEWsJQg4iGe4eY2noXA@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Aug 2011 15:09:57 +0800 Xiaotian Feng <xtfeng@gmail.com> wrote:

> __ __I'm hitting the kernel BUG at mm/vmscan.c:1114 twice, each time I
> was trying to build my kernel. The photo of crash screen and my config
> is attached.

hm, now why has that started happening?

Perhaps you could apply this debug patch, see if we can narrow it down?

--- a/mm/vmscan.c~a
+++ a/mm/vmscan.c
@@ -54,6 +54,8 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/vmscan.h>
 
+#define D() do { printk("%s:%d\n", __FILE__, __LINE__); } while (0)
+
 /*
  * reclaim_mode determines how the inactive list is shrunk
  * RECLAIM_MODE_SINGLE: Reclaim only order-0 pages
@@ -1018,27 +1020,37 @@ int __isolate_lru_page(struct page *page
 	int ret = -EINVAL;
 
 	/* Only take pages on the LRU. */
-	if (!PageLRU(page))
+	if (!PageLRU(page)) {
+		D();
 		return ret;
+	}
 
 	/*
 	 * When checking the active state, we need to be sure we are
 	 * dealing with comparible boolean values.  Take the logical not
 	 * of each.
 	 */
-	if (mode != ISOLATE_BOTH && (!PageActive(page) != !mode))
+	if (mode != ISOLATE_BOTH && (!PageActive(page) != !mode)) {
+		printk("mode:%d\n", mode);
+		D();
 		return ret;
+	}
 
-	if (mode != ISOLATE_BOTH && page_is_file_cache(page) != file)
+	if (mode != ISOLATE_BOTH && page_is_file_cache(page) != file) {
+		printk("mode: %d, pifc: %d, file: %d\n", mode,
+					page_is_file_cache(page), file);
+		D();
 		return ret;
-
+	}
 	/*
 	 * When this function is being called for lumpy reclaim, we
 	 * initially look into all LRU pages, active, inactive and
 	 * unevictable; only give shrink_page_list evictable pages.
 	 */
-	if (PageUnevictable(page))
+	if (PageUnevictable(page)) {
+		D();
 		return ret;
+	}
 
 	ret = -EBUSY;
 
_

