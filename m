Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506Ab1HZADH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 20:03:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42214 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752188Ab1HZADE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 20:03:04 -0400
Date: Thu, 25 Aug 2011 17:03:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH -v2] debug-pagealloc: add support for highmem pages
Message-Id: <20110825170302.81ed210c.akpm@linux-foundation.org>
In-Reply-To: <1314281649-21508-1-git-send-email-akinobu.mita@gmail.com>
References: <1314281649-21508-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Aug 2011 23:14:09 +0900
Akinobu Mita <akinobu.mita@gmail.com> wrote:

> This adds support for highmem pages poisoning and verification to the
> debug-pagealloc feature for no-architecture support.
> 

Sorry, I had a brainfart.  kmap_atomic() internally does the
preempt_disable() (actually pagefault_disable()).

--- a/mm/debug-pagealloc.c~debug-pagealloc-add-support-for-highmem-pages-fix
+++ a/mm/debug-pagealloc.c
@@ -23,14 +23,11 @@ static inline bool page_poison(struct pa
 
 static void poison_page(struct page *page)
 {
-	void *addr;
+	void *addr = kmap_atomic(page);
 
-	preempt_disable();
-	addr = kmap_atomic(page);
 	set_page_poison(page);
 	memset(addr, PAGE_POISON, PAGE_SIZE);
 	kunmap_atomic(addr);
-	preempt_enable();
 }
 
 static void poison_pages(struct page *page, int n)
@@ -82,12 +79,10 @@ static void unpoison_page(struct page *p
 	if (!page_poison(page))
 		return;
 
-	preempt_disable();
 	addr = kmap_atomic(page);
 	check_poison_mem(addr, PAGE_SIZE);
 	clear_page_poison(page);
 	kunmap_atomic(addr);
-	preempt_enable();
 }
 
 static void unpoison_pages(struct page *page, int n)
_

