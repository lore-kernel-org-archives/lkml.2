Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757421Ab1KJXnD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 18:43:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60618 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214Ab1KJXnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 18:43:01 -0500
Date: Thu, 10 Nov 2011 15:42:59 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, minchan.kim@gmail.com
Subject: Re: [PATCH v2] mm: add free_hot_cold_page_list helper
Message-Id: <20111110154259.261f1534.akpm@linux-foundation.org>
In-Reply-To: <20111101074502.32668.93131.stgit@zurg>
References: <20110729075837.12274.58405.stgit@localhost6>
	<20111101074502.32668.93131.stgit@zurg>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 01 Nov 2011 11:45:02 +0300
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> This patch adds helper free_hot_cold_page_list() to free list of 0-order pages.
> It frees pages directly from the list without temporary page-vector.
> It also calls trace_mm_pagevec_free() to simulate pagevec_free() behaviour.
> 
> bloat-o-meter:
> 
> add/remove: 1/1 grow/shrink: 1/3 up/down: 267/-295 (-28)
> function                                     old     new   delta
> free_hot_cold_page_list                        -     264    +264
> get_page_from_freelist                      2129    2132      +3
> __pagevec_free                               243     239      -4
> split_free_page                              380     373      -7
> release_pages                                606     510     -96
> free_page_list                               188       -    -188

Here's what you changed:

--- a/mm/page_alloc.c~mm-add-free_hot_cold_page_list-helper-v2
+++ a/mm/page_alloc.c
@@ -1210,6 +1210,9 @@ out:
 	local_irq_restore(flags);
 }
 
+/*
+ * Free a list of 0-order pages
+ */
 void free_hot_cold_page_list(struct list_head *list, int cold)
 {
 	struct page *page, *next;
@@ -1218,8 +1221,6 @@ void free_hot_cold_page_list(struct list
 		trace_mm_pagevec_free(page, cold);
 		free_hot_cold_page(page, cold);
 	}
-
-	INIT_LIST_HEAD(list);
 }
 
 /*
_

However I can't find any sign that you addressed Minchin's original
review comment regarding free_hot_cold_page_list():

: I understand you want to minimize changes without breaking current ABI
: with trace tools.
: But apparently, It's not a pagvec_free. It just hurts readability.
: As I take a look at the code, mm_pagevec_free isn't related to pagevec
: but I guess it can represent 0-order pages free because 0-order pages
: are freed only by pagevec until now.
: So, how about renaming it with mm_page_free or mm_page_free_zero_order?
: If you do, you need to do s/MM_PAGEVEC_FREE/MM_FREE_FREE/g in
: trace-pagealloc-postprocess.pl.

